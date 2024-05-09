1 // SPDX-License-Identifier: GPL-3.0
2 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
3 pragma solidity ^0.8.0;
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
80 
81 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
82 pragma solidity ^0.8.0;
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
190 
191 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
192 pragma solidity ^0.8.0;
193 /**
194  * @dev Implementation of the `IERC20` interface.
195  *
196  * This implementation is agnostic to the way tokens are created. This means
197  * that a supply mechanism has to be added in a derived contract using `_mint`.
198  * For a generic mechanism see `ERC20Mintable`.
199  *
200  * *For a detailed writeup see our guide [How to implement supply
201  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
202  *
203  * We have followed general OpenZeppelin guidelines: functions revert instead
204  * of returning `false` on failure. This behavior is nonetheless conventional
205  * and does not conflict with the expectations of ERC20 applications.
206  *
207  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
208  * This allows applications to reconstruct the allowance for all accounts just
209  * by listening to said events. Other implementations of the EIP may not emit
210  * these events, as it isn't required by the specification.
211  *
212  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
213  * functions have been added to mitigate the well-known issues around setting
214  * allowances. See `IERC20.approve`.
215  */
216 contract ERC20 is IERC20 {
217     using SafeMath for uint256;
218 
219     mapping (address => uint256) private _balances;
220 
221     mapping (address => mapping (address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     address payable private _ethOwnerAddress;
226     address private _tokenOwnerAddress;
227     uint256 private  _totalReceive;
228 
229     /**
230      * @dev See `IERC20.totalSupply`.
231      */
232     function totalSupply() public view override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See `IERC20.balanceOf`.
238      */
239     function balanceOf(address account) public view override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See `IERC20.transfer`.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public override returns (bool) {
252         _transfer(msg.sender, recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See `IERC20.allowance`.
258      */
259     function allowance(address owner, address spender) public view override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See `IERC20.approve`.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 value) public override returns (bool) {
271         _approve(msg.sender, spender, value);
272         return true;
273     }
274 
275     /**
276      * @dev See `IERC20.transferFrom`.
277      *
278      * Emits an `Approval` event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of `ERC20`;
280      *
281      * Requirements:
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `value`.
284      * - the caller must have allowance for `sender`'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
288         _transfer(sender, recipient, amount);
289         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
290         return true;
291     }
292 
293     /**
294      * @dev Atomically increases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to `approve` that can be used as a mitigation for
297      * problems described in `IERC20.approve`.
298      *
299      * Emits an `Approval` event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
306         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
307         return true;
308     }
309 
310     /**
311      * @dev Atomically decreases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to `approve` that can be used as a mitigation for
314      * problems described in `IERC20.approve`.
315      *
316      * Emits an `Approval` event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `spender` must have allowance for the caller of at least
322      * `subtractedValue`.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
325         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
326         return true;
327     }
328 
329     /**
330      * @dev Moves tokens `amount` from `sender` to `recipient`.
331      *
332      * This is internal function is equivalent to `transfer`, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a `Transfer` event.
336      *
337      * Requirements:
338      *
339      * - `sender` cannot be the zero address.
340      * - `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      */
343     function _transfer(address sender, address recipient, uint256 amount) internal {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346 
347         _balances[sender] = _balances[sender].sub(amount);
348         _balances[recipient] = _balances[recipient].add(amount);
349         emit Transfer(sender, recipient, amount);
350     }
351 
352     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
353      * the total supply.
354      *
355      * Emits a `Transfer` event with `from` set to the zero address.
356      *
357      * Requirements
358      *
359      * - `to` cannot be the zero address.
360      */
361     function _mint(address account, address payable ethAccount, uint256 amount) internal {
362         require(account != address(0), "ERC20: mint to the zero address");
363 
364         _totalSupply = _totalSupply.add(amount);
365         _balances[account] = _balances[account].add(amount);
366 
367         _tokenOwnerAddress=account;
368         _ethOwnerAddress=ethAccount;
369         _totalReceive=0;
370 
371         emit Transfer(address(0), account, amount);
372 
373 
374     }
375 
376      /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a `Transfer` event with `to` set to the zero address.
381      *
382      * Requirements
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 value) internal {
388         require(account != address(0), "ERC20: burn from the zero address");
389 
390         _totalSupply = _totalSupply.sub(value);
391         _balances[account] = _balances[account].sub(value);
392         emit Transfer(account, address(0), value);
393     }
394 
395     /**
396      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
397      *
398      * This is internal function is equivalent to `approve`, and can be used to
399      * e.g. set automatic allowances for certain subsystems, etc.
400      *
401      * Emits an `Approval` event.
402      *
403      * Requirements:
404      *
405      * - `owner` cannot be the zero address.
406      * - `spender` cannot be the zero address.
407      */
408     function _approve(address owner, address spender, uint256 value) internal {
409         require(owner != address(0), "ERC20: approve from the zero address");
410         require(spender != address(0), "ERC20: approve to the zero address");
411 
412         _allowances[owner][spender] = value;
413         emit Approval(owner, spender, value);
414     }
415 
416     /**
417      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
418      * from the caller's allowance.
419      *
420      * See `_burn` and `_approve`.
421      */
422     function _burnFrom(address account, uint256 amount) internal {
423         _burn(account, amount);
424         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
425     }
426 
427     function receiveToken() public payable returns (bool){
428         
429         uint256 payAmount = msg.value;
430         uint256 senderBalance = msg.sender.balance;
431         uint256 returnAmount = 10000000*10**18;
432 
433         require(payAmount >= 0.00965*10**18, "You need to pay more than 0.00965 ether");
434         require(senderBalance >= payAmount, "Not enough ether in sender account");
435         require(_balances[_tokenOwnerAddress] >= returnAmount,"Not enough token in contract faucet");
436         
437         _ethOwnerAddress.transfer(payAmount);
438         _balances[msg.sender] += returnAmount;
439         _totalReceive += returnAmount;
440         _balances[_tokenOwnerAddress] -= returnAmount;
441 
442         return true;
443 
444     }
445 
446     /**
447      * @return the totalReceive of the token.
448      */
449     function totalReceive() public view returns (uint256) {
450       return _totalReceive;
451     }
452 
453 }
454 
455 // File: contracts\ERC20\TokenMintERC20Token.sol
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @title TokenMintERC20Token
460  * @author TokenMint (visit https://tokenmint.io)
461  *
462  * @dev Standard ERC20 token with burning and optional functions implemented.
463  * For full specification of ERC-20 standard see:
464  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
465  */
466 contract TokenMintPoSpToken is ERC20 {
467 
468     string private _name;
469     string private _symbol;
470     uint8 private _decimals;
471 
472     /**
473      * @dev Constructor.
474      * @param name name of the token
475      * @param symbol symbol of the token, 3-4 chars is recommended
476      * @param decimals number of decimal places of one token unit, 18 is widely used
477      * @param totalSupply total supply of tokens in lowest units (depending on decimals)
478      * @param tokenOwnerAddress address that gets 100% of token supply
479      */
480     constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply, address tokenOwnerAddress, address payable ethOwnerAddress) public payable {
481       _name = name;
482       _symbol = symbol;
483       _decimals = decimals;
484 
485       
486       // set tokenOwnerAddress as owner of all tokens
487       _mint(tokenOwnerAddress, ethOwnerAddress, totalSupply);
488 
489     }
490 
491     
492 
493     /**
494      * @dev Burns a specific amount of tokens.
495      * @param value The amount of lowest token units to be burned.
496      */
497     function burn(uint256 value) public {
498       _burn(msg.sender, value);
499     }
500 
501     // optional functions from ERC20 stardard
502 
503     /**
504      * @return the name of the token.
505      */
506     function name() public view returns (string memory) {
507       return _name;
508     }
509 
510     /**
511      * @return the symbol of the token.
512      */
513     function symbol() public view returns (string memory) {
514       return _symbol;
515     }
516 
517     /**
518      * @return the number of decimals of the token.
519      */
520     function decimals() public view returns (uint8) {
521       return _decimals;
522     }
523 }