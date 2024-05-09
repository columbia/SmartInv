1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-05
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, "SafeMath: division by zero");
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
98      * Reverts when dividing by zero.
99      *
100      * Counterpart to Solidity's `%` operator. This function uses a `revert`
101      * opcode (which leaves remaining gas untouched) while Solidity uses an
102      * invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b != 0, "SafeMath: modulo by zero");
109         return a % b;
110     }
111 }
112 
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be aplied to your functions to restrict their use to
121  * the owner.
122  */
123 contract Ownable {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor () internal {
132         _owner = msg.sender;
133         emit OwnershipTransferred(address(0), _owner);
134     }
135 
136     /**
137      * @dev Returns the address of the current owner.
138      */
139     function owner() public view returns (address) {
140         return _owner;
141     }
142 
143     /**
144      * @dev Throws if called by any account other than the owner.
145      */
146     modifier onlyOwner() {
147         require(isOwner(), "Ownable: caller is not the owner");
148         _;
149     }
150 
151     /**
152      * @dev Returns true if the caller is the current owner.
153      */
154     function isOwner() public view returns (bool) {
155         return msg.sender == _owner;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * > Note: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public onlyOwner {
166         emit OwnershipTransferred(_owner, address(0));
167         _owner = address(0);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Can only be called by the current owner.
173      */
174     function transferOwnership(address newOwner) public onlyOwner {
175         _transferOwnership(newOwner);
176     }
177 
178     /**
179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
180      */
181     function _transferOwnership(address newOwner) internal {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 }
187 
188 
189 /**
190  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
191  * the optional functions; to access them see `ERC20Detailed`.
192  */
193 interface IERC20 {
194     /**
195      * @dev Returns the amount of tokens in existence.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     /**
200      * @dev Returns the amount of tokens owned by `account`.
201      */
202     function balanceOf(address account) external view returns (uint256);
203 
204     /**
205      * @dev Moves `amount` tokens from the caller's account to `recipient`.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * Emits a `Transfer` event.
210      */
211     function transfer(address recipient, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Returns the remaining number of tokens that `spender` will be
215      * allowed to spend on behalf of `owner` through `transferFrom`. This is
216      * zero by default.
217      *
218      * This value changes when `approve` or `transferFrom` are called.
219      */
220     function allowance(address owner, address spender) external view returns (uint256);
221 
222     /**
223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * > Beware that changing an allowance with this method brings the risk
228      * that someone may use both the old and the new allowance by unfortunate
229      * transaction ordering. One possible solution to mitigate this race
230      * condition is to first reduce the spender's allowance to 0 and set the
231      * desired value afterwards:
232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
233      *
234      * Emits an `Approval` event.
235      */
236     function approve(address spender, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Moves `amount` tokens from `sender` to `recipient` using the
240      * allowance mechanism. `amount` is then deducted from the caller's
241      * allowance.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to `approve`. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 }
263 
264 /**
265  * @dev Implementation of the `IERC20` interface.
266  *
267  * *For a detailed writeup see our guide [How to implement supply
268  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See `IERC20.approve`.
282  */
283 contract ERC20 is IERC20, Ownable{
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) internal _balances;
287 
288     mapping (address => mapping (address => uint256)) internal _allowances;
289 
290     uint256 internal _totalSupply;
291 
292     /**
293      * @dev See `IERC20.totalSupply`.
294      */
295     function totalSupply() public view returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See `IERC20.balanceOf`.
301      */
302     function balanceOf(address account) public view returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See `IERC20.transfer`.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public returns (bool) {
315         _transfer(msg.sender, recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See `IERC20.allowance`.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See `IERC20.approve`.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 value) public returns (bool) {
334         _approve(msg.sender, spender, value);
335         return true;
336     }
337 
338     /**
339      * @dev See `IERC20.transferFrom`.
340      *
341      * Emits an `Approval` event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of `ERC20`;
343      *
344      * Requirements:
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `value`.
347      * - the caller must have allowance for `sender`'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to `approve` that can be used as a mitigation for
360      * problems described in `IERC20.approve`.
361      *
362      * Emits an `Approval` event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to `approve` that can be used as a mitigation for
377      * problems described in `IERC20.approve`.
378      *
379      * Emits an `Approval` event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to `transfer`, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a `Transfer` event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(address sender, address recipient, uint256 amount) internal {
407         require(sender != address(0), "ERC20: transfer from the zero address");
408         require(recipient != address(0), "ERC20: transfer to the zero address");
409 
410         _balances[sender] = _balances[sender].sub(amount);
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415      /**
416      * @dev Destoys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a `Transfer` event with `to` set to the zero address.
420      *
421      * Requirements
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 value) internal {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _totalSupply = _totalSupply.sub(value);
430         _balances[account] = _balances[account].sub(value);
431         emit Transfer(account, address(0), value);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
436      *
437      * This is internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an `Approval` event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(address owner, address spender, uint256 value) internal {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = value;
452         emit Approval(owner, spender, value);
453     }
454     
455 }
456 
457 /**
458  * @dev Extension of `ERC20` that allows token holders to destroy both their own
459  * tokens and those that they have an allowance for, in a way that can be
460  * recognized off-chain (via event analysis).
461  */
462 contract ERC20Burnable is ERC20 {
463     /**
464      * @dev Destoys `amount` tokens from the caller.
465      *
466      * See `ERC20._burn`.
467      */
468     function burn(uint256 amount) public onlyOwner {
469         _burn(msg.sender, amount);
470     }
471 }
472 
473 
474 /**
475  * @dev dAppStore Token implementation.
476  */
477 contract dAppStoreToken is  ERC20Burnable {
478     using SafeMath for uint256;
479 
480     string public constant name = "dAppstore Token";
481     string public constant symbol = "DAPPX";
482     uint8 public constant decimals = 18;
483 
484     uint256 internal constant INITIAL_SUPPLY = 1.5 * (10**9) * (10 ** uint256(decimals)); // 1.5 billions tokens
485 
486     /**
487     * @dev Constructor that gives msg.sender all of existing tokens.
488     */
489     constructor() public {
490         _totalSupply = INITIAL_SUPPLY;
491         _balances[msg.sender] = INITIAL_SUPPLY;
492         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
493     }
494 }