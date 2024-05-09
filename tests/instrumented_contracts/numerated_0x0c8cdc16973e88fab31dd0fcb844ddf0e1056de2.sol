1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, "SafeMath: division by zero");
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95      * Reverts when dividing by zero.
96      *
97      * Counterpart to Solidity's `%` operator. This function uses a `revert`
98      * opcode (which leaves remaining gas untouched) while Solidity uses an
99      * invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "SafeMath: modulo by zero");
106         return a % b;
107     }
108 }
109 
110 contract Owned {
111 
112     address public owner;
113 
114     event OwnerChanged(address indexed _owner);
115 
116     modifier onlyOwner {
117         require(msg.sender == owner, "Must be owner");
118         _;
119     }
120 
121     constructor() public {
122         owner = msg.sender;
123     }
124 
125     function setOwner(address _owner) external onlyOwner {
126         require(_owner != address(0), "new owner must not be null");
127         owner = _owner;
128         emit OwnerChanged(_owner);
129     }
130 
131 }
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
135  * the optional functions; to access them see `ERC20Detailed`.
136  */
137 interface IERC20 {
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a `Transfer` event.
154      */
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through `transferFrom`. This is
160      * zero by default.
161      *
162      * This value changes when `approve` or `transferFrom` are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * > Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an `Approval` event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a `Transfer` event.
190      */
191     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to `approve`. `value` is the new allowance.
204      */
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 /**
209  * @dev Implementation of the `IERC20` interface.
210  *
211  * This implementation is agnostic to the way tokens are created. This means
212  * that a supply mechanism has to be added in a derived contract using `_mint`.
213  * For a generic mechanism see `ERC20Mintable`.
214  *
215  * *For a detailed writeup see our guide [How to implement supply
216  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
217  *
218  * We have followed general OpenZeppelin guidelines: functions revert instead
219  * of returning `false` on failure. This behavior is nonetheless conventional
220  * and does not conflict with the expectations of ERC20 applications.
221  *
222  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
223  * This allows applications to reconstruct the allowance for all accounts just
224  * by listening to said events. Other implementations of the EIP may not emit
225  * these events, as it isn't required by the specification.
226  *
227  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
228  * functions have been added to mitigate the well-known issues around setting
229  * allowances. See `IERC20.approve`.
230  */
231 contract ERC20 is IERC20 {
232     using SafeMath for uint256;
233 
234     mapping (address => uint256) private _balances;
235 
236     mapping (address => mapping (address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     /**
241      * @dev See `IERC20.totalSupply`.
242      */
243     function totalSupply() public view returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See `IERC20.balanceOf`.
249      */
250     function balanceOf(address account) public view returns (uint256) {
251         return _balances[account];
252     }
253 
254     /**
255      * @dev See `IERC20.transfer`.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public returns (bool) {
263         _transfer(msg.sender, recipient, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See `IERC20.allowance`.
269      */
270     function allowance(address owner, address spender) public view returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See `IERC20.approve`.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 value) public returns (bool) {
282         _approve(msg.sender, spender, value);
283         return true;
284     }
285 
286     /**
287      * @dev See `IERC20.transferFrom`.
288      *
289      * Emits an `Approval` event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of `ERC20`;
291      *
292      * Requirements:
293      * - `sender` and `recipient` cannot be the zero address.
294      * - `sender` must have a balance of at least `value`.
295      * - the caller must have allowance for `sender`'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
299         _transfer(sender, recipient, amount);
300         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to `approve` that can be used as a mitigation for
308      * problems described in `IERC20.approve`.
309      *
310      * Emits an `Approval` event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
317         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to `approve` that can be used as a mitigation for
325      * problems described in `IERC20.approve`.
326      *
327      * Emits an `Approval` event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
336         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
337         return true;
338     }
339 
340     /**
341      * @dev Moves tokens `amount` from `sender` to `recipient`.
342      *
343      * This is internal function is equivalent to `transfer`, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a `Transfer` event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      */
354     function _transfer(address sender, address recipient, uint256 amount) internal {
355         require(sender != address(0), "ERC20: transfer from the zero address");
356         require(recipient != address(0), "ERC20: transfer to the zero address");
357 
358         _balances[sender] = _balances[sender].sub(amount);
359         _balances[recipient] = _balances[recipient].add(amount);
360         emit Transfer(sender, recipient, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a `Transfer` event with `from` set to the zero address.
367      *
368      * Requirements
369      *
370      * - `to` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _totalSupply = _totalSupply.add(amount);
376         _balances[account] = _balances[account].add(amount);
377         emit Transfer(address(0), account, amount);
378     }
379 
380      /**
381      * @dev Destroys `amount` tokens from `account`, reducing the
382      * total supply.
383      *
384      * Emits a `Transfer` event with `to` set to the zero address.
385      *
386      * Requirements
387      *
388      * - `account` cannot be the zero address.
389      * - `account` must have at least `amount` tokens.
390      */
391     function _burn(address account, uint256 value) internal {
392         require(account != address(0), "ERC20: burn from the zero address");
393 
394         _totalSupply = _totalSupply.sub(value);
395         _balances[account] = _balances[account].sub(value);
396         emit Transfer(account, address(0), value);
397     }
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
401      *
402      * This is internal function is equivalent to `approve`, and can be used to
403      * e.g. set automatic allowances for certain subsystems, etc.
404      *
405      * Emits an `Approval` event.
406      *
407      * Requirements:
408      *
409      * - `owner` cannot be the zero address.
410      * - `spender` cannot be the zero address.
411      */
412     function _approve(address owner, address spender, uint256 value) internal {
413         require(owner != address(0), "ERC20: approve from the zero address");
414         require(spender != address(0), "ERC20: approve to the zero address");
415 
416         _allowances[owner][spender] = value;
417         emit Approval(owner, spender, value);
418     }
419 
420     /**
421      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
422      * from the caller's allowance.
423      *
424      * See `_burn` and `_approve`.
425      */
426     function _burnFrom(address account, uint256 amount) internal {
427         _burn(account, amount);
428         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
429     }
430 }
431 
432 contract RaffleTicket is Owned, ERC20 {
433     
434     string public constant name = "Genesis Raffle Token";
435     string public constant symbol = "GRT";
436     uint8 public constant decimals = 0;
437 
438     mapping(address => bool) minters;
439 
440     event MinterApprovalChanged(address indexed minter, bool approved);
441 
442     modifier onlyMinter {
443         require(minters[msg.sender], "must be an approved minter");
444         _;
445     }
446 
447     function mint(address[] memory accounts, uint32[] memory amounts) public onlyMinter {
448 
449         uint len = accounts.length;
450         require(len > 0, "must be at least one account");
451         require(len == amounts.length, "must be the same number of accounts and amounts");
452 
453         for (uint i = 0; i < len; i++) {
454             _mint(accounts[i], amounts[i]);
455         }
456     }
457 
458     function changeMinterApproval(address minter, bool approved) public onlyOwner {
459         minters[minter] = approved;
460         emit MinterApprovalChanged(minter, approved);
461     }
462 
463 }