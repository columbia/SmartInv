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
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20Mintable}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin guidelines: functions revert instead
239  * of returning `false` on failure. This behavior is nonetheless conventional
240  * and does not conflict with the expectations of ERC20 applications.
241  *
242  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
243  * This allows applications to reconstruct the allowance for all accounts just
244  * by listening to said events. Other implementations of the EIP may not emit
245  * these events, as it isn't required by the specification.
246  *
247  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
248  * functions have been added to mitigate the well-known issues around setting
249  * allowances. See {IERC20-approve}.
250  */
251 contract ERC20 is IERC20 {
252     using SafeMath for uint256;
253 
254     mapping (address => uint256) private _balances;
255 
256     mapping (address => mapping (address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     /**
261      * @dev See {IERC20-totalSupply}.
262      */
263     function totalSupply() public view returns (uint256) {
264         return _totalSupply;
265     }
266 
267     /**
268      * @dev See {IERC20-balanceOf}.
269      */
270     function balanceOf(address account) public view returns (uint256) {
271         return _balances[account];
272     }
273 
274     /**
275      * @dev See {IERC20-transfer}.
276      *
277      * Requirements:
278      *
279      * - `recipient` cannot be the zero address.
280      * - the caller must have a balance of at least `amount`.
281      */
282     function transfer(address recipient, uint256 amount) public returns (bool) {
283         _transfer(msg.sender, recipient, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-allowance}.
289      */
290     function allowance(address owner, address spender) public view returns (uint256) {
291         return _allowances[owner][spender];
292     }
293 
294     /**
295      * @dev See {IERC20-approve}.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function approve(address spender, uint256 value) public returns (bool) {
302         _approve(msg.sender, spender, value);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20};
311      *
312      * Requirements:
313      * - `sender` and `recipient` cannot be the zero address.
314      * - `sender` must have a balance of at least `value`.
315      * - the caller must have allowance for `sender`'s tokens of at least
316      * `amount`.
317      */
318     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
319         _transfer(sender, recipient, amount);
320         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
321         return true;
322     }
323 
324     /**
325      * @dev Atomically increases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
337         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
338         return true;
339     }
340 
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
356         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
357         return true;
358     }
359 
360     /**
361      * @dev Moves tokens `amount` from `sender` to `recipient`.
362      *
363      * This is internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `sender` cannot be the zero address.
371      * - `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      */
374     function _transfer(address sender, address recipient, uint256 amount) internal {
375         require(sender != address(0), "ERC20: transfer from the zero address");
376         require(recipient != address(0), "ERC20: transfer to the zero address");
377 
378         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
379         _balances[recipient] = _balances[recipient].add(amount);
380         emit Transfer(sender, recipient, amount);
381     }
382 
383     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
384      * the total supply.
385      *
386      * Emits a {Transfer} event with `from` set to the zero address.
387      *
388      * Requirements
389      *
390      * - `to` cannot be the zero address.
391      */
392     function _mint(address account, uint256 amount) internal {
393         require(account != address(0), "ERC20: mint to the zero address");
394 
395         _totalSupply = _totalSupply.add(amount);
396         _balances[account] = _balances[account].add(amount);
397         emit Transfer(address(0), account, amount);
398     }
399 
400      /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 value) internal {
412         require(account != address(0), "ERC20: burn from the zero address");
413 
414         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
415         _totalSupply = _totalSupply.sub(value);
416         emit Transfer(account, address(0), value);
417     }
418 
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
421      *
422      * This is internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(address owner, address spender, uint256 value) internal {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435 
436         _allowances[owner][spender] = value;
437         emit Approval(owner, spender, value);
438     }
439 
440     /**
441      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
442      * from the caller's allowance.
443      *
444      * See {_burn} and {_approve}.
445      */
446     function _burnFrom(address account, uint256 amount) internal {
447         _burn(account, amount);
448         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
449     }
450 }
451 
452 /**
453  * @dev Optional functions from the ERC20 standard.
454  */
455 contract ERC20Detailed is IERC20 {
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     /**
461      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
462      * these values are immutable: they can only be set once during
463      * construction.
464      */
465     constructor (string memory name, string memory symbol, uint8 decimals) public {
466         _name = name;
467         _symbol = symbol;
468         _decimals = decimals;
469     }
470 
471     /**
472      * @dev Returns the name of the token.
473      */
474     function name() public view returns (string memory) {
475         return _name;
476     }
477 
478     /**
479      * @dev Returns the symbol of the token, usually a shorter version of the
480      * name.
481      */
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     /**
487      * @dev Returns the number of decimals used to get its user representation.
488      * For example, if `decimals` equals `2`, a balance of `505` tokens should
489      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
490      *
491      * Tokens usually opt for a value of 18, imitating the relationship between
492      * Ether and Wei.
493      *
494      * NOTE: This information is only used for _display_ purposes: it in
495      * no way affects any of the arithmetic of the contract, including
496      * {IERC20-balanceOf} and {IERC20-transfer}.
497      */
498     function decimals() public view returns (uint8) {
499         return _decimals;
500     }
501 }
502 
503 contract TEPToken is ERC20, ERC20Detailed {
504 
505     /**
506      * @dev Constructor that gives msg.sender all of existing tokens.
507      */
508     constructor () public ERC20Detailed("Tepleton", "TEP", 8) {
509         _mint(msg.sender, 1000000000 * (10 ** uint256(decimals())));
510     }
511 }