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
78 
79 pragma solidity ^0.5.0;
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
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
121         require(b <= a, "SafeMath: subtraction overflow");
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0, "SafeMath: division by zero");
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
182         require(b != 0, "SafeMath: modulo by zero");
183         return a % b;
184     }
185 }
186 
187 
188 pragma solidity ^0.5.0;
189 
190 
191 
192 /**
193  * @dev Implementation of the `IERC20` interface.
194  *
195  * This implementation is agnostic to the way tokens are created. This means
196  * that a supply mechanism has to be added in a derived contract using `_mint`.
197  * For a generic mechanism see `ERC20Mintable`.
198  *
199  * *For a detailed writeup see our guide [How to implement supply
200  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
201  *
202  * We have followed general OpenZeppelin guidelines: functions revert instead
203  * of returning `false` on failure. This behavior is nonetheless conventional
204  * and does not conflict with the expectations of ERC20 applications.
205  *
206  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See `IERC20.approve`.
214  */
215 contract ERC20 is IERC20 {
216     using SafeMath for uint256;
217 
218     mapping (address => uint256) private _balances;
219 
220     mapping (address => uint256) internal _datesOfFirstTransfer;
221 
222     mapping (address => mapping (address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     /**
227      * @dev See `IERC20.totalSupply`.
228      */
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See `IERC20.balanceOf`.
235      */
236     function balanceOf(address account) public view returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See `IERC20.transfer`.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public returns (bool) {
249         if (_datesOfFirstTransfer[recipient] == 0) {
250             _datesOfFirstTransfer[recipient] = now;
251         }
252         
253         _transfer(msg.sender, recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See `IERC20.allowance`.
259      */
260     function allowance(address owner, address spender) public view returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See `IERC20.approve`.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 value) public returns (bool) {
272         _approve(msg.sender, spender, value);
273         return true;
274     }
275 
276     /**
277      * @dev See `IERC20.transferFrom`.
278      *
279      * Emits an `Approval` event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of `ERC20`;
281      *
282      * Requirements:
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `value`.
285      * - the caller must have allowance for `sender`'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
289         _transfer(sender, recipient, amount);
290         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
291         return true;
292     }
293 
294     /**
295      * @dev Atomically increases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to `approve` that can be used as a mitigation for
298      * problems described in `IERC20.approve`.
299      *
300      * Emits an `Approval` event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
307         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
308         return true;
309     }
310 
311     /**
312      * @dev Atomically decreases the allowance granted to `spender` by the caller.
313      *
314      * This is an alternative to `approve` that can be used as a mitigation for
315      * problems described in `IERC20.approve`.
316      *
317      * Emits an `Approval` event indicating the updated allowance.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      * - `spender` must have allowance for the caller of at least
323      * `subtractedValue`.
324      */
325     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
326         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
327         return true;
328     }
329 
330     /**
331      * @dev Moves tokens `amount` from `sender` to `recipient`.
332      *
333      * This is internal function is equivalent to `transfer`, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a `Transfer` event.
337      *
338      * Requirements:
339      *
340      * - `sender` cannot be the zero address.
341      * - `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      */
344     function _transfer(address sender, address recipient, uint256 amount) internal {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _balances[sender] = _balances[sender].sub(amount);
349         _balances[recipient] = _balances[recipient].add(amount);
350         emit Transfer(sender, recipient, amount);
351     }
352 
353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
354      * the total supply.
355      *
356      * Emits a `Transfer` event with `from` set to the zero address.
357      *
358      * Requirements
359      *
360      * - `to` cannot be the zero address.
361      */
362     function _mint(address account, uint256 amount) internal {
363         require(account != address(0), "ERC20: mint to the zero address");
364 
365         _totalSupply = _totalSupply.add(amount);
366         _balances[account] = _balances[account].add(amount);
367         emit Transfer(address(0), account, amount);
368     }
369 
370      /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a `Transfer` event with `to` set to the zero address.
375      *
376      * Requirements
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 value) internal {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _totalSupply = _totalSupply.sub(value);
385         _balances[account] = _balances[account].sub(value);
386         emit Transfer(account, address(0), value);
387     }
388 
389     /**
390      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
391      *
392      * This is internal function is equivalent to `approve`, and can be used to
393      * e.g. set automatic allowances for certain subsystems, etc.
394      *
395      * Emits an `Approval` event.
396      *
397      * Requirements:
398      *
399      * - `owner` cannot be the zero address.
400      * - `spender` cannot be the zero address.
401      */
402     function _approve(address owner, address spender, uint256 value) internal {
403         require(owner != address(0), "ERC20: approve from the zero address");
404         require(spender != address(0), "ERC20: approve to the zero address");
405 
406         _allowances[owner][spender] = value;
407         emit Approval(owner, spender, value);
408     }
409 
410     /**
411      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
412      * from the caller's allowance.
413      *
414      * See `_burn` and `_approve`.
415      */
416     function _burnFrom(address account, uint256 amount) internal {
417         _burn(account, amount);
418         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
419     }
420 }
421 
422 
423 pragma solidity ^0.5.0;
424 
425 /**
426  * @title Roles
427  * @dev Library for managing addresses assigned to a Role.
428  */
429 library Roles {
430     struct Role {
431         mapping (address => bool) bearer;
432     }
433 
434     /**
435      * @dev Give an account access to this role.
436      */
437     function add(Role storage role, address account) internal {
438         require(!has(role, account), "Roles: account already has role");
439         role.bearer[account] = true;
440     }
441 
442     /**
443      * @dev Remove an account's access to this role.
444      */
445     function remove(Role storage role, address account) internal {
446         require(has(role, account), "Roles: account does not have role");
447         role.bearer[account] = false;
448     }
449 
450     /**
451      * @dev Check if an account has this role.
452      * @return bool
453      */
454     function has(Role storage role, address account) internal view returns (bool) {
455         require(account != address(0), "Roles: account is the zero address");
456         return role.bearer[account];
457     }
458 }
459 
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 contract TealCoin is ERC20, MinterRole {
511     string private _name;
512     string private _symbol;
513     uint8 private _decimals;
514 
515 
516     /**
517      * @dev Constructor.
518      */
519     constructor() public payable {
520       _name = 'TealCoin';
521       _symbol = 'TEAC';
522       _decimals = 6;
523     }
524 
525     /**
526      * @dev See `ERC20._mint`.
527      *
528      * Requirements:
529      *
530      * - the caller must have the `MinterRole`.
531      */
532     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
533         _mint(account, amount);
534         return true;
535     }
536     
537     /**
538      * @dev transfers minter role from msg.sender to newMinter
539      */
540     function transferMinterRole(address newMinter) public {
541       addMinter(newMinter);
542       renounceMinter();
543     }
544 
545     // optional functions from ERC20 stardard
546 
547     /**
548      * @return the name of the token.
549      */
550     function name() public view returns (string memory) {
551       return _name;
552     }
553 
554     /**
555      * @return the symbol of the token.
556      */
557     function symbol() public view returns (string memory) {
558       return _symbol;
559     }
560 
561     /**
562      * @return the number of decimals of the token.
563      */
564     function decimals() public view returns (uint8) {
565       return _decimals;
566     }
567 }   
568 
569 
570 contract TealToken is ERC20 {
571     string private _name;
572     string private _symbol;
573     uint8 private _decimals;
574     TealCoin public _tlc;
575     bool public _allowMinting;
576     address public owner;
577     mapping (address => uint256) private _lastTimeMinted;
578 
579     modifier onlyOwner() {
580         require(msg.sender == owner, "Only owner is allowed to do this");
581         _;
582     }
583 
584     function setAllowMinting(bool _value) public onlyOwner {
585         _allowMinting = _value;
586     }
587     
588     /**
589      * @dev Constructor.
590      * @param tlc TlcCoin contract to connect
591      */
592     constructor(TealCoin tlc) public payable {
593       _name = 'TealToken';
594       _symbol = 'TEAT';
595       _decimals = 0;
596       _tlc = tlc;
597       
598       owner = msg.sender;
599       
600       _allowMinting = true;
601 
602       // set tokenOwnerAddress as owner of initial supply, more tokens can be minted later
603       _mint(msg.sender, 9000000);
604     }
605 
606     /**
607      * @dev See `ERC20._mint`.
608      *
609      * Requirements:
610      *
611      * - Can be called by the same wallet once per month.
612      */
613     function mint(address account, uint256 amount) public returns (bool) {
614         require(_allowMinting, "Minting is not allowed");
615         require(_datesOfFirstTransfer[msg.sender] > 0, "You can't mint if you did'nt receive your initial tokens");
616         
617         uint256 lastTime = _lastTimeMinted[msg.sender];
618         if (lastTime == 0) {
619             lastTime = _datesOfFirstTransfer[msg.sender];
620         }
621         
622         require(now > lastTime + 1 days, "You need to wait at least one day since the last minting or your initial transfer");
623         
624         _lastTimeMinted[msg.sender] = now;
625 
626         _mint(account, amount);
627         
628         uint256 tlcAmount = amount.mul(4167);
629         uint256 diffInDays = (now - lastTime).div(86400); //60 * 60 * 24
630         if (diffInDays > 730) {
631             diffInDays = 730;
632         }
633         tlcAmount = tlcAmount.mul(diffInDays);
634     
635         _tlc.mint(account, tlcAmount);
636 
637         return true;
638     }
639 
640     // optional functions from ERC20 stardard
641 
642     /**
643      * @return the name of the token.
644      */
645     function name() public view returns (string memory) {
646       return _name;
647     }
648 
649     /**
650      * @return the symbol of the token.
651      */
652     function symbol() public view returns (string memory) {
653       return _symbol;
654     }
655 
656     /**
657      * @return the number of decimals of the token.
658      */
659     function decimals() public view returns (uint8) {
660       return _decimals;
661     }
662 }