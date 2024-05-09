1 pragma solidity =0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 contract Ownable {
16     address public owner;
17     address public newOwner;
18 
19     event OwnershipTransferred(address indexed from, address indexed to);
20 
21     constructor() {
22         owner = msg.sender;
23         emit OwnershipTransferred(address(0), owner);
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner, "Ownable: Caller is not the owner");
28         _;
29     }
30 
31     function transferOwnership(address transferOwner) public onlyOwner {
32         require(transferOwner != newOwner);
33         newOwner = transferOwner;
34     }
35 
36     function acceptOwnership() virtual public {
37         require(msg.sender == newOwner);
38         emit OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40         newOwner = address(0);
41     }
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         return a - b;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         return a / b;
79     }
80 
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         return mod(a, b, "SafeMath: modulo by zero");
83     }
84 
85     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b != 0, errorMessage);
87         return a % b;
88     }
89 }
90 
91 interface INimbusReferralProgram {
92     function userSponsorByAddress(address user) external view returns (uint);
93     function userIdByAddress(address user) external view returns (uint);
94     function userSponsorAddressByAddress(address user) external view returns (address);
95 }
96 
97 interface INimbusStakingPool {
98     function balanceOf(address account) external view returns (uint256);
99 }
100 
101 interface INimbusRouter {
102     function getAmountsOut(uint amountIn, address[] calldata path) external  view returns (uint[] memory amounts);
103 }
104 
105 contract NimbusReferralProgram is INimbusReferralProgram, Ownable {
106     using SafeMath for uint;
107 
108     uint public lastUserId;
109     mapping(address => uint) public override userIdByAddress;
110     mapping(uint => address) public userAddressById;
111 
112     uint[] public levels;
113     uint public maxLevel;
114     uint public maxLevelDepth;
115     uint public minTokenAmountForCheck;
116 
117     mapping(uint => uint) private _userSponsor;
118     mapping(address => mapping(uint => uint)) private _undistributedFees;
119     mapping(uint => uint[]) private _userReferrals;
120     mapping(uint => bool) private _networkBonus;
121     mapping(address => uint) private _recordedBalances;
122     mapping(uint => mapping(uint => uint)) private _legacyBalances;
123     mapping(uint => mapping(uint => bool)) private _legacyBalanceStatus;
124 
125     bytes32 public immutable DOMAIN_SEPARATOR;
126     // keccak256("UpdateUserAddressBySig(uint256 id,address user,uint256 nonce,uint256 deadline)");
127     bytes32 public constant UPDATE_ADDRESS_TYPEHASH = 0x965f73b57f3777233e641e140ef6fc17fb3dd7594d04c94df9e3bc6f8531614b;
128     // keccak256("UpdateUserDataBySig(uint256 id,address user,bytes32 refHash,uint256 nonce,uint256 deadline)");
129     bytes32 public constant UPDATE_DATA_TYPEHASG = 0x48b1ff889c9b587c3e7ddba4a9f57008181c3ed75eabbc6f2fefb3a62e987e95;
130     mapping(address => uint) public nonces;
131 
132     IERC20 public immutable NBU;
133     INimbusRouter public swapRouter;                
134     INimbusStakingPool[] public stakingPools; 
135     address public migrator;
136     address public specialReserveFund;
137     address public swapToken;                       
138     uint public swapTokenAmountForFeeDistributionThreshold;
139 
140     event DistributeFees(address token, uint userId, uint amount);
141     event DistributeFeesForUser(address token, uint recipientId, uint amount);
142     event ClaimEarnedFunds(address token, uint userId, uint unclaimedAmount);
143     event TransferToNimbusSpecialReserveFund(address token, uint fromUserId, uint undistributedAmount);
144     event UpdateLevels(uint[] newLevels);
145     event UpdateSpecialReserveFund(address newSpecialReserveFund);
146     event MigrateUserBySign(address signatory, uint userId, address userAddress, uint nonce);
147 
148     uint private unlocked = 1;
149     modifier lock() {
150         require(unlocked == 1, 'Nimbus: LOCKED');
151         unlocked = 0;
152         _;
153         unlocked = 1;
154     }
155 
156     constructor(address migratorAddress, address nbu)  {
157         migrator = migratorAddress;
158         levels = [40, 20, 13, 10, 10, 7];
159         maxLevel = 6;
160         NBU = IERC20(nbu);
161 
162         minTokenAmountForCheck = 10 * 10 ** 18;
163         maxLevelDepth = 25;
164 
165         uint chainId;
166         assembly {
167             chainId := chainid()
168         }
169         DOMAIN_SEPARATOR = keccak256(
170             abi.encode(
171                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
172                 keccak256(bytes("NimbusReferralProgram")),
173                 keccak256(bytes('1')),
174                 chainId,
175                 address(this)
176             )
177         );
178     }
179 
180     receive() payable external {
181         revert();
182     }
183 
184     modifier onlyMigrator() {
185         require(msg.sender == migrator, "Nimbus Referral: caller is not the migrator");
186         _;
187     }
188 
189     function userSponsorByAddress(address user) external override view returns (uint) {
190         return _userSponsor[userIdByAddress[user]];
191     }
192 
193     function userSponsor(uint user) external view returns (uint) {
194         return _userSponsor[user];
195     }
196 
197     function userSponsorAddressByAddress(address user) external override view returns (address) {
198         uint sponsorId = _userSponsor[userIdByAddress[user]];
199         if (sponsorId < 1000000001) return address(0);
200         else return userAddressById[sponsorId];
201     }
202 
203     function getUserReferrals(uint userId) external view returns (uint[] memory) {
204         return _userReferrals[userId];
205     }
206 
207     function getUserReferrals(address user) external view returns (uint[] memory) {
208         return _userReferrals[userIdByAddress[user]];
209     }
210 
211     function getLegacyBalance(uint id) external view returns (uint NBU_USDT, uint GNBU_USDT) {
212         NBU_USDT = _legacyBalances[id][0];
213         GNBU_USDT = _legacyBalances[id][1];
214     }
215 
216     function getLegacyBalanceProcessStatus(uint id) external view returns (bool NBU_USDT, bool GNBU_USDT) {
217         NBU_USDT = _legacyBalanceStatus[id][0];
218         GNBU_USDT = _legacyBalanceStatus[id][1];
219     }
220 
221     function undistributedFees(address token, uint userId) external view returns (uint) {
222         return _undistributedFees[token][userId];
223     }
224 
225 
226 
227 
228     function registerBySponsorAddress(address sponsorAddress) external returns (uint) { 
229         return registerBySponsorId(userIdByAddress[sponsorAddress]);
230     }
231 
232     function register() public returns (uint) {
233         return registerBySponsorId(1000000001);
234     }
235 
236     function registerBySponsorId(uint sponsorId) public returns (uint) {
237         require(userIdByAddress[msg.sender] == 0, "Nimbus Referral: Already registered");
238         require(_userSponsor[sponsorId] != 0, "Nimbus Referral: No such sponsor");
239         
240         uint id = ++lastUserId; //gas saving
241         userIdByAddress[msg.sender] = id;
242         userAddressById[id] = msg.sender;
243         _userSponsor[id] = sponsorId;
244         _userReferrals[sponsorId].push(id);
245         return id;
246     }
247 
248     function recordFee(address token, address recipient, uint amount) external lock { 
249         uint actualBalance = IERC20(token).balanceOf(address(this));
250         require(actualBalance - amount >= _recordedBalances[token], "Nimbus Referral: Balance check failed");
251         uint uiserId = userIdByAddress[recipient];
252         if (_userSponsor[uiserId] == 0) uiserId = 0;
253         _undistributedFees[token][uiserId] = _undistributedFees[token][uiserId].add(amount);
254         _recordedBalances[token] = actualBalance;
255     }
256 
257     function distributeEarnedFees(address token, uint userId) external {
258         distributeFees(token, userId);
259         uint callerId = userIdByAddress[msg.sender];
260         if (_undistributedFees[token][callerId] > 0) distributeFees(token, callerId);
261     }
262 
263     function distributeEarnedFees(address token, uint[] memory userIds) external {
264         for (uint i; i < userIds.length; i++) {
265             distributeFees(token, userIds[i]);
266         }
267         
268         uint callerId = userIdByAddress[msg.sender];
269         if (_undistributedFees[token][callerId] > 0) distributeFees(token, callerId);
270     }
271 
272     function distributeEarnedFees(address[] memory tokens, uint userId) external {
273         uint callerId = userIdByAddress[msg.sender];
274         for (uint i; i < tokens.length; i++) {
275             distributeFees(tokens[i], userId);
276             if (_undistributedFees[tokens[i]][callerId] > 0) distributeFees(tokens[i], callerId);
277         }
278     }
279     
280     function distributeFees(address token, uint userId) private {
281         require(_undistributedFees[token][userId] > 0, "Undistributed fee is 0");
282         uint amount = _undistributedFees[token][userId];
283         uint level = transferToSponsor(token, userId, amount, 0, 0); 
284 
285         if (level < maxLevel) {
286             uint undistributedPercentage;
287             for (uint ii = level; ii < maxLevel; ii++) {
288                 undistributedPercentage += levels[ii];
289             }
290             uint undistributedAmount = amount * undistributedPercentage / 100;
291             _undistributedFees[token][0] = _undistributedFees[token][0].add(undistributedAmount);
292             emit TransferToNimbusSpecialReserveFund(token, userId, undistributedAmount);
293         }
294 
295         emit DistributeFees(token, userId, amount);
296         _undistributedFees[token][userId] = 0;
297     }
298 
299     function transferToSponsor(address token, uint userId, uint amount, uint level, uint levelGuard) private returns (uint) {
300         if (level >= maxLevel) return maxLevel;
301         if (levelGuard > maxLevelDepth) return level;
302         uint sponsorId = _userSponsor[userId];
303         if (sponsorId < 1000000001) return level;
304         address sponsorAddress = userAddressById[sponsorId];
305         if (isUserBalanceEnough(sponsorAddress)) {
306             uint bonusAmount = amount.mul(levels[level]) / 100;
307             TransferHelper.safeTransfer(token, sponsorAddress, bonusAmount);
308             _recordedBalances[token] = _recordedBalances[token].sub(bonusAmount);
309             emit DistributeFeesForUser(token, sponsorId, bonusAmount);
310             return transferToSponsor(token, sponsorId, amount, ++level, ++levelGuard);
311         } else {
312             return transferToSponsor(token, sponsorId, amount, level, ++levelGuard);
313         }            
314     }
315 
316     function isUserBalanceEnough(address user) public view returns (bool) {
317         if (user == address(0)) return false;
318         uint amount = NBU.balanceOf(user);
319         for (uint i; i < stakingPools.length; i++) {
320             amount = amount.add(stakingPools[i].balanceOf(user));
321         }
322         if (amount < minTokenAmountForCheck) return false;
323         address[] memory path = new address[](2);
324         path[0] = address(NBU);
325         path[1] = swapToken;
326         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
327         return tokenAmount >= swapTokenAmountForFeeDistributionThreshold;
328     }
329 
330     function claimSpecialReserveFundBatch(address[] memory tokens) external {
331         for (uint i; i < tokens.length; i++) {
332             claimSpecialReserveFund(tokens[i]);
333         }
334     }
335 
336     function claimSpecialReserveFund(address token) public {
337         uint amount = _undistributedFees[token][0]; 
338         require(amount > 0, "Nimbus Referral: No unclaimed funds for selected token");
339         TransferHelper.safeTransfer(token, specialReserveFund, amount);
340         _recordedBalances[token] = _recordedBalances[token].sub(amount);
341         _undistributedFees[token][0] = 0;
342     }
343 
344 
345 
346 
347     function migrateUsers(uint[] memory ids, uint[] memory sponsorId, address[] memory userAddress, uint[] memory nbuUsdt) external onlyMigrator {
348         require(lastUserId == 0, "Nimbus Referral: Basic migration is finished"); 
349         require(ids.length == sponsorId.length, "Nimbus Referral: Different array lengths");     
350         for (uint i; i < ids.length; i++) {
351             uint id = ids[i];
352             _userSponsor[id] = sponsorId[i];
353             if (userAddress[i] != address(0)) {
354                 userIdByAddress[userAddress[i]] = id;
355                 userAddressById[id] = userAddress[i];
356             }
357             if (nbuUsdt[i] > 0) _legacyBalances[id][0] = nbuUsdt[i];
358         }
359     } 
360 
361     function updateUserLegacyBalances(uint currencyId, uint[] memory ids, uint[] memory balances) external onlyMigrator {
362         require(ids.length == balances.length, "Nimbus Referral: Different array lengths");     
363         for (uint i; i < ids.length; i++) {
364             _legacyBalances[ids[i]][currencyId] = balances[i];
365         }
366     }
367 
368     function updateUserLegacyBalanceStatuses(uint currencyId, uint[] memory ids, bool[] memory status) external onlyMigrator {
369         require(ids.length == status.length, "Nimbus Referral: Different array lengths");     
370         for (uint i; i < ids.length; i++) {
371             _legacyBalanceStatus[ids[i]][currencyId] = status[i];
372         }
373     }
374 
375     function updateUserAddress(uint id, address userAddress) external onlyMigrator {
376         require(userAddress != address(0), "Nimbus Referral: Address is zero");
377         require(_userSponsor[id] < 1000000001, "Nimbus Referral: No such user");
378         require(userIdByAddress[userAddress] == 0, "Nimbus Referral: Address is already in the system");
379         userIdByAddress[userAddress] = id;
380         userAddressById[id] = userAddress;
381     }
382 
383     function updateUserAddressBySig(uint id, address userAddress, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
384         require(block.timestamp <= deadline, "Nimbus Referral: signature expired");
385         require(userIdByAddress[userAddress] == 0, "Nimbus Referral: Address is already in the system");
386         uint nonce = nonces[userAddress]++;
387         bytes32 digest = keccak256(
388             abi.encodePacked(
389                 '\x19\x01',
390                 DOMAIN_SEPARATOR,
391                 keccak256(abi.encode(UPDATE_ADDRESS_TYPEHASH, id, userAddress, nonce, deadline))
392             )
393         );
394         
395         address recoveredAddress = ecrecover(digest, v, r, s);
396         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus: INVALID_SIGNATURE');
397         userIdByAddress[userAddress] = id;
398         userAddressById[id] = userAddress;
399         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
400     }
401 
402     function updateUserDataBySig(uint id, address userAddress, uint[] memory referrals, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
403         require(block.timestamp <= deadline, "Nimbus Referral: signature expired");
404         uint nonce = nonces[userAddress]++;
405         bytes32 digest = keccak256(
406             abi.encodePacked(
407                 '\x19\x01',
408                 DOMAIN_SEPARATOR,
409                 keccak256(abi.encode(UPDATE_DATA_TYPEHASG, id, userAddress, keccak256(abi.encodePacked(referrals)), nonce, deadline))
410             )
411         );
412         
413         address recoveredAddress = ecrecover(digest, v, r, s);
414         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus: INVALID_SIGNATURE');
415         userIdByAddress[userAddress] = id;
416         userAddressById[id] = userAddress;
417         _userReferrals[id] = referrals;
418         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
419     }
420 
421     function updateUserReferralsBySig(uint id, address userAddress, uint[] memory referrals, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
422         require(block.timestamp <= deadline, "Nimbus Referral: signature expired");
423         uint nonce = nonces[userAddress]++;
424         bytes32 digest = keccak256(
425             abi.encodePacked(
426                 '\x19\x01',
427                 DOMAIN_SEPARATOR,
428                 keccak256(abi.encode(UPDATE_DATA_TYPEHASG, id, userAddress, keccak256(abi.encodePacked(referrals)), nonce, deadline))
429             )
430         );
431         
432         address recoveredAddress = ecrecover(digest, v, r, s);
433         require(recoveredAddress != address(0) && recoveredAddress == migrator, 'Nimbus: INVALID_SIGNATURE');
434         userIdByAddress[userAddress] = id;
435         userAddressById[id] = userAddress;
436         for (uint i; i < referrals.length; i++) {
437             _userReferrals[id].push(referrals[i]);
438         }
439         emit MigrateUserBySign(recoveredAddress, id, userAddress, nonce);
440     }
441 
442     function updateUserReferrals(uint id, uint[] memory referrals) external onlyMigrator {
443         _userReferrals[id] = referrals;
444         for (uint i; i < referrals.length; i++) {
445             _userReferrals[id].push(referrals[i]);
446         }
447     }
448 
449     function updateMigrator(address newMigrator) external onlyMigrator {
450         require(newMigrator != address(0), "Nimbus Referral: Address is zero");
451         migrator = newMigrator;
452     }
453 
454     function finishBasicMigration(uint userId) external onlyMigrator {
455         lastUserId = userId;
456     }
457 
458 
459 
460 
461     function updateSwapRouter(address newSwapRouter) external onlyOwner {
462         require(newSwapRouter != address(0), "Address is zero");
463         swapRouter = INimbusRouter(newSwapRouter);
464     }
465 
466     function updateSwapToken(address newSwapToken) external onlyOwner {
467         require(newSwapToken != address(0), "Address is zero");
468         swapToken = newSwapToken;
469     }
470 
471     function updateSwapTokenAmountForFeeDistributionThreshold(uint threshold) external onlyOwner {
472         swapTokenAmountForFeeDistributionThreshold = threshold;
473     }
474 
475     function updateMaxLevelDepth(uint newMaxLevelDepth) external onlyOwner {
476         maxLevelDepth = newMaxLevelDepth;
477     }
478 
479     function updateMinTokenAmountForCheck(uint newMinTokenAmountForCheck) external onlyOwner {
480         minTokenAmountForCheck = newMinTokenAmountForCheck;
481     }
482 
483     
484 
485     function updateStakingPoolAdd(address newStakingPool) external onlyOwner {
486         for (uint i; i < stakingPools.length; i++) {
487             require (address(stakingPools[i]) != newStakingPool, "Pool exists");
488         }
489         stakingPools.push(INimbusStakingPool(newStakingPool));
490     }
491 
492     function updateStakingPoolRemove(uint poolIndex) external onlyOwner {
493         stakingPools[poolIndex] = stakingPools[stakingPools.length - 1];
494         stakingPools.pop();
495     }
496     
497     function updateSpecialReserveFund(address newSpecialReserveFund) external onlyOwner {
498         require(newSpecialReserveFund != address(0), "Nimbus Referral: Address is zero");
499         specialReserveFund = newSpecialReserveFund;
500         emit UpdateSpecialReserveFund(newSpecialReserveFund);
501     }
502 
503     function updateLevels(uint[] memory newLevels) external onlyOwner {
504         uint checkSum;
505         for (uint i; i < newLevels.length; i++) {
506             checkSum += newLevels[i];
507         }
508         require(checkSum == 100, "Nimbus Referral: Wrong levels amounts");
509         levels = newLevels;
510         maxLevel = newLevels.length;
511         emit UpdateLevels(newLevels);
512     }
513 }
514 
515 //helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
516 library TransferHelper {
517     function safeApprove(address token, address to, uint value) internal {
518         //bytes4(keccak256(bytes('approve(address,uint256)')));
519         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
520         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
521     }
522 
523     function safeTransfer(address token, address to, uint value) internal {
524         //bytes4(keccak256(bytes('transfer(address,uint256)')));
525         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
526         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
527     }
528 
529     function safeTransferFrom(address token, address from, address to, uint value) internal {
530         //bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
531         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
532         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
533     }
534 
535     function safeTransferETH(address to, uint value) internal {
536         (bool success,) = to.call{value:value}(new bytes(0));
537         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
538     }
539 }