1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @dev Contract module which provides a basic access control mechanism, where
6  * there is an account (an owner) that can be granted exclusive access to
7  * specific functions.
8  *
9  * This module is used through inheritance. It will make available the modifier
10  * `onlyOwner`, which can be aplied to your functions to restrict their use to
11  * the owner.
12  */
13 contract Ownable {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev Initializes the contract setting the deployer as the initial owner.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @dev Returns the address of the current owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(isOwner(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     /**
42      * @dev Returns true if the caller is the current owner.
43      */
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 
48     /**
49      * @dev Leaves the contract without owner. It will not be possible to call
50      * `onlyOwner` functions anymore. Can only be called by the current owner.
51      *
52      * > Note: Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      */
71     function _transferOwnership(address newOwner) internal {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b <= a, "SafeMath: subtraction overflow");
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      * - Multiplication cannot overflow.
133      */
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136         // benefit is lost if 'b' is also tested.
137         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint256 c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers. Reverts on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator. Note: this function uses a
153      * `revert` opcode (which leaves remaining gas untouched) while Solidity
154      * uses an invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Solidity only automatically asserts when dividing by 0
161         require(b > 0, "SafeMath: division by zero");
162         uint256 c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
170      * Reverts when dividing by zero.
171      *
172      * Counterpart to Solidity's `%` operator. This function uses a `revert`
173      * opcode (which leaves remaining gas untouched) while Solidity uses an
174      * invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b != 0, "SafeMath: modulo by zero");
181         return a % b;
182     }
183 }
184 
185 /**
186  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
187  * the optional functions; to access them see `ERC20Detailed`.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a `Transfer` event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through `transferFrom`. This is
212      * zero by default.
213      *
214      * This value changes when `approve` or `transferFrom` are called.
215      */
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * > Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an `Approval` event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a `Transfer` event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to `approve`. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 /**
261  * @dev Optional functions from the ERC20 standard.
262  */
263 contract ERC20Detailed is IERC20 {
264     string private _name;
265     string private _symbol;
266     uint8 private _decimals;
267 
268     /**
269      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
270      * these values are immutable: they can only be set once during
271      * construction.
272      */
273     constructor (string memory name, string memory symbol, uint8 decimals) public {
274         _name = name;
275         _symbol = symbol;
276         _decimals = decimals;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei.
301      *
302      * > Note that this information is only used for _display_ purposes: it in
303      * no way affects any of the arithmetic of the contract, including
304      * `IERC20.balanceOf` and `IERC20.transfer`.
305      */
306     function decimals() public view returns (uint8) {
307         return _decimals;
308     }
309 }
310 
311 contract MinterRole {
312     using Roles for Roles.Role;
313 
314     event MinterAdded(address indexed account);
315     event MinterRemoved(address indexed account);
316 
317     Roles.Role private _minters;
318 
319     constructor () internal {
320         _addMinter(msg.sender);
321     }
322 
323     modifier onlyMinter() {
324         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
325         _;
326     }
327 
328     function isMinter(address account) public view returns (bool) {
329         return _minters.has(account);
330     }
331 
332     function addMinter(address account) public onlyMinter {
333         _addMinter(account);
334     }
335 
336     function renounceMinter() public {
337         _removeMinter(msg.sender);
338     }
339 
340     function _addMinter(address account) internal {
341         _minters.add(account);
342         emit MinterAdded(account);
343     }
344 
345     function _removeMinter(address account) internal {
346         _minters.remove(account);
347         emit MinterRemoved(account);
348     }
349 }
350 
351 /**
352  * @title Roles
353  * @dev Library for managing addresses assigned to a Role.
354  */
355 library Roles {
356     struct Role {
357         mapping (address => bool) bearer;
358     }
359 
360     /**
361      * @dev Give an account access to this role.
362      */
363     function add(Role storage role, address account) internal {
364         require(!has(role, account), "Roles: account already has role");
365         role.bearer[account] = true;
366     }
367 
368     /**
369      * @dev Remove an account's access to this role.
370      */
371     function remove(Role storage role, address account) internal {
372         require(has(role, account), "Roles: account does not have role");
373         role.bearer[account] = false;
374     }
375 
376     /**
377      * @dev Check if an account has this role.
378      * @return bool
379      */
380     function has(Role storage role, address account) internal view returns (bool) {
381         require(account != address(0), "Roles: account is the zero address");
382         return role.bearer[account];
383     }
384 }
385 
386 
387 /**
388  * @dev Derived From the `ERC20` .
389  *
390  */
391 contract HkmtFeePool is Ownable , IERC20, MinterRole {
392     using SafeMath for uint256;
393 
394     mapping (address => uint256) private _balances;
395 
396     mapping (address => mapping (address => uint256)) private _allowances;
397 
398     uint256 private _totalSupply;
399 
400     /**
401      * @dev See `IERC20.totalSupply`.
402      */
403     function totalSupply() public view returns (uint256) {
404         return _totalSupply;
405     }
406 
407     /**
408      * @dev See `IERC20.balanceOf`.
409      */
410     function balanceOf(address account) public view returns (uint256) {
411         return _balances[account];
412     }
413 
414     /**
415      * @dev See `IERC20.allowance`.
416      */
417     function allowance(address owner, address spender) public view returns (uint256) {
418         return _allowances[owner][spender];
419     }
420 
421     /**
422      * @dev See `IERC20.approve`.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function approve(address spender, uint256 value) public returns (bool) {
429         _approve(msg.sender, spender, value);
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to `approve` that can be used as a mitigation for
437      * problems described in `IERC20.approve`.
438      *
439      * Emits an `Approval` event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
446         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically decreases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to `approve` that can be used as a mitigation for
454      * problems described in `IERC20.approve`.
455      *
456      * Emits an `Approval` event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      * - `spender` must have allowance for the caller of at least
462      * `subtractedValue`.
463      */
464     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
465         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
466         return true;
467     }
468 
469     /**
470      * @dev Moves tokens `amount` from `sender` to `recipient`.
471      *
472      * This is internal function is equivalent to `transfer`, and can be used to
473      * e.g. implement automatic token fees, slashing mechanisms, etc.
474      *
475      * Emits a `Transfer` event.
476      *
477      * Requirements:
478      *
479      * - `sender` cannot be the zero address.
480      * - `recipient` cannot be the zero address.
481      * - `sender` must have a balance of at least `amount`.
482      */
483     function _transfer(address sender, address recipient, uint256 amount) internal {
484         require(sender != address(0), "ERC20: transfer from the zero address");
485         require(recipient != address(0), "ERC20: transfer to the zero address");
486 
487         _balances[sender] = _balances[sender].sub(amount);
488         _balances[recipient] = _balances[recipient].add(amount);
489         emit Transfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a `Transfer` event with `from` set to the zero address.
496      *
497      * Requirements
498      *
499      * - `to` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _totalSupply = _totalSupply.add(amount);
505         _balances[account] = _balances[account].add(amount);
506         emit Transfer(address(0), account, amount);
507     }
508 
509      /**
510      * @dev Destoys `amount` tokens from `account`, reducing the
511      * total supply.
512      *
513      * Emits a `Transfer` event with `to` set to the zero address.
514      *
515      * Requirements
516      *
517      * - `account` cannot be the zero address.
518      * - `account` must have at least `amount` tokens.
519      */
520     function _burn(address account, uint256 value) internal {
521         require(account != address(0), "ERC20: burn from the zero address");
522 
523         _totalSupply = _totalSupply.sub(value);
524         _balances[account] = _balances[account].sub(value);
525         emit Transfer(account, address(0), value);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
530      *
531      * This is internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an `Approval` event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(address owner, address spender, uint256 value) internal {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = value;
546         emit Approval(owner, spender, value);
547     }
548 
549     /**
550      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
551      * from the caller's allowance.
552      *
553      * See `_burn` and `_approve`.
554      */
555     function _burnFrom(address account, uint256 amount) internal {
556         _burn(account, amount);
557         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
558     }
559 
560 
561     using SafeMath for uint;
562     uint public createdAt = block.timestamp;
563     uint public difficultyIncreaseInPercentPerDay = 1;
564     HKMT public hkmtContract;
565 
566     modifier onlySender(address _sender) {
567         require(msg.sender == _sender);
568         _;
569     }
570     event Claimed(
571         address indexed by,
572         uint256 tokenReturned,
573         uint256 reward
574     );
575     constructor(address _hkmtContract) public {
576         hkmtContract = HKMT(_hkmtContract);
577     }
578 
579     function set_difficultyIncreaseInPercentPerDay(uint value) external onlyOwner returns (bool) {
580         difficultyIncreaseInPercentPerDay = value;
581         return true;
582     }
583 
584     function currentReward(uint256 _value) public view returns (uint256) {
585         uint timeDiff = block.timestamp.sub(createdAt);
586         uint currentDifficulty = 100 + timeDiff.div(24 * 3600).mul(difficultyIncreaseInPercentPerDay);
587         uint256 supposedReward = _value.mul(100).div(currentDifficulty);
588         if (_balances[address(this)] > supposedReward) {
589             return supposedReward;
590         } else {
591             return _balances[address(this)];
592         }
593     }
594 
595     function currentMined() public view returns (uint256) {
596         return _totalSupply - _balances[address(this)];
597     }
598 
599     function notifyTx(address _payer, uint256 _value) external onlySender(address(hkmtContract)) returns (bool) {
600         require(_payer != address(0));
601         uint256 reward = currentReward(_value);
602         
603         _balances[address(this)] = _balances[address(this)].sub(reward);
604         _balances[_payer] = _balances[_payer].add(reward);
605 
606         emit Transfer(owner(), _payer, reward);
607 
608         return true;
609     }
610 
611     function transfer(address _to, uint256 _value) public returns (bool) {
612         require(_to != address(0));
613         require(_value <= _balances[msg.sender]);
614 
615         if (_to == address(this)) {
616             uint256 currentPool = hkmtContract.balanceOf(address(this));
617             uint256 currentPZ = currentMined();
618             uint256 result = currentPool.mul(_value).div(currentPZ);
619 
620             _transfer(msg.sender, _to, _value);
621 
622             hkmtContract.feePoolTransfer(msg.sender, result);
623             emit Claimed(msg.sender, _value, result);
624         } else {
625             _transfer(msg.sender, _to, _value);
626         }
627 
628         return true;
629     }
630 
631     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
632         require(_to != address(0));
633         require(_value <= _balances[_from]);
634         require(_value <= _allowances[_from][msg.sender]);
635 
636         if (_to == address(this)) {
637             uint256 currentPool = hkmtContract.balanceOf(address(this));
638             uint256 currentPZ = currentMined();
639             uint256 result = currentPool.mul(_value).div(currentPZ);
640 
641             _balances[_from] = _balances[_from].sub(_value);
642             _balances[_to] = _balances[_to].add(_value);
643             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
644             emit Transfer(_from, _to, _value);
645 
646             hkmtContract.feePoolTransfer(msg.sender, result);
647             emit Claimed(msg.sender, _value, result);
648         } else {
649             _balances[_from] = _balances[_from].sub(_value);
650             _balances[_to] = _balances[_to].add(_value);
651             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
652             emit Transfer(_from, _to, _value);
653         }
654 
655         return true;
656     }
657 
658     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
659         _mint(account, amount);
660         return true;
661     }
662 
663     /**
664      * @dev Destoys `amount` tokens from the caller.
665      *
666      * See `ERC20._burn`.
667      */
668     function burn(uint256 amount) public {
669         _burn(msg.sender, amount);
670     }
671 
672     /**
673      * @dev See `ERC20._burnFrom`.
674      */
675     function burnFrom(address account, uint256 amount) public {
676         _burnFrom(account, amount);
677     }
678 }
679 
680 
681 /**
682  * @dev Derived From the `ERC20` .
683  *
684  */
685 contract HKMT is Ownable, IERC20, MinterRole, ERC20Detailed {
686     using SafeMath for uint256;
687 
688     mapping (address => uint256) private _balances;
689 
690     mapping (address => mapping (address => uint256)) private _allowances;
691 
692     uint256 private _totalSupply;
693 
694     /**
695      * @dev See `IERC20.totalSupply`.
696      */
697     function totalSupply() public view returns (uint256) {
698         return _totalSupply;
699     }
700 
701     /**
702      * @dev See `IERC20.balanceOf`.
703      */
704     function balanceOf(address account) public view returns (uint256) {
705         return _balances[account];
706     }
707 
708     /**
709      * @dev See `IERC20.allowance`.
710      */
711     function allowance(address owner, address spender) public view returns (uint256) {
712         return _allowances[owner][spender];
713     }
714 
715     /**
716      * @dev See `IERC20.approve`.
717      *
718      * Requirements:
719      *
720      * - `spender` cannot be the zero address.
721      */
722     function approve(address spender, uint256 value) public returns (bool) {
723         _approve(msg.sender, spender, value);
724         return true;
725     }
726 
727     /**
728      * @dev Atomically increases the allowance granted to `spender` by the caller.
729      *
730      * This is an alternative to `approve` that can be used as a mitigation for
731      * problems described in `IERC20.approve`.
732      *
733      * Emits an `Approval` event indicating the updated allowance.
734      *
735      * Requirements:
736      *
737      * - `spender` cannot be the zero address.
738      */
739     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
740         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
741         return true;
742     }
743 
744     /**
745      * @dev Atomically decreases the allowance granted to `spender` by the caller.
746      *
747      * This is an alternative to `approve` that can be used as a mitigation for
748      * problems described in `IERC20.approve`.
749      *
750      * Emits an `Approval` event indicating the updated allowance.
751      *
752      * Requirements:
753      *
754      * - `spender` cannot be the zero address.
755      * - `spender` must have allowance for the caller of at least
756      * `subtractedValue`.
757      */
758     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
759         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
760         return true;
761     }
762 
763     /**
764      * @dev Moves tokens `amount` from `sender` to `recipient`.
765      *
766      * This is internal function is equivalent to `transfer`, and can be used to
767      * e.g. implement automatic token fees, slashing mechanisms, etc.
768      *
769      * Emits a `Transfer` event.
770      *
771      * Requirements:
772      *
773      * - `sender` cannot be the zero address.
774      * - `recipient` cannot be the zero address.
775      * - `sender` must have a balance of at least `amount`.
776      */
777     function _transfer(address sender, address recipient, uint256 amount) internal {
778         require(sender != address(0), "ERC20: transfer from the zero address");
779         require(recipient != address(0), "ERC20: transfer to the zero address");
780 
781         _balances[sender] = _balances[sender].sub(amount);
782         _balances[recipient] = _balances[recipient].add(amount);
783         emit Transfer(sender, recipient, amount);
784     }
785 
786     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
787      * the total supply.
788      *
789      * Emits a `Transfer` event with `from` set to the zero address.
790      *
791      * Requirements
792      *
793      * - `to` cannot be the zero address.
794      */
795     function _mint(address account, uint256 amount) internal {
796         require(account != address(0), "ERC20: mint to the zero address");
797 
798         _totalSupply = _totalSupply.add(amount);
799         _balances[account] = _balances[account].add(amount);
800         emit Transfer(address(0), account, amount);
801     }
802 
803      /**
804      * @dev Destoys `amount` tokens from `account`, reducing the
805      * total supply.
806      *
807      * Emits a `Transfer` event with `to` set to the zero address.
808      *
809      * Requirements
810      *
811      * - `account` cannot be the zero address.
812      * - `account` must have at least `amount` tokens.
813      */
814     function _burn(address account, uint256 value) internal {
815         require(account != address(0), "ERC20: burn from the zero address");
816 
817         _totalSupply = _totalSupply.sub(value);
818         _balances[account] = _balances[account].sub(value);
819         emit Transfer(account, address(0), value);
820     }
821 
822     /**
823      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
824      *
825      * This is internal function is equivalent to `approve`, and can be used to
826      * e.g. set automatic allowances for certain subsystems, etc.
827      *
828      * Emits an `Approval` event.
829      *
830      * Requirements:
831      *
832      * - `owner` cannot be the zero address.
833      * - `spender` cannot be the zero address.
834      */
835     function _approve(address owner, address spender, uint256 value) internal {
836         require(owner != address(0), "ERC20: approve from the zero address");
837         require(spender != address(0), "ERC20: approve to the zero address");
838 
839         _allowances[owner][spender] = value;
840         emit Approval(owner, spender, value);
841     }
842 
843     /**
844      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
845      * from the caller's allowance.
846      *
847      * See `_burn` and `_approve`.
848      */
849     function _burnFrom(address account, uint256 amount) internal {
850         _burn(account, amount);
851         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
852     }
853 
854     using SafeMath for uint;
855     uint public txFeePerMillion = 0;
856     uint256 public INITIAL_SUPPLY = 4000000000*(10**6);
857     HkmtFeePool public feePool;
858 
859     constructor() public ERC20Detailed("HK Monetary Token", "HKMT", 6) {
860         _totalSupply = INITIAL_SUPPLY;
861         _balances[msg.sender] = INITIAL_SUPPLY;
862     }
863 
864     modifier onlySender(address _sender) {
865         require(msg.sender == _sender);
866         _;
867     }
868 
869     function setTxFee(uint _value) external onlyOwner returns (bool) {
870         txFeePerMillion = _value;
871         return true;
872     }
873 
874     /**
875     * @dev Set the fee pool to a specified address
876     * @param _feePool The FeePool contract address
877     */
878 
879     function setFeePool(address _feePool) external onlyOwner returns (bool) {
880         require(_feePool != address(0));
881 
882         feePool = HkmtFeePool(_feePool);
883         return true;
884     }
885 
886     /**
887     * @dev Change the fee pool to a specified address. Transfer the balance of current fee pool to the new one.
888     * @param _newFeePool The new FeePool contract address
889     */
890 
891     function changeFeePool(address _newFeePool) external onlyOwner returns (bool) {
892         require(address(feePool) != address(0), "no FeePool set yet");
893         require(_newFeePool != address(0));
894         require(_balances[_newFeePool] == 0);
895 
896         uint256 currentPoolBalance = _balances[address(feePool)];
897         delete _balances[address(feePool)];
898         feePool = HkmtFeePool(_newFeePool);
899         _balances[_newFeePool] = currentPoolBalance;
900 
901         return true;
902     }
903 
904     // Fee pool transfer doesn't pay fee again.
905     function feePoolTransfer(address _to, uint256 _value) external onlySender(address(feePool)) returns (bool) {
906         require(_to != address(0));
907         require(_value <= _balances[msg.sender]);
908 
909         _transfer(msg.sender, _to, _value);
910         return true;
911     }
912 
913 
914     /**
915     * @dev Transfer tokens to a specified address after diverting a fee to a central account.
916     * @param _to The receiving address.
917     * @param _value The number of tokens to transfer.
918     */
919     function transfer(address _to, uint256 _value) public returns (bool) {
920         require(_to != address(0));
921         require(_value <= _balances[msg.sender]);
922 
923         uint256 fee = _value.mul(txFeePerMillion).div(10**6);
924         uint256 taxedValue = _value.sub(fee);
925 
926         // SafeMath.sub will throw if there is not enough balance.
927         _transfer(msg.sender, _to, taxedValue);
928 
929         if (address(feePool) != address(0)) {
930             _balances[address(feePool)] = _balances[address(feePool)].add(fee);
931             emit Transfer(msg.sender, address(feePool), fee);
932             if (msg.sender != owner()) {
933                 feePool.notifyTx(msg.sender, _value);
934             } 
935         }
936         return true;
937     }
938 
939 
940     /**
941     * @dev Transfer tokens from one address to another
942     * @param _from address The address which you want to send tokens from
943     * @param _to address The address which you want to transfer to
944     * @param _value uint256 the amount of tokens to be transferred
945     */
946     function transferFrom(
947         address _from,
948         address _to,
949         uint256 _value
950     )
951         public
952         returns (bool)
953     {
954         require(_to != address(0));
955         require(_value <= _balances[_from]);
956         require(_value <= _allowances[_from][msg.sender]);
957 
958         uint256 fee = _value.mul(txFeePerMillion).div(10**6);
959         uint256 taxedValue = _value.sub(fee);
960 
961         _balances[_from] = _balances[_from].sub(_value);
962         _balances[_to] = _balances[_to].add(taxedValue);
963         _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
964         emit Transfer(_from, _to, _value);
965         
966         if (address(feePool) != address(0)) {
967             _balances[address(feePool)] = _balances[address(feePool)].add(fee);
968             emit Transfer(msg.sender, address(feePool), fee);        
969             feePool.notifyTx(msg.sender, _value);
970         }
971         return true;
972     }
973 
974     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
975         _mint(account, amount);
976         return true;
977     }
978 
979     /**
980      * @dev Destoys `amount` tokens from the caller.
981      *
982      * See `ERC20._burn`.
983      */
984     function burn(uint256 amount) public {
985         _burn(msg.sender, amount);
986     }
987 
988     /**
989      * @dev See `ERC20._burnFrom`.
990      */
991     function burnFrom(address account, uint256 amount) public {
992         _burnFrom(account, amount);
993     }
994 }