1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./../pcv/PCVDeposit.sol";
5 import "./../fei/minter/RateLimitedMinter.sol";
6 import "./IPegStabilityModule.sol";
7 import "./../refs/OracleRef.sol";
8 import "../Constants.sol";
9 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
10 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
11 
12 contract PegStabilityModule is IPegStabilityModule, RateLimitedMinter, OracleRef, PCVDeposit, ReentrancyGuard {
13     using Decimal for Decimal.D256;
14     using SafeCast for *;
15     using SafeERC20 for IERC20;
16 
17     /// @notice the fee in basis points for selling asset into FEI
18     uint256 public override mintFeeBasisPoints;
19 
20     /// @notice the fee in basis points for buying the asset for FEI
21     uint256 public override redeemFeeBasisPoints;
22 
23     /// @notice the amount of reserves to be held for redemptions
24     uint256 public override reservesThreshold;
25 
26     /// @notice the PCV deposit target
27     IPCVDeposit public override surplusTarget;
28 
29     /// @notice the token this PSM will exchange for FEI
30     /// This token will be set to WETH9 if the bonding curve accepts eth
31     IERC20 public immutable override underlyingToken;
32 
33     /// @notice the max mint and redeem fee in basis points
34     /// Governance can change this fee
35     uint256 public override MAX_FEE = 300;
36 
37     /// @notice boolean switch that indicates whether redemptions are paused
38     bool public redeemPaused;
39 
40     /// @notice event that is emitted when redemptions are paused
41     event RedemptionsPaused(address account);
42 
43     /// @notice event that is emitted when redemptions are unpaused
44     event RedemptionsUnpaused(address account);
45 
46     /// @notice boolean switch that indicates whether minting is paused
47     bool public mintPaused;
48 
49     /// @notice event that is emitted when minting is paused
50     event MintingPaused(address account);
51 
52     /// @notice event that is emitted when minting is unpaused
53     event MintingUnpaused(address account);
54 
55     /// @notice struct for passing constructor parameters related to OracleRef
56     struct OracleParams {
57         address coreAddress;
58         address oracleAddress;
59         address backupOracle;
60         int256 decimalsNormalizer;
61         bool doInvert;
62     }
63 
64     /// @notice constructor
65     /// @param params PSM constructor parameter struct
66     constructor(
67         OracleParams memory params,
68         uint256 _mintFeeBasisPoints,
69         uint256 _redeemFeeBasisPoints,
70         uint256 _reservesThreshold,
71         uint256 _feiLimitPerSecond,
72         uint256 _mintingBufferCap,
73         IERC20 _underlyingToken,
74         IPCVDeposit _surplusTarget
75     )
76         OracleRef(
77             params.coreAddress,
78             params.oracleAddress,
79             params.backupOracle,
80             params.decimalsNormalizer,
81             params.doInvert
82         )
83         /// rate limited minter passes false as the last param as there can be no partial mints
84         RateLimitedMinter(_feiLimitPerSecond, _mintingBufferCap, false)
85     {
86         underlyingToken = _underlyingToken;
87 
88         _setReservesThreshold(_reservesThreshold);
89         _setMintFee(_mintFeeBasisPoints);
90         _setRedeemFee(_redeemFeeBasisPoints);
91         _setSurplusTarget(_surplusTarget);
92         _setContractAdminRole(keccak256("PSM_ADMIN_ROLE"));
93     }
94 
95     /// @notice modifier that allows execution when redemptions are not paused
96     modifier whileRedemptionsNotPaused() {
97         require(!redeemPaused, "PegStabilityModule: Redeem paused");
98         _;
99     }
100 
101     /// @notice modifier that allows execution when minting is not paused
102     modifier whileMintingNotPaused() {
103         require(!mintPaused, "PegStabilityModule: Minting paused");
104         _;
105     }
106 
107     /// @notice set secondary pausable methods to paused
108     function pauseRedeem() external isGovernorOrGuardianOrAdmin {
109         redeemPaused = true;
110         emit RedemptionsPaused(msg.sender);
111     }
112 
113     /// @notice set secondary pausable methods to unpaused
114     function unpauseRedeem() external isGovernorOrGuardianOrAdmin {
115         redeemPaused = false;
116         emit RedemptionsUnpaused(msg.sender);
117     }
118 
119     /// @notice set secondary pausable methods to paused
120     function pauseMint() external isGovernorOrGuardianOrAdmin {
121         mintPaused = true;
122         emit MintingPaused(msg.sender);
123     }
124 
125     /// @notice set secondary pausable methods to unpaused
126     function unpauseMint() external isGovernorOrGuardianOrAdmin {
127         mintPaused = false;
128         emit MintingUnpaused(msg.sender);
129     }
130 
131     /// @notice withdraw assets from PSM to an external address
132     function withdraw(address to, uint256 amount) external virtual override onlyPCVController {
133         _withdrawERC20(address(underlyingToken), to, amount);
134     }
135 
136     /// @notice set the mint fee vs oracle price in basis point terms
137     function setMintFee(uint256 newMintFeeBasisPoints) external override onlyGovernorOrAdmin {
138         _setMintFee(newMintFeeBasisPoints);
139     }
140 
141     /// @notice set the redemption fee vs oracle price in basis point terms
142     function setRedeemFee(uint256 newRedeemFeeBasisPoints) external override onlyGovernorOrAdmin {
143         _setRedeemFee(newRedeemFeeBasisPoints);
144     }
145 
146     /// @notice set the ideal amount of reserves for the contract to hold for redemptions
147     function setReservesThreshold(uint256 newReservesThreshold) external override onlyGovernorOrAdmin {
148         _setReservesThreshold(newReservesThreshold);
149     }
150 
151     /// @notice set the target for sending surplus reserves
152     function setSurplusTarget(IPCVDeposit newTarget) external override onlyGovernorOrAdmin {
153         _setSurplusTarget(newTarget);
154     }
155 
156     /// @notice set the mint fee vs oracle price in basis point terms
157     function _setMintFee(uint256 newMintFeeBasisPoints) internal {
158         require(newMintFeeBasisPoints <= MAX_FEE, "PegStabilityModule: Mint fee exceeds max fee");
159         uint256 _oldMintFee = mintFeeBasisPoints;
160         mintFeeBasisPoints = newMintFeeBasisPoints;
161 
162         emit MintFeeUpdate(_oldMintFee, newMintFeeBasisPoints);
163     }
164 
165     /// @notice internal helper function to set the redemption fee
166     function _setRedeemFee(uint256 newRedeemFeeBasisPoints) internal {
167         require(newRedeemFeeBasisPoints <= MAX_FEE, "PegStabilityModule: Redeem fee exceeds max fee");
168         uint256 _oldRedeemFee = redeemFeeBasisPoints;
169         redeemFeeBasisPoints = newRedeemFeeBasisPoints;
170 
171         emit RedeemFeeUpdate(_oldRedeemFee, newRedeemFeeBasisPoints);
172     }
173 
174     /// @notice helper function to set reserves threshold
175     function _setReservesThreshold(uint256 newReservesThreshold) internal {
176         require(newReservesThreshold > 0, "PegStabilityModule: Invalid new reserves threshold");
177         uint256 oldReservesThreshold = reservesThreshold;
178         reservesThreshold = newReservesThreshold;
179 
180         emit ReservesThresholdUpdate(oldReservesThreshold, newReservesThreshold);
181     }
182 
183     /// @notice helper function to set the surplus target
184     function _setSurplusTarget(IPCVDeposit newSurplusTarget) internal {
185         require(address(newSurplusTarget) != address(0), "PegStabilityModule: Invalid new surplus target");
186         IPCVDeposit oldTarget = surplusTarget;
187         surplusTarget = newSurplusTarget;
188 
189         emit SurplusTargetUpdate(oldTarget, newSurplusTarget);
190     }
191 
192     // ----------- Public State Changing API -----------
193 
194     /// @notice send any surplus reserves to the PCV allocation
195     function allocateSurplus() external override {
196         int256 currentSurplus = reservesSurplus();
197         require(currentSurplus > 0, "PegStabilityModule: No surplus to allocate");
198 
199         _allocate(currentSurplus.toUint256());
200     }
201 
202     /// @notice function to receive ERC20 tokens from external contracts
203     function deposit() external override {
204         int256 currentSurplus = reservesSurplus();
205         if (currentSurplus > 0) {
206             _allocate(currentSurplus.toUint256());
207         }
208     }
209 
210     /// @notice internal helper method to redeem fei in exchange for an external asset
211     function _redeem(
212         address to,
213         uint256 amountFeiIn,
214         uint256 minAmountOut
215     ) internal virtual returns (uint256 amountOut) {
216         updateOracle();
217 
218         amountOut = _getRedeemAmountOut(amountFeiIn);
219         require(amountOut >= minAmountOut, "PegStabilityModule: Redeem not enough out");
220 
221         IERC20(fei()).safeTransferFrom(msg.sender, address(this), amountFeiIn);
222 
223         _transfer(to, amountOut);
224 
225         emit Redeem(to, amountFeiIn, amountOut);
226     }
227 
228     /// @notice internal helper method to mint fei in exchange for an external asset
229     function _mint(
230         address to,
231         uint256 amountIn,
232         uint256 minAmountOut
233     ) internal virtual returns (uint256 amountFeiOut) {
234         updateOracle();
235 
236         amountFeiOut = _getMintAmountOut(amountIn);
237         require(amountFeiOut >= minAmountOut, "PegStabilityModule: Mint not enough out");
238 
239         _transferFrom(msg.sender, address(this), amountIn);
240 
241         uint256 amountFeiToTransfer = Math.min(fei().balanceOf(address(this)), amountFeiOut);
242         uint256 amountFeiToMint = amountFeiOut - amountFeiToTransfer;
243 
244         IERC20(fei()).safeTransfer(to, amountFeiToTransfer);
245 
246         if (amountFeiToMint > 0) {
247             _mintFei(to, amountFeiToMint);
248         }
249 
250         emit Mint(to, amountIn, amountFeiOut);
251     }
252 
253     /// @notice function to redeem FEI for an underlying asset
254     /// We do not burn Fei; this allows the contract's balance of Fei to be used before the buffer is used
255     /// In practice, this helps prevent artificial cycling of mint-burn cycles and prevents a griefing vector.
256     function redeem(
257         address to,
258         uint256 amountFeiIn,
259         uint256 minAmountOut
260     ) external virtual override nonReentrant whenNotPaused whileRedemptionsNotPaused returns (uint256 amountOut) {
261         amountOut = _redeem(to, amountFeiIn, minAmountOut);
262     }
263 
264     /// @notice function to buy FEI for an underlying asset
265     /// We first transfer any contract-owned fei, then mint the remaining if necessary
266     function mint(
267         address to,
268         uint256 amountIn,
269         uint256 minAmountOut
270     ) external virtual override nonReentrant whenNotPaused whileMintingNotPaused returns (uint256 amountFeiOut) {
271         amountFeiOut = _mint(to, amountIn, minAmountOut);
272     }
273 
274     // ----------- Public View-Only API ----------
275 
276     /// @notice calculate the amount of FEI out for a given `amountIn` of underlying
277     /// First get oracle price of token
278     /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
279     /// ensure decimals are normalized if on underlying they are not 18
280     function getMintAmountOut(uint256 amountIn) public view override returns (uint256 amountFeiOut) {
281         amountFeiOut = _getMintAmountOut(amountIn);
282     }
283 
284     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of FEI
285     /// First get oracle price of token
286     /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
287     /// ensure decimals are normalized if on underlying they are not 18
288     function getRedeemAmountOut(uint256 amountFeiIn) public view override returns (uint256 amountTokenOut) {
289         amountTokenOut = _getRedeemAmountOut(amountFeiIn);
290     }
291 
292     /// @notice the maximum mint amount out
293     function getMaxMintAmountOut() external view override returns (uint256) {
294         return fei().balanceOf(address(this)) + buffer();
295     }
296 
297     /// @notice a flag for whether the current balance is above (true) or below (false) the reservesThreshold
298     function hasSurplus() external view override returns (bool) {
299         return balance() > reservesThreshold;
300     }
301 
302     /// @notice an integer representing the positive surplus or negative deficit of contract balance vs reservesThreshold
303     function reservesSurplus() public view override returns (int256) {
304         return balance().toInt256() - reservesThreshold.toInt256();
305     }
306 
307     /// @notice function from PCVDeposit that must be overriden
308     function balance() public view virtual override returns (uint256) {
309         return underlyingToken.balanceOf(address(this));
310     }
311 
312     /// @notice returns address of token this contracts balance is reported in
313     function balanceReportedIn() public view override returns (address) {
314         return address(underlyingToken);
315     }
316 
317     /// @notice override default behavior of not checking fei balance
318     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
319         return (balance(), feiBalance());
320     }
321 
322     // ----------- Internal Methods -----------
323 
324     /// @notice helper function to get mint amount out based on current market prices
325     /// @dev will revert if price is outside of bounds and bounded PSM is being used
326     function _getMintAmountOut(uint256 amountIn) internal view virtual returns (uint256 amountFeiOut) {
327         Decimal.D256 memory price = readOracle();
328         _validatePriceRange(price);
329 
330         Decimal.D256 memory adjustedAmountIn = price.mul(amountIn);
331 
332         amountFeiOut = adjustedAmountIn
333             .mul(Constants.BASIS_POINTS_GRANULARITY - mintFeeBasisPoints)
334             .div(Constants.BASIS_POINTS_GRANULARITY)
335             .asUint256();
336     }
337 
338     /// @notice helper function to get redeem amount out based on current market prices
339     /// @dev will revert if price is outside of bounds and bounded PSM is being used
340     function _getRedeemAmountOut(uint256 amountFeiIn) internal view virtual returns (uint256 amountTokenOut) {
341         Decimal.D256 memory price = readOracle();
342         _validatePriceRange(price);
343 
344         /// get amount of dollars being provided
345         Decimal.D256 memory adjustedAmountIn = Decimal.from(
346             (amountFeiIn * (Constants.BASIS_POINTS_GRANULARITY - redeemFeeBasisPoints)) /
347                 Constants.BASIS_POINTS_GRANULARITY
348         );
349 
350         /// now turn the dollars into the underlying token amounts
351         /// dollars / price = how much token to pay out
352         amountTokenOut = adjustedAmountIn.div(price).asUint256();
353     }
354 
355     /// @notice Allocates a portion of escrowed PCV to a target PCV deposit
356     function _allocate(uint256 amount) internal virtual {
357         _transfer(address(surplusTarget), amount);
358 
359         surplusTarget.deposit();
360 
361         emit AllocateSurplus(msg.sender, amount);
362     }
363 
364     /// @notice transfer ERC20 token
365     function _transfer(address to, uint256 amount) internal {
366         SafeERC20.safeTransfer(underlyingToken, to, amount);
367     }
368 
369     /// @notice transfer assets from user to this contract
370     function _transferFrom(
371         address from,
372         address to,
373         uint256 amount
374     ) internal {
375         SafeERC20.safeTransferFrom(underlyingToken, from, to, amount);
376     }
377 
378     /// @notice mint amount of FEI to the specified user on a rate limit
379     function _mintFei(address to, uint256 amount) internal override(CoreRef, RateLimitedMinter) {
380         super._mintFei(to, amount);
381     }
382 
383     // ----------- Hooks -----------
384 
385     /// @notice overriden function in the bounded PSM
386     function _validatePriceRange(Decimal.D256 memory price) internal view virtual {}
387 }
