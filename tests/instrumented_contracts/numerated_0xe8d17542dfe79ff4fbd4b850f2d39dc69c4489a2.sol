1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
6  * the optional functions; to access them see {ERC20Detailed}.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Optional functions from the ERC20 standard.
81  */
82 contract ERC20Detailed is IERC20 {
83     string private _name;
84     string private _symbol;
85     uint8 private _decimals;
86 
87     /**
88      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
89      * these values are immutable: they can only be set once during
90      * construction.
91      */
92     constructor (string memory name, string memory symbol, uint8 decimals) public {
93         _name = name;
94         _symbol = symbol;
95         _decimals = decimals;
96     }
97 
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() public view returns (string memory) {
102         return _name;
103     }
104 
105     /**
106      * @dev Returns the symbol of the token, usually a shorter version of the
107      * name.
108      */
109     function symbol() public view returns (string memory) {
110         return _symbol;
111     }
112 
113     /**
114      * @dev Returns the number of decimals used to get its user representation.
115      * For example, if `decimals` equals `2`, a balance of `505` tokens should
116      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
117      *
118      * Tokens usually opt for a value of 18, imitating the relationship between
119      * Ether and Wei.
120      *
121      * NOTE: This information is only used for _display_ purposes: it in
122      * no way affects any of the arithmetic of the contract, including
123      * {IERC20-balanceOf} and {IERC20-transfer}.
124      */
125     function decimals() public view returns (uint8) {
126         return _decimals;
127     }
128 }
129 
130 /*
131  * @dev Provides information about the current execution context, including the
132  * sender of the transaction and its data. While these are generally available
133  * via msg.sender and msg.data, they should not be accessed in such a direct
134  * manner, since when dealing with GSN meta-transactions the account sending and
135  * paying for execution may not be the actual sender (as far as an application
136  * is concerned).
137  *
138  * This contract is only required for intermediate, library-like contracts.
139  */
140 contract Context {
141     // Empty internal constructor, to prevent people from mistakenly deploying
142     // an instance of this contract, which should be used via inheritance.
143     constructor () internal { }
144     // solhint-disable-previous-line no-empty-blocks
145 
146     function _msgSender() internal view returns (address payable) {
147         return msg.sender;
148     }
149 
150     function _msgData() internal view returns (bytes memory) {
151         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
152         return msg.data;
153     }
154 }
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
181         require(c >= a, "SafeMath: addition overflow");
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
196         return sub(a, b, "SafeMath: subtraction overflow");
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
235         require(c / a == b, "SafeMath: multiplication overflow");
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
252         return div(a, b, "SafeMath: division by zero");
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
289         return mod(a, b, "SafeMath: modulo by zero");
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
311 /**
312  * @dev Implementation of the {IERC20} interface.
313  *
314  * This implementation is agnostic to the way tokens are created. This means
315  * that a supply mechanism has to be added in a derived contract using {_mint}.
316  * For a generic mechanism see {ERC20Mintable}.
317  *
318  * TIP: For a detailed writeup see our guide
319  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
320  * to implement supply mechanisms].
321  *
322  * We have followed general OpenZeppelin guidelines: functions revert instead
323  * of returning `false` on failure. This behavior is nonetheless conventional
324  * and does not conflict with the expectations of ERC20 applications.
325  *
326  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
327  * This allows applications to reconstruct the allowance for all accounts just
328  * by listening to said events. Other implementations of the EIP may not emit
329  * these events, as it isn't required by the specification.
330  *
331  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
332  * functions have been added to mitigate the well-known issues around setting
333  * allowances. See {IERC20-approve}.
334  */
335 contract ERC20 is Context, IERC20 {
336     using SafeMath for uint256;
337 
338     mapping (address => uint256) private _balances;
339 
340     mapping (address => mapping (address => uint256)) private _allowances;
341 
342     uint256 private _totalSupply;
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `recipient` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address recipient, uint256 amount) public returns (bool) {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender) public view returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     /**
379      * @dev See {IERC20-approve}.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function approve(address spender, uint256 amount) public returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20};
395      *
396      * Requirements:
397      * - `sender` and `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      * - the caller must have allowance for `sender`'s tokens of at least
400      * `amount`.
401      */
402     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
403         _transfer(sender, recipient, amount);
404         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
441         return true;
442     }
443 
444     /**
445      * @dev Moves tokens `amount` from `sender` to `recipient`.
446      *
447      * This is internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(address sender, address recipient, uint256 amount) internal {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
463         _balances[recipient] = _balances[recipient].add(amount);
464         emit Transfer(sender, recipient, amount);
465     }
466 
467     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
468      * the total supply.
469      *
470      * Emits a {Transfer} event with `from` set to the zero address.
471      *
472      * Requirements
473      *
474      * - `to` cannot be the zero address.
475      */
476     function _mint(address account, uint256 amount) internal {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _totalSupply = _totalSupply.add(amount);
480         _balances[account] = _balances[account].add(amount);
481         emit Transfer(address(0), account, amount);
482     }
483 
484      /**
485      * @dev Destroys `amount` tokens from `account`, reducing the
486      * total supply.
487      *
488      * Emits a {Transfer} event with `to` set to the zero address.
489      *
490      * Requirements
491      *
492      * - `account` cannot be the zero address.
493      * - `account` must have at least `amount` tokens.
494      */
495     function _burn(address account, uint256 amount) internal {
496         require(account != address(0), "ERC20: burn from the zero address");
497 
498         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
499         _totalSupply = _totalSupply.sub(amount);
500         emit Transfer(account, address(0), amount);
501     }
502 
503     /**
504      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
505      *
506      * This is internal function is equivalent to `approve`, and can be used to
507      * e.g. set automatic allowances for certain subsystems, etc.
508      *
509      * Emits an {Approval} event.
510      *
511      * Requirements:
512      *
513      * - `owner` cannot be the zero address.
514      * - `spender` cannot be the zero address.
515      */
516     function _approve(address owner, address spender, uint256 amount) internal {
517         require(owner != address(0), "ERC20: approve from the zero address");
518         require(spender != address(0), "ERC20: approve to the zero address");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     /**
525      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
526      * from the caller's allowance.
527      *
528      * See {_burn} and {_approve}.
529      */
530     function _burnFrom(address account, uint256 amount) internal {
531         _burn(account, amount);
532         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
533     }
534 }
535 
536 /**
537  * @title KMPL ERC20 token
538  */
539 contract KiloAmple is ERC20Detailed, ERC20 {
540     string private constant TOKEN = "KiloAmple";
541     string private constant SYMBOL = "kMPL";
542     uint256 private constant DECIMALS = 9;
543     uint256 private constant TOTAL_SUPPLY = 51000 * 10**DECIMALS;
544 
545     constructor()  ERC20Detailed(TOKEN, SYMBOL, uint8(DECIMALS)) public {
546         _mint(msg.sender, TOTAL_SUPPLY);
547     }
548 }