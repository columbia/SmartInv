1 pragma solidity 0.5.0;
2 
3 
4 library Roles {
5     struct Role {
6         mapping (address => bool) bearer;
7     }
8 
9     /**
10      * @dev Give an account access to this role.
11      */
12     function add(Role storage role, address account) internal {
13         require(!has(role, account), "Roles: account already has role");
14         role.bearer[account] = true;
15     }
16 
17     /**
18      * @dev Remove an account's access to this role.
19      */
20     function remove(Role storage role, address account) internal {
21         require(has(role, account), "Roles: account does not have role");
22         role.bearer[account] = false;
23     }
24 
25     /**
26      * @dev Check if an account has this role.
27      * @return bool
28      */
29     function has(Role storage role, address account) internal view returns (bool) {
30         require(account != address(0), "Roles: account is the zero address");
31         return role.bearer[account];
32     }
33 }
34 
35 contract PauserRole {
36     using Roles for Roles.Role;
37 
38     event PauserAdded(address indexed account);
39     event PauserRemoved(address indexed account);
40 
41     Roles.Role private _pausers;
42 
43     constructor () internal {
44         _addPauser(msg.sender);
45     }
46 
47     modifier onlyPauser() {
48         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
49         _;
50     }
51 
52     function isPauser(address account) public view returns (bool) {
53         return _pausers.has(account);
54     }
55 
56     function addPauser(address account) public onlyPauser {
57         _addPauser(account);
58     }
59 
60     function renouncePauser() public {
61         _removePauser(msg.sender);
62     }
63 
64     function _addPauser(address account) internal {
65         _pausers.add(account);
66         emit PauserAdded(account);
67     }
68 
69     function _removePauser(address account) internal {
70         _pausers.remove(account);
71         emit PauserRemoved(account);
72     }
73 }
74 
75 contract Pausable is PauserRole {
76     /**
77      * @dev Emitted when the pause is triggered by a pauser (`account`).
78      */
79     event Paused(address account);
80 
81     /**
82      * @dev Emitted when the pause is lifted by a pauser (`account`).
83      */
84     event Unpaused(address account);
85 
86     bool private _paused;
87 
88     /**
89      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
90      * to the deployer.
91      */
92     constructor () internal {
93         _paused = false;
94     }
95 
96     /**
97      * @dev Returns true if the contract is paused, and false otherwise.
98      */
99     function paused() public view returns (bool) {
100         return _paused;
101     }
102 
103     /**
104      * @dev Modifier to make a function callable only when the contract is not paused.
105      */
106     modifier whenNotPaused() {
107         require(!_paused, "Pausable: paused");
108         _;
109     }
110 
111     /**
112      * @dev Modifier to make a function callable only when the contract is paused.
113      */
114     modifier whenPaused() {
115         require(_paused, "Pausable: not paused");
116         _;
117     }
118 
119     /**
120      * @dev Called by a pauser to pause, triggers stopped state.
121      */
122     function pause() public onlyPauser whenNotPaused {
123         _paused = true;
124         emit Paused(msg.sender);
125     }
126 
127     /**
128      * @dev Called by a pauser to unpause, returns to normal state.
129      */
130     function unpause() public onlyPauser whenPaused {
131         _paused = false;
132         emit Unpaused(msg.sender);
133     }
134 }
135 
136 library SafeMath {
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         require(b <= a, "SafeMath: subtraction overflow");
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         // Solidity only automatically asserts when dividing by 0
205         require(b > 0, "SafeMath: division by zero");
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         require(b != 0, "SafeMath: modulo by zero");
225         return a % b;
226     }
227 }
228 
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a `Transfer` event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through `transferFrom`. This is
252      * zero by default.
253      *
254      * This value changes when `approve` or `transferFrom` are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * > Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an `Approval` event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a `Transfer` event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to `approve`. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 contract ERC20 is IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See `IERC20.totalSupply`.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See `IERC20.balanceOf`.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See `IERC20.transfer`.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(msg.sender, recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See `IERC20.allowance`.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See `IERC20.approve`.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 value) public returns (bool) {
351         _approve(msg.sender, spender, value);
352         return true;
353     }
354 
355     /**
356      * @dev See `IERC20.transferFrom`.
357      *
358      * Emits an `Approval` event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of `ERC20`;
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `value`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to `approve` that can be used as a mitigation for
377      * problems described in `IERC20.approve`.
378      *
379      * Emits an `Approval` event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to `approve` that can be used as a mitigation for
394      * problems described in `IERC20.approve`.
395      *
396      * Emits an `Approval` event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to `transfer`, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a `Transfer` event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount);
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a `Transfer` event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449      /**
450      * @dev Destoys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a `Transfer` event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 value) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _totalSupply = _totalSupply.sub(value);
464         _balances[account] = _balances[account].sub(value);
465         emit Transfer(account, address(0), value);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an `Approval` event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 value) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = value;
486         emit Approval(owner, spender, value);
487     }
488 
489     /**
490      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See `_burn` and `_approve`.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
498     }
499 }
500 
501 contract ERC20Pausable is ERC20, Pausable {
502     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
503         return super.transfer(to, value);
504     }
505 
506     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
507         return super.transferFrom(from, to, value);
508     }
509 
510     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
511         return super.approve(spender, value);
512     }
513 
514     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
515         return super.increaseAllowance(spender, addedValue);
516     }
517 
518     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
519         return super.decreaseAllowance(spender, subtractedValue);
520     }
521 }
522 
523 contract ERC20Burnable is ERC20 {
524     /**
525      * @dev Destoys `amount` tokens from the caller.
526      *
527      * See `ERC20._burn`.
528      */
529     function burn(uint256 amount) public {
530         _burn(msg.sender, amount);
531     }
532 
533     /**
534      * @dev See `ERC20._burnFrom`.
535      */
536     function burnFrom(address account, uint256 amount) public {
537         _burnFrom(account, amount);
538     }
539 }
540 
541 contract Ownable {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545 
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor () internal {
550         _owner = msg.sender;
551         emit OwnershipTransferred(address(0), _owner);
552     }
553 
554     /**
555      * @dev Returns the address of the current owner.
556      */
557     function owner() public view returns (address) {
558         return _owner;
559     }
560 
561     /**
562      * @dev Throws if called by any account other than the owner.
563      */
564     modifier onlyOwner() {
565         require(isOwner(), "Ownable: caller is not the owner");
566         _;
567     }
568 
569     /**
570      * @dev Returns true if the caller is the current owner.
571      */
572     function isOwner() public view returns (bool) {
573         return msg.sender == _owner;
574     }
575 
576     /**
577      * @dev Leaves the contract without owner. It will not be possible to call
578      * `onlyOwner` functions anymore. Can only be called by the current owner.
579      *
580      * > Note: Renouncing ownership will leave the contract without an owner,
581      * thereby removing any functionality that is only available to the owner.
582      */
583     function renounceOwnership() public onlyOwner {
584         emit OwnershipTransferred(_owner, address(0));
585         _owner = address(0);
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Can only be called by the current owner.
591      */
592     function transferOwnership(address newOwner) public onlyOwner {
593         _transferOwnership(newOwner);
594     }
595 
596     /**
597      * @dev Transfers ownership of the contract to a new account (`newOwner`).
598      */
599     function _transferOwnership(address newOwner) internal {
600         require(newOwner != address(0), "Ownable: new owner is the zero address");
601         emit OwnershipTransferred(_owner, newOwner);
602         _owner = newOwner;
603     }
604 }
605 
606 contract FreeToolBox is ERC20,  ERC20Burnable, ERC20Pausable, Ownable {
607 
608             
609     using SafeMath for uint256;
610 
611   // events
612   event Approval(address indexed owner, address indexed spender, uint256 value);
613   event AddressLockTransfer(address indexed to, bool _enable);
614 
615   mapping(address => bool) addresslock;
616   string public constant symbol = "FTB";
617   string public constant name = "Free Tool Box Coin";
618   uint8  public constant decimals = 18;
619   uint256 constant TOTAL_SUPPLY = 20000000000;
620 
621     constructor() public
622     {
623         _mint(msg.sender, TOTAL_SUPPLY  * (10 ** uint256(decimals)));
624     }
625     
626     function LockTransferAddress(address _sender) public view returns(bool) {
627         return addresslock[_sender];
628     }
629 
630     function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
631         require(_addr != address(0));
632         addresslock[_addr] = _enable;
633   
634          emit AddressLockTransfer(_addr, _enable);
635     }
636 
637     // override function using canTransfer on the sender address
638     function transfer(address _to, uint256 _value)  public returns (bool success) {
639         require(!addresslock[msg.sender]);
640         return super.transfer(_to, _value);
641     }
642 
643     // transfer tokens from one address to another
644     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
645         require(!addresslock[_from]);
646         return super.transferFrom(_from, _to, _value);
647     }
648 }