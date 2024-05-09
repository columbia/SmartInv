1 pragma solidity 0.5.17;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // Empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
31  * the optional functions; to access them see {ERC20Detailed}.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      * - Subtraction cannot overflow.
155      *
156      * _Available since v2.4.0._
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      * - The divisor cannot be zero.
213      *
214      * _Available since v2.4.0._
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      *
251      * _Available since v2.4.0._
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 /**
260  * @dev Implementation of the {IERC20} interface.
261  *
262  * This implementation is agnostic to the way tokens are created. This means
263  * that a supply mechanism has to be added in a derived contract using {_mint}.
264  * For a generic mechanism see {ERC20Mintable}.
265  *
266  * TIP: For a detailed writeup see our guide
267  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
268  * to implement supply mechanisms].
269  *
270  * We have followed general OpenZeppelin guidelines: functions revert instead
271  * of returning `false` on failure. This behavior is nonetheless conventional
272  * and does not conflict with the expectations of ERC20 applications.
273  *
274  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
275  * This allows applications to reconstruct the allowance for all accounts just
276  * by listening to said events. Other implementations of the EIP may not emit
277  * these events, as it isn't required by the specification.
278  *
279  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
280  * functions have been added to mitigate the well-known issues around setting
281  * allowances. See {IERC20-approve}.
282  */
283 contract ERC20 is Context, IERC20 {
284     using SafeMath for uint256;
285 
286     mapping (address => uint256) private _balances;
287 
288     mapping (address => mapping (address => uint256)) private _allowances;
289 
290     uint256 private _totalSupply;
291 
292     /**
293      * @dev See {IERC20-totalSupply}.
294      */
295     function totalSupply() public view returns (uint256) {
296         return _totalSupply;
297     }
298 
299     /**
300      * @dev See {IERC20-balanceOf}.
301      */
302     function balanceOf(address account) public view returns (uint256) {
303         return _balances[account];
304     }
305 
306     /**
307      * @dev See {IERC20-transfer}.
308      *
309      * Requirements:
310      *
311      * - `recipient` cannot be the zero address.
312      * - the caller must have a balance of at least `amount`.
313      */
314     function transfer(address recipient, uint256 amount) public returns (bool) {
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-allowance}.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowances[owner][spender];
324     }
325 
326     /**
327      * @dev See {IERC20-approve}.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function approve(address spender, uint256 amount) public returns (bool) {
334         _approve(_msgSender(), spender, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-transferFrom}.
340      *
341      * Emits an {Approval} event indicating the updated allowance. This is not
342      * required by the EIP. See the note at the beginning of {ERC20};
343      *
344      * Requirements:
345      * - `sender` and `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      * - the caller must have allowance for `sender`'s tokens of at least
348      * `amount`.
349      */
350     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
351         _transfer(sender, recipient, amount);
352         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
353         return true;
354     }
355 
356     /**
357      * @dev Atomically increases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically decreases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      * - `spender` must have allowance for the caller of at least
385      * `subtractedValue`.
386      */
387     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
389         return true;
390     }
391 
392     /**
393      * @dev Moves tokens `amount` from `sender` to `recipient`.
394      *
395      * This is internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
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
410         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `to` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _totalSupply = _totalSupply.add(amount);
428         _balances[account] = _balances[account].add(amount);
429         emit Transfer(address(0), account, amount);
430     }
431 
432      /**
433      * @dev Destroys `amount` tokens from `account`, reducing the
434      * total supply.
435      *
436      * Emits a {Transfer} event with `to` set to the zero address.
437      *
438      * Requirements
439      *
440      * - `account` cannot be the zero address.
441      * - `account` must have at least `amount` tokens.
442      */
443     function _burn(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: burn from the zero address");
445 
446         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
447         _totalSupply = _totalSupply.sub(amount);
448         emit Transfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
453      *
454      * This is internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(address owner, address spender, uint256 amount) internal {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
474      * from the caller's allowance.
475      *
476      * See {_burn} and {_approve}.
477      */
478     function _burnFrom(address account, uint256 amount) internal {
479         _burn(account, amount);
480         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
481     }
482 }
483 
484 contract TraceNetworkToken is ERC20 {
485 
486     uint public totalTokensAmount = 100000000;
487 
488     string public name = "Trace Network";
489     string public symbol = "TRACE";
490     uint8 public decimals = 18;
491 
492     bool public paused = false;
493 
494     address public pauser;
495 
496     event Paused();
497     event Unpaused();
498 
499     constructor() public {
500         // mint totalTokensAmount times 10^decimals for operator
501         _mint(_msgSender(), totalTokensAmount  * (10 ** uint256(decimals)));
502 
503         pauser = _msgSender();
504     }
505 
506     function changePauser(address pauser_) external {
507         require(_msgSender() == pauser, "Invalid access");
508         pauser = pauser_;
509     }
510 
511     function pause() external {
512         require(_msgSender() == pauser, "Invalid access");
513         paused = true;
514         emit Paused();
515     }
516 
517     function unpause() external {
518         require(_msgSender() == pauser, "Invalid access");
519         paused = false;
520         pauser = address(0); //Can only be paused once
521         emit Unpaused();
522     }
523 
524 
525     function _transfer(
526         address sender,
527         address recipient,
528         uint256 amount
529     )
530         internal
531     {
532         require(!paused, "Transfer is paused");
533         super._transfer(sender, recipient, amount);
534     }
535 }