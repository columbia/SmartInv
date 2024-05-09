1 pragma solidity ^0.5.10;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
34  * the optional functions; to access them see {ERC20Detailed}.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 /**
110  * @dev Wrappers over Solidity's arithmetic operations with added overflow
111  * checks.
112  *
113  * Arithmetic operations in Solidity wrap on overflow. This can easily result
114  * in bugs, because programmers usually assume that an overflow raises an
115  * error, which is the standard behavior in high level programming languages.
116  * `SafeMath` restores this intuition by reverting the transaction when an
117  * operation overflows.
118  *
119  * Using this library instead of the unchecked operations eliminates an entire
120  * class of bugs, so it's recommended to use it always.
121  */
122 library SafeMath {
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         return sub(a, b, "SafeMath: subtraction overflow");
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      * - Subtraction cannot overflow.
160      *
161      * _Available since v2.4.0._
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, "SafeMath: multiplication overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         // Solidity only automatically asserts when dividing by 0
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242         return mod(a, b, "SafeMath: modulo by zero");
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts with custom message when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      *
256      * _Available since v2.4.0._
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 
265 /**
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20Mintable}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * We have followed general OpenZeppelin guidelines: functions revert instead
277  * of returning `false` on failure. This behavior is nonetheless conventional
278  * and does not conflict with the expectations of ERC20 applications.
279  *
280  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
281  * This allows applications to reconstruct the allowance for all accounts just
282  * by listening to said events. Other implementations of the EIP may not emit
283  * these events, as it isn't required by the specification.
284  *
285  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
286  * functions have been added to mitigate the well-known issues around setting
287  * allowances. See {IERC20-approve}.
288  */
289 contract ERC20 is Context, IERC20 {
290     using SafeMath for uint256;
291 
292     mapping (address => uint256) private _balances;
293 
294     mapping (address => mapping (address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20};
349      *
350      * Requirements:
351      * - `sender` and `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      * - the caller must have allowance for `sender`'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
357         _transfer(sender, recipient, amount);
358         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
359         return true;
360     }
361 
362     /**
363      * @dev Atomically increases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
375         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Atomically decreases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      * - `spender` must have allowance for the caller of at least
391      * `subtractedValue`.
392      */
393     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
395         return true;
396     }
397 
398     /**
399      * @dev Moves tokens `amount` from `sender` to `recipient`.
400      *
401      * This is internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(address sender, address recipient, uint256 amount) internal {
413         require(sender != address(0), "ERC20: transfer from the zero address");
414         require(recipient != address(0), "ERC20: transfer to the zero address");
415 
416         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `to` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _totalSupply = _totalSupply.add(amount);
434         _balances[account] = _balances[account].add(amount);
435         emit Transfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
453         _totalSupply = _totalSupply.sub(amount);
454         emit Transfer(account, address(0), amount);
455     }
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
459      *
460      * This is internal function is equivalent to `approve`, and can be used to
461      * e.g. set automatic allowances for certain subsystems, etc.
462      *
463      * Emits an {Approval} event.
464      *
465      * Requirements:
466      *
467      * - `owner` cannot be the zero address.
468      * - `spender` cannot be the zero address.
469      */
470     function _approve(address owner, address spender, uint256 amount) internal {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
480      * from the caller's allowance.
481      *
482      * See {_burn} and {_approve}.
483      */
484     function _burnFrom(address account, uint256 amount) internal {
485         _burn(account, amount);
486         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
487     }
488 }
489 
490 
491 /**
492  * @title Roles
493  * @dev Library for managing addresses assigned to a Role.
494  */
495 library Roles {
496     struct Role {
497         mapping (address => bool) bearer;
498     }
499 
500     /**
501      * @dev Give an account access to this role.
502      */
503     function add(Role storage role, address account) internal {
504         require(!has(role, account), "Roles: account already has role");
505         role.bearer[account] = true;
506     }
507 
508     /**
509      * @dev Remove an account's access to this role.
510      */
511     function remove(Role storage role, address account) internal {
512         require(has(role, account), "Roles: account does not have role");
513         role.bearer[account] = false;
514     }
515 
516     /**
517      * @dev Check if an account has this role.
518      * @return bool
519      */
520     function has(Role storage role, address account) internal view returns (bool) {
521         require(account != address(0), "Roles: account is the zero address");
522         return role.bearer[account];
523     }
524 }
525 
526 
527 contract MinterRole is Context {
528     using Roles for Roles.Role;
529 
530     event MinterAdded(address indexed account);
531     event MinterRemoved(address indexed account);
532 
533     Roles.Role private _minters;
534 
535     constructor () internal {
536         _addMinter(_msgSender());
537     }
538 
539     modifier onlyMinter() {
540         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
541         _;
542     }
543 
544     function isMinter(address account) public view returns (bool) {
545         return _minters.has(account);
546     }
547 
548     function addMinter(address account) public onlyMinter {
549         _addMinter(account);
550     }
551 
552     function renounceMinter() public {
553         _removeMinter(_msgSender());
554     }
555 
556     function _addMinter(address account) internal {
557         _minters.add(account);
558         emit MinterAdded(account);
559     }
560 
561     function _removeMinter(address account) internal {
562         _minters.remove(account);
563         emit MinterRemoved(account);
564     }
565 }
566 
567 /**
568  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
569  * which have permission to mint (create) new tokens as they see fit.
570  *
571  * At construction, the deployer of the contract is the only minter.
572  */
573 contract ERC20Mintable is ERC20, MinterRole {
574     /**
575      * @dev See {ERC20-_mint}.
576      *
577      * Requirements:
578      *
579      * - the caller must have the {MinterRole}.
580      */
581     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
582         _mint(account, amount);
583         return true;
584     }
585 }
586 
587 
588 contract NewGolemNetworkToken is ERC20Mintable {
589     string public name = "Golem Network Token";
590     string public symbol = "GLM";
591     uint8 public decimals = 18;
592     string public constant version = "1";
593     mapping(address => uint) public nonces;
594 
595     // --- EIP712 niceties ---
596     bytes32 public DOMAIN_SEPARATOR;
597     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
598     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
599 
600     constructor(address _migrationAgent, uint256 _chainId) public {
601         addMinter(_migrationAgent);
602         renounceMinter();
603         DOMAIN_SEPARATOR = keccak256(
604             abi.encode(
605                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
606                 keccak256(bytes(name)),
607                 keccak256(bytes(version)),
608                 _chainId,
609                 address(this)
610             )
611         );
612     }
613 
614     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
615         _transfer(sender, recipient, amount);
616         if (sender != msg.sender && allowance(sender, msg.sender) != uint(-1)) {
617             _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
618         }
619         return true;
620     }
621 
622     // --- Approve by signature ---
623     function permit(
624         address holder, address spender, uint256 nonce, uint256 expiry,
625         bool allowed, uint8 v, bytes32 r, bytes32 s) external {
626         bytes32 digest = keccak256(
627             abi.encodePacked(
628                 "\x19\x01",
629                 DOMAIN_SEPARATOR,
630                 keccak256(
631                     abi.encode(
632                         PERMIT_TYPEHASH,
633                         holder,
634                         spender,
635                         nonce,
636                         expiry,
637                         allowed
638                     )
639                 )
640             )
641         );
642 
643         require(holder != address(0), "Ngnt/invalid-address-0");
644         require(holder == ecrecover(digest, v, r, s), "Ngnt/invalid-permit");
645         require(expiry == 0 || now <= expiry, "Ngnt/permit-expired");
646         require(nonce == nonces[holder]++, "Ngnt/invalid-nonce");
647         uint wad = allowed ? uint(- 1) : 0;
648         _approve(holder, spender, wad);
649     }
650 }