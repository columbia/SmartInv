1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed from, address indexed to);
22 
23     constructor() {
24         owner = msg.sender;
25         emit OwnershipTransferred(address(0), owner);
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner, "Ownable: Caller is not the owner");
30         _;
31     }
32 
33     function getOwner() external view returns (address) {
34         return owner;
35     }
36 
37     function transferOwnership(address transferOwner) external onlyOwner {
38         require(transferOwner != newOwner);
39         newOwner = transferOwner;
40     }
41 
42     function acceptOwnership() virtual external {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 interface INimbusReferralProgram {
51     function userSponsor(uint user) external view returns (uint);
52     function userSponsorByAddress(address user) external view returns (uint);
53     function userIdByAddress(address user) external view returns (uint);
54     function userAddressById(uint id) external view returns (address);
55     function userSponsorAddressByAddress(address user) external view returns (address);
56 }
57 
58 interface INimbusStakingPool {
59     function balanceOf(address account) external view returns (uint256);
60     function stakingToken() external view returns (IBEP20);
61 }
62 
63 interface INimbusRouter {
64     function getAmountsOut(uint amountIn, address[] calldata path) external  view returns (uint[] memory amounts);
65 }
66 
67 contract NimbusReferralProgramLogic is Ownable { 
68     INimbusReferralProgram public immutable users;
69     IBEP20 public immutable NBU;
70     INimbusRouter public swapRouter;
71     INimbusStakingPool[] public stakingPools; 
72 
73     uint[] public levels;
74     uint public maxLevel;
75     uint public maxLevelDepth;
76     uint public minTokenAmountForCheck;
77 
78     mapping(address => mapping(uint => uint)) private _undistributedFees;
79     mapping(address => uint) private _recordedBalances;
80 
81 
82     address public specialReserveFund;
83     address public swapToken;
84     uint public swapTokenAmountForFeeDistributionThreshold;
85 
86     event DistributeFees(address indexed token, uint indexed userId, uint amount);
87     event DistributeFeesForUser(address indexed token, uint indexed recipientId, uint amount);
88     event ClaimEarnedFunds(address indexed token, uint indexed userId, uint unclaimedAmount);
89     event TransferToNimbusSpecialReserveFund(address indexed token, uint indexed fromUserId, uint undistributedAmount);
90     event UpdateLevels(uint[] newLevels);
91     event UpdateSpecialReserveFund(address newSpecialReserveFund);
92 
93     uint private unlocked = 1;
94     modifier lock() {
95         require(unlocked == 1, 'Nimbus Referral: LOCKED');
96         unlocked = 0;
97         _;
98         unlocked = 1;
99     }
100 
101     constructor(address referralUsers, address nbu)  {
102         require(referralUsers != address(0) && nbu != address(0), "Nimbus Referral: Address is zero");
103         levels = [40, 20, 13, 10, 10, 7];
104         maxLevel = 6;
105         NBU = IBEP20(nbu);
106         users = INimbusReferralProgram(referralUsers);
107 
108         minTokenAmountForCheck = 10 * 1e18;
109         maxLevelDepth = 25;
110     }
111 
112     function undistributedFees(address token, uint userId) external view returns (uint) {
113         return _undistributedFees[token][userId];
114 }
115 
116     function recordFee(address token, address recipient, uint amount) external lock { 
117         uint actualBalance = IBEP20(token).balanceOf(address(this));
118         require(actualBalance - amount >= _recordedBalances[token], "Nimbus Referral: Balance check failed");
119         uint uiserId = users.userIdByAddress(recipient);
120         if (users.userSponsor(uiserId) == 0) uiserId = 0;
121         _undistributedFees[token][uiserId] += amount;
122         _recordedBalances[token] = actualBalance;
123     }
124 
125     function distributeEarnedFees(address token, uint userId) external {
126         distributeFees(token, userId);
127         uint callerId = users.userIdByAddress(msg.sender);
128         if (_undistributedFees[token][callerId] > 0) distributeFees(token, callerId);
129     }
130 
131     function distributeEarnedFees(address token, uint[] memory userIds) external {
132         for (uint i; i < userIds.length; i++) {
133             distributeFees(token, userIds[i]);
134         }
135         
136         uint callerId = users.userIdByAddress(msg.sender);
137         if (_undistributedFees[token][callerId] > 0) distributeFees(token, callerId);
138     }
139 
140     function distributeEarnedFees(address[] memory tokens, uint userId) external {
141         uint callerId = users.userIdByAddress(msg.sender);
142         for (uint i; i < tokens.length; i++) {
143             distributeFees(tokens[i], userId);
144             if (_undistributedFees[tokens[i]][callerId] > 0) distributeFees(tokens[i], callerId);
145         }
146     }
147     
148     function distributeFees(address token, uint userId) private {
149         require(_undistributedFees[token][userId] > 0, "Nimbus Referral: Undistributed fee is 0");
150         uint amount = _undistributedFees[token][userId];
151         uint level = transferToSponsor(token, userId, amount, 0, 0); 
152 
153         if (level < maxLevel) {
154             uint undistributedPercentage;
155             for (uint ii = level; ii < maxLevel; ii++) {
156                 undistributedPercentage += levels[ii];
157             }
158             uint undistributedAmount = amount * undistributedPercentage / 100;
159             _undistributedFees[token][0] += undistributedAmount;
160             emit TransferToNimbusSpecialReserveFund(token, userId, undistributedAmount);
161         }
162 
163         emit DistributeFees(token, userId, amount);
164         _undistributedFees[token][userId] = 0;
165     }
166 
167     function transferToSponsor(address token, uint userId, uint amount, uint level, uint levelGuard) private returns (uint) {
168         if (level >= maxLevel) return maxLevel;
169         if (levelGuard > maxLevelDepth) return level;
170         uint sponsorId = users.userSponsor(userId);
171         if (sponsorId < 1000000001) return level;
172         address sponsorAddress = users.userAddressById(sponsorId);
173         if (isUserBalanceEnough(sponsorAddress)) {
174             uint bonusAmount = amount * levels[level] / 100;
175             TransferHelper.safeTransfer(token, sponsorAddress, bonusAmount);
176             _recordedBalances[token] = _recordedBalances[token] - bonusAmount;
177             emit DistributeFeesForUser(token, sponsorId, bonusAmount);
178             return transferToSponsor(token, sponsorId, amount, ++level, ++levelGuard);
179         } else {
180             return transferToSponsor(token, sponsorId, amount, level, ++levelGuard);
181         }            
182     }
183 
184     function isUserBalanceEnough(address user) public view returns (bool) {
185         if (user == address(0)) return false;
186         uint amount = NBU.balanceOf(user);
187         for (uint i; i < stakingPools.length; i++) {
188             amount += stakingPools[i].balanceOf(user);
189         }
190         if (amount < minTokenAmountForCheck) return false;
191         address[] memory path = new address[](2);
192         path[0] = address(NBU);
193         path[1] = swapToken;
194         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
195         return tokenAmount >= swapTokenAmountForFeeDistributionThreshold;
196     }
197 
198     function claimSpecialReserveFundBatch(address[] memory tokens) external {
199         for (uint i; i < tokens.length; i++) {
200             claimSpecialReserveFund(tokens[i]);
201         }
202     }
203 
204     function claimSpecialReserveFund(address token) public {
205         uint amount = _undistributedFees[token][0]; 
206         require(amount > 0, "Nimbus Referral: No unclaimed funds for selected token");
207         TransferHelper.safeTransfer(token, specialReserveFund, amount);
208         _recordedBalances[token] -= amount;
209         _undistributedFees[token][0] = 0;
210     }
211 
212 
213         function updateSwapRouter(address newSwapRouter) external onlyOwner {
214         require(newSwapRouter != address(0), "Nimbus Referral: Address is zero");
215         swapRouter = INimbusRouter(newSwapRouter);
216     }
217 
218     function updateSwapToken(address newSwapToken) external onlyOwner {
219         require(newSwapToken != address(0), "Nimbus Referral: Address is zero");
220         swapToken = newSwapToken;
221     }
222 
223     function updateSwapTokenAmountForFeeDistributionThreshold(uint threshold) external onlyOwner {
224         swapTokenAmountForFeeDistributionThreshold = threshold;
225     }
226 
227     function updateMaxLevelDepth(uint newMaxLevelDepth) external onlyOwner {
228         maxLevelDepth = newMaxLevelDepth;
229     }
230 
231     function updateMinTokenAmountForCheck(uint newMinTokenAmountForCheck) external onlyOwner {
232         minTokenAmountForCheck = newMinTokenAmountForCheck;
233     }
234 
235     
236 
237     function updateStakingPoolAdd(address newStakingPool) external onlyOwner {
238         INimbusStakingPool pool = INimbusStakingPool(newStakingPool);
239         require (pool.stakingToken() == NBU, "Nimbus Referral: Wrong pool staking tokens");
240 
241         for (uint i; i < stakingPools.length; i++) {
242             require (address(stakingPools[i]) != newStakingPool, "Nimbus Referral: Pool exists");
243         }
244         stakingPools.push(INimbusStakingPool(pool));
245     }
246 
247     function updateStakingPoolRemove(uint poolIndex) external onlyOwner {
248         stakingPools[poolIndex] = stakingPools[stakingPools.length - 1];
249         stakingPools.pop();
250     }
251     
252     function updateSpecialReserveFund(address newSpecialReserveFund) external onlyOwner {
253         require(newSpecialReserveFund != address(0), "Nimbus Referral: Address is zero");
254         specialReserveFund = newSpecialReserveFund;
255         emit UpdateSpecialReserveFund(newSpecialReserveFund);
256     }
257 
258     function updateLevels(uint[] memory newLevels) external onlyOwner {
259         uint checkSum;
260         for (uint i; i < newLevels.length; i++) {
261             checkSum += newLevels[i];
262         }
263         require(checkSum == 100, "Nimbus Referral: Wrong levels amounts");
264         levels = newLevels;
265         maxLevel = newLevels.length;
266         emit UpdateLevels(newLevels);
267     }
268 }
269 
270 //helper methods for interacting with BEP20 tokens and sending BNB that do not consistently return true/false
271 library TransferHelper {
272     function safeApprove(address token, address to, uint value) internal {
273         //bytes4(keccak256(bytes('approve(address,uint256)')));
274         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
275         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
276     }
277 
278     function safeTransfer(address token, address to, uint value) internal {
279         //bytes4(keccak256(bytes('transfer(address,uint256)')));
280         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
281         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
282     }
283 
284     function safeTransferFrom(address token, address from, address to, uint value) internal {
285         //bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
286         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
287         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
288     }
289 
290     function safeTransferBNB(address to, uint value) internal {
291         (bool success,) = to.call{value:value}(new bytes(0));
292         require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
293     }
294 }