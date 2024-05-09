1 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 /**
196  * @dev Implementation of the `IERC20` interface.
197  *
198  * *For a detailed writeup see our guide [How to implement supply
199  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
200  *
201  * We have followed general OpenZeppelin guidelines: functions revert instead
202  * of returning `false` on failure. This behavior is nonetheless conventional
203  * and does not conflict with the expectations of ERC20 applications.
204  *
205  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
206  * This allows applications to reconstruct the allowance for all accounts just
207  * by listening to said events. Other implementations of the EIP may not emit
208  * these events, as it isn't required by the specification.
209  *
210  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
211  * functions have been added to mitigate the well-known issues around setting
212  * allowances. See `IERC20.approve`.
213  */
214 contract ERC20 is IERC20 {
215     using SafeMath for uint256;
216 
217     mapping (address => uint256) private _balances;
218 
219     mapping (address => mapping (address => uint256)) private _allowances;
220 
221     uint256 private _totalSupply;
222 
223     /**
224      * @dev See `IERC20.totalSupply`.
225      */
226     function totalSupply() public view returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See `IERC20.balanceOf`.
232      */
233     function balanceOf(address account) public view returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See `IERC20.transfer`.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public returns (bool) {
246         _transfer(msg.sender, recipient, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See `IERC20.allowance`.
252      */
253     function allowance(address owner, address spender) public view returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See `IERC20.approve`.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 value) public returns (bool) {
265         _approve(msg.sender, spender, value);
266         return true;
267     }
268 
269     /**
270      * @dev See `IERC20.transferFrom`.
271      *
272      * Emits an `Approval` event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of `ERC20`;
274      *
275      * Requirements:
276      * - `sender` and `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `value`.
278      * - the caller must have allowance for `sender`'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
282         _transfer(sender, recipient, amount);
283         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to `approve` that can be used as a mitigation for
291      * problems described in `IERC20.approve`.
292      *
293      * Emits an `Approval` event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
300         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to `approve` that can be used as a mitigation for
308      * problems described in `IERC20.approve`.
309      *
310      * Emits an `Approval` event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
319         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Moves tokens `amount` from `sender` to `recipient`.
325      *
326      * This is internal function is equivalent to `transfer`, and can be used to
327      * e.g. implement automatic token fees, slashing mechanisms, etc.
328      *
329      * Emits a `Transfer` event.
330      *
331      * Requirements:
332      *
333      * - `sender` cannot be the zero address.
334      * - `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      */
337     function _transfer(address sender, address recipient, uint256 amount) internal {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _balances[sender] = _balances[sender].sub(amount);
342         _balances[recipient] = _balances[recipient].add(amount);
343         emit Transfer(sender, recipient, amount);
344     }
345 
346     /** @dev Creates `amount` tokens and assigns them to `account`, initializing
347      * the total supply. This is only called once from constructor at contract creation
348      *
349      * Emits a `Transfer` event with `from` set to the zero address.
350      *
351      * Requirements
352      *
353      * - `to` cannot be the zero address.
354      */
355     function _initSupply(address account, uint256 amount) internal {
356         require(account != address(0), "ERC20: supply cannot be initiatlized at zero address");
357 
358         _totalSupply = _totalSupply.add(amount);
359         _balances[account] = _balances[account].add(amount);
360         emit Transfer(address(0), account, amount);
361     }
362 
363 
364      /**
365      * @dev Destroys `amount` tokens from `account`, reducing the
366      * total supply.
367      *
368      * Emits a `Transfer` event with `to` set to the zero address.
369      *
370      * Requirements
371      *
372      * - `account` cannot be the zero address.
373      * - `account` must have at least `amount` tokens.
374      */
375     function _burn(address account, uint256 value) internal {
376         require(account != address(0), "ERC20: burn from the zero address");
377 
378         _totalSupply = _totalSupply.sub(value);
379         _balances[account] = _balances[account].sub(value);
380         emit Transfer(account, address(0), value);
381     }
382 
383     /**
384      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
385      *
386      * This is internal function is equivalent to `approve`, and can be used to
387      * e.g. set automatic allowances for certain subsystems, etc.
388      *
389      * Emits an `Approval` event.
390      *
391      * Requirements:
392      *
393      * - `owner` cannot be the zero address.
394      * - `spender` cannot be the zero address.
395      */
396     function _approve(address owner, address spender, uint256 value) internal {
397         require(owner != address(0), "ERC20: approve from the zero address");
398         require(spender != address(0), "ERC20: approve to the zero address");
399 
400         _allowances[owner][spender] = value;
401         emit Approval(owner, spender, value);
402     }
403 
404     /**
405      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
406      * from the caller's allowance.
407      *
408      * See `_burn` and `_approve`.
409      */
410     function _burnFrom(address account, uint256 amount) internal {
411         _burn(account, amount);
412         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
413     }
414 }
415 
416 pragma solidity ^0.5.0;
417 
418 
419 /**
420  * @title FNSP
421  *
422  * @dev Standard ERC20 token with burning and optional functions implemented.
423  * For full specification of ERC-20 standard see:
424  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
425  */
426 contract FNSP is ERC20 {
427 
428     string private _name;
429     string private _symbol;
430     uint8 private _decimals;
431 
432     /**
433      * @dev Constructor.
434      */
435     constructor() public payable {
436       _name = 'Finswap';
437       _symbol = 'FNSP';
438       _decimals = 18;
439 
440       // set tokenOwnerAddress as owner of all tokens
441       _initSupply(msg.sender, 10000000 * 10 ** uint(decimals()));
442     }
443 
444     /**
445      * @dev Burns a specific amount of tokens.
446      * @param value The amount of lowest token units to be burned.
447      */
448     function burn(uint256 value) public {
449       _burn(msg.sender, value);
450     }
451 
452     // optional functions from ERC20 stardard
453 
454     /**
455      * @return the name of the token.
456      */
457     function name() public view returns (string memory) {
458       return _name;
459     }
460 
461     /**
462      * @return the symbol of the token.
463      */
464     function symbol() public view returns (string memory) {
465       return _symbol;
466     }
467 
468     /**
469      * @return the number of decimals of the token.
470      */
471     function decimals() public view returns (uint8) {
472       return _decimals;
473     }
474 }