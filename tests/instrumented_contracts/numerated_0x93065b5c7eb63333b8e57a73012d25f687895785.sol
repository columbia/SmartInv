1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
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
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
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
59      * Emits a `Transfer` event.
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
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /**
80  * @dev Implementation of the `IERC20` interface.
81  *
82  * This implementation is agnostic to the way tokens are created. This means
83  * that a supply mechanism has to be added in a derived contract using `_mint`.
84  * For a generic mechanism see `ERC20Mintable`.
85  *
86  * *For a detailed writeup see our guide [How to implement supply
87  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
88  *
89  * We have followed general OpenZeppelin guidelines: functions revert instead
90  * of returning `false` on failure. This behavior is nonetheless conventional
91  * and does not conflict with the expectations of ERC20 applications.
92  *
93  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
94  * This allows applications to reconstruct the allowance for all accounts just
95  * by listening to said events. Other implementations of the EIP may not emit
96  * these events, as it isn't required by the specification.
97  *
98  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
99  * functions have been added to mitigate the well-known issues around setting
100  * allowances. See `IERC20.approve`.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     /**
112      * @dev See `IERC20.totalSupply`.
113      */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119      * @dev See `IERC20.balanceOf`.
120      */
121     function balanceOf(address account) public view returns (uint256) {
122         return _balances[account];
123     }
124 
125     /**
126      * @dev See `IERC20.transfer`.
127      *
128      * Requirements:
129      *
130      * - `recipient` cannot be the zero address.
131      * - the caller must have a balance of at least `amount`.
132      */
133     function transfer(address recipient, uint256 amount) public returns (bool) {
134         _transfer(msg.sender, recipient, amount);
135         return true;
136     }
137 
138     /**
139      * @dev See `IERC20.allowance`.
140      */
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowances[owner][spender];
143     }
144 
145     /**
146      * @dev See `IERC20.approve`.
147      *
148      * Requirements:
149      *
150      * - `spender` cannot be the zero address.
151      */
152     function approve(address spender, uint256 value) public returns (bool) {
153         _approve(msg.sender, spender, value);
154         return true;
155     }
156 
157     /**
158      * @dev See `IERC20.transferFrom`.
159      *
160      * Emits an `Approval` event indicating the updated allowance. This is not
161      * required by the EIP. See the note at the beginning of `ERC20`;
162      *
163      * Requirements:
164      * - `sender` and `recipient` cannot be the zero address.
165      * - `sender` must have a balance of at least `value`.
166      * - the caller must have allowance for `sender`'s tokens of at least
167      * `amount`.
168      */
169     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
170         _transfer(sender, recipient, amount);
171         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
172         return true;
173     }
174 
175     /**
176      * @dev Atomically increases the allowance granted to `spender` by the caller.
177      *
178      * This is an alternative to `approve` that can be used as a mitigation for
179      * problems described in `IERC20.approve`.
180      *
181      * Emits an `Approval` event indicating the updated allowance.
182      *
183      * Requirements:
184      *
185      * - `spender` cannot be the zero address.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
189         return true;
190     }
191 
192     /**
193      * @dev Atomically decreases the allowance granted to `spender` by the caller.
194      *
195      * This is an alternative to `approve` that can be used as a mitigation for
196      * problems described in `IERC20.approve`.
197      *
198      * Emits an `Approval` event indicating the updated allowance.
199      *
200      * Requirements:
201      *
202      * - `spender` cannot be the zero address.
203      * - `spender` must have allowance for the caller of at least
204      * `subtractedValue`.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
208         return true;
209     }
210 
211     /**
212      * @dev Moves tokens `amount` from `sender` to `recipient`.
213      *
214      * This is internal function is equivalent to `transfer`, and can be used to
215      * e.g. implement automatic token fees, slashing mechanisms, etc.
216      *
217      * Emits a `Transfer` event.
218      *
219      * Requirements:
220      *
221      * - `sender` cannot be the zero address.
222      * - `recipient` cannot be the zero address.
223      * - `sender` must have a balance of at least `amount`.
224      */
225     function _transfer(address sender, address recipient, uint256 amount) internal {
226         require(sender != address(0), "ERC20: transfer from the zero address");
227         require(recipient != address(0), "ERC20: transfer to the zero address");
228 
229         _balances[sender] = _balances[sender].sub(amount);
230         _balances[recipient] = _balances[recipient].add(amount);
231         emit Transfer(sender, recipient, amount);
232     }
233 
234     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
235      * the total supply.
236      *
237      * Emits a `Transfer` event with `from` set to the zero address.
238      *
239      * Requirements
240      *
241      * - `to` cannot be the zero address.
242      */
243     function _mint(address account, uint256 amount) internal {
244         require(account != address(0), "ERC20: mint to the zero address");
245 
246         _totalSupply = _totalSupply.add(amount);
247         _balances[account] = _balances[account].add(amount);
248         emit Transfer(address(0), account, amount);
249     }
250 
251      /**
252      * @dev Destoys `amount` tokens from `account`, reducing the
253      * total supply.
254      *
255      * Emits a `Transfer` event with `to` set to the zero address.
256      *
257      * Requirements
258      *
259      * - `account` cannot be the zero address.
260      * - `account` must have at least `amount` tokens.
261      */
262     function _burn(address account, uint256 value) internal {
263         require(account != address(0), "ERC20: burn from the zero address");
264 
265         _totalSupply = _totalSupply.sub(value);
266         _balances[account] = _balances[account].sub(value);
267         emit Transfer(account, address(0), value);
268     }
269 
270     /**
271      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
272      *
273      * This is internal function is equivalent to `approve`, and can be used to
274      * e.g. set automatic allowances for certain subsystems, etc.
275      *
276      * Emits an `Approval` event.
277      *
278      * Requirements:
279      *
280      * - `owner` cannot be the zero address.
281      * - `spender` cannot be the zero address.
282      */
283     function _approve(address owner, address spender, uint256 value) internal {
284         require(owner != address(0), "ERC20: approve from the zero address");
285         require(spender != address(0), "ERC20: approve to the zero address");
286 
287         _allowances[owner][spender] = value;
288         emit Approval(owner, spender, value);
289     }
290 
291     /**
292      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
293      * from the caller's allowance.
294      *
295      * See `_burn` and `_approve`.
296      */
297     function _burnFrom(address account, uint256 amount) internal {
298         _burn(account, amount);
299         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
300     }
301 }
302 
303 
304 /**
305  * @dev Wrappers over Solidity's arithmetic operations with added overflow
306  * checks.
307  *
308  * Arithmetic operations in Solidity wrap on overflow. This can easily result
309  * in bugs, because programmers usually assume that an overflow raises an
310  * error, which is the standard behavior in high level programming languages.
311  * `SafeMath` restores this intuition by reverting the transaction when an
312  * operation overflows.
313  *
314  * Using this library instead of the unchecked operations eliminates an entire
315  * class of bugs, so it's recommended to use it always.
316  */
317 library SafeMath {
318     /**
319      * @dev Returns the addition of two unsigned integers, reverting on
320      * overflow.
321      *
322      * Counterpart to Solidity's `+` operator.
323      *
324      * Requirements:
325      * - Addition cannot overflow.
326      */
327     function add(uint256 a, uint256 b) internal pure returns (uint256) {
328         uint256 c = a + b;
329         require(c >= a, "SafeMath: addition overflow");
330 
331         return c;
332     }
333 
334     /**
335      * @dev Returns the subtraction of two unsigned integers, reverting on
336      * overflow (when the result is negative).
337      *
338      * Counterpart to Solidity's `-` operator.
339      *
340      * Requirements:
341      * - Subtraction cannot overflow.
342      */
343     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
344         require(b <= a, "SafeMath: subtraction overflow");
345         uint256 c = a - b;
346 
347         return c;
348     }
349 
350     /**
351      * @dev Returns the multiplication of two unsigned integers, reverting on
352      * overflow.
353      *
354      * Counterpart to Solidity's `*` operator.
355      *
356      * Requirements:
357      * - Multiplication cannot overflow.
358      */
359     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
360         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
361         // benefit is lost if 'b' is also tested.
362         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
363         if (a == 0) {
364             return 0;
365         }
366 
367         uint256 c = a * b;
368         require(c / a == b, "SafeMath: multiplication overflow");
369 
370         return c;
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers. Reverts on
375      * division by zero. The result is rounded towards zero.
376      *
377      * Counterpart to Solidity's `/` operator. Note: this function uses a
378      * `revert` opcode (which leaves remaining gas untouched) while Solidity
379      * uses an invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      * - The divisor cannot be zero.
383      */
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         // Solidity only automatically asserts when dividing by 0
386         require(b > 0, "SafeMath: division by zero");
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * Reverts when dividing by zero.
396      *
397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
398      * opcode (which leaves remaining gas untouched) while Solidity uses an
399      * invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      * - The divisor cannot be zero.
403      */
404     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
405         require(b != 0, "SafeMath: modulo by zero");
406         return a % b;
407     }
408 }
409 
410 /**
411  * @dev Optional functions from the ERC20 standard.
412  */
413 contract ERC20Detailed is IERC20 {
414     string private _name;
415     string private _symbol;
416     uint8 private _decimals;
417 
418     /**
419      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
420      * these values are immutable: they can only be set once during
421      * construction.
422      */
423     constructor (string memory name, string memory symbol, uint8 decimals) public {
424         _name = name;
425         _symbol = symbol;
426         _decimals = decimals;
427     }
428 
429     /**
430      * @dev Returns the name of the token.
431      */
432     function name() public view returns (string memory) {
433         return _name;
434     }
435 
436     /**
437      * @dev Returns the symbol of the token, usually a shorter version of the
438      * name.
439      */
440     function symbol() public view returns (string memory) {
441         return _symbol;
442     }
443 
444     /**
445      * @dev Returns the number of decimals used to get its user representation.
446      * For example, if `decimals` equals `2`, a balance of `505` tokens should
447      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
448      *
449      * Tokens usually opt for a value of 18, imitating the relationship between
450      * Ether and Wei.
451      *
452      * > Note that this information is only used for _display_ purposes: it in
453      * no way affects any of the arithmetic of the contract, including
454      * `IERC20.balanceOf` and `IERC20.transfer`.
455      */
456     function decimals() public view returns (uint8) {
457         return _decimals;
458     }
459 }
460 
461 contract ColletrixToken is ERC20, ERC20Detailed {
462     uint256 public constant INITIAL_SUPPLY = 10 ** uint256(22) * 2;
463     uint256 public constant MAX_SUPPLY = 10 ** uint256(28) * 2;
464 
465     constructor () public ERC20Detailed("ColletrixToken", "CIPX", 18) {
466         owner = msg.sender;
467         _mint(msg.sender, INITIAL_SUPPLY);
468     }
469 
470     address public owner;
471 
472     modifier onlyOwner {
473         require(msg.sender == owner, "CIPX: Not the owner");
474         _;
475     }
476 
477     function () external payable{}
478 
479 	function transferOwnership(address newOwner) public onlyOwner {
480         if (newOwner != address(0)) {
481             owner = newOwner;
482         }
483     }
484 
485     function mintNew(uint256 amount) public onlyOwner {
486         require(MAX_SUPPLY >= totalSupply().add(amount), "CIPX: Can't have more token");
487         _mint(msg.sender, amount);
488     }
489 
490     function withdrawToken(address toAddress, uint256 amount) public onlyOwner {
491         require(balanceOf(address(this)) >= amount, "CIPX: Amount not enough");
492         require(toAddress != address(0), "CIPX: transfer to the zero address");
493         _transfer(address(this), toAddress, amount);
494     }
495 
496     function withdrawETH(address payable toAddress, uint256 amount) public onlyOwner {
497         require(address(this).balance >= amount, "CIPX: Amount not enough");
498         require(toAddress != address(0), "CIPX: transfer to the zero address");
499         toAddress.transfer(amount);
500     }
501 }