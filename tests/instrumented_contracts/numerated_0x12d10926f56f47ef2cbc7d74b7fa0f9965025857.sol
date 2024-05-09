1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/IOwned.sol
4 
5 /*
6     Owned Contract Interface
7 */
8 contract IOwned {
9     function transferOwnership(address _newOwner) public;
10     function acceptOwnership() public;
11     function transferOwnershipNow(address newContractOwner) public;
12 }
13 
14 // File: contracts/utility/Owned.sol
15 
16 /*
17     This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()
18     
19     The original unmodified version can be found here:
20     https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846
21     
22     Provides support and utilities for contract ownership
23 */
24 contract Owned is IOwned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
29 
30     /**
31         @dev constructor
32     */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     // allows execution by the owner only
38     modifier ownerOnly {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44         @dev allows transferring the contract ownership
45         the new owner still needs to accept the transfer
46         can only be called by the contract owner
47         @param _newOwner    new contract owner
48     */
49     function transferOwnership(address _newOwner) public ownerOnly {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     /**
55         @dev used by a new owner to accept an ownership transfer
56     */
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnerUpdate(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 
64     /**
65         @dev transfers the contract ownership without needing the new owner to accept ownership
66         @param newContractOwner    new contract owner
67     */
68     function transferOwnershipNow(address newContractOwner) ownerOnly public {
69         require(newContractOwner != owner);
70         emit OwnerUpdate(owner, newContractOwner);
71         owner = newContractOwner;
72     }
73 
74 }
75 
76 // File: contracts/interfaces/ILogger.sol
77 
78 /*
79     Logger Contract Interface
80 */
81 
82 contract ILogger {
83     function addNewLoggerPermission(address addressToPermission) public;
84     function emitTaskCreated(uint uuid, uint amount) public;
85     function emitProjectCreated(uint uuid, uint amount, address rewardAddress) public;
86     function emitNewSmartToken(address token) public;
87     function emitIssuance(uint256 amount) public;
88     function emitDestruction(uint256 amount) public;
89     function emitTransfer(address from, address to, uint256 value) public;
90     function emitApproval(address owner, address spender, uint256 value) public;
91     function emitGenericLog(string messageType, string message) public;
92 }
93 
94 // File: contracts/Logger.sol
95 
96 /*
97 
98 Centralized logger allows backend to easily watch all events on all communities without needing to watch each community individually
99 
100 */
101 contract Logger is Owned, ILogger  {
102 
103     // Community
104     event TaskCreated(address msgSender, uint _uuid, uint _amount);
105     event ProjectCreated(address msgSender, uint _uuid, uint _amount, address _address);
106 
107     // SmartToken
108     // triggered when a smart token is deployed - the _token address is defined for forward compatibility
109     //  in case we want to trigger the event from a factory
110     event NewSmartToken(address msgSender, address _token);
111     // triggered when the total supply is increased
112     event Issuance(address msgSender, uint256 _amount);
113     // triggered when the total supply is decreased
114     event Destruction(address msgSender, uint256 _amount);
115     // erc20
116     event Transfer(address msgSender, address indexed _from, address indexed _to, uint256 _value);
117     event Approval(address msgSender, address indexed _owner, address indexed _spender, uint256 _value);
118 
119     // Logger
120     event NewCommunityAddress(address msgSender, address _newAddress);
121 
122     event GenericLog(address msgSender, string messageType, string message);
123     mapping (address => bool) public permissionedAddresses;
124 
125     modifier hasLoggerPermissions(address _address) {
126         require(permissionedAddresses[_address] == true);
127         _;
128     }
129 
130     function addNewLoggerPermission(address addressToPermission) ownerOnly public {
131         permissionedAddresses[addressToPermission] = true;
132     }
133 
134     function emitTaskCreated(uint uuid, uint amount) public hasLoggerPermissions(msg.sender) {
135         emit TaskCreated(msg.sender, uuid, amount);
136     }
137 
138     function emitProjectCreated(uint uuid, uint amount, address rewardAddress) public hasLoggerPermissions(msg.sender) {
139         emit ProjectCreated(msg.sender, uuid, amount, rewardAddress);
140     }
141 
142     function emitNewSmartToken(address token) public hasLoggerPermissions(msg.sender) {
143         emit NewSmartToken(msg.sender, token);
144     }
145 
146     function emitIssuance(uint256 amount) public hasLoggerPermissions(msg.sender) {
147         emit Issuance(msg.sender, amount);
148     }
149 
150     function emitDestruction(uint256 amount) public hasLoggerPermissions(msg.sender) {
151         emit Destruction(msg.sender, amount);
152     }
153 
154     function emitTransfer(address from, address to, uint256 value) public hasLoggerPermissions(msg.sender) {
155         emit Transfer(msg.sender, from, to, value);
156     }
157 
158     function emitApproval(address owner, address spender, uint256 value) public hasLoggerPermissions(msg.sender) {
159         emit Approval(msg.sender, owner, spender, value);
160     }
161 
162     function emitGenericLog(string messageType, string message) public hasLoggerPermissions(msg.sender) {
163         emit GenericLog(msg.sender, messageType, message);
164     }
165 }
166 
167 // File: contracts/interfaces/IERC20.sol
168 
169 /*
170     Smart Token Interface
171 */
172 contract IERC20 {
173     function balanceOf(address tokenOwner) public constant returns (uint balance);
174     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
175     function transfer(address to, uint tokens) public returns (bool success);
176     function approve(address spender, uint tokens) public returns (bool success);
177     function transferFrom(address from, address to, uint tokens) public returns (bool success);
178 
179     event Transfer(address indexed from, address indexed to, uint tokens);
180     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
181 }
182 
183 // File: contracts/interfaces/ICommunityAccount.sol
184 
185 /*
186     Community Account Interface
187 */
188 contract ICommunityAccount is IOwned {
189     function setStakedBalances(uint _amount, address msgSender) public;
190     function setTotalStaked(uint _totalStaked) public;
191     function setTimeStaked(uint _timeStaked, address msgSender) public;
192     function setEscrowedTaskBalances(uint uuid, uint balance) public;
193     function setEscrowedProjectBalances(uint uuid, uint balance) public;
194     function setEscrowedProjectPayees(uint uuid, address payeeAddress) public;
195     function setTotalTaskEscrow(uint balance) public;
196     function setTotalProjectEscrow(uint balance) public;
197 }
198 
199 // File: contracts/CommunityAccount.sol
200 
201 /**
202 @title Tribe Account
203 @notice This contract is used as a community's data store.
204 @notice Advantages:
205 @notice 1) Decouple logic contract from data contract
206 @notice 2) Safely upgrade logic contract without compromising stored data
207 */
208 contract CommunityAccount is Owned, ICommunityAccount {
209 
210     // Staking Variables.  In community token
211     mapping (address => uint256) public stakedBalances;
212     mapping (address => uint256) public timeStaked;
213     uint public totalStaked;
214 
215     // Escrow variables.  In native token
216     uint public totalTaskEscrow;
217     uint public totalProjectEscrow;
218     mapping (uint256 => uint256) public escrowedTaskBalances;
219     mapping (uint256 => uint256) public escrowedProjectBalances;
220     mapping (uint256 => address) public escrowedProjectPayees;
221     
222     /**
223     @notice This function allows the community to transfer tokens out of the contract.
224     @param tokenContractAddress Address of community contract
225     @param destination Destination address of user looking to remove tokens from contract
226     @param amount Amount to transfer out of community
227     */
228     function transferTokensOut(address tokenContractAddress, address destination, uint amount) public ownerOnly returns(bool result) {
229         IERC20 token = IERC20(tokenContractAddress);
230         return token.transfer(destination, amount);
231     }
232 
233     /**
234     @notice This is the community staking method
235     @param _amount Amount to be staked
236     @param msgSender Address of the staker
237     */
238     function setStakedBalances(uint _amount, address msgSender) public ownerOnly {
239         stakedBalances[msgSender] = _amount;
240     }
241 
242     /**
243     @param _totalStaked Set total amount staked in community
244      */
245     function setTotalStaked(uint _totalStaked) public ownerOnly {
246         totalStaked = _totalStaked;
247     }
248 
249     /**
250     @param _timeStaked Time of user staking into community
251     @param msgSender Staker address
252      */
253     function setTimeStaked(uint _timeStaked, address msgSender) public ownerOnly {
254         timeStaked[msgSender] = _timeStaked;
255     }
256 
257     /**
258     @param uuid id of escrowed task
259     @param balance Balance to be set of escrowed task
260      */
261     function setEscrowedTaskBalances(uint uuid, uint balance) public ownerOnly {
262         escrowedTaskBalances[uuid] = balance;
263     }
264 
265     /**
266     @param uuid id of escrowed project
267     @param balance Balance to be set of escrowed project
268      */
269     function setEscrowedProjectBalances(uint uuid, uint balance) public ownerOnly {
270         escrowedProjectBalances[uuid] = balance;
271     }
272 
273     /**
274     @param uuid id of escrowed project
275     @param payeeAddress Address funds will go to once project completed
276      */
277     function setEscrowedProjectPayees(uint uuid, address payeeAddress) public ownerOnly {
278         escrowedProjectPayees[uuid] = payeeAddress;
279     }
280 
281     /**
282     @param balance Balance which to set total task escrow to
283      */
284     function setTotalTaskEscrow(uint balance) public ownerOnly {
285         totalTaskEscrow = balance;
286     }
287 
288     /**
289     @param balance Balance which to set total project to
290      */
291     function setTotalProjectEscrow(uint balance) public ownerOnly {
292         totalProjectEscrow = balance;
293     }
294 }
295 
296 // File: contracts/interfaces/ISmartToken.sol
297 
298 /**
299     @notice Smart Token Interface
300 */
301 contract ISmartToken is IOwned, IERC20 {
302     function disableTransfers(bool _disable) public;
303     function issue(address _to, uint256 _amount) public;
304     function destroy(address _from, uint256 _amount) public;
305 }
306 
307 // File: contracts/interfaces/ICommunity.sol
308 
309 /*
310     Community Interface
311 */
312 contract ICommunity {
313     function transferCurator(address _curator) public;
314     function transferVoteController(address _voteController) public;
315     function setMinimumStakingRequirement(uint _minimumStakingRequirement) public;
316     function setLockupPeriodSeconds(uint _lockupPeriodSeconds) public;
317     function setLogger(address newLoggerAddress) public;
318     function setTokenAddresses(address newNativeTokenAddress, address newCommunityTokenAddress) public;
319     function setCommunityAccount(address newCommunityAccountAddress) public;
320     function setCommunityAccountOwner(address newOwner) public;
321     function getAvailableDevFund() public view returns (uint);
322     function getLockedDevFundAmount() public view returns (uint);
323     function createNewTask(uint uuid, uint amount) public;
324     function cancelTask(uint uuid) public;
325     function rewardTaskCompletion(uint uuid, address user) public;
326     function createNewProject(uint uuid, uint amount, address projectPayee) public;
327     function cancelProject(uint uuid) public;
328     function rewardProjectCompletion(uint uuid) public;
329     function stakeCommunityTokens() public;
330     function unstakeCommunityTokens() public;
331     function isMember(address memberAddress)public view returns (bool);
332 }
333 
334 // File: contracts/utility/SafeMath.sol
335 
336 /**
337  * @title SafeMath
338  * @dev Math operations with safety checks that revert on error
339  * From https://github.com/OpenZeppelin/openzeppelin-solidity/commit/a2e710386933d3002062888b35aae8ac0401a7b3
340  */
341 library SafeMath {
342 
343     /**
344     * @dev Multiplies two numbers, reverts on overflow.
345     */
346     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
347         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
348         // benefit is lost if 'b' is also tested.
349         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
350         if (_a == 0) {
351             return 0;
352         }
353 
354         uint256 c = _a * _b;
355         require(c / _a == _b);
356 
357         return c;
358     }
359 
360     /**
361     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
362     */
363     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
364         require(_b > 0); // Solidity only automatically asserts when dividing by 0
365         uint256 c = _a / _b;
366         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
367 
368         return c;
369     }
370 
371     /**
372     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
373     */
374     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
375         require(_b <= _a);
376         uint256 c = _a - _b;
377 
378         return c;
379     }
380 
381     /**
382     * @dev Adds two numbers, reverts on overflow.
383     */
384     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
385         uint256 c = _a + _b;
386         require(c >= _a);
387 
388         return c;
389     }
390 }
391 
392 // File: contracts/Community.sol
393 
394 /**
395 @notice Main community logic contract.
396 @notice functionality:
397 @notice 1) Stake / Unstake community tokens.  This is how user joins or leaves community.
398 @notice 2) Create Projects and Tasks by escrowing NTV token until curator or voteController determines task complete
399 @notice 3) Log all events to singleton Logger contract
400 @notice 4) Own communityAccount contract which holds all staking- and escrow-related funds and variables
401 @notice --- This abstraction of funds allows for easy upgrade process; launch new community -> transfer ownership of the existing communityAccount
402 @notice --- View test/integration-test-upgrades.js to demonstrate this process
403  */
404 contract Community is ICommunity {
405 
406     address public curator;
407     address public voteController;
408     uint public minimumStakingRequirement;
409     uint public lockupPeriodSeconds;
410     ISmartToken public nativeTokenInstance;
411     ISmartToken public communityTokenInstance;
412     Logger public logger;
413     CommunityAccount public communityAccount;
414 
415     modifier onlyCurator {
416         require(msg.sender == curator);
417         _;
418     }
419 
420     modifier onlyVoteController {
421         require(msg.sender == voteController);
422         _;
423     }
424 
425     modifier sufficientDevFundBalance (uint amount) {
426         require(amount <= getAvailableDevFund());
427         _;
428     }
429 
430     /**
431     @param _minimumStakingRequirement Minimum stake amount to join community
432     @param _lockupPeriodSeconds Required minimum holding time, in seconds, after joining for staker to leave
433     @param _curator Address of community curator
434     @param _communityTokenContractAddress Address of community token contract
435     @param _nativeTokenContractAddress Address of ontract
436     @param _voteController Address of vote controller
437     @param _loggerContractAddress Address of logger contract
438     @param _communityAccountContractAddress Address of community account
439      */
440     constructor(uint _minimumStakingRequirement,
441         uint _lockupPeriodSeconds,
442         address _curator,
443         address _communityTokenContractAddress,
444         address _nativeTokenContractAddress,
445         address _voteController,
446         address _loggerContractAddress,
447         address _communityAccountContractAddress) public {
448         communityAccount = CommunityAccount(_communityAccountContractAddress);
449         curator = _curator;
450         minimumStakingRequirement = _minimumStakingRequirement;
451         lockupPeriodSeconds = _lockupPeriodSeconds;
452         logger = Logger(_loggerContractAddress);
453         voteController = _voteController;
454         nativeTokenInstance = ISmartToken(_nativeTokenContractAddress);
455         communityTokenInstance = ISmartToken(_communityTokenContractAddress);
456     }
457 
458     // TODO add events to each of these
459     /**
460     @notice Sets curator to input curator address
461     @param _curator Address of new community curator
462      */
463     function transferCurator(address _curator) public onlyCurator {
464         curator = _curator;
465         logger.emitGenericLog("transferCurator", "");
466     }
467 
468     /**
469     @notice Sets vote controller to input vote controller address
470     @param _voteController Address of new vote controller
471      */
472     function transferVoteController(address _voteController) public onlyCurator {
473         voteController = _voteController;
474         logger.emitGenericLog("transferVoteController", "");
475     }
476 
477     /**
478     @notice Sets the minimum community staking requirement
479     @param _minimumStakingRequirement Minimum community staking requirement to be set
480      */
481     function setMinimumStakingRequirement(uint _minimumStakingRequirement) public onlyCurator {
482         minimumStakingRequirement = _minimumStakingRequirement;
483         logger.emitGenericLog("setMinimumStakingRequirement", "");
484     }
485 
486     /**
487     @notice Sets lockup period for community staking
488     @param _lockupPeriodSeconds Community staking lockup period, in seconds
489     */
490     function setLockupPeriodSeconds(uint _lockupPeriodSeconds) public onlyCurator {
491         lockupPeriodSeconds = _lockupPeriodSeconds;
492         logger.emitGenericLog("setLockupPeriodSeconds", "");
493     }
494 
495     /**
496     @notice Updates Logger contract address to be used
497     @param newLoggerAddress Address of new Logger contract
498      */
499     function setLogger(address newLoggerAddress) public onlyCurator {
500         logger = Logger(newLoggerAddress);
501         logger.emitGenericLog("setLogger", "");
502     }
503 
504     /**
505     @param newNativeTokenAddress New Native token address
506     @param newCommunityTokenAddress New community token address
507      */
508     function setTokenAddresses(address newNativeTokenAddress, address newCommunityTokenAddress) public onlyCurator {
509         nativeTokenInstance = ISmartToken(newNativeTokenAddress);
510         communityTokenInstance = ISmartToken(newCommunityTokenAddress);
511         logger.emitGenericLog("setTokenAddresses", "");
512     }
513 
514     /**
515     @param newCommunityAccountAddress Address of new community account
516      */
517     function setCommunityAccount(address newCommunityAccountAddress) public onlyCurator {
518         communityAccount = CommunityAccount(newCommunityAccountAddress);
519         logger.emitGenericLog("setCommunityAccount", "");
520     }
521 
522     /**
523     @param newOwner New community account owner address
524      */
525     function setCommunityAccountOwner(address newOwner) public onlyCurator {
526         communityAccount.transferOwnershipNow(newOwner);
527         logger.emitGenericLog("setCommunityAccountOwner", "");
528     }
529 
530     /// @return Amount in the dev fund not locked up by project or task stake
531     function getAvailableDevFund() public view returns (uint) {
532         uint devFundBalance = nativeTokenInstance.balanceOf(address(communityAccount));
533         return SafeMath.sub(devFundBalance, getLockedDevFundAmount());
534     }
535 
536     /// @return Amount locked up in escrow
537     function getLockedDevFundAmount() public view returns (uint) {
538         return SafeMath.add(communityAccount.totalTaskEscrow(), communityAccount.totalProjectEscrow());
539     }
540 
541     /* Task escrow code below (in community tokens) */
542 
543     /// @notice Updates the escrow values for a new task
544     function createNewTask(uint uuid, uint amount) public onlyCurator sufficientDevFundBalance (amount) {
545         communityAccount.setEscrowedTaskBalances(uuid, amount);
546         communityAccount.setTotalTaskEscrow(SafeMath.add(communityAccount.totalTaskEscrow(), amount));
547         logger.emitTaskCreated(uuid, amount);
548         logger.emitGenericLog("createNewTask", "");
549     }
550 
551     /// @notice Subtracts the tasks escrow and sets tasks escrow balance to 0
552     function cancelTask(uint uuid) public onlyCurator {
553         communityAccount.setTotalTaskEscrow(SafeMath.sub(communityAccount.totalTaskEscrow(), communityAccount.escrowedTaskBalances(uuid)));
554         communityAccount.setEscrowedTaskBalances(uuid, 0);
555         logger.emitGenericLog("cancelTask", "");
556     }
557 
558     /// @notice Pays task completer and updates escrow balances
559     function rewardTaskCompletion(uint uuid, address user) public onlyVoteController {
560         communityAccount.transferTokensOut(address(nativeTokenInstance), user, communityAccount.escrowedTaskBalances(uuid));
561         communityAccount.setTotalTaskEscrow(SafeMath.sub(communityAccount.totalTaskEscrow(), communityAccount.escrowedTaskBalances(uuid)));
562         communityAccount.setEscrowedTaskBalances(uuid, 0);
563         logger.emitGenericLog("rewardTaskCompletion", "");
564     }
565 
566     /* Project escrow code below (in community tokens) */
567 
568     /// @notice updates the escrow values along with the project payee for a new project
569     function createNewProject(uint uuid, uint amount, address projectPayee) public onlyCurator sufficientDevFundBalance (amount) {
570         communityAccount.setEscrowedProjectBalances(uuid, amount);
571         communityAccount.setEscrowedProjectPayees(uuid, projectPayee);
572         communityAccount.setTotalProjectEscrow(SafeMath.add(communityAccount.totalProjectEscrow(), amount));
573         logger.emitProjectCreated(uuid, amount, projectPayee);
574         logger.emitGenericLog("createNewProject", "");
575     }
576 
577     /// @notice Subtracts tasks escrow and sets tasks escrow balance to 0
578     function cancelProject(uint uuid) public onlyCurator {
579         communityAccount.setTotalProjectEscrow(SafeMath.sub(communityAccount.totalProjectEscrow(), communityAccount.escrowedProjectBalances(uuid)));
580         communityAccount.setEscrowedProjectBalances(uuid, 0);
581         logger.emitGenericLog("cancelProject", "");
582     }
583 
584     /// @notice Pays out upon project completion
585     /// @notice Updates escrow balances
586     function rewardProjectCompletion(uint uuid) public onlyVoteController {
587         communityAccount.transferTokensOut(
588             address(nativeTokenInstance),
589             communityAccount.escrowedProjectPayees(uuid),
590             communityAccount.escrowedProjectBalances(uuid));
591         communityAccount.setTotalProjectEscrow(SafeMath.sub(communityAccount.totalProjectEscrow(), communityAccount.escrowedProjectBalances(uuid)));
592         communityAccount.setEscrowedProjectBalances(uuid, 0);
593         logger.emitGenericLog("rewardProjectCompletion", "");
594     }
595 
596     /// @notice Stake code (in community tokens)
597     function stakeCommunityTokens() public {
598 
599         require(minimumStakingRequirement >= communityAccount.stakedBalances(msg.sender));
600 
601         uint amount = minimumStakingRequirement - communityAccount.stakedBalances(msg.sender);
602         require(amount > 0);
603         require(communityTokenInstance.transferFrom(msg.sender, address(communityAccount), amount));
604 
605         communityAccount.setStakedBalances(SafeMath.add(communityAccount.stakedBalances(msg.sender), amount), msg.sender);
606         communityAccount.setTotalStaked(SafeMath.add(communityAccount.totalStaked(), amount));
607         communityAccount.setTimeStaked(now, msg.sender);
608         logger.emitGenericLog("stakeCommunityTokens", "");
609     }
610 
611     /// @notice Unstakes user from community and sends funds back to user
612     /// @notice Checks lockup period and balance before unstaking
613     function unstakeCommunityTokens() public {
614         uint amount = communityAccount.stakedBalances(msg.sender);
615 
616         require(now - communityAccount.timeStaked(msg.sender) >= lockupPeriodSeconds);
617 
618         communityAccount.setStakedBalances(0, msg.sender);
619         communityAccount.setTotalStaked(SafeMath.sub(communityAccount.totalStaked(), amount));
620         require(communityAccount.transferTokensOut(address(communityTokenInstance), msg.sender, amount));
621         logger.emitGenericLog("unstakeCommunityTokens", "");
622     }
623 
624     /// @notice Checks that the user is fully staked
625     function isMember(address memberAddress) public view returns (bool) {
626         return (communityAccount.stakedBalances(memberAddress) >= minimumStakingRequirement);
627     }
628 }