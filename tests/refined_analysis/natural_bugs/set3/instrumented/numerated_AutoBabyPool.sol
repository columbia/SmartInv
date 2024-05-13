1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
7 import "@openzeppelin/contracts/access/Ownable.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import "@openzeppelin/contracts/utils/Pausable.sol";
10 
11 interface IMasterChef {
12     function deposit(uint256 _pid, uint256 _amount) external;
13 
14     function withdraw(uint256 _pid, uint256 _amount) external;
15 
16     function enterStaking(uint256 _amount) external;
17 
18     function leaveStaking(uint256 _amount) external;
19 
20     function pendingCake(uint256 _pid, address _user)
21         external
22         view
23         returns (uint256);
24 
25     function userInfo(uint256 _pid, address _user)
26         external
27         view
28         returns (uint256, uint256);
29 
30     function emergencyWithdraw(uint256 _pid) external;
31 }
32 
33 contract AutoBabyPool is Ownable, Pausable {
34     using SafeERC20 for IERC20;
35     using SafeMath for uint256;
36 
37     struct UserInfo {
38         uint256 shares; // number of shares for a user
39         uint256 lastDepositedTime; // keeps track of deposited time for potential penalty
40         uint256 cakeAtLastUserAction; // keeps track of cake deposited at the last user action
41         uint256 lastUserActionTime; // keeps track of the last user action time
42     }
43 
44     IERC20 public immutable token; // Cake token
45     IERC20 public immutable receiptToken; // Syrup token
46 
47     IMasterChef public immutable masterchef;
48 
49     mapping(address => UserInfo) public userInfo;
50 
51     uint256 public totalShares;
52     uint256 public lastHarvestedTime;
53     address public admin;
54     address public treasury;
55 
56     uint256 public constant MAX_PERFORMANCE_FEE = 500; // 5%
57     uint256 public constant MAX_CALL_FEE = 100; // 1%
58     uint256 public constant MAX_WITHDRAW_FEE = 100; // 1%
59     uint256 public constant MAX_WITHDRAW_FEE_PERIOD = 72 hours; // 3 days
60 
61     uint256 public performanceFee = 200; // 2%
62     uint256 public callFee = 25; // 0.25%
63     uint256 public withdrawFee = 10; // 0.1%
64     uint256 public withdrawFeePeriod = 72 hours; // 3 days
65 
66     event Deposit(
67         address indexed sender,
68         uint256 amount,
69         uint256 shares,
70         uint256 lastDepositedTime
71     );
72     event Withdraw(address indexed sender, uint256 amount, uint256 shares);
73     event Harvest(
74         address indexed sender,
75         uint256 performanceFee,
76         uint256 callFee
77     );
78     event Pause();
79     event Unpause();
80 
81     /**
82      * @notice Constructor
83      * @param _token: Cake token contract
84      * @param _receiptToken: Syrup token contract
85      * @param _masterchef: MasterChef contract
86      * @param _admin: address of the admin
87      * @param _treasury: address of the treasury (collects fees)
88      */
89     constructor(
90         IERC20 _token,
91         IERC20 _receiptToken,
92         IMasterChef _masterchef,
93         address _admin,
94         address _treasury
95     ) public {
96         require(
97             address(_token) != address(0),
98             "_token should not be address(0)"
99         );
100         require(
101             address(_receiptToken) != address(0),
102             "_receiptToken should not be address(0)"
103         );
104         require(
105             address(_masterchef) != address(0),
106             "_masterchef should not be address(0)"
107         );
108         require(_admin != address(0), "_admin should not be address(0)");
109         require(_treasury != address(0), "_treasury should not be address(0)");
110 
111         token = _token;
112         receiptToken = _receiptToken;
113         masterchef = _masterchef;
114         admin = _admin;
115         treasury = _treasury;
116 
117         // Infinite approve
118         IERC20(_token).safeApprove(address(_masterchef), uint256(-1));
119     }
120 
121     /**
122      * @notice Checks if the msg.sender is the admin address
123      */
124     modifier onlyAdmin() {
125         require(msg.sender == admin, "admin: wut?");
126         _;
127     }
128 
129     /**
130      * @notice Checks if the msg.sender is a contract or a proxy
131      */
132     modifier notContract() {
133         require(!_isContract(msg.sender), "contract not allowed");
134         require(msg.sender == tx.origin, "proxy contract not allowed");
135         _;
136     }
137 
138     /**
139      * @notice Deposits funds into the Cake Vault
140      * @dev Only possible when contract not paused.
141      * @param _amount: number of tokens to deposit (in CAKE)
142      */
143     function deposit(uint256 _amount)
144         external
145         whenNotPaused
146         notContract
147         nonReentrant("deposit")
148     {
149         require(_amount > 0, "Nothing to deposit");
150 
151         uint256 pool = balanceOf();
152         token.safeTransferFrom(msg.sender, address(this), _amount);
153         uint256 currentShares = 0;
154         if (totalShares != 0) {
155             currentShares = (_amount.mul(totalShares)).div(pool);
156         } else {
157             currentShares = _amount;
158         }
159         UserInfo storage user = userInfo[msg.sender];
160 
161         user.shares = user.shares.add(currentShares);
162         user.lastDepositedTime = block.timestamp;
163 
164         totalShares = totalShares.add(currentShares);
165 
166         user.cakeAtLastUserAction = user.shares.mul(balanceOf()).div(
167             totalShares
168         );
169         user.lastUserActionTime = block.timestamp;
170 
171         _earn();
172 
173         emit Deposit(msg.sender, _amount, currentShares, block.timestamp);
174     }
175 
176     /**
177      * @notice Withdraws all funds for a user
178      */
179     function withdrawAll() external notContract {
180         withdraw(userInfo[msg.sender].shares);
181     }
182 
183     /**
184      * @notice Reinvests CAKE tokens into MasterChef
185      * @dev Only possible when contract not paused.
186      */
187     function harvest()
188         external
189         notContract
190         whenNotPaused
191         nonReentrant("harvest")
192     {
193         IMasterChef(masterchef).leaveStaking(0);
194 
195         uint256 bal = available();
196         uint256 currentPerformanceFee = bal.mul(performanceFee).div(10000);
197         token.safeTransfer(treasury, currentPerformanceFee);
198 
199         uint256 currentCallFee = bal.mul(callFee).div(10000);
200         token.safeTransfer(msg.sender, currentCallFee);
201 
202         _earn();
203 
204         lastHarvestedTime = block.timestamp;
205 
206         emit Harvest(msg.sender, currentPerformanceFee, currentCallFee);
207     }
208 
209     /**
210      * @notice Sets admin address
211      * @dev Only callable by the contract owner.
212      */
213     function setAdmin(address _admin) external onlyOwner {
214         require(_admin != address(0), "Cannot be zero address");
215         admin = _admin;
216     }
217 
218     /**
219      * @notice Sets treasury address
220      * @dev Only callable by the contract owner.
221      */
222     function setTreasury(address _treasury) external onlyOwner {
223         require(_treasury != address(0), "Cannot be zero address");
224         treasury = _treasury;
225     }
226 
227     /**
228      * @notice Sets performance fee
229      * @dev Only callable by the contract admin.
230      */
231     function setPerformanceFee(uint256 _performanceFee) external onlyAdmin {
232         require(
233             _performanceFee <= MAX_PERFORMANCE_FEE,
234             "performanceFee cannot be more than MAX_PERFORMANCE_FEE"
235         );
236         performanceFee = _performanceFee;
237     }
238 
239     /**
240      * @notice Sets call fee
241      * @dev Only callable by the contract admin.
242      */
243     function setCallFee(uint256 _callFee) external onlyAdmin {
244         require(
245             _callFee <= MAX_CALL_FEE,
246             "callFee cannot be more than MAX_CALL_FEE"
247         );
248         callFee = _callFee;
249     }
250 
251     /**
252      * @notice Sets withdraw fee
253      * @dev Only callable by the contract admin.
254      */
255     function setWithdrawFee(uint256 _withdrawFee) external onlyAdmin {
256         require(
257             _withdrawFee <= MAX_WITHDRAW_FEE,
258             "withdrawFee cannot be more than MAX_WITHDRAW_FEE"
259         );
260         withdrawFee = _withdrawFee;
261     }
262 
263     /**
264      * @notice Sets withdraw fee period
265      * @dev Only callable by the contract admin.
266      */
267     function setWithdrawFeePeriod(uint256 _withdrawFeePeriod)
268         external
269         onlyAdmin
270     {
271         require(
272             _withdrawFeePeriod <= MAX_WITHDRAW_FEE_PERIOD,
273             "withdrawFeePeriod cannot be more than MAX_WITHDRAW_FEE_PERIOD"
274         );
275         withdrawFeePeriod = _withdrawFeePeriod;
276     }
277 
278     /**
279      * @notice Withdraws from MasterChef to Vault without caring about rewards.
280      * @dev EMERGENCY ONLY. Only callable by the contract admin.
281      */
282     function emergencyWithdraw() external onlyAdmin {
283         IMasterChef(masterchef).emergencyWithdraw(0);
284     }
285 
286     /**
287      * @notice Withdraw unexpected tokens sent to the Cake Vault
288      */
289     function inCaseTokensGetStuck(address _token) external onlyAdmin {
290         require(
291             _token != address(token),
292             "Token cannot be same as deposit token"
293         );
294         require(
295             _token != address(receiptToken),
296             "Token cannot be same as receipt token"
297         );
298 
299         uint256 amount = IERC20(_token).balanceOf(address(this));
300         IERC20(_token).safeTransfer(msg.sender, amount);
301     }
302 
303     /**
304      * @notice Triggers stopped state
305      * @dev Only possible when contract not paused.
306      */
307     function pause() external onlyAdmin whenNotPaused {
308         _pause();
309         emit Pause();
310     }
311 
312     /**
313      * @notice Returns to normal state
314      * @dev Only possible when contract is paused.
315      */
316     function unpause() external onlyAdmin whenPaused {
317         _unpause();
318         emit Unpause();
319     }
320 
321     /**
322      * @notice Calculates the expected harvest reward from third party
323      * @return Expected reward to collect in CAKE
324      */
325     function calculateHarvestCakeRewards() external view returns (uint256) {
326         uint256 amount = IMasterChef(masterchef).pendingCake(0, address(this));
327         amount = amount.add(available());
328         uint256 currentCallFee = amount.mul(callFee).div(10000);
329 
330         return currentCallFee;
331     }
332 
333     /**
334      * @notice Calculates the total pending rewards that can be restaked
335      * @return Returns total pending cake rewards
336      */
337     function calculateTotalPendingCakeRewards()
338         external
339         view
340         returns (uint256)
341     {
342         uint256 amount = IMasterChef(masterchef).pendingCake(0, address(this));
343         amount = amount.add(available());
344 
345         return amount;
346     }
347 
348     /**
349      * @notice Calculates the price per share
350      */
351     function getPricePerFullShare() external view returns (uint256) {
352         return totalShares == 0 ? 1e18 : balanceOf().mul(1e18).div(totalShares);
353     }
354 
355     /**
356      * @notice Withdraws from funds from the Cake Vault
357      * @param _shares: Number of shares to withdraw
358      */
359     function withdraw(uint256 _shares)
360         public
361         notContract
362         nonReentrant("withdraw")
363     {
364         UserInfo storage user = userInfo[msg.sender];
365         require(_shares > 0, "Nothing to withdraw");
366         require(_shares <= user.shares, "Withdraw amount exceeds balance");
367 
368         uint256 currentAmount = (balanceOf().mul(_shares)).div(totalShares);
369         user.shares = user.shares.sub(_shares);
370         totalShares = totalShares.sub(_shares);
371 
372         uint256 bal = available();
373         if (bal < currentAmount) {
374             uint256 balWithdraw = currentAmount.sub(bal);
375             IMasterChef(masterchef).leaveStaking(balWithdraw);
376             uint256 balAfter = available();
377             uint256 diff = balAfter.sub(bal);
378             if (diff < balWithdraw) {
379                 currentAmount = bal.add(diff);
380             }
381         }
382 
383         if (block.timestamp < user.lastDepositedTime.add(withdrawFeePeriod)) {
384             uint256 currentWithdrawFee = currentAmount.mul(withdrawFee).div(
385                 10000
386             );
387             token.safeTransfer(treasury, currentWithdrawFee);
388             currentAmount = currentAmount.sub(currentWithdrawFee);
389         }
390 
391         if (user.shares > 0) {
392             user.cakeAtLastUserAction = user.shares.mul(balanceOf()).div(
393                 totalShares
394             );
395         } else {
396             user.cakeAtLastUserAction = 0;
397         }
398 
399         user.lastUserActionTime = block.timestamp;
400 
401         token.safeTransfer(msg.sender, currentAmount);
402 
403         emit Withdraw(msg.sender, currentAmount, _shares);
404     }
405 
406     /**
407      * @notice Custom logic for how much the vault allows to be borrowed
408      * @dev The contract puts 100% of the tokens to work.
409      */
410     function available() public view returns (uint256) {
411         return token.balanceOf(address(this));
412     }
413 
414     /**
415      * @notice Calculates the total underlying tokens
416      * @dev It includes tokens held by the contract and held in MasterChef
417      */
418     function balanceOf() public view returns (uint256) {
419         (uint256 amount, ) = IMasterChef(masterchef).userInfo(0, address(this));
420         return token.balanceOf(address(this)).add(amount);
421     }
422 
423     /**
424      * @notice Deposits tokens into MasterChef to earn staking rewards
425      */
426     function _earn() internal {
427         uint256 bal = available();
428         if (bal > 0) {
429             IMasterChef(masterchef).enterStaking(bal);
430         }
431     }
432 
433     /**
434      * @notice Checks if address is a contract
435      * @dev It prevents contract from being targetted
436      */
437     function _isContract(address addr) internal view returns (bool) {
438         uint256 size;
439         assembly {
440             size := extcodesize(addr)
441         }
442         return size > 0;
443     }
444 
445     mapping(string => bool) private _methodStatus;
446     modifier nonReentrant(string memory methodName) {
447         require(!_methodStatus[methodName], "reentrant call");
448         _methodStatus[methodName] = true;
449         _;
450         _methodStatus[methodName] = false;
451     }
452 }
