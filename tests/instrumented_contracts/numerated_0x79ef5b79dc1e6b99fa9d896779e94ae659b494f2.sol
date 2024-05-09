1 pragma solidity ^0.5.16;
2 
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      * - Subtraction cannot overflow.
129      *
130      * _Available since v2.4.0._
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         // Solidity only automatically asserts when dividing by 0
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      * - The divisor cannot be zero.
224      *
225      * _Available since v2.4.0._
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 contract ERC20 is Context, IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `recipient` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address recipient, uint256 amount) public returns (bool) {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender) public view returns (uint256) {
273         return _allowances[owner][spender];
274     }
275 
276     /**
277      * @dev See {IERC20-approve}.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public returns (bool) {
284         _approve(_msgSender(), spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20};
293      *
294      * Requirements:
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for `sender`'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
301         _transfer(sender, recipient, amount);
302         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
339         return true;
340     }
341 
342     /**
343      * @dev Moves tokens `amount` from `sender` to `recipient`.
344      *
345      * This is internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(address sender, address recipient, uint256 amount) internal {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359 
360         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
361         _balances[recipient] = _balances[recipient].add(amount);
362         emit Transfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements
371      *
372      * - `to` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _totalSupply = _totalSupply.add(amount);
378         _balances[account] = _balances[account].add(amount);
379         emit Transfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
397         _totalSupply = _totalSupply.sub(amount);
398         emit Transfer(account, address(0), amount);
399     }
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
403      *
404      * This is internal function is equivalent to `approve`, and can be used to
405      * e.g. set automatic allowances for certain subsystems, etc.
406      *
407      * Emits an {Approval} event.
408      *
409      * Requirements:
410      *
411      * - `owner` cannot be the zero address.
412      * - `spender` cannot be the zero address.
413      */
414     function _approve(address owner, address spender, uint256 amount) internal {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417 
418         _allowances[owner][spender] = amount;
419         emit Approval(owner, spender, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
424      * from the caller's allowance.
425      *
426      * See {_burn} and {_approve}.
427      */
428     function _burnFrom(address account, uint256 amount) internal {
429         _burn(account, amount);
430         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
431     }
432 }
433 
434 library Roles {
435     struct Role {
436         mapping (address => bool) bearer;
437     }
438 
439     /**
440      * @dev Give an account access to this role.
441      */
442     function add(Role storage role, address account) internal {
443         require(!has(role, account), "Roles: account already has role");
444         role.bearer[account] = true;
445     }
446 
447     /**
448      * @dev Remove an account's access to this role.
449      */
450     function remove(Role storage role, address account) internal {
451         require(has(role, account), "Roles: account does not have role");
452         role.bearer[account] = false;
453     }
454 
455     /**
456      * @dev Check if an account has this role.
457      * @return bool
458      */
459     function has(Role storage role, address account) internal view returns (bool) {
460         require(account != address(0), "Roles: account is the zero address");
461         return role.bearer[account];
462     }
463 }
464 
465 contract MinterRole is Context {
466     using Roles for Roles.Role;
467 
468     event MinterAdded(address indexed account);
469     event MinterRemoved(address indexed account);
470 
471     Roles.Role private _minters;
472 
473     constructor () internal {
474         _addMinter(_msgSender());
475     }
476 
477     modifier onlyMinter() {
478         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
479         _;
480     }
481 
482     function isMinter(address account) public view returns (bool) {
483         return _minters.has(account);
484     }
485 
486     function addMinter(address account) public onlyMinter {
487         _addMinter(account);
488     }
489 
490     function renounceMinter() public {
491         _removeMinter(_msgSender());
492     }
493 
494     function _addMinter(address account) internal {
495         _minters.add(account);
496         emit MinterAdded(account);
497     }
498 
499     function _removeMinter(address account) internal {
500         _minters.remove(account);
501         emit MinterRemoved(account);
502     }
503 }
504 
505 contract ERC20Mintable is ERC20, MinterRole {
506     /**
507      * @dev See {ERC20-_mint}.
508      *
509      * Requirements:
510      *
511      * - the caller must have the {MinterRole}.
512      */
513     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
514         _mint(account, amount);
515         return true;
516     }
517 }
518 
519 contract ERC20Burnable is Context, ERC20 {
520     /**
521      * @dev Destroys `amount` tokens from the caller.
522      *
523      * See {ERC20-_burn}.
524      */
525     function burn(uint256 amount) public {
526         _burn(_msgSender(), amount);
527     }
528 
529     /**
530      * @dev See {ERC20-_burnFrom}.
531      */
532     function burnFrom(address account, uint256 amount) public {
533         _burnFrom(account, amount);
534     }
535 }
536 
537 contract MythicalToken is ERC20, ERC20Mintable, ERC20Burnable {
538   string public name     = "Mythical Token";
539   string public symbol   = "MYTH";
540   uint8 public decimals  = 9;
541 
542   constructor() public {
543     _mint(msg.sender, 1000000000000000);
544   }
545 
546   function airdrop(address[] memory addresses, uint256 amount) public onlyMinter returns (bool) {
547     for(uint i=0; i<addresses.length; i++){
548         _mint(addresses[i], amount);
549     }
550     return true;
551   }
552 
553   function wagered(uint256 amount) public onlyMinter returns (bool) {
554     _burn(msg.sender, amount);
555     return true;
556   }
557 }