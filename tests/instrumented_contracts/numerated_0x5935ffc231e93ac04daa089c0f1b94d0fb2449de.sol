1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Optional functions from the ERC20 standard.
80  */
81 contract ERC20Detailed is IERC20 {
82     string private _name;
83     string private _symbol;
84     uint8 private _decimals;
85 
86     /**
87      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
88      * these values are immutable: they can only be set once during
89      * construction.
90      */
91     constructor (string memory name, string memory symbol, uint8 decimals) public {
92         _name = name;
93         _symbol = symbol;
94         _decimals = decimals;
95     }
96 
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() public view returns (string memory) {
101         return _name;
102     }
103 
104     /**
105      * @dev Returns the symbol of the token, usually a shorter version of the
106      * name.
107      */
108     function symbol() public view returns (string memory) {
109         return _symbol;
110     }
111 
112     /**
113      * @dev Returns the number of decimals used to get its user representation.
114      * For example, if `decimals` equals `2`, a balance of `505` tokens should
115      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
116      *
117      * Tokens usually opt for a value of 18, imitating the relationship between
118      * Ether and Wei.
119      *
120      * NOTE: This information is only used for _display_ purposes: it in
121      * no way affects any of the arithmetic of the contract, including
122      * {IERC20-balanceOf} and {IERC20-transfer}.
123      */
124     function decimals() public view returns (uint8) {
125         return _decimals;
126     }
127 }
128 
129 /*
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with GSN meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 contract Context {
140     // Empty internal constructor, to prevent people from mistakenly deploying
141     // an instance of this contract, which should be used via inheritance.
142     constructor () internal { }
143     // solhint-disable-previous-line no-empty-blocks
144 
145     function _msgSender() internal view returns (address payable) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view returns (bytes memory) {
150         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
151         return msg.data;
152     }
153 }
154 
155 /**
156  * @dev Wrappers over Solidity's arithmetic operations with added overflow
157  * checks.
158  *
159  * Arithmetic operations in Solidity wrap on overflow. This can easily result
160  * in bugs, because programmers usually assume that an overflow raises an
161  * error, which is the standard behavior in high level programming languages.
162  * `SafeMath` restores this intuition by reverting the transaction when an
163  * operation overflows.
164  *
165  * Using this library instead of the unchecked operations eliminates an entire
166  * class of bugs, so it's recommended to use it always.
167  */
168 library SafeMath {
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      * - Addition cannot overflow.
177      */
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         require(c >= a, "SafeMath: addition overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return sub(a, b, "SafeMath: subtraction overflow");
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      * - Subtraction cannot overflow.
206      *
207      * _Available since v2.4.0._
208      */
209     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b <= a, errorMessage);
211         uint256 c = a - b;
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the multiplication of two unsigned integers, reverting on
218      * overflow.
219      *
220      * Counterpart to Solidity's `*` operator.
221      *
222      * Requirements:
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
227         // benefit is lost if 'b' is also tested.
228         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
229         if (a == 0) {
230             return 0;
231         }
232 
233         uint256 c = a * b;
234         require(c / a == b, "SafeMath: multiplication overflow");
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return div(a, b, "SafeMath: division by zero");
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      *
265      * _Available since v2.4.0._
266      */
267     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         // Solidity only automatically asserts when dividing by 0
269         require(b > 0, errorMessage);
270         uint256 c = a / b;
271         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
278      * Reverts when dividing by zero.
279      *
280      * Counterpart to Solidity's `%` operator. This function uses a `revert`
281      * opcode (which leaves remaining gas untouched) while Solidity uses an
282      * invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return mod(a, b, "SafeMath: modulo by zero");
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts with custom message when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      *
302      * _Available since v2.4.0._
303      */
304     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b != 0, errorMessage);
306         return a % b;
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
535 /**
536  * @dev Extension of {ERC20} that allows token holders to destroy both their own
537  * tokens and those that they have an allowance for, in a way that can be
538  * recognized off-chain (via event analysis).
539  */
540 contract ERC20Burnable is Context, ERC20 {
541     /**
542      * @dev Destroys `amount` tokens from the caller.
543      *
544      * See {ERC20-_burn}.
545      */
546     function burn(uint256 amount) public {
547         _burn(_msgSender(), amount);
548     }
549 
550     /**
551      * @dev See {ERC20-_burnFrom}.
552      */
553     function burnFrom(address account, uint256 amount) public {
554         _burnFrom(account, amount);
555     }
556 }
557 
558 /**
559  * @title Kanva Token
560  * @dev Implementation of the Kanva Token
561  */
562 contract KanvaToken is ERC20Detailed, ERC20Burnable {
563     /**
564      * @param receiver wallet who should receive all initial tokens
565      */
566     constructor(address receiver) public ERC20Detailed("Kanva", "KNV", 8) {
567         _mint(receiver, 48_000 * 1e8);
568     }
569 }