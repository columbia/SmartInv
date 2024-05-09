1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev provides information about the current execution context, including the
5  * sender of the transaction and its data. while these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with gsn meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * this contract is only required for intermediate, library-like contracts.
12  */
13 contract Context {
14     // empty internal constructor, to prevent people from mistakenly deploying
15     // an instance of this contract, which should be used via inheritance.
16     constructor () internal { }
17     // solhint-disable-previous-line no-empty-blocks
18 
19     function _msgSender() internal view returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * this module is used through inheritance. it will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(isOwner(), "caller is not beeg");
64         _;
65     }
66 
67     /**
68      * @dev returns true if the caller is the current owner.
69      */
70     function isOwner() public view returns (bool) {
71         return _msgSender() == _owner;
72     }
73 
74     /**
75      * @dev leaves the contract without owner. it will not be possible to call
76      * `onlyOwner` functions anymore. can only be called by the current owner.
77      *
78      * smol note: renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev transfers ownership of the contract to a new account (`newOwner`).
88      * can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public onlyOwner {
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev transfers ownership of the contract to a new account (`newOwner`).
96      */
97     function _transferOwnership(address newOwner) internal {
98         require(newOwner != address(0), "new beeg is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 /**
105  * @dev interface of the erc20 standard as defined in the eip. does not include
106  * the optional functions; to access them see {erc20detailed}.
107  */
108 interface IERC20 {
109     /**
110      * @dev returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev moves `amount` tokens from the caller's account to `recipient`.
121      *
122      * returns a boolean value indicating whether the operation succeeded.
123      *
124      * emits a {Transfer} event.
125      */
126     function transfer(address recipient, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. this is
131      * zero by default.
132      *
133      * this value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     /**
138      * @dev sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * returns a boolean value indicating whether the operation succeeded.
141      *
142      * rly beeg ting here: be aware that changing an allowance with this method brings
143      * the risk that someone may use both the old and the new allowance by
144      * unfortunate transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev moves `amount` tokens from `sender` to `recipient` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * returns a boolean value indicating whether the operation succeeded.
159      *
160      * emits a {Transfer} event.
161      */
162     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev emitted when `value` tokens are moved from one account (`from`) to
166      * another (`to`).
167      *
168      * note that `value` may be zero.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 value);
171 
172     /**
173      * @dev emitted when the allowance of a `spender` for an `owner` is set by
174      * a call to {approve}. `value` is the new allowance.
175      */
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 /**
180  * @title roles
181  * @dev library for managing addresses assigned to a role.
182  */
183 library Roles {
184     struct Role {
185         mapping (address => bool) bearer;
186     }
187 
188     /**
189      * @dev give an account access to this role.
190      */
191     function add(Role storage role, address account) internal {
192         require(!has(role, account), "roles: account already has role");
193         role.bearer[account] = true;
194     }
195 
196     /**
197      * @dev remove an account's access to this role.
198      */
199     function remove(Role storage role, address account) internal {
200         require(has(role, account), "roles: account does not have role");
201         role.bearer[account] = false;
202     }
203 
204     /**
205      * @dev check if an account has this role.
206      * @return bool
207      */
208     function has(Role storage role, address account) internal view returns (bool) {
209         require(account != address(0), "roles: account is the zero address");
210         return role.bearer[account];
211     }
212 }
213 
214 contract MinterRole is Context {
215     using Roles for Roles.Role;
216 
217     event MinterAdded(address indexed account);
218     event MinterRemoved(address indexed account);
219 
220     Roles.Role private _minters;
221 
222     constructor () internal {
223         _addMinter(_msgSender());
224     }
225 
226     modifier onlyMinter() {
227         require(isMinter(_msgSender()), "smol guy does not have beeg role");
228         _;
229     }
230 
231     function isMinter(address account) public view returns (bool) {
232         return _minters.has(account);
233     }
234 
235     function addMinter(address account) public onlyMinter {
236         _addMinter(account);
237     }
238 
239     function renounceMinter() public {
240         _removeMinter(_msgSender());
241     }
242 
243     function _addMinter(address account) internal {
244         _minters.add(account);
245         emit MinterAdded(account);
246     }
247 
248     function _removeMinter(address account) internal {
249         _minters.remove(account);
250         emit MinterRemoved(account);
251     }
252 }
253 
254 /**
255  * @title safemath
256  * @dev unsigned math operations with safety checks that revert on error
257  */
258 library SafeMath {
259 
260     /**
261      * @dev multiplies two unsigned integers, reverts on overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // gas optimization: this is cheeper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // see: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "safemath#mul: OVERFLOW");
273 
274         return c;
275     }
276 
277     /**
278      * @dev integer division of two unsigned integers truncating the quotient, reverts on division by zero.
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         // solidity only automatically asserts when dividing by 0
282         require(b > 0, "safemath#div: DIVISION_BY_ZERO");
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // there is no case in which this doesn't hold
285 
286         return c;
287     }
288 
289     /**
290      * @dev subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
291      */
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         require(b <= a, "safemath#sub: UNDERFLOW");
294         uint256 c = a - b;
295 
296         return c;
297     }
298 
299     /**
300      * @dev adds two unsigned integers, reverts on overflow.
301      */
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         uint256 c = a + b;
304         require(c >= a, "safemath#add: OVERFLOW");
305 
306         return c;
307     }
308 
309     /**
310      * @dev divides two unsigned integers and returns the remainder (unsigned integer modulo),
311      * reverts when dividing by zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(b != 0, "safemath#mod: DIVISION_BY_ZERO");
315         return a % b;
316     }
317 
318 }
319 
320 /**
321  * copyright 2018 zeroex intl.
322  * licensed under the apache license, version 2.0 (the "License");
323  * you may not use this file except in compliance with the License.
324  * you may obtain a copy of the License at
325  *   http://www.apache.org/licenses/LICENSE-2.0
326  * unless required by applicable law or agreed to in writing, software
327  * distributed under the License is distributed on an "AS IS" BASIS,
328  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
329  * see the License for the specific language governing permissions and
330  * limitations under the License.
331  */
332 /**
333  * utility library of inline functions on addresses
334  */
335 library Address {
336 
337     /**
338      * returns whether the target address is a contract
339      * @dev this function will return false if invoked during the constructor of a contract,
340      * as the code is not actually created until after the constructor finishes.
341      * @param account address of the account to check
342      * @return whether the target address is a contract
343      */
344     function isContract(address account) internal view returns (bool) {
345         bytes32 codehash;
346         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
347 
348         // XXX currently there is no better way to check if there is a contract in an address
349         // than to check the size of the code at that address.
350         // see https://ethereum.stackexchange.com/a/14016/36603
351         // for more details about how this works.
352         // todo check this again before the serenity release, because all addresses will be
353         // contracts then.
354         assembly { codehash := extcodehash(account) }
355         return (codehash != 0x0 && codehash != accountHash);
356     }
357 
358 }
359 
360 contract CanTransferRole is Context {
361     using Roles for Roles.Role;
362 
363     event CanTransferAdded(address indexed account);
364     event CanTransferRemoved(address indexed account);
365 
366     Roles.Role private _canTransfer;
367 
368     constructor () internal {
369         _addCanTransfer(_msgSender());
370     }
371 
372     modifier onlyCanTransfer() {
373         require(canTransfer(_msgSender()), "cant: caller is too smol");
374         _;
375     }
376 
377     function canTransfer(address account) public view returns (bool) {
378         return _canTransfer.has(account);
379     }
380 
381     function addCanTransfer(address account) public onlyCanTransfer {
382         _addCanTransfer(account);
383     }
384 
385     function renounceCanTransfer() public {
386         _removeCanTransfer(_msgSender());
387     }
388 
389     function _addCanTransfer(address account) internal {
390         _canTransfer.add(account);
391         emit CanTransferAdded(account);
392     }
393 
394     function _removeCanTransfer(address account) internal {
395         _canTransfer.remove(account);
396         emit CanTransferRemoved(account);
397     }
398 }
399 
400 contract SmolTing is Ownable, MinterRole, CanTransferRole {
401     using SafeMath for uint256;
402     event Transfer(address indexed from, address indexed to, uint256 value);
403 
404     mapping (address => uint256) private _balances;
405 
406     uint256 private _totalSupply;
407     uint256 private _totalClaimed;
408     string public name = "smol ting";
409     string public symbol = "TING";
410     uint8 public decimals = 18;
411 
412     /**
413      * @dev total number of tokens in existence.
414      */
415     function totalSupply() public view returns (uint256) {
416         return _totalSupply;
417     }
418 
419     // returns the total claimed smol
420     // this is just purely used to display the total smol claimed by users on the frontend
421     function totalClaimed() public view returns (uint256) {
422         return _totalClaimed;
423     }
424 
425     // add smol claimed
426     function addClaimed(uint256 _amount) public onlyCanTransfer {
427         _totalClaimed = _totalClaimed.add(_amount);
428     }
429 
430     // set smol claimed to a custom value, for if we wanna reset the counter anytime
431     function setClaimed(uint256 _amount) public onlyCanTransfer {
432         require(_amount >= 0, "cannot be negative");
433         _totalClaimed = _amount;
434     }
435 
436     // as this token is non tradable, only minters are allowed to transfer tokens between accounts
437     function transfer(address receiver, uint numTokens) public onlyCanTransfer returns (bool) {
438         require(numTokens <= _balances[msg.sender]);
439         _balances[msg.sender] = _balances[msg.sender].sub(numTokens);
440         _balances[receiver] = _balances[receiver].add(numTokens);
441         emit Transfer(msg.sender, receiver, numTokens);
442         return true;
443     }
444 
445     // as this token is non tradable, only minters are allowed to transfer tokens between accounts
446     function transferFrom(address owner, address buyer, uint numTokens) public onlyCanTransfer returns (bool) {
447         require(numTokens <= _balances[owner]);
448 
449         _balances[owner] = _balances[owner].sub(numTokens);
450         _balances[buyer] = _balances[buyer].add(numTokens);
451         emit Transfer(owner, buyer, numTokens);
452         return true;
453     }
454 
455     /**
456      * @dev gets the balance of the specified address.
457      * @param owner the address to query the balance of.
458      * @return a uint256 representing the amount owned by the passed address.
459      */
460     function balanceOf(address owner) public view returns (uint256) {
461         return _balances[owner];
462     }
463 
464     function mint(address _to, uint256 _amount) public onlyMinter {
465         _mint(_to, _amount);
466     }
467 
468     function burn(address _account, uint256 value) public onlyCanTransfer {
469         require(_balances[_account] >= value, "nope, cannot burn more than address has");
470         _burn(_account, value);
471     }
472 
473     /**
474      * @dev internal function that mints an amount of the token and assigns it to
475      * an account. this encapsulates the modification of balances such that the
476      * proper events are emitted.
477      * @param account the account that will receive the created tokens.
478      * @param value the amount that will be created.
479      */
480     function _mint(address account, uint256 value) internal {
481         require(account != address(0), "erc20: mint to the zero address");
482 
483         _totalSupply = _totalSupply.add(value);
484         _balances[account] = _balances[account].add(value);
485         emit Transfer(address(0), account, value);
486     }
487 
488     /**
489      * @dev internal function that burns an amount of the token of a given
490      * account.
491      * @param account the account whose tokens will be burnt.
492      * @param value the amount that will be burnt.
493      */
494     function _burn(address account, uint256 value) internal {
495         require(account != address(0), "erc20: burn from the zero address");
496 
497         _totalSupply = _totalSupply.sub(value);
498         _balances[account] = _balances[account].sub(value);
499         emit Transfer(account, address(0), value);
500     }
501 }
502 
503 /*
504 * @dev Contract from where the multiplier is taken.
505 */
506 interface SmolMuseum {
507     function getBoosterForUser(address _address, uint256 _pid) external view returns (uint256);
508 }
509 
510 contract SmolTingPot is Ownable {
511     using SafeMath for uint256;
512 
513     // info of each user.
514     struct UserInfo {
515         uint256 amount; // how many tokens the user has provided.
516         uint256 rewardDebt; // Reward debt. See explanation below.
517         //
518         // we do some fancy math here. basically, any point in time, the amount of TINGs
519         // entitled to a user but is pending to be distributed is:
520         //
521         //   pending reward = (user.amount * pool.accTingPerShare) - user.rewardDebt
522         //
523         // whenever a user deposits or withdraws tokens to a pool. Here's what happens:
524         //   1. user's pending reward is minted to his/her address.
525         //   2. user's `amount` gets updated.
526         //   3. user's `lastUpdate` gets updated.
527     }
528 
529     // info of each pool.
530     struct PoolInfo {
531         IERC20 token; // address of token contract.
532         uint256 tingsPerDay; // the amount of TINGs per day generated for each token staked
533         uint256 maxStake; // the maximum amount of tokens which can be staked in this pool
534         uint256 lastUpdateTime; // last timestamp that TINGs distribution occurs.
535         uint256 accTingPerShare; // accumulated TINGs per share, times 1e12. See below.
536     }
537 
538     // treasury address.
539     address public treasuryAddr;
540     // info of each pool.
541     PoolInfo[] public poolInfo;
542     // info of each user that stakes LP tokens.
543     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
544     // record whether the pair has been added.
545     mapping(address => uint256) public tokenPID;
546 
547     SmolTing public Ting;
548     SmolMuseum public Museum;
549 
550     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
551     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
552     event EmergencyWithdraw(
553         address indexed user,
554         uint256 indexed pid,
555         uint256 amount
556     );
557 
558     constructor(SmolTing _tingAddress, SmolMuseum _smolMuseumAddress, address _treasuryAddr) public {
559         Ting = _tingAddress;
560         Museum = _smolMuseumAddress;
561         treasuryAddr = _treasuryAddr;
562     }
563 
564     function poolLength() external view returns (uint256) {
565         return poolInfo.length;
566     }
567 
568     // add a new token to the pool. can only be called by the owner.
569     // XXX DO NOT add the same token more than once. rewards will be messed up if you do.
570     function add(IERC20 _token, uint256 _tingsPerDay, uint256 _maxStake) public onlyOwner {
571         require(tokenPID[address(_token)] == 0, "smoltingpot:duplicate add.");
572         require(address(_token) != address(Ting), "cannot add ting as a pool" );
573         poolInfo.push(
574             PoolInfo({
575                 token: _token,
576                 maxStake: _maxStake,
577                 tingsPerDay: _tingsPerDay,
578                 lastUpdateTime: block.timestamp,
579                 accTingPerShare: 0
580             })
581         );
582         tokenPID[address(_token)] = poolInfo.length;
583     }
584 
585     // set a new max stake. value must be greater than previous one,
586     // to not give an unfair advantage to people who already staked > new max
587     function setMaxStake(uint256 pid, uint256 amount) public onlyOwner {
588         require(amount >= 0, "max stake cannot be negative");
589         poolInfo[pid].maxStake = amount;
590     }
591 
592     // set the amount of TINGs generated per day for each token staked
593     function setTingsPerDay(uint256 pid, uint256 amount) public onlyOwner {
594         require(amount >= 0, "hey smol tings per day cannot be negative");
595         PoolInfo storage pool = poolInfo[pid];
596         uint256 blockTime = block.timestamp;
597         uint256 tingReward = blockTime.sub(pool.lastUpdateTime).mul(pool.tingsPerDay);
598 
599         pool.accTingPerShare = pool.accTingPerShare.add(tingReward.mul(1e12).div(86400));
600         pool.lastUpdateTime = block.timestamp;
601         pool.tingsPerDay = amount;
602     }
603 
604     function _pendingTing(uint256 _pid, address _user) internal view returns (uint256[2] memory) {
605         PoolInfo storage pool = poolInfo[_pid];
606         UserInfo storage user = userInfo[_pid][_user];
607         uint256 blockTime = block.timestamp;
608         uint256 accTing = pool.accTingPerShare;
609 
610         uint256 tingReward = blockTime.sub(pool.lastUpdateTime).mul(pool.tingsPerDay);
611         accTing = accTing.add(tingReward.mul(1e12).div(86400));                    
612     
613         uint256 pending = user.amount.mul(accTing).div(1e12).sub(user.rewardDebt);
614         return [pending, accTing];
615     }
616 
617     // view function to see pending TINGs on frontend.
618     function pendingTing(uint256 _pid, address _user) public view returns (uint256) {
619         uint256 pending = _pendingTing(_pid, _user)[0];
620         if (Museum.getBoosterForUser(_user, _pid) > 0) pending = pending.mul(Museum.getBoosterForUser(_user, _pid).add(1));
621         return pending;
622     }
623 
624 
625     // view function to calculate the total pending TINGs of address across all pools
626     function totalPendingTing(address _user) public view returns (uint256) {
627         uint256 total = 0;
628         uint256 length = poolInfo.length;
629         for (uint256 pid = 0; pid < length; ++pid) {
630             total = total.add(pendingTing(pid, _user));
631         }
632 
633         return total;
634     }
635 
636     // harvest pending TINGs of a list of pools.
637     // be careful of beeg gas spending if you try to harvest a big number of pools
638     // might be worth it checking in the frontend for the pool IDs with pending ting for this address and only harvest those
639     function rugPull(uint256[] memory _pids) public {
640         for (uint i=0; i < _pids.length; i++) {
641             withdraw(_pids[i], 0, msg.sender);
642         }
643     }
644 
645 
646     // deposit LP tokens to pool for TING allocation.
647     function deposit(uint256 _pid, uint256 _amount) public {
648         PoolInfo storage pool = poolInfo[_pid];
649         UserInfo storage user = userInfo[_pid][msg.sender];
650         require(_amount.add(user.amount) <= pool.maxStake, "cannot stake beyond max stake value");
651 
652         uint256 pending = _pendingTing(_pid, msg.sender)[0];
653         uint256 accTing = _pendingTing(_pid, msg.sender)[1];
654         user.amount = user.amount.add(_amount);
655         user.rewardDebt = user.amount.mul(accTing).div(1e12);
656 
657         uint256 pendingWithBooster = pending.mul(Museum.getBoosterForUser(msg.sender, _pid).add(1));
658         if (pendingWithBooster > 0) {
659             Ting.mint(treasuryAddr, pendingWithBooster.div(40)); // 2.5% TING for the treasury (usable to purchase NFTs)
660             Ting.mint(msg.sender, pendingWithBooster);
661             Ting.addClaimed(pendingWithBooster);
662         }
663 
664         pool.token.transferFrom(address(msg.sender), address(this), _amount);
665         emit Deposit(msg.sender, _pid, _amount);
666     }
667 
668     // withdraw tokens from pool.
669     function withdraw(uint256 _pid, uint256 _amount, address _staker) public {
670         address staker = _staker;
671         PoolInfo storage pool = poolInfo[_pid];
672         UserInfo storage user = userInfo[_pid][staker];
673         require(user.amount >= _amount, "withdraw: not good");
674         require(msg.sender == staker || _amount == 0);
675 
676         uint256 pending = _pendingTing(_pid, staker)[0];
677         uint256 accTing = _pendingTing(_pid, staker)[1];
678 
679         // in case the maxstake has been lowered and address is above maxstake, we force it to withdraw what is above current maxstake
680         // user can delay his/her withdraw/harvest to take advantage of a reducing of maxstake,
681         // if he/she entered the pool at maxstake before the maxstake reducing occured
682         uint256 leftAfterWithdraw = user.amount.sub(_amount);
683         if (leftAfterWithdraw > pool.maxStake) {
684             _amount = _amount.add(leftAfterWithdraw - pool.maxStake);
685         }
686 
687         user.amount = user.amount.sub(_amount);
688         user.rewardDebt = user.amount.mul(accTing).div(1e12);
689 
690         uint256 pendingWithBooster = pending.mul(Museum.getBoosterForUser(staker, _pid).add(1));
691         if(pendingWithBooster > 0)
692         {
693             Ting.mint(treasuryAddr, pendingWithBooster.div(40));
694             Ting.mint(staker, pendingWithBooster);
695             Ting.addClaimed(pendingWithBooster);
696         }
697 
698         pool.token.transfer(address(staker), _amount);
699         emit Withdraw(staker, _pid, _amount);
700     }
701 
702     // withdraw without caring about rewards. EMERGENCY ONLY.
703     function emergencyWithdraw(uint256 _pid) public {
704         PoolInfo storage pool = poolInfo[_pid];
705         UserInfo storage user = userInfo[_pid][msg.sender];
706         require(user.amount > 0, "emergncy withdrawal not good");
707         uint256 _amount = user.amount;
708         user.amount = 0;
709         user.rewardDebt = 0;
710         pool.token.transfer(address(msg.sender), _amount);
711         emit EmergencyWithdraw(msg.sender, _pid, _amount);
712     }
713 
714 
715     // update dev address by the previous dev.
716     function treasury(address _treasuryAddr) public {
717         require(msg.sender == treasuryAddr, "must be called from current treasury address");
718         treasuryAddr = _treasuryAddr;
719     }
720 
721     // update Museum address if the booster logic changed.
722     function updateSmolMuseumAddress(SmolMuseum _smolMuseumAddress) public onlyOwner{
723         Museum = _smolMuseumAddress;
724     }
725 }