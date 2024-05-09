1 // File: contracts/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65 }
66 
67 // File: contracts/ERC20/ERC20Detailed.sol
68 
69 pragma solidity ^0.6.0;
70 
71 
72 /**
73  * @dev Optional functions from the ERC20 standard.
74  */
75 abstract contract ERC20Detailed is IERC20 {
76     string private _name;
77     string private _symbol;
78     uint8 private _decimals;
79 
80     /**
81      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
82      * these values are immutable: they can only be set once during
83      * construction.
84      */
85     constructor (string memory name, string memory symbol, uint8 decimals) public {
86         _name = name;
87         _symbol = symbol;
88         _decimals = decimals;
89     }
90 
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() public view returns (string memory) {
95         return _name;
96     }
97 
98     /**
99      * @dev Returns the symbol of the token, usually a shorter version of the
100      * name.
101      */
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106     /**
107      * @dev Returns the number of decimals used to get its user representation.
108      * For example, if `decimals` equals `2`, a balance of `505` tokens should
109      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
110      *
111      * Tokens usually opt for a value of 18, imitating the relationship between
112      * Ether and Wei.
113      *
114      * NOTE: This information is only used for _display_ purposes: it in
115      * no way affects any of the arithmetic of the contract, including
116      * {IERC20-balanceOf} and {IERC20-transfer}.
117      */
118     function decimals() public view returns (uint8) {
119         return _decimals;
120     }
121 }
122 
123 // File: contracts/ERC20/GSN/Context.sol
124 
125 pragma solidity ^0.6.0;
126 
127 /*
128  * @dev Provides information about the current execution context, including the
129  * sender of the transaction and its data. While these are generally available
130  * via msg.sender and msg.data, they should not be accessed in such a direct
131  * manner, since when dealing with GSN meta-transactions the account sending and
132  * paying for execution may not be the actual sender (as far as an application
133  * is concerned).
134  *
135  * This contract is only required for intermediate, library-like contracts.
136  */
137 contract Context {
138     // Empty internal constructor, to prevent people from mistakenly deploying
139     // an instance of this contract, which should be used via inheritance.
140     constructor () internal { }
141 
142     function _msgSender() internal view virtual returns (address payable) {
143         return msg.sender;
144     }
145 
146     function _msgData() internal view virtual returns (bytes memory) {
147         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
148         return msg.data;
149     }
150 }
151 
152 // File: contracts/ERC20/SafeMath.sol
153 
154 pragma solidity ^0.6.0;
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations with added overflow
158  * checks.
159  *
160  * Arithmetic operations in Solidity wrap on overflow. This can easily result
161  * in bugs, because programmers usually assume that an overflow raises an
162  * error, which is the standard behavior in high level programming languages.
163  * `SafeMath` restores this intuition by reverting the transaction when an
164  * operation overflows.
165  *
166  * Using this library instead of the unchecked operations eliminates an entire
167  * class of bugs, so it's recommended to use it always.
168  */
169 library SafeMath {
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SM:28");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         return sub(a, b, "SM:43");
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      * - Subtraction cannot overflow.
207      *
208      * _Available since v2.4.0._
209      */
210     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b <= a, errorMessage);
212         uint256 c = a - b;
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `*` operator.
222      *
223      * Requirements:
224      * - Multiplication cannot overflow.
225      */
226     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
227         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
228         // benefit is lost if 'b' is also tested.
229         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
230         if (a == 0) {
231             return 0;
232         }
233 
234         uint256 c = a * b;
235         require(c / a == b, "SM:82");
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers. Reverts on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator. Note: this function uses a
245      * `revert` opcode (which leaves remaining gas untouched) while Solidity
246      * uses an invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         return div(a, b, "SM:99");
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      * - The divisor cannot be zero.
265      *
266      * _Available since v2.4.0._
267      */
268     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         // Solidity only automatically asserts when dividing by 0
270         require(b > 0, errorMessage);
271         uint256 c = a / b;
272         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
279      * Reverts when dividing by zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
289         return mod(a, b, "SM:144");
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
294      * Reverts with custom message when dividing by zero.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b != 0, errorMessage);
307         return a % b;
308     }
309 }
310 
311 // File: contracts/ERC20/ERC20.sol
312 
313 pragma solidity ^0.6.0;
314 
315 
316 
317 
318 contract ERC20 is Context {
319     using SafeMath for uint256;
320 
321     mapping (address => uint256) private _balances;
322 
323     mapping (address => mapping (address => uint256)) private _allowances;
324 
325     uint256 private _totalSupply;
326 
327     function __totalSupply() internal view returns (uint256) {
328         return _totalSupply;
329     }
330 
331     function __balanceOf(address account) internal view returns (uint256) {
332         return _balances[account];
333     }
334 
335     function __transfer(address recipient, uint256 amount) internal returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     function __allowance(address owner, address spender) internal view returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     function __approve(address spender, uint256 amount) internal returns (bool) {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     function __transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20:40"));
352         return true;
353     }
354 
355     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
356         require(sender != address(0), "ERC20:44");
357         require(recipient != address(0), "ERC20:46");
358         _balances[sender] = _balances[sender].sub(amount, "ERC20:50");
359         _balances[recipient] = _balances[recipient].add(amount);
360         emit Transfer(sender, recipient, amount);
361     }
362 
363     function _mint(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20:56");
365         _totalSupply = _totalSupply.add(amount);
366         _balances[account] = _balances[account].add(amount);
367         emit Transfer(address(0), account, amount);
368     }
369 
370     function _approve(address owner, address spender, uint256 amount) private {
371         require(owner != address(0), "ERC20:66");
372         require(spender != address(0), "ERC20:67");
373 
374         _allowances[owner][spender] = amount;
375         emit Approval(owner, spender, amount);
376     }
377 
378     event Transfer(address indexed from, address indexed to, uint256 value);
379 
380     event Approval(address indexed owner, address indexed spender, uint256 value);
381 }
382 
383 // File: contracts/library/Ownable.sol
384 
385 pragma solidity ^0.6.0;
386 
387 contract Ownable {
388     address internal _owner;
389 
390     event OwnershipTransferred(
391         address indexed currentOwner,
392         address indexed newOwner
393     );
394 
395     constructor() internal {
396         _owner = msg.sender;
397         emit OwnershipTransferred(address(0), msg.sender);
398     }
399 
400     modifier onlyOwner() {
401         require(
402             msg.sender == _owner,
403             "Ownable : Function called by unauthorized user."
404         );
405         _;
406     }
407 
408     function owner() external view returns (address ownerAddress) {
409         ownerAddress = _owner;
410     }
411 
412     function transferOwnership(address newOwner)
413         public
414         onlyOwner
415         returns (bool success)
416     {
417         require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
418         success = _transferOwnership(newOwner);
419     }
420 
421     function _transferOwnership(address newOwner) internal returns (bool success) {
422         emit OwnershipTransferred(_owner, newOwner);
423         _owner = newOwner;
424         success = true;
425     }
426 }
427 
428 // File: contracts/library/UserManager.sol
429 
430 pragma solidity ^0.6.0;
431 
432 contract UserManager {
433     struct AddressSet {
434         mapping(address => bool) flags;
435     }
436 
437     AddressSet internal lockedUsers = AddressSet();
438 
439     function _insertLockUser(address value)
440           internal
441           returns (bool)
442       {
443           if (lockedUsers.flags[value])
444               return false; // already there
445           lockedUsers.flags[value] = true;
446           return true;
447       }
448 
449       function _removeLockUser(address value)
450           internal
451           returns (bool)
452       {
453           if (!lockedUsers.flags[value])
454               return false; // not there
455           lockedUsers.flags[value] = false;
456           return true;
457       }
458 
459       function _containsLockUser(address value)
460           internal
461           view
462           returns (bool)
463       {
464           return lockedUsers.flags[value];
465       }
466 
467     modifier isAllowedUser(address user) {
468         require(_containsLockUser(user) == false, "sender is locked user");    // 차단된 사용자가 아니어야 한다!
469         _;
470     }
471 }
472 
473 // File: contracts/CojamToken.sol
474 
475 pragma solidity ^0.6.0;
476 
477 
478 
479 
480 
481 contract CojamToken is IERC20, ERC20, ERC20Detailed, Ownable, UserManager {
482 
483     event LockUser(address user);
484     event UnlockUser(address user);
485 
486     constructor() ERC20Detailed("Cojam", "CT", 18) public {
487         uint256 initialSupply = 5000000000 * (10 ** 18);
488 
489         _owner = msg.sender;
490         _mint(msg.sender, initialSupply);
491     }
492 
493     /**
494      * 관리자가 사용자의 차단 여부를 확인하는 함수
495      * */
496     function isLock(address target) external view returns(bool) {
497         return _containsLockUser(target);
498     }
499 
500     /**
501      * 관리자가 사용자를 차단하는 함수
502      * */
503     function lock(address[] memory targets) public onlyOwner returns(bool[] memory) {
504         bool[] memory results = new bool[](targets.length);
505 
506         for(uint256 ii=0; ii<targets.length; ii++){
507             require(_owner != targets[ii], "can not lock owner");     // 관리자 주소가 컨트롤 되어서는 안 된다!
508             results[ii] = _insertLockUser(targets[ii]);
509             emit LockUser(targets[ii]);
510         }
511 
512         return results;
513     }
514 
515     /**
516      * 관리자가 사용자를 차단해제 하는 함수
517      * */
518     function unlock(address[] memory targets) public onlyOwner returns(bool[] memory) {
519         bool[] memory results = new bool[](targets.length);
520 
521         for(uint256 ii=0; ii<targets.length; ii++){
522             require(_owner != targets[ii], "can not unlock owner");     // 관리자 주소가 컨트롤 되어서는 안 된다!
523             results[ii] = _removeLockUser(targets[ii]);
524             emit UnlockUser(targets[ii]);
525         }
526 
527         return results;
528     }
529     /**
530      * ERC20 기본 함수
531     **/
532     function transfer(address recipient, uint256 amount) external override isAllowedUser(msg.sender) returns (bool){
533         return __transfer(recipient, amount);
534     }
535 
536     function totalSupply() external override view returns (uint256){
537         return __totalSupply();
538     }
539 
540     function balanceOf(address account) external override view returns (uint256){
541         return __balanceOf(account);
542     }
543 
544     function allowance(address owner, address spender) external view override returns (uint256){
545         return __allowance(owner, spender);
546     }
547 
548     function approve(address spender, uint256 amount) external override isAllowedUser(msg.sender) returns (bool){
549         return __approve(spender, amount);
550     }
551 
552     function transferFrom(address sender, address recipient, uint256 amount) external override isAllowedUser(sender) returns (bool){
553         return __transferFrom(sender, recipient, amount);
554     }
555 }