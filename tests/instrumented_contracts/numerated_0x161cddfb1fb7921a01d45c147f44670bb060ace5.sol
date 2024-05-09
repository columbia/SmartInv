1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-02
3 */
4  
5 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
6  
7 pragma solidity ^0.5.0;
8 /**
9  * https://t.me/catdogee
10  */
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
13  * the optional functions; to access them see `ERC20Detailed`.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20  
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25  
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a `Transfer` event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34  
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through `transferFrom`. This is
38      * zero by default.
39      *
40      * This value changes when `approve` or `transferFrom` are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43  
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * > Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an `Approval` event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59  
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a `Transfer` event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70  
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78  
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to `approve`. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85  
86 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
87  
88 pragma solidity ^0.5.0;
89  
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116  
117         return c;
118     }
119  
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b <= a, "SafeMath: subtraction overflow");
131         uint256 c = a - b;
132  
133         return c;
134     }
135  
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
149         if (a == 0) {
150             return 0;
151         }
152  
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155  
156         return c;
157     }
158  
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Solidity only automatically asserts when dividing by 0
172         require(b > 0, "SafeMath: division by zero");
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175  
176         return c;
177     }
178  
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         require(b != 0, "SafeMath: modulo by zero");
192         return a % b;
193     }
194 }
195  
196 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
197  
198 pragma solidity ^0.5.0;
199  
200  
201  
202 /**
203  * @dev Implementation of the `IERC20` interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using `_mint`.
207  * For a generic mechanism see `ERC20Mintable`.
208  *
209  * *For a detailed writeup see our guide [How to implement supply
210  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
211  *
212  * We have followed general OpenZeppelin guidelines: functions revert instead
213  * of returning `false` on failure. This behavior is nonetheless conventional
214  * and does not conflict with the expectations of ERC20 applications.
215  *
216  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
217  * This allows applications to reconstruct the allowance for all accounts just
218  * by listening to said events. Other implementations of the EIP may not emit
219  * these events, as it isn't required by the specification.
220  *
221  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
222  * functions have been added to mitigate the well-known issues around setting
223  * allowances. See `IERC20.approve`.
224  */
225 contract ERC20 is IERC20 {
226     using SafeMath for uint256;
227  
228     mapping (address => uint256) private _balances;
229  
230     mapping (address => mapping (address => uint256)) private _allowances;
231  
232     uint256 private _totalSupply;
233  
234     /**
235      * @dev See `IERC20.totalSupply`.
236      */
237     function totalSupply() public view returns (uint256) {
238         return _totalSupply;
239     }
240  
241     /**
242      * @dev See `IERC20.balanceOf`.
243      */
244     function balanceOf(address account) public view returns (uint256) {
245         return _balances[account];
246     }
247  
248     /**
249      * @dev See `IERC20.transfer`.
250      *
251      * Requirements:
252      *
253      * - `recipient` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address recipient, uint256 amount) public returns (bool) {
257         _transfer(msg.sender, recipient, amount);
258         return true;
259     }
260  
261     /**
262      * @dev See `IERC20.allowance`.
263      */
264     function allowance(address owner, address spender) public view returns (uint256) {
265         return _allowances[owner][spender];
266     }
267  
268     /**
269      * @dev See `IERC20.approve`.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 value) public returns (bool) {
276         _approve(msg.sender, spender, value);
277         return true;
278     }
279  
280     /**
281      * @dev See `IERC20.transferFrom`.
282      *
283      * Emits an `Approval` event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of `ERC20`;
285      *
286      * Requirements:
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `value`.
289      * - the caller must have allowance for `sender`'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
293         _transfer(sender, recipient, amount);
294         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
295         return true;
296     }
297  
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to `approve` that can be used as a mitigation for
302      * problems described in `IERC20.approve`.
303      *
304      * Emits an `Approval` event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
311         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
312         return true;
313     }
314  
315     /**
316      * @dev Atomically decreases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to `approve` that can be used as a mitigation for
319      * problems described in `IERC20.approve`.
320      *
321      * Emits an `Approval` event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      * - `spender` must have allowance for the caller of at least
327      * `subtractedValue`.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
330         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
331         return true;
332     }
333  
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to `transfer`, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a `Transfer` event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351  
352         _balances[sender] = _balances[sender].sub(amount);
353         _balances[recipient] = _balances[recipient].add(amount);
354         emit Transfer(sender, recipient, amount);
355     }
356  
357     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
358      * the total supply.
359      *
360      * Emits a `Transfer` event with `from` set to the zero address.
361      *
362      * Requirements
363      *
364      * - `to` cannot be the zero address.
365      */
366     function _mint(address account, uint256 amount) internal {
367         require(account != address(0), "ERC20: mint to the zero address");
368  
369         _totalSupply = _totalSupply.add(amount);
370         _balances[account] = _balances[account].add(amount);
371         emit Transfer(address(0), account, amount);
372     }
373  
374      /**
375      * @dev Destroys `amount` tokens from `account`, reducing the
376      * total supply.
377      *
378      * Emits a `Transfer` event with `to` set to the zero address.
379      *
380      * Requirements
381      *
382      * - `account` cannot be the zero address.
383      * - `account` must have at least `amount` tokens.
384      */
385     function _burn(address account, uint256 value) internal {
386         require(account != address(0), "ERC20: burn from the zero address");
387  
388         _totalSupply = _totalSupply.sub(value);
389         _balances[account] = _balances[account].sub(value);
390         emit Transfer(account, address(0), value);
391     }
392  
393     /**
394      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
395      *
396      * This is internal function is equivalent to `approve`, and can be used to
397      * e.g. set automatic allowances for certain subsystems, etc.
398      *
399      * Emits an `Approval` event.
400      *
401      * Requirements:
402      *
403      * - `owner` cannot be the zero address.
404      * - `spender` cannot be the zero address.
405      */
406     function _approve(address owner, address spender, uint256 value) internal {
407         require(owner != address(0), "ERC20: approve from the zero address");
408         require(spender != address(0), "ERC20: approve to the zero address");
409  
410         _allowances[owner][spender] = value;
411         emit Approval(owner, spender, value);
412     }
413  
414     /**
415      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
416      * from the caller's allowance.
417      *
418      * See `_burn` and `_approve`.
419      */
420     function _burnFrom(address account, uint256 amount) internal {
421         _burn(account, amount);
422         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
423     }
424 }
425  
426 // File: contracts\ERC20\TokenMintERC20Token.sol
427  
428 pragma solidity ^0.5.0;
429  
430  
431 /**
432  * @title TokenMintERC20Token
433  * @author TokenMint (visit https://tokenmint.io)
434  *
435  * @dev Standard ERC20 token with burning and optional functions implemented.
436  * For full specification of ERC-20 standard see:
437  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
438  */
439 contract TokenMintERC20Token is ERC20 {
440  
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444  
445     /**
446      * @dev Constructor.
447      * @param name name of the token
448      * @param symbol symbol of the token, 3-4 chars is recommended
449      * @param decimals number of decimal places of one token unit, 18 is widely used
450      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
451      * @param tokenOwnerAddress address that gets 100% of token supply
452      */
453     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address payable feeReceiver, address tokenOwnerAddress) public payable {
454       _name = name;
455       _symbol = symbol;
456       _decimals = decimals;
457  
458       // set tokenOwnerAddress as owner of all tokens
459       _mint(tokenOwnerAddress, totalSupply);
460  
461       // pay the service fee for contract deployment
462       feeReceiver.transfer(msg.value);
463     }
464  
465     /**
466      * @dev Burns a specific amount of tokens.
467      * @param value The amount of lowest token units to be burned.
468      */
469     function burn(uint256 value) public {
470       _burn(msg.sender, value);
471     }
472  
473     // optional functions from ERC20 stardard
474  
475     /**
476      * @return the name of the token.
477      */
478     function name() public view returns (string memory) {
479       return _name;
480     }
481  
482     /**
483      * @return the symbol of the token.
484      */
485     function symbol() public view returns (string memory) {
486       return _symbol;
487     }
488  
489     /**
490      * @return the number of decimals of the token.
491      */
492     function decimals() public view returns (uint8) {
493       return _decimals;
494     }
495 }