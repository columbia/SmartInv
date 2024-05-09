1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-28
3 */
4 
5 pragma solidity >=0.5.0 <0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 /**
157  * @dev Interface of the ERC20 standard as defined in the EIP.
158  */
159 interface IERC20 {
160     /**
161      * @dev Returns the amount of tokens in existence.
162      */
163     function totalSupply() external view returns (uint256);
164 
165     /**
166      * @dev Returns the amount of tokens owned by `account`.
167      */
168     function balanceOf(address account) external view returns (uint256);
169 
170     /**
171      * @dev Moves `amount` tokens from the caller's account to `recipient`.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a `Transfer` event.
176      */
177     function transfer(address recipient, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Returns the remaining number of tokens that `spender` will be
181      * allowed to spend on behalf of `owner` through `transferFrom`. This is
182      * zero by default.
183      *
184      * This value changes when `approve` or `transferFrom` are called.
185      */
186     function allowance(address owner, address spender) external view returns (uint256);
187 
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * > Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an `Approval` event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Moves `amount` tokens from `sender` to `recipient` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a `Transfer` event.
212      */
213     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Emitted when `value` tokens are moved from one account (`from`) to
217      * another (`to`).
218      *
219      * Note that `value` may be zero.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 value);
222 
223     /**
224      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
225      * a call to `approve`. `value` is the new allowance.
226      */
227     event Approval(address indexed owner, address indexed spender, uint256 value);
228 }
229 
230 /**
231  * @dev Implementation of the `IERC20` interface.
232  *
233  */
234 contract ERC20 is IERC20 {
235     using SafeMath for uint256;
236 
237     mapping (address => uint256) internal _balances;
238 
239     mapping (address => mapping (address => uint256)) internal _allowances;
240 
241     uint256 internal _totalSupply;
242 
243     /**
244      * @dev See `IERC20.totalSupply`.
245      */
246     function totalSupply() public view returns (uint256) {
247         return _totalSupply;
248     }
249 
250     /**
251      * @dev See `IERC20.balanceOf`.
252      */
253     function balanceOf(address account) public view returns (uint256) {
254         return _balances[account];
255     }
256 
257     /**
258      * @dev See `IERC20.transfer`.
259      *
260      * Requirements:
261      *
262      * - `recipient` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address recipient, uint256 amount) public returns (bool) {
266         _transfer(msg.sender, recipient, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See `IERC20.allowance`.
272      */
273     function allowance(address owner, address spender) public view returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     /**
278      * @dev See `IERC20.approve`.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 value) public returns (bool) {
285         _approve(msg.sender, spender, value);
286         return true;
287     }
288 
289     /**
290      * @dev See `IERC20.transferFrom`.
291      *
292      * Emits an `Approval` event indicating the updated allowance. This is not
293      * required by the EIP. See the note at the beginning of `ERC20`;
294      *
295      * Requirements:
296      * - `sender` and `recipient` cannot be the zero address.
297      * - `sender` must have a balance of at least `value`.
298      * - the caller must have allowance for `sender`'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to `approve` that can be used as a mitigation for
311      * problems described in `IERC20.approve`.
312      *
313      * Emits an `Approval` event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
320         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to `approve` that can be used as a mitigation for
328      * problems described in `IERC20.approve`.
329      *
330      * Emits an `Approval` event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
339         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342 
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to `transfer`, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a `Transfer` event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(address sender, address recipient, uint256 amount) internal {
358         require(sender != address(0), "ERC20: transfer from the zero address");
359         require(recipient != address(0), "ERC20: transfer to the zero address");
360 
361         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
362         _balances[recipient] = _balances[recipient].add(amount);
363         emit Transfer(sender, recipient, amount);
364     }
365 
366     /**
367      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
368      */
369     function _approve(address owner, address spender, uint256 value) internal {
370         require(owner != address(0), "ERC20: approve from the zero address");
371         require(spender != address(0), "ERC20: approve to the zero address");
372 
373         _allowances[owner][spender] = value;
374         emit Approval(owner, spender, value);
375     }
376 }
377 
378 contract Ownable {
379     address public owner;
380 
381     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(msg.sender == owner, "Ownable: the caller must be owner");
388         _;
389     }
390 
391     /**
392      * @dev Allows the current owner to transfer control of the contract to a newOwner.
393      * @param _newOwner The address to transfer ownership to.
394      */
395     function transferOwnership(address _newOwner) public onlyOwner {
396         _transferOwnership(_newOwner);
397     }
398 
399     /**
400      * @dev Transfers control of the contract to a newOwner.
401      * @param _newOwner The address to transfer ownership to.
402      */
403     function _transferOwnership(address _newOwner) internal {
404         require(_newOwner != address(0), "Ownable: new owner is the zero address");
405         emit OwnershipTransferred(owner, _newOwner);
406         owner = _newOwner;
407     }
408 }
409 
410 /**
411  * @dev Contract module which allows children to implement an emergency stop
412  * mechanism that can be triggered by an authorized account.
413  */
414 contract Pausable is Ownable {
415     /**
416      * @dev Emitted when the pause is triggered by a pauser (`account`).
417      */
418     event Paused(address account);
419 
420     /**
421      * @dev Emitted when the pause is lifted by a pauser (`account`).
422      */
423     event Unpaused(address account);
424 
425     bool private _paused;
426 
427     /**
428      * @dev Initialize the contract in unpaused state. Assigns the Pauser role
429      * to the deployer.
430      */
431     constructor () internal {
432         _paused = false;
433     }
434 
435     /**
436      * @dev Return true if the contract is paused, and false otherwise.
437      */
438     function paused() public view returns (bool) {
439         return _paused;
440     }
441 
442     /**
443      * @dev Modifier to make a function callable only when the contract is not paused.
444      */
445     modifier whenNotPaused() {
446         require(!_paused, "Pausable: paused");
447         _;
448     }
449 
450     /**
451      * @dev Modifier to make a function callable only when the contract is paused.
452      */
453     modifier whenPaused() {
454         require(_paused, "Pausable: not paused");
455         _;
456     }
457 
458     /**
459      * @dev Called by a pauser to pause, triggers stopped state.
460      */
461     function pause() public onlyOwner whenNotPaused {
462         _paused = true;
463         emit Paused(msg.sender);
464     }
465 
466     /**
467      * @dev Called by a pauser to unpause, returns to normal state.
468      */
469     function unpause() public onlyOwner whenPaused {
470         _paused = false;
471         emit Unpaused(msg.sender);
472     }
473 }
474 
475 /**
476  * @title Pausable token
477  * @dev ERC20 modified with pausable transfers.
478  */
479 contract ERC20Pausable is ERC20, Pausable {
480     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
481         return super.transfer(to, value);
482     }
483 
484     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
485         return super.transferFrom(from, to, value);
486     }
487 
488     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
489         return super.approve(spender, value);
490     }
491 
492     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
493         return super.increaseAllowance(spender, addedValue);
494     }
495 
496     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
497         return super.decreaseAllowance(spender, subtractedValue);
498     }
499 }
500 
501 contract NXXToken is ERC20Pausable {
502     string public constant name = "Nikita";
503     string public constant symbol = "NXX";
504     uint8 public constant decimals = 18;
505     uint256 internal constant INIT_TOTALSUPPLY = 21000000 ether;
506 
507     /**
508      * @dev Constructor.
509      */
510     constructor () public {
511         owner = msg.sender;
512         _totalSupply = INIT_TOTALSUPPLY;
513         _balances[owner] = _totalSupply;
514         emit Transfer(address(0), owner, _totalSupply);
515     }
516 }