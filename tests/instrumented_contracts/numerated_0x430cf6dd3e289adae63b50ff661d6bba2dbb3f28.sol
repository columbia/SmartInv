1 pragma solidity 0.6.12;
2 
3 // SPDX-License-Identifier: GPL-3.0-only
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18  library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 interface IStafiStorage {
162 
163     // Getters
164     function getAddress(bytes32 _key) external view returns (address);
165     function getUint(bytes32 _key) external view returns (uint);
166     function getString(bytes32 _key) external view returns (string memory);
167     function getBytes(bytes32 _key) external view returns (bytes memory);
168     function getBool(bytes32 _key) external view returns (bool);
169     function getInt(bytes32 _key) external view returns (int);
170     function getBytes32(bytes32 _key) external view returns (bytes32);
171 
172     // Setters
173     function setAddress(bytes32 _key, address _value) external;
174     function setUint(bytes32 _key, uint _value) external;
175     function setString(bytes32 _key, string calldata _value) external;
176     function setBytes(bytes32 _key, bytes calldata _value) external;
177     function setBool(bytes32 _key, bool _value) external;
178     function setInt(bytes32 _key, int _value) external;
179     function setBytes32(bytes32 _key, bytes32 _value) external;
180 
181     // Deleters
182     function deleteAddress(bytes32 _key) external;
183     function deleteUint(bytes32 _key) external;
184     function deleteString(bytes32 _key) external;
185     function deleteBytes(bytes32 _key) external;
186     function deleteBool(bytes32 _key) external;
187     function deleteInt(bytes32 _key) external;
188     function deleteBytes32(bytes32 _key) external;
189 
190 }
191 
192 
193 abstract contract StafiBase {
194 
195     // Version of the contract
196     uint8 public version;
197 
198     // The main storage contract where primary persistant storage is maintained
199     IStafiStorage stafiStorage = IStafiStorage(0);
200 
201 
202     /**
203     * @dev Throws if called by any sender that doesn't match a network contract
204     */
205     modifier onlyLatestNetworkContract() {
206         require(getBool(keccak256(abi.encodePacked("contract.exists", msg.sender))), "Invalid or outdated network contract");
207         _;
208     }
209 
210 
211     /**
212     * @dev Throws if called by any sender that doesn't match one of the supplied contract or is the latest version of that contract
213     */
214     modifier onlyLatestContract(string memory _contractName, address _contractAddress) {
215         require(_contractAddress == getAddress(keccak256(abi.encodePacked("contract.address", _contractName))), "Invalid or outdated contract");
216         _;
217     }
218 
219 
220     /**
221     * @dev Throws if called by any sender that isn't a trusted node
222     */
223     modifier onlyTrustedNode(address _nodeAddress) {
224         require(getBool(keccak256(abi.encodePacked("node.trusted", _nodeAddress))), "Invalid trusted node");
225         _;
226     }
227 
228 
229     /**
230     * @dev Throws if called by any sender that isn't a registered staking pool
231     */
232     modifier onlyRegisteredStakingPool(address _stakingPoolAddress) {
233         require(getBool(keccak256(abi.encodePacked("stakingpool.exists", _stakingPoolAddress))), "Invalid staking pool");
234         _;
235     }
236 
237 
238     /**
239     * @dev Throws if called by any account other than the owner.
240     */
241     modifier onlyOwner() {
242         require(roleHas("owner", msg.sender), "Account is not the owner");
243         _;
244     }
245 
246 
247     /**
248     * @dev Modifier to scope access to admins
249     */
250     modifier onlyAdmin() {
251         require(roleHas("admin", msg.sender), "Account is not an admin");
252         _;
253     }
254 
255 
256     /**
257     * @dev Modifier to scope access to admins
258     */
259     modifier onlySuperUser() {
260         require(roleHas("owner", msg.sender) || roleHas("admin", msg.sender), "Account is not a super user");
261         _;
262     }
263 
264 
265     /**
266     * @dev Reverts if the address doesn't have this role
267     */
268     modifier onlyRole(string memory _role) {
269         require(roleHas(_role, msg.sender), "Account does not match the specified role");
270         _;
271     }
272 
273 
274     /// @dev Set the main Storage address
275     constructor(address _stafiStorageAddress) public {
276         // Update the contract address
277         stafiStorage = IStafiStorage(_stafiStorageAddress);
278     }
279 
280 
281     /// @dev Get the address of a network contract by name
282     function getContractAddress(string memory _contractName) internal view returns (address) {
283         // Get the current contract address
284         address contractAddress = getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
285         // Check it
286         require(contractAddress != address(0x0), "Contract not found");
287         // Return
288         return contractAddress;
289     }
290 
291 
292     /// @dev Get the name of a network contract by address
293     function getContractName(address _contractAddress) internal view returns (string memory) {
294         // Get the contract name
295         string memory contractName = getString(keccak256(abi.encodePacked("contract.name", _contractAddress)));
296         // Check it
297         require(keccak256(abi.encodePacked(contractName)) != keccak256(abi.encodePacked("")), "Contract not found");
298         // Return
299         return contractName;
300     }
301 
302 
303     /// @dev Storage get methods
304     function getAddress(bytes32 _key) internal view returns (address) { return stafiStorage.getAddress(_key); }
305     function getUint(bytes32 _key) internal view returns (uint256) { return stafiStorage.getUint(_key); }
306     function getString(bytes32 _key) internal view returns (string memory) { return stafiStorage.getString(_key); }
307     function getBytes(bytes32 _key) internal view returns (bytes memory) { return stafiStorage.getBytes(_key); }
308     function getBool(bytes32 _key) internal view returns (bool) { return stafiStorage.getBool(_key); }
309     function getInt(bytes32 _key) internal view returns (int256) { return stafiStorage.getInt(_key); }
310     function getBytes32(bytes32 _key) internal view returns (bytes32) { return stafiStorage.getBytes32(_key); }
311     function getAddressS(string memory _key) internal view returns (address) { return stafiStorage.getAddress(keccak256(abi.encodePacked(_key))); }
312     function getUintS(string memory _key) internal view returns (uint256) { return stafiStorage.getUint(keccak256(abi.encodePacked(_key))); }
313     function getStringS(string memory _key) internal view returns (string memory) { return stafiStorage.getString(keccak256(abi.encodePacked(_key))); }
314     function getBytesS(string memory _key) internal view returns (bytes memory) { return stafiStorage.getBytes(keccak256(abi.encodePacked(_key))); }
315     function getBoolS(string memory _key) internal view returns (bool) { return stafiStorage.getBool(keccak256(abi.encodePacked(_key))); }
316     function getIntS(string memory _key) internal view returns (int256) { return stafiStorage.getInt(keccak256(abi.encodePacked(_key))); }
317     function getBytes32S(string memory _key) internal view returns (bytes32) { return stafiStorage.getBytes32(keccak256(abi.encodePacked(_key))); }
318 
319     /// @dev Storage set methods
320     function setAddress(bytes32 _key, address _value) internal { stafiStorage.setAddress(_key, _value); }
321     function setUint(bytes32 _key, uint256 _value) internal { stafiStorage.setUint(_key, _value); }
322     function setString(bytes32 _key, string memory _value) internal { stafiStorage.setString(_key, _value); }
323     function setBytes(bytes32 _key, bytes memory _value) internal { stafiStorage.setBytes(_key, _value); }
324     function setBool(bytes32 _key, bool _value) internal { stafiStorage.setBool(_key, _value); }
325     function setInt(bytes32 _key, int256 _value) internal { stafiStorage.setInt(_key, _value); }
326     function setBytes32(bytes32 _key, bytes32 _value) internal { stafiStorage.setBytes32(_key, _value); }
327     function setAddressS(string memory _key, address _value) internal { stafiStorage.setAddress(keccak256(abi.encodePacked(_key)), _value); }
328     function setUintS(string memory _key, uint256 _value) internal { stafiStorage.setUint(keccak256(abi.encodePacked(_key)), _value); }
329     function setStringS(string memory _key, string memory _value) internal { stafiStorage.setString(keccak256(abi.encodePacked(_key)), _value); }
330     function setBytesS(string memory _key, bytes memory _value) internal { stafiStorage.setBytes(keccak256(abi.encodePacked(_key)), _value); }
331     function setBoolS(string memory _key, bool _value) internal { stafiStorage.setBool(keccak256(abi.encodePacked(_key)), _value); }
332     function setIntS(string memory _key, int256 _value) internal { stafiStorage.setInt(keccak256(abi.encodePacked(_key)), _value); }
333     function setBytes32S(string memory _key, bytes32 _value) internal { stafiStorage.setBytes32(keccak256(abi.encodePacked(_key)), _value); }
334 
335     /// @dev Storage delete methods
336     function deleteAddress(bytes32 _key) internal { stafiStorage.deleteAddress(_key); }
337     function deleteUint(bytes32 _key) internal { stafiStorage.deleteUint(_key); }
338     function deleteString(bytes32 _key) internal { stafiStorage.deleteString(_key); }
339     function deleteBytes(bytes32 _key) internal { stafiStorage.deleteBytes(_key); }
340     function deleteBool(bytes32 _key) internal { stafiStorage.deleteBool(_key); }
341     function deleteInt(bytes32 _key) internal { stafiStorage.deleteInt(_key); }
342     function deleteBytes32(bytes32 _key) internal { stafiStorage.deleteBytes32(_key); }
343     function deleteAddressS(string memory _key) internal { stafiStorage.deleteAddress(keccak256(abi.encodePacked(_key))); }
344     function deleteUintS(string memory _key) internal { stafiStorage.deleteUint(keccak256(abi.encodePacked(_key))); }
345     function deleteStringS(string memory _key) internal { stafiStorage.deleteString(keccak256(abi.encodePacked(_key))); }
346     function deleteBytesS(string memory _key) internal { stafiStorage.deleteBytes(keccak256(abi.encodePacked(_key))); }
347     function deleteBoolS(string memory _key) internal { stafiStorage.deleteBool(keccak256(abi.encodePacked(_key))); }
348     function deleteIntS(string memory _key) internal { stafiStorage.deleteInt(keccak256(abi.encodePacked(_key))); }
349     function deleteBytes32S(string memory _key) internal { stafiStorage.deleteBytes32(keccak256(abi.encodePacked(_key))); }
350 
351 
352     /**
353     * @dev Check if an address has this role
354     */
355     function roleHas(string memory _role, address _address) internal view returns (bool) {
356         return getBool(keccak256(abi.encodePacked("access.role", _role, _address)));
357     }
358 
359 }
360 
361 // Represents the type of deposits
362 enum DepositType {
363     None,    // Marks an invalid deposit type
364     FOUR,    // Require 4 ETH from the node operator to be matched with 28 ETH from user deposits
365     EIGHT,   // Require 8 ETH from the node operator to be matched with 24 ETH from user deposits
366     TWELVE,  // Require 12 ETH from the node operator to be matched with 20 ETH from user deposits
367     SIXTEEN,  // Require 16 ETH from the node operator to be matched with 16 ETH from user deposits
368     Empty    // Require 0 ETH from the node operator to be matched with 32 ETH from user deposits (trusted nodes only)
369 }
370 
371 // Represents a stakingpool's status within the network
372 enum StakingPoolStatus {
373     Initialized,    // The stakingpool has been initialized and is awaiting a deposit of user ETH
374     Prelaunch,      // The stakingpool has enough ETH to begin staking and is awaiting launch by the node
375     Staking,        // The stakingpool is currently staking
376     Withdrawn,   // The stakingpool has been withdrawn from by the node
377     Dissolved       // The stakingpool has been dissolved and its user deposited ETH has been returned to the deposit pool
378 }
379 
380 interface IStafiStakingPool {
381     function getStatus() external view returns (StakingPoolStatus);
382     function getStatusBlock() external view returns (uint256);
383     function getStatusTime() external view returns (uint256);
384     function getDepositType() external view returns (DepositType);
385     function getNodeAddress() external view returns (address);
386     function getNodeFee() external view returns (uint256);
387     function getNodeDepositBalance() external view returns (uint256);
388     function getNodeRefundBalance() external view returns (uint256);
389     function getNodeDepositAssigned() external view returns (bool);
390     function getNodeCommonlyRefunded() external view returns (bool);
391     function getNodeTrustedRefunded() external view returns (bool);
392     function getUserDepositBalance() external view returns (uint256);
393     function getUserDepositAssigned() external view returns (bool);
394     function getUserDepositAssignedTime() external view returns (uint256);
395     function getPlatformDepositBalance() external view returns (uint256);
396     function nodeDeposit() external payable;
397     function userDeposit() external payable;
398     function stake(bytes calldata _validatorPubkey, bytes calldata _validatorSignature, bytes32 _depositDataRoot) external;
399     function refund() external;
400     function dissolve() external;
401     function close() external;
402 }
403 
404 interface IStafiStakingPoolQueue {
405     function getTotalLength() external view returns (uint256);
406     function getLength(DepositType _depositType) external view returns (uint256);
407     function getTotalCapacity() external view returns (uint256);
408     function getEffectiveCapacity() external view returns (uint256);
409     function getNextCapacity() external view returns (uint256);
410     function enqueueStakingPool(DepositType _depositType, address _stakingPool) external;
411     function dequeueStakingPool() external returns (address);
412     function removeStakingPool() external;
413 }
414 
415 interface IRETHToken {
416     function getEthValue(uint256 _rethAmount) external view returns (uint256);
417     function getRethValue(uint256 _ethAmount) external view returns (uint256);
418     function getExchangeRate() external view returns (uint256);
419     function getTotalCollateral() external view returns (uint256);
420     function getCollateralRate() external view returns (uint256);
421     function depositRewards() external payable;
422     function depositExcess() external payable;
423     function userMint(uint256 _ethAmount, address _to) external;
424     function userBurn(uint256 _rethAmount) external;
425 }
426 
427 
428 interface IStafiEther {
429     function balanceOf(address _contractAddress) external view returns (uint256);
430     function depositEther() external payable;
431     function withdrawEther(uint256 _amount) external;
432 }
433 
434 interface IStafiEtherWithdrawer {
435     function receiveEtherWithdrawal() external payable;
436 }
437 
438 interface IStafiUserDeposit {
439     function getBalance() external view returns (uint256);
440     function getExcessBalance() external view returns (uint256);
441     function deposit() external payable;
442     function recycleDissolvedDeposit() external payable;
443     function recycleWithdrawnDeposit() external payable;
444     function assignDeposits() external;
445     function withdrawExcessBalance(uint256 _amount) external;
446 }
447 
448 
449 // Accepts user deposits and mints rETH; handles assignment of deposited ETH to pools
450 contract StafiUserDeposit is StafiBase, IStafiUserDeposit, IStafiEtherWithdrawer {
451 
452     // Libs
453     using SafeMath for uint256;
454 
455     // Events
456     event DepositReceived(address indexed from, uint256 amount, uint256 time);
457     event DepositRecycled(address indexed from, uint256 amount, uint256 time);
458     event DepositAssigned(address indexed stakingPool, uint256 amount, uint256 time);
459     event ExcessWithdrawn(address indexed to, uint256 amount, uint256 time);
460 
461     // Construct
462     constructor(address _stafiStorageAddress) StafiBase(_stafiStorageAddress) public {
463         version = 1;
464         // Initialize settings on deployment
465         if (!getBoolS("settings.user.deposit.init")) {
466             // Apply settings
467             setDepositEnabled(true);
468             setAssignDepositsEnabled(true);
469             setMinimumDeposit(0.01 ether);
470             // setMaximumDepositPoolSize(100000 ether);
471             setMaximumDepositAssignments(2);
472             // Settings initialized
473             setBoolS("settings.user.deposit.init", true);
474         }
475     }
476 
477     // Current deposit pool balance
478     function getBalance() override public view returns (uint256) {
479         IStafiEther stafiEther = IStafiEther(getContractAddress("stafiEther"));
480         return stafiEther.balanceOf(address(this));
481     }
482 
483     // Excess deposit pool balance (in excess of stakingPool queue capacity)
484     function getExcessBalance() override public view returns (uint256) {
485         // Get stakingPool queue capacity
486         IStafiStakingPoolQueue stafiStakingPoolQueue = IStafiStakingPoolQueue(getContractAddress("stafiStakingPoolQueue"));
487         uint256 stakingPoolCapacity = stafiStakingPoolQueue.getEffectiveCapacity();
488         // Calculate and return
489         uint256 balance = getBalance();
490         if (stakingPoolCapacity >= balance) { return 0; }
491         else { return balance.sub(stakingPoolCapacity); }
492     }
493 
494     // Receive a ether withdrawal
495     // Only accepts calls from the StafiEther contract
496     function receiveEtherWithdrawal() override external payable onlyLatestContract("stafiUserDeposit", address(this)) onlyLatestContract("stafiEther", msg.sender) {}
497 
498     // Accept a deposit from a user
499     function deposit() override external payable onlyLatestContract("stafiUserDeposit", address(this)) {
500         // Check deposit settings
501         require(getDepositEnabled(), "Deposits into Stafi are currently disabled");
502         require(msg.value >= getMinimumDeposit(), "The deposited amount is less than the minimum deposit size");
503         // require(getBalance().add(msg.value) <= getMaximumDepositPoolSize(), "The deposit pool size after depositing exceeds the maximum size");
504         // Load contracts
505         IRETHToken rETHToken = IRETHToken(getContractAddress("rETHToken"));
506         // Mint rETH to user account
507         rETHToken.userMint(msg.value, msg.sender);
508         // Emit deposit received event
509         emit DepositReceived(msg.sender, msg.value, now);
510         // Process deposit
511         processDeposit();
512     }
513 
514     // Recycle a deposit from a dissolved stakingPool
515     // Only accepts calls from registered stakingPools
516     function recycleDissolvedDeposit() override external payable onlyLatestContract("stafiUserDeposit", address(this)) onlyRegisteredStakingPool(msg.sender) {
517         // Emit deposit recycled event
518         emit DepositRecycled(msg.sender, msg.value, now);
519         // Process deposit
520         processDeposit();
521     }
522 
523     // Recycle a deposit from a withdrawn stakingPool
524     function recycleWithdrawnDeposit() override external payable onlyLatestContract("stafiUserDeposit", address(this)) onlyLatestContract("stafiNetworkWithdrawal", msg.sender) {
525         // Emit deposit recycled event
526         emit DepositRecycled(msg.sender, msg.value, now);
527         // Process deposit
528         processDeposit();
529     }
530 
531     // Process a deposit
532     function processDeposit() private {
533         // Load contracts
534         IStafiEther stafiEther = IStafiEther(getContractAddress("stafiEther"));
535         // Transfer ETH to stafiEther
536         stafiEther.depositEther{value: msg.value}();
537         // Assign deposits if enabled
538         assignDeposits();
539     }
540 
541     // Assign deposits to available stakingPools
542     function assignDeposits() override public onlyLatestContract("stafiUserDeposit", address(this)) {
543         // Check deposit settings
544         require(getAssignDepositsEnabled(), "Deposit assignments are currently disabled");
545         // Load contracts
546         IStafiStakingPoolQueue stafiStakingPoolQueue = IStafiStakingPoolQueue(getContractAddress("stafiStakingPoolQueue"));
547         IStafiEther stafiEther = IStafiEther(getContractAddress("stafiEther"));
548         // Assign deposits
549         uint256 maximumDepositAssignments = getMaximumDepositAssignments();
550         for (uint256 i = 0; i < maximumDepositAssignments; ++i) {
551             // Get & check next available staking pool capacity
552             uint256 stakingPoolCapacity = stafiStakingPoolQueue.getNextCapacity();
553             if (stakingPoolCapacity == 0 || getBalance() < stakingPoolCapacity) { break; }
554             // Dequeue next available staking pool
555             address stakingPoolAddress = stafiStakingPoolQueue.dequeueStakingPool();
556             IStafiStakingPool stakingPool = IStafiStakingPool(stakingPoolAddress);
557             // Withdraw ETH from stafiEther
558             stafiEther.withdrawEther(stakingPoolCapacity);
559             // Assign deposit to staking pool
560             stakingPool.userDeposit{value: stakingPoolCapacity}();
561             // Emit deposit assigned event
562             emit DepositAssigned(stakingPoolAddress, stakingPoolCapacity, now);
563         }
564     }
565 
566     // Withdraw excess deposit pool balance for rETH collateral
567     function withdrawExcessBalance(uint256 _amount) override external onlyLatestContract("stafiUserDeposit", address(this)) onlyLatestContract("rETHToken", msg.sender) {
568         // Load contracts
569         IRETHToken rETHToken = IRETHToken(getContractAddress("rETHToken"));
570         IStafiEther stafiEther = IStafiEther(getContractAddress("stafiEther"));
571         // Check amount
572         require(_amount <= getExcessBalance(), "Insufficient excess balance for withdrawal");
573         // Withdraw ETH from vault
574         stafiEther.withdrawEther(_amount);
575         // Transfer to rETH contract
576         rETHToken.depositExcess{value: _amount}();
577         // Emit excess withdrawn event
578         emit ExcessWithdrawn(msg.sender, _amount, now);
579     }
580 
581     // Deposits currently enabled
582     function getDepositEnabled() public view returns (bool) {
583         return getBoolS("settings.deposit.enabled");
584     }
585     function setDepositEnabled(bool _value) public onlySuperUser {
586         setBoolS("settings.deposit.enabled", _value);
587     }
588 
589     // Deposit assignments currently enabled
590     function getAssignDepositsEnabled() public view returns (bool) {
591         return getBoolS("settings.deposit.assign.enabled");
592     }
593     function setAssignDepositsEnabled(bool _value) public onlySuperUser {
594         setBoolS("settings.deposit.assign.enabled", _value);
595     }
596 
597     // Minimum deposit size
598     function getMinimumDeposit() public view returns (uint256) {
599         return getUintS("settings.deposit.minimum");
600     }
601     function setMinimumDeposit(uint256 _value) public onlySuperUser {
602         setUintS("settings.deposit.minimum", _value);
603     }
604 
605     // The maximum size of the deposit pool
606     // function getMaximumDepositPoolSize() public view returns (uint256) {
607     //     return getUintS("settings.deposit.pool.maximum");
608     // }
609     // function setMaximumDepositPoolSize(uint256 _value) public onlySuperUser {
610     //     setUintS("settings.deposit.pool.maximum", _value);
611     // }
612 
613     // The maximum number of deposit assignments to perform at once
614     function getMaximumDepositAssignments() public view returns (uint256) {
615         return getUintS("settings.deposit.assign.maximum");
616     }
617     function setMaximumDepositAssignments(uint256 _value) public onlySuperUser {
618         setUintS("settings.deposit.assign.maximum", _value);
619     }
620 
621 }