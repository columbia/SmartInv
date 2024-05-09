1 pragma solidity 0.6.3;
2 
3 
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17  
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25  
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30 
31     function approve(address spender, uint256 amount) external returns (bool);
32 
33  
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35 
36  
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         return div(a, b, "SafeMath: division by zero");
80     }
81 
82     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b > 0, errorMessage);
84         uint256 c = a / b;
85         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86 
87         return c;
88     }
89 
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         return mod(a, b, "SafeMath: modulo by zero");
92     }
93 
94 
95     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b != 0, errorMessage);
97         return a % b;
98     }
99 }
100 
101 
102 
103 
104 contract Ownable is Context {
105     address private _owner;
106 
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     /**
110      * @dev Initializes the contract setting the deployer as the initial owner.
111      */
112     constructor () internal {
113         address msgSender = _msgSender();
114         _owner = msgSender;
115         emit OwnershipTransferred(address(0), msgSender);
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130 
131     function renounceOwnership() public virtual onlyOwner {
132         emit OwnershipTransferred(_owner, address(0));
133         _owner = address(0);
134     }
135 
136     function transferOwnership(address newOwner) public virtual onlyOwner {
137         require(newOwner != address(0), "Ownable: new owner is the zero address");
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 
144 
145 
146 
147 
148 
149 
150 
151 library Address {
152 
153     function isContract(address account) internal view returns (bool) {
154         // This method relies on extcodesize, which returns 0 for contracts in
155         // construction, since the code is only stored at the end of the
156         // constructor execution.
157 
158         uint256 size;
159         // solhint-disable-next-line no-inline-assembly
160         assembly { size := extcodesize(account) }
161         return size > 0;
162     }
163 
164 
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
169         (bool success, ) = recipient.call{ value: amount }("");
170         require(success, "Address: unable to send value, recipient may have reverted");
171     }
172 
173 
174     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
175       return functionCall(target, data, "Address: low-level call failed");
176     }
177 
178 
179     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183 
184     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
185         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
186     }
187 
188     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
189         require(address(this).balance >= value, "Address: insufficient balance for call");
190         require(isContract(target), "Address: call to non-contract");
191 
192         // solhint-disable-next-line avoid-low-level-calls
193         (bool success, bytes memory returndata) = target.call{ value: value }(data);
194         return _verifyCallResult(success, returndata, errorMessage);
195     }
196 
197 
198     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
199         return functionStaticCall(target, data, "Address: low-level static call failed");
200     }
201 
202     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
203         require(isContract(target), "Address: static call to non-contract");
204 
205         // solhint-disable-next-line avoid-low-level-calls
206         (bool success, bytes memory returndata) = target.staticcall(data);
207         return _verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
212     }
213 
214 
215     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
216         require(isContract(target), "Address: delegate call to non-contract");
217 
218         // solhint-disable-next-line avoid-low-level-calls
219         (bool success, bytes memory returndata) = target.delegatecall(data);
220         return _verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
224         if (success) {
225             return returndata;
226         } else {
227             // Look for revert reason and bubble it up if present
228             if (returndata.length > 0) {
229                 // The easiest way to bubble the revert reason is using memory via assembly
230 
231                 // solhint-disable-next-line no-inline-assembly
232                 assembly {
233                     let returndata_size := mload(returndata)
234                     revert(add(32, returndata), returndata_size)
235                 }
236             } else {
237                 revert(errorMessage);
238             }
239         }
240     }
241 }
242 
243 
244 
245 library SafeERC20 {
246     using SafeMath for uint256;
247     using Address for address;
248 
249     function safeTransfer(IERC20 token, address to, uint256 value) internal {
250         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
251     }
252 
253     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
254         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
255     }
256 
257 
258     function safeApprove(IERC20 token, address spender, uint256 value) internal {
259         // safeApprove should only be called when setting an initial allowance,
260         // or when resetting it to zero. To increase and decrease it, use
261         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
262         // solhint-disable-next-line max-line-length
263         require((value == 0) || (token.allowance(address(this), spender) == 0),
264             "SafeERC20: approve from non-zero to non-zero allowance"
265         );
266         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
267     }
268 
269     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
270         uint256 newAllowance = token.allowance(address(this), spender).add(value);
271         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
272     }
273 
274     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
275         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
276         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
277     }
278 
279 
280     function _callOptionalReturn(IERC20 token, bytes memory data) private {
281 
282         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
283         if (returndata.length > 0) { // Return data is optional
284             // solhint-disable-next-line max-line-length
285             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
286         }
287     }
288 }
289 
290 
291 contract MasterChef is Ownable {
292     using SafeMath for uint256;
293     using SafeERC20 for IERC20;
294 
295     // Info of each user.
296     struct UserInfo {
297 		uint256 pid;
298         uint256 amount;     // How many LP tokens the user has provided.
299 		uint256 reward;
300         uint256 rewardPaid; 
301 		uint256 userRewardPerTokenPaid;
302     }
303 	// Info of each user that stakes LP tokens.
304     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
305 	
306 
307 	
308     // Info of each pool.
309     struct PoolInfo {
310         IERC20 lpToken;           // Address of LP token contract.
311         uint256 allocPoint;       // How many allocation points assigned to this pool. Pizzas to distribute per block.
312         uint256 lastRewardTime;  // Last block number that Pizzas distribution occurs.
313         uint256 accPizzaPerShare; // Accumulated Pizzas per share, times 1e18. See below.
314 		uint256 totalPool;
315     }
316     // Info of each pool.
317     PoolInfo[] public poolInfo;
318 	
319 
320 
321 
322     
323 	struct User {
324         uint id; 
325         address referrer; 
326 
327 		uint256[] referAmount;
328 
329 		uint256 referReward;
330 		
331 		uint256[] referCount;
332 	
333 		uint256 referRewardPerTokenPaid;
334 
335     }	
336 	mapping(address => User) public users;
337 	
338 
339 	uint public lastUserId = 2;
340 	mapping(uint256 => address) public regisUser;
341 
342 
343 
344 	
345 	
346 	
347 
348 	bool initialized = false;
349 
350     //uint256 public initreward = 1250*1e18;
351 
352     uint256 public starttime = 1599829200;
353 
354     uint256 public periodFinish = 0;
355 
356     uint256 public rewardRate = 0;
357 
358     uint256 public totalMinted = 0;
359 
360 
361 
362 
363 
364 	
365 
366 
367 
368 	//The Pizza TOKEN!
369 	//  IERC20 public pizza = IERC20(0xb02899b895ad5dd975784adde42c92362503a025);
370     IERC20 public pizza ;
371 
372 
373 
374 	address public defaultReferAddr = address(0x49e7EC51dC974980ad87D1e509357E0A27a0A68E);
375 	
376 	address public projectAddress = address(0xAC112a46216759fbd0a3a3ADEc245e37c9748E18);
377 	
378 
379     // Total allocation poitns. Must be the sum of all allocation points in all pools.
380     uint256 public totalAllocPoint = 0;
381     // Bonus muliplier for early pizza makers.
382     uint256 public constant BONUS_MULTIPLIER = 1;
383 
384 
385 
386 
387     event RewardPaid(address indexed user, uint256 reward);
388     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
389     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
390     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
391 
392  //constructor
393    // function initContract 
394 	 constructor (IERC20 _pizza,uint256 _rewardRate,uint256 _starttime,uint256 _periodFinish,address _defaultReferAddr,address _projectAddress) public onlyOwner{	
395 		require(initialized == false,"has initialized");
396         pizza = _pizza;
397 		rewardRate = _rewardRate;
398 		starttime = _starttime;
399 		periodFinish = _periodFinish;
400 		defaultReferAddr =  _defaultReferAddr;
401 		projectAddress = _projectAddress;
402 	
403 		User memory user = User({
404             id: 1,
405             referrer: address(0),
406             referAmount:new uint256[](2),
407 			referReward:0,
408 			referCount:new uint256[](2),
409 			referRewardPerTokenPaid:0		
410         });		
411 		users[defaultReferAddr] = user;	
412 		
413 		regisUser[1] = 	defaultReferAddr;
414 		initialized = true;	
415     }
416 
417     function poolLength() external view returns (uint256) {
418         return poolInfo.length;
419     }
420 	
421 
422     function isUserExists(address user) public view returns (bool) {
423 		return (users[user].id != 0);
424     }
425 	
426 
427 	
428 	function registrationExt(address referrerAddress) external {
429         registration(msg.sender, referrerAddress);
430     }
431 
432     function registration(address userAddress, address referrerAddress) private {
433        //require(msg.value == 0.05 ether, "registration cost 0.05");
434         require(!isUserExists(userAddress), "user exists");
435         require(isUserExists(referrerAddress), "referrer not exists");
436         
437        // uint32 size;
438         //assembly {
439         //    size := extcodesize(userAddress)
440        // }
441 		//require(size == 0, "cannot be a contract");
442 		require(!Address.isContract(userAddress), "cannot be a contract");
443         
444  
445         User memory user = User({
446             id: lastUserId,
447             referrer: referrerAddress,
448 			referAmount:new uint256[](2),
449 			referReward:0,
450 			referCount:new uint256[](2),
451 			referRewardPerTokenPaid:0		
452         });
453 		
454 
455 		
456 		regisUser[lastUserId] = userAddress;
457         
458         users[userAddress] = user;
459 		
460 		users[referrerAddress].referCount[0] = users[referrerAddress].referCount[0].add(1);
461 		
462 		address _refer = users[referrerAddress].referrer;
463 		if(_refer != address(0)){
464 			users[_refer].referCount[1] = users[_refer].referCount[1].add(1);
465 		}
466 		
467         lastUserId++;
468         
469         emit  Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
470     }
471 	
472 
473 
474 
475     // Add a new lp to the pool. Can only be called by the owner.
476     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
477     function addLp(uint256 _allocPoint, IERC20 _lpToken) public onlyOwner {   
478         uint256 lastRewardTime = block.timestamp > starttime ? block.timestamp : starttime;
479         totalAllocPoint = totalAllocPoint.add(_allocPoint);
480         poolInfo.push(PoolInfo({
481             lpToken: _lpToken,
482             allocPoint: _allocPoint,
483             lastRewardTime: lastRewardTime,
484             accPizzaPerShare: 0,
485 			totalPool:0
486         }));		
487     }
488 	
489 	
490 
491 
492     // Update the given pool's Pizza allocation point. Can only be called by the owner.
493     function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {
494 
495         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
496         poolInfo[_pid].allocPoint = _allocPoint;
497     }
498 	
499 	function setTotalAllocPoint(uint256 _totalAllocPoint) public onlyOwner{
500 		totalAllocPoint = _totalAllocPoint;
501 	}
502 	
503 	function setRewardRate(uint256 _rewardRate) public onlyOwner {
504 		rewardRate = _rewardRate;	
505 	} 
506 
507 	
508   
509 
510     // Return reward multiplier over the given _from to _to block.
511     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
512         if (_to <= periodFinish) {
513             return _to.sub(_from).mul(BONUS_MULTIPLIER);
514         } else if (_from >= periodFinish) {
515             return _to.sub(_from);
516         } else {
517             return periodFinish.sub(_from).mul(BONUS_MULTIPLIER).add(
518                 _to.sub(periodFinish)
519             );
520         }
521     }
522 
523 	function getRewardRate() public view returns(uint256){
524 		
525 		if(totalMinted < 6000*1e18){
526 			return rewardRate;
527 		}else if(totalMinted >= 6000*1e18   && totalMinted <= 8000 * 1e18){
528 			return rewardRate.mul(50).div(100);
529 		}else if(totalMinted >8000*1e18 && totalMinted <= 9000 * 1e18){
530 			return   rewardRate.mul(50).div(100);
531 		}else{
532 			return 0;
533 		}
534 	}
535 
536     function pendingPizza(uint256 _pid, address _user) public view returns (uint256) {
537         PoolInfo storage pool = poolInfo[_pid];
538         UserInfo storage user = userInfo[_pid][_user];
539         uint256 accPizzaPerShare = pool.accPizzaPerShare;
540         uint256 lpSupply = pool.totalPool;
541 		uint256 result = user.reward;
542         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
543             uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
544             uint256 pizzaReward = multiplier.mul(getRewardRate()).mul(pool.allocPoint).div(totalAllocPoint);
545             accPizzaPerShare = pool.accPizzaPerShare.add(pizzaReward.mul(1e18).div(lpSupply));
546         }
547 
548 		result = result.add(user.amount.mul((accPizzaPerShare).sub(user.userRewardPerTokenPaid)).div(1e18));
549 	
550         
551 		return result;
552     }
553 	
554 
555 	function pendingAllPizza(address _user) public view returns (uint256) {
556 		uint256  result = 0;
557 		for(uint256 i = 0;i< poolInfo.length;i++ ){
558 			result = result.add(pendingPizza(i,_user));
559 		}
560         return result;
561     }
562 	
563 
564 	function allPizzaAmount(address _user) public view returns (uint256) {
565 		uint256 result = 0;
566 		for(uint256 i = 0;i< poolInfo.length;i++ ){
567 			UserInfo storage user = userInfo[i][_user];
568 			result = result.add(pendingPizza(i,_user).add(user.rewardPaid));
569 		}
570         return result;
571     }
572 	
573 
574 	function getAllDeposit(address _user) public view returns (uint256) {
575 		uint256 result = 0;
576 		for(uint256 i = 0;i< poolInfo.length;i++ ){
577 			UserInfo storage user = userInfo[i][_user];		
578 			result = result.add(user.amount);
579 		}
580         return result;
581     }
582 
583 
584 
585 	function getReferCount(address userAddress) public view returns(uint256[] memory){
586 	
587 		if(isUserExists(userAddress)){
588 			return	users[userAddress].referCount;
589 		}
590 		return new uint256[](2);
591 	}
592 	
593 
594 
595 	function getReferAmount(address _user,uint256 _index) public view returns(uint256){
596 		if(isUserExists(_user)){
597 			return	users[_user].referAmount[_index];
598 		}
599 		return 0;
600 	}
601 	
602     // Update reward variables of the given pool to be up-to-date.
603     function updatePool(uint256 _pid,address _user) internal {
604         PoolInfo storage pool = poolInfo[_pid];
605         if (block.timestamp <= pool.lastRewardTime) {
606             return;
607         }
608         uint256 lpSupply = pool.totalPool;
609         if (lpSupply == 0) {
610             pool.lastRewardTime = block.timestamp;
611             return;
612         }
613 		UserInfo storage user = userInfo[_pid][_user];
614 		
615         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
616         uint256 pizzaReward = multiplier.mul(getRewardRate()).mul(pool.allocPoint).div(totalAllocPoint);
617         totalMinted = totalMinted.add(pizzaReward);
618 
619 
620 		//pizza.mint(address(this), pizzaReward);
621         pool.accPizzaPerShare = pool.accPizzaPerShare.add(pizzaReward.mul(1e18).div(lpSupply));
622 		
623 		user.reward = user.amount.mul((pool.accPizzaPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
624 		
625 		
626 		user.userRewardPerTokenPaid = pool.accPizzaPerShare;
627         pool.lastRewardTime = block.timestamp;
628     }
629 
630 
631     // Deposit LP tokens to MasterChef for pizza allocation.
632     function deposit(uint256 _pid, uint256 _amount) public checkStart {
633 
634 		require(isUserExists(msg.sender), "user don't exists");		
635         PoolInfo storage pool = poolInfo[_pid];
636         UserInfo storage user = userInfo[_pid][msg.sender];
637         updatePool(_pid,msg.sender);	
638 		
639         if(_amount > 0) {
640             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
641             user.amount = user.amount.add(_amount);
642 			user.pid = _pid;
643 			pool.totalPool = pool.totalPool.add(_amount);   		
644 	
645 			address _referrer = users[msg.sender].referrer;
646 			for(uint256 i = 0;i<2;i++){				
647 				if(_referrer!= address(0) && isUserExists(_referrer)){
648 					users[_referrer].referAmount[i] = _amount.add(users[_referrer].referAmount[i]);					
649 					_referrer = users[_referrer].referrer;
650 				}else break;
651 			}				
652         }
653         emit Deposit(msg.sender, _pid, _amount);
654     }
655 	
656 
657     function getReward(uint256 _pid) public  {
658 
659 		PoolInfo storage pool = poolInfo[_pid];
660         UserInfo storage user = userInfo[_pid][msg.sender];
661         uint256 accPizzaPerShare = pool.accPizzaPerShare;
662         uint256 lpSupply = pool.totalPool;
663         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
664             uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
665             uint256 pizzaReward = multiplier.mul(getRewardRate()).mul(pool.allocPoint).div(totalAllocPoint);
666             accPizzaPerShare = pool.accPizzaPerShare.add(pizzaReward.mul(1e18).div(lpSupply));
667         }
668         uint256 reward = user.amount.mul((accPizzaPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
669 	
670         if (reward > 0) {
671 			safePizzaTransfer(msg.sender, reward);
672 			user.rewardPaid = user.rewardPaid.add(reward);
673 			user.reward = 0;
674             emit RewardPaid(msg.sender, reward);
675         }		
676 		user.userRewardPerTokenPaid = accPizzaPerShare;
677     }
678 	
679 
680 
681     // Withdraw LP tokens from MasterChef.
682     function withdraw(uint256 _pid, uint256 _amount) public{		
683 		UserInfo storage user = userInfo[_pid][msg.sender];
684 		
685 		
686         PoolInfo storage pool = poolInfo[_pid];
687         
688         require(user.amount >= _amount, "withdraw: not good");
689         updatePool(_pid,msg.sender);
690                
691 
692 		safePizzaTransfer(msg.sender, user.reward);
693 		
694 		safePizzaTransfer(projectAddress, user.reward.mul(10).div(100));
695 		
696 		user.rewardPaid = user.rewardPaid.add(user.reward);
697 		emit RewardPaid(msg.sender, user.rewardPaid);
698         if(_amount > 0) {
699             user.amount = user.amount.sub(_amount);
700             pool.lpToken.safeTransfer(address(msg.sender), _amount);			
701 			pool.totalPool = pool.totalPool.sub(_amount);   	
702 			address _referrer = users[msg.sender].referrer;
703 			for(uint256 i = 0;i<2;i++){
704 				if(_referrer!= address(0) && isUserExists(_referrer)){
705 					users[_referrer].referAmount[i] = users[_referrer].referAmount[i].sub(_amount);	
706 					users[_referrer].referReward = 	users[_referrer].referReward.add(user.reward.mul(10).div(100).div(i+1));				
707 					safePizzaTransfer(_referrer, user.reward.mul(10).div(100).div(i+1));
708 					_referrer = users[_referrer].referrer;
709 				}else break;
710 			}	
711         }
712 		user.reward = 0;
713         emit Withdraw(msg.sender, _pid, _amount);
714     }
715 
716     // Withdraw without caring about rewards. EMERGENCY ONLY.
717    // function emergencyWithdraw(uint256 _pid) public {
718    //     PoolInfo storage pool = poolInfo[_pid];
719     //    UserInfo storage user = userInfo[_pid][msg.sender];
720    //     pool.lpToken.safeTransfer(address(msg.sender), user.amount);
721    //     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
722   //      user.amount = 0;
723    // }
724 
725     // Safe pizza transfer function, just in case if rounding error causes pool to not have enough pizzas.
726     function safePizzaTransfer(address _to, uint256 _amount) internal {
727         uint256 pizzaBal = pizza.balanceOf(address(this));
728         if (_amount > pizzaBal) {
729             pizza.transfer(_to, pizzaBal);
730         } else {
731             pizza.transfer(_to, _amount);
732         }
733     }   
734 
735 	
736 	modifier checkStart(){
737        require(block.timestamp  > starttime,"not start");
738        _;
739     }
740 
741 
742 }