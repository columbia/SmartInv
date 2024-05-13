1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 import {BoringOwnable} from "./utils/BoringOwnable.sol";
5 import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
8 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
9 import "@openzeppelin-upgradeable/contracts/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
10 import "@openzeppelin-upgradeable/contracts/token/ERC20/ERC20Upgradeable.sol";
11 import {IVault, IAsset} from "interfaces/balancer/IVault.sol";
12 import "interfaces/balancer/IWeightedPool.sol";
13 import "interfaces/balancer/IPriceOracle.sol";
14 
15 contract sNOTE is ERC20Upgradeable, ERC20VotesUpgradeable, BoringOwnable, UUPSUpgradeable, ReentrancyGuard {
16     using SafeERC20 for ERC20;
17 
18     IVault public immutable BALANCER_VAULT;
19     ERC20 public immutable NOTE;
20     ERC20 public immutable BALANCER_POOL_TOKEN;
21     ERC20 public immutable WETH;
22     bytes32 public immutable NOTE_ETH_POOL_ID;
23 
24     /// @notice Maximum shortfall withdraw of 50%
25     uint256 public constant MAX_SHORTFALL_WITHDRAW = 50;
26     uint256 public constant BPT_TOKEN_PRECISION = 1e18;
27 
28     /// @notice Redemption window in seconds
29     uint256 public constant REDEEM_WINDOW_SECONDS = 3 days;
30 
31     /// @notice Tracks an account's redemption window
32     struct AccountCoolDown {
33         uint32 redeemWindowBegin;
34         uint32 redeemWindowEnd;
35     }
36 
37     /// @notice Number of seconds that need to pass before sNOTE can be redeemed
38     uint32 public coolDownTimeInSeconds;
39 
40     /// @notice Mapping between sNOTE holders and their current cooldown status
41     mapping(address => AccountCoolDown) public accountCoolDown;
42 
43     /// @notice Emitted when a cool down begins
44     event CoolDownStarted(address account, uint256 redeemWindowBegin, uint256 redeemWindowEnd);
45 
46     /// @notice Emitted when a cool down ends
47     event CoolDownEnded(address account);
48 
49     /// @notice Emitted when cool down time is updated
50     event GlobalCoolDownUpdated(uint256 newCoolDownTimeSeconds);
51 
52     /// @notice Constructor sets immutable contract addresses
53     constructor(
54         IVault _balancerVault,
55         bytes32 _noteETHPoolId,
56         ERC20 _note,
57         ERC20 _weth
58     ) initializer { 
59         // Validate that the pool exists
60         (address poolAddress, /* */) = _balancerVault.getPool(_noteETHPoolId);
61         require(poolAddress != address(0));
62 
63         WETH = _weth;
64         NOTE = _note;
65         NOTE_ETH_POOL_ID = _noteETHPoolId;
66         BALANCER_VAULT = _balancerVault;
67         BALANCER_POOL_TOKEN = ERC20(poolAddress);
68     }
69 
70     /// @notice Initializes sNOTE ERC20 metadata and owner
71     function initialize(
72         address _owner,
73         uint32 _coolDownTimeInSeconds
74     ) external initializer {
75         string memory _name = "Staked NOTE";
76         string memory _symbol = "sNOTE";
77         __ERC20_init(_name, _symbol);
78         __ERC20Permit_init(_name);
79 
80         coolDownTimeInSeconds = _coolDownTimeInSeconds;
81         owner = _owner;
82         NOTE.safeApprove(address(BALANCER_VAULT), type(uint256).max);
83         WETH.safeApprove(address(BALANCER_VAULT), type(uint256).max);
84 
85         emit OwnershipTransferred(address(0), _owner);
86     }
87 
88     /** Governance Methods **/
89 
90     /// @notice Authorizes the DAO to upgrade this contract
91     function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
92 
93     /// @notice Updates the required cooldown time to redeem
94     function setCoolDownTime(uint32 _coolDownTimeInSeconds) external onlyOwner {
95         coolDownTimeInSeconds = _coolDownTimeInSeconds;
96         emit GlobalCoolDownUpdated(_coolDownTimeInSeconds);
97     }
98 
99     /// @notice Allows the DAO to extract up to 50% of the BPT tokens during a collateral shortfall event
100     function extractTokensForCollateralShortfall(uint256 requestedWithdraw) external nonReentrant onlyOwner {
101         uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
102         uint256 maxBPTWithdraw = (bptBalance * MAX_SHORTFALL_WITHDRAW) / 100;
103         // Do not allow a withdraw of more than the MAX_SHORTFALL_WITHDRAW percentage. Specifically don't
104         // revert here since there may be a delay between when governance issues the token amount and when
105         // the withdraw actually occurs.
106         uint256 bptExitAmount = requestedWithdraw > maxBPTWithdraw ? maxBPTWithdraw : requestedWithdraw;
107 
108         IAsset[] memory assets = new IAsset[](2);
109         assets[0] = IAsset(address(WETH));
110         assets[1] = IAsset(address(NOTE));
111         uint256[] memory minAmountsOut = new uint256[](2);
112         minAmountsOut[0] = 0;
113         minAmountsOut[1] = 0;
114 
115         BALANCER_VAULT.exitPool(
116             NOTE_ETH_POOL_ID,
117             address(this),
118             payable(owner), // Owner will receive the NOTE and WETH
119             IVault.ExitPoolRequest(
120                 assets,
121                 minAmountsOut,
122                 abi.encode(
123                     IVault.ExitKind.EXACT_BPT_IN_FOR_TOKENS_OUT,
124                     bptExitAmount
125                 ),
126                 false // Don't use internal balances
127             )
128         );
129     }
130 
131     /// @notice Allows the DAO to set the swap fee on the BPT
132     function setSwapFeePercentage(uint256 swapFeePercentage) external onlyOwner {
133         IWeightedPool(address(BALANCER_POOL_TOKEN)).setSwapFeePercentage(swapFeePercentage);
134     }
135 
136     /** User Methods **/
137 
138     /// @notice Mints sNOTE from the underlying BPT token.
139     /// @param bptAmount is the amount of BPT to transfer from the msg.sender.
140     function mintFromBPT(uint256 bptAmount) external nonReentrant {
141         // _mint logic requires that tokens are transferred first
142         BALANCER_POOL_TOKEN.safeTransferFrom(msg.sender, address(this), bptAmount);
143         _mint(msg.sender, bptAmount);
144     }
145 
146     /// @notice Mints sNOTE from some amount of NOTE tokens.
147     /// @param noteAmount amount of NOTE to transfer into the sNOTE contract
148     function mintFromNOTE(uint256 noteAmount) external nonReentrant {
149         // Transfer the NOTE balance into sNOTE first
150         NOTE.safeTransferFrom(msg.sender, address(this), noteAmount);
151 
152         IAsset[] memory assets = new IAsset[](2);
153         assets[0] = IAsset(address(0));
154         assets[1] = IAsset(address(NOTE));
155         uint256[] memory maxAmountsIn = new uint256[](2);
156         maxAmountsIn[0] = 0;
157         maxAmountsIn[1] = noteAmount;
158 
159         _mintFromAssets(assets, maxAmountsIn);
160     }
161 
162     /// @notice Mints sNOTE from some amount of ETH
163     function mintFromETH() payable external nonReentrant {
164         IAsset[] memory assets = new IAsset[](2);
165         assets[0] = IAsset(address(0));
166         assets[1] = IAsset(address(NOTE));
167         uint256[] memory maxAmountsIn = new uint256[](2);
168         maxAmountsIn[0] = msg.value;
169         maxAmountsIn[1] = 0;
170 
171         _mintFromAssets(assets, maxAmountsIn);
172     }
173 
174     /// @notice Mints sNOTE from some amount of WETH
175     /// @param wethAmount amount of WETH to transfer into the sNOTE contract
176     function mintFromWETH(uint256 wethAmount) external nonReentrant {
177         // Transfer the NOTE balance into sNOTE first
178         WETH.safeTransferFrom(msg.sender, address(this), wethAmount);
179 
180         IAsset[] memory assets = new IAsset[](2);
181         assets[0] = IAsset(address(WETH));
182         assets[1] = IAsset(address(NOTE));
183         uint256[] memory maxAmountsIn = new uint256[](2);
184         maxAmountsIn[0] = wethAmount;
185         maxAmountsIn[1] = 0;
186 
187         _mintFromAssets(assets, maxAmountsIn);
188     }
189 
190     function _mintFromAssets(IAsset[] memory assets, uint256[] memory maxAmountsIn) internal {
191         uint256 bptBefore = BALANCER_POOL_TOKEN.balanceOf(address(this));
192         // Set msgValue when joining via ETH
193         uint256 msgValue = assets[0] == IAsset(address(0)) ? maxAmountsIn[0] : 0;
194 
195         BALANCER_VAULT.joinPool{value: msgValue}(
196             NOTE_ETH_POOL_ID,
197             address(this),
198             address(this), // sNOTE will receive the BPT
199             IVault.JoinPoolRequest(
200                 assets,
201                 maxAmountsIn,
202                 abi.encode(
203                     IVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
204                     maxAmountsIn,
205                     0 // Accept however much BPT the pool will give us
206                 ),
207                 false // Don't use internal balances
208             )
209         );
210         uint256 bptAfter = BALANCER_POOL_TOKEN.balanceOf(address(this));
211 
212         // Balancer pool token amounts must increase
213         _mint(msg.sender, bptAfter - bptBefore);
214     }
215 
216     /// @notice Begins a cool down period for the sender, this is required to redeem tokens
217     function startCoolDown() external {
218         // Cannot start a cool down if there is already one in effect
219         _requireAccountNotInCoolDown(msg.sender);
220         uint256 redeemWindowBegin = block.timestamp + coolDownTimeInSeconds;
221         uint256 redeemWindowEnd = redeemWindowBegin + REDEEM_WINDOW_SECONDS;
222 
223         accountCoolDown[msg.sender] = AccountCoolDown(_safe32(redeemWindowBegin), _safe32(redeemWindowEnd));
224 
225         emit CoolDownStarted(msg.sender, redeemWindowBegin, redeemWindowEnd);
226     }
227 
228     /// @notice Stops a cool down for the sender
229     function stopCoolDown() public {
230         // Reset the cool down back to zero so that the account must initiate it again to redeem
231         delete accountCoolDown[msg.sender];
232         emit CoolDownEnded(msg.sender);
233     }
234 
235     /// @notice Redeems some amount of sNOTE to underlying BPT tokens (which can then be sold for
236     /// NOTE or ETH). An account must have passed its cool down expiration before they can redeem
237     /// @param sNOTEAmount amount of sNOTE to redeem
238     function redeem(uint256 sNOTEAmount) external nonReentrant {
239         AccountCoolDown memory coolDown = accountCoolDown[msg.sender];
240         require(sNOTEAmount <= balanceOf(msg.sender), "Insufficient balance");
241         require(
242             coolDown.redeemWindowBegin != 0 &&
243             coolDown.redeemWindowBegin < block.timestamp &&
244             block.timestamp < coolDown.redeemWindowEnd,
245             "Not in Redemption Window"
246         );
247 
248         uint256 bptToRedeem = getPoolTokenShare(sNOTEAmount);
249         _burn(msg.sender, bptToRedeem);
250 
251         BALANCER_POOL_TOKEN.safeTransfer(msg.sender, bptToRedeem);
252     }
253 
254     /** External View Methods **/
255 
256     /// @notice Returns how many Balancer pool tokens an sNOTE token amount has a claim on
257     function getPoolTokenShare(uint256 sNOTEAmount) public view returns (uint256 bptClaim) {
258         uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
259         // BPT and sNOTE are both in 18 decimal precision so no conversion required
260         return (bptBalance * sNOTEAmount) / totalSupply();
261     }
262 
263     /// @notice Returns the pool token share of a specific account
264     function poolTokenShareOf(address account) public view returns (uint256 bptClaim) {
265         return getPoolTokenShare(balanceOf(account));
266     }
267 
268     /// @notice Calculates voting power for a given amount of sNOTE
269     /// @param sNOTEAmount amount of sNOTE to calculate voting power for
270     /// @return corresponding NOTE voting power
271     function getVotingPower(uint256 sNOTEAmount) public view returns (uint256) {
272         // Gets the BPT token price (in ETH)
273         uint256 bptPrice = IPriceOracle(address(BALANCER_POOL_TOKEN)).getLatest(IPriceOracle.Variable.BPT_PRICE);
274         // Gets the NOTE token price (in ETH)
275         uint256 notePrice = IPriceOracle(address(BALANCER_POOL_TOKEN)).getLatest(IPriceOracle.Variable.PAIR_PRICE);
276         
277         // Since both bptPrice and notePrice are denominated in ETH, we can use
278         // this formula to calculate noteAmount
279         // bptBalance * bptPrice = notePrice * noteAmount
280         // noteAmount = bptPrice/notePrice * bptBalance
281         uint256 priceRatio = bptPrice * 1e18 / notePrice;
282         uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
283 
284         // Amount_note = Price_NOTE_per_BPT * BPT_supply * 80% (80/20 pool)
285         uint256 noteAmount = priceRatio * bptBalance * 80 / 100;
286 
287         // Reduce precision down to 1e8 (NOTE token)
288         // priceRatio and bptBalance are both 1e18 (1e36 total)
289         // we divide by 1e28 to get to 1e8
290         noteAmount /= 1e28;
291 
292         return (noteAmount * sNOTEAmount) / totalSupply();
293     }
294 
295     /// @notice Calculates voting power for a given account
296     /// @param account a given sNOTE holding account
297     /// @return corresponding NOTE voting power
298     function votingPowerOf(address account) external view returns (uint256) {
299         return getVotingPower(balanceOf(account));
300     }
301 
302     /** Internal Methods **/
303 
304     function _requireAccountNotInCoolDown(address account) internal view {
305         AccountCoolDown memory coolDown = accountCoolDown[account];
306         // An account is in cool down if the redeem window has begun and the window end has not
307         // passed yet.
308         bool isInCoolDown = (0 < coolDown.redeemWindowBegin && block.timestamp < coolDown.redeemWindowEnd);
309         require(!isInCoolDown, "Account in Cool Down");
310     }
311 
312     /// @notice Burns sNOTE tokens when they are redeemed
313     /// @param account account to burn tokens on
314     /// @param bptToRedeem the number of BPT tokens being redeemed by the account
315     function _burn(address account, uint256 bptToRedeem) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
316         uint256 poolTokenShare = poolTokenShareOf(account);
317         require(bptToRedeem <= poolTokenShare, "Invalid Redeem Amount");
318 
319         // Burns the portion of the sNOTE corresponding to the bptToRedeem
320         uint256 sNOTEToBurn = balanceOf(account) * bptToRedeem / poolTokenShare;
321         // Handles event emission, balance update and total supply update
322         super._burn(account, sNOTEToBurn);
323     }
324 
325     /// @notice Mints sNOTE tokens given a bptAmount
326     /// @param account account to mint tokens to
327     /// @param bptAmount the number of BPT tokens being minted by the account
328     function _mint(address account, uint256 bptAmount) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
329         // Cannot mint if a cooldown is already in effect. If an account mints during a cool down period then they will
330         // be able to redeem the tokens immediately, bypassing the cool down.
331         _requireAccountNotInCoolDown(account);
332 
333         // Immediately after minting, we need to satisfy the equality:
334         // (sNOTEToMint * bptBalance) / (totalSupply + sNOTEToMint) == bptAmount
335 
336         // Rearranging to get sNOTEToMint on one side:
337         // (sNOTEToMint * bptBalance) = (totalSupply + sNOTEToMint) * bptAmount
338         // (sNOTEToMint * bptBalance) = totalSupply * bptAmount + sNOTEToMint * bptAmount
339         // (sNOTEToMint * bptBalance) - (sNOTEToMint * bptAmount) = totalSupply * bptAmount
340         // sNOTEToMint * (bptBalance - bptAmount) = totalSupply * bptAmount
341         // sNOTEToMint = (totalSupply * bptAmount) / (bptBalance - bptAmount)
342 
343         // NOTE: at this point the BPT has already been transferred into the sNOTE contract, so this
344         // bptBalance amount includes bptAmount.
345         uint256 bptBalance = BALANCER_POOL_TOKEN.balanceOf(address(this));
346         uint256 _totalSupply = totalSupply();
347         uint256 sNOTEToMint;
348         if (_totalSupply == 0) {
349             sNOTEToMint = bptAmount;
350         } else {
351             sNOTEToMint = (_totalSupply * bptAmount) / (bptBalance - bptAmount);
352         }
353 
354         // Handles event emission, balance update and total supply update
355         super._mint(account, sNOTEToMint);
356     }
357 
358     function _beforeTokenTransfer(
359         address from,
360         address to,
361         uint256 amount
362     ) internal override(ERC20Upgradeable) {
363         // Cannot send or receive tokens if a cool down is in effect or else accounts
364         // can bypass the cool down. It's not clear if sending tokens can be used to bypass
365         // the cool down but we restrict it here anyway, there's no clear use case for sending
366         // sNOTE tokens during a cool down.
367         if (to != address(0)) {
368             // Run these checks only when we are not burning tokens. (OZ ERC20 does not allow transfers
369             // to address(0), to == address(0) only when _burn is called).
370             _requireAccountNotInCoolDown(from);
371             _requireAccountNotInCoolDown(to);
372         }
373 
374         super._beforeTokenTransfer(from, to, amount);
375     }
376 
377     function _afterTokenTransfer(
378         address from,
379         address to,
380         uint256 amount
381     ) internal override(ERC20Upgradeable, ERC20VotesUpgradeable) {
382         // Moves sNOTE checkpoints
383         super._afterTokenTransfer(from, to, amount);
384     }
385 
386     function _safe32(uint256 x) internal pure returns (uint32) {
387         require (x <= type(uint32).max);
388         return uint32(x);
389     }
390 }