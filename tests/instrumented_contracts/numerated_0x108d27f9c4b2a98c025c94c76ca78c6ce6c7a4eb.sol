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
78 /**
79  * @dev Contract module which provides a basic access control mechanism, where
80  * there is an account (an owner) that can be granted exclusive access to
81  * specific functions.
82  *
83  * This module is used through inheritance. It will make available the modifier
84  * `onlyOwner`, which can be aplied to your functions to restrict their use to
85  * the owner.
86  */
87 contract Ownable {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev Initializes the contract setting the deployer as the initial owner.
94      */
95     constructor () internal {
96         _owner = msg.sender;
97         emit OwnershipTransferred(address(0), _owner);
98     }
99 
100     /**
101      * @dev Returns the address of the current owner.
102      */
103     function owner() public view returns (address) {
104         return _owner;
105     }
106 
107     /**
108      * @dev Throws if called by any account other than the owner.
109      */
110     modifier onlyOwner() {
111         require(isOwner(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     /**
116      * @dev Returns true if the caller is the current owner.
117      */
118     function isOwner() public view returns (bool) {
119         return msg.sender == _owner;
120     }
121 
122     /**
123      * @dev Leaves the contract without owner. It will not be possible to call
124      * `onlyOwner` functions anymore. Can only be called by the current owner.
125      *
126      * > Note: Renouncing ownership will leave the contract without an owner,
127      * thereby removing any functionality that is only available to the owner.
128      */
129     function renounceOwnership() public onlyOwner {
130         emit OwnershipTransferred(_owner, address(0));
131         _owner = address(0);
132     }
133 
134     /**
135      * @dev Transfers ownership of the contract to a new account (`newOwner`).
136      * Can only be called by the current owner.
137      */
138     function transferOwnership(address newOwner) public onlyOwner {
139         _transferOwnership(newOwner);
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      */
145     function _transferOwnership(address newOwner) internal {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         emit OwnershipTransferred(_owner, newOwner);
148         _owner = newOwner;
149     }
150 }
151 
152 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
153 
154 pragma solidity ^0.5.0;
155 
156 /**
157  * @dev Wrappers over Solidity's arithmetic operations with added overflow
158  * checks.
159  *
160  * Arithmetic operations in Solidity wrap on overflow. This can easily result
161  * in bugs, because programmers usually assume that an overflow raises an
162  * error, which is the standard behavior in high level programming languages.
163  * `SafeMath` restores this intuition by reverting the transaction when an
164  * operation overflows.
165  *
166  * Using this library instead of the unchecked operations eliminates an entire
167  * class of bugs, so it's recommended to use it always.
168  */
169 library SafeMath {
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SafeMath: addition overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SafeMath: subtraction overflow");
197         uint256 c = a - b;
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the multiplication of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `*` operator.
207      *
208      * Requirements:
209      * - Multiplication cannot overflow.
210      */
211     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
215         if (a == 0) {
216             return 0;
217         }
218 
219         uint256 c = a * b;
220         require(c / a == b, "SafeMath: multiplication overflow");
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0, "SafeMath: division by zero");
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         require(b != 0, "SafeMath: modulo by zero");
258         return a % b;
259     }
260 }
261 
262 // File: contracts/MetaPrediction.sol
263 
264 pragma solidity 0.5.8;
265 
266 
267 
268 
269 contract MetaPrediction is IERC20, Ownable {
270     using SafeMath for uint256;
271 
272     string public constant name = "MetaPrediction";
273     string public constant symbol = "METP";
274     uint8 public constant decimals = 18;
275     
276     bool public mintingFinished = false;
277 
278     mapping (address => uint256) private _balances;
279     mapping (address => mapping (address => uint256)) private _allowances;
280     uint256 private _totalSupply;
281 
282     event MintFinished();
283 
284     /**
285      * @dev See `IERC20.totalSupply`.
286      */
287     function totalSupply() public view returns (uint256) {
288         return _totalSupply;
289     }
290 
291     /**
292      * @dev See `IERC20.balanceOf`.
293      */
294     function balanceOf(address account) public view returns (uint256) {
295         return _balances[account];
296     }
297 
298     /**
299      * @dev See `IERC20.transfer`.
300      *
301      * Requirements:
302      *
303      * - `recipient` cannot be the zero address.
304      * - the caller must have a balance of at least `amount`.
305      */
306     function transfer(address recipient, uint256 amount) public returns (bool) {
307         _transfer(msg.sender, recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See `IERC20.allowance`.
313      */
314     function allowance(address owner, address spender) public view returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See `IERC20.approve`.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 value) public returns (bool) {
326         _approve(msg.sender, spender, value);
327         return true;
328     }
329 
330     /**
331      * @dev See `IERC20.transferFrom`.
332      *
333      * Emits an `Approval` event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of `ERC20`;
335      *
336      * Requirements:
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `value`.
339      * - the caller must have allowance for `sender`'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
345         return true;
346     }
347 
348     /**
349      * @dev Atomically increases the allowance granted to `spender` by the caller.
350      *
351      * This is an alternative to `approve` that can be used as a mitigation for
352      * problems described in `IERC20.approve`.
353      *
354      * Emits an `Approval` event indicating the updated allowance.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
361         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically decreases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to `approve` that can be used as a mitigation for
369      * problems described in `IERC20.approve`.
370      *
371      * Emits an `Approval` event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      * - `spender` must have allowance for the caller of at least
377      * `subtractedValue`.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
380         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Moves tokens `amount` from `sender` to `recipient`.
386      *
387      * This is internal function is equivalent to `transfer`, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a `Transfer` event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(address sender, address recipient, uint256 amount) internal {
399         require(sender != address(0), "ERC20: transfer from the zero address");
400         require(recipient != address(0), "ERC20: transfer to the zero address");
401 
402         _balances[sender] = _balances[sender].sub(amount);
403         _balances[recipient] = _balances[recipient].add(amount);
404         emit Transfer(sender, recipient, amount);
405     }
406 
407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
408      * the total supply.
409      *
410      * Requirements
411      *
412      * - `to` cannot be the zero address.
413      */
414     function _mint(address account, uint256 amount) public onlyOwner {
415         require(account != address(0), "ERC20: mint to the zero address");
416         require(amount > 0, "ERC20: mint to the zero address");
417 
418         _totalSupply = _totalSupply.add(amount);
419         _balances[account] = _balances[account].add(amount);
420     }
421 
422      /**
423      * @dev Destoys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a `Transfer` event with `to` set to the zero address.
427      *
428      * Requirements
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 value) internal {
434         require(account != address(0), "ERC20: burn from the zero address");
435 
436         _totalSupply = _totalSupply.sub(value);
437         _balances[account] = _balances[account].sub(value);
438         emit Transfer(account, address(0), value);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
443      *
444      * This is internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an `Approval` event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(address owner, address spender, uint256 value) internal {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = value;
459         emit Approval(owner, spender, value);
460     }
461 
462     /**
463      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
464      * from the caller's allowance.
465      *
466      * See `_burn` and `_approve`.
467      */
468     function _burnFrom(address account, uint256 amount) internal {
469         _burn(account, amount);
470         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
471     }
472 
473     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
474      * the total supply from array
475      *
476      * Emits a `Transfer` event with `from` set to the zero address.
477      *
478      * Requirements
479      *
480      * - `to` cannot be the zero address.
481      */
482     function mintTokens(address[] calldata _receivers, uint256[] calldata _amounts) onlyOwner canMint external  {
483         require(_receivers.length > 0 && _receivers.length <= 100, "Token: array must be 1-100 length");
484         require(_receivers.length == _amounts.length, "Token: length of receivers and amounts arrays must match");
485         for (uint256 i = 0; i < _receivers.length; i++) {
486             address receiver = _receivers[i];
487             uint256 amount = _amounts[i];
488 
489             require(amount > 0, "Token: mint to the zero address");
490 
491             _mint(receiver, amount);
492             emit Transfer(address(0), receiver, amount);
493         }
494     }
495 
496     /**
497     * @dev Function to stop minting new tokens.
498     * @return True if the operation was successful.
499     */
500     function finishMinting() public onlyOwner canMint returns (bool) {
501         mintingFinished = true;
502         emit MintFinished();
503         return true;
504     }
505 
506     modifier canMint() {
507         require(!mintingFinished, "Token: minting is finished");
508         _;
509     }
510 }