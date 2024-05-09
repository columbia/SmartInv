1 pragma solidity >=0.5.0 <0.6.0;
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
152 /**
153  * @dev Interface of the ERC20 standard as defined in the EIP.
154  */
155 interface IERC20 {
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transfer(address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through `transferFrom`. This is
178      * zero by default.
179      *
180      * This value changes when `approve` or `transferFrom` are called.
181      */
182     function allowance(address owner, address spender) external view returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * > Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an `Approval` event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a `Transfer` event.
208      */
209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to `approve`. `value` is the new allowance.
222      */
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 /**
227  * @dev Implementation of the `IERC20` interface.
228  *
229  */
230 contract ERC20 is IERC20 {
231     using SafeMath for uint256;
232 
233     mapping (address => uint256) internal _balances;
234 
235     mapping (address => mapping (address => uint256)) internal _allowances;
236 
237     uint256 internal _totalSupply;
238 
239     /**
240      * @dev See `IERC20.totalSupply`.
241      */
242     function totalSupply() public view returns (uint256) {
243         return _totalSupply;
244     }
245 
246     /**
247      * @dev See `IERC20.balanceOf`.
248      */
249     function balanceOf(address account) public view returns (uint256) {
250         return _balances[account];
251     }
252 
253     /**
254      * @dev See `IERC20.transfer`.
255      *
256      * Requirements:
257      *
258      * - `recipient` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address recipient, uint256 amount) public returns (bool) {
262         _transfer(msg.sender, recipient, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See `IERC20.allowance`.
268      */
269     function allowance(address owner, address spender) public view returns (uint256) {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See `IERC20.approve`.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 value) public returns (bool) {
281         _approve(msg.sender, spender, value);
282         return true;
283     }
284 
285     /**
286      * @dev See `IERC20.transferFrom`.
287      *
288      * Emits an `Approval` event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of `ERC20`;
290      *
291      * Requirements:
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `value`.
294      * - the caller must have allowance for `sender`'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
298         _transfer(sender, recipient, amount);
299         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to `approve` that can be used as a mitigation for
307      * problems described in `IERC20.approve`.
308      *
309      * Emits an `Approval` event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
316         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
317         return true;
318     }
319 
320     /**
321      * @dev Atomically decreases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to `approve` that can be used as a mitigation for
324      * problems described in `IERC20.approve`.
325      *
326      * Emits an `Approval` event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      * - `spender` must have allowance for the caller of at least
332      * `subtractedValue`.
333      */
334     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
335         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
336         return true;
337     }
338 
339     /**
340      * @dev Moves tokens `amount` from `sender` to `recipient`.
341      *
342      * This is internal function is equivalent to `transfer`, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a `Transfer` event.
346      *
347      * Requirements:
348      *
349      * - `sender` cannot be the zero address.
350      * - `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      */
353     function _transfer(address sender, address recipient, uint256 amount) internal {
354         require(sender != address(0), "ERC20: transfer from the zero address");
355         require(recipient != address(0), "ERC20: transfer to the zero address");
356 
357         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
358         _balances[recipient] = _balances[recipient].add(amount);
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
364      */
365     function _approve(address owner, address spender, uint256 value) internal {
366         require(owner != address(0), "ERC20: approve from the zero address");
367         require(spender != address(0), "ERC20: approve to the zero address");
368 
369         _allowances[owner][spender] = value;
370         emit Approval(owner, spender, value);
371     }
372 }
373 
374 contract Ownable {
375     address public owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379     /**
380      * @dev Throws if called by any account other than the owner.
381      */
382     modifier onlyOwner() {
383         require(msg.sender == owner, "Ownable: the caller must be owner");
384         _;
385     }
386 
387     /**
388      * @dev Allows the current owner to transfer control of the contract to a newOwner.
389      * @param _newOwner The address to transfer ownership to.
390      */
391     function transferOwnership(address _newOwner) public onlyOwner {
392         _transferOwnership(_newOwner);
393     }
394 
395     /**
396      * @dev Transfers control of the contract to a newOwner.
397      * @param _newOwner The address to transfer ownership to.
398      */
399     function _transferOwnership(address _newOwner) internal {
400         require(_newOwner != address(0), "Ownable: new owner is the zero address");
401         emit OwnershipTransferred(owner, _newOwner);
402         owner = _newOwner;
403     }
404 }
405 
406 /**
407  * @dev Contract module which allows children to implement an emergency stop
408  * mechanism that can be triggered by an authorized account.
409  */
410 contract Pausable is Ownable {
411     /**
412      * @dev Emitted when the pause is triggered by a pauser (`account`).
413      */
414     event Paused(address account);
415 
416     /**
417      * @dev Emitted when the pause is lifted by a pauser (`account`).
418      */
419     event Unpaused(address account);
420 
421     bool private _paused;
422 
423     /**
424      * @dev Initialize the contract in unpaused state. Assigns the Pauser role
425      * to the deployer.
426      */
427     constructor () internal {
428         _paused = false;
429     }
430 
431     /**
432      * @dev Return true if the contract is paused, and false otherwise.
433      */
434     function paused() public view returns (bool) {
435         return _paused;
436     }
437 
438     /**
439      * @dev Modifier to make a function callable only when the contract is not paused.
440      */
441     modifier whenNotPaused() {
442         require(!_paused, "Pausable: paused");
443         _;
444     }
445 
446     /**
447      * @dev Modifier to make a function callable only when the contract is paused.
448      */
449     modifier whenPaused() {
450         require(_paused, "Pausable: not paused");
451         _;
452     }
453 
454     /**
455      * @dev Called by a pauser to pause, triggers stopped state.
456      */
457     function pause() public onlyOwner whenNotPaused {
458         _paused = true;
459         emit Paused(msg.sender);
460     }
461 
462     /**
463      * @dev Called by a pauser to unpause, returns to normal state.
464      */
465     function unpause() public onlyOwner whenPaused {
466         _paused = false;
467         emit Unpaused(msg.sender);
468     }
469 }
470 
471 /**
472  * @title Pausable token
473  * @dev ERC20 modified with pausable transfers.
474  */
475 contract ERC20Pausable is ERC20, Pausable {
476     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
477         return super.transfer(to, value);
478     }
479 
480     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
481         return super.transferFrom(from, to, value);
482     }
483 
484     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
485         return super.approve(spender, value);
486     }
487 
488     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
489         return super.increaseAllowance(spender, addedValue);
490     }
491 
492     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
493         return super.decreaseAllowance(spender, subtractedValue);
494     }
495 }
496 
497 contract UPCToken is ERC20Pausable {
498     string public constant name = "Utopia";
499     string public constant symbol = "UPC";
500     uint8 public constant decimals = 18;
501     uint256 internal constant INIT_TOTALSUPPLY = 1000000000 ether;
502 
503     /**
504      * @dev Constructor.
505      */
506     constructor () public {
507         owner = msg.sender;
508         _totalSupply = INIT_TOTALSUPPLY;
509         _balances[owner] = _totalSupply;
510         emit Transfer(address(0), owner, _totalSupply);
511     }
512 }