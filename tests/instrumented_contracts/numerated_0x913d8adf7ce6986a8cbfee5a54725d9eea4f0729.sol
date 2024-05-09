1 /*
2  * @dev Provides information about the current execution context, including the
3  * sender of the transaction and its data. While these are generally available
4  * via msg.sender and msg.data, they should not be accessed in such a direct
5  * manner, since when dealing with GSN meta-transactions the account sending and
6  * paying for execution may not be the actual sender (as far as an application
7  * is concerned).
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 contract Context {
12     // Empty internal constructor, to prevent people from mistakenly deploying
13     // an instance of this contract, which should be used via inheritance.
14     constructor () internal { }
15     // solhint-disable-previous-line no-empty-blocks
16 
17     function _msgSender() internal view returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
29  * the optional functions; to access them see {ERC20Detailed}.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      * - Subtraction cannot overflow.
153      *
154      * _Available since v2.4.0._
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      *
212      * _Available since v2.4.0._
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         // Solidity only automatically asserts when dividing by 0
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      * - The divisor cannot be zero.
248      *
249      * _Available since v2.4.0._
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 /**
258  * @dev Implementation of the {IERC20} interface.
259  *
260  * This implementation is agnostic to the way tokens are created. This means
261  * that a supply mechanism has to be added in a derived contract using {_mint}.
262  * For a generic mechanism see {ERC20Mintable}.
263  *
264  * TIP: For a detailed writeup see our guide
265  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
266  * to implement supply mechanisms].
267  *
268  * We have followed general OpenZeppelin guidelines: functions revert instead
269  * of returning `false` on failure. This behavior is nonetheless conventional
270  * and does not conflict with the expectations of ERC20 applications.
271  *
272  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
273  * This allows applications to reconstruct the allowance for all accounts just
274  * by listening to said events. Other implementations of the EIP may not emit
275  * these events, as it isn't required by the specification.
276  *
277  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
278  * functions have been added to mitigate the well-known issues around setting
279  * allowances. See {IERC20-approve}.
280  */
281 contract ERC20 is Context, IERC20 {
282     using SafeMath for uint256;
283 
284     mapping (address => uint256) private _balances;
285 
286     mapping (address => mapping (address => uint256)) private _allowances;
287 
288     uint256 private _totalSupply;
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `recipient` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address recipient, uint256 amount) public returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function approve(address spender, uint256 amount) public returns (bool) {
332         _approve(_msgSender(), spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20};
341      *
342      * Requirements:
343      * - `sender` and `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      * - the caller must have allowance for `sender`'s tokens of at least
346      * `amount`.
347      */
348     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
349         _transfer(sender, recipient, amount);
350         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
367         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
368         return true;
369     }
370 
371     /**
372      * @dev Atomically decreases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      * - `spender` must have allowance for the caller of at least
383      * `subtractedValue`.
384      */
385     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
387         return true;
388     }
389 
390     /**
391      * @dev Moves tokens `amount` from `sender` to `recipient`.
392      *
393      * This is internal function is equivalent to {transfer}, and can be used to
394      * e.g. implement automatic token fees, slashing mechanisms, etc.
395      *
396      * Emits a {Transfer} event.
397      *
398      * Requirements:
399      *
400      * - `sender` cannot be the zero address.
401      * - `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      */
404     function _transfer(address sender, address recipient, uint256 amount) internal {
405         require(sender != address(0), "ERC20: transfer from the zero address");
406         require(recipient != address(0), "ERC20: transfer to the zero address");
407 
408         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
409         _balances[recipient] = _balances[recipient].add(amount);
410         emit Transfer(sender, recipient, amount);
411     }
412 
413     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
414      * the total supply.
415      *
416      * Emits a {Transfer} event with `from` set to the zero address.
417      *
418      * Requirements
419      *
420      * - `to` cannot be the zero address.
421      */
422     function _mint(address account, uint256 amount) internal {
423         require(account != address(0), "ERC20: mint to the zero address");
424 
425         _totalSupply = _totalSupply.add(amount);
426         _balances[account] = _balances[account].add(amount);
427         emit Transfer(address(0), account, amount);
428     }
429 
430      /**
431      * @dev Destroys `amount` tokens from `account`, reducing the
432      * total supply.
433      *
434      * Emits a {Transfer} event with `to` set to the zero address.
435      *
436      * Requirements
437      *
438      * - `account` cannot be the zero address.
439      * - `account` must have at least `amount` tokens.
440      */
441     function _burn(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: burn from the zero address");
443 
444         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
445         _totalSupply = _totalSupply.sub(amount);
446         emit Transfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
451      *
452      * This is internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(address owner, address spender, uint256 amount) internal {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
472      * from the caller's allowance.
473      *
474      * See {_burn} and {_approve}.
475      */
476     function _burnFrom(address account, uint256 amount) internal {
477         _burn(account, amount);
478         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
479     }
480 }
481 
482 contract EasyToken is ERC20 {
483 
484     uint public totalTokensAmount = 10000000;
485 
486     string public name = "EASY";
487     string public symbol = "EASY";
488     uint8 public decimals = 18;
489 
490     bool public paused = false;
491 
492     address public pauser;
493 
494     event Paused();
495     event Unpaused();
496 
497     constructor() public {
498         // mint totalTokensAmount times 10^decimals for operator
499         _mint(_msgSender(), totalTokensAmount  * (10 ** uint256(decimals)));
500 
501         pauser = _msgSender();
502     }
503 
504     function changePauser(address pauser_) external {
505         require(_msgSender() == pauser, "Invalid access");
506         pauser = pauser_;
507     }
508 
509     function pause() external {
510         require(_msgSender() == pauser, "Invalid access");
511         paused = true;
512         emit Paused();
513     }
514 
515     function unpause() external {
516         require(_msgSender() == pauser, "Invalid access");
517         paused = false;
518         pauser = address(0); //Can only be paused once
519         emit Unpaused();
520     }
521 
522 
523     function _transfer(
524         address sender,
525         address recipient,
526         uint256 amount
527     )
528         internal
529     {
530         require(!paused, "Transfer is paused");
531         super._transfer(sender, recipient, amount);
532     }
533 }