1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 import "@openzeppelin/contracts/utils/Pausable.sol";
8 import "@openzeppelin/contracts/math/SafeMath.sol";
9 import "../core/SafeOwnable.sol";
10 import "./BabyPoolV2.sol";
11 
12 contract BabyAutoPoolV2 is SafeOwnable, Pausable {
13     using SafeERC20 for IERC20;
14     using SafeMath for uint256;
15 
16     struct UserInfo {
17         uint256 shares;                 // number of shares for a user
18         uint256 lastDepositedTime;      // keeps track of deposited time for potential penalty
19         uint256 babyAtLastUserAction;   // keeps track of baby deposited at the last user action
20         uint256 lastUserActionTime;     // keeps track of the last user action time
21     }
22 
23     IERC20 public immutable token; 
24     BabyPoolV2 public immutable pool;
25     mapping(address => UserInfo) public userInfo;
26 
27     uint256 public totalShares;
28     uint256 public lastHarvestedTime;
29     address public admin;
30     address public treasury;
31 
32     uint256 public constant MAX_PERFORMANCE_FEE = 500;          // 5%
33     uint256 public constant MAX_CALL_FEE = 100;                 // 1%
34     uint256 public constant MAX_WITHDRAW_FEE = 100;             // 1%
35     uint256 public constant MAX_WITHDRAW_FEE_PERIOD = 72 hours; // 3 days
36 
37     uint256 public performanceFee = 200;                        // 2%
38     uint256 public callFee = 25;                                // 0.25%
39     uint256 public withdrawFee = 10;                            // 0.1%
40     uint256 public withdrawFeePeriod = 72 hours;                // 3 days
41 
42     event Deposit(address indexed sender, uint256 amount, uint256 shares, uint256 lastDepositedTime);
43     event Withdraw(address indexed sender, uint256 amount, uint256 shares);
44     event Harvest(address indexed sender, uint256 performanceFee, uint256 callFee);
45     event Pause();
46     event Unpause();
47 
48     constructor(BabyPoolV2 _pool, address _admin, address _treasury, address _owner) {
49         require(address(_pool) != address(0), "_pool should not be address(0)");
50         require(_admin != address(0), "_admin should not be address(0)");
51         require(_treasury != address(0), "_treasury should not be address(0)");
52         token = _pool.token();
53         pool = _pool;
54         admin = _admin;
55         treasury = _treasury;
56         // Infinite approve
57         _pool.token().safeApprove(address(_pool), uint256(-1));
58         if (_owner != address(0)) {
59             _transferOwnership(_owner);
60         }
61     }
62 
63     modifier onlyAdmin() {
64         require(msg.sender == admin, "admin: wut?");
65         _;
66     }
67 
68     function _isContract(address addr) internal view returns (bool) {
69         uint256 size;
70         assembly {
71             size := extcodesize(addr)
72         }
73         return size > 0;
74     }
75 
76     modifier notContract() {
77         require(!_isContract(msg.sender), "contract not allowed");
78         require(msg.sender == tx.origin, "proxy contract not allowed");
79         _;
80     }
81 
82     mapping(string => bool) private _methodStatus;
83     modifier nonReentrant(string memory methodName) {
84         require(!_methodStatus[methodName], "reentrant call");
85         _methodStatus[methodName] = true;
86         _;
87         _methodStatus[methodName] = false;
88     }
89 
90     function balanceOf() public view returns (uint256) {
91         (uint256 amount, ) = pool.userInfo(address(this));
92         return token.balanceOf(address(this)).add(amount);
93     }
94 
95     function available() public view returns (uint256) {
96         return token.balanceOf(address(this));
97     }
98 
99     function _earn() internal {
100         uint256 bal = available();
101         if (bal > 0) {
102             pool.enterStaking(bal);
103         }
104     }
105 
106     function deposit(uint256 _amount)
107         external
108         whenNotPaused
109         notContract
110         nonReentrant("deposit")
111     {
112         require(_amount > 0, "Nothing to deposit");
113 
114         uint256 pool = balanceOf();
115         token.safeTransferFrom(msg.sender, address(this), _amount);
116         uint256 currentShares = 0;
117         if (totalShares != 0) {
118             currentShares = (_amount.mul(totalShares)).div(pool);
119         } else {
120             currentShares = _amount;
121         }
122         UserInfo storage user = userInfo[msg.sender];
123         user.shares = user.shares.add(currentShares);
124         user.lastDepositedTime = block.timestamp;
125         totalShares = totalShares.add(currentShares);
126         user.babyAtLastUserAction = user.shares.mul(balanceOf()).div(
127             totalShares
128         );
129         user.lastUserActionTime = block.timestamp;
130         _earn();
131         emit Deposit(msg.sender, _amount, currentShares, block.timestamp);
132     }
133 
134     function withdraw(uint256 _shares)
135         public
136         notContract
137         nonReentrant("withdraw")
138     {
139         UserInfo storage user = userInfo[msg.sender];
140         require(_shares > 0, "Nothing to withdraw");
141         require(_shares <= user.shares, "Withdraw amount exceeds balance");
142 
143         uint256 currentAmount = (balanceOf().mul(_shares)).div(totalShares);
144         user.shares = user.shares.sub(_shares);
145         totalShares = totalShares.sub(_shares);
146 
147         uint256 bal = available();
148         if (bal < currentAmount) {
149             uint256 balWithdraw = currentAmount.sub(bal);
150             pool.leaveStaking(balWithdraw);
151             uint256 balAfter = available();
152             uint256 diff = balAfter.sub(bal);
153             if (diff < balWithdraw) {
154                 currentAmount = bal.add(diff);
155             }
156         }
157         if (block.timestamp < user.lastDepositedTime.add(withdrawFeePeriod)) {
158             uint256 currentWithdrawFee = currentAmount.mul(withdrawFee).div(10000);
159             token.safeTransfer(treasury, currentWithdrawFee);
160             currentAmount = currentAmount.sub(currentWithdrawFee);
161         }
162         if (user.shares > 0) {
163             user.babyAtLastUserAction = user.shares.mul(balanceOf()).div(totalShares);
164         } else {
165             user.babyAtLastUserAction = 0;
166         }
167         user.lastUserActionTime = block.timestamp;
168         token.safeTransfer(msg.sender, currentAmount);
169         emit Withdraw(msg.sender, currentAmount, _shares);
170     }
171 
172     function withdrawAll() external notContract {
173         withdraw(userInfo[msg.sender].shares);
174     }
175 
176     function harvest()
177         external
178         notContract
179         whenNotPaused
180         nonReentrant("harvest")
181     {
182         pool.leaveStaking(0);
183         uint256 bal = available();
184         uint256 currentPerformanceFee = bal.mul(performanceFee).div(10000);
185         token.safeTransfer(treasury, currentPerformanceFee);
186         uint256 currentCallFee = bal.mul(callFee).div(10000);
187         token.safeTransfer(msg.sender, currentCallFee);
188         _earn();
189         lastHarvestedTime = block.timestamp;
190         emit Harvest(msg.sender, currentPerformanceFee, currentCallFee);
191     }
192 
193     function setAdmin(address _admin) external onlyOwner {
194         require(_admin != address(0), "Cannot be zero address");
195         admin = _admin;
196     }
197 
198     function setTreasury(address _treasury) external onlyOwner {
199         require(_treasury != address(0), "Cannot be zero address");
200         treasury = _treasury;
201     }
202 
203     function setPerformanceFee(uint256 _performanceFee) external onlyAdmin {
204         require(
205             _performanceFee <= MAX_PERFORMANCE_FEE,
206             "performanceFee cannot be more than MAX_PERFORMANCE_FEE"
207         );
208         performanceFee = _performanceFee;
209     }
210 
211     function setCallFee(uint256 _callFee) external onlyAdmin {
212         require(
213             _callFee <= MAX_CALL_FEE,
214             "callFee cannot be more than MAX_CALL_FEE"
215         );
216         callFee = _callFee;
217     }
218 
219     function setWithdrawFee(uint256 _withdrawFee) external onlyAdmin {
220         require(
221             _withdrawFee <= MAX_WITHDRAW_FEE,
222             "withdrawFee cannot be more than MAX_WITHDRAW_FEE"
223         );
224         withdrawFee = _withdrawFee;
225     }
226 
227     function setWithdrawFeePeriod(uint256 _withdrawFeePeriod)
228         external
229         onlyAdmin
230     {
231         require(
232             _withdrawFeePeriod <= MAX_WITHDRAW_FEE_PERIOD,
233             "withdrawFeePeriod cannot be more than MAX_WITHDRAW_FEE_PERIOD"
234         );
235         withdrawFeePeriod = _withdrawFeePeriod;
236     }
237 
238     function emergencyWithdraw() external onlyAdmin {
239         pool.emergencyWithdraw();
240     }
241 
242     function inCaseTokensGetStuck(address _token) external onlyAdmin {
243         require(
244             _token != address(token),
245             "Token cannot be same as deposit token"
246         );
247         uint256 amount = IERC20(_token).balanceOf(address(this));
248         IERC20(_token).safeTransfer(msg.sender, amount);
249     }
250 
251     function pause() external onlyAdmin whenNotPaused {
252         _pause();
253         emit Pause();
254     }
255 
256     function unpause() external onlyAdmin whenPaused {
257         _unpause();
258         emit Unpause();
259     }
260 
261     function calculateHarvestBabyRewards() external view returns (uint256) {
262         uint256 amount = pool.pendingReward(address(this));
263         amount = amount.add(available());
264         uint256 currentCallFee = amount.mul(callFee).div(10000);
265         return currentCallFee;
266     }
267 
268     function calculateTotalPendingBabyRewards()
269         external
270         view
271         returns (uint256)
272     {
273         uint256 amount = pool.pendingReward(address(this));
274         amount = amount.add(available());
275         return amount;
276     }
277 
278     function getPricePerFullShare() external view returns (uint256) {
279         return totalShares == 0 ? 1e18 : balanceOf().mul(1e18).div(totalShares);
280     }
281 }
