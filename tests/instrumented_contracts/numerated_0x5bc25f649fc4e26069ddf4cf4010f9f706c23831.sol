1 pragma solidity 0.5.17;
2 
3 
4 /*
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
31  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
32  * the optional functions; to access them see {ERC20Detailed}.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      * - Subtraction cannot overflow.
156      *
157      * _Available since v2.4.0._
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      *
215      * _Available since v2.4.0._
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         // Solidity only automatically asserts when dividing by 0
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      * - The divisor cannot be zero.
251      *
252      * _Available since v2.4.0._
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 contract ERC20 is Context, IERC20 {
261     using SafeMath for uint256;
262 
263     mapping (address => uint256) private _balances;
264 
265     mapping (address => mapping (address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     /**
270      * @dev See {IERC20-totalSupply}.
271      */
272     function totalSupply() public view returns (uint256) {
273         return _totalSupply;
274     }
275 
276     /**
277      * @dev See {IERC20-balanceOf}.
278      */
279     function balanceOf(address account) public view returns (uint256) {
280         return _balances[account];
281     }
282 
283     /**
284      * @dev See {IERC20-transfer}.
285      *
286      * Requirements:
287      *
288      * - `recipient` cannot be the zero address.
289      * - the caller must have a balance of at least `amount`.
290      */
291     function transfer(address recipient, uint256 amount) public returns (bool) {
292         _transfer(_msgSender(), recipient, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-allowance}.
298      */
299     function allowance(address owner, address spender) public view returns (uint256) {
300         return _allowances[owner][spender];
301     }
302 
303     /**
304      * @dev See {IERC20-approve}.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function approve(address spender, uint256 amount) public returns (bool) {
311         _approve(_msgSender(), spender, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See {IERC20-transferFrom}.
317      *
318      * Emits an {Approval} event indicating the updated allowance. This is not
319      * required by the EIP. See the note at the beginning of {ERC20};
320      *
321      * Requirements:
322      * - `sender` and `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `amount`.
324      * - the caller must have allowance for `sender`'s tokens of at least
325      * `amount`.
326      */
327     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
365         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
366         return true;
367     }
368 
369     /**
370      * @dev Moves tokens `amount` from `sender` to `recipient`.
371      *
372      * This is internal function is equivalent to {transfer}, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a {Transfer} event.
376      *
377      * Requirements:
378      *
379      * - `sender` cannot be the zero address.
380      * - `recipient` cannot be the zero address.
381      * - `sender` must have a balance of at least `amount`.
382      */
383     function _transfer(address sender, address recipient, uint256 amount) internal {
384         require(sender != address(0), "ERC20: transfer from the zero address");
385         require(recipient != address(0), "ERC20: transfer to the zero address");
386 
387         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
388         _balances[recipient] = _balances[recipient].add(amount);
389         emit Transfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements
398      *
399      * - `to` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _totalSupply = _totalSupply.add(amount);
405         _balances[account] = _balances[account].add(amount);
406         emit Transfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
424         _totalSupply = _totalSupply.sub(amount);
425         emit Transfer(account, address(0), amount);
426     }
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
430      *
431      * This is internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an {Approval} event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(address owner, address spender, uint256 amount) internal {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = amount;
446         emit Approval(owner, spender, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
451      * from the caller's allowance.
452      *
453      * See {_burn} and {_approve}.
454      */
455     function _burnFrom(address account, uint256 amount) internal {
456         _burn(account, amount);
457         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
458     }
459 }
460 
461 contract ERC20Detailed is IERC20 {
462     string private _name;
463     string private _symbol;
464     uint8 private _decimals;
465 
466     /**
467      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
468      * these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor (string memory name, string memory symbol, uint8 decimals) public {
472         _name = name;
473         _symbol = symbol;
474         _decimals = decimals;
475     }
476 
477     /**
478      * @dev Returns the name of the token.
479      */
480     function name() public view returns (string memory) {
481         return _name;
482     }
483 
484     /**
485      * @dev Returns the symbol of the token, usually a shorter version of the
486      * name.
487      */
488     function symbol() public view returns (string memory) {
489         return _symbol;
490     }
491 
492     /**
493      * @dev Returns the number of decimals used to get its user representation.
494      * For example, if `decimals` equals `2`, a balance of `505` tokens should
495      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
496      *
497      * Tokens usually opt for a value of 18, imitating the relationship between
498      * Ether and Wei.
499      *
500      * NOTE: This information is only used for _display_ purposes: it in
501      * no way affects any of the arithmetic of the contract, including
502      * {IERC20-balanceOf} and {IERC20-transfer}.
503      */
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 }
508 
509 contract DUSD is ERC20, ERC20Detailed {
510     address public core;
511 
512     constructor(address _core, string memory _name, string memory _symbol, uint8 _decimals)
513         public
514         ERC20Detailed(_name, _symbol, _decimals)
515     {
516         core = _core;
517     }
518 
519     modifier onlyCore() {
520         require(msg.sender == core, "Not authorized");
521         _;
522     }
523 
524     function mint(address account, uint amount) public onlyCore {
525         _mint(account, amount);
526     }
527 
528     function burn(address account, uint amount) public onlyCore {
529         _burn(account, amount);
530     }
531 
532     function burnForSelf(uint amount) external {
533         _burn(msg.sender, amount);
534     }
535 }