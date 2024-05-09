1 pragma solidity ^0.5.0;
2 
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a `Transfer` event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through `transferFrom`. This is
27      * zero by default.
28      *
29      * This value changes when `approve` or `transferFrom` are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * > Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an `Approval` event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a `Transfer` event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to `approve`. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
76 
77 pragma solidity ^0.5.0;
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a, "SafeMath: subtraction overflow");
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Solidity only automatically asserts when dividing by 0
161         require(b > 0, "SafeMath: division by zero");
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b != 0, "SafeMath: modulo by zero");
181         return a % b;
182     }
183 }
184 
185 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
186 
187 pragma solidity ^0.5.0;
188 
189 
190 
191 /**
192  * @dev Implementation of the `IERC20` interface.
193  *
194  * This implementation is agnostic to the way tokens are created. This means
195  * that a supply mechanism has to be added in a derived contract using `_mint`.
196  * For a generic mechanism see `ERC20Mintable`.
197  *
198  * *For a detailed writeup see our guide [How to implement supply
199  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
200  *
201  * We have followed general OpenZeppelin guidelines: functions revert instead
202  * of returning `false` on failure. This behavior is nonetheless conventional
203  * and does not conflict with the expectations of ERC20 applications.
204  *
205  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
206  * This allows applications to reconstruct the allowance for all accounts just
207  * by listening to said events. Other implementations of the EIP may not emit
208  * these events, as it isn't required by the specification.
209  *
210  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
211  * functions have been added to mitigate the well-known issues around setting
212  * allowances. See `IERC20.approve`.
213  */
214 contract ERC20 is IERC20 {
215     using SafeMath for uint256;
216 
217     mapping (address => uint256) private _balances;
218 
219     mapping (address => mapping (address => uint256)) private _allowances;
220 
221     uint256 private _totalSupply;
222 
223     /**
224      * @dev See `IERC20.totalSupply`.
225      */
226     function totalSupply() public view returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See `IERC20.balanceOf`.
232      */
233     function balanceOf(address account) public view returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See `IERC20.transfer`.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public returns (bool) {
246         _transfer(msg.sender, recipient, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See `IERC20.allowance`.
252      */
253     function allowance(address owner, address spender) public view returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See `IERC20.approve`.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 value) public returns (bool) {
265         _approve(msg.sender, spender, value);
266         return true;
267     }
268 
269     /**
270      * @dev See `IERC20.transferFrom`.
271      *
272      * Emits an `Approval` event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of `ERC20`;
274      *
275      * Requirements:
276      * - `sender` and `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `value`.
278      * - the caller must have allowance for `sender`'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to `approve` that can be used as a mitigation for
291      * problems described in `IERC20.approve`.
292      *
293      * Emits an `Approval` event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
300         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to `approve` that can be used as a mitigation for
308      * problems described in `IERC20.approve`.
309      *
310      * Emits an `Approval` event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
319         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Moves tokens `amount` from `sender` to `recipient`.
325      *
326      * This is internal function is equivalent to `transfer`, and can be used to
327      * e.g. implement automatic token fees, slashing mechanisms, etc.
328      *
329      * Emits a `Transfer` event.
330      *
331      * Requirements:
332      *
333      * - `sender` cannot be the zero address.
334      * - `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      */
337     function _transfer(address sender, address recipient, uint256 amount) internal {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _balances[sender] = _balances[sender].sub(amount);
342         _balances[recipient] = _balances[recipient].add(amount);
343         emit Transfer(sender, recipient, amount);
344     }
345 
346     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
347      * the total supply.
348      *
349      * Emits a `Transfer` event with `from` set to the zero address.
350      *
351      * Requirements
352      *
353      * - `to` cannot be the zero address.
354      */
355     function _mint(address account, uint256 amount) internal {
356         require(account != address(0), "ERC20: mint to the zero address");
357 
358         _totalSupply = _totalSupply.add(amount);
359         _balances[account] = _balances[account].add(amount);
360         emit Transfer(address(0), account, amount);
361     }
362 
363      /**
364      * @dev Destoys `amount` tokens from `account`, reducing the
365      * total supply.
366      *
367      * Emits a `Transfer` event with `to` set to the zero address.
368      *
369      * Requirements
370      *
371      * - `account` cannot be the zero address.
372      * - `account` must have at least `amount` tokens.
373      */
374     function _burn(address account, uint256 value) internal {
375         require(account != address(0), "ERC20: burn from the zero address");
376 
377         _totalSupply = _totalSupply.sub(value);
378         _balances[account] = _balances[account].sub(value);
379         emit Transfer(account, address(0), value);
380     }
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
384      *
385      * This is internal function is equivalent to `approve`, and can be used to
386      * e.g. set automatic allowances for certain subsystems, etc.
387      *
388      * Emits an `Approval` event.
389      *
390      * Requirements:
391      *
392      * - `owner` cannot be the zero address.
393      * - `spender` cannot be the zero address.
394      */
395     function _approve(address owner, address spender, uint256 value) internal {
396         require(owner != address(0), "ERC20: approve from the zero address");
397         require(spender != address(0), "ERC20: approve to the zero address");
398 
399         _allowances[owner][spender] = value;
400         emit Approval(owner, spender, value);
401     }
402 
403     /**
404      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
405      * from the caller's allowance.
406      *
407      * See `_burn` and `_approve`.
408      */
409     function _burnFrom(address account, uint256 amount) internal {
410         _burn(account, amount);
411         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
412     }
413 }
414 
415 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
416 
417 pragma solidity ^0.5.0;
418 
419 
420 /**
421  * @dev Optional functions from the ERC20 standard.
422  */
423 contract ERC20Detailed is IERC20 {
424     string private _name;
425     string private _symbol;
426     uint8 private _decimals;
427 
428     /**
429      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
430      * these values are immutable: they can only be set once during
431      * construction.
432      */
433     constructor (string memory name, string memory symbol, uint8 decimals) public {
434         _name = name;
435         _symbol = symbol;
436         _decimals = decimals;
437     }
438 
439     /**
440      * @dev Returns the name of the token.
441      */
442     function name() public view returns (string memory) {
443         return _name;
444     }
445 
446     /**
447      * @dev Returns the symbol of the token, usually a shorter version of the
448      * name.
449      */
450     function symbol() public view returns (string memory) {
451         return _symbol;
452     }
453 
454     /**
455      * @dev Returns the number of decimals used to get its user representation.
456      * For example, if `decimals` equals `2`, a balance of `505` tokens should
457      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
458      *
459      * Tokens usually opt for a value of 18, imitating the relationship between
460      * Ether and Wei.
461      *
462      * > Note that this information is only used for _display_ purposes: it in
463      * no way affects any of the arithmetic of the contract, including
464      * `IERC20.balanceOf` and `IERC20.transfer`.
465      */
466     function decimals() public view returns (uint8) {
467         return _decimals;
468     }
469 }
470 
471 // File: contracts/TestToken.sol
472 
473 pragma solidity ^0.5.0;  
474 
475 
476 //import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";  
477   
478 // contract TestToken is ERC20 {
479 //   string public name = "TutorialToken";
480 //   string public symbol = "TT";
481 //   uint8 public decimals = 2;
482 //   uint public INITIAL_SUPPLY = 12000;
483 
484 //   constructor() public {
485 //   _mint(msg.sender, INITIAL_SUPPLY);
486 // }
487 // }
488 
489 contract ESMEToken is ERC20Detailed, ERC20 {
490   constructor(
491     string memory _name,
492     string memory _symbol,
493     uint8 _decimals,
494     uint256 _amount
495   )
496     ERC20Detailed(_name, _symbol, _decimals)
497     public
498   {
499     _mint(msg.sender, _amount);
500   }
501 }