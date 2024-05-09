1 pragma solidity 0.5.11;
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
78 
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with GSN meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 contract Context {
90     // Empty internal constructor, to prevent people from mistakenly deploying
91     // an instance of this contract, which should be used via inheritance.
92     constructor () internal { }
93     // solhint-disable-previous-line no-empty-blocks
94 
95     function _msgSender() internal view returns (address payable) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view returns (bytes memory) {
100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
101         return msg.data;
102     }
103 }
104 
105 
106 
107 
108 
109 
110 /**
111  * @dev Optional functions from the ERC20 standard.
112  */
113 contract ERC20Detailed is IERC20 {
114     string private _name;
115     string private _symbol;
116     uint8 private _decimals;
117 
118     /**
119      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
120      * these values are immutable: they can only be set once during
121      * construction.
122      */
123     constructor (string memory name, string memory symbol, uint8 decimals) public {
124         _name = name;
125         _symbol = symbol;
126         _decimals = decimals;
127     }
128 
129     /**
130      * @dev Returns the name of the token.
131      */
132     function name() public view returns (string memory) {
133         return _name;
134     }
135 
136     /**
137      * @dev Returns the symbol of the token, usually a shorter version of the
138      * name.
139      */
140     function symbol() public view returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @dev Returns the number of decimals used to get its user representation.
146      * For example, if `decimals` equals `2`, a balance of `505` tokens should
147      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
148      *
149      * Tokens usually opt for a value of 18, imitating the relationship between
150      * Ether and Wei.
151      *
152      * NOTE: This information is only used for _display_ purposes: it in
153      * no way affects any of the arithmetic of the contract, including
154      * {IERC20-balanceOf} and {IERC20-transfer}.
155      */
156     function decimals() public view returns (uint8) {
157         return _decimals;
158     }
159 }
160 
161 
162 
163 
164 
165 
166 
167 
168 
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      *
222      * _Available since v2.4.0._
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 /**
327  * @dev Implementation of the {IERC20} interface.
328  *
329  * This implementation is agnostic to the way tokens are created. This means
330  * that a supply mechanism has to be added in a derived contract using {_mint}.
331  * For a generic mechanism see {ERC20Mintable}.
332  *
333  * TIP: For a detailed writeup see our guide
334  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
335  * to implement supply mechanisms].
336  *
337  * We have followed general OpenZeppelin guidelines: functions revert instead
338  * of returning `false` on failure. This behavior is nonetheless conventional
339  * and does not conflict with the expectations of ERC20 applications.
340  *
341  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
342  * This allows applications to reconstruct the allowance for all accounts just
343  * by listening to said events. Other implementations of the EIP may not emit
344  * these events, as it isn't required by the specification.
345  *
346  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
347  * functions have been added to mitigate the well-known issues around setting
348  * allowances. See {IERC20-approve}.
349  */
350 contract ERC20 is Context, IERC20 {
351     using SafeMath for uint256;
352 
353     mapping (address => uint256) private _balances;
354 
355     mapping (address => mapping (address => uint256)) private _allowances;
356 
357     uint256 private _totalSupply;
358 
359     /**
360      * @dev See {IERC20-totalSupply}.
361      */
362     function totalSupply() public view returns (uint256) {
363         return _totalSupply;
364     }
365 
366     /**
367      * @dev See {IERC20-balanceOf}.
368      */
369     function balanceOf(address account) public view returns (uint256) {
370         return _balances[account];
371     }
372 
373     /**
374      * @dev See {IERC20-transfer}.
375      *
376      * Requirements:
377      *
378      * - `recipient` cannot be the zero address.
379      * - the caller must have a balance of at least `amount`.
380      */
381     function transfer(address recipient, uint256 amount) public returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-allowance}.
388      */
389     function allowance(address owner, address spender) public view returns (uint256) {
390         return _allowances[owner][spender];
391     }
392 
393     /**
394      * @dev See {IERC20-approve}.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount) public returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-transferFrom}.
407      *
408      * Emits an {Approval} event indicating the updated allowance. This is not
409      * required by the EIP. See the note at the beginning of {ERC20};
410      *
411      * Requirements:
412      * - `sender` and `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      * - the caller must have allowance for `sender`'s tokens of at least
415      * `amount`.
416      */
417     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     /**
424      * @dev Atomically increases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      */
435     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
436         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
437         return true;
438     }
439 
440     /**
441      * @dev Atomically decreases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `spender` must have allowance for the caller of at least
452      * `subtractedValue`.
453      */
454     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
456         return true;
457     }
458 
459     /**
460      * @dev Moves tokens `amount` from `sender` to `recipient`.
461      *
462      * This is internal function is equivalent to {transfer}, and can be used to
463      * e.g. implement automatic token fees, slashing mechanisms, etc.
464      *
465      * Emits a {Transfer} event.
466      *
467      * Requirements:
468      *
469      * - `sender` cannot be the zero address.
470      * - `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      */
473     function _transfer(address sender, address recipient, uint256 amount) internal {
474         require(sender != address(0), "ERC20: transfer from the zero address");
475         require(recipient != address(0), "ERC20: transfer to the zero address");
476 
477         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
478         _balances[recipient] = _balances[recipient].add(amount);
479         emit Transfer(sender, recipient, amount);
480     }
481 
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements
488      *
489      * - `to` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _totalSupply = _totalSupply.add(amount);
495         _balances[account] = _balances[account].add(amount);
496         emit Transfer(address(0), account, amount);
497     }
498 
499      /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
514         _totalSupply = _totalSupply.sub(amount);
515         emit Transfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
520      *
521      * This is internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(address owner, address spender, uint256 amount) internal {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
541      * from the caller's allowance.
542      *
543      * See {_burn} and {_approve}.
544      */
545     function _burnFrom(address account, uint256 amount) internal {
546         _burn(account, amount);
547         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
548     }
549 }
550 
551 
552 /**
553  * @dev Extension of {ERC20} that allows token holders to destroy both their own
554  * tokens and those that they have an allowance for, in a way that can be
555  * recognized off-chain (via event analysis).
556  */
557 contract ERC20Burnable is Context, ERC20 {
558     /**
559      * @dev Destroys `amount` tokens from the caller.
560      *
561      * See {ERC20-_burn}.
562      */
563     function burn(uint256 amount) public {
564         _burn(_msgSender(), amount);
565     }
566 
567     /**
568      * @dev See {ERC20-_burnFrom}.
569      */
570     function burnFrom(address account, uint256 amount) public {
571         _burnFrom(account, amount);
572     }
573 }
574 
575 
576 contract UPIToken is ERC20Detailed,  ERC20Burnable {
577   
578     uint256 constant private _INITIAL_SUPPLY = 1000000000 ether;
579     
580     constructor() 
581     	ERC20Detailed("Pawtocol Network UPI Token", "UPI", 18) 
582     	public
583     {
584     	_mint(msg.sender, _INITIAL_SUPPLY);
585     }
586     
587 }