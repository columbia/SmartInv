1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "../libraries/ScaledMath.sol";
6 import "../libraries/Errors.sol";
7 import "../libraries/EnumerableExtensions.sol";
8 import "../interfaces/IBkdLocker.sol";
9 import "../interfaces/tokenomics/IBkdToken.sol";
10 import "../interfaces/tokenomics/IMigrationContract.sol";
11 import "./utils/Preparable.sol";
12 import "./access/Authorization.sol";
13 
14 contract BkdLocker is IBkdLocker, Authorization, Preparable {
15     using ScaledMath for uint256;
16     using SafeERC20 for IERC20;
17     using EnumerableMapping for EnumerableMapping.AddressToUintMap;
18     using EnumerableExtensions for EnumerableMapping.AddressToUintMap;
19 
20     bytes32 internal constant _START_BOOST = "startBoost";
21     bytes32 internal constant _MAX_BOOST = "maxBoost";
22     bytes32 internal constant _INCREASE_PERIOD = "increasePeriod";
23     bytes32 internal constant _WITHDRAW_DELAY = "withdrawDelay";
24 
25     // User-specific data
26     mapping(address => uint256) public balances;
27     mapping(address => uint256) public boostFactors;
28     mapping(address => uint256) public lastUpdated;
29     mapping(address => WithdrawStash[]) public stashedGovTokens;
30     mapping(address => uint256) public totalStashed;
31 
32     // Global data
33     uint256 public totalLocked;
34     uint256 public totalLockedBoosted;
35     uint256 public lastMigrationEvent;
36     EnumerableMapping.AddressToUintMap private _replacedRewardTokens;
37 
38     // Reward token data
39     mapping(address => RewardTokenData) public rewardTokenData;
40     address public rewardToken;
41     IERC20 public immutable govToken;
42 
43     constructor(
44         address _rewardToken,
45         address _govToken,
46         IRoleManager roleManager
47     ) Authorization(roleManager) {
48         rewardToken = _rewardToken;
49         govToken = IBkdToken(_govToken);
50     }
51 
52     function initialize(
53         uint256 startBoost,
54         uint256 maxBoost,
55         uint256 increasePeriod,
56         uint256 withdrawDelay
57     ) external override onlyGovernance {
58         require(currentUInts256[_START_BOOST] == 0, Error.CONTRACT_INITIALIZED);
59         _setConfig(_START_BOOST, startBoost);
60         _setConfig(_MAX_BOOST, maxBoost);
61         _setConfig(_INCREASE_PERIOD, increasePeriod);
62         _setConfig(_WITHDRAW_DELAY, withdrawDelay);
63     }
64 
65     /**
66      * @notice Sets a new token to be the rewardToken. Fees are then accumulated in this token.
67      * @dev Previously used rewardTokens can be set again here.
68      */
69     function migrate(address newRewardToken) external override onlyGovernance {
70         _replacedRewardTokens.remove(newRewardToken);
71         _replacedRewardTokens.set(rewardToken, block.timestamp);
72         lastMigrationEvent = block.timestamp;
73         rewardToken = newRewardToken;
74     }
75 
76     /**
77      * @notice Lock gov. tokens.
78      * @dev The amount needs to be approved in advance.
79      */
80     function lock(uint256 amount) external override {
81         return lockFor(msg.sender, amount);
82     }
83 
84     /**
85      * @notice Deposit fees (in the rewardToken) to be distributed to lockers of gov. tokens.
86      * @dev `deposit` or `depositFor` needs to be called at least once before this function can be called
87      * @param amount Amount of rewardToken to deposit.
88      */
89     function depositFees(uint256 amount) external {
90         require(amount > 0, Error.INVALID_AMOUNT);
91         require(totalLockedBoosted > 0, Error.NOT_ENOUGH_FUNDS);
92         IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), amount);
93 
94         RewardTokenData storage curRewardTokenData = rewardTokenData[rewardToken];
95 
96         curRewardTokenData.feeIntegral += amount.scaledDiv(totalLockedBoosted);
97         curRewardTokenData.feeBalance += amount;
98         emit FeesDeposited(amount);
99     }
100 
101     function claimFees() external override {
102         claimFees(rewardToken);
103     }
104 
105     /**
106      * @notice Checkpoint function to update user data, in particular the boost factor.
107      */
108     function userCheckpoint(address user) external override {
109         _userCheckpoint(user, 0, balances[user]);
110     }
111 
112     /**
113      * @notice Prepare unlocking of locked gov. tokens.
114      * @dev A delay is enforced and unlocking can only be executed after that.
115      * @param amount Amount of gov. tokens to prepare for unlocking.
116      */
117     function prepareUnlock(uint256 amount) external override {
118         require(
119             totalStashed[msg.sender] + amount <= balances[msg.sender],
120             "Amount exceeds locked balance"
121         );
122         totalStashed[msg.sender] += amount;
123         stashedGovTokens[msg.sender].push(
124             WithdrawStash(block.timestamp + currentUInts256[_WITHDRAW_DELAY], amount)
125         );
126         emit WithdrawPrepared(msg.sender, amount);
127     }
128 
129     /**
130      * @notice Execute all prepared gov. token withdrawals.
131      */
132     function executeUnlocks() external override {
133         uint256 totalAvailableToWithdraw = 0;
134         WithdrawStash[] storage stashedWithdraws = stashedGovTokens[msg.sender];
135         uint256 length = stashedWithdraws.length;
136         require(length > 0, "No entries");
137         uint256 i = length;
138         while (i > 0) {
139             i = i - 1;
140             if (stashedWithdraws[i].releaseTime <= block.timestamp) {
141                 totalAvailableToWithdraw += stashedWithdraws[i].amount;
142 
143                 stashedWithdraws[i] = stashedWithdraws[stashedWithdraws.length - 1];
144 
145                 stashedWithdraws.pop();
146             }
147         }
148         totalStashed[msg.sender] -= totalAvailableToWithdraw;
149         uint256 newTotal = balances[msg.sender] - totalAvailableToWithdraw;
150         _userCheckpoint(msg.sender, 0, newTotal);
151         totalLocked -= totalAvailableToWithdraw;
152         govToken.safeTransfer(msg.sender, totalAvailableToWithdraw);
153         emit WithdrawExecuted(msg.sender, totalAvailableToWithdraw);
154     }
155 
156     function getUserShare(address user) external view override returns (uint256) {
157         return getUserShare(user, rewardToken);
158     }
159 
160     /**
161      * @notice Get the boosted locked balance for a user.
162      * @dev This includes the gov. tokens queued for withdrawal.
163      * @param user Address to get the boosted balance for.
164      * @return boosted balance for user.
165      */
166     function boostedBalance(address user) external view override returns (uint256) {
167         return balances[user].scaledMul(boostFactors[user]);
168     }
169 
170     /**
171      * @notice Get the vote weight for a user.
172      * @dev This does not invlude the gov. tokens queued for withdrawal.
173      * @param user Address to get the vote weight for.
174      * @return vote weight for user.
175      */
176     function balanceOf(address user) external view override returns (uint256) {
177         return (balances[user] - totalStashed[user]).scaledMul(boostFactors[user]);
178     }
179 
180     /**
181      * @notice Get the share of the total boosted locked balance for a user.
182      * @dev This includes the gov. tokens queued for withdrawal.
183      * @param user Address to get the share of the total boosted balance for.
184      * @return share of the total boosted balance for user.
185      */
186     function getShareOfTotalBoostedBalance(address user) external view override returns (uint256) {
187         return balances[user].scaledMul(boostFactors[user]).scaledDiv(totalLockedBoosted);
188     }
189 
190     function getStashedGovTokens(address user)
191         external
192         view
193         override
194         returns (WithdrawStash[] memory)
195     {
196         return stashedGovTokens[user];
197     }
198 
199     function claimableFees(address user) external view override returns (uint256) {
200         return claimableFees(user, rewardToken);
201     }
202 
203     /**
204      * @notice Claim fees accumulated in the Locker.
205      */
206     function claimFees(address _rewardToken) public override {
207         require(
208             _rewardToken == rewardToken || _replacedRewardTokens.contains(_rewardToken),
209             Error.INVALID_ARGUMENT
210         );
211         _userCheckpoint(msg.sender, 0, balances[msg.sender]);
212         RewardTokenData storage curRewardTokenData = rewardTokenData[_rewardToken];
213         uint256 claimable = curRewardTokenData.userShares[msg.sender];
214         curRewardTokenData.userShares[msg.sender] = 0;
215         curRewardTokenData.feeBalance -= claimable;
216         IERC20(_rewardToken).safeTransfer(msg.sender, claimable);
217         emit RewardsClaimed(msg.sender, _rewardToken, claimable);
218     }
219 
220     /**
221      * @notice Lock gov. tokens on behalf of another user.
222      * @dev The amount needs to be approved in advance.
223      * @param user Address of user to lock on behalf of.
224      * @param amount Amount of gov. tokens to lock.
225      */
226     function lockFor(address user, uint256 amount) public override {
227         govToken.safeTransferFrom(msg.sender, address(this), amount);
228         _userCheckpoint(user, amount, balances[user] + amount);
229         totalLocked += amount;
230         emit Locked(user, amount);
231     }
232 
233     function getUserShare(address user, address _rewardToken)
234         public
235         view
236         override
237         returns (uint256)
238     {
239         return rewardTokenData[_rewardToken].userShares[user];
240     }
241 
242     function claimableFees(address user, address _rewardToken)
243         public
244         view
245         override
246         returns (uint256)
247     {
248         uint256 currentShare;
249         uint256 userBalance = balances[user];
250         RewardTokenData storage curRewardTokenData = rewardTokenData[_rewardToken];
251 
252         // Compute the share earned by the user since he last updated
253         if (userBalance > 0) {
254             currentShare += (curRewardTokenData.feeIntegral -
255                 curRewardTokenData.userFeeIntegrals[user]).scaledMul(
256                     userBalance.scaledMul(boostFactors[user])
257                 );
258         }
259         return curRewardTokenData.userShares[user] + currentShare;
260     }
261 
262     function computeNewBoost(
263         address user,
264         uint256 amountAdded,
265         uint256 newTotal
266     ) public view override returns (uint256) {
267         uint256 newBoost;
268         uint256 balance = balances[user];
269         uint256 startBoost = currentUInts256[_START_BOOST];
270         if (balance == 0 || newTotal == 0) {
271             newBoost = startBoost;
272         } else {
273             uint256 maxBoost = currentUInts256[_MAX_BOOST];
274             newBoost = boostFactors[user];
275             newBoost += (block.timestamp - lastUpdated[user])
276                 .scaledDiv(currentUInts256[_INCREASE_PERIOD])
277                 .scaledMul(maxBoost - startBoost);
278             if (newBoost > maxBoost) {
279                 newBoost = maxBoost;
280             }
281             if (newTotal <= balance) {
282                 return newBoost;
283             }
284             newBoost =
285                 newBoost.scaledMul(balance.scaledDiv(newTotal)) +
286                 startBoost.scaledMul(amountAdded.scaledDiv(newTotal));
287         }
288         return newBoost;
289     }
290 
291     function _userCheckpoint(
292         address user,
293         uint256 amountAdded,
294         uint256 newTotal
295     ) internal {
296         RewardTokenData storage curRewardTokenData = rewardTokenData[rewardToken];
297 
298         // Compute the share earned by the user since he last updated
299         uint256 userBalance = balances[user];
300         if (userBalance > 0) {
301             curRewardTokenData.userShares[user] += (curRewardTokenData.feeIntegral -
302                 curRewardTokenData.userFeeIntegrals[user]).scaledMul(
303                     userBalance.scaledMul(boostFactors[user])
304                 );
305         }
306 
307         // Update values for previous rewardTokens
308         if (lastUpdated[user] < lastMigrationEvent && userBalance > 0) {
309             uint256 length = _replacedRewardTokens.length();
310             for (uint256 i = 0; i < length; i++) {
311                 (address token, uint256 replacedAt) = _replacedRewardTokens.at(i);
312                 if (lastUpdated[user] < replacedAt) {
313                     RewardTokenData storage prevRewardTokenData = rewardTokenData[token];
314                     prevRewardTokenData.userShares[user] += (prevRewardTokenData.feeIntegral -
315                         prevRewardTokenData.userFeeIntegrals[user]).scaledMul(
316                             userBalance.scaledMul(boostFactors[user])
317                         );
318                     prevRewardTokenData.userFeeIntegrals[user] = prevRewardTokenData.feeIntegral;
319                 }
320             }
321         }
322 
323         uint256 newBoost = computeNewBoost(user, amountAdded, newTotal);
324         totalLockedBoosted =
325             totalLockedBoosted +
326             newTotal.scaledMul(newBoost) -
327             balances[user].scaledMul(boostFactors[user]);
328 
329         // Update user values
330         curRewardTokenData.userFeeIntegrals[user] = curRewardTokenData.feeIntegral;
331         lastUpdated[user] = block.timestamp;
332         boostFactors[user] = newBoost;
333         balances[user] = newTotal;
334     }
335 }
