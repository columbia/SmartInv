1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
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
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
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
59      * Emits a `Transfer` event.
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
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a, "SafeMath: subtraction overflow");
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, "SafeMath: division by zero");
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b != 0, "SafeMath: modulo by zero");
182         return a % b;
183     }
184 }
185 
186 
187 /**
188  * @dev Implementation of the `IERC20` interface.
189  *
190  * This implementation is agnostic to the way tokens are created. This means
191  * that a supply mechanism has to be added in a derived contract using `_mint`.
192  * For a generic mechanism see `ERC20Mintable`.
193  *
194  * *For a detailed writeup see our guide [How to implement supply
195  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
196  *
197  * We have followed general OpenZeppelin guidelines: functions revert instead
198  * of returning `false` on failure. This behavior is nonetheless conventional
199  * and does not conflict with the expectations of ERC20 applications.
200  *
201  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
202  * This allows applications to reconstruct the allowance for all accounts just
203  * by listening to said events. Other implementations of the EIP may not emit
204  * these events, as it isn't required by the specification.
205  *
206  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
207  * functions have been added to mitigate the well-known issues around setting
208  * allowances. See `IERC20.approve`.
209  */
210 contract ERC20 is IERC20 {
211     using SafeMath for uint256;
212 
213     mapping (address => uint256) private _balances;
214 
215     mapping (address => mapping (address => uint256)) private _allowances;
216 
217     uint256 private _totalSupply;
218 
219     /**
220      * @dev See `IERC20.totalSupply`.
221      */
222     function totalSupply() public view returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev See `IERC20.balanceOf`.
228      */
229     function balanceOf(address account) public view returns (uint256) {
230         return _balances[account];
231     }
232 
233     /**
234      * @dev See `IERC20.transfer`.
235      *
236      * Requirements:
237      *
238      * - `recipient` cannot be the zero address.
239      * - the caller must have a balance of at least `amount`.
240      */
241     function transfer(address recipient, uint256 amount) public returns (bool) {
242         _transfer(msg.sender, recipient, amount);
243         return true;
244     }
245 
246     /**
247      * @dev See `IERC20.allowance`.
248      */
249     function allowance(address owner, address spender) public view returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     /**
254      * @dev See `IERC20.approve`.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         _approve(msg.sender, spender, value);
262         return true;
263     }
264 
265     /**
266      * @dev See `IERC20.transferFrom`.
267      *
268      * Emits an `Approval` event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of `ERC20`;
270      *
271      * Requirements:
272      * - `sender` and `recipient` cannot be the zero address.
273      * - `sender` must have a balance of at least `value`.
274      * - the caller must have allowance for `sender`'s tokens of at least
275      * `amount`.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
278         _transfer(sender, recipient, amount);
279         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
280         return true;
281     }
282 
283     /**
284      * @dev Atomically increases the allowance granted to `spender` by the caller.
285      *
286      * This is an alternative to `approve` that can be used as a mitigation for
287      * problems described in `IERC20.approve`.
288      *
289      * Emits an `Approval` event indicating the updated allowance.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
296         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
297         return true;
298     }
299 
300     /**
301      * @dev Atomically decreases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to `approve` that can be used as a mitigation for
304      * problems described in `IERC20.approve`.
305      *
306      * Emits an `Approval` event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      * - `spender` must have allowance for the caller of at least
312      * `subtractedValue`.
313      */
314     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
315         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
316         return true;
317     }
318 
319     /**
320      * @dev Moves tokens `amount` from `sender` to `recipient`.
321      *
322      * This is internal function is equivalent to `transfer`, and can be used to
323      * e.g. implement automatic token fees, slashing mechanisms, etc.
324      *
325      * Emits a `Transfer` event.
326      *
327      * Requirements:
328      *
329      * - `sender` cannot be the zero address.
330      * - `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      */
333     function _transfer(address sender, address recipient, uint256 amount) internal {
334         require(sender != address(0), "ERC20: transfer from the zero address");
335         require(recipient != address(0), "ERC20: transfer to the zero address");
336 
337         _balances[sender] = _balances[sender].sub(amount);
338         _balances[recipient] = _balances[recipient].add(amount);
339         emit Transfer(sender, recipient, amount);
340     }
341 
342     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
343      * the total supply.
344      *
345      * Emits a `Transfer` event with `from` set to the zero address.
346      *
347      * Requirements
348      *
349      * - `to` cannot be the zero address.
350      */
351     function _mint(address account, uint256 amount) internal {
352         require(account != address(0), "ERC20: mint to the zero address");
353 
354         _totalSupply = _totalSupply.add(amount);
355         _balances[account] = _balances[account].add(amount);
356         emit Transfer(address(0), account, amount);
357     }
358 
359      /**
360      * @dev Destoys `amount` tokens from `account`, reducing the
361      * total supply.
362      *
363      * Emits a `Transfer` event with `to` set to the zero address.
364      *
365      * Requirements
366      *
367      * - `account` cannot be the zero address.
368      * - `account` must have at least `amount` tokens.
369      */
370     function _burn(address account, uint256 value) internal {
371         require(account != address(0), "ERC20: burn from the zero address");
372 
373         _totalSupply = _totalSupply.sub(value);
374         _balances[account] = _balances[account].sub(value);
375         emit Transfer(account, address(0), value);
376     }
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
380      *
381      * This is internal function is equivalent to `approve`, and can be used to
382      * e.g. set automatic allowances for certain subsystems, etc.
383      *
384      * Emits an `Approval` event.
385      *
386      * Requirements:
387      *
388      * - `owner` cannot be the zero address.
389      * - `spender` cannot be the zero address.
390      */
391     function _approve(address owner, address spender, uint256 value) internal {
392         require(owner != address(0), "ERC20: approve from the zero address");
393         require(spender != address(0), "ERC20: approve to the zero address");
394 
395         _allowances[owner][spender] = value;
396         emit Approval(owner, spender, value);
397     }
398 
399     /**
400      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
401      * from the caller's allowance.
402      *
403      * See `_burn` and `_approve`.
404      */
405     function _burnFrom(address account, uint256 amount) internal {
406         _burn(account, amount);
407         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
408     }
409 }
410 
411 
412 
413 
414 
415 /**
416  * @dev Optional functions from the ERC20 standard.
417  */
418 contract ERC20Detailed is IERC20 {
419     string private _name;
420     string private _symbol;
421     uint8 private _decimals;
422 
423     /**
424      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
425      * these values are immutable: they can only be set once during
426      * construction.
427      */
428     constructor (string memory name, string memory symbol, uint8 decimals) public {
429         _name = name;
430         _symbol = symbol;
431         _decimals = decimals;
432     }
433 
434     /**
435      * @dev Returns the name of the token.
436      */
437     function name() public view returns (string memory) {
438         return _name;
439     }
440 
441     /**
442      * @dev Returns the symbol of the token, usually a shorter version of the
443      * name.
444      */
445     function symbol() public view returns (string memory) {
446         return _symbol;
447     }
448 
449     /**
450      * @dev Returns the number of decimals used to get its user representation.
451      * For example, if `decimals` equals `2`, a balance of `505` tokens should
452      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
453      *
454      * Tokens usually opt for a value of 18, imitating the relationship between
455      * Ether and Wei.
456      *
457      * > Note that this information is only used for _display_ purposes: it in
458      * no way affects any of the arithmetic of the contract, including
459      * `IERC20.balanceOf` and `IERC20.transfer`.
460      */
461     function decimals() public view returns (uint8) {
462         return _decimals;
463     }
464 }
465 
466 
467 
468 /**
469  * @dev Contract module which provides a basic access control mechanism, where
470  * there is an account (an owner) that can be granted exclusive access to
471  * specific functions.
472  *
473  * This module is used through inheritance. It will make available the modifier
474  * `onlyOwner`, which can be aplied to your functions to restrict their use to
475  * the owner.
476  */
477 contract Ownable {
478     address private _owner;
479 
480     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor () internal {
486         _owner = msg.sender;
487         emit OwnershipTransferred(address(0), _owner);
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(isOwner(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Returns true if the caller is the current owner.
507      */
508     function isOwner() public view returns (bool) {
509         return msg.sender == _owner;
510     }
511 
512     /**
513      * @dev Leaves the contract without owner. It will not be possible to call
514      * `onlyOwner` functions anymore. Can only be called by the current owner.
515      *
516      * > Note: Renouncing ownership will leave the contract without an owner,
517      * thereby removing any functionality that is only available to the owner.
518      */
519     function renounceOwnership() public onlyOwner {
520         emit OwnershipTransferred(_owner, address(0));
521         _owner = address(0);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Can only be called by the current owner.
527      */
528     function transferOwnership(address newOwner) public onlyOwner {
529         _transferOwnership(newOwner);
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      */
535     function _transferOwnership(address newOwner) internal {
536         require(newOwner != address(0), "Ownable: new owner is the zero address");
537         emit OwnershipTransferred(_owner, newOwner);
538         _owner = newOwner;
539     }
540 }
541 
542 
543 
544 contract Xenium is ERC20, ERC20Detailed, Ownable {
545 
546     uint256 INITIAL_SUPPLY = 20643435050000000000000000;
547 
548     constructor() ERC20Detailed("Xenium", "XENM", 18) public {
549         _mint(msg.sender, INITIAL_SUPPLY);
550     }
551 }