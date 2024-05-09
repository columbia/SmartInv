1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-26
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 contract Context {
8     // Empty internal constructor, to prevent people from mistakenly deploying
9     // an instance of this contract, which should be used via inheritance.
10     constructor () internal { }
11     // solhint-disable-previous-line no-empty-blocks
12 
13     function _msgSender() internal view returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      * - Subtraction cannot overflow.
132      *
133      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
134      * @dev Get it via `npm install @openzeppelin/contracts@next`.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191 
192      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
193      * @dev Get it via `npm install @openzeppelin/contracts@next`.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         // Solidity only automatically asserts when dividing by 0
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      * - The divisor cannot be zero.
229      *
230      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
231      * @dev Get it via `npm install @openzeppelin/contracts@next`.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 contract ERC20 is Context, IERC20 {
240     using SafeMath for uint256;
241 
242     mapping (address => uint256) private _balances;
243 
244     mapping (address => mapping (address => uint256)) private _allowances;
245 
246     uint256 private _totalSupply;
247 
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view returns (uint256) {
252         return _totalSupply;
253     }
254 
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view returns (uint256) {
259         return _balances[account];
260     }
261 
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public returns (bool) {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20};
299      *
300      * Requirements:
301      * - `sender` and `recipient` cannot be the zero address.
302      * - `sender` must have a balance of at least `amount`.
303      * - the caller must have allowance for `sender`'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
307         _transfer(sender, recipient, amount);
308         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
326         return true;
327     }
328 
329     /**
330      * @dev Atomically decreases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      * - `spender` must have allowance for the caller of at least
341      * `subtractedValue`.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
344         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
345         return true;
346     }
347 
348     /**
349      * @dev Moves tokens `amount` from `sender` to `recipient`.
350      *
351      * This is internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `sender` cannot be the zero address.
359      * - `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      */
362     function _transfer(address sender, address recipient, uint256 amount) internal {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
367         _balances[recipient] = _balances[recipient].add(amount);
368         emit Transfer(sender, recipient, amount);
369     }
370 
371     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
372      * the total supply.
373      *
374      * Emits a {Transfer} event with `from` set to the zero address.
375      *
376      * Requirements
377      *
378      * - `to` cannot be the zero address.
379      */
380     function _mint(address account, uint256 amount) internal {
381         require(account != address(0), "ERC20: mint to the zero address");
382 
383         _totalSupply = _totalSupply.add(amount);
384         _balances[account] = _balances[account].add(amount);
385         emit Transfer(address(0), account, amount);
386     }
387 
388     /**
389      * @dev Destroys `amount` tokens from `account`, reducing the
390      * total supply.
391      *
392      * Emits a {Transfer} event with `to` set to the zero address.
393      *
394      * Requirements
395      *
396      * - `account` cannot be the zero address.
397      * - `account` must have at least `amount` tokens.
398      */
399     function _burn(address account, uint256 amount) internal {
400         require(account != address(0), "ERC20: burn from the zero address");
401 
402         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
403         _totalSupply = _totalSupply.sub(amount);
404         emit Transfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
409      *
410      * This is internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(address owner, address spender, uint256 amount) internal {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
430      * from the caller's allowance.
431      *
432      * See {_burn} and {_approve}.
433      */
434     function _burnFrom(address account, uint256 amount) internal {
435         _burn(account, amount);
436         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
437     }
438 }
439 
440 contract ERC20Detailed is IERC20 {
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444 
445     /**
446      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
447      * these values are immutable: they can only be set once during
448      * construction.
449      */
450     constructor (string memory name, string memory symbol, uint8 decimals) public {
451         _name = name;
452         _symbol = symbol;
453         _decimals = decimals;
454     }
455 
456     /**
457      * @dev Returns the name of the token.
458      */
459     function name() public view returns (string memory) {
460         return _name;
461     }
462 
463     /**
464      * @dev Returns the symbol of the token, usually a shorter version of the
465      * name.
466      */
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     /**
472      * @dev Returns the number of decimals used to get its user representation.
473      * For example, if `decimals` equals `2`, a balance of `505` tokens should
474      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
475      *
476      * Tokens usually opt for a value of 18, imitating the relationship between
477      * Ether and Wei.
478      *
479      * NOTE: This information is only used for _display_ purposes: it in
480      * no way affects any of the arithmetic of the contract, including
481      * {IERC20-balanceOf} and {IERC20-transfer}.
482      */
483     function decimals() public view returns (uint8) {
484         return _decimals;
485     }
486 }
487 
488 library Roles {
489     struct Role {
490         mapping (address => bool) bearer;
491     }
492 
493     /**
494      * @dev Give an account access to this role.
495      */
496     function add(Role storage role, address account) internal {
497         require(!has(role, account), "Roles: account already has role");
498         role.bearer[account] = true;
499     }
500 
501     /**
502      * @dev Remove an account's access to this role.
503      */
504     function remove(Role storage role, address account) internal {
505         require(has(role, account), "Roles: account does not have role");
506         role.bearer[account] = false;
507     }
508 
509     /**
510      * @dev Check if an account has this role.
511      * @return bool
512      */
513     function has(Role storage role, address account) internal view returns (bool) {
514         require(account != address(0), "Roles: account is the zero address");
515         return role.bearer[account];
516     }
517 }
518 
519 contract MinterRole is Context {
520     using Roles for Roles.Role;
521 
522     event MinterAdded(address indexed account);
523     event MinterRemoved(address indexed account);
524 
525     Roles.Role private _minters;
526 
527     constructor () internal {
528         _addMinter(_msgSender());
529     }
530 
531     modifier onlyMinter() {
532         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
533         _;
534     }
535 
536     function isMinter(address account) public view returns (bool) {
537         return _minters.has(account);
538     }
539 
540     function addMinter(address account) public onlyMinter {
541         _addMinter(account);
542     }
543 
544     function renounceMinter() public {
545         _removeMinter(_msgSender());
546     }
547 
548     function _addMinter(address account) internal {
549         _minters.add(account);
550         emit MinterAdded(account);
551     }
552 
553     function _removeMinter(address account) internal {
554         _minters.remove(account);
555         emit MinterRemoved(account);
556     }
557 }
558 
559 contract ERC20Mintable is ERC20, MinterRole {
560     /**
561      * @dev See {ERC20-_mint}.
562      *
563      * Requirements:
564      *
565      * - the caller must have the {MinterRole}.
566      */
567     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
568         _mint(account, amount);
569         return true;
570     }
571 }
572 
573 /**
574  * @title SimpleToken
575  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
576  * Note they can later distribute these tokens as they wish using `transfer` and other
577  * `ERC20` functions.
578  */
579 contract Simbcoin is Context, ERC20, ERC20Detailed {
580 
581     /**
582      * @dev Constructor that gives _msgSender() all of existing tokens.
583      */
584     constructor (string memory _name, string memory _symbol, uint8 _decimals, uint256 _initsupply) public ERC20Detailed(_name, _symbol, _decimals) {
585         _mint(_msgSender(), _initsupply * (10 ** uint256(decimals())));
586     }
587 }