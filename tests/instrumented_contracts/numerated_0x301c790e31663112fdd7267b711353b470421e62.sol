1 // File: contracts/IEpochUtils.sol
2 
3 pragma solidity 0.6.6;
4 
5 interface IEpochUtils {
6     function epochPeriodInSeconds() external view returns (uint256);
7 
8     function firstEpochStartTimestamp() external view returns (uint256);
9 
10     function getCurrentEpochNumber() external view returns (uint256);
11 
12     function getEpochNumber(uint256 timestamp) external view returns (uint256);
13 }
14 
15 // File: contracts/IKyberDao.sol
16 
17 pragma solidity 0.6.6;
18 
19 
20 
21 interface IKyberDao is IEpochUtils {
22     event Voted(address indexed staker, uint indexed epoch, uint indexed campaignID, uint option);
23 
24     function getLatestNetworkFeeDataWithCache()
25         external
26         returns (uint256 feeInBps, uint256 expiryTimestamp);
27 
28     function getLatestBRRDataWithCache()
29         external
30         returns (
31             uint256 burnInBps,
32             uint256 rewardInBps,
33             uint256 rebateInBps,
34             uint256 epoch,
35             uint256 expiryTimestamp
36         );
37 
38     function handleWithdrawal(address staker, uint256 penaltyAmount) external;
39 
40     function vote(uint256 campaignID, uint256 option) external;
41 
42     function getLatestNetworkFeeData()
43         external
44         view
45         returns (uint256 feeInBps, uint256 expiryTimestamp);
46 
47     function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);
48 
49     /**
50      * @dev  return staker's reward percentage in precision for a past epoch only
51      *       fee handler should call this function when a staker wants to claim reward
52      *       return 0 if staker has no votes or stakes
53      */
54     function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
55         external
56         view
57         returns (uint256);
58 
59     /**
60      * @dev  return staker's reward percentage in precision for the current epoch
61      *       reward percentage is not finalized until the current epoch is ended
62      */
63     function getCurrentEpochRewardPercentageInPrecision(address staker)
64         external
65         view
66         returns (uint256);
67 }
68 
69 // File: @kyber.network/utils-sc/contracts/IERC20.sol
70 
71 pragma solidity 0.6.6;
72 
73 
74 interface IERC20 {
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77     function approve(address _spender, uint256 _value) external returns (bool success);
78 
79     function transfer(address _to, uint256 _value) external returns (bool success);
80 
81     function transferFrom(
82         address _from,
83         address _to,
84         uint256 _value
85     ) external returns (bool success);
86 
87     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
88 
89     function balanceOf(address _owner) external view returns (uint256 balance);
90 
91     function decimals() external view returns (uint8 digits);
92 
93     function totalSupply() external view returns (uint256 supply);
94 }
95 
96 
97 // to support backward compatible contract name -- so function signature remains same
98 abstract contract ERC20 is IERC20 {
99 
100 }
101 
102 // File: contracts/IERC20.sol
103 
104 pragma solidity 0.6.6;
105 
106 // File: contracts/IKyberFeeHandler.sol
107 
108 pragma solidity 0.6.6;
109 
110 
111 
112 interface IKyberFeeHandler {
113     event RewardPaid(address indexed staker, uint256 indexed epoch, IERC20 indexed token, uint256 amount);
114     event RebatePaid(address indexed rebateWallet, IERC20 indexed token, uint256 amount);
115     event PlatformFeePaid(address indexed platformWallet, IERC20 indexed token, uint256 amount);
116     event KncBurned(uint256 kncTWei, IERC20 indexed token, uint256 amount);
117 
118     function handleFees(
119         IERC20 token,
120         address[] calldata eligibleWallets,
121         uint256[] calldata rebatePercentages,
122         address platformWallet,
123         uint256 platformFee,
124         uint256 networkFee
125     ) external payable;
126 
127     function claimReserveRebate(address rebateWallet) external returns (uint256);
128 
129     function claimPlatformFee(address platformWallet) external returns (uint256);
130 
131     function claimStakerReward(
132         address staker,
133         uint256 epoch
134     ) external returns(uint amount);
135 }
136 
137 // File: contracts/wrappers/IMultipleEpochRewardsClaimer.sol
138 
139 pragma solidity 0.6.6;
140 
141 
142 interface IFeeHandler is IKyberFeeHandler {
143     function hasClaimedReward(address, uint256) external view returns (bool);
144 }
145 
146 interface IMultipleEpochRewardsClaimer {
147     function claimMultipleRewards(
148         IFeeHandler feeHandler,
149         uint256[] calldata unclaimedEpochs
150     ) external;
151 
152     function getUnclaimedEpochs(IFeeHandler feeHandler, address staker)
153         external
154         view
155         returns (uint256[] memory unclaimedEpochs);
156 }
157 
158 // File: @kyber.network/utils-sc/contracts/PermissionGroups.sol
159 
160 pragma solidity 0.6.6;
161 
162 contract PermissionGroups {
163     uint256 internal constant MAX_GROUP_SIZE = 50;
164 
165     address public admin;
166     address public pendingAdmin;
167     mapping(address => bool) internal operators;
168     mapping(address => bool) internal alerters;
169     address[] internal operatorsGroup;
170     address[] internal alertersGroup;
171 
172     event AdminClaimed(address newAdmin, address previousAdmin);
173 
174     event TransferAdminPending(address pendingAdmin);
175 
176     event OperatorAdded(address newOperator, bool isAdd);
177 
178     event AlerterAdded(address newAlerter, bool isAdd);
179 
180     constructor(address _admin) public {
181         require(_admin != address(0), "admin 0");
182         admin = _admin;
183     }
184 
185     modifier onlyAdmin() {
186         require(msg.sender == admin, "only admin");
187         _;
188     }
189 
190     modifier onlyOperator() {
191         require(operators[msg.sender], "only operator");
192         _;
193     }
194 
195     modifier onlyAlerter() {
196         require(alerters[msg.sender], "only alerter");
197         _;
198     }
199 
200     function getOperators() external view returns (address[] memory) {
201         return operatorsGroup;
202     }
203 
204     function getAlerters() external view returns (address[] memory) {
205         return alertersGroup;
206     }
207 
208     /**
209      * @dev Allows the current admin to set the pendingAdmin address.
210      * @param newAdmin The address to transfer ownership to.
211      */
212     function transferAdmin(address newAdmin) public onlyAdmin {
213         require(newAdmin != address(0), "new admin 0");
214         emit TransferAdminPending(newAdmin);
215         pendingAdmin = newAdmin;
216     }
217 
218     /**
219      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
220      * @param newAdmin The address to transfer ownership to.
221      */
222     function transferAdminQuickly(address newAdmin) public onlyAdmin {
223         require(newAdmin != address(0), "admin 0");
224         emit TransferAdminPending(newAdmin);
225         emit AdminClaimed(newAdmin, admin);
226         admin = newAdmin;
227     }
228 
229     /**
230      * @dev Allows the pendingAdmin address to finalize the change admin process.
231      */
232     function claimAdmin() public {
233         require(pendingAdmin == msg.sender, "not pending");
234         emit AdminClaimed(pendingAdmin, admin);
235         admin = pendingAdmin;
236         pendingAdmin = address(0);
237     }
238 
239     function addAlerter(address newAlerter) public onlyAdmin {
240         require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
241         require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");
242 
243         emit AlerterAdded(newAlerter, true);
244         alerters[newAlerter] = true;
245         alertersGroup.push(newAlerter);
246     }
247 
248     function removeAlerter(address alerter) public onlyAdmin {
249         require(alerters[alerter], "not alerter");
250         alerters[alerter] = false;
251 
252         for (uint256 i = 0; i < alertersGroup.length; ++i) {
253             if (alertersGroup[i] == alerter) {
254                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
255                 alertersGroup.pop();
256                 emit AlerterAdded(alerter, false);
257                 break;
258             }
259         }
260     }
261 
262     function addOperator(address newOperator) public onlyAdmin {
263         require(!operators[newOperator], "operator exists"); // prevent duplicates.
264         require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");
265 
266         emit OperatorAdded(newOperator, true);
267         operators[newOperator] = true;
268         operatorsGroup.push(newOperator);
269     }
270 
271     function removeOperator(address operator) public onlyAdmin {
272         require(operators[operator], "not operator");
273         operators[operator] = false;
274 
275         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
276             if (operatorsGroup[i] == operator) {
277                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
278                 operatorsGroup.pop();
279                 emit OperatorAdded(operator, false);
280                 break;
281             }
282         }
283     }
284 }
285 
286 // File: @kyber.network/utils-sc/contracts/Withdrawable.sol
287 
288 pragma solidity 0.6.6;
289 
290 
291 
292 contract Withdrawable is PermissionGroups {
293 
294     event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);
295     event EtherWithdraw(uint256 amount, address sendTo);
296 
297     constructor(address _admin) public PermissionGroups(_admin) {}
298 
299     /**
300      * @dev Withdraw all IERC20 compatible tokens
301      * @param token IERC20 The address of the token contract
302      */
303     function withdrawToken(
304         IERC20 token,
305         uint256 amount,
306         address sendTo
307     ) external onlyAdmin {
308         token.transfer(sendTo, amount);
309         emit TokenWithdraw(token, amount, sendTo);
310     }
311 
312     /**
313      * @dev Withdraw Ethers
314      */
315     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
316         (bool success, ) = sendTo.call{value: amount}("");
317         require(success, "withdraw failed");
318         emit EtherWithdraw(amount, sendTo);
319     }
320 }
321 
322 // File: contracts/wrappers/MultipleEpochRewardsClaimer.sol
323 
324 pragma solidity 0.6.6;
325 
326 
327 
328 
329 
330 contract MultipleEpochRewardsClaimer is IMultipleEpochRewardsClaimer, Withdrawable {
331     IKyberDao public immutable kyberDao;
332 
333     constructor(IKyberDao _kyberDao, address _admin) public Withdrawable(_admin) {
334         kyberDao = _kyberDao;
335     }
336 
337     /// @dev unclaimedEpochs is asusumed to be of reasonable length
338     /// otherwise txns might run out of gas
339     function claimMultipleRewards(
340         IFeeHandler feeHandler,
341         uint256[] calldata unclaimedEpochs
342     ) external override {
343         for (uint256 i = 0; i < unclaimedEpochs.length; i++) {
344             feeHandler.claimStakerReward(msg.sender, unclaimedEpochs[i]);
345         }
346     }
347 
348     function getUnclaimedEpochs(IFeeHandler feeHandler, address staker)
349         external
350         view
351         override
352         returns (uint256[] memory unclaimedEpochs)
353     {
354         uint256 currentEpoch = kyberDao.getCurrentEpochNumber();
355         uint256[] memory tempArray = new uint256[](currentEpoch);
356         uint256 i;
357         uint256 j;
358         // full array size is expected to be of reasonable length
359         // for the next 1-2 years
360         // we thus start iterating from epoch 0
361         for (i = 0; i < currentEpoch; i++) {
362             if (
363                 !feeHandler.hasClaimedReward(staker, i) &&
364                 kyberDao.getPastEpochRewardPercentageInPrecision(staker, i) != 0
365             ) {
366                 tempArray[j]= i;
367                 j++;
368             }
369         }
370         unclaimedEpochs = new uint256[](j);
371         for (i = 0; i < j; i++) {
372             unclaimedEpochs[i] = tempArray[i];
373         }
374     }
375 }