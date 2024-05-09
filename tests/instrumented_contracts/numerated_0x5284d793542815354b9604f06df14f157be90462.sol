1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-11
3 */
4 
5 pragma solidity >=0.4.23 <0.6.0;
6 
7 library SafeMath {
8     /**
9      * @dev Returns the addition of two unsigned integers, reverting on
10      * overflow.
11      *
12      * Counterpart to Solidity's `+` operator.
13      *
14      * Requirements:
15      * - Addition cannot overflow.
16      */
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Returns the subtraction of two unsigned integers, reverting on
26      * overflow (when the result is negative).
27      *
28      * Counterpart to Solidity's `-` operator.
29      *
30      * Requirements:
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a, "SafeMath: subtraction overflow");
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `*` operator.
45      *
46      * Requirements:
47      * - Multiplication cannot overflow.
48      */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the integer division of two unsigned integers. Reverts on
65      * division by zero. The result is rounded towards zero.
66      *
67      * Counterpart to Solidity's `/` operator. Note: this function uses a
68      * `revert` opcode (which leaves remaining gas untouched) while Solidity
69      * uses an invalid opcode to revert (consuming all remaining gas).
70      *
71      * Requirements:
72      * - The divisor cannot be zero.
73      */
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Solidity only automatically asserts when dividing by 0
76         require(b > 0, "SafeMath: division by zero");
77         uint256 c = a / b;
78         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
85      * Reverts when dividing by zero.
86      *
87      * Counterpart to Solidity's `%` operator. This function uses a `revert`
88      * opcode (which leaves remaining gas untouched) while Solidity uses an
89      * invalid opcode to revert (consuming all remaining gas).
90      *
91      * Requirements:
92      * - The divisor cannot be zero.
93      */
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0, "SafeMath: modulo by zero");
96         return a % b;
97     }
98 }
99 
100 
101 
102 interface IERC20 {
103     /**
104      * @dev Returns the amount of tokens in existence.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     /**
109      * @dev Returns the amount of tokens owned by `account`.
110      */
111     function balanceOf(address account) external view returns (uint256);
112 
113     /**
114      * @dev Moves `amount` tokens from the caller's account to `recipient`.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * Emits a `Transfer` event.
119      */
120     function transfer(address recipient, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Returns the remaining number of tokens that `spender` will be
124      * allowed to spend on behalf of `owner` through `transferFrom`. This is
125      * zero by default.
126      *
127      * This value changes when `approve` or `transferFrom` are called.
128      */
129     function allowance(address owner, address spender) external view returns (uint256);
130 
131     /**
132      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * > Beware that changing an allowance with this method brings the risk
137      * that someone may use both the old and the new allowance by unfortunate
138      * transaction ordering. One possible solution to mitigate this race
139      * condition is to first reduce the spender's allowance to 0 and set the
140      * desired value afterwards:
141      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
142      *
143      * Emits an `Approval` event.
144      */
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Moves `amount` tokens from `sender` to `recipient` using the
149      * allowance mechanism. `amount` is then deducted from the caller's
150      * allowance.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a `Transfer` event.
155      */
156     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Emitted when `value` tokens are moved from one account (`from`) to
160      * another (`to`).
161      *
162      * Note that `value` may be zero.
163      */
164     event Transfer(address indexed from, address indexed to, uint256 value);
165 
166     /**
167      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
168      * a call to `approve`. `value` is the new allowance.
169      */
170     event Approval(address indexed owner, address indexed spender, uint256 value);
171 }
172 
173 
174 contract ERC20 is IERC20 {
175     using SafeMath for uint256;
176 
177     mapping (address => uint256) private _balances;
178 
179     mapping (address => mapping (address => uint256)) private _allowances;
180 
181     uint256 private _totalSupply;
182 
183     /**
184      * @dev See `IERC20.totalSupply`.
185      */
186     function totalSupply() public view returns (uint256) {
187         return _totalSupply;
188     }
189 
190     /**
191      * @dev See `IERC20.balanceOf`.
192      */
193     function balanceOf(address account) public view returns (uint256) {
194         return _balances[account];
195     }
196 
197     /**
198      * @dev See `IERC20.transfer`.
199      *
200      * Requirements:
201      *
202      * - `recipient` cannot be the zero address.
203      * - the caller must have a balance of at least `amount`.
204      */
205     function transfer(address recipient, uint256 amount) public returns (bool) {
206         _transfer(msg.sender, recipient, amount);
207         return true;
208     }
209 
210     /**
211      * @dev See `IERC20.allowance`.
212      */
213     function allowance(address owner, address spender) public view returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     /**
218      * @dev See `IERC20.approve`.
219      *
220      * Requirements:
221      *
222      * - `spender` cannot be the zero address.
223      */
224     function approve(address spender, uint256 value) public returns (bool) {
225         _approve(msg.sender, spender, value);
226         return true;
227     }
228 
229     /**
230      * @dev See `IERC20.transferFrom`.
231      *
232      * Emits an `Approval` event indicating the updated allowance. This is not
233      * required by the EIP. See the note at the beginning of `ERC20`;
234      *
235      * Requirements:
236      * - `sender` and `recipient` cannot be the zero address.
237      * - `sender` must have a balance of at least `value`.
238      * - the caller must have allowance for `sender`'s tokens of at least
239      * `amount`.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
244         return true;
245     }
246 
247     /**
248      * @dev Atomically increases the allowance granted to `spender` by the caller.
249      *
250      * This is an alternative to `approve` that can be used as a mitigation for
251      * problems described in `IERC20.approve`.
252      *
253      * Emits an `Approval` event indicating the updated allowance.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
260         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
261         return true;
262     }
263 
264     /**
265      * @dev Atomically decreases the allowance granted to `spender` by the caller.
266      *
267      * This is an alternative to `approve` that can be used as a mitigation for
268      * problems described in `IERC20.approve`.
269      *
270      * Emits an `Approval` event indicating the updated allowance.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      * - `spender` must have allowance for the caller of at least
276      * `subtractedValue`.
277      */
278     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
279         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
280         return true;
281     }
282 
283     /**
284      * @dev Moves tokens `amount` from `sender` to `recipient`.
285      *
286      * This is internal function is equivalent to `transfer`, and can be used to
287      * e.g. implement automatic token fees, slashing mechanisms, etc.
288      *
289      * Emits a `Transfer` event.
290      *
291      * Requirements:
292      *
293      * - `sender` cannot be the zero address.
294      * - `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      */
297     function _transfer(address sender, address recipient, uint256 amount) internal {
298         require(sender != address(0), "ERC20: transfer from the zero address");
299         require(recipient != address(0), "ERC20: transfer to the zero address");
300 
301         _balances[sender] = _balances[sender].sub(amount);
302         _balances[recipient] = _balances[recipient].add(amount);
303         emit Transfer(sender, recipient, amount);
304     }
305 
306     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
307      * the total supply.
308      *
309      * Emits a `Transfer` event with `from` set to the zero address.
310      *
311      * Requirements
312      *
313      * - `to` cannot be the zero address.
314      */
315     function _mint(address account, uint256 amount) internal {
316         require(account != address(0), "ERC20: mint to the zero address");
317 
318         _totalSupply = _totalSupply.add(amount);
319         _balances[account] = _balances[account].add(amount);
320         emit Transfer(address(0), account, amount);
321     }
322 
323      /**
324      * @dev Destoys `amount` tokens from `account`, reducing the
325      * total supply.
326      *
327      * Emits a `Transfer` event with `to` set to the zero address.
328      *
329      * Requirements
330      *
331      * - `account` cannot be the zero address.
332      * - `account` must have at least `amount` tokens.
333      */
334     function _burn(address account, uint256 value) internal {
335         require(account != address(0), "ERC20: burn from the zero address");
336 
337         _totalSupply = _totalSupply.sub(value);
338         _balances[account] = _balances[account].sub(value);
339         emit Transfer(account, address(0), value);
340     }
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
344      *
345      * This is internal function is equivalent to `approve`, and can be used to
346      * e.g. set automatic allowances for certain subsystems, etc.
347      *
348      * Emits an `Approval` event.
349      *
350      * Requirements:
351      *
352      * - `owner` cannot be the zero address.
353      * - `spender` cannot be the zero address.
354      */
355     function _approve(address owner, address spender, uint256 value) internal {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358 
359         _allowances[owner][spender] = value;
360         emit Approval(owner, spender, value);
361     }
362 
363     /**
364      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
365      * from the caller's allowance.
366      *
367      * See `_burn` and `_approve`.
368      */
369     function _burnFrom(address account, uint256 amount) internal {
370         _burn(account, amount);
371         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
372     }
373 }
374 
375 
376 library Roles {
377     struct Role {
378         mapping (address => bool) bearer;
379     }
380 
381     /**
382      * @dev Give an account access to this role.
383      */
384     function add(Role storage role, address account) internal {
385         require(!has(role, account), "Roles: account already has role");
386         role.bearer[account] = true;
387     }
388 
389     /**
390      * @dev Remove an account's access to this role.
391      */
392     function remove(Role storage role, address account) internal {
393         require(has(role, account), "Roles: account does not have role");
394         role.bearer[account] = false;
395     }
396 
397     /**
398      * @dev Check if an account has this role.
399      * @return bool
400      */
401     function has(Role storage role, address account) internal view returns (bool) {
402         require(account != address(0), "Roles: account is the zero address");
403         return role.bearer[account];
404     }
405 }
406 contract WhitelistAdminRole {
407     using Roles for Roles.Role;
408 
409     event WhitelistAdminAdded(address indexed account);
410     event WhitelistAdminRemoved(address indexed account);
411 
412     Roles.Role private _whitelistAdmins;
413 
414     constructor () internal {
415         _addWhitelistAdmin(msg.sender);
416     }
417 
418     modifier onlyWhitelistAdmin() {
419         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
420         _;
421     }
422 
423     function isWhitelistAdmin(address account) public view returns (bool) {
424         return _whitelistAdmins.has(account);
425     }
426 
427     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
428         _addWhitelistAdmin(account);
429     }
430 
431     function renounceWhitelistAdmin() public {
432         _removeWhitelistAdmin(msg.sender);
433     }
434 
435     function _addWhitelistAdmin(address account) internal {
436         _whitelistAdmins.add(account);
437         emit WhitelistAdminAdded(account);
438     }
439 
440     function _removeWhitelistAdmin(address account) internal {
441         _whitelistAdmins.remove(account);
442         emit WhitelistAdminRemoved(account);
443     }
444 }
445 
446 contract MinterRole {
447     using Roles for Roles.Role;
448 
449     event MinterAdded(address indexed account);
450     event MinterRemoved(address indexed account);
451 
452     Roles.Role private _minters;
453 
454     constructor () internal {
455         _addMinter(msg.sender);
456     }
457 
458     modifier onlyMinter() {
459         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
460         _;
461     }
462 
463     function isMinter(address account) public view returns (bool) {
464         return _minters.has(account);
465     }
466 
467     function addMinter(address account) public onlyMinter {
468         _addMinter(account);
469     }
470 
471     function renounceMinter() public {
472         _removeMinter(msg.sender);
473     }
474 
475     function _addMinter(address account) internal {
476         _minters.add(account);
477         emit MinterAdded(account);
478     }
479 
480     function _removeMinter(address account) internal {
481         _minters.remove(account);
482         emit MinterRemoved(account);
483     }
484 }
485 
486 
487 contract PauserRole {
488     using Roles for Roles.Role;
489 
490     event PauserAdded(address indexed account);
491     event PauserRemoved(address indexed account);
492 
493     Roles.Role private _pausers;
494 
495     constructor () internal {
496         _addPauser(msg.sender);
497     }
498 
499     modifier onlyPauser() {
500         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
501         _;
502     }
503 
504     function isPauser(address account) public view returns (bool) {
505         return _pausers.has(account);
506     }
507 
508     function addPauser(address account) public onlyPauser {
509         _addPauser(account);
510     }
511 
512     function renouncePauser() public {
513         _removePauser(msg.sender);
514     }
515 
516     function _addPauser(address account) internal {
517         _pausers.add(account);
518         emit PauserAdded(account);
519     }
520 
521     function _removePauser(address account) internal {
522         _pausers.remove(account);
523         emit PauserRemoved(account);
524     }
525 }
526 
527 contract ERC20Mintable is ERC20, MinterRole {
528     /**
529      * @dev See `ERC20._mint`.
530      *
531      * Requirements:
532      *
533      * - the caller must have the `MinterRole`.
534      */
535     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
536         _mint(account, amount);
537         return true;
538     }
539 }
540 
541 contract Pausable is PauserRole {
542     /**
543      * @dev Emitted when the pause is triggered by a pauser (`account`).
544      */
545     event Paused(address account);
546 
547     /**
548      * @dev Emitted when the pause is lifted by a pauser (`account`).
549      */
550     event Unpaused(address account);
551 
552     bool private _paused;
553 
554     /**
555      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
556      * to the deployer.
557      */
558     constructor () internal {
559         _paused = false;
560     }
561 
562     /**
563      * @dev Returns true if the contract is paused, and false otherwise.
564      */
565     function paused() public view returns (bool) {
566         return _paused;
567     }
568 
569     /**
570      * @dev Modifier to make a function callable only when the contract is not paused.
571      */
572     modifier whenNotPaused() {
573         require(!_paused, "Pausable: paused");
574         _;
575     }
576 
577     /**
578      * @dev Modifier to make a function callable only when the contract is paused.
579      */
580     modifier whenPaused() {
581         require(_paused, "Pausable: not paused");
582         _;
583     }
584 
585     /**
586      * @dev Called by a pauser to pause, triggers stopped state.
587      */
588     function pause() public onlyPauser whenNotPaused {
589         _paused = true;
590         emit Paused(msg.sender);
591     }
592 
593     /**
594      * @dev Called by a pauser to unpause, returns to normal state.
595      */
596     function unpause() public onlyPauser whenPaused {
597         _paused = false;
598         emit Unpaused(msg.sender);
599     }
600 }
601 
602 
603 contract ERC20Pausable is ERC20, Pausable {
604     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
605         return super.transfer(to, value);
606     }
607 
608     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
609         return super.transferFrom(from, to, value);
610     }
611 
612     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
613         return super.approve(spender, value);
614     }
615 
616     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
617         return super.increaseAllowance(spender, addedValue);
618     }
619 
620     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
621         return super.decreaseAllowance(spender, subtractedValue);
622     }
623 }
624 
625 contract ERC20BlackList is ERC20Pausable,WhitelistAdminRole{
626     mapping(address=>bool) public blacklist;
627     
628     function putIntoBlacklist(address _addr) public onlyWhitelistAdmin{
629         blacklist[_addr]=true;
630     }
631     
632     function removeFromBlacklist(address _addr) public onlyWhitelistAdmin{
633         blacklist[_addr]=false;
634     }    
635     
636     function inBlacklist(address _addr)external view returns (bool){
637         return blacklist[_addr];
638     }    
639     
640     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
641         require(blacklist[msg.sender]==false,"address in blacklist");
642         return super.transfer(to, value);
643     }
644 
645     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
646         require(blacklist[from]==false,"address in blacklist");
647         return super.transferFrom(from, to, value);
648     }   
649     
650 }
651 
652 contract UmiToken is ERC20BlackList,ERC20Mintable{
653     using SafeMath for uint256;
654     string public constant name="UMI";
655     string public constant symbol="UMI";
656     string public constant version = "1.0";
657     uint256 public decimals = 18;
658     
659     uint256 public maxMine=100000000*10**decimals;
660     uint256 public totalMined=0;
661     
662     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
663         require(totalMined.add(amount)<=maxMine,"reach max supply");
664         _mint(account, amount);
665         totalMined=totalMined.add(amount);
666         return true;
667     }
668     
669      function addIssue(uint256 amount) public onlyWhitelistAdmin {
670          maxMine=maxMine.add(amount);
671      }
672 }