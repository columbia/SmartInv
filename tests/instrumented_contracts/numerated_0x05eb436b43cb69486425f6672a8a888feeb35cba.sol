1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be aplied to your functions to restrict their use to
116  * the owner.
117  */
118 contract Ownable {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor () internal {
127         _owner = msg.sender;
128         emit OwnershipTransferred(address(0), _owner);
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(isOwner(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     /**
147      * @dev Returns true if the caller is the current owner.
148      */
149     function isOwner() public view returns (bool) {
150         return msg.sender == _owner;
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * > Note: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public onlyOwner {
161         _owner = address(0);
162         emit OwnershipTransferred(_owner, address(0));
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public onlyOwner {
170         _transferOwnership(newOwner);
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      */
176     function _transferOwnership(address newOwner) internal {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _owner = newOwner;
179         emit OwnershipTransferred(_owner, newOwner);
180     }
181 }
182 
183 /**
184  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
185  * the optional functions; to access them see `ERC20Detailed`.
186  */
187 interface IERC20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `recipient`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a `Transfer` event.
204      */
205     function transfer(address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through `transferFrom`. This is
210      * zero by default.
211      *
212      * This value changes when `approve` or `transferFrom` are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * > Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an `Approval` event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `sender` to `recipient` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a `Transfer` event.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to `approve`. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 /**
259  * @dev Implementation of the `IERC20` interface.
260  *
261  * This implementation is agnostic to the way tokens are created. This means
262  * that a supply mechanism has to be added in a derived contract using `_mint`.
263  * For a generic mechanism see `ERC20Mintable`.
264  *
265  * *For a detailed writeup see our guide [How to implement supply
266  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
267  *
268  * We have followed general OpenZeppelin guidelines: functions revert instead
269  * of returning `false` on failure. This behavior is nonetheless conventional
270  * and does not conflict with the expectations of ERC20 applications.
271  *
272  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See `IERC20.approve`.
280  */
281 contract ERC20 is IERC20 {
282     using SafeMath for uint256;
283 
284     mapping (address => uint256) private _balances;
285 
286     mapping (address => mapping (address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     /**
291      * @dev See `IERC20.totalSupply`.
292      */
293     function totalSupply() public view returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See `IERC20.balanceOf`.
299      */
300     function balanceOf(address account) public view returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See `IERC20.transfer`.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public returns (bool) {
313         _transfer(msg.sender, recipient, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See `IERC20.allowance`.
319      */
320     function allowance(address owner, address spender) public view returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See `IERC20.approve`.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 value) public returns (bool) {
332         _approve(msg.sender, spender, value);
333         return true;
334     }
335 
336     /**
337      * @dev See `IERC20.transferFrom`.
338      *
339      * Emits an `Approval` event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of `ERC20`;
341      *
342      * Requirements:
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `value`.
345      * - the caller must have allowance for `sender`'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
349         _transfer(sender, recipient, amount);
350         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to `approve` that can be used as a mitigation for
358      * problems described in `IERC20.approve`.
359      *
360      * Emits an `Approval` event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
367         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically decreases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to `approve` that can be used as a mitigation for
375      * problems described in `IERC20.approve`.
376      *
377      * Emits an `Approval` event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      * - `spender` must have allowance for the caller of at least
383      * `subtractedValue`.
384      */
385     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
386         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Moves tokens `amount` from `sender` to `recipient`.
392      *
393      * This is internal function is equivalent to `transfer`, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a `Transfer` event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(address sender, address recipient, uint256 amount) internal {
405         require(sender != address(0), "ERC20: transfer from the zero address");
406         require(recipient != address(0), "ERC20: transfer to the zero address");
407 
408         _balances[sender] = _balances[sender].sub(amount);
409         _balances[recipient] = _balances[recipient].add(amount);
410         emit Transfer(sender, recipient, amount);
411     }
412 
413     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
414      * the total supply.
415      *
416      * Emits a `Transfer` event with `from` set to the zero address.
417      *
418      * Requirements
419      *
420      * - `to` cannot be the zero address.
421      */
422     function _mint(address account, uint256 amount) internal {
423         require(account != address(0), "ERC20: mint to the zero address");
424 
425         _totalSupply = _totalSupply.add(amount);
426         _balances[account] = _balances[account].add(amount);
427         emit Transfer(address(0), account, amount);
428     }
429 
430      /**
431      * @dev Destoys `amount` tokens from `account`, reducing the
432      * total supply.
433      *
434      * Emits a `Transfer` event with `to` set to the zero address.
435      *
436      * Requirements
437      *
438      * - `account` cannot be the zero address.
439      * - `account` must have at least `amount` tokens.
440      */
441     function _burn(address account, uint256 value) internal {
442         require(account != address(0), "ERC20: burn from the zero address");
443 
444         _totalSupply = _totalSupply.sub(value);
445         _balances[account] = _balances[account].sub(value);
446         emit Transfer(account, address(0), value);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
451      *
452      * This is internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an `Approval` event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(address owner, address spender, uint256 value) internal {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = value;
467         emit Approval(owner, spender, value);
468     }
469 
470     /**
471      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
472      * from the caller's allowance.
473      *
474      * See `_burn` and `_approve`.
475      */
476     function _burnFrom(address account, uint256 amount) internal {
477         _burn(account, amount);
478         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
479     }
480 }
481 
482 /**
483  * @dev Contract module which allows children to implement an emergency stop
484  * mechanism that can be triggered by an authorized account.
485  *
486  * This module is used through inheritance. It will make available the
487  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
488  * the functions of your contract. Note that they will not be pausable by
489  * simply including this module, only once the modifiers are put in place.
490  */
491 contract Pausable is Ownable {
492     /**
493      * @dev Emitted when the pause is triggered by a pauser (`account`).
494      */
495     event Paused(address account);
496 
497     /**
498      * @dev Emitted when the pause is lifted by a pauser (`account`).
499      */
500     event Unpaused(address account);
501 
502     bool private _paused;
503 
504     /**
505      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
506      * to the deployer.
507      */
508     constructor () internal {
509         _paused = false;
510     }
511 
512     /**
513      * @dev Returns true if the contract is paused, and false otherwise.
514      */
515     function paused() public view returns (bool) {
516         return _paused;
517     }
518 
519     /**
520      * @dev Modifier to make a function callable only when the contract is not paused.
521      */
522     modifier whenNotPaused() {
523         require(!_paused, "Pausable: paused");
524         _;
525     }
526 
527     /**
528      * @dev Modifier to make a function callable only when the contract is paused.
529      */
530     modifier whenPaused() {
531         require(_paused, "Pausable: not paused");
532         _;
533     }
534 
535     /**
536      * @dev Called by a pauser to pause, triggers stopped state.
537      */
538     function pause() public onlyOwner whenNotPaused {
539         _paused = true;
540         emit Paused(msg.sender);
541     }
542 
543     /**
544      * @dev Called by a pauser to unpause, returns to normal state.
545      */
546     function unpause() public onlyOwner whenPaused {
547         _paused = false;
548         emit Unpaused(msg.sender);
549     }
550 }
551 
552 contract FirstCNY is ERC20, Pausable {
553     string private _name;
554     string private _symbol;
555     uint8 private _decimals;
556 
557     constructor (string memory name, string memory symbol, uint8 decimals, uint256 initialSupply) public {
558         _name = name;
559         _symbol = symbol;
560         _decimals = decimals;
561 
562         _mint(msg.sender, initialSupply);
563     }
564 
565     function name() public view returns (string memory) {
566         return _name;
567     }
568 
569     function symbol() public view returns (string memory) {
570         return _symbol;
571     }
572 
573     function decimals() public view returns (uint8) {
574         return _decimals;
575     }
576 
577     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
578         return super.transfer(recipient, amount);
579     }
580 
581     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
582         return super.transferFrom(sender, recipient, amount);
583     }
584 
585     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
586         return super.approve(spender, value);
587     }
588 
589     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
590         return super.increaseAllowance(spender, addedValue);
591     }
592 
593     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
594         return super.decreaseAllowance(spender, subtractedValue);
595     }
596 
597     function mint(address account, uint256 amount) public onlyOwner returns (bool) {
598         _mint(account, amount);
599         return true;
600     }
601 
602     function burn(address account, uint256 amount) public onlyOwner returns (bool) {
603         _burn(account, amount);
604         return true;
605     }
606 
607     function burnFrom(address account, uint256 amount) public whenNotPaused returns (bool) {
608         _burnFrom(account, amount);
609         return true;
610     }
611 }