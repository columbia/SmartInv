1 pragma solidity ^0.5.0;
2 
3 contract Context {
4     // Empty internal constructor, to prevent people from mistakenly deploying
5     // an instance of this contract, which should be used via inheritance.
6     constructor () internal { }
7     // solhint-disable-previous-line no-empty-blocks
8 
9     function _msgSender() internal view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
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
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
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
71      * Emits a {Transfer} event.
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
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      * - Subtraction cannot overflow.
128      *
129      * _Available since v2.4.0._
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      *
187      * _Available since v2.4.0._
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         // Solidity only automatically asserts when dividing by 0
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 contract ERC20Detailed is IERC20 {
233     string private _name;
234     string private _symbol;
235     uint8 private _decimals;
236 
237     /**
238      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
239      * these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor (string memory name, string memory symbol, uint8 decimals) public {
243         _name = name;
244         _symbol = symbol;
245         _decimals = decimals;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei.
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view returns (uint8) {
276         return _decimals;
277     }
278 }
279 
280 contract MinterRole is Context {
281     using Roles for Roles.Role;
282 
283     event MinterAdded(address indexed account);
284     event MinterRemoved(address indexed account);
285 
286     Roles.Role private _minters;
287 
288     constructor () internal {
289         _addMinter(_msgSender());
290     }
291 
292     modifier onlyMinter() {
293         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
294         _;
295     }
296 
297     function isMinter(address account) public view returns (bool) {
298         return _minters.has(account);
299     }
300 
301     function addMinter(address account) public onlyMinter {
302         _addMinter(account);
303     }
304 
305     function renounceMinter() public {
306         _removeMinter(_msgSender());
307     }
308 
309     function _addMinter(address account) internal {
310         _minters.add(account);
311         emit MinterAdded(account);
312     }
313 
314     function _removeMinter(address account) internal {
315         _minters.remove(account);
316         emit MinterRemoved(account);
317     }
318 }
319 
320 library Roles {
321     struct Role {
322         mapping (address => bool) bearer;
323     }
324 
325     /**
326      * @dev Give an account access to this role.
327      */
328     function add(Role storage role, address account) internal {
329         require(!has(role, account), "Roles: account already has role");
330         role.bearer[account] = true;
331     }
332 
333     /**
334      * @dev Remove an account's access to this role.
335      */
336     function remove(Role storage role, address account) internal {
337         require(has(role, account), "Roles: account does not have role");
338         role.bearer[account] = false;
339     }
340 
341     /**
342      * @dev Check if an account has this role.
343      * @return bool
344      */
345     function has(Role storage role, address account) internal view returns (bool) {
346         require(account != address(0), "Roles: account is the zero address");
347         return role.bearer[account];
348     }
349 }
350 
351 contract ERC20 is Context, IERC20 {
352     using SafeMath for uint256;
353 
354     mapping (address => uint256) private _balances;
355 
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     uint256 private _totalSupply;
359 
360     /**
361      * @dev See {IERC20-totalSupply}.
362      */
363     function totalSupply() public view returns (uint256) {
364         return _totalSupply;
365     }
366 
367     /**
368      * @dev See {IERC20-balanceOf}.
369      */
370     function balanceOf(address account) public view returns (uint256) {
371         return _balances[account];
372     }
373 
374     /**
375      * @dev See {IERC20-transfer}.
376      *
377      * Requirements:
378      *
379      * - `recipient` cannot be the zero address.
380      * - the caller must have a balance of at least `amount`.
381      */
382     function transfer(address recipient, uint256 amount) public returns (bool) {
383         _transfer(_msgSender(), recipient, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-allowance}.
389      */
390     function allowance(address owner, address spender) public view returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     /**
395      * @dev See {IERC20-approve}.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 amount) public returns (bool) {
402         _approve(_msgSender(), spender, amount);
403         return true;
404     }
405 
406     /**
407      * @dev See {IERC20-transferFrom}.
408      *
409      * Emits an {Approval} event indicating the updated allowance. This is not
410      * required by the EIP. See the note at the beginning of {ERC20};
411      *
412      * Requirements:
413      * - `sender` and `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      * - the caller must have allowance for `sender`'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
419         _transfer(sender, recipient, amount);
420         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
437         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
438         return true;
439     }
440 
441     /**
442      * @dev Atomically decreases the allowance granted to `spender` by the caller.
443      *
444      * This is an alternative to {approve} that can be used as a mitigation for
445      * problems described in {IERC20-approve}.
446      *
447      * Emits an {Approval} event indicating the updated allowance.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      * - `spender` must have allowance for the caller of at least
453      * `subtractedValue`.
454      */
455     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
456         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
457         return true;
458     }
459 
460     /**
461      * @dev Moves tokens `amount` from `sender` to `recipient`.
462      *
463      * This is internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `sender` cannot be the zero address.
471      * - `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      */
474     function _transfer(address sender, address recipient, uint256 amount) internal {
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
479         _balances[recipient] = _balances[recipient].add(amount);
480         emit Transfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements
489      *
490      * - `to` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _totalSupply = _totalSupply.add(amount);
496         _balances[account] = _balances[account].add(amount);
497         emit Transfer(address(0), account, amount);
498     }
499 
500     /**
501      * @dev Destroys `amount` tokens from `account`, reducing the
502      * total supply.
503      *
504      * Emits a {Transfer} event with `to` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `account` cannot be the zero address.
509      * - `account` must have at least `amount` tokens.
510      */
511     function _burn(address account, uint256 amount) internal {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
515         _totalSupply = _totalSupply.sub(amount);
516         emit Transfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
521      *
522      * This is internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(address owner, address spender, uint256 amount) internal {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
542      * from the caller's allowance.
543      *
544      * See {_burn} and {_approve}.
545      */
546     function _burnFrom(address account, uint256 amount) internal {
547         _burn(account, amount);
548         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
549     }
550 }
551 
552 contract ERC20Mintable is ERC20, MinterRole {
553     /**
554      * @dev See {ERC20-_mint}.
555      *
556      * Requirements:
557      *
558      * - the caller must have the {MinterRole}.
559      */
560     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
561         _mint(account, amount);
562         return true;
563     }
564 }
565 
566 contract Token is ERC20, ERC20Detailed, ERC20Mintable {
567 
568     constructor () public ERC20Detailed("Autonio", "NIOX", 4) {
569         _mint(msg.sender, 300000000 * (10 ** uint256(decimals())));
570     }
571 }