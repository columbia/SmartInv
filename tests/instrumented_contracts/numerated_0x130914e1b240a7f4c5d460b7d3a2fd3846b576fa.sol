1 pragma solidity ^0.5.0;
2 /**
3  * @dev Wrappers over Solidity's arithmetic operations with added overflow
4  * checks.
5  *
6  * Arithmetic operations in Solidity wrap on overflow. This can easily result
7  * in bugs, because programmers usually assume that an overflow raises an
8  * error, which is the standard behavior in high level programming languages.
9  * `SafeMath` restores this intuition by reverting the transaction when an
10  * operation overflows.
11  *
12  * Using this library instead of the unchecked operations eliminates an entire
13  * class of bugs, so it's recommended to use it always.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, reverting on
18      * overflow.
19      *
20      * Counterpart to Solidity's `+` operator.
21      *
22      * Requirements:
23      * - Addition cannot overflow.
24      */
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30     /**
31      * @dev Returns the subtraction of two unsigned integers, reverting on
32      * overflow (when the result is negative).
33      *
34      * Counterpart to Solidity's `-` operator.
35      *
36      * Requirements:
37      * - Subtraction cannot overflow.
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42     /**
43      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
44      * overflow (when the result is negative).
45      *
46      * Counterpart to Solidity's `-` operator.
47      *
48      * Requirements:
49      * - Subtraction cannot overflow.
50      *
51      * _Available since v2.4.0._
52      */
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      * - Multiplication cannot overflow.
66      */
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      *
103      * _Available since v2.4.0._
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         // Solidity only automatically asserts when dividing by 0
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110         return c;
111     }
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts with custom message when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      *
137      * _Available since v2.4.0._
138      */
139     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b != 0, errorMessage);
141         return a % b;
142     }
143 }
144 
145 
146 /**
147  * @title Roles
148  * @dev Library for managing addresses assigned to a Role.
149  */
150 library Roles {
151     struct Role {
152         mapping(address => bool) bearer;
153     }
154 
155     /**
156      * @dev Give an account access to this role.
157      */
158     function add(Role storage role, address account) internal {
159         require(!has(role, account), "Roles: account already has role");
160         role.bearer[account] = true;
161     }
162 
163     /**
164      * @dev Remove an account's access to this role.
165      */
166     function remove(Role storage role, address account) internal {
167         require(has(role, account), "Roles: account does not have role");
168         role.bearer[account] = false;
169     }
170 
171     /**
172      * @dev Check if an account has this role.
173      * @return bool
174      */
175     function has(Role storage role, address account) internal view returns (bool) {
176         require(account != address(0), "Roles: account is the zero address");
177         return role.bearer[account];
178     }
179 }
180 
181 /**
182  * @title Pusher
183  * @dev Library for managing addresses assigned to a Role.
184  */
185 contract PusherRole {
186     using Roles for Roles.Role;
187 
188     event PusherAdded(address indexed account);
189     event PusherRemoved(address indexed account);
190 
191     Roles.Role private _pushers;
192 
193     constructor () internal {
194         _addPusher(msg.sender);
195     }
196 
197     modifier onlyPusher() {
198         require(isPusher(msg.sender), "Pusher: caller does not have the Pusher role");
199         _;
200     }
201 
202     function isPusher(address account) public view returns (bool) {
203         return _pushers.has(account);
204     }
205 
206     function addPusher(address account) public onlyPusher {
207         _addPusher(account);
208     }
209 
210     function renouncePusher() public {
211         _removePusher(msg.sender);
212     }
213 
214     function _addPusher(address account) internal {
215         _pushers.add(account);
216         emit PusherAdded(account);
217     }
218 
219     function _removePusher(address account) internal {
220         _pushers.remove(account);
221         emit PusherRemoved(account);
222     }
223 }
224 
225 /*
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with GSN meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 contract Context {
236     // Empty internal constructor, to prevent people from mistakenly deploying
237     // an instance of this contract, which should be used via inheritance.
238     constructor () internal { }
239     // solhint-disable-previous-line no-empty-blocks
240     function _msgSender() internal view returns (address payable) {
241         return msg.sender;
242     }
243     function _msgData() internal view returns (bytes memory) {
244         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
245         return msg.data;
246     }
247 }
248 /**
249  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
250  * the optional functions; to access them see {ERC20Detailed}.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257     /**
258      * @dev Returns the amount of tokens owned by `account`.
259      */
260     function balanceOf(address account) external view returns (uint256);
261     /**
262      * @dev Moves `amount` tokens from the caller's account to `recipient`.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transfer(address recipient, uint256 amount) external returns (bool);
269     /**
270      * @dev Returns the remaining number of tokens that `spender` will be
271      * allowed to spend on behalf of `owner` through {transferFrom}. This is
272      * zero by default.
273      *
274      * This value changes when {approve} or {transferFrom} are called.
275      */
276     function allowance(address owner, address spender) external view returns (uint256);
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292     /**
293      * @dev Moves `amount` tokens from `sender` to `recipient` using the
294      * allowance mechanism. `amount` is then deducted from the caller's
295      * allowance.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
302     /**
303      * @dev Emitted when `value` tokens are moved from one account (`from`) to
304      * another (`to`).
305      *
306      * Note that `value` may be zero.
307      */
308     event Transfer(address indexed from, address indexed to, uint256 value);
309     /**
310      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
311      * a call to {approve}. `value` is the new allowance.
312      */
313     event Approval(address indexed owner, address indexed spender, uint256 value);
314 }
315 /**
316  * @dev Implementation of the {IERC20} interface.
317  *
318  * This implementation is agnostic to the way tokens are created. This means
319  * that a supply mechanism has to be added in a derived contract using {_mint}.
320  * For a generic mechanism see {ERC20Mintable}.
321  *
322  * TIP: For a detailed writeup see our guide
323  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
324  * to implement supply mechanisms].
325  *
326  * We have followed general OpenZeppelin guidelines: functions revert instead
327  * of returning `false` on failure. This behavior is nonetheless conventional
328  * and does not conflict with the expectations of ERC20 applications.
329  *
330  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
331  * This allows applications to reconstruct the allowance for all accounts just
332  * by listening to said events. Other implementations of the EIP may not emit
333  * these events, as it isn't required by the specification.
334  *
335  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
336  * functions have been added to mitigate the well-known issues around setting
337  * allowances. See {IERC20-approve}.
338  */
339 contract ERC20 is Context, IERC20 {
340     using SafeMath for uint256;
341     mapping (address => uint256) private _balances;
342     mapping (address => mapping (address => uint256)) private _allowances;
343     uint256 private _totalSupply;
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view returns (uint256) {
348         return _totalSupply;
349     }
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account) public view returns (uint256) {
354         return _balances[account];
355     }
356     /**
357      * @dev See {IERC20-transfer}.
358      *
359      * Requirements:
360      *
361      * - `recipient` cannot be the zero address.
362      * - the caller must have a balance of at least `amount`.
363      */
364     function transfer(address recipient, uint256 amount) public returns (bool) {
365         _transfer(_msgSender(), recipient, amount);
366         return true;
367     }
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender) public view returns (uint256) {
372         return _allowances[owner][spender];
373     }
374     /**
375      * @dev See {IERC20-approve}.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function approve(address spender, uint256 amount) public returns (bool) {
382         _approve(_msgSender(), spender, amount);
383         return true;
384     }
385     /**
386      * @dev See {IERC20-transferFrom}.
387      *
388      * Emits an {Approval} event indicating the updated allowance. This is not
389      * required by the EIP. See the note at the beginning of {ERC20};
390      *
391      * Requirements:
392      * - `sender` and `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      * - the caller must have allowance for `sender`'s tokens of at least
395      * `amount`.
396      */
397     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
398         _transfer(sender, recipient, amount);
399         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
400         return true;
401     }
402     /**
403      * @dev Atomically increases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
415         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
416         return true;
417     }
418     /**
419      * @dev Atomically decreases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      * - `spender` must have allowance for the caller of at least
430      * `subtractedValue`.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
433         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
434         return true;
435     }
436     /**
437      * @dev Moves tokens `amount` from `sender` to `recipient`.
438      *
439      * This is internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `sender` cannot be the zero address.
447      * - `recipient` cannot be the zero address.
448      * - `sender` must have a balance of at least `amount`.
449      */
450     function _transfer(address sender, address recipient, uint256 amount) internal {
451         require(sender != address(0), "ERC20: transfer from the zero address");
452         require(recipient != address(0), "ERC20: transfer to the zero address");
453         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
454         _balances[recipient] = _balances[recipient].add(amount);
455         emit Transfer(sender, recipient, amount);
456     }
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements
463      *
464      * - `to` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal {
467         require(account != address(0), "ERC20: mint to the zero address");
468         _totalSupply = _totalSupply.add(amount);
469         _balances[account] = _balances[account].add(amount);
470         emit Transfer(address(0), account, amount);
471     }
472     /**
473      * @dev Destroys `amount` tokens from `account`, reducing the
474      * total supply.
475      *
476      * Emits a {Transfer} event with `to` set to the zero address.
477      *
478      * Requirements
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens.
482      */
483     function _burn(address account, uint256 amount) internal {
484         require(account != address(0), "ERC20: burn from the zero address");
485         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
486         _totalSupply = _totalSupply.sub(amount);
487         emit Transfer(account, address(0), amount);
488     }
489     /**
490      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
491      *
492      * This is internal function is equivalent to `approve`, and can be used to
493      * e.g. set automatic allowances for certain subsystems, etc.
494      *
495      * Emits an {Approval} event.
496      *
497      * Requirements:
498      *
499      * - `owner` cannot be the zero address.
500      * - `spender` cannot be the zero address.
501      */
502     function _approve(address owner, address spender, uint256 amount) internal {
503         require(owner != address(0), "ERC20: approve from the zero address");
504         require(spender != address(0), "ERC20: approve to the zero address");
505         _allowances[owner][spender] = amount;
506         emit Approval(owner, spender, amount);
507     }
508     /**
509      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
510      * from the caller's allowance.
511      *
512      * See {_burn} and {_approve}.
513      */
514     function _burnFrom(address account, uint256 amount) internal {
515         _burn(account, amount);
516         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
517     }
518 }
519 
520 contract AureusNummusGold is ERC20, PusherRole{
521     
522     string public constant name = 'Aureus Nummus Gold';
523     string public constant symbol = 'ANG';
524     uint8 public constant decimals = 18;
525     uint constant _supply = 60000000000000 * 10**18;
526 
527     /**
528      * @dev Price in USD for one token in 10 to the power 18 part
529      * so, 1 USD = 10^18
530      */
531     uint256 public tokenPrice;
532 
533     /**
534      * @dev Constructor that gives msg.sender all of existing tokens.
535      */
536     constructor() public {
537         _mint(msg.sender, _supply);
538     }
539     
540     event TokenPriceUpdated(uint256 indexed _price);
541     
542     /**
543      * @dev Update token price only by Pusher role.
544      * @param _price new price to be set
545      */
546     function updateTokenPrice(uint256 _price) external onlyPusher{
547         tokenPrice = _price;
548         emit TokenPriceUpdated(_price);
549     }
550     
551     /**
552      * @dev Price in USD for token holded by an account in 10 to the power 18 part
553      * @param account to check the equivalent USD value
554      * @return uint256 equivalent USD value of token in 10 to the power 18 part
555      */
556     function getTokenPrice(address account) public view returns (uint256) {
557         return balanceOf(account).mul(tokenPrice).div(10**18);
558     }
559     
560 }