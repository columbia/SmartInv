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
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  * 
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * the Proven Healer
216  * Master Fisherman
217  *
218  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
219  * functions have been added to mitigate the well-known issues around setting
220  * allowances. See `IERC20.approve`.
221  */
222 contract ERC20 is IERC20 {
223     using SafeMath for uint256;
224 
225     mapping (address => uint256) private _balances;
226 
227     mapping (address => mapping (address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     /**
232      * @dev See `IERC20.totalSupply`.
233      */
234     function totalSupply() public view returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See `IERC20.balanceOf`.
240      */
241     function balanceOf(address account) public view returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See `IERC20.transfer`.
247      *
248      * Requirements:
249      *
250      * - `recipient` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address recipient, uint256 amount) public returns (bool) {
254         _transfer(msg.sender, recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See `IERC20.allowance`.
260      */
261     function allowance(address owner, address spender) public view returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See `IERC20.approve`.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 value) public returns (bool) {
273         _approve(msg.sender, spender, value);
274         return true;
275     }
276 
277     /**
278      * @dev See `IERC20.transferFrom`.
279      *
280      * Emits an `Approval` event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of `ERC20`;
282      *
283      * Requirements:
284      * - `sender` and `recipient` cannot be the zero address.
285      * - `sender` must have a balance of at least `value`.
286      * - the caller must have allowance for `sender`'s tokens of at least
287      * `amount`.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
290         _transfer(sender, recipient, amount);
291         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to `approve` that can be used as a mitigation for
299      * problems described in `IERC20.approve`.
300      *
301      * Emits an `Approval` event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
308         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to `approve` that can be used as a mitigation for
316      * problems described in `IERC20.approve`.
317      *
318      * Emits an `Approval` event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
327         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
328         return true;
329     }
330 
331     /**
332      * @dev Moves tokens `amount` from `sender` to `recipient`.
333      *
334      * This is internal function is equivalent to `transfer`, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a `Transfer` event.
338      *
339      * Requirements:
340      *
341      * - `sender` cannot be the zero address.
342      * - `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      */
345     function _transfer(address sender, address recipient, uint256 amount) internal {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _balances[sender] = _balances[sender].sub(amount);
350         _balances[recipient] = _balances[recipient].add(amount);
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a `Transfer` event with `from` set to the zero address.
358      *
359      * Requirements
360      *
361      * - `to` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _totalSupply = _totalSupply.add(amount);
367         _balances[account] = _balances[account].add(amount);
368         emit Transfer(address(0), account, amount);
369     }
370 
371      /**
372      * @dev Destroys `amount` tokens from `account`, reducing the
373      * total supply.
374      *
375      * Emits a `Transfer` event with `to` set to the zero address.
376      *
377      * Requirements
378      *
379      * - `account` cannot be the zero address.
380      * - `account` must have at least `amount` tokens.
381      */
382     function _burn(address account, uint256 value) internal {
383         require(account != address(0), "ERC20: burn from the zero address");
384 
385         _totalSupply = _totalSupply.sub(value);
386         _balances[account] = _balances[account].sub(value);
387         emit Transfer(account, address(0), value);
388     }
389 
390     /**
391      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
392      *
393      * This is internal function is equivalent to `approve`, and can be used to
394      * e.g. set automatic allowances for certain subsystems, etc.
395      *
396      * Emits an `Approval` event.
397      *
398      * Requirements:
399      *
400      * - `owner` cannot be the zero address.
401      * - `spender` cannot be the zero address.
402      */
403     function _approve(address owner, address spender, uint256 value) internal {
404         require(owner != address(0), "ERC20: approve from the zero address");
405         require(spender != address(0), "ERC20: approve to the zero address");
406 
407         _allowances[owner][spender] = value;
408         emit Approval(owner, spender, value);
409     }
410 
411     /**
412      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
413      * from the caller's allowance.
414      *
415      * See `_burn` and `_approve`.
416      */
417     function _burnFrom(address account, uint256 amount) internal {
418         _burn(account, amount);
419         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
420     }
421 }
422 
423 // File: contracts\ERC20\TokenMintERC20Token.sol
424 
425 pragma solidity ^0.5.0;
426 
427 
428 /**
429  * @title TokenMintERC20Token
430  * @author TokenMint (visit https://tokenmint.io)
431  *
432  * @dev Standard ERC20 token with burning and optional functions implemented.
433  * For full specification of ERC-20 standard see:
434  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
435  */
436 contract StandardERC20 is ERC20 {
437 
438     string private _name;
439     string private _symbol;
440     uint8 private _decimals;
441 
442     /**
443      * @dev Constructor.
444      * @param name name of the token
445      * @param symbol symbol of the token, 3-4 chars is recommended
446      * @param decimals number of decimal places of one token unit, 18 is widely used
447      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
448      * @param tokenOwnerAddress address that gets 100% of token supply
449      */
450     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
451       _name = name;
452       _symbol = symbol;
453       _decimals = decimals;
454 
455       // set tokenOwnerAddress as owner of all tokens
456       _mint(tokenOwnerAddress, totalSupply);
457 
458       // pay the service fee for contract deployment
459       feeReceiver.transfer(msg.value);
460     }
461 
462     /**
463      * @dev Burns a specific amount of tokens.
464      * @param value The amount of lowest token units to be burned.
465      */
466     function burn(uint256 value) public {
467       _burn(msg.sender, value);
468     }
469 
470     // optional functions from ERC20 stardard
471 
472     /**
473      * @return the name of the token.
474      */
475     function name() public view returns (string memory) {
476       return _name;
477     }
478 
479     /**
480      * @return the symbol of the token.
481      */
482     function symbol() public view returns (string memory) {
483       return _symbol;
484     }
485 
486     /**
487      * @return the number of decimals of the token.
488      */
489     function decimals() public view returns (uint8) {
490       return _decimals;
491     }
492 }