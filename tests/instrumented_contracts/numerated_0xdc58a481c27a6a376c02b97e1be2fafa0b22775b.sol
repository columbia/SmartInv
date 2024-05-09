1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity 0.5.17;
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
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 interface IYFVRewards {
161     function stakingPower(address account) external view returns (uint256);
162 }
163 
164 contract YFVVIPVoteV2 {
165     using SafeMath for uint256;
166 
167     uint8 public constant MAX_VOTERS_PER_ITEM = 200;
168     uint256 public constant POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM = 10000;
169     uint256 public constant VIP_3_VOTE_ITEM = 3;
170 
171     mapping(address => mapping(uint256 => uint8)) public numVoters; // poolAddress -> votingItem (periodFinish) -> numVoters (the number of voters in this round)
172     mapping(address => mapping(uint256 => address[MAX_VOTERS_PER_ITEM])) public voters; // poolAddress -> votingItem (periodFinish) -> voters (array)
173     mapping(address => mapping(uint256 => mapping(address => bool))) public isInTopVoters; // poolAddress -> votingItem (periodFinish) -> isInTopVoters (map: voter -> in_top (true/false))
174     mapping(address => mapping(uint256 => mapping(address => uint64))) public voter2VotingValue; // poolAddress -> votingItem (periodFinish) -> voter2VotingValue (map: voter -> voting value)
175 
176     mapping(address => mapping(uint256 => uint64)) public votingValueMinimums; // poolAddress -> votingItem (proposalId) -> votingValueMin
177     mapping(address => mapping(uint256 => uint64)) public votingValueMaximums; // poolAddress -> votingItem (proposalId) -> votingValueMax
178 
179     mapping(address => mapping(uint256 => uint256)) public votingStarttimes; // poolAddress -> votingItem (proposalId) -> voting's starttime
180     mapping(address => mapping(uint256 => uint256)) public votingEndtimes; // poolAddress -> votingItem (proposalId) -> voting's endtime
181 
182     mapping(address => uint8) poolVotingValueLeftBitRanges; // poolAddress -> left bit range
183     mapping(address => uint8) poolVotingValueRightBitRanges; // poolAddress -> right bit range
184 
185     address public stakeGovernancePool = 0xD120f23438AC0edbBA2c4c072739387aaa70277a; // Stake Pool v2
186 
187     address public governance;
188     address public operator; // help to replace weak voter by higher power one
189 
190     event Voted(address poolAddress, address indexed user, uint256 votingItem, uint64 votingValue);
191 
192     constructor () public {
193         governance = msg.sender;
194         operator = msg.sender;
195         // BAL Pool
196         poolVotingValueLeftBitRanges[0x62a9fE913eb596C8faC0936fd2F51064022ba22e] = 5;
197         poolVotingValueRightBitRanges[0x62a9fE913eb596C8faC0936fd2F51064022ba22e] = 0;
198         // YFI Pool
199         poolVotingValueLeftBitRanges[0x70b83A7f5E83B3698d136887253E0bf426C9A117] = 10;
200         poolVotingValueRightBitRanges[0x70b83A7f5E83B3698d136887253E0bf426C9A117] = 5;
201         // BAT Pool
202         poolVotingValueLeftBitRanges[0x1c990fC37F399C935625b815975D0c9fAD5C31A1] = 15;
203         poolVotingValueRightBitRanges[0x1c990fC37F399C935625b815975D0c9fAD5C31A1] = 10;
204         // REN Pool
205         poolVotingValueLeftBitRanges[0x752037bfEf024Bd2669227BF9068cb22840174B0] = 20;
206         poolVotingValueRightBitRanges[0x752037bfEf024Bd2669227BF9068cb22840174B0] = 15;
207         // KNC Pool
208         poolVotingValueLeftBitRanges[0x9b74774f55C0351fD064CfdfFd35dB002C433092] = 25;
209         poolVotingValueRightBitRanges[0x9b74774f55C0351fD064CfdfFd35dB002C433092] = 20;
210         // BTC Pool
211         poolVotingValueLeftBitRanges[0xFBDE07329FFc9Ec1b70f639ad388B94532b5E063] = 30;
212         poolVotingValueRightBitRanges[0xFBDE07329FFc9Ec1b70f639ad388B94532b5E063] = 25;
213         // WETH Pool
214         poolVotingValueLeftBitRanges[0x67FfB615EAEb8aA88fF37cCa6A32e322286a42bb] = 35;
215         poolVotingValueRightBitRanges[0x67FfB615EAEb8aA88fF37cCa6A32e322286a42bb] = 30;
216         // LINK Pool
217         poolVotingValueLeftBitRanges[0x196CF719251579cBc850dED0e47e972b3d7810Cd] = 40;
218         poolVotingValueRightBitRanges[0x196CF719251579cBc850dED0e47e972b3d7810Cd] = 35;
219     }
220 
221     function setGovernance(address _governance) public {
222         require(msg.sender == governance, "!governance");
223         governance = _governance;
224     }
225 
226     function setOperator(address _operator) public {
227         require(msg.sender == governance, "!governance");
228         operator = _operator;
229     }
230 
231     function setVotingConfig(address poolAddress, uint256 votingItem, uint64 minValue, uint64 maxValue, uint256 starttime, uint256 endtime) public {
232         require(msg.sender == governance, "!governance");
233         require(minValue < maxValue, "Invalid voting range");
234         require(starttime < endtime, "Invalid time range");
235         require(endtime > block.timestamp, "Endtime has passed");
236         votingValueMinimums[poolAddress][votingItem] = minValue;
237         votingValueMaximums[poolAddress][votingItem] = maxValue;
238         votingStarttimes[poolAddress][votingItem] = starttime;
239         votingEndtimes[poolAddress][votingItem] = endtime;
240     }
241 
242     function setStakeGovernancePool(address _stakeGovernancePool) public {
243         require(msg.sender == governance, "!governance");
244         stakeGovernancePool = _stakeGovernancePool;
245     }
246 
247     function setPoolVotingValueBitRanges(address poolAddress, uint8 leftBitRange, uint8 rightBitRange) public {
248         require(msg.sender == governance, "!governance");
249         poolVotingValueLeftBitRanges[poolAddress] = leftBitRange;
250         poolVotingValueRightBitRanges[poolAddress] = rightBitRange;
251     }
252 
253     function isVotable(address poolAddress, address account, uint256 votingItem) public view returns (bool) {
254         if (block.timestamp < votingStarttimes[poolAddress][votingItem]) return false; // vote is not open yet
255         if (block.timestamp > votingEndtimes[poolAddress][votingItem]) return false; // vote is closed
256 
257         IYFVRewards rewards = IYFVRewards(poolAddress);
258         // hasn't any staking power
259         if (rewards.stakingPower(account) == 0) return false;
260 
261         // number of voters is under limit still
262         if (numVoters[poolAddress][votingItem] < MAX_VOTERS_PER_ITEM) return true;
263         return false;
264     }
265 
266     // for VIP: multiply by 100 for more precise
267     function averageVotingValueX100(address poolAddress, uint256 votingItem) public view returns (uint64) {
268         if (numVoters[poolAddress][votingItem] == 0) return 0; // no votes
269         uint256 totalStakingPower = 0;
270         uint256 totalWeightedVotingValue = 0;
271         IYFVRewards rewards = IYFVRewards(poolAddress);
272         for (uint8 i = 0; i < numVoters[poolAddress][votingItem]; i++) {
273             address voter = voters[poolAddress][votingItem][i];
274             totalStakingPower = totalStakingPower.add(rewards.stakingPower(voter));
275             totalWeightedVotingValue = totalWeightedVotingValue.add(rewards.stakingPower(voter).mul(voter2VotingValue[poolAddress][votingItem][voter]));
276         }
277         return (uint64) (totalWeightedVotingValue.mul(100).div(totalStakingPower));
278     }
279 
280     // multiply by 100 for more precise
281     function averageVotingValueByBitsX100(address poolAddress, uint256 votingItem, uint8 leftBitRange, uint8 rightBitRange) public view returns (uint64) {
282         if (numVoters[poolAddress][votingItem] == 0) return 0; // no votes
283         uint256 totalStakingPower = 0;
284         uint256 totalWeightedVotingValue = 0;
285         IYFVRewards rewards = IYFVRewards(poolAddress);
286         uint64 bitmask = (uint64(1) << (leftBitRange - rightBitRange)) - 1;
287         for (uint8 i = 0; i < numVoters[poolAddress][votingItem]; i++) {
288             address voter = voters[poolAddress][votingItem][i];
289             totalStakingPower = totalStakingPower.add(rewards.stakingPower(voter));
290             uint64 votingValueByBits = (voter2VotingValue[poolAddress][votingItem][voter] >> rightBitRange) & bitmask;
291             totalWeightedVotingValue = totalWeightedVotingValue.add(rewards.stakingPower(voter).mul(votingValueByBits));
292         }
293         return (uint64) (totalWeightedVotingValue.mul(100).div(totalStakingPower));
294     }
295 
296     function verifyOfflineVote(address poolAddress, uint256 votingItem, uint64 votingValue, uint256 timestamp, address voter, uint8 v, bytes32 r, bytes32 s) public pure returns (bool) {
297         bytes32 signatureHash = keccak256(abi.encodePacked(voter, poolAddress, votingItem, votingValue, timestamp));
298         return voter == ecrecover(signatureHash, v, r, s);
299     }
300 
301     // if more than 200 voters participate, we may need to replace a weak (low power) voter by a stronger (high power) one
302     function replaceVoter(address poolAddress, uint256 votingItem, uint8 voterIndex, address newVoter) public {
303         require(msg.sender == governance || msg.sender == operator, "!governance && !operator");
304         require(numVoters[poolAddress][votingItem] > voterIndex, "index is out of range");
305         require(!isInTopVoters[poolAddress][votingItem][newVoter], "newVoter is in the list already");
306         IYFVRewards rewards = IYFVRewards(poolAddress);
307         address currentVoter = voters[poolAddress][votingItem][voterIndex];
308         require(rewards.stakingPower(currentVoter) < rewards.stakingPower(newVoter), "newVoter does not have high power than currentVoter");
309         isInTopVoters[poolAddress][votingItem][currentVoter] = false;
310         isInTopVoters[poolAddress][votingItem][newVoter] = true;
311         voters[poolAddress][votingItem][voterIndex] = newVoter;
312     }
313 
314     function vote(address poolAddress, uint256 votingItem, uint64 votingValue) public {
315         require(block.timestamp >= votingStarttimes[poolAddress][votingItem], "voting is not open yet");
316         require(block.timestamp <= votingEndtimes[poolAddress][votingItem], "voting is closed");
317         if (votingValueMinimums[poolAddress][votingItem] > 0 || votingValueMaximums[poolAddress][votingItem] > 0) {
318             require(votingValue >= votingValueMinimums[poolAddress][votingItem], "votingValue is smaller than minimum accepted value");
319             require(votingValue <= votingValueMaximums[poolAddress][votingItem], "votingValue is greater than maximum accepted value");
320         }
321 
322         if (!isInTopVoters[poolAddress][votingItem][msg.sender]) {
323             require(isVotable(poolAddress, msg.sender, votingItem), "This account is not votable");
324             if (numVoters[poolAddress][votingItem] < MAX_VOTERS_PER_ITEM) {
325                 isInTopVoters[poolAddress][votingItem][msg.sender] = true;
326                 voters[poolAddress][votingItem][numVoters[poolAddress][votingItem]] = msg.sender;
327                 ++numVoters[poolAddress][votingItem];
328             }
329         }
330         voter2VotingValue[poolAddress][votingItem][msg.sender] = votingValue;
331         emit Voted(poolAddress, msg.sender, votingItem, votingValue);
332     }
333 
334     function averageVotingValue(address poolAddress, uint256) public view returns (uint16) {
335         uint8 numInflationVoters = numVoters[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM];
336         if (numInflationVoters == 0) return 0; // no votes
337 
338         uint8 leftBitRange = poolVotingValueLeftBitRanges[poolAddress];
339         uint8 rightBitRange = poolVotingValueRightBitRanges[poolAddress];
340         if (leftBitRange == 0 && rightBitRange == 0) return 0; // we dont know about this pool
341         // empowerment Factor (every 100 is 5%) (slider 0% - 5% - 10% - .... - 80%)
342         uint64 empowermentFactor = averageVotingValueByBitsX100(stakeGovernancePool, VIP_3_VOTE_ITEM, leftBitRange, rightBitRange) / 20;
343         if (empowermentFactor > 80) empowermentFactor = 80; // minimum 0% -> maximum 80%
344         uint64 farmingFactor = 100 - empowermentFactor; // minimum 20% -> maximum 100%
345 
346         uint256 totalFarmingPower = 0;
347         uint256 totalStakingPower = 0;
348         uint256 totalWeightedFarmingVotingValue = 0;
349         uint256 totalWeightedStakingVotingValue = 0;
350         IYFVRewards farmingPool = IYFVRewards(poolAddress);
351         IYFVRewards stakingPool = IYFVRewards(stakeGovernancePool);
352         uint64 bitmask = (uint64(1) << (leftBitRange - rightBitRange)) - 1;
353         for (uint8 i = 0; i < numInflationVoters; i++) {
354             address voter = voters[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM][i];
355             totalFarmingPower = totalFarmingPower.add(farmingPool.stakingPower(voter));
356             totalStakingPower = totalStakingPower.add(stakingPool.stakingPower(voter));
357             uint64 votingValueByBits = (voter2VotingValue[stakeGovernancePool][POOL_REWARD_SUPPLY_INFLATION_RATE_VOTE_ITEM][voter] >> rightBitRange) & bitmask;
358             totalWeightedFarmingVotingValue = totalWeightedFarmingVotingValue.add(farmingPool.stakingPower(voter).mul(votingValueByBits));
359             totalWeightedStakingVotingValue = totalWeightedStakingVotingValue.add(stakingPool.stakingPower(voter).mul(votingValueByBits));
360         }
361         uint64 farmingAvgValue = (uint64) (totalWeightedFarmingVotingValue.mul(farmingFactor).div(totalFarmingPower));
362         uint64 stakingAvgValue = (uint64) (totalWeightedStakingVotingValue.mul(empowermentFactor).div(totalStakingPower));
363         uint16 avgValue = (uint16) ((farmingAvgValue + stakingAvgValue) / 100);
364         // 0 -> x0.2, 1 -> x0.25, ..., 20 -> x1.20
365         if (avgValue > 20) return 120;
366         return 20 + avgValue * 5;
367     }
368 
369     function votingValueGovernance(address poolAddress, uint256 votingItem, uint16) public view returns (uint16) {
370         return averageVotingValue(poolAddress, votingItem);
371     }
372 
373     // governance can drain tokens that are sent here by mistake
374     function emergencyERC20Drain(ERC20 token, uint amount) external {
375         require(msg.sender == governance, "!governance");
376         token.transfer(governance, amount);
377     }
378 }
379 
380 /**
381  * @title ERC20 interface
382  * @dev see https://github.com/ethereum/EIPs/issues/20
383  */
384 contract ERC20 {
385     function totalSupply() public view returns (uint256);
386     function balanceOf(address _who) public view returns (uint256);
387     function transfer(address _to, uint256 _value) public returns (bool);
388     function allowance(address _owner, address _spender) public view returns (uint256);
389     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
390     function approve(address _spender, uint256 _value) public returns (bool);
391     event Transfer(address indexed from, address indexed to, uint256 value);
392     event Approval(address indexed owner, address indexed spender, uint256 value);
393 }