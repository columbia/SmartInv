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
61         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * This module is used through inheritance. It will make available the modifier
116  * `onlyOwner`, which can be aplied to your functions to restrict their use to
117  * the owner.
118  */
119 contract Ownable {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor () internal {
128         _owner = msg.sender;
129         emit OwnershipTransferred(address(0), _owner);
130     }
131 
132     /**
133      * @dev Returns the address of the current owner.
134      */
135     function owner() public view returns (address) {
136         return _owner;
137     }
138 
139     /**
140      * @dev Throws if called by any account other than the owner.
141      */
142     modifier onlyOwner() {
143         require(isOwner(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     /**
148      * @dev Returns true if the caller is the current owner.
149      */
150     function isOwner() public view returns (bool) {
151         return msg.sender == _owner;
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * > Note: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public onlyOwner {
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      */
177     function _transferOwnership(address newOwner) internal {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
187  * the optional functions; to access them see `ERC20Detailed`.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a `Transfer` event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through `transferFrom`. This is
212      * zero by default.
213      *
214      * This value changes when `approve` or `transferFrom` are called.
215      */
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * > Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an `Approval` event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a `Transfer` event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to `approve`. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 /**
261  * @dev Implementation of the `IERC20` interface.
262  *
263  * *For a detailed writeup see our guide [How to implement supply
264  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
265  *
266  * We have followed general OpenZeppelin guidelines: functions revert instead
267  * of returning `false` on failure. This behavior is nonetheless conventional
268  * and does not conflict with the expectations of ERC20 applications.
269  *
270  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
271  * This allows applications to reconstruct the allowance for all accounts just
272  * by listening to said events. Other implementations of the EIP may not emit
273  * these events, as it isn't required by the specification.
274  *
275  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
276  * functions have been added to mitigate the well-known issues around setting
277  * allowances. See `IERC20.approve`.
278  */
279 contract ERC20 is IERC20, Ownable{
280     using SafeMath for uint256;
281 
282     mapping (address => uint256) internal _balances;
283 
284     mapping (address => mapping (address => uint256)) internal _allowances;
285 
286     uint256 internal _totalSupply;
287 
288     /**
289      * @dev See `IERC20.totalSupply`.
290      */
291     function totalSupply() public view returns (uint256) {
292         return _totalSupply;
293     }
294 
295     /**
296      * @dev See `IERC20.balanceOf`.
297      */
298     function balanceOf(address account) public view returns (uint256) {
299         return _balances[account];
300     }
301 
302     /**
303      * @dev See `IERC20.transfer`.
304      *
305      * Requirements:
306      *
307      * - `recipient` cannot be the zero address.
308      * - the caller must have a balance of at least `amount`.
309      */
310     function transfer(address recipient, uint256 amount) public returns (bool) {
311         _transfer(msg.sender, recipient, amount);
312         return true;
313     }
314 
315     /**
316      * @dev See `IERC20.allowance`.
317      */
318     function allowance(address owner, address spender) public view returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     /**
323      * @dev See `IERC20.approve`.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function approve(address spender, uint256 value) public returns (bool) {
330         _approve(msg.sender, spender, value);
331         return true;
332     }
333 
334     /**
335      * @dev See `IERC20.transferFrom`.
336      *
337      * Emits an `Approval` event indicating the updated allowance. This is not
338      * required by the EIP. See the note at the beginning of `ERC20`;
339      *
340      * Requirements:
341      * - `sender` and `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `value`.
343      * - the caller must have allowance for `sender`'s tokens of at least
344      * `amount`.
345      */
346     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
347         _transfer(sender, recipient, amount);
348         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
349         return true;
350     }
351 
352     /**
353      * @dev Atomically increases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to `approve` that can be used as a mitigation for
356      * problems described in `IERC20.approve`.
357      *
358      * Emits an `Approval` event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
365         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
366         return true;
367     }
368 
369     /**
370      * @dev Atomically decreases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to `approve` that can be used as a mitigation for
373      * problems described in `IERC20.approve`.
374      *
375      * Emits an `Approval` event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      * - `spender` must have allowance for the caller of at least
381      * `subtractedValue`.
382      */
383     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
384         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
385         return true;
386     }
387 
388     /**
389      * @dev Moves tokens `amount` from `sender` to `recipient`.
390      *
391      * This is internal function is equivalent to `transfer`, and can be used to
392      * e.g. implement automatic token fees, slashing mechanisms, etc.
393      *
394      * Emits a `Transfer` event.
395      *
396      * Requirements:
397      *
398      * - `sender` cannot be the zero address.
399      * - `recipient` cannot be the zero address.
400      * - `sender` must have a balance of at least `amount`.
401      */
402     function _transfer(address sender, address recipient, uint256 amount) internal {
403         require(sender != address(0), "ERC20: transfer from the zero address");
404         require(recipient != address(0), "ERC20: transfer to the zero address");
405 
406         _balances[sender] = _balances[sender].sub(amount);
407         _balances[recipient] = _balances[recipient].add(amount);
408         emit Transfer(sender, recipient, amount);
409     }
410 
411      /**
412      * @dev Destoys `amount` tokens from `account`, reducing the
413      * total supply.
414      *
415      * Emits a `Transfer` event with `to` set to the zero address.
416      *
417      * Requirements
418      *
419      * - `account` cannot be the zero address.
420      * - `account` must have at least `amount` tokens.
421      */
422     function _burn(address account, uint256 value) internal {
423         require(account != address(0), "ERC20: burn from the zero address");
424 
425         _totalSupply = _totalSupply.sub(value);
426         _balances[account] = _balances[account].sub(value);
427         emit Transfer(account, address(0), value);
428     }
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
432      *
433      * This is internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an `Approval` event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(address owner, address spender, uint256 value) internal {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446 
447         _allowances[owner][spender] = value;
448         emit Approval(owner, spender, value);
449     }
450     
451 }
452 
453 
454 /**
455  * @dev Extension of `ERC20` that allows token holders to destroy both their own
456  * tokens and those that they have an allowance for, in a way that can be
457  * recognized off-chain (via event analysis).
458  */
459 contract ERC20Burnable is ERC20 {
460     /**
461      * @dev Destoys `amount` tokens from the caller.
462      *
463      * See `ERC20._burn`.
464      */
465     function burn(uint256 amount) public onlyOwner {
466         _burn(msg.sender, amount);
467     }
468 }
469 
470 
471 /**
472  * @dev ACENT Token implementation.
473  */
474 contract ACENTToken is  ERC20Burnable {
475     using SafeMath for uint256;
476 
477     string public constant name = "ACENT";
478     string public constant symbol = "ACE";
479     uint8 public constant decimals = 18;
480 
481     uint256 internal constant INITIAL_SUPPLY = 2 * (10**9) * (10 ** uint256(decimals)); // 2 billions tokens
482 
483     /**
484     * @dev Constructor that gives msg.sender all of existing tokens.
485     */
486     constructor() public {
487         _totalSupply = INITIAL_SUPPLY;
488         _balances[msg.sender] = INITIAL_SUPPLY;
489         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
490     }
491 }