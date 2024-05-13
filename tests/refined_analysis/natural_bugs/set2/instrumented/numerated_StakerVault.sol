1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
7 
8 import "../libraries/ScaledMath.sol";
9 import "../libraries/Errors.sol";
10 import "../libraries/Errors.sol";
11 import "../libraries/AddressProviderHelpers.sol";
12 
13 import "../interfaces/IStakerVault.sol";
14 import "../interfaces/IAddressProvider.sol";
15 import "../interfaces/IVault.sol";
16 import "../interfaces/IController.sol";
17 import "../interfaces/tokenomics/IRewardsGauge.sol";
18 import "../interfaces/IController.sol";
19 import "../interfaces/pool/ILiquidityPool.sol";
20 import "../interfaces/tokenomics/ILpGauge.sol";
21 import "../interfaces/IERC20Full.sol";
22 
23 import "./utils/Preparable.sol";
24 import "./Controller.sol";
25 import "./pool/LiquidityPool.sol";
26 import "./access/Authorization.sol";
27 import "./utils/Pausable.sol";
28 
29 /**
30  * @notice This contract handles staked tokens from Backd pools
31  * However, not that this is NOT an ERC-20 compliant contract and these
32  * tokens should never be integrated with any protocol assuming ERC-20 compliant
33  * tokens
34  * @dev When paused, allows only withdraw/unstake
35  */
36 contract StakerVault is IStakerVault, Authorization, Pausable, Initializable, Preparable {
37     using AddressProviderHelpers for IAddressProvider;
38     using SafeERC20 for IERC20;
39     using ScaledMath for uint256;
40 
41     bytes32 internal constant _LP_GAUGE = "lpGauge";
42 
43     IController public immutable controller;
44 
45     address public token;
46 
47     mapping(address => uint256) public balances;
48     mapping(address => uint256) public actionLockedBalances;
49 
50     mapping(address => mapping(address => uint256)) internal _allowances;
51 
52     // All the data fields required for the staking tracking
53     uint256 private _poolTotalStaked;
54 
55     mapping(address => bool) public strategies;
56     uint256 public strategiesTotalStaked;
57 
58     constructor(IController _controller)
59         Authorization(_controller.addressProvider().getRoleManager())
60     {
61         require(address(_controller) != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
62         controller = _controller;
63     }
64 
65     function initialize(address _token) external override initializer {
66         token = _token;
67     }
68 
69     function initializeLpGauge(address _lpGauge) external override onlyGovernance returns (bool) {
70         require(currentAddresses[_LP_GAUGE] == address(0), Error.ROLE_EXISTS);
71         _setConfig(_LP_GAUGE, _lpGauge);
72         controller.inflationManager().addGaugeForVault(token);
73         return true;
74     }
75 
76     function prepareLpGauge(address _lpGauge) external override onlyGovernance returns (bool) {
77         _prepare(_LP_GAUGE, _lpGauge);
78         return true;
79     }
80 
81     function executeLpGauge() external override onlyGovernance returns (bool) {
82         _executeAddress(_LP_GAUGE);
83         controller.inflationManager().addGaugeForVault(token);
84         return true;
85     }
86 
87     /**
88      * @notice Registers an address as a strategy to be excluded from token accumulation.
89      * @dev This should be used is a strategy deposits into a stakerVault and should not get gov. tokens.
90      * @return `true` if success.
91      */
92     function addStrategy(address strategy) external override returns (bool) {
93         require(msg.sender == address(controller.inflationManager()), Error.UNAUTHORIZED_ACCESS);
94         strategies[strategy] = true;
95         return true;
96     }
97 
98     /**
99      * @notice Transfer staked tokens to an account.
100      * @dev This is not an ERC20 transfer, as tokens are still owned by this contract, but fees get updated in the LP pool.
101      * @param account Address to transfer to.
102      * @param amount Amount to transfer.
103      * @return `true` if success.
104      */
105     function transfer(address account, uint256 amount) external override notPaused returns (bool) {
106         require(msg.sender != account, Error.SELF_TRANSFER_NOT_ALLOWED);
107         require(balances[msg.sender] >= amount, Error.INSUFFICIENT_BALANCE);
108 
109         ILiquidityPool pool = controller.addressProvider().getPoolForToken(token);
110         pool.handleLpTokenTransfer(msg.sender, account, amount);
111 
112         balances[msg.sender] -= amount;
113         balances[account] += amount;
114 
115         address lpGauge = currentAddresses[_LP_GAUGE];
116         if (lpGauge != address(0)) {
117             ILpGauge(lpGauge).userCheckpoint(msg.sender);
118             ILpGauge(lpGauge).userCheckpoint(account);
119         }
120 
121         emit Transfer(msg.sender, account, amount);
122         return true;
123     }
124 
125     /**
126      * @notice Transfer staked tokens from src to dst.
127      * @dev This is not an ERC20 transfer, as tokens are still owned by this contract, but fees get updated in the LP pool.
128      * @param src Address to transfer from.
129      * @param dst Address to transfer to.
130      * @param amount Amount to transfer.
131      * @return `true` if success.
132      */
133     function transferFrom(
134         address src,
135         address dst,
136         uint256 amount
137     ) external override notPaused returns (bool) {
138         /* Do not allow self transfers */
139         require(src != dst, Error.SAME_ADDRESS_NOT_ALLOWED);
140 
141         address spender = msg.sender;
142 
143         /* Get the allowance, infinite for the account owner */
144         uint256 startingAllowance = 0;
145         if (spender == src) {
146             startingAllowance = type(uint256).max;
147         } else {
148             startingAllowance = _allowances[src][spender];
149         }
150         require(startingAllowance >= amount, Error.INSUFFICIENT_BALANCE);
151 
152         uint256 srcTokens = balances[src];
153         require(srcTokens >= amount, Error.INSUFFICIENT_BALANCE);
154 
155         address lpGauge = currentAddresses[_LP_GAUGE];
156         if (lpGauge != address(0)) {
157             ILpGauge(lpGauge).userCheckpoint(src);
158             ILpGauge(lpGauge).userCheckpoint(dst);
159         }
160         ILiquidityPool pool = controller.addressProvider().getPoolForToken(token);
161         pool.handleLpTokenTransfer(src, dst, amount);
162 
163         uint256 allowanceNew = startingAllowance - amount;
164         uint256 srcTokensNew = srcTokens - amount;
165         uint256 dstTokensNew = balances[dst] + amount;
166 
167         /* Update token balances */
168         balances[src] = srcTokensNew;
169         balances[dst] = dstTokensNew;
170 
171         /* Update allowance if necessary */
172         if (startingAllowance != type(uint256).max) {
173             _allowances[src][spender] = allowanceNew;
174         }
175         emit Transfer(src, dst, amount);
176         return true;
177     }
178 
179     /**
180      * @notice Approve staked tokens for spender.
181      * @param spender Address to approve tokens for.
182      * @param amount Amount to approve.
183      * @return `true` if success.
184      */
185     function approve(address spender, uint256 amount) external override notPaused returns (bool) {
186         address src = msg.sender;
187         _allowances[src][spender] = amount;
188         emit Approval(src, spender, amount);
189         return true;
190     }
191 
192     /**
193      * @notice If an action is registered and stakes funds, this updates the actionLockedBalances for the user.
194      * @param account Address that registered the action.
195      * @param amount Amount staked by the action.
196      * @return `true` if success.
197      */
198     function increaseActionLockedBalance(address account, uint256 amount)
199         external
200         override
201         returns (bool)
202     {
203         require(controller.addressProvider().isAction(msg.sender), Error.UNAUTHORIZED_ACCESS);
204 
205         address lpGauge = currentAddresses[_LP_GAUGE];
206         if (lpGauge != address(0)) {
207             ILpGauge(lpGauge).userCheckpoint(account);
208         }
209         actionLockedBalances[account] += amount;
210         return true;
211     }
212 
213     /**
214      * @notice If an action is executed/reset, this updates the actionLockedBalances for the user.
215      * @param account Address that registered the action.
216      * @param amount Amount executed/reset by the action.
217      * @return `true` if success.
218      */
219     function decreaseActionLockedBalance(address account, uint256 amount)
220         external
221         override
222         returns (bool)
223     {
224         require(controller.addressProvider().isAction(msg.sender), Error.UNAUTHORIZED_ACCESS);
225 
226         address lpGauge = currentAddresses[_LP_GAUGE];
227         if (lpGauge != address(0)) {
228             ILpGauge(lpGauge).userCheckpoint(account);
229         }
230         if (actionLockedBalances[account] > amount) {
231             actionLockedBalances[account] -= amount;
232         } else {
233             actionLockedBalances[account] = 0;
234         }
235         return true;
236     }
237 
238     function poolCheckpoint() external override returns (bool) {
239         if (currentAddresses[_LP_GAUGE] != address(0)) {
240             return ILpGauge(currentAddresses[_LP_GAUGE]).poolCheckpoint();
241         }
242         return false;
243     }
244 
245     function getLpGauge() external view override returns (address) {
246         return currentAddresses[_LP_GAUGE];
247     }
248 
249     function isStrategy(address user) external view override returns (bool) {
250         return strategies[user];
251     }
252 
253     /**
254      * @notice Get the total amount of tokens that are staked by actions
255      * @return Total amount staked by actions
256      */
257     function getStakedByActions() external view override returns (uint256) {
258         address[] memory actions = controller.addressProvider().allActions();
259         uint256 total;
260         for (uint256 i = 0; i < actions.length; i++) {
261             total += balances[actions[i]];
262         }
263         return total;
264     }
265 
266     function allowance(address owner, address spender) external view override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     function balanceOf(address account) external view override returns (uint256) {
271         return balances[account];
272     }
273 
274     function getPoolTotalStaked() external view override returns (uint256) {
275         return _poolTotalStaked;
276     }
277 
278     /**
279      * @notice Returns the total balance in the staker vault, including that locked in positions.
280      * @param account Account to query balance for.
281      * @return Total balance in staker vault for account.
282      */
283     function stakedAndActionLockedBalanceOf(address account)
284         external
285         view
286         override
287         returns (uint256)
288     {
289         return balances[account] + actionLockedBalances[account];
290     }
291 
292     function actionLockedBalanceOf(address account) external view override returns (uint256) {
293         return actionLockedBalances[account];
294     }
295 
296     function decimals() external view returns (uint8) {
297         return IERC20Full(token).decimals();
298     }
299 
300     function getToken() external view override returns (address) {
301         return token;
302     }
303 
304     function unstake(uint256 amount) public override returns (bool) {
305         return unstakeFor(msg.sender, msg.sender, amount);
306     }
307 
308     /**
309      * @notice Stake an amount of vault tokens.
310      * @param amount Amount of token to stake.
311      * @return `true` if success.
312      */
313     function stake(uint256 amount) public override returns (bool) {
314         return stakeFor(msg.sender, amount);
315     }
316 
317     /**
318      * @notice Stake amount of vault token on behalf of another account.
319      * @param account Account for which tokens will be staked.
320      * @param amount Amount of token to stake.
321      * @return `true` if success.
322      */
323     function stakeFor(address account, uint256 amount) public override notPaused returns (bool) {
324         require(IERC20(token).balanceOf(msg.sender) >= amount, Error.INSUFFICIENT_BALANCE);
325 
326         address lpGauge = currentAddresses[_LP_GAUGE];
327         if (lpGauge != address(0)) {
328             ILpGauge(lpGauge).userCheckpoint(account);
329         }
330 
331         uint256 oldBal = IERC20(token).balanceOf(address(this));
332 
333         if (msg.sender != account) {
334             ILiquidityPool pool = controller.addressProvider().getPoolForToken(token);
335             pool.handleLpTokenTransfer(msg.sender, account, amount);
336         }
337 
338         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
339         uint256 staked = IERC20(token).balanceOf(address(this)) - oldBal;
340         require(staked == amount, Error.INVALID_AMOUNT);
341         balances[account] += staked;
342 
343         if (strategies[account]) {
344             strategiesTotalStaked += staked;
345         } else {
346             _poolTotalStaked += staked;
347         }
348         emit Staked(account, amount);
349         return true;
350     }
351 
352     /**
353      * @notice Unstake tokens on behalf of another account.
354      * @dev Needs to be approved.
355      * @param src Account for which tokens will be unstaked.
356      * @param dst Account receiving the tokens.
357      * @param amount Amount of token to unstake/receive.
358      * @return `true` if success.
359      */
360     function unstakeFor(
361         address src,
362         address dst,
363         uint256 amount
364     ) public override returns (bool) {
365         ILiquidityPool pool = controller.addressProvider().getPoolForToken(token);
366         uint256 allowance_ = _allowances[src][msg.sender];
367         require(
368             src == msg.sender || allowance_ >= amount || address(pool) == msg.sender,
369             Error.UNAUTHORIZED_ACCESS
370         );
371         require(balances[src] >= amount, Error.INSUFFICIENT_BALANCE);
372         address lpGauge = currentAddresses[_LP_GAUGE];
373         if (lpGauge != address(0)) {
374             ILpGauge(lpGauge).userCheckpoint(src);
375         }
376         uint256 oldBal = IERC20(token).balanceOf(address(this));
377 
378         if (src != dst) {
379             pool.handleLpTokenTransfer(src, dst, amount);
380         }
381 
382         IERC20(token).safeTransfer(dst, amount);
383 
384         uint256 unstaked = oldBal - IERC20(token).balanceOf(address(this));
385 
386         if (src != msg.sender && allowance_ != type(uint256).max && address(pool) != msg.sender) {
387             // update allowance
388             _allowances[src][msg.sender] -= unstaked;
389         }
390         balances[src] -= unstaked;
391 
392         if (strategies[src]) {
393             strategiesTotalStaked -= unstaked;
394         } else {
395             _poolTotalStaked -= unstaked;
396         }
397         emit Unstaked(src, amount);
398         return true;
399     }
400 
401     function _isAuthorizedToPause(address account) internal view override returns (bool) {
402         return _roleManager().hasRole(Roles.GOVERNANCE, account);
403     }
404 }
