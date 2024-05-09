1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      * - Subtraction cannot overflow.
80      *
81      * _Available since v2.4.0._
82      */
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      * - Multiplication cannot overflow.
98      */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
101         // benefit is lost if 'b' is also tested.
102         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
103         if (a == 0) {
104             return 0;
105         }
106 
107         uint256 c = a * b;
108         require(c / a == b, "SafeMath: multiplication overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      *
139      * _Available since v2.4.0._
140      */
141     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         // Solidity only automatically asserts when dividing by 0
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         return mod(a, b, "SafeMath: modulo by zero");
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts with custom message when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      *
176      * _Available since v2.4.0._
177      */
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
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
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
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
240      * Emits a {Transfer} event.
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
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 /**
260  * @dev Optional functions from the ERC20 standard.
261  */
262 contract ERC20Detailed is IERC20 {
263     string private _name;
264     string private _symbol;
265     uint8 private _decimals;
266 
267     /**
268      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
269      * these values are immutable: they can only be set once during
270      * construction.
271      */
272     constructor (string memory name, string memory symbol, uint8 decimals) public {
273         _name = name;
274         _symbol = symbol;
275         _decimals = decimals;
276     }
277 
278     /**
279      * @dev Returns the name of the token.
280      */
281     function name() public view returns (string memory) {
282         return _name;
283     }
284 
285     /**
286      * @dev Returns the symbol of the token, usually a shorter version of the
287      * name.
288      */
289     function symbol() public view returns (string memory) {
290         return _symbol;
291     }
292 
293     /**
294      * @dev Returns the number of decimals used to get its user representation.
295      * For example, if `decimals` equals `2`, a balance of `505` tokens should
296      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
297      *
298      * Tokens usually opt for a value of 18, imitating the relationship between
299      * Ether and Wei.
300      *
301      * NOTE: This information is only used for _display_ purposes: it in
302      * no way affects any of the arithmetic of the contract, including
303      * {IERC20-balanceOf} and {IERC20-transfer}.
304      */
305     function decimals() public view returns (uint8) {
306         return _decimals;
307     }
308 }
309 
310 /**
311  * @dev Implementation of the {IERC20} interface.
312  *
313  * This implementation is agnostic to the way tokens are created. This means
314  * that a supply mechanism has to be added in a derived contract using {_mint}.
315  * For a generic mechanism see {ERC20Mintable}.
316  *
317  * TIP: For a detailed writeup see our guide
318  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
319  * to implement supply mechanisms].
320  *
321  * We have followed general OpenZeppelin guidelines: functions revert instead
322  * of returning `false` on failure. This behavior is nonetheless conventional
323  * and does not conflict with the expectations of ERC20 applications.
324  *
325  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
326  * This allows applications to reconstruct the allowance for all accounts just
327  * by listening to said events. Other implementations of the EIP may not emit
328  * these events, as it isn't required by the specification.
329  *
330  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
331  * functions have been added to mitigate the well-known issues around setting
332  * allowances. See {IERC20-approve}.
333  */
334 contract ERC20 is Context, IERC20 {
335     using SafeMath for uint256;
336 
337     mapping (address => uint256) private _balances;
338 
339     mapping (address => mapping (address => uint256)) private _allowances;
340 
341     uint256 private _totalSupply;
342 
343     /**
344      * @dev See {IERC20-totalSupply}.
345      */
346     function totalSupply() public view returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account) public view returns (uint256) {
354         return _balances[account];
355     }
356 
357     /**
358      * @dev See {IERC20-transfer}.
359      *
360      * Requirements:
361      *
362      * - `recipient` cannot be the zero address.
363      * - the caller must have a balance of at least `amount`.
364      */
365     function transfer(address recipient, uint256 amount) public returns (bool) {
366         _transfer(_msgSender(), recipient, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-allowance}.
372      */
373     function allowance(address owner, address spender) public view returns (uint256) {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount) public returns (bool) {
385         _approve(_msgSender(), spender, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See {IERC20-transferFrom}.
391      *
392      * Emits an {Approval} event indicating the updated allowance. This is not
393      * required by the EIP. See the note at the beginning of {ERC20};
394      *
395      * Requirements:
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      * - the caller must have allowance for `sender`'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
402         _transfer(sender, recipient, amount);
403         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
439         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
440         return true;
441     }
442 
443     /**
444      * @dev Moves tokens `amount` from `sender` to `recipient`.
445      *
446      * This is internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `sender` cannot be the zero address.
454      * - `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      */
457     function _transfer(address sender, address recipient, uint256 amount) internal {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460 
461         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
462         _balances[recipient] = _balances[recipient].add(amount);
463         emit Transfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements
472      *
473      * - `to` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _totalSupply = _totalSupply.add(amount);
479         _balances[account] = _balances[account].add(amount);
480         emit Transfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint256 amount) internal {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
498         _totalSupply = _totalSupply.sub(amount);
499         emit Transfer(account, address(0), amount);
500     }
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
504      *
505      * This is internal function is equivalent to `approve`, and can be used to
506      * e.g. set automatic allowances for certain subsystems, etc.
507      *
508      * Emits an {Approval} event.
509      *
510      * Requirements:
511      *
512      * - `owner` cannot be the zero address.
513      * - `spender` cannot be the zero address.
514      */
515     function _approve(address owner, address spender, uint256 amount) internal {
516         require(owner != address(0), "ERC20: approve from the zero address");
517         require(spender != address(0), "ERC20: approve to the zero address");
518 
519         _allowances[owner][spender] = amount;
520         emit Approval(owner, spender, amount);
521     }
522 
523     /**
524      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
525      * from the caller's allowance.
526      *
527      * See {_burn} and {_approve}.
528      */
529     function _burnFrom(address account, uint256 amount) internal {
530         _burn(account, amount);
531         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
532     }
533 }
534 
535 contract SudanGoldCoin is Context, ERC20, ERC20Detailed {
536 
537     /**
538      * @dev Constructor that gives _msgSender() all of existing tokens.
539      */
540     constructor () public ERC20Detailed("SudanGoldCoin", "SGC", 18) {
541         _mint(_msgSender(), 999999999 * (10 ** uint256(decimals())));
542     }
543 }