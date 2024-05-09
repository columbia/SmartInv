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
185  * @title HubToken
186  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
187  * Note they can later distribute these tokens as they wish using `transfer` and other
188  * `ERC20` functions.
189  */
190 contract HubToken is IERC20 {
191 
192     string private _name;
193     string private _symbol;
194     uint8 private _decimals;
195 
196     
197         using SafeMath for uint256;
198 
199     mapping (address => uint256) private _balances;
200 
201     mapping (address => mapping (address => uint256)) private _allowances;
202 
203     uint256 private _totalSupply;
204 
205     /**
206      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
207      * these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor () public {
211         _name = "Hub Exchange Token";
212         _symbol = "HUB";
213         _decimals = 18;
214         _mint(msg.sender, 1500000000 * (10 ** uint256(decimals())));
215     }
216 
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() public view returns (string memory) {
221         return _name;
222     }
223 
224     /**
225      * @dev Returns the symbol of the token, usually a shorter version of the
226      * name.
227      */
228     function symbol() public view returns (string memory) {
229         return _symbol;
230     }
231 
232     /**
233      * @dev Returns the number of decimals used to get its user representation.
234      * For example, if `decimals` equals `2`, a balance of `505` tokens should
235      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
236      *
237      * Tokens usually opt for a value of 18, imitating the relationship between
238      * Ether and Wei.
239      *
240      * > Note that this information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * `IERC20.balanceOf` and `IERC20.transfer`.
243      */
244     function decimals() public view returns (uint8) {
245         return _decimals;
246     }
247 
248 
249     /**
250      * @dev See `IERC20.totalSupply`.
251      */
252     function totalSupply() public view returns (uint256) {
253         return _totalSupply;
254     }
255 
256     /**
257      * @dev See `IERC20.balanceOf`.
258      */
259     function balanceOf(address account) public view returns (uint256) {
260         return _balances[account];
261     }
262 
263     /**
264      * @dev See `IERC20.transfer`.
265      *
266      * Requirements:
267      *
268      * - `recipient` cannot be the zero address.
269      * - the caller must have a balance of at least `amount`.
270      */
271     function transfer(address recipient, uint256 amount) public returns (bool) {
272         _transfer(msg.sender, recipient, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See `IERC20.allowance`.
278      */
279     function allowance(address owner, address spender) public view returns (uint256) {
280         return _allowances[owner][spender];
281     }
282 
283     /**
284      * @dev See `IERC20.approve`.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 value) public returns (bool) {
291         _approve(msg.sender, spender, value);
292         return true;
293     }
294 
295     /**
296      * @dev See `IERC20.transferFrom`.
297      *
298      * Emits an `Approval` event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of `ERC20`;
300      *
301      * Requirements:
302      * - `sender` and `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `value`.
304      * - the caller must have allowance for `sender`'s tokens of at least
305      * `amount`.
306      */
307     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
308         _transfer(sender, recipient, amount);
309         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to `approve` that can be used as a mitigation for
317      * problems described in `IERC20.approve`.
318      *
319      * Emits an `Approval` event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to `approve` that can be used as a mitigation for
334      * problems described in `IERC20.approve`.
335      *
336      * Emits an `Approval` event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
345         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
346         return true;
347     }
348 
349     /**
350      * @dev Moves tokens `amount` from `sender` to `recipient`.
351      *
352      * This is internal function is equivalent to `transfer`, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a `Transfer` event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(address sender, address recipient, uint256 amount) internal {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _balances[sender] = _balances[sender].sub(amount);
368         _balances[recipient] = _balances[recipient].add(amount);
369         emit Transfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a `Transfer` event with `from` set to the zero address.
376      *
377      * Requirements
378      *
379      * - `to` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _totalSupply = _totalSupply.add(amount);
385         _balances[account] = _balances[account].add(amount);
386         emit Transfer(address(0), account, amount);
387     }
388 
389      /**
390      * @dev Destoys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a `Transfer` event with `to` set to the zero address.
394      *
395      * Requirements
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 value) internal {
401         require(account != address(0), "ERC20: burn from the zero address");
402 
403         _totalSupply = _totalSupply.sub(value);
404         _balances[account] = _balances[account].sub(value);
405         emit Transfer(account, address(0), value);
406     }
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
410      *
411      * This is internal function is equivalent to `approve`, and can be used to
412      * e.g. set automatic allowances for certain subsystems, etc.
413      *
414      * Emits an `Approval` event.
415      *
416      * Requirements:
417      *
418      * - `owner` cannot be the zero address.
419      * - `spender` cannot be the zero address.
420      */
421     function _approve(address owner, address spender, uint256 value) internal {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = value;
426         emit Approval(owner, spender, value);
427     }
428 
429     /**
430      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
431      * from the caller's allowance.
432      *
433      * See `_burn` and `_approve`.
434      */
435     function _burnFrom(address account, uint256 amount) internal {
436         _burn(account, amount);
437         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
438     }
439 
440 }