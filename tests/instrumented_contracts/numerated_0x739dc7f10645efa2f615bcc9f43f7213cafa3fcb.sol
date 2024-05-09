1 pragma solidity ^0.5.12;
2 
3 /*
4  * Context.Sol
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 /**
31  * IERC20.sol
32  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
33  * the optional functions; to access them see {ERC20Detailed}.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 /**
107  * SafeMath.sol
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      *
159      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
160      * @dev Get it via `npm install @openzeppelin/contracts@next`.
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
218      * @dev Get it via `npm install @openzeppelin/contracts@next`.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
256      * @dev Get it via `npm install @openzeppelin/contracts@next`.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 /**
265  * ERC20.sol
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20Mintable}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * We have followed general OpenZeppelin guidelines: functions revert instead
277  * of returning `false` on failure. This behavior is nonetheless conventional
278  * and does not conflict with the expectations of ERC20 applications.
279  *
280  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
281  * This allows applications to reconstruct the allowance for all accounts just
282  * by listening to said events. Other implementations of the EIP may not emit
283  * these events, as it isn't required by the specification.
284  *
285  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
286  * functions have been added to mitigate the well-known issues around setting
287  * allowances. See {IERC20-approve}.
288  */
289 contract ERC20 is Context, IERC20 {
290     using SafeMath for uint256;
291 
292     mapping (address => uint256) private _balances;
293 
294     mapping (address => mapping (address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20};
349      *
350      * Requirements:
351      * - `sender` and `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      * - the caller must have allowance for `sender`'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
357         _transfer(sender, recipient, amount);
358         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
395         return true;
396     }
397 
398     /**
399      * @dev Moves tokens `amount` from `sender` to `recipient`.
400      *
401      * This is internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(address sender, address recipient, uint256 amount) internal {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `to` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _totalSupply = _totalSupply.add(amount);
434         _balances[account] = _balances[account].add(amount);
435         emit Transfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
453         _totalSupply = _totalSupply.sub(amount);
454         emit Transfer(account, address(0), amount);
455     }
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
459      *
460      * This is internal function is equivalent to `approve`, and can be used to
461      * e.g. set automatic allowances for certain subsystems, etc.
462      *
463      * Emits an {Approval} event.
464      *
465      * Requirements:
466      *
467      * - `owner` cannot be the zero address.
468      * - `spender` cannot be the zero address.
469      */
470     function _approve(address owner, address spender, uint256 amount) internal {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
480      * from the caller's allowance.
481      *
482      * See {_burn} and {_approve}.
483      */
484     function _burnFrom(address account, uint256 amount) internal {
485         _burn(account, amount);
486         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
487     }
488 }
489 
490 /**
491  * ERC20Detailed.sol
492  * @dev Optional functions from the ERC20 standard.
493  */
494 contract ERC20Detailed is IERC20 {
495     string private _name;
496     string private _symbol;
497     uint8 private _decimals;
498 
499     /**
500      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
501      * these values are immutable: they can only be set once during
502      * construction.
503      */
504     constructor (string memory name, string memory symbol, uint8 decimals) public {
505         _name = name;
506         _symbol = symbol;
507         _decimals = decimals;
508     }
509 
510     /**
511      * @dev Returns the name of the token.
512      */
513     function name() public view returns (string memory) {
514         return _name;
515     }
516 
517     /**
518      * @dev Returns the symbol of the token, usually a shorter version of the
519      * name.
520      */
521     function symbol() public view returns (string memory) {
522         return _symbol;
523     }
524 
525     /**
526      * @dev Returns the number of decimals used to get its user representation.
527      * For example, if `decimals` equals `2`, a balance of `505` tokens should
528      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
529      *
530      * Tokens usually opt for a value of 18, imitating the relationship between
531      * Ether and Wei.
532      *
533      * NOTE: This information is only used for _display_ purposes: it in
534      * no way affects any of the arithmetic of the contract, including
535      * {IERC20-balanceOf} and {IERC20-transfer}.
536      */
537     function decimals() public view returns (uint8) {
538         return _decimals;
539     }
540 }
541 
542 /**
543  * ERC20Burnable.sol
544  * @dev Extension of {ERC20} that allows token holders to destroy both their own
545  * tokens and those that they have an allowance for, in a way that can be
546  * recognized off-chain (via event analysis).
547  */
548 contract ERC20Burnable is Context, ERC20 {
549     /**
550      * @dev Destroys `amount` tokens from the caller.
551      *
552      * See {ERC20-_burn}.
553      */
554     function burn(uint256 amount) public {
555         _burn(_msgSender(), amount);
556     }
557 
558     /**
559      * @dev See {ERC20-_burnFrom}.
560      */
561     function burnFrom(address account, uint256 amount) public {
562         _burnFrom(account, amount);
563     }
564 }
565 
566 /**
567  * SimpleToken.sol
568  * @title SimpleToken
569  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
570  * Note they can later distribute these tokens as they wish using `transfer` and other
571  * `ERC20` functions.
572  */
573 contract SimpleToken is Context, ERC20, ERC20Detailed, ERC20Burnable{
574 
575     /**
576      * @dev Constructor that gives _msgSender() all of existing tokens.
577      */
578     constructor () public ERC20Detailed("builic", "BL", 18) {
579         _mint(_msgSender(), 6000000000 * (10 ** uint256(decimals())));
580     }
581 }