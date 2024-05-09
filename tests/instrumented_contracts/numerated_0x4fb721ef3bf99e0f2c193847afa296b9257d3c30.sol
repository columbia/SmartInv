1 /**
2  *Submitted for verification at Etherscan.io on 2020-01-10
3 */
4 
5 pragma solidity ^0.5.16;
6 
7 // File: contracts/GSN/Context.sol
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 contract Context {
20     // Empty internal constructor, to prevent people from mistakenly deploying
21     // an instance of this contract, which should be used via inheritance.
22     constructor () internal { }
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: contracts/token/ERC20/IERC20.sol
36 
37 
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
41  * the optional functions; to access them see {ERC20Detailed}.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: contracts/math/SafeMath.sol
115 
116 
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      * - Subtraction cannot overflow.
169      *
170      * _Available since v2.4.0._
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      *
228      * _Available since v2.4.0._
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         // Solidity only automatically asserts when dividing by 0
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      *
265      * _Available since v2.4.0._
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 // File: contracts/token/ERC20/ERC20.sol
274 
275 
276 
277 
278 
279 
280 /**
281  * @dev Implementation of the {IERC20} interface.
282  *
283  * This implementation is agnostic to the way tokens are created. This means
284  * that a supply mechanism has to be added in a derived contract using {_mint}.
285  * For a generic mechanism see {ERC20Mintable}.
286  *
287  * TIP: For a detailed writeup see our guide
288  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
289  * to implement supply mechanisms].
290  *
291  * We have followed general OpenZeppelin guidelines: functions revert instead
292  * of returning `false` on failure. This behavior is nonetheless conventional
293  * and does not conflict with the expectations of ERC20 applications.
294  *
295  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
296  * This allows applications to reconstruct the allowance for all accounts just
297  * by listening to said events. Other implementations of the EIP may not emit
298  * these events, as it isn't required by the specification.
299  *
300  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
301  * functions have been added to mitigate the well-known issues around setting
302  * allowances. See {IERC20-approve}.
303  */
304 contract ERC20 is Context, IERC20 {
305     using SafeMath for uint256;
306 
307     mapping (address => uint256) private _balances;
308 
309     mapping (address => mapping (address => uint256)) private _allowances;
310 
311     uint256 private _totalSupply;
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20};
364      *
365      * Requirements:
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for `sender`'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
372         _transfer(sender, recipient, amount);
373         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
391         return true;
392     }
393 
394     /**
395      * @dev Atomically decreases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      * - `spender` must have allowance for the caller of at least
406      * `subtractedValue`.
407      */
408     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
410         return true;
411     }
412 
413     /**
414      * @dev Moves tokens `amount` from `sender` to `recipient`.
415      *
416      * This is internal function is equivalent to {transfer}, and can be used to
417      * e.g. implement automatic token fees, slashing mechanisms, etc.
418      *
419      * Emits a {Transfer} event.
420      *
421      * Requirements:
422      *
423      * - `sender` cannot be the zero address.
424      * - `recipient` cannot be the zero address.
425      * - `sender` must have a balance of at least `amount`.
426      */
427     function _transfer(address sender, address recipient, uint256 amount) internal {
428         require(sender != address(0), "ERC20: transfer from the zero address");
429         require(recipient != address(0), "ERC20: transfer to the zero address");
430 
431         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
432         _balances[recipient] = _balances[recipient].add(amount);
433         emit Transfer(sender, recipient, amount);
434     }
435 
436     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
437      * the total supply.
438      *
439      * Emits a {Transfer} event with `from` set to the zero address.
440      *
441      * Requirements
442      *
443      * - `to` cannot be the zero address.
444      */
445     function _mint(address account, uint256 amount) internal {
446         require(account != address(0), "ERC20: mint to the zero address");
447 
448         _totalSupply = _totalSupply.add(amount);
449         _balances[account] = _balances[account].add(amount);
450         emit Transfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
468         _totalSupply = _totalSupply.sub(amount);
469         emit Transfer(account, address(0), amount);
470     }
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
474      *
475      * This is internal function is equivalent to `approve`, and can be used to
476      * e.g. set automatic allowances for certain subsystems, etc.
477      *
478      * Emits an {Approval} event.
479      *
480      * Requirements:
481      *
482      * - `owner` cannot be the zero address.
483      * - `spender` cannot be the zero address.
484      */
485     function _approve(address owner, address spender, uint256 amount) internal {
486         require(owner != address(0), "ERC20: approve from the zero address");
487         require(spender != address(0), "ERC20: approve to the zero address");
488 
489         _allowances[owner][spender] = amount;
490         emit Approval(owner, spender, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
495      * from the caller's allowance.
496      *
497      * See {_burn} and {_approve}.
498      */
499     function _burnFrom(address account, uint256 amount) internal {
500         _burn(account, amount);
501         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
502     }
503 }
504 
505 // File: contracts/token/ERC20/ERC20Detailed.sol
506 
507 
508 
509 
510 /**
511  * @dev Optional functions from the ERC20 standard.
512  */
513 contract ERC20Detailed is IERC20 {
514     string private _name;
515     string private _symbol;
516     uint8 private _decimals;
517 
518     /**
519      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
520      * these values are immutable: they can only be set once during
521      * construction.
522      */
523     constructor (string memory name, string memory symbol, uint8 decimals) public {
524         _name = name;
525         _symbol = symbol;
526         _decimals = decimals;
527     }
528 
529     /**
530      * @dev Returns the name of the token.
531      */
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     /**
537      * @dev Returns the symbol of the token, usually a shorter version of the
538      * name.
539      */
540     function symbol() public view returns (string memory) {
541         return _symbol;
542     }
543 
544     /**
545      * @dev Returns the number of decimals used to get its user representation.
546      * For example, if `decimals` equals `2`, a balance of `505` tokens should
547      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
548      *
549      * Tokens usually opt for a value of 18, imitating the relationship between
550      * Ether and Wei.
551      *
552      * NOTE: This information is only used for _display_ purposes: it in
553      * no way affects any of the arithmetic of the contract, including
554      * {IERC20-balanceOf} and {IERC20-transfer}.
555      */
556     function decimals() public view returns (uint8) {
557         return _decimals;
558     }
559 }
560 
561 // File: contracts/Token.sol
562 
563 contract Token is ERC20, ERC20Detailed {
564 
565     constructor () public ERC20Detailed("TOK", "TOK", 8) {
566         _mint(msg.sender, 250000000 * (10 ** uint256(decimals())));
567     }
568 }