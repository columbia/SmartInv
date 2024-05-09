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
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be aplied to your functions to restrict their use to
117  * the owner.
118  */
119 contract Ownable {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor () internal {
128         _owner = msg.sender;
129         emit OwnershipTransferred(address(0), _owner);
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(isOwner(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Returns true if the caller is the current owner.
149      */
150     function isOwner() public view returns (bool) {
151         return msg.sender == _owner;
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * > Note: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public onlyOwner {
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      */
177     function _transferOwnership(address newOwner) internal {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see `ERC20Detailed`.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a `Transfer` event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through `transferFrom`. This is
211      * zero by default.
212      *
213      * This value changes when `approve` or `transferFrom` are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * > Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an `Approval` event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a `Transfer` event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to `approve`. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Implementation of the `IERC20` interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using `_mint`.
264  * For a generic mechanism see `ERC20Mintable`.
265  *
266  * *For a detailed writeup see our guide [How to implement supply
267  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
268  *
269  * We have followed general OpenZeppelin guidelines: functions revert instead
270  * of returning `false` on failure. This behavior is nonetheless conventional
271  * and does not conflict with the expectations of ERC20 applications.
272  *
273  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
274  * This allows applications to reconstruct the allowance for all accounts just
275  * by listening to said events. Other implementations of the EIP may not emit
276  * these events, as it isn't required by the specification.
277  *
278  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
279  * functions have been added to mitigate the well-known issues around setting
280  * allowances. See `IERC20.approve`.
281  */
282 contract ERC20 is IERC20, Ownable{
283     using SafeMath for uint256;
284 
285     mapping (address => uint256) internal _balances;
286 
287     mapping (address => mapping (address => uint256)) internal _allowances;
288 
289     uint256 internal _totalSupply;
290 
291     /**
292      * @dev See `IERC20.totalSupply`.
293      */
294     function totalSupply() public view returns (uint256) {
295         return _totalSupply;
296     }
297 
298     /**
299      * @dev See `IERC20.balanceOf`.
300      */
301     function balanceOf(address account) public view returns (uint256) {
302         return _balances[account];
303     }
304 
305     /**
306      * @dev See `IERC20.transfer`.
307      *
308      * Requirements:
309      *
310      * - `recipient` cannot be the zero address.
311      * - the caller must have a balance of at least `amount`.
312      */
313     function transfer(address recipient, uint256 amount) public returns (bool) {
314         _transfer(msg.sender, recipient, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See `IERC20.allowance`.
320      */
321     function allowance(address owner, address spender) public view returns (uint256) {
322         return _allowances[owner][spender];
323     }
324 
325     /**
326      * @dev See `IERC20.approve`.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function approve(address spender, uint256 value) public returns (bool) {
333         _approve(msg.sender, spender, value);
334         return true;
335     }
336 
337     /**
338      * @dev See `IERC20.transferFrom`.
339      *
340      * Emits an `Approval` event indicating the updated allowance. This is not
341      * required by the EIP. See the note at the beginning of `ERC20`;
342      *
343      * Requirements:
344      * - `sender` and `recipient` cannot be the zero address.
345      * - `sender` must have a balance of at least `value`.
346      * - the caller must have allowance for `sender`'s tokens of at least
347      * `amount`.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
352         return true;
353     }
354 
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to `approve` that can be used as a mitigation for
359      * problems described in `IERC20.approve`.
360      *
361      * Emits an `Approval` event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
368         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to `approve` that can be used as a mitigation for
376      * problems described in `IERC20.approve`.
377      *
378      * Emits an `Approval` event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
387         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
388         return true;
389     }
390 
391     /**
392      * @dev Moves tokens `amount` from `sender` to `recipient`.
393      *
394      * This is internal function is equivalent to `transfer`, and can be used to
395      * e.g. implement automatic token fees, slashing mechanisms, etc.
396      *
397      * Emits a `Transfer` event.
398      *
399      * Requirements:
400      *
401      * - `sender` cannot be the zero address.
402      * - `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      */
405     function _transfer(address sender, address recipient, uint256 amount) internal {
406         require(sender != address(0), "ERC20: transfer from the zero address");
407         require(recipient != address(0), "ERC20: transfer to the zero address");
408 
409         _balances[sender] = _balances[sender].sub(amount);
410         _balances[recipient] = _balances[recipient].add(amount);
411         emit Transfer(sender, recipient, amount);
412     }
413 
414     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
415      * the total supply.
416      *
417      * Emits a `Transfer` event with `from` set to the zero address.
418      *
419      * Requirements
420      *
421      * - `to` cannot be the zero address.
422      */
423     function _mint(address account, uint256 amount) internal {
424         require(account != address(0), "ERC20: mint to the zero address");
425 
426         _totalSupply = _totalSupply.add(amount);
427         _balances[account] = _balances[account].add(amount);
428         emit Transfer(address(0), account, amount);
429     }
430 
431      /**
432      * @dev Destoys `amount` tokens from `account`, reducing the
433      * total supply.
434      *
435      * Emits a `Transfer` event with `to` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `account` cannot be the zero address.
440      * - `account` must have at least `amount` tokens.
441      */
442     function _burn(address account, uint256 value) internal {
443         require(account != address(0), "ERC20: burn from the zero address");
444 
445         _totalSupply = _totalSupply.sub(value);
446         _balances[account] = _balances[account].sub(value);
447         emit Transfer(account, address(0), value);
448     }
449 
450     /**
451      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
452      *
453      * This is internal function is equivalent to `approve`, and can be used to
454      * e.g. set automatic allowances for certain subsystems, etc.
455      *
456      * Emits an `Approval` event.
457      *
458      * Requirements:
459      *
460      * - `owner` cannot be the zero address.
461      * - `spender` cannot be the zero address.
462      */
463     function _approve(address owner, address spender, uint256 value) internal {
464         require(owner != address(0), "ERC20: approve from the zero address");
465         require(spender != address(0), "ERC20: approve to the zero address");
466 
467         _allowances[owner][spender] = value;
468         emit Approval(owner, spender, value);
469     }
470 
471     /**
472      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
473      * from the caller's allowance.
474      *
475      * See `_burn` and `_approve`.
476      */
477     function _burnFrom(address account, uint256 amount) internal {
478         _burn(account, amount);
479         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
480     }
481 }
482 
483 /**
484  * @dev Extension of `ERC20` that allows token holders to destroy both their own
485  * tokens and those that they have an allowance for, in a way that can be
486  * recognized off-chain (via event analysis).
487  */
488 contract ERC20Burnable is ERC20 {
489     /**
490      * @dev Destoys `amount` tokens from the caller.
491      *
492      * See `ERC20._burn`.
493      */
494     function burn(uint256 amount) public onlyOwner {
495         _burn(msg.sender, amount);
496     }
497 
498     /**
499      * @dev See `ERC20._burnFrom`.
500      */
501     function burnFrom(address account, uint256 amount) public {
502         _burnFrom(account, amount);
503     }
504 }
505 
506 /**
507  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
508  * which have permission to mint (create) new tokens as they see fit.
509  *
510  * At construction, the deployer of the contract is the only minter.
511  */
512 contract ERC20Mintable is ERC20 {
513     /**
514      * @dev See `ERC20._mint`.
515      *
516      * Requirements:
517      *
518      * - the caller must have the `MinterRole`.
519      */
520     function mint(address account, uint256 amount) public onlyOwner returns (bool) {
521         _mint(account, amount);
522         return true;
523     }
524 }
525 
526 /**
527  * @dev Spyce Token implementation.
528  */
529 contract SpyceToken is  ERC20Burnable, ERC20Mintable {
530     using SafeMath for uint256;
531 
532     string public constant name = "SPYCE";
533     string public constant symbol = "SPYCE";
534     uint8 public constant decimals = 18;
535 
536     uint256 internal constant INITIAL_SUPPLY = 2 * (10**6) * (10 ** uint256(decimals)); // 2 millions tokens (first release)
537 
538     /**
539     * @dev Constructor that gives msg.sender all of existing tokens.
540     */
541     constructor() public {
542         _totalSupply = INITIAL_SUPPLY;
543         _balances[msg.sender] = INITIAL_SUPPLY;
544         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
545     }
546 }