1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IVault.sol";
5 import "./IWeightedPool.sol";
6 import "./BalancerPCVDepositBase.sol";
7 import "../PCVDeposit.sol";
8 import "../../Constants.sol";
9 import "../../refs/CoreRef.sol";
10 import "../../oracle/IOracle.sol";
11 import "../../external/gyro/ExtendedMath.sol";
12 import "../../external/gyro/abdk/ABDKMath64x64.sol";
13 
14 /// @title base class for a Balancer WeightedPool PCV Deposit
15 /// @author Fei Protocol
16 contract BalancerPCVDepositWeightedPool is BalancerPCVDepositBase {
17     using ExtendedMath for *;
18     using ABDKMath64x64 for *;
19     using SafeMath for *;
20     using Decimal for Decimal.D256;
21 
22     event OracleUpdate(address _sender, address indexed _token, address indexed _oldOracle, address indexed _newOracle);
23 
24     /// @notice oracle array of the tokens stored in this Balancer pool
25     IOracle[] public tokenOracles;
26     /// @notice mapping of tokens to oracles of the tokens stored in this Balancer pool
27     mapping(IERC20 => IOracle) public tokenOraclesMapping;
28 
29     /// @notice the token stored in the Balancer pool, used for accounting
30     IERC20 public token;
31     /// @notice cache of the index of the token in the Balancer pool
32     uint8 private tokenIndexInPool;
33 
34     /// @notice true if FEI is in the pool
35     bool private feiInPool;
36     /// @notice if feiInPool is true, this is the index of FEI in the pool.
37     /// If feiInPool is false, this is zero.
38     uint8 private feiIndexInPool;
39 
40     /// @notice Balancer PCV Deposit constructor
41     /// @param _core Fei Core for reference
42     /// @param _poolId Balancer poolId to deposit in
43     /// @param _vault Balancer vault
44     /// @param _rewards Balancer rewards (the MerkleOrchard)
45     /// @param _maximumSlippageBasisPoints Maximum slippage basis points when depositing
46     /// @param _token Address of the ERC20 to manage / do accounting with
47     /// @param _tokenOracles oracle for price feeds of the tokens in pool
48     constructor(
49         address _core,
50         address _vault,
51         address _rewards,
52         bytes32 _poolId,
53         uint256 _maximumSlippageBasisPoints,
54         address _token,
55         IOracle[] memory _tokenOracles
56     ) BalancerPCVDepositBase(_core, _vault, _rewards, _poolId, _maximumSlippageBasisPoints) {
57         // check that we have oracles for all tokens
58         require(poolAssets.length == _tokenOracles.length, "BalancerPCVDepositWeightedPool: wrong number of oracles.");
59 
60         tokenOracles = _tokenOracles;
61 
62         // set cached values for token addresses & indexes
63         bool tokenFound = false;
64         address _fei = address(fei());
65         for (uint256 i = 0; i < poolAssets.length; i++) {
66             tokenOraclesMapping[IERC20(address(poolAssets[i]))] = _tokenOracles[i];
67             if (address(poolAssets[i]) == _token) {
68                 tokenFound = true;
69                 tokenIndexInPool = uint8(i);
70                 token = IERC20(address(poolAssets[i]));
71             }
72             if (address(poolAssets[i]) == _fei) {
73                 feiInPool = true;
74                 feiIndexInPool = uint8(i);
75             }
76         }
77         // check that the token is in the pool
78         require(tokenFound, "BalancerPCVDepositWeightedPool: token not in pool.");
79 
80         // check that token used for account is not FEI
81         require(_token != _fei, "BalancerPCVDepositWeightedPool: token must not be FEI.");
82     }
83 
84     /// @notice sets the oracle for a token in this deposit
85     function setOracle(address _token, address _newOracle) external onlyGovernorOrAdmin {
86         // we must set the oracle for an asset that is in the pool
87         address oldOracle = address(tokenOraclesMapping[IERC20(_token)]);
88         require(oldOracle != address(0), "BalancerPCVDepositWeightedPool: invalid token");
89 
90         // set oracle in the map
91         tokenOraclesMapping[IERC20(_token)] = IOracle(_newOracle);
92 
93         // emit event
94         emit OracleUpdate(msg.sender, _token, oldOracle, _newOracle);
95     }
96 
97     /// @notice returns total balance of PCV in the Deposit, expressed in "token"
98     function balance() public view override returns (uint256) {
99         uint256 _bptSupply = IWeightedPool(poolAddress).totalSupply();
100         if (_bptSupply == 0) {
101             // empty (uninitialized) pools have a totalSupply of 0
102             return 0;
103         }
104 
105         (, uint256[] memory balances, ) = vault.getPoolTokens(poolId);
106         uint256[] memory underlyingPrices = _readOracles();
107 
108         uint256 _balance = balances[tokenIndexInPool];
109         for (uint256 i = 0; i < balances.length; i++) {
110             bool isToken = i == tokenIndexInPool;
111             bool isFei = feiInPool && i == feiIndexInPool;
112             if (!isToken && !isFei) {
113                 _balance += (balances[i] * underlyingPrices[i]) / underlyingPrices[tokenIndexInPool];
114             }
115         }
116 
117         uint256 _bptBalance = IWeightedPool(poolAddress).balanceOf(address(this));
118 
119         return (_balance * _bptBalance) / _bptSupply;
120     }
121 
122     // @notice returns the manipulation-resistant balance of tokens & FEI held.
123     function resistantBalanceAndFei() public view override returns (uint256 _resistantBalance, uint256 _resistantFei) {
124         // read oracle values
125         uint256[] memory underlyingPrices = _readOracles();
126 
127         // get BPT token price
128         uint256 bptPrice = _getBPTPrice(underlyingPrices);
129 
130         // compute balance in USD value
131         uint256 bptBalance = IWeightedPool(poolAddress).balanceOf(address(this));
132         Decimal.D256 memory bptValueUSD = Decimal.from(bptBalance).mul(bptPrice).div(1e18);
133 
134         // compute balance in "token" value
135         _resistantBalance = bptValueUSD.mul(1e18).div(underlyingPrices[tokenIndexInPool]).asUint256();
136 
137         // if FEI is in the pair, return only the value of asset, and does not
138         // count the protocol-owned FEI in the balance. For instance, if the pool
139         // is 80% WETH and 20% FEI, balance() will return 80% of the USD value
140         // of the balancer pool tokens held by the contract, denominated in
141         // "token" (and not in USD).
142         if (feiInPool) {
143             uint256[] memory _weights = IWeightedPool(poolAddress).getNormalizedWeights();
144             _resistantFei = bptValueUSD.mul(_weights[feiIndexInPool]).div(1e18).asUint256();
145             // if FEI is x% of the pool, remove x% of the balance
146             _resistantBalance = (_resistantBalance * (1e18 - _weights[feiIndexInPool])) / 1e18;
147         }
148 
149         return (_resistantBalance, _resistantFei);
150     }
151 
152     /// @notice display the related token of the balance reported
153     function balanceReportedIn() public view override returns (address) {
154         return address(token);
155     }
156 
157     // @notice deposit tokens to the Balancer pool
158     function deposit() external override whenNotPaused {
159         uint256[] memory balances = new uint256[](poolAssets.length);
160         uint256 totalbalance = 0;
161         for (uint256 i = 0; i < balances.length; i++) {
162             balances[i] = IERC20(address(poolAssets[i])).balanceOf(address(this));
163             // @dev: note that totalbalance is meaningless here, because we are
164             // adding units of tokens that may have different decimals, different
165             // values, etc. But the totalbalance is only used for checking > 0,
166             // to make sure that we have something to deposit.
167             totalbalance += balances[i];
168         }
169         require(totalbalance > 0, "BalancerPCVDepositWeightedPool: no tokens to deposit");
170 
171         // Read oracles
172         uint256[] memory underlyingPrices = _readOracles();
173 
174         // Build joinPool request
175         if (feiInPool) {
176             // If FEI is in pool, we mint the good balance of FEI to go with the tokens
177             // we are depositing
178             uint256 _feiToMint = (underlyingPrices[tokenIndexInPool] * balances[tokenIndexInPool]) / 1e18;
179             // normalize by weights
180             uint256[] memory _weights = IWeightedPool(poolAddress).getNormalizedWeights();
181             _feiToMint = (_feiToMint * _weights[feiIndexInPool]) / _weights[tokenIndexInPool];
182             // mint FEI
183             _mintFei(address(this), _feiToMint);
184             balances[feiIndexInPool] = _feiToMint;
185         }
186 
187         bytes memory userData = abi.encode(IWeightedPool.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT, balances, 0);
188         // If the pool is not initialized, join with an INIT JoinKind
189         if (IWeightedPool(poolAddress).totalSupply() == 0) {
190             userData = abi.encode(IWeightedPool.JoinKind.INIT, balances);
191         }
192 
193         IVault.JoinPoolRequest memory request = IVault.JoinPoolRequest({
194             assets: poolAssets,
195             maxAmountsIn: balances,
196             userData: userData,
197             fromInternalBalance: false // tokens are held on this contract
198         });
199 
200         // approve spending on balancer's vault
201         for (uint256 i = 0; i < balances.length; i++) {
202             if (balances[i] > 0) {
203                 IERC20(address(poolAssets[i])).approve(address(vault), balances[i]);
204             }
205         }
206 
207         // execute joinPool & transfer tokens to Balancer
208         uint256 bptBalanceBefore = IWeightedPool(poolAddress).balanceOf(address(this));
209         vault.joinPool(
210             poolId, // poolId
211             address(this), // sender
212             address(this), // recipient
213             request // join pool request
214         );
215         uint256 bptBalanceAfter = IWeightedPool(poolAddress).balanceOf(address(this));
216 
217         // Check for slippage
218         {
219             // Compute USD value deposited
220             uint256 valueIn = 0;
221             for (uint256 i = 0; i < balances.length; i++) {
222                 valueIn += (balances[i] * underlyingPrices[i]) / 1e18;
223             }
224 
225             // Compute USD value out
226             uint256 bptPrice = _getBPTPrice(underlyingPrices);
227             uint256 valueOut = Decimal.from(bptPrice).mul(bptBalanceAfter - bptBalanceBefore).div(1e18).asUint256();
228             uint256 minValueOut = Decimal
229                 .from(valueIn)
230                 .mul(Constants.BASIS_POINTS_GRANULARITY - maximumSlippageBasisPoints)
231                 .div(Constants.BASIS_POINTS_GRANULARITY)
232                 .asUint256();
233             require(valueOut > minValueOut, "BalancerPCVDepositWeightedPool: slippage too high");
234         }
235 
236         // emit event
237         emit Deposit(msg.sender, balances[tokenIndexInPool]);
238     }
239 
240     /// @notice withdraw tokens from the PCV allocation
241     /// @param to the address to send PCV to
242     /// @param amount of tokens withdrawn
243     /// Note: except for ERC20/FEI pool2s, this function will not withdraw tokens
244     /// in the right proportions for the pool, so only use this to withdraw small
245     /// amounts comparatively to the pool size. For large withdrawals, it is
246     /// preferrable to use exitPool() and then withdrawERC20().
247     function withdraw(address to, uint256 amount) external override onlyPCVController whenNotPaused {
248         uint256 bptBalance = IWeightedPool(poolAddress).balanceOf(address(this));
249         if (bptBalance != 0) {
250             IVault.ExitPoolRequest memory request;
251             request.assets = poolAssets;
252             request.minAmountsOut = new uint256[](poolAssets.length);
253             request.minAmountsOut[tokenIndexInPool] = amount;
254             request.toInternalBalance = false;
255 
256             if (feiInPool) {
257                 // If FEI is in pool, we also remove an equivalent portion of FEI
258                 // from the pool, to conserve balance as much as possible
259                 (Decimal.D256 memory oracleValue, bool oracleValid) = tokenOraclesMapping[token].read();
260                 require(oracleValid, "BalancerPCVDepositWeightedPool: oracle invalid");
261                 uint256 amountFeiToWithdraw = oracleValue.mul(amount).asUint256();
262                 request.minAmountsOut[feiIndexInPool] = amountFeiToWithdraw;
263             }
264 
265             // Uses encoding for exact tokens out, spending at maximum bptBalance
266             bytes memory userData = abi.encode(
267                 IWeightedPool.ExitKind.BPT_IN_FOR_EXACT_TOKENS_OUT,
268                 request.minAmountsOut,
269                 bptBalance
270             );
271             request.userData = userData;
272 
273             vault.exitPool(poolId, address(this), payable(address(this)), request);
274             SafeERC20.safeTransfer(token, to, amount);
275             _burnFeiHeld();
276 
277             emit Withdrawal(msg.sender, to, amount);
278         }
279     }
280 
281     /// @notice read token oracles and revert if one of them is invalid
282     function _readOracles() internal view returns (uint256[] memory underlyingPrices) {
283         underlyingPrices = new uint256[](poolAssets.length);
284         for (uint256 i = 0; i < underlyingPrices.length; i++) {
285             (Decimal.D256 memory oracleValue, bool oracleValid) = tokenOraclesMapping[IERC20(address(poolAssets[i]))]
286                 .read();
287             require(oracleValid, "BalancerPCVDepositWeightedPool: invalid oracle");
288             underlyingPrices[i] = oracleValue.mul(1e18).asUint256();
289 
290             // normalize prices for tokens with different decimals
291             uint8 decimals = ERC20(address(poolAssets[i])).decimals();
292             require(decimals <= 18, "invalid decimals"); // should never happen
293             if (decimals < 18) {
294                 underlyingPrices[i] = underlyingPrices[i] * 10**(18 - decimals);
295             }
296         }
297     }
298 
299     /**
300      * Calculates the value of Balancer pool tokens using the logic described here:
301      * https://docs.gyro.finance/learn/oracles/bpt-oracle
302      * This is robust to price manipulations within the Balancer pool.
303      * Courtesy of Gyroscope protocol, used with permission. See the original file here :
304      * https://github.com/gyrostable/core/blob/master/contracts/GyroPriceOracle.sol#L109-L167
305      * @param underlyingPrices = array of prices for underlying assets in the pool,
306      *   given in USD, on a base of 18 decimals.
307      * @return bptPrice = the price of balancer pool tokens, in USD, on a base
308      *   of 18 decimals.
309      */
310     function _getBPTPrice(uint256[] memory underlyingPrices) internal view returns (uint256 bptPrice) {
311         IWeightedPool pool = IWeightedPool(poolAddress);
312         uint256 _bptSupply = pool.totalSupply();
313         uint256[] memory _weights = pool.getNormalizedWeights();
314         (, uint256[] memory _balances, ) = vault.getPoolTokens(poolId);
315 
316         uint256 _k = uint256(1e18);
317         uint256 _weightedProd = uint256(1e18);
318 
319         for (uint256 i = 0; i < poolAssets.length; i++) {
320             uint256 _tokenBalance = _balances[i];
321             uint256 _decimals = ERC20(address(poolAssets[i])).decimals();
322             if (_decimals < 18) {
323                 _tokenBalance = _tokenBalance.mul(10**(18 - _decimals));
324             }
325 
326             // if one of the tokens in the pool has zero balance, there is a problem
327             // in the pool, so we return zero
328             if (_tokenBalance == 0) {
329                 return 0;
330             }
331 
332             _k = _k.mulPow(_tokenBalance, _weights[i], 18);
333 
334             _weightedProd = _weightedProd.mulPow(underlyingPrices[i].scaledDiv(_weights[i], 18), _weights[i], 18);
335         }
336 
337         uint256 result = _k.scaledMul(_weightedProd).scaledDiv(_bptSupply);
338         return result;
339     }
340 }
