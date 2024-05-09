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
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
111  * the optional functions; to access them see `ERC20Detailed`.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a `Transfer` event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through `transferFrom`. This is
136      * zero by default.
137      *
138      * This value changes when `approve` or `transferFrom` are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * > Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an `Approval` event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a `Transfer` event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to `approve`. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using `_mint`.
189  * For a generic mechanism see `ERC20Mintable`.
190  *
191  * *For a detailed writeup see our guide [How to implement supply
192  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
193  *
194  * We have followed general OpenZeppelin guidelines: functions revert instead
195  * of returning `false` on failure. This behavior is nonetheless conventional
196  * and does not conflict with the expectations of ERC20 applications.
197  *
198  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
199  * This allows applications to reconstruct the allowance for all accounts just
200  * by listening to said events. Other implementations of the EIP may not emit
201  * these events, as it isn't required by the specification.
202  *
203  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
204  * functions have been added to mitigate the well-known issues around setting
205  * allowances. See `IERC20.approve`.
206  */
207 contract NODE is IERC20 {
208     using SafeMath for uint256;
209 
210     string private _name = "Whole Network Node";
211 
212     string private _symbol = "NODE";
213 
214     uint8 private _decimals = 5;      //How many decimals to show
215 
216     mapping (address => uint256) private _balances;
217 
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply = 10 ** 15; // total supply is 10^15 unit, equivalent to 10^10 NODE;
221 
222     constructor() public {
223         _balances[msg.sender] = _totalSupply;               // Give the creator all initial tokens
224     }
225 
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() public view returns (string memory) {
230         return _name;
231     }
232 
233     /**
234      * @dev Returns the symbol of the token, usually a shorter version of the
235      * name.
236      */
237     function symbol() public view returns (string memory) {
238         return _symbol;
239     }
240 
241     /**
242      * @dev Returns the number of decimals used to get its user representation.
243      * For example, if `decimals` equals `2`, a balance of `505` tokens should
244      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
245      *
246      * Tokens usually opt for a value of 18, imitating the relationship between
247      * Ether and Wei.
248      *
249      * > Note that this information is only used for _display_ purposes: it in
250      * no way affects any of the arithmetic of the contract, including
251      * `IERC20.balanceOf` and `IERC20.transfer`.
252      */
253     function decimals() public view returns (uint8) {
254         return _decimals;
255     }
256 
257     /**
258      * @dev See `IERC20.totalSupply`.
259      */
260     function totalSupply() public view returns (uint256) {
261         return _totalSupply;
262     }
263 
264     /**
265      * @dev See `IERC20.balanceOf`.
266      */
267     function balanceOf(address account) public view returns (uint256) {
268         return _balances[account];
269     }
270 
271     /**
272      * @dev See `IERC20.transfer`.
273      *
274      * Requirements:
275      *
276      * - `recipient` cannot be the zero address.
277      * - the caller must have a balance of at least `amount`.
278      */
279     function transfer(address recipient, uint256 amount) public returns (bool) {
280         _transfer(msg.sender, recipient, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See `IERC20.allowance`.
286      */
287     function allowance(address owner, address spender) public view returns (uint256) {
288         return _allowances[owner][spender];
289     }
290 
291     /**
292      * @dev See `IERC20.approve`.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function approve(address spender, uint256 value) public returns (bool) {
299         _approve(msg.sender, spender, value);
300         return true;
301     }
302 
303     /**
304      * @dev See `IERC20.transferFrom`.
305      *
306      * Emits an `Approval` event indicating the updated allowance. This is not
307      * required by the EIP. See the note at the beginning of `ERC20`;
308      *
309      * Requirements:
310      * - `sender` and `recipient` cannot be the zero address.
311      * - `sender` must have a balance of at least `value`.
312      * - the caller must have allowance for `sender`'s tokens of at least
313      * `amount`.
314      */
315     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
316         _transfer(sender, recipient, amount);
317         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
318         return true;
319     }
320 
321     /**
322      * @dev Atomically increases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to `approve` that can be used as a mitigation for
325      * problems described in `IERC20.approve`.
326      *
327      * Emits an `Approval` event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
334         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
335         return true;
336     }
337 
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to `approve` that can be used as a mitigation for
342      * problems described in `IERC20.approve`.
343      *
344      * Emits an `Approval` event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
353         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
354         return true;
355     }
356 
357     /**
358      * @dev Moves tokens `amount` from `sender` to `recipient`.
359      *
360      * This is internal function is equivalent to `transfer`, and can be used to
361      * e.g. implement automatic token fees, slashing mechanisms, etc.
362      *
363      * Emits a `Transfer` event.
364      *
365      * Requirements:
366      *
367      * - `sender` cannot be the zero address.
368      * - `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      */
371     function _transfer(address sender, address recipient, uint256 amount) internal {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _balances[sender] = _balances[sender].sub(amount);
376         _balances[recipient] = _balances[recipient].add(amount);
377         emit Transfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a `Transfer` event with `from` set to the zero address.
384      *
385      * Requirements
386      *
387      * - `to` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _totalSupply = _totalSupply.add(amount);
393         _balances[account] = _balances[account].add(amount);
394         emit Transfer(address(0), account, amount);
395     }
396 
397      /**
398      * @dev Destoys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a `Transfer` event with `to` set to the zero address.
402      *
403      * Requirements
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 value) internal {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _totalSupply = _totalSupply.sub(value);
412         _balances[account] = _balances[account].sub(value);
413         emit Transfer(account, address(0), value);
414     }
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
418      *
419      * This is internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an `Approval` event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(address owner, address spender, uint256 value) internal {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = value;
434         emit Approval(owner, spender, value);
435     }
436 
437     /**
438      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
439      * from the caller's allowance.
440      *
441      * See `_burn` and `_approve`.
442      */
443     function _burnFrom(address account, uint256 amount) internal {
444         _burn(account, amount);
445         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
446     }
447 
448     /**
449      * @dev Destroys `amount` tokens from the caller.
450      *
451      * See `_burn`.
452      */
453     function burn(uint256 amount) public {
454         _burn(msg.sender, amount);
455     }
456 }