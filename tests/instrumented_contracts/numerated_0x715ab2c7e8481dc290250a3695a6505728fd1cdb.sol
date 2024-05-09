1 pragma solidity 0.5.10;
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
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 contract Ownable {
153     address public owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157 
158     /**
159      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160      * account.
161      */
162 
163     /**
164      * @dev Throws if called by any account other than the owner.
165      */
166     modifier onlyOwner() {
167         require(msg.sender == owner, "Ownable: the caller must be owner");
168         _;
169     }
170 
171     /**
172      * @dev Allows the current owner to transfer control of the contract to a newOwner.
173      * @param _newOwner The address to transfer ownership to.
174      */
175     function transferOwnership(address _newOwner) public onlyOwner {
176         _transferOwnership(_newOwner);
177     }
178 
179     /**
180      * @dev Transfers control of the contract to a newOwner.
181      * @param _newOwner The address to transfer ownership to.
182      */
183     function _transferOwnership(address _newOwner) internal {
184         require(_newOwner != address(0), "Ownable: new owner is the zero address");
185         emit OwnershipTransferred(owner, _newOwner);
186         owner = _newOwner;
187     }
188 }
189 
190 /**
191  * @dev Interface of the ERC20 standard as defined in the EIP.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a `Transfer` event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through `transferFrom`. This is
216      * zero by default.
217      *
218      * This value changes when `approve` or `transferFrom` are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * > Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an `Approval` event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to `approve`. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 /**
265  * @dev Implementation of the `IERC20` interface.
266  *
267  */
268 contract ERC20 is IERC20 {
269     using SafeMath for uint256;
270 
271     mapping (address => uint256) internal _balances;
272     mapping (address => mapping (address => uint256)) internal _allowances;
273 
274     uint256 internal _totalSupply;
275 
276     /**
277      * @dev See `IERC20.totalSupply`.
278      */
279     function totalSupply() public view returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See `IERC20.balanceOf`.
285      */
286     function balanceOf(address account) public view returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See `IERC20.transfer`.
292      *
293      * Requirements:
294      *
295      * - `recipient` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address recipient, uint256 amount) public returns (bool) {
299         _transfer(msg.sender, recipient, amount);
300         return true;
301     }
302 
303     /**
304      * @dev See `IERC20.allowance`.
305      */
306     function allowance(address owner, address spender) public view returns (uint256) {
307         return _allowances[owner][spender];
308     }
309 
310     /**
311      * @dev See `IERC20.approve`.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function approve(address spender, uint256 value) public returns (bool) {
318         _approve(msg.sender, spender, value);
319         return true;
320     }
321 
322     /**
323      * @dev See `IERC20.transferFrom`.
324      *
325      * Emits an `Approval` event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of `ERC20`;
327      *
328      * Requirements:
329      * - `sender` and `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `value`.
331      * - the caller must have allowance for `sender`'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
335         _transfer(sender, recipient, amount);
336         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
337         return true;
338     }
339 
340     /**
341      * @dev Atomically increases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to `approve` that can be used as a mitigation for
344      * problems described in `IERC20.approve`.
345      *
346      * Emits an `Approval` event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
353         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
354         return true;
355     }
356 
357     /**
358      * @dev Atomically decreases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to `approve` that can be used as a mitigation for
361      * problems described in `IERC20.approve`.
362      *
363      * Emits an `Approval` event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      * - `spender` must have allowance for the caller of at least
369      * `subtractedValue`.
370      */
371     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
372         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
373         return true;
374     }
375 
376     /**
377      * @dev Moves tokens `amount` from `sender` to `recipient`.
378      *
379      * This is internal function is equivalent to `transfer`, and can be used to
380      * e.g. implement automatic token fees, slashing mechanisms, etc.
381      *
382      * Emits a `Transfer` event.
383      *
384      * Requirements:
385      *
386      * - `sender` cannot be the zero address.
387      * - `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      */
390     function _transfer(address sender, address recipient, uint256 amount) internal {
391         require(sender != address(0), "ERC20: transfer from the zero address");
392         require(recipient != address(0), "ERC20: transfer to the zero address");
393 
394         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
395         _balances[recipient] = _balances[recipient].add(amount);
396         emit Transfer(sender, recipient, amount);
397     }
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
401      */
402     function _approve(address owner, address spender, uint256 value) internal {
403         require(owner != address(0), "ERC20: approve from the zero address");
404         require(spender != address(0), "ERC20: approve to the zero address");
405 
406         _allowances[owner][spender] = value;
407         emit Approval(owner, spender, value);
408     }
409 }
410 
411 
412 /**
413  * @dev Contract module which allows children to implement an emergency stop
414  * mechanism that can be triggered by an authorized account.
415  */
416 contract Pausable is Ownable {
417     /**
418      * @dev Emitted when the pause is triggered by a pauser (`account`).
419      */
420     event Paused(address account);
421 
422     /**
423      * @dev Emitted when the pause is lifted by a pauser (`account`).
424      */
425     event Unpaused(address account);
426 
427     bool private _paused;
428 
429     /**
430      * @dev Initialize the contract in unpaused state. Assigns the Pauser role
431      * to the deployer.
432      */
433     constructor () internal {
434         _paused = false;
435     }
436 
437     /**
438      * @dev Return true if the contract is paused, and false otherwise.
439      */
440     function paused() public view returns (bool) {
441         return _paused;
442     }
443 
444     /**
445      * @dev Modifier to make a function callable only when the contract is not paused.
446      */
447     modifier whenNotPaused() {
448         require(!_paused, "Pausable: paused");
449         _;
450     }
451 
452     /**
453      * @dev Modifier to make a function callable only when the contract is paused.
454      */
455     modifier whenPaused() {
456         require(_paused, "Pausable: not paused");
457         _;
458     }
459 
460     /**
461      * @dev Called by a pauser to pause, triggers stopped state.
462      */
463     function pause() public onlyOwner whenNotPaused {
464         _paused = true;
465         emit Paused(msg.sender);
466     }
467 
468     /**
469      * @dev Called by a pauser to unpause, returns to normal state.
470      */
471     function unpause() public onlyOwner whenPaused {
472         _paused = false;
473         emit Unpaused(msg.sender);
474     }
475 }
476 
477 /**
478  * @title Pausable token
479  * @dev ERC20 modified with pausable transfers.
480  */
481 contract ERC20Pausable is ERC20, Pausable {
482     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
483         return super.transfer(to, value);
484     }
485 
486     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
487         return super.transferFrom(from, to, value);
488     }
489 
490     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
491         return super.approve(spender, value);
492     }
493 
494     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
495         return super.increaseAllowance(spender, addedValue);
496     }
497 
498     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
499         return super.decreaseAllowance(spender, subtractedValue);
500     }
501 }
502 
503 contract GGSToken is ERC20Pausable {
504     string public constant name = "Golden Griffin Stone";
505     string public constant symbol = "GGS";
506     uint8 public constant decimals = 18;
507     uint256 internal constant INIT_TOTALSUPPLY = 150000000;  // Total amount of tokens
508     address wallet = 0x114Adc53945dBAD3886279D1B87B6f207cA62c4D;
509 
510     constructor() public {
511         _totalSupply = INIT_TOTALSUPPLY * 10 ** uint256(decimals);
512         _balances[wallet] = _totalSupply;
513         owner = wallet;
514         emit Transfer(address(0), wallet, _totalSupply);
515     }
516 }