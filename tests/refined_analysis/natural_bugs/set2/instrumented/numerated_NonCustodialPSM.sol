1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {Decimal} from "../external/Decimal.sol";
5 import {Constants} from "../Constants.sol";
6 import {OracleRef} from "./../refs/OracleRef.sol";
7 import {TribeRoles} from "./../core/TribeRoles.sol";
8 import {RateLimited} from "./../utils/RateLimited.sol";
9 import {IPCVDeposit, PCVDeposit} from "./../pcv/PCVDeposit.sol";
10 import {INonCustodialPSM} from "./INonCustodialPSM.sol";
11 import {GlobalRateLimitedMinter} from "./../utils/GlobalRateLimitedMinter.sol";
12 import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
13 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
14 import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";
15 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
16 import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
17 
18 /// @notice Peg Stability Module that holds no funds.
19 /// On a mint, it transfers all proceeds to a PCV Deposit
20 /// When funds are needed for a redemption, they are simply pulled from the PCV Deposit
21 contract NonCustodialPSM is OracleRef, RateLimited, ReentrancyGuard, INonCustodialPSM {
22     using Decimal for Decimal.D256;
23     using SafeCast for *;
24     using SafeERC20 for IERC20;
25 
26     /// @notice the fee in basis points for selling an asset into Fei
27     uint256 public override mintFeeBasisPoints;
28 
29     /// @notice the fee in basis points for buying the asset for Fei
30     uint256 public override redeemFeeBasisPoints;
31 
32     /// @notice the PCV deposit target to deposit and withdraw from
33     IPCVDeposit public override pcvDeposit;
34 
35     /// @notice the token this PSM will exchange for Fei
36     /// Must be a stable token pegged to $1
37     IERC20 public immutable override underlyingToken;
38 
39     /// @notice Rate Limited Minter contract that will be called when Fei needs to be minted
40     GlobalRateLimitedMinter public override rateLimitedMinter;
41 
42     /// @notice the max mint and redeem fee in basis points
43     /// Governance cannot change the maximum fee
44     uint256 public immutable override MAX_FEE = 300;
45 
46     /// @notice boolean switch that indicates whether redeeming is paused
47     bool public redeemPaused;
48 
49     /// @notice boolean switch that indicates whether minting is paused
50     bool public mintPaused;
51 
52     /// @notice struct for passing constructor parameters related to OracleRef
53     struct OracleParams {
54         address coreAddress;
55         address oracleAddress;
56         address backupOracle;
57         int256 decimalsNormalizer;
58     }
59 
60     /// @notice struct for passing constructor parameters related to MultiRateLimited
61     struct RateLimitedParams {
62         uint256 maxRateLimitPerSecond;
63         uint256 rateLimitPerSecond;
64         uint256 bufferCap;
65     }
66 
67     /// @notice struct for passing constructor parameters related to the non custodial PSM
68     struct PSMParams {
69         uint256 mintFeeBasisPoints;
70         uint256 redeemFeeBasisPoints;
71         IERC20 underlyingToken;
72         IPCVDeposit pcvDeposit;
73         GlobalRateLimitedMinter rateLimitedMinter;
74     }
75 
76     /// @notice construct the non custodial PSM. Structs are used to prevent stack too deep errors
77     /// @param params oracle ref constructor data
78     /// @param rateLimitedParams rate limited constructor data
79     /// @param psmParams non custodial PSM constructor data
80     constructor(
81         OracleParams memory params,
82         RateLimitedParams memory rateLimitedParams,
83         PSMParams memory psmParams
84     )
85         OracleRef(
86             params.coreAddress,
87             params.oracleAddress,
88             params.backupOracle,
89             params.decimalsNormalizer,
90             false /// leaving as false for now
91         )
92         /// rate limited replenishable passes false as the last param as there can be no partial actions
93         RateLimited(
94             rateLimitedParams.maxRateLimitPerSecond,
95             rateLimitedParams.rateLimitPerSecond,
96             rateLimitedParams.bufferCap,
97             false
98         )
99     {
100         underlyingToken = psmParams.underlyingToken;
101 
102         _setGlobalRateLimitedMinter(psmParams.rateLimitedMinter);
103         _setMintFee(psmParams.mintFeeBasisPoints);
104         _setRedeemFee(psmParams.redeemFeeBasisPoints);
105         _setPCVDeposit(psmParams.pcvDeposit);
106     }
107 
108     // ----------- Mint & Redeem pausing modifiers -----------
109 
110     /// @notice modifier that allows execution when redemptions are not paused
111     modifier whileRedemptionsNotPaused() {
112         require(!redeemPaused, "PegStabilityModule: Redeem paused");
113         _;
114     }
115 
116     /// @notice modifier that allows execution when minting is not paused
117     modifier whileMintingNotPaused() {
118         require(!mintPaused, "PegStabilityModule: Minting paused");
119         _;
120     }
121 
122     // ----------- Governor & Guardian only pausing api -----------
123 
124     /// @notice set secondary pausable methods to paused
125     function pauseRedeem() external onlyGuardianOrGovernor {
126         redeemPaused = true;
127         emit RedemptionsPaused(msg.sender);
128     }
129 
130     /// @notice set secondary pausable methods to unpaused
131     function unpauseRedeem() external onlyGuardianOrGovernor {
132         redeemPaused = false;
133         emit RedemptionsUnpaused(msg.sender);
134     }
135 
136     /// @notice set secondary pausable methods to paused
137     function pauseMint() external onlyGuardianOrGovernor {
138         mintPaused = true;
139         emit MintingPaused(msg.sender);
140     }
141 
142     /// @notice set secondary pausable methods to unpaused
143     function unpauseMint() external onlyGuardianOrGovernor {
144         mintPaused = false;
145         emit MintingUnpaused(msg.sender);
146     }
147 
148     // ----------- Governor, psm admin and parameter admin only state changing api -----------
149 
150     /// @notice set the mint fee vs oracle price in basis point terms
151     /// @param newMintFeeBasisPoints the new fee in basis points for minting
152     function setMintFee(uint256 newMintFeeBasisPoints)
153         external
154         override
155         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PARAMETER_ADMIN)
156     {
157         _setMintFee(newMintFeeBasisPoints);
158     }
159 
160     /// @notice set the redemption fee vs oracle price in basis point terms
161     /// @param newRedeemFeeBasisPoints the new fee in basis points for redemptions
162     function setRedeemFee(uint256 newRedeemFeeBasisPoints)
163         external
164         override
165         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PARAMETER_ADMIN)
166     {
167         _setRedeemFee(newRedeemFeeBasisPoints);
168     }
169 
170     /// @notice set the target for sending all PCV
171     /// @param newTarget new PCV Deposit target for this PSM
172     function setPCVDeposit(IPCVDeposit newTarget)
173         external
174         override
175         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PSM_ADMIN_ROLE)
176     {
177         _setPCVDeposit(newTarget);
178     }
179 
180     /// @notice set the target to call for Fei minting
181     /// @param newMinter new Global Rate Limited Minter for this PSM
182     function setGlobalRateLimitedMinter(GlobalRateLimitedMinter newMinter)
183         external
184         override
185         hasAnyOfTwoRoles(TribeRoles.GOVERNOR, TribeRoles.PSM_ADMIN_ROLE)
186     {
187         _setGlobalRateLimitedMinter(newMinter);
188     }
189 
190     // ----------- PCV Controller only state changing api -----------
191 
192     /// @notice withdraw ERC20 from the contract
193     /// @param token address of the ERC20 to send
194     /// @param to address destination of the ERC20
195     /// @param amount quantity of ERC20 to send
196     function withdrawERC20(
197         address token,
198         address to,
199         uint256 amount
200     ) external override onlyPCVController {
201         IERC20(token).safeTransfer(to, amount);
202         emit WithdrawERC20(msg.sender, token, to, amount);
203     }
204 
205     // ----------- Public State Changing API -----------
206 
207     /// @notice function to redeem Fei for an underlying asset
208     /// We do not burn Fei; this allows the contract's balance of Fei to be used before the buffer is used
209     /// In practice, this helps prevent artificial cycling of mint-burn cycles and prevents DOS attacks.
210     /// This function will deplete the buffer based on the amount of Fei that is being redeemed.
211     /// @param to the destination address for proceeds
212     /// @param amountFeiIn the amount of Fei to sell
213     /// @param minAmountOut the minimum amount out otherwise the TX will fail
214     function redeem(
215         address to,
216         uint256 amountFeiIn,
217         uint256 minAmountOut
218     ) external virtual override nonReentrant whenNotPaused whileRedemptionsNotPaused returns (uint256 amountOut) {
219         _depleteBuffer(amountFeiIn); /// deplete buffer first to save gas on buffer exhaustion sad path
220 
221         updateOracle();
222 
223         amountOut = _getRedeemAmountOut(amountFeiIn);
224         require(amountOut >= minAmountOut, "PegStabilityModule: Redeem not enough out");
225 
226         IERC20(fei()).safeTransferFrom(msg.sender, address(this), amountFeiIn);
227 
228         pcvDeposit.withdraw(to, amountOut);
229 
230         emit Redeem(to, amountFeiIn, amountOut);
231     }
232 
233     /// @notice function to buy Fei for an underlying asset that is pegged to $1
234     /// We first transfer any contract-owned Fei, then mint the remaining if necessary
235     /// This function will replenish the buffer based on the amount of Fei that is being sent out.
236     /// @param to the destination address for proceeds
237     /// @param amountIn the amount of external asset to sell to the PSM
238     /// @param minFeiAmountOut the minimum amount of Fei out otherwise the TX will fail
239     function mint(
240         address to,
241         uint256 amountIn,
242         uint256 minFeiAmountOut
243     ) external virtual override nonReentrant whenNotPaused whileMintingNotPaused returns (uint256 amountFeiOut) {
244         updateOracle();
245 
246         amountFeiOut = _getMintAmountOut(amountIn);
247         require(amountFeiOut >= minFeiAmountOut, "PegStabilityModule: Mint not enough out");
248 
249         underlyingToken.safeTransferFrom(msg.sender, address(pcvDeposit), amountIn);
250         pcvDeposit.deposit();
251 
252         uint256 amountFeiToTransfer = Math.min(fei().balanceOf(address(this)), amountFeiOut);
253         uint256 amountFeiToMint = amountFeiOut - amountFeiToTransfer;
254 
255         if (amountFeiToTransfer != 0) {
256             IERC20(fei()).safeTransfer(to, amountFeiToTransfer);
257         }
258 
259         if (amountFeiToMint != 0) {
260             rateLimitedMinter.mint(to, amountFeiToMint);
261         }
262 
263         _replenishBuffer(amountFeiOut);
264 
265         emit Mint(to, amountIn, amountFeiOut);
266     }
267 
268     // ----------- Public View-Only API ----------
269 
270     /// @notice calculate the amount of Fei out for a given `amountIn` of underlying
271     /// First get oracle price of token
272     /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
273     /// ensure decimals are normalized if on underlying they are not 18
274     /// @param amountIn the amount of external asset to sell to the PSM
275     /// @return amountFeiOut the amount of Fei received for the amountIn of external asset
276     function getMintAmountOut(uint256 amountIn) public view override returns (uint256 amountFeiOut) {
277         amountFeiOut = _getMintAmountOut(amountIn);
278     }
279 
280     /// @notice calculate the amount of underlying out for a given `amountFeiIn` of Fei
281     /// First get oracle price of token
282     /// Then figure out how many dollars that amount in is worth by multiplying price * amount.
283     /// ensure decimals are normalized if on underlying they are not 18
284     /// @param amountFeiIn the amount of Fei to redeem
285     /// @return amountTokenOut the amount of the external asset received in exchange for the amount of Fei redeemed
286     function getRedeemAmountOut(uint256 amountFeiIn) public view override returns (uint256 amountTokenOut) {
287         amountTokenOut = _getRedeemAmountOut(amountFeiIn);
288     }
289 
290     /// @notice getter to return the maximum amount of Fei that could be purchased at once
291     /// @return the maximum amount of Fei available for purchase at once through this PSM
292     function getMaxMintAmountOut() external view override returns (uint256) {
293         return fei().balanceOf(address(this)) + rateLimitedMinter.individualBuffer(address(this));
294     }
295 
296     // ----------- Internal Methods -----------
297 
298     /// @notice helper function to get mint amount out based on current market prices
299     /// @dev will revert if price is outside of bounds and price bound PSM is being used
300     /// @param amountIn the amount of stable asset in
301     /// @return amountFeiOut the amount of Fei received for the amountIn of stable assets
302     function _getMintAmountOut(uint256 amountIn) internal view virtual returns (uint256 amountFeiOut) {
303         Decimal.D256 memory price = readOracle();
304         _validatePriceRange(price);
305 
306         Decimal.D256 memory adjustedAmountIn = price.mul(amountIn);
307 
308         amountFeiOut = adjustedAmountIn
309             .mul(Constants.BASIS_POINTS_GRANULARITY - mintFeeBasisPoints)
310             .div(Constants.BASIS_POINTS_GRANULARITY)
311             .asUint256();
312     }
313 
314     /// @notice helper function to get redeem amount out based on current market prices
315     /// @dev will revert if price is outside of bounds and price bound PSM is being used
316     /// @param amountFeiIn the amount of Fei to redeem
317     /// @return amountTokenOut the amount of the external asset received in exchange for the amount of Fei redeemed
318     function _getRedeemAmountOut(uint256 amountFeiIn) internal view virtual returns (uint256 amountTokenOut) {
319         Decimal.D256 memory price = readOracle();
320         _validatePriceRange(price);
321 
322         /// get amount of Fei being provided being redeemed after fees
323         Decimal.D256 memory adjustedAmountIn = Decimal.from(
324             (amountFeiIn * (Constants.BASIS_POINTS_GRANULARITY - redeemFeeBasisPoints)) /
325                 Constants.BASIS_POINTS_GRANULARITY
326         );
327 
328         /// now turn the Fei into the underlying token amounts
329         /// amount Fei in / Fei you receive for $1 = how much stable token to pay out
330         amountTokenOut = adjustedAmountIn.div(price).asUint256();
331     }
332 
333     // ----------- Helper methods to change state -----------
334 
335     /// @notice set the global rate limited minter this PSM calls to mint Fei
336     /// @param newMinter the new minter contract that this PSM will reference
337     function _setGlobalRateLimitedMinter(GlobalRateLimitedMinter newMinter) internal {
338         require(address(newMinter) != address(0), "PegStabilityModule: Invalid new GlobalRateLimitedMinter");
339         GlobalRateLimitedMinter oldMinter = rateLimitedMinter;
340         rateLimitedMinter = newMinter;
341 
342         emit GlobalRateLimitedMinterUpdate(oldMinter, newMinter);
343     }
344 
345     /// @notice set the mint fee vs oracle price in basis point terms
346     /// @param newMintFeeBasisPoints the new fee for minting in basis points
347     function _setMintFee(uint256 newMintFeeBasisPoints) internal {
348         require(newMintFeeBasisPoints <= MAX_FEE, "PegStabilityModule: Mint fee exceeds max fee");
349         uint256 _oldMintFee = mintFeeBasisPoints;
350         mintFeeBasisPoints = newMintFeeBasisPoints;
351 
352         emit MintFeeUpdate(_oldMintFee, newMintFeeBasisPoints);
353     }
354 
355     /// @notice internal helper function to set the redemption fee
356     /// @param newRedeemFeeBasisPoints the new fee for redemptions in basis points
357     function _setRedeemFee(uint256 newRedeemFeeBasisPoints) internal {
358         require(newRedeemFeeBasisPoints <= MAX_FEE, "PegStabilityModule: Redeem fee exceeds max fee");
359         uint256 _oldRedeemFee = redeemFeeBasisPoints;
360         redeemFeeBasisPoints = newRedeemFeeBasisPoints;
361 
362         emit RedeemFeeUpdate(_oldRedeemFee, newRedeemFeeBasisPoints);
363     }
364 
365     /// @notice helper function to set the PCV deposit
366     /// @param newPCVDeposit the new PCV deposit that this PSM will pull assets from and deposit assets into
367     function _setPCVDeposit(IPCVDeposit newPCVDeposit) internal {
368         require(address(newPCVDeposit) != address(0), "PegStabilityModule: Invalid new PCVDeposit");
369         /* Removed to be compatible with PCV deposit v1. (which uses token() instead of balanceReportedIn())
370         require(
371             newPCVDeposit.balanceReportedIn() == address(underlyingToken),
372             "PegStabilityModule: Underlying token mismatch"
373         );
374         */
375         IPCVDeposit oldTarget = pcvDeposit;
376         pcvDeposit = newPCVDeposit;
377 
378         emit PCVDepositUpdate(oldTarget, newPCVDeposit);
379     }
380 
381     // ----------- Hooks -----------
382 
383     /// @notice overriden function in the price bound PSM
384     function _validatePriceRange(Decimal.D256 memory price) internal view virtual {}
385 }
