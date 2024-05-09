1 pragma solidity ^0.5.0;
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
153  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
154  * the optional functions; to access them see {ERC20Detailed}.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166 
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `recipient`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address recipient, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender) external view returns (uint256);
184 
185     /**
186      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * IMPORTANT: Beware that changing an allowance with this method brings the risk
191      * that someone may use both the old and the new allowance by unfortunate
192      * transaction ordering. One possible solution to mitigate this race
193      * condition is to first reduce the spender's allowance to 0 and set the
194      * desired value afterwards:
195      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address spender, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Moves `amount` tokens from `sender` to `recipient` using the
203      * allowance mechanism. `amount` is then deducted from the caller's
204      * allowance.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
211 
212     /**
213      * @dev Emitted when `value` tokens are moved from one account (`from`) to
214      * another (`to`).
215      *
216      * Note that `value` may be zero.
217      */
218     event Transfer(address indexed from, address indexed to, uint256 value);
219 
220     /**
221      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
222      * a call to {approve}. `value` is the new allowance.
223      */
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 /**
228  * @dev Optional functions from the ERC20 standard.
229  */
230 contract ERC20Detailed is IERC20 {
231     string private _name;
232     string private _symbol;
233     uint8 private _decimals;
234 
235     /**
236      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
237      * these values are immutable: they can only be set once during
238      * construction.
239      */
240     constructor (string memory name, string memory symbol, uint8 decimals) public {
241         _name = name;
242         _symbol = symbol;
243         _decimals = decimals;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei.
268      *
269      * NOTE: This information is only used for _display_ purposes: it in
270      * no way affects any of the arithmetic of the contract, including
271      * {IERC20-balanceOf} and {IERC20-transfer}.
272      */
273     function decimals() public view returns (uint8) {
274         return _decimals;
275     }
276 }
277 
278 /**
279  * @dev Implementation of the {IERC20} interface.
280  *
281  * This implementation is agnostic to the way tokens are created. This means
282  * that a supply mechanism has to be added in a derived contract using {_mint}.
283  * For a generic mechanism see {ERC20Mintable}.
284  *
285  * TIP: For a detailed writeup see our guide
286  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
287  * to implement supply mechanisms].
288  *
289  * We have followed general OpenZeppelin guidelines: functions revert instead
290  * of returning `false` on failure. This behavior is nonetheless conventional
291  * and does not conflict with the expectations of ERC20 applications.
292  *
293  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
294  * This allows applications to reconstruct the allowance for all accounts just
295  * by listening to said events. Other implementations of the EIP may not emit
296  * these events, as it isn't required by the specification.
297  *
298  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
299  * functions have been added to mitigate the well-known issues around setting
300  * allowances. See {IERC20-approve}.
301  */
302 contract ERC20 is IERC20 {
303     using SafeMath for uint256;
304 
305     mapping (address => uint256) internal _balances;
306 
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 internal _totalSupply;
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public returns (bool) {
334         _transfer(msg.sender, recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 value) public returns (bool) {
353         _approve(msg.sender, spender, value);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20};
362      *
363      * Requirements:
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `value`.
366      * - the caller must have allowance for `sender`'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
388         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
407         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
408         return true;
409     }
410 
411     /**
412      * @dev Moves tokens `amount` from `sender` to `recipient`.
413      *
414      * This is internal function is equivalent to {transfer}, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a {Transfer} event.
418      *
419      * Requirements:
420      *
421      * - `sender` cannot be the zero address.
422      * - `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      */
425     function _transfer(address sender, address recipient, uint256 amount) internal {
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428 
429         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
430         _balances[recipient] = _balances[recipient].add(amount);
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _totalSupply = _totalSupply.add(amount);
447         _balances[account] = _balances[account].add(amount);
448         emit Transfer(address(0), account, amount);
449     }
450 
451      /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 value) internal {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
466         _totalSupply = _totalSupply.sub(value);
467         emit Transfer(account, address(0), value);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
472      *
473      * This is internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(address owner, address spender, uint256 value) internal {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = value;
488         emit Approval(owner, spender, value);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
493      * from the caller's allowance.
494      *
495      * See {_burn} and {_approve}.
496      */
497     function _burnFrom(address account, uint256 amount) internal {
498         _burn(account, amount);
499         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
500     }
501 }
502 
503 contract CtokenTokenFix is ERC20Detailed, ERC20 {
504   uint private _commission = 10000000000000000;
505   address payable private _seller = 0xdC2DC0e9f3685516Fde4b2be035639553908490F;
506     
507   constructor(
508     string memory  _name,
509     string memory  _symbol,
510     uint8 _decimals,
511     uint256 _amount,
512     address _tokenOwner
513   )
514     ERC20Detailed(_name, _symbol, _decimals)
515     payable public
516   {
517     require(_amount > 0, "amount has to be greater than 0");
518     
519     require(msg.value >= _commission, "you need commission");
520     _seller.transfer(msg.value); // sends the funds to the seller
521     
522     _totalSupply = _amount.mul(10 ** uint256(_decimals));
523     _balances[_tokenOwner] = _totalSupply;
524     emit Transfer(address(0), _tokenOwner, _totalSupply);
525   }
526 }