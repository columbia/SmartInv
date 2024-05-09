1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-30
3 */
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
18     constructor () internal { }
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
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
33  * the optional functions; to access them see {ERC20Detailed}.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      * - Subtraction cannot overflow.
157      *
158      * _Available since v2.4.0._
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      *
216      * _Available since v2.4.0._
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         // Solidity only automatically asserts when dividing by 0
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      *
253      * _Available since v2.4.0._
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Implementation of the {IERC20} interface.
263  *
264  * This implementation is agnostic to the way tokens are created. This means
265  * that a supply mechanism has to be added in a derived contract using {_mint}.
266  * For a generic mechanism see {ERC20Mintable}.
267  *
268  * TIP: For a detailed writeup see our guide
269  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
270  * to implement supply mechanisms].
271  *
272  * We have followed general OpenZeppelin guidelines: functions revert instead
273  * of returning `false` on failure. This behavior is nonetheless conventional
274  * and does not conflict with the expectations of ERC20 applications.
275  *
276  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
277  * This allows applications to reconstruct the allowance for all accounts just
278  * by listening to said events. Other implementations of the EIP may not emit
279  * these events, as it isn't required by the specification.
280  *
281  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
282  * functions have been added to mitigate the well-known issues around setting
283  * allowances. See {IERC20-approve}.
284  */
285 contract ERC20 is Context, IERC20 {
286     using SafeMath for uint256;
287 
288     mapping (address => uint256) private _balances;
289 
290     mapping (address => mapping (address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20};
345      *
346      * Requirements:
347      * - `sender` and `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      * - the caller must have allowance for `sender`'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
353         _transfer(sender, recipient, amount);
354         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
391         return true;
392     }
393 
394     /**
395      * @dev Moves tokens `amount` from `sender` to `recipient`.
396      *
397      * This is internal function is equivalent to {transfer}, and can be used to
398      * e.g. implement automatic token fees, slashing mechanisms, etc.
399      *
400      * Emits a {Transfer} event.
401      *
402      * Requirements:
403      *
404      * - `sender` cannot be the zero address.
405      * - `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      */
408     function _transfer(address sender, address recipient, uint256 amount) internal {
409         require(sender != address(0), "ERC20: transfer from the zero address");
410         require(recipient != address(0), "ERC20: transfer to the zero address");
411 
412         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
413         _balances[recipient] = _balances[recipient].add(amount);
414         emit Transfer(sender, recipient, amount);
415     }
416 
417     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
418      * the total supply.
419      *
420      * Emits a {Transfer} event with `from` set to the zero address.
421      *
422      * Requirements
423      *
424      * - `to` cannot be the zero address.
425      */
426     function _mint(address account, uint256 amount) internal {
427         require(account != address(0), "ERC20: mint to the zero address");
428 
429         _totalSupply = _totalSupply.add(amount);
430         _balances[account] = _balances[account].add(amount);
431         emit Transfer(address(0), account, amount);
432     }
433 
434      /**
435      * @dev Destroys `amount` tokens from `account`, reducing the
436      * total supply.
437      *
438      * Emits a {Transfer} event with `to` set to the zero address.
439      *
440      * Requirements
441      *
442      * - `account` cannot be the zero address.
443      * - `account` must have at least `amount` tokens.
444      */
445     function _burn(address account, uint256 amount) internal {
446         require(account != address(0), "ERC20: burn from the zero address");
447 
448         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
449         _totalSupply = _totalSupply.sub(amount);
450         emit Transfer(account, address(0), amount);
451     }
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
455      *
456      * This is internal function is equivalent to `approve`, and can be used to
457      * e.g. set automatic allowances for certain subsystems, etc.
458      *
459      * Emits an {Approval} event.
460      *
461      * Requirements:
462      *
463      * - `owner` cannot be the zero address.
464      * - `spender` cannot be the zero address.
465      */
466     function _approve(address owner, address spender, uint256 amount) internal {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
476      * from the caller's allowance.
477      *
478      * See {_burn} and {_approve}.
479      */
480     function _burnFrom(address account, uint256 amount) internal {
481         _burn(account, amount);
482         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
483     }
484 }
485 
486 contract EasyToken is ERC20 {
487 
488     uint public totalTokensAmount = 10000000;
489 
490     string public name = "EASY V2";
491     string public symbol = "EZ";
492     uint8 public decimals = 18;
493 
494     bool public paused = false;
495 
496     address public pauser;
497 
498     event Paused();
499     event Unpaused();
500 
501     constructor() public {
502         // mint totalTokensAmount times 10^decimals for operator
503         _mint(_msgSender(), totalTokensAmount  * (10 ** uint256(decimals)));
504 
505         pauser = _msgSender();
506     }
507 
508     function changePauser(address pauser_) external {
509         require(_msgSender() == pauser, "Invalid access");
510         pauser = pauser_;
511     }
512 
513     function pause() external {
514         require(_msgSender() == pauser, "Invalid access");
515         paused = true;
516         emit Paused();
517     }
518 
519     function unpause() external {
520         require(_msgSender() == pauser, "Invalid access");
521         paused = false;
522         pauser = address(0); //Can only be paused once
523         emit Unpaused();
524     }
525 
526 
527     function _transfer(
528         address sender,
529         address recipient,
530         uint256 amount
531     )
532         internal
533     {
534         require(!paused, "Transfer is paused");
535         super._transfer(sender, recipient, amount);
536     }
537 }