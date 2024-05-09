1 /**
2 */
3 
4 /**
5 ウェブサイト: いいえ
6 ロードマップ: いいえ
7 LP: 焼けた
8 TG: 作成する時間がありません
9 マーケティング: いいえ
10 みんなのために、だからみんなはそれのためにしてください
11 
12 **/
13 pragma solidity ^0.5.0;
14  
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
17  * the optional functions; to access them see `ERC20Detailed`.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24  
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29  
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a `Transfer` event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38  
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through `transferFrom`. This is
42      * zero by default.
43      *
44      * This value changes when `approve` or `transferFrom` are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47  
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * > Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an `Approval` event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63  
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a `Transfer` event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74  
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82  
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to `approve`. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89  
90 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
91  
92 pragma solidity ^0.5.0;
93  
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120  
121         return c;
122     }
123  
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b <= a, "SafeMath: subtraction overflow");
135         uint256 c = a - b;
136  
137         return c;
138     }
139  
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
153         if (a == 0) {
154             return 0;
155         }
156  
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159  
160         return c;
161     }
162  
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Solidity only automatically asserts when dividing by 0
176         require(b > 0, "SafeMath: division by zero");
177         uint256 c = a / b;
178         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179  
180         return c;
181     }
182  
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         require(b != 0, "SafeMath: modulo by zero");
196         return a % b;
197     }
198 }
199  
200 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
201  
202 pragma solidity ^0.5.0;
203  
204  
205  
206 /**
207  * @dev Implementation of the `IERC20` interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using `_mint`.
211  * For a generic mechanism see `ERC20Mintable`.
212  *
213  * *For a detailed writeup see our guide [How to implement supply
214  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
215  *
216  * We have followed general OpenZeppelin guidelines: functions revert instead
217  * of returning `false` on failure. This behavior is nonetheless conventional
218  * and does not conflict with the expectations of ERC20 applications.
219  *
220  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
221  * This allows applications to reconstruct the allowance for all accounts just
222  * by listening to said events. Other implementations of the EIP may not emit
223  * these events, as it isn't required by the specification.
224  *
225  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
226  * functions have been added to mitigate the well-known issues around setting
227  * allowances. See `IERC20.approve`.
228  */
229 contract ERC20 is IERC20 {
230     using SafeMath for uint256;
231  
232     mapping (address => uint256) private _balances;
233  
234     mapping (address => mapping (address => uint256)) private _allowances;
235  
236     uint256 private _totalSupply;
237  
238     /**
239      * @dev See `IERC20.totalSupply`.
240      */
241     function totalSupply() public view returns (uint256) {
242         return _totalSupply;
243     }
244  
245     /**
246      * @dev See `IERC20.balanceOf`.
247      */
248     function balanceOf(address account) public view returns (uint256) {
249         return _balances[account];
250     }
251  
252     /**
253      * @dev See `IERC20.transfer`.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public returns (bool) {
261         _transfer(msg.sender, recipient, amount);
262         return true;
263     }
264  
265     /**
266      * @dev See `IERC20.allowance`.
267      */
268     function allowance(address owner, address spender) public view returns (uint256) {
269         return _allowances[owner][spender];
270     }
271  
272     /**
273      * @dev See `IERC20.approve`.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 value) public returns (bool) {
280         _approve(msg.sender, spender, value);
281         return true;
282     }
283  
284     /**
285      * @dev See `IERC20.transferFrom`.
286      *
287      * Emits an `Approval` event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of `ERC20`;
289      *
290      * Requirements:
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `value`.
293      * - the caller must have allowance for `sender`'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
299         return true;
300     }
301  
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to `approve` that can be used as a mitigation for
306      * problems described in `IERC20.approve`.
307      *
308      * Emits an `Approval` event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
315         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
316         return true;
317     }
318  
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to `approve` that can be used as a mitigation for
323      * problems described in `IERC20.approve`.
324      *
325      * Emits an `Approval` event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
334         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
335         return true;
336     }
337  
338     /**
339      * @dev Moves tokens `amount` from `sender` to `recipient`.
340      *
341      * This is internal function is equivalent to `transfer`, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a `Transfer` event.
345      *
346      * Requirements:
347      *
348      * - `sender` cannot be the zero address.
349      * - `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      */
352     function _transfer(address sender, address recipient, uint256 amount) internal {
353         require(sender != address(0), "ERC20: transfer from the zero address");
354         require(recipient != address(0), "ERC20: transfer to the zero address");
355  
356         _balances[sender] = _balances[sender].sub(amount);
357         _balances[recipient] = _balances[recipient].add(amount);
358         emit Transfer(sender, recipient, amount);
359     }
360  
361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
362      * the total supply.
363      *
364      * Emits a `Transfer` event with `from` set to the zero address.
365      *
366      * Requirements
367      *
368      * - `to` cannot be the zero address.
369      */
370     function _mint(address account, uint256 amount) internal {
371         require(account != address(0), "ERC20: mint to the zero address");
372  
373         _totalSupply = _totalSupply.add(amount);
374         _balances[account] = _balances[account].add(amount);
375         emit Transfer(address(0), account, amount);
376     }
377  
378      /**
379      * @dev Destroys `amount` tokens from `account`, reducing the
380      * total supply.
381      *
382      * Emits a `Transfer` event with `to` set to the zero address.
383      *
384      * Requirements
385      *
386      * - `account` cannot be the zero address.
387      * - `account` must have at least `amount` tokens.
388      */
389     function _burn(address account, uint256 value) internal {
390         require(account != address(0), "ERC20: burn from the zero address");
391  
392         _totalSupply = _totalSupply.sub(value);
393         _balances[account] = _balances[account].sub(value);
394         emit Transfer(account, address(0), value);
395     }
396  
397     /**
398      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
399      *
400      * This is internal function is equivalent to `approve`, and can be used to
401      * e.g. set automatic allowances for certain subsystems, etc.
402      *
403      * Emits an `Approval` event.
404      *
405      * Requirements:
406      *
407      * - `owner` cannot be the zero address.
408      * - `spender` cannot be the zero address.
409      */
410     function _approve(address owner, address spender, uint256 value) internal {
411         require(owner != address(0), "ERC20: approve from the zero address");
412         require(spender != address(0), "ERC20: approve to the zero address");
413  
414         _allowances[owner][spender] = value;
415         emit Approval(owner, spender, value);
416     }
417  
418     /**
419      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
420      * from the caller's allowance.
421      *
422      * See `_burn` and `_approve`.
423      */
424     function _burnFrom(address account, uint256 amount) internal {
425         _burn(account, amount);
426         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
427     }
428 }
429  
430 // File: contracts\ERC20\TokenMintERC20Token.sol
431  
432 pragma solidity ^0.5.0;
433  
434  
435 /**
436  * @title TokenMintERC20Token
437  * @author TokenMint (visit https://tokenmint.io)
438  *
439  * @dev Standard ERC20 token with burning and optional functions implemented.
440  * For full specification of ERC-20 standard see:
441  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
442  */
443 contract FORPPL is ERC20 {
444 
445     
446  
447     string private _name;
448     string private _symbol;
449     uint8 private _decimals;
450  
451     /**
452      * @dev Constructor.
453      * @param name name of the token
454      * @param symbol symbol of the token, 3-4 chars is recommended
455      * @param decimals number of decimal places of one token unit, 18 is widely used
456      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
457      * @param tokenOwnerAddress address that gets 100% of token supply
458      */
459     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress) public payable {
460       _name = name;
461       _symbol = symbol;
462       _decimals = decimals;
463  
464       // set tokenOwnerAddress as owner of all tokens
465       _mint(tokenOwnerAddress, totalSupply);
466     }
467  
468     /**
469      * @dev Burns a specific amount of tokens.
470      * @param value The amount of lowest token units to be burned.
471      */
472     function burn(uint256 value) public {
473       _burn(msg.sender, value);
474     }
475  
476     // optional functions from ERC20 stardard
477  
478     /**
479      * @return the name of the token.
480      */
481     function name() public view returns (string memory) {
482       return _name;
483     }
484  
485     /**
486      * @return the symbol of the token.
487      */
488     function symbol() public view returns (string memory) {
489       return _symbol;
490     }
491  
492     /**
493      * @return the number of decimals of the token.
494      */
495     function decimals() public view returns (uint8) {
496       return _decimals;
497     }
498 }