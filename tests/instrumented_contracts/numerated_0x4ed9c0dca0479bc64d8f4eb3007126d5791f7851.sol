1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-02
3 */
4 
5 /// OracleRelayer.sol
6 
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU Affero General Public License as published by
9 // the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 //
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU Affero General Public License for more details.
16 //
17 // You should have received a copy of the GNU Affero General Public License
18 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
19 
20 pragma solidity 0.6.7;
21 
22 abstract contract SAFEEngineLike {
23     function modifyParameters(bytes32, bytes32, uint256) virtual external;
24 }
25 
26 abstract contract OracleLike {
27     function getResultWithValidity() virtual public view returns (uint256, bool);
28 }
29 
30 contract OracleRelayer {
31     // --- Auth ---
32     mapping (address => uint256) public authorizedAccounts;
33     /**
34      * @notice Add auth to an account
35      * @param account Account to add auth to
36      */
37     function addAuthorization(address account) external isAuthorized {
38         authorizedAccounts[account] = 1;
39         emit AddAuthorization(account);
40     }
41     /**
42      * @notice Remove auth from an account
43      * @param account Account to remove auth from
44      */
45     function removeAuthorization(address account) external isAuthorized {
46         authorizedAccounts[account] = 0;
47         emit RemoveAuthorization(account);
48     }
49     /**
50     * @notice Checks whether msg.sender can call an authed function
51     **/
52     modifier isAuthorized {
53         require(authorizedAccounts[msg.sender] == 1, "OracleRelayer/account-not-authorized");
54         _;
55     }
56 
57     // --- Data ---
58     struct CollateralType {
59         // Usually an oracle security module that enforces delays to fresh price feeds
60         OracleLike orcl;
61         // CRatio used to compute the 'safePrice' - the price used when generating debt in SAFEEngine
62         uint256 safetyCRatio;
63         // CRatio used to compute the 'liquidationPrice' - the price used when liquidating SAFEs
64         uint256 liquidationCRatio;
65     }
66 
67     // Data about each collateral type
68     mapping (bytes32 => CollateralType) public collateralTypes;
69 
70     SAFEEngineLike public safeEngine;
71 
72     // Whether this contract is enabled
73     uint256 public contractEnabled;
74     // Virtual redemption price (not the most updated value)
75     uint256 internal _redemptionPrice;                                                        // [ray]
76     // The force that changes the system users' incentives by changing the redemption price
77     uint256 public redemptionRate;                                                            // [ray]
78     // Last time when the redemption price was changed
79     uint256 public redemptionPriceUpdateTime;                                                 // [unix epoch time]
80     // Upper bound for the per-second redemption rate
81     uint256 public redemptionRateUpperBound;                                                  // [ray]
82     // Lower bound for the per-second redemption rate
83     uint256 public redemptionRateLowerBound;                                                  // [ray]
84 
85     // --- Events ---
86     event AddAuthorization(address account);
87     event RemoveAuthorization(address account);
88     event DisableContract();
89     event ModifyParameters(
90         bytes32 collateralType,
91         bytes32 parameter,
92         address addr
93     );
94     event ModifyParameters(bytes32 parameter, uint256 data);
95     event ModifyParameters(
96         bytes32 collateralType,
97         bytes32 parameter,
98         uint256 data
99     );
100     event UpdateRedemptionPrice(uint256 redemptionPrice);
101     event UpdateCollateralPrice(
102       bytes32 indexed collateralType,
103       uint256 priceFeedValue,
104       uint256 safetyPrice,
105       uint256 liquidationPrice
106     );
107 
108     // --- Init ---
109     constructor(address safeEngine_) public {
110         authorizedAccounts[msg.sender] = 1;
111         safeEngine                 = SAFEEngineLike(safeEngine_);
112         _redemptionPrice           = RAY;
113         redemptionRate             = RAY;
114         redemptionPriceUpdateTime  = now;
115         redemptionRateUpperBound   = RAY * WAD;
116         redemptionRateLowerBound   = 1;
117         contractEnabled            = 1;
118         emit AddAuthorization(msg.sender);
119     }
120 
121     // --- Math ---
122     uint256 constant WAD = 10 ** 18;
123     uint256 constant RAY = 10 ** 27;
124 
125     function subtract(uint256 x, uint256 y) internal pure returns (uint256 z) {
126         z = x - y;
127         require(z <= x, "OracleRelayer/sub-underflow");
128     }
129     function multiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
130         require(y == 0 || (z = x * y) / y == x, "OracleRelayer/mul-overflow");
131     }
132     function rmultiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
133         // always rounds down
134         z = multiply(x, y) / RAY;
135     }
136     function rdivide(uint256 x, uint256 y) internal pure returns (uint256 z) {
137         require(y > 0, "OracleRelayer/rdiv-by-zero");
138         z = multiply(x, RAY) / y;
139     }
140     function rpower(uint256 x, uint256 n, uint256 base) internal pure returns (uint256 z) {
141         assembly {
142             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
143             default {
144                 switch mod(n, 2) case 0 { z := base } default { z := x }
145                 let half := div(base, 2)  // for rounding.
146                 for { n := div(n, 2) } n { n := div(n,2) } {
147                     let xx := mul(x, x)
148                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
149                     let xxRound := add(xx, half)
150                     if lt(xxRound, xx) { revert(0,0) }
151                     x := div(xxRound, base)
152                     if mod(n,2) {
153                         let zx := mul(z, x)
154                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
155                         let zxRound := add(zx, half)
156                         if lt(zxRound, zx) { revert(0,0) }
157                         z := div(zxRound, base)
158                     }
159                 }
160             }
161         }
162     }
163 
164     // --- Administration ---
165     /**
166      * @notice Modify oracle price feed addresses
167      * @param collateralType Collateral whose oracle we change
168      * @param parameter Name of the parameter
169      * @param addr New oracle address
170      */
171     function modifyParameters(
172         bytes32 collateralType,
173         bytes32 parameter,
174         address addr
175     ) external isAuthorized {
176         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
177         if (parameter == "orcl") collateralTypes[collateralType].orcl = OracleLike(addr);
178         else revert("OracleRelayer/modify-unrecognized-param");
179         emit ModifyParameters(
180             collateralType,
181             parameter,
182             addr
183         );
184     }
185     /**
186      * @notice Modify redemption related parameters
187      * @param parameter Name of the parameter
188      * @param data New param value
189      */
190     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
191         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
192         require(data > 0, "OracleRelayer/null-data");
193         if (parameter == "redemptionPrice") {
194           _redemptionPrice = data;
195         }
196         else if (parameter == "redemptionRate") {
197           require(now == redemptionPriceUpdateTime, "OracleRelayer/redemption-price-not-updated");
198           uint256 adjustedRate = data;
199           if (data > redemptionRateUpperBound) {
200             adjustedRate = redemptionRateUpperBound;
201           } else if (data < redemptionRateLowerBound) {
202             adjustedRate = redemptionRateLowerBound;
203           }
204           redemptionRate = adjustedRate;
205         }
206         else if (parameter == "redemptionRateUpperBound") {
207           require(data > RAY, "OracleRelayer/invalid-redemption-rate-upper-bound");
208           redemptionRateUpperBound = data;
209         }
210         else if (parameter == "redemptionRateLowerBound") {
211           require(data < RAY, "OracleRelayer/invalid-redemption-rate-lower-bound");
212           redemptionRateLowerBound = data;
213         }
214         else revert("OracleRelayer/modify-unrecognized-param");
215         emit ModifyParameters(
216             parameter,
217             data
218         );
219     }
220     /**
221      * @notice Modify CRatio related parameters
222      * @param collateralType Collateral whose parameters we change
223      * @param parameter Name of the parameter
224      * @param data New param value
225      */
226     function modifyParameters(
227         bytes32 collateralType,
228         bytes32 parameter,
229         uint256 data
230     ) external isAuthorized {
231         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
232         if (parameter == "safetyCRatio") {
233           require(data >= collateralTypes[collateralType].liquidationCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
234           collateralTypes[collateralType].safetyCRatio = data;
235         }
236         else if (parameter == "liquidationCRatio") {
237           require(data <= collateralTypes[collateralType].safetyCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
238           collateralTypes[collateralType].liquidationCRatio = data;
239         }
240         else revert("OracleRelayer/modify-unrecognized-param");
241         emit ModifyParameters(
242             collateralType,
243             parameter,
244             data
245         );
246     }
247 
248     // --- Redemption Price Update ---
249     /**
250      * @notice Update the redemption price according to the current redemption rate
251      */
252     function updateRedemptionPrice() internal returns (uint256) {
253         // Update redemption price
254         _redemptionPrice = rmultiply(
255           rpower(redemptionRate, subtract(now, redemptionPriceUpdateTime), RAY),
256           _redemptionPrice
257         );
258         if (_redemptionPrice == 0) _redemptionPrice = 1;
259         redemptionPriceUpdateTime = now;
260         emit UpdateRedemptionPrice(_redemptionPrice);
261         // Return updated redemption price
262         return _redemptionPrice;
263     }
264     /**
265      * @notice Fetch the latest redemption price by first updating it
266      */
267     function redemptionPrice() public returns (uint256) {
268         if (now > redemptionPriceUpdateTime) return updateRedemptionPrice();
269         return _redemptionPrice;
270     }
271 
272     // --- Update value ---
273     /**
274      * @notice Update the collateral price inside the system (inside SAFEEngine)
275      * @param collateralType The collateral we want to update prices (safety and liquidation prices) for
276      */
277     function updateCollateralPrice(bytes32 collateralType) external {
278         (uint256 priceFeedValue, bool hasValidValue) =
279           collateralTypes[collateralType].orcl.getResultWithValidity();
280         uint256 redemptionPrice_ = redemptionPrice();
281         uint256 safetyPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint256(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].safetyCRatio) : 0;
282         uint256 liquidationPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint256(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].liquidationCRatio) : 0;
283 
284         safeEngine.modifyParameters(collateralType, "safetyPrice", safetyPrice_);
285         safeEngine.modifyParameters(collateralType, "liquidationPrice", liquidationPrice_);
286         emit UpdateCollateralPrice(collateralType, priceFeedValue, safetyPrice_, liquidationPrice_);
287     }
288 
289     /**
290      * @notice Disable this contract (normally called by GlobalSettlement)
291      */
292     function disableContract() external isAuthorized {
293         contractEnabled = 0;
294         redemptionRate = RAY;
295         emit DisableContract();
296     }
297 
298     /**
299      * @notice Fetch the safety CRatio of a specific collateral type
300      * @param collateralType The collateral type we want the safety CRatio for
301      */
302     function safetyCRatio(bytes32 collateralType) public view returns (uint256) {
303         return collateralTypes[collateralType].safetyCRatio;
304     }
305     /**
306      * @notice Fetch the liquidation CRatio of a specific collateral type
307      * @param collateralType The collateral type we want the liquidation CRatio for
308      */
309     function liquidationCRatio(bytes32 collateralType) public view returns (uint256) {
310         return collateralTypes[collateralType].liquidationCRatio;
311     }
312     /**
313      * @notice Fetch the oracle price feed of a specific collateral type
314      * @param collateralType The collateral type we want the oracle price feed for
315      */
316     function orcl(bytes32 collateralType) public view returns (address) {
317         return address(collateralTypes[collateralType].orcl);
318     }
319 }