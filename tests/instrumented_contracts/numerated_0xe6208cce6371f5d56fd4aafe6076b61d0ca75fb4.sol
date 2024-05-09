1 // File: contracts-waifu/waif/utils/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: contracts-waifu/waif/utils/Ownable.sol
32 
33 pragma solidity 0.5.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(isOwner(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Returns true if the caller is the current owner.
76      */
77     function isOwner() public view returns (bool) {
78         return _msgSender() == _owner;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public onlyOwner {
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      */
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: contracts-waifu/waif/utils/SafeMath.sol
112 
113 pragma solidity 0.5.0;
114 /**
115  * @title SafeMath
116  * @dev Unsigned math operations with safety checks that revert on error
117  */
118 library SafeMath {
119 
120     /**
121      * @dev Multiplies two unsigned integers, reverts on overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
125         // benefit is lost if 'b' is also tested.
126         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
127         if (a == 0) {
128             return 0;
129         }
130 
131         uint256 c = a * b;
132         require(c / a == b, "SafeMath#mul: OVERFLOW");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Solidity only automatically asserts when dividing by 0
142         require(b > 0, "SafeMath#div: DIVISION_BY_ZERO");
143         uint256 c = a / b;
144         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145 
146         return c;
147     }
148 
149     /**
150      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b <= a, "SafeMath#sub: UNDERFLOW");
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Adds two unsigned integers, reverts on overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         uint256 c = a + b;
164         require(c >= a, "SafeMath#add: OVERFLOW");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
171      * reverts when dividing by zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b != 0, "SafeMath#mod: DIVISION_BY_ZERO");
175         return a % b;
176     }
177 
178 }
179 
180 // File: contracts-waifu/waif/utils/IERC20.sol
181 
182 pragma solidity 0.5.0;
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
186  * the optional functions; to access them see {ERC20Detailed}.
187  */
188 interface IERC20 {
189     /**
190      * @dev Returns the amount of tokens in existence.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     /**
195      * @dev Returns the amount of tokens owned by `account`.
196      */
197     function balanceOf(address account) external view returns (uint256);
198 
199     /**
200      * @dev Moves `amount` tokens from the caller's account to `recipient`.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transfer(address recipient, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Returns the remaining number of tokens that `spender` will be
210      * allowed to spend on behalf of `owner` through {transferFrom}. This is
211      * zero by default.
212      *
213      * This value changes when {approve} or {transferFrom} are called.
214      */
215     function allowance(address owner, address spender) external view returns (uint256);
216 
217     /**
218      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * IMPORTANT: Beware that changing an allowance with this method brings the risk
223      * that someone may use both the old and the new allowance by unfortunate
224      * transaction ordering. One possible solution to mitigate this race
225      * condition is to first reduce the spender's allowance to 0 and set the
226      * desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address spender, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Moves `amount` tokens from `sender` to `recipient` using the
235      * allowance mechanism. `amount` is then deducted from the caller's
236      * allowance.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 // File: contracts-waifu/waif/utils/Roles.sol
260 
261 pragma solidity 0.5.0;
262 /**
263  * @title Roles
264  * @dev Library for managing addresses assigned to a Role.
265  */
266 library Roles {
267     struct Role {
268         mapping (address => bool) bearer;
269     }
270 
271     /**
272      * @dev Give an account access to this role.
273      */
274     function add(Role storage role, address account) internal {
275         require(!has(role, account), "Roles: account already has role");
276         role.bearer[account] = true;
277     }
278 
279     /**
280      * @dev Remove an account's access to this role.
281      */
282     function remove(Role storage role, address account) internal {
283         require(has(role, account), "Roles: account does not have role");
284         role.bearer[account] = false;
285     }
286 
287     /**
288      * @dev Check if an account has this role.
289      * @return bool
290      */
291     function has(Role storage role, address account) internal view returns (bool) {
292         require(account != address(0), "Roles: account is the zero address");
293         return role.bearer[account];
294     }
295 }
296 
297 // File: contracts-waifu/waif/utils/MinterRole.sol
298 
299 pragma solidity 0.5.0;
300 
301 
302 
303 
304 contract MinterRole is Context {
305     using Roles for Roles.Role;
306 
307     event MinterAdded(address indexed account);
308     event MinterRemoved(address indexed account);
309 
310     Roles.Role private _minters;
311 
312     constructor () internal {
313         _addMinter(_msgSender());
314     }
315 
316     modifier onlyMinter() {
317         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
318         _;
319     }
320 
321     function isMinter(address account) public view returns (bool) {
322         return _minters.has(account);
323     }
324 
325     function addMinter(address account) public onlyMinter {
326         _addMinter(account);
327     }
328 
329     function renounceMinter() public {
330         _removeMinter(_msgSender());
331     }
332 
333     function _addMinter(address account) internal {
334         _minters.add(account);
335         emit MinterAdded(account);
336     }
337 
338     function _removeMinter(address account) internal {
339         _minters.remove(account);
340         emit MinterRemoved(account);
341     }
342 }
343 
344 // File: contracts-waifu/waif/utils/CanTransferRole.sol
345 
346 pragma solidity 0.5.0;
347 
348 
349 
350 
351 contract CanTransferRole is Context {
352     using Roles for Roles.Role;
353 
354     event CanTransferAdded(address indexed account);
355     event CanTransferRemoved(address indexed account);
356 
357     Roles.Role private _canTransfer;
358 
359     constructor () internal {
360         _addCanTransfer(_msgSender());
361     }
362 
363     modifier onlyCanTransfer() {
364         require(canTransfer(_msgSender()), "CanTransferRole: caller does not have the CanTransfer role");
365         _;
366     }
367 
368     function canTransfer(address account) public view returns (bool) {
369         return _canTransfer.has(account);
370     }
371 
372     function addCanTransfer(address account) public onlyCanTransfer {
373         _addCanTransfer(account);
374     }
375 
376     function renounceCanTransfer() public {
377         _removeCanTransfer(_msgSender());
378     }
379 
380     function _addCanTransfer(address account) internal {
381         _canTransfer.add(account);
382         emit CanTransferAdded(account);
383     }
384 
385     function _removeCanTransfer(address account) internal {
386         _canTransfer.remove(account);
387         emit CanTransferRemoved(account);
388     }
389 }
390 
391 // File: contracts-waifu/waif/HaremNonTradable.sol
392 
393 pragma solidity 0.5.0;
394 
395 
396 
397 
398 
399 
400 
401 
402 
403 contract HaremNonTradable is Ownable, MinterRole, CanTransferRole {
404     using SafeMath for uint256;
405     event Transfer(address indexed from, address indexed to, uint256 value);
406 
407     mapping (address => uint256) private _balances;
408 
409     uint256 private _totalSupply;
410     uint256 private _totalClaimed;
411     string public name = "HAREM - Non Tradable";
412     string public symbol = "HAREM";
413     uint8 public decimals = 18;
414 
415     /**
416      * @dev Total number of tokens in existence.
417      */
418     function totalSupply() public view returns (uint256) {
419         return _totalSupply;
420     }
421 
422     // Returns the total claimed Harem
423     // This is just purely used to display the total Harem claimed by users on the frontend
424     function totalClaimed() public view returns (uint256) {
425         return _totalClaimed;
426     }
427 
428     // Add Harem claimed
429     function addClaimed(uint256 _amount) public onlyCanTransfer {
430         _totalClaimed = _totalClaimed.add(_amount);
431     }
432 
433     // Set Harem claimed to a custom value, for if we wanna reset the counter on new season release
434     function setClaimed(uint256 _amount) public onlyCanTransfer {
435         require(_amount >= 0, "Cant be negative");
436         _totalClaimed = _amount;
437     }
438 
439     // As this token is non tradable, only minters are allowed to transfer tokens between accounts
440     function transfer(address receiver, uint numTokens) public onlyCanTransfer returns (bool) {
441         require(numTokens <= _balances[msg.sender]);
442         _balances[msg.sender] = _balances[msg.sender].sub(numTokens);
443         _balances[receiver] = _balances[receiver].add(numTokens);
444         emit Transfer(msg.sender, receiver, numTokens);
445         return true;
446     }
447 
448     // As this token is non tradable, only minters are allowed to transfer tokens between accounts
449     function transferFrom(address owner, address buyer, uint numTokens) public onlyCanTransfer returns (bool) {
450         require(numTokens <= _balances[owner]);
451 
452         _balances[owner] = _balances[owner].sub(numTokens);
453         _balances[buyer] = _balances[buyer].add(numTokens);
454         emit Transfer(owner, buyer, numTokens);
455         return true;
456     }
457 
458     /**
459      * @dev Gets the balance of the specified address.
460      * @param owner The address to query the balance of.
461      * @return A uint256 representing the amount owned by the passed address.
462      */
463     function balanceOf(address owner) public view returns (uint256) {
464         return _balances[owner];
465     }
466 
467     function mint(address _to, uint256 _amount) public onlyMinter {
468         _mint(_to, _amount);
469     }
470 
471     function burn(address _account, uint256 value) public onlyCanTransfer {
472         require(_balances[_account] >= value, "Cannot burn more than address has");
473         _burn(_account, value);
474     }
475 
476     /**
477      * @dev Internal function that mints an amount of the token and assigns it to
478      * an account. This encapsulates the modification of balances such that the
479      * proper events are emitted.
480      * @param account The account that will receive the created tokens.
481      * @param value The amount that will be created.
482      */
483     function _mint(address account, uint256 value) internal {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _totalSupply = _totalSupply.add(value);
487         _balances[account] = _balances[account].add(value);
488         emit Transfer(address(0), account, value);
489     }
490 
491     /**
492      * @dev Internal function that burns an amount of the token of a given
493      * account.
494      * @param account The account whose tokens will be burnt.
495      * @param value The amount that will be burnt.
496      */
497     function _burn(address account, uint256 value) internal {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _totalSupply = _totalSupply.sub(value);
501         _balances[account] = _balances[account].sub(value);
502         emit Transfer(account, address(0), value);
503     }
504 }
505 
506 // File: contracts-waifu/waif/HaremFactory.sol
507 
508 pragma solidity 0.5.0;
509 
510 
511 
512 
513 
514 contract HaremFactory is Ownable {
515     using SafeMath for uint256;
516 
517     // Info of each user.
518     struct UserInfo {
519         uint256 amount; // How many tokens the user has provided.
520         uint256 rewardDebt; // Reward debt. See explanation below.
521         //
522         // We do some fancy math here. Basically, any point in time, the amount of Harems
523         // entitled to a user but is pending to be distributed is:
524         //
525         //   pending reward = (user.amount * pool.accHaremPerShare) - user.rewardDebt
526         //
527         // Whenever a user deposits or withdraws tokens to a pool. Here's what happens:
528         //   1. The pool's `accHaremPerShare` (and `lastRewardBlock`) gets updated.
529         //   2. User receives the pending reward sent to his/her address.
530         //   3. User's `amount` gets updated.
531         //   4. User's `rewardDebt` gets updated.
532     }
533 
534     // Info of each pool.
535     struct PoolInfo {
536         IERC20 token; // Address of token contract.
537         uint256 haremsPerDay; // The amount of Harems per day generated for each token staked
538         uint256 maxStake; // The maximum amount of tokens which can be staked in this pool
539         uint256 lastUpdateTime; // Last timestamp that Harems distribution occurs.
540         uint256 accHaremPerShare; // Accumulated Harems per share, times 1e12. See below.
541     }
542 
543     // Treasury address.
544     address public treasuryAddr;
545     // Info of each pool.
546     PoolInfo[] public poolInfo;
547     // Info of each user that stakes LP tokens.
548     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
549     // Record whether the pair has been added.
550     mapping(address => uint256) public tokenPID;
551 
552     HaremNonTradable public Harem;
553 
554     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
555     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
556     event EmergencyWithdraw(
557         address indexed user,
558         uint256 indexed pid,
559         uint256 amount
560     );
561 
562     constructor(HaremNonTradable _haremAddress, address _treasuryAddr) public {
563         Harem = _haremAddress;
564         treasuryAddr = _treasuryAddr;
565     }
566 
567     function poolLength() external view returns (uint256) {
568         return poolInfo.length;
569     }
570 
571     // Add a new token to the pool. Can only be called by the owner.
572     // XXX DO NOT add the same token more than once. Rewards will be messed up if you do.
573     function add(IERC20 _token, uint256 _haremsPerDay, uint256 _maxStake) public onlyOwner {
574         require(tokenPID[address(_token)] == 0, "GiverOfHarem:duplicate add.");
575         require(address(_token) != address(Harem), "Cannot add Harem as a pool" );
576         poolInfo.push(
577             PoolInfo({
578                 token: _token,
579                 maxStake: _maxStake,
580                 haremsPerDay: _haremsPerDay,
581                 lastUpdateTime: block.timestamp,
582                 accHaremPerShare: 0
583             })
584         );
585         tokenPID[address(_token)] = poolInfo.length;
586     }
587 
588   
589     function setMaxStake(uint256 pid, uint256 amount) public onlyOwner {
590         require(amount >= 0, "Max stake cannot be negative");
591         poolInfo[pid].maxStake = amount;
592     }
593 
594     // Set the amount of Harems generated per day for each token staked
595     function setHaremsPerDay(uint256 pid, uint256 amount) public onlyOwner {
596         require(amount >= 0, "Harems per day cannot be negative");
597         updatePool(pid);
598         poolInfo[pid].haremsPerDay = amount;
599     }
600 
601     // View function to see pending Harems on frontend.
602     function pendingHarem(uint256 _pid, address _user) public view returns (uint256) {
603         PoolInfo storage pool = poolInfo[_pid];
604         UserInfo storage user = userInfo[_pid][_user];
605         uint256 blockTime = block.timestamp;
606         uint256 accHaremPerShare = pool.accHaremPerShare;
607         uint256 tokenSupply = pool.token.balanceOf(address(this));
608         if (blockTime > pool.lastUpdateTime && tokenSupply != 0) {
609             uint256 haremReward = pendingHaremOfPool(_pid);
610             accHaremPerShare = accHaremPerShare.add(haremReward.mul(1e12).div(tokenSupply));
611         }
612         return user.amount.mul(accHaremPerShare).div(1e12).sub(user.rewardDebt);
613     }
614 
615     // View function to calculate the total pending Harems of address across all pools
616     function totalPendingHarem(address _user) public view returns (uint256) {
617         uint256 total = 0;
618         uint256 length = poolInfo.length;
619         for (uint256 pid = 0; pid < length; ++pid) {
620             total = total.add(pendingHarem(pid, _user));
621         }
622 
623         return total;
624     }
625 
626     // View function to see pending Harems on the whole pool
627     function pendingHaremOfPool(uint256 _pid) public view returns (uint256) {
628         PoolInfo storage pool = poolInfo[_pid];
629         uint256 blockTime = block.timestamp;
630         uint256 tokenSupply = pool.token.balanceOf(address(this));
631         return blockTime.sub(pool.lastUpdateTime).mul(tokenSupply.mul(pool.haremsPerDay).div(86400).div(1000000000000000000));
632     }
633 
634     // Harvest pending Harems of a list of pools.
635     // Be careful of gas spending if you try to harvest a big number of pools
636     // Might be worth it checking in the frontend for the pool IDs with pending Harem for this address and only harvest those
637     function rugPull(uint256[] memory _pids) public {
638         for (uint i=0; i < _pids.length; i++) {
639             withdraw(_pids[i], 0);
640         }
641     }
642 
643     // Update reward variables for all pools. Be careful of gas spending!
644     function rugPullAll() public {
645         uint256 length = poolInfo.length;
646         for (uint256 pid = 0; pid < length; ++pid) {
647             updatePool(pid);
648         }
649     }
650 
651     // Update reward variables of the given pool to be up-to-date.
652     function updatePool(uint256 _pid) public {
653         PoolInfo storage pool = poolInfo[_pid];
654         if (block.timestamp <= pool.lastUpdateTime) {
655             return;
656         }
657         if (pool.haremsPerDay == 0) {
658             pool.lastUpdateTime = block.timestamp;
659             return;
660         }
661         uint256 tokenSupply = pool.token.balanceOf(address(this));
662         if (tokenSupply == 0) {
663             pool.lastUpdateTime = block.timestamp;
664             return;
665         }
666 
667         // return blockTime.sub(lastUpdateTime[account]).mul(balanceOf(account).mul(haremsPerDay).div(86400));
668         uint256 haremReward = pendingHaremOfPool(_pid);
669         //Harem.mint(treasuryAddr, haremReward.div(40)); // 2.5% Harem for the treasury (Usable to purchase NFTs)
670         Harem.mint(address(this), haremReward);
671 
672         pool.accHaremPerShare = pool.accHaremPerShare.add(haremReward.mul(1e12).div(tokenSupply));
673         pool.lastUpdateTime = block.timestamp;
674     }
675 
676     // Deposit LP tokens to pool for Harem allocation.
677     function deposit(uint256 _pid, uint256 _amount) public {
678         PoolInfo storage pool = poolInfo[_pid];
679         UserInfo storage user = userInfo[_pid][msg.sender];
680 
681         require(_amount.add(user.amount) <= pool.maxStake, "Cannot stake beyond maxStake value");
682 
683         updatePool(_pid);
684         uint256 pending = user.amount.mul(pool.accHaremPerShare).div(1e12).sub(user.rewardDebt);
685         user.amount = user.amount.add(_amount);
686         user.rewardDebt = user.amount.mul(pool.accHaremPerShare).div(1e12);
687         if (pending > 0) safeHaremTransfer(msg.sender, pending);
688         pool.token.transferFrom(address(msg.sender), address(this), _amount);
689         emit Deposit(msg.sender, _pid, _amount);
690     }
691 
692     // Withdraw tokens from pool.
693     function withdraw(uint256 _pid, uint256 _amount) public {
694         PoolInfo storage pool = poolInfo[_pid];
695         UserInfo storage user = userInfo[_pid][msg.sender];
696         require(user.amount >= _amount, "withdraw: not good");
697         updatePool(_pid);
698         uint256 pending = user.amount.mul(pool.accHaremPerShare).div(1e12).sub(user.rewardDebt);
699 
700         // In case the maxStake has been lowered and address is above maxStake, we force it to withdraw what is above current maxStake
701         // User can delay his/her withdraw/harvest to take advantage of a reducing of maxStake,
702         // if he/she entered the pool at maxStake before the maxStake reducing occured
703         uint256 leftAfterWithdraw = user.amount.sub(_amount);
704         if (leftAfterWithdraw > pool.maxStake) {
705             _amount = _amount.add(leftAfterWithdraw - pool.maxStake);
706         }
707 
708         user.amount = user.amount.sub(_amount);
709         user.rewardDebt = user.amount.mul(pool.accHaremPerShare).div(1e12);
710         safeHaremTransfer(msg.sender, pending);
711         pool.token.transfer(address(msg.sender), _amount);
712         emit Withdraw(msg.sender, _pid, _amount);
713     }
714 
715     // Withdraw without caring about rewards. EMERGENCY ONLY.
716     function emergencyWithdraw(uint256 _pid) public {
717         PoolInfo storage pool = poolInfo[_pid];
718         UserInfo storage user = userInfo[_pid][msg.sender];
719         require(user.amount > 0, "emergencyWithdraw: not good");
720         uint256 _amount = user.amount;
721         user.amount = 0;
722         user.rewardDebt = 0;
723         pool.token.transfer(address(msg.sender), _amount);
724         emit EmergencyWithdraw(msg.sender, _pid, _amount);
725     }
726 
727     // Safe Harem transfer function, just in case if rounding error causes pool to not have enough Harems.
728     function safeHaremTransfer(address _to, uint256 _amount) internal {
729         uint256 haremBal = Harem.balanceOf(address(this));
730         if (_amount > haremBal) {
731             Harem.transfer(_to, haremBal);
732             Harem.addClaimed(haremBal);
733         } else {
734             Harem.transfer(_to, _amount);
735             Harem.addClaimed(_amount);
736         }
737     }
738 
739     // Update dev address by the previous dev.
740     function treasury(address _treasuryAddr) public {
741         require(msg.sender == treasuryAddr, "Must be called from current treasury address");
742         treasuryAddr = _treasuryAddr;
743     }
744 }