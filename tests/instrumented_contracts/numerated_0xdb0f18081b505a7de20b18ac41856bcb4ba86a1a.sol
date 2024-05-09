1 // File: polynetwork/eth-contracts/contracts/libs/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
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
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b != 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: polynetwork/eth-contracts/contracts/libs/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
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
239 // File: polynetwork/eth-contracts/contracts/libs/token/ERC20/ERC20Detailed.sol
240 
241 pragma solidity ^0.5.0;
242 
243 
244 /**
245  * @dev Optional functions from the ERC20 standard.
246  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Detailed.sol
247  */
248 contract ERC20Detailed is IERC20 {
249     string private _name;
250     string private _symbol;
251     uint8 private _decimals;
252 
253     /**
254      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
255      * these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor (string memory name, string memory symbol, uint8 decimals) public {
259         _name = name;
260         _symbol = symbol;
261         _decimals = decimals;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei.
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view returns (uint8) {
292         return _decimals;
293     }
294 }
295 
296 // File: polynetwork/eth-contracts/contracts/libs/GSN/Context.sol
297 
298 pragma solidity ^0.5.0;
299 
300 /*
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with GSN meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
310  */
311 contract Context {
312     // Empty internal constructor, to prevent people from mistakenly deploying
313     // an instance of this contract, which should be used via inheritance.
314     constructor () internal { }
315     // solhint-disable-previous-line no-empty-blocks
316 
317     function _msgSender() internal view returns (address payable) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 
327 // File: polynetwork/eth-contracts/contracts/libs/token/ERC20/ERC20.sol
328 
329 pragma solidity ^0.5.0;
330 
331 
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20Mintable}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin guidelines: functions revert instead
346  * of returning `false` on failure. This behavior is nonetheless conventional
347  * and does not conflict with the expectations of ERC20 applications.
348  *
349  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
350  * This allows applications to reconstruct the allowance for all accounts just
351  * by listening to said events. Other implementations of the EIP may not emit
352  * these events, as it isn't required by the specification.
353  *
354  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
355  * functions have been added to mitigate the well-known issues around setting
356  * allowances. See {IERC20-approve}.
357  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
358  */
359 contract ERC20 is Context, IERC20 {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) private _balances;
363 
364     mapping (address => mapping (address => uint256)) private _allowances;
365 
366     uint256 private _totalSupply;
367 
368     /**
369      * @dev See {IERC20-totalSupply}.
370      */
371     function totalSupply() public view returns (uint256) {
372         return _totalSupply;
373     }
374 
375     /**
376      * @dev See {IERC20-balanceOf}.
377      */
378     function balanceOf(address account) public view returns (uint256) {
379         return _balances[account];
380     }
381 
382     /**
383      * @dev See {IERC20-transfer}.
384      *
385      * Requirements:
386      *
387      * - `recipient` cannot be the zero address.
388      * - the caller must have a balance of at least `amount`.
389      */
390     function transfer(address recipient, uint256 amount) public returns (bool) {
391         _transfer(_msgSender(), recipient, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {IERC20-allowance}.
397      */
398     function allowance(address owner, address spender) public view returns (uint256) {
399         return _allowances[owner][spender];
400     }
401 
402     /**
403      * @dev See {IERC20-approve}.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function approve(address spender, uint256 amount) public returns (bool) {
410         _approve(_msgSender(), spender, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-transferFrom}.
416      *
417      * Emits an {Approval} event indicating the updated allowance. This is not
418      * required by the EIP. See the note at the beginning of {ERC20};
419      *
420      * Requirements:
421      * - `sender` and `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      * - the caller must have allowance for `sender`'s tokens of at least
424      * `amount`.
425      */
426     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
427         _transfer(sender, recipient, amount);
428         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically increases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
445         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
446         return true;
447     }
448 
449     /**
450      * @dev Atomically decreases the allowance granted to `spender` by the caller.
451      *
452      * This is an alternative to {approve} that can be used as a mitigation for
453      * problems described in {IERC20-approve}.
454      *
455      * Emits an {Approval} event indicating the updated allowance.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      * - `spender` must have allowance for the caller of at least
461      * `subtractedValue`.
462      */
463     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
465         return true;
466     }
467 
468     /**
469      * @dev Moves tokens `amount` from `sender` to `recipient`.
470      *
471      * This is internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(address sender, address recipient, uint256 amount) internal {
483         require(sender != address(0), "ERC20: transfer from the zero address");
484         require(recipient != address(0), "ERC20: transfer to the zero address");
485 
486         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
487         _balances[recipient] = _balances[recipient].add(amount);
488         emit Transfer(sender, recipient, amount);
489     }
490 
491     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492      * the total supply.
493      *
494      * Emits a {Transfer} event with `from` set to the zero address.
495      *
496      * Requirements
497      *
498      * - `to` cannot be the zero address.
499      */
500     function _mint(address account, uint256 amount) internal {
501         require(account != address(0), "ERC20: mint to the zero address");
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
523         _totalSupply = _totalSupply.sub(amount);
524         emit Transfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
529      *
530      * This is internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(address owner, address spender, uint256 amount) internal {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
550      * from the caller's allowance.
551      *
552      * See {_burn} and {_approve}.
553      */
554     function _burnFrom(address account, uint256 amount) internal {
555         _burn(account, amount);
556         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
557     }
558 }
559 
560 // File: polynetwork/eth-contracts/contracts/core/assets/erc20_template/ERC20Template.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 
566 
567 contract ERC20Template is Context, ERC20, ERC20Detailed {
568     
569     constructor (address lockProxy) public ERC20Detailed("Poly Ontology Wing Token", "pWING", 9) {
570         _mint(lockProxy, 10000000000000000);
571     }
572 }