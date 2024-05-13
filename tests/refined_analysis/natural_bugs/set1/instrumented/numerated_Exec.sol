1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 import "../IRiskManager.sol";
7 import "../PToken.sol";
8 import "../Interfaces.sol";
9 import "../Utils.sol";
10 
11 
12 /// @notice Definition of callback method that deferLiquidityCheck will invoke on your contract
13 interface IDeferredLiquidityCheck {
14     function onDeferredLiquidityCheck(bytes memory data) external;
15 }
16 
17 
18 /// @notice Batch executions, liquidity check deferrals, and interfaces to fetch prices and account liquidity
19 contract Exec is BaseLogic {
20     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__EXEC, moduleGitCommit_) {}
21 
22     /// @notice Single item in a batch request
23     struct EulerBatchItem {
24         bool allowError;
25         address proxyAddr;
26         bytes data;
27     }
28 
29     /// @notice Single item in a batch response
30     struct EulerBatchItemResponse {
31         bool success;
32         bytes result;
33     }
34 
35     /// @notice Error containing results of a simulated batch dispatch
36     error BatchDispatchSimulation(EulerBatchItemResponse[] simulation);
37 
38     // Accessors
39 
40     /// @notice Compute aggregate liquidity for an account
41     /// @param account User address
42     /// @return status Aggregate liquidity (sum of all entered assets)
43     function liquidity(address account) external staticDelegate returns (IRiskManager.LiquidityStatus memory status) {
44         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER,
45                                                  abi.encodeWithSelector(IRiskManager.computeLiquidity.selector, account));
46 
47         (status) = abi.decode(result, (IRiskManager.LiquidityStatus));
48     }
49 
50     /// @notice Compute detailed liquidity for an account, broken down by asset
51     /// @param account User address
52     /// @return assets List of user's entered assets and each asset's corresponding liquidity
53     function detailedLiquidity(address account) public staticDelegate returns (IRiskManager.AssetLiquidity[] memory assets) {
54         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER,
55                                                  abi.encodeWithSelector(IRiskManager.computeAssetLiquidities.selector, account));
56 
57         (assets) = abi.decode(result, (IRiskManager.AssetLiquidity[]));
58     }
59 
60     /// @notice Retrieve Euler's view of an asset's price
61     /// @param underlying Token address
62     /// @return twap Time-weighted average price
63     /// @return twapPeriod TWAP duration, either the twapWindow value in AssetConfig, or less if that duration not available
64     function getPrice(address underlying) external staticDelegate returns (uint twap, uint twapPeriod) {
65         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER,
66                                                  abi.encodeWithSelector(IRiskManager.getPrice.selector, underlying));
67 
68         (twap, twapPeriod) = abi.decode(result, (uint, uint));
69     }
70 
71     /// @notice Retrieve Euler's view of an asset's price, as well as the current marginal price on uniswap
72     /// @param underlying Token address
73     /// @return twap Time-weighted average price
74     /// @return twapPeriod TWAP duration, either the twapWindow value in AssetConfig, or less if that duration not available
75     /// @return currPrice The current marginal price on uniswap3 (informational: not used anywhere in the Euler protocol)
76     function getPriceFull(address underlying) external staticDelegate returns (uint twap, uint twapPeriod, uint currPrice) {
77         bytes memory result = callInternalModule(MODULEID__RISK_MANAGER,
78                                                  abi.encodeWithSelector(IRiskManager.getPriceFull.selector, underlying));
79 
80         (twap, twapPeriod, currPrice) = abi.decode(result, (uint, uint, uint));
81     }
82 
83 
84     // Custom execution methods
85 
86     /// @notice Defer liquidity checking for an account, to perform rebalancing, flash loans, etc. msg.sender must implement IDeferredLiquidityCheck
87     /// @param account The account to defer liquidity for. Usually address(this), although not always
88     /// @param data Passed through to the onDeferredLiquidityCheck() callback, so contracts don't need to store transient data in storage
89     function deferLiquidityCheck(address account, bytes memory data) external reentrantOK {
90         address msgSender = unpackTrailingParamMsgSender();
91 
92         require(accountLookup[account].deferLiquidityStatus == DEFERLIQUIDITY__NONE, "e/defer/reentrancy");
93         accountLookup[account].deferLiquidityStatus = DEFERLIQUIDITY__CLEAN;
94 
95         IDeferredLiquidityCheck(msgSender).onDeferredLiquidityCheck(data);
96 
97         uint8 status = accountLookup[account].deferLiquidityStatus;
98         accountLookup[account].deferLiquidityStatus = DEFERLIQUIDITY__NONE;
99 
100         if (status == DEFERLIQUIDITY__DIRTY) checkLiquidity(account);
101     }
102 
103     /// @notice Execute several operations in a single transaction
104     /// @param items List of operations to execute
105     /// @param deferLiquidityChecks List of user accounts to defer liquidity checks for
106     function batchDispatch(EulerBatchItem[] calldata items, address[] calldata deferLiquidityChecks) external reentrantOK {
107         doBatchDispatch(items, deferLiquidityChecks, false);
108     }
109 
110     /// @notice Call batch dispatch, but instruct it to revert with the responses, before the liquidity checks.
111     /// @param items List of operations to execute
112     /// @param deferLiquidityChecks List of user accounts to defer liquidity checks for
113     /// @dev During simulation all batch items are executed, regardless of the `allowError` flag
114     function batchDispatchSimulate(EulerBatchItem[] calldata items, address[] calldata deferLiquidityChecks) external reentrantOK {
115         doBatchDispatch(items, deferLiquidityChecks, true);
116 
117         revert("e/batch/simulation-did-not-revert");
118     }
119 
120 
121     // Average liquidity tracking
122 
123     /// @notice Enable average liquidity tracking for your account. Operations will cost more gas, but you may get additional benefits when performing liquidations
124     /// @param subAccountId subAccountId 0 for primary, 1-255 for a sub-account. 
125     /// @param delegate An address of another account that you would allow to use the benefits of your account's average liquidity (use the null address if you don't care about this). The other address must also reciprocally delegate to your account.
126     /// @param onlyDelegate Set this flag to skip tracking average liquidity and only set the delegate.
127     function trackAverageLiquidity(uint subAccountId, address delegate, bool onlyDelegate) external nonReentrant {
128         address msgSender = unpackTrailingParamMsgSender();
129         address account = getSubAccount(msgSender, subAccountId);
130         require(account != delegate, "e/track-liquidity/self-delegation");
131 
132         emit DelegateAverageLiquidity(account, delegate);
133         accountLookup[account].averageLiquidityDelegate = delegate;
134 
135         if (onlyDelegate) return;
136 
137         emit TrackAverageLiquidity(account);
138 
139         accountLookup[account].lastAverageLiquidityUpdate = uint40(block.timestamp);
140         accountLookup[account].averageLiquidity = 0;
141     }
142 
143     /// @notice Disable average liquidity tracking for your account and remove delegate
144     /// @param subAccountId subAccountId 0 for primary, 1-255 for a sub-account
145     function unTrackAverageLiquidity(uint subAccountId) external nonReentrant {
146         address msgSender = unpackTrailingParamMsgSender();
147         address account = getSubAccount(msgSender, subAccountId);
148 
149         emit UnTrackAverageLiquidity(account);
150         emit DelegateAverageLiquidity(account, address(0));
151 
152         accountLookup[account].lastAverageLiquidityUpdate = 0;
153         accountLookup[account].averageLiquidity = 0;
154         accountLookup[account].averageLiquidityDelegate = address(0);
155     }
156 
157     /// @notice Retrieve the average liquidity for an account
158     /// @param account User account (xor in subAccountId, if applicable)
159     /// @return The average liquidity, in terms of the reference asset, and post risk-adjustment
160     function getAverageLiquidity(address account) external nonReentrant returns (uint) {
161         return getUpdatedAverageLiquidity(account);
162     }
163 
164     /// @notice Retrieve the average liquidity for an account or a delegate account, if set
165     /// @param account User account (xor in subAccountId, if applicable)
166     /// @return The average liquidity, in terms of the reference asset, and post risk-adjustment
167     function getAverageLiquidityWithDelegate(address account) external nonReentrant returns (uint) {
168         return getUpdatedAverageLiquidityWithDelegate(account);
169     }
170 
171     /// @notice Retrieve the account which delegates average liquidity for an account, if set
172     /// @param account User account (xor in subAccountId, if applicable)
173     /// @return The average liquidity delegate account
174     function getAverageLiquidityDelegateAccount(address account) external view returns (address) {
175         address delegate = accountLookup[account].averageLiquidityDelegate;
176         return accountLookup[delegate].averageLiquidityDelegate == account ? delegate : address(0);
177     }
178 
179 
180 
181 
182     // PToken wrapping/unwrapping
183 
184     /// @notice Transfer underlying tokens from sender's wallet into the pToken wrapper. Allowance should be set for the euler address.
185     /// @param underlying Token address
186     /// @param amount The amount to wrap in underlying units
187     function pTokenWrap(address underlying, uint amount) external nonReentrant {
188         address msgSender = unpackTrailingParamMsgSender();
189 
190         emit PTokenWrap(underlying, msgSender, amount);
191 
192         address pTokenAddr = reversePTokenLookup[underlying];
193         require(pTokenAddr != address(0), "e/exec/ptoken-not-found");
194 
195         {
196             uint origBalance = IERC20(underlying).balanceOf(pTokenAddr);
197             Utils.safeTransferFrom(underlying, msgSender, pTokenAddr, amount);
198             uint newBalance = IERC20(underlying).balanceOf(pTokenAddr);
199             require(newBalance == origBalance + amount, "e/exec/ptoken-transfer-mismatch");
200         }
201 
202         PToken(pTokenAddr).claimSurplus(msgSender);
203     }
204 
205     /// @notice Transfer underlying tokens from the pToken wrapper to the sender's wallet.
206     /// @param underlying Token address
207     /// @param amount The amount to unwrap in underlying units
208     function pTokenUnWrap(address underlying, uint amount) external nonReentrant {
209         address msgSender = unpackTrailingParamMsgSender();
210 
211         emit PTokenUnWrap(underlying, msgSender, amount);
212 
213         address pTokenAddr = reversePTokenLookup[underlying];
214         require(pTokenAddr != address(0), "e/exec/ptoken-not-found");
215 
216         PToken(pTokenAddr).forceUnwrap(msgSender, amount);
217     }
218 
219     /// @notice Apply EIP2612 signed permit on a target token from sender to euler contract
220     /// @param token Token address
221     /// @param value Allowance value
222     /// @param deadline Permit expiry timestamp
223     /// @param v secp256k1 signature v
224     /// @param r secp256k1 signature r
225     /// @param s secp256k1 signature s
226     function usePermit(address token, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
227         require(underlyingLookup[token].eTokenAddress != address(0), "e/exec/market-not-activated");
228         address msgSender = unpackTrailingParamMsgSender();
229 
230         IERC20Permit(token).permit(msgSender, address(this), value, deadline, v, r, s);
231     }
232 
233     /// @notice Apply DAI like (allowed) signed permit on a target token from sender to euler contract
234     /// @param token Token address
235     /// @param nonce Sender nonce
236     /// @param expiry Permit expiry timestamp
237     /// @param allowed If true, set unlimited allowance, otherwise set zero allowance
238     /// @param v secp256k1 signature v
239     /// @param r secp256k1 signature r
240     /// @param s secp256k1 signature s
241     function usePermitAllowed(address token, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
242         require(underlyingLookup[token].eTokenAddress != address(0), "e/exec/market-not-activated");
243         address msgSender = unpackTrailingParamMsgSender();
244 
245         IERC20Permit(token).permit(msgSender, address(this), nonce, expiry, allowed, v, r, s);
246     }
247 
248     /// @notice Apply allowance to tokens expecting the signature packed in a single bytes param
249     /// @param token Token address
250     /// @param value Allowance value
251     /// @param deadline Permit expiry timestamp
252     /// @param signature secp256k1 signature encoded as rsv
253     function usePermitPacked(address token, uint256 value, uint256 deadline, bytes calldata signature) external nonReentrant {
254         require(underlyingLookup[token].eTokenAddress != address(0), "e/exec/market-not-activated");
255         address msgSender = unpackTrailingParamMsgSender();
256 
257         IERC20Permit(token).permit(msgSender, address(this), value, deadline, signature);
258     }
259 
260     /// @notice Execute a staticcall to an arbitrary address with an arbitrary payload.
261     /// @param contractAddress Address of the contract to call
262     /// @param payload Encoded call payload
263     /// @return result Encoded return data
264     /// @dev Intended to be used in static-called batches, to e.g. provide detailed information about the impacts of the simulated operation.
265     function doStaticCall(address contractAddress, bytes memory payload) external view returns (bytes memory) {
266         (bool success, bytes memory result) = contractAddress.staticcall(payload);
267         if (!success) revertBytes(result);
268 
269         assembly {
270             return(add(32, result), mload(result))
271         }
272     }
273 
274     function doBatchDispatch(EulerBatchItem[] calldata items, address[] calldata deferLiquidityChecks, bool revertResponse) private {
275         address msgSender = unpackTrailingParamMsgSender();
276 
277         for (uint i = 0; i < deferLiquidityChecks.length; ++i) {
278             address account = deferLiquidityChecks[i];
279 
280             require(accountLookup[account].deferLiquidityStatus == DEFERLIQUIDITY__NONE, "e/batch/reentrancy");
281             accountLookup[account].deferLiquidityStatus = DEFERLIQUIDITY__CLEAN;
282         }
283 
284 
285         EulerBatchItemResponse[] memory response;
286         if (revertResponse) response = new EulerBatchItemResponse[](items.length);
287 
288         for (uint i = 0; i < items.length; ++i) {
289             EulerBatchItem calldata item = items[i];
290             address proxyAddr = item.proxyAddr;
291 
292             uint32 moduleId = trustedSenders[proxyAddr].moduleId;
293             address moduleImpl = trustedSenders[proxyAddr].moduleImpl;
294 
295             require(moduleId != 0, "e/batch/unknown-proxy-addr");
296             require(moduleId <= MAX_EXTERNAL_MODULEID, "e/batch/call-to-internal-module");
297 
298             if (moduleImpl == address(0)) moduleImpl = moduleLookup[moduleId];
299             require(moduleImpl != address(0), "e/batch/module-not-installed");
300 
301             bytes memory inputWrapped = abi.encodePacked(item.data, uint160(msgSender), uint160(proxyAddr));
302             (bool success, bytes memory result) = moduleImpl.delegatecall(inputWrapped);
303 
304             if (revertResponse) {
305                 EulerBatchItemResponse memory r = response[i];
306                 r.success = success;
307                 r.result = result;
308             } else if (!(success || item.allowError)) {
309                 revertBytes(result);
310             }
311         }
312 
313         if (revertResponse) revert BatchDispatchSimulation(response);
314 
315         for (uint i = 0; i < deferLiquidityChecks.length; ++i) {
316             address account = deferLiquidityChecks[i];
317 
318             uint8 status = accountLookup[account].deferLiquidityStatus;
319             accountLookup[account].deferLiquidityStatus = DEFERLIQUIDITY__NONE;
320 
321             if (status == DEFERLIQUIDITY__DIRTY) checkLiquidity(account);
322         }
323     }
324 }
