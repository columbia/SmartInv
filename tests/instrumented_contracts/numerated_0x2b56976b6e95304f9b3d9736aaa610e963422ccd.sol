1 /// OracleRelayer.sol
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU Affero General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 //
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU Affero General Public License for more details.
12 //
13 // You should have received a copy of the GNU Affero General Public License
14 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.6.7;
17 
18 abstract contract SAFEEngineLike {
19     function modifyParameters(bytes32, bytes32, uint) virtual external;
20 }
21 
22 abstract contract OracleLike {
23     function getResultWithValidity() virtual public view returns (uint256, bool);
24 }
25 
26 contract OracleRelayer {
27     // --- Auth ---
28     mapping (address => uint) public authorizedAccounts;
29     /**
30      * @notice Add auth to an account
31      * @param account Account to add auth to
32      */
33     function addAuthorization(address account) external isAuthorized {
34         authorizedAccounts[account] = 1;
35         emit AddAuthorization(account);
36     }
37     /**
38      * @notice Remove auth from an account
39      * @param account Account to remove auth from
40      */
41     function removeAuthorization(address account) external isAuthorized {
42         authorizedAccounts[account] = 0;
43         emit RemoveAuthorization(account);
44     }
45     /**
46     * @notice Checks whether msg.sender can call an authed function
47     **/
48     modifier isAuthorized {
49         require(authorizedAccounts[msg.sender] == 1, "OracleRelayer/account-not-authorized");
50         _;
51     }
52 
53     // --- Data ---
54     struct CollateralType {
55         // Usually an oracle security module that enforces delays to fresh price feeds
56         OracleLike orcl;
57         // CRatio used to compute the 'safePrice' - the price used when generating debt in SAFEEngine
58         uint256 safetyCRatio;
59         // CRatio used to compute the 'liquidationPrice' - the price used when liquidating SAFEs
60         uint256 liquidationCRatio;
61     }
62 
63     // Data about each collateral type
64     mapping (bytes32 => CollateralType) public collateralTypes;
65 
66     SAFEEngineLike public safeEngine;
67 
68     // Whether this contract is enabled
69     uint256 public contractEnabled;
70     // Virtual redemption price (not the most updated value)
71     uint256 internal _redemptionPrice;                                                        // [ray]
72     // The force that changes the system users' incentives by changing the redemption price
73     uint256 public redemptionRate;                                                            // [ray]
74     // Last time when the redemption price was changed
75     uint256 public redemptionPriceUpdateTime;                                                 // [unix epoch time]
76     // Upper bound for the per-second redemption rate
77     uint256 public redemptionRateUpperBound;                                                  // [ray]
78     // Lower bound for the per-second redemption rate
79     uint256 public redemptionRateLowerBound;                                                  // [ray]
80 
81     // --- Events ---
82     event AddAuthorization(address account);
83     event RemoveAuthorization(address account);
84     event DisableContract();
85     event ModifyParameters(
86         bytes32 collateralType,
87         bytes32 parameter,
88         address addr
89     );
90     event ModifyParameters(bytes32 parameter, uint data);
91     event ModifyParameters(
92         bytes32 collateralType,
93         bytes32 parameter,
94         uint data
95     );
96     event UpdateRedemptionPrice(uint redemptionPrice);
97     event UpdateCollateralPrice(
98       bytes32 collateralType,
99       uint256 priceFeedValue,
100       uint256 safetyPrice,
101       uint256 liquidationPrice
102     );
103 
104     // --- Init ---
105     constructor(address safeEngine_) public {
106         authorizedAccounts[msg.sender] = 1;
107         safeEngine                 = SAFEEngineLike(safeEngine_);
108         _redemptionPrice           = RAY;
109         redemptionRate             = RAY;
110         redemptionPriceUpdateTime  = now;
111         redemptionRateUpperBound   = RAY * WAD;
112         redemptionRateLowerBound   = 1;
113         contractEnabled            = 1;
114         emit AddAuthorization(msg.sender);
115     }
116 
117     // --- Math ---
118     uint constant WAD = 10 ** 18;
119     uint constant RAY = 10 ** 27;
120 
121     function subtract(uint x, uint y) internal pure returns (uint z) {
122         z = x - y;
123         require(z <= x);
124     }
125     function multiply(uint x, uint y) internal pure returns (uint z) {
126         require(y == 0 || (z = x * y) / y == x);
127     }
128     function rmultiply(uint x, uint y) internal pure returns (uint z) {
129         // alsites rounds down
130         z = multiply(x, y) / RAY;
131     }
132     function rdivide(uint x, uint y) internal pure returns (uint z) {
133         z = multiply(x, RAY) / y;
134     }
135     function rpower(uint x, uint n, uint base) internal pure returns (uint z) {
136         assembly {
137             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
138             default {
139                 switch mod(n, 2) case 0 { z := base } default { z := x }
140                 let half := div(base, 2)  // for rounding.
141                 for { n := div(n, 2) } n { n := div(n,2) } {
142                     let xx := mul(x, x)
143                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
144                     let xxRound := add(xx, half)
145                     if lt(xxRound, xx) { revert(0,0) }
146                     x := div(xxRound, base)
147                     if mod(n,2) {
148                         let zx := mul(z, x)
149                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
150                         let zxRound := add(zx, half)
151                         if lt(zxRound, zx) { revert(0,0) }
152                         z := div(zxRound, base)
153                     }
154                 }
155             }
156         }
157     }
158 
159     // --- Administration ---
160     /**
161      * @notice Modify oracle price feed addresses
162      * @param collateralType Collateral who's oracle we change
163      * @param parameter Name of the parameter
164      * @param addr New oracle address
165      */
166     function modifyParameters(
167         bytes32 collateralType,
168         bytes32 parameter,
169         address addr
170     ) external isAuthorized {
171         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
172         if (parameter == "orcl") collateralTypes[collateralType].orcl = OracleLike(addr);
173         else revert("OracleRelayer/modify-unrecognized-param");
174         emit ModifyParameters(
175             collateralType,
176             parameter,
177             addr
178         );
179     }
180     /**
181      * @notice Modify redemption related parameters
182      * @param parameter Name of the parameter
183      * @param data New param value
184      */
185     function modifyParameters(bytes32 parameter, uint data) external isAuthorized {
186         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
187         require(data > 0, "OracleRelayer/null-data");
188         if (parameter == "redemptionPrice") {
189           require(data > 0, "OracleRelayer/null-redemption-price");
190           _redemptionPrice = data;
191         }
192         else if (parameter == "redemptionRate") {
193           require(now == redemptionPriceUpdateTime, "OracleRelayer/redemption-price-not-updated");
194           uint256 adjustedRate = data;
195           if (data > redemptionRateUpperBound) {
196             adjustedRate = redemptionRateUpperBound;
197           } else if (data < redemptionRateLowerBound) {
198             adjustedRate = redemptionRateLowerBound;
199           }
200           redemptionRate = adjustedRate;
201         }
202         else if (parameter == "redemptionRateUpperBound") {
203           require(data > RAY, "OracleRelayer/invalid-redemption-rate-upper-bound");
204           redemptionRateUpperBound = data;
205         }
206         else if (parameter == "redemptionRateLowerBound") {
207           require(data < RAY, "OracleRelayer/invalid-redemption-rate-lower-bound");
208           redemptionRateLowerBound = data;
209         }
210         else revert("OracleRelayer/modify-unrecognized-param");
211         emit ModifyParameters(
212             parameter,
213             data
214         );
215     }
216     /**
217      * @notice Modify CRatio related parameters
218      * @param collateralType Collateral who's parameters we change
219      * @param parameter Name of the parameter
220      * @param data New param value
221      */
222     function modifyParameters(
223         bytes32 collateralType,
224         bytes32 parameter,
225         uint data
226     ) external isAuthorized {
227         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
228         if (parameter == "safetyCRatio") {
229           require(data >= collateralTypes[collateralType].liquidationCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
230           collateralTypes[collateralType].safetyCRatio = data;
231         }
232         else if (parameter == "liquidationCRatio") {
233           require(data <= collateralTypes[collateralType].safetyCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
234           collateralTypes[collateralType].liquidationCRatio = data;
235         }
236         else revert("OracleRelayer/modify-unrecognized-param");
237         emit ModifyParameters(
238             collateralType,
239             parameter,
240             data
241         );
242     }
243 
244     // --- Redemption Price Update ---
245     /**
246      * @notice Update the redemption price according to the current redemption rate
247      */
248     function updateRedemptionPrice() internal returns (uint) {
249         // Update redemption price
250         _redemptionPrice = rmultiply(
251           rpower(redemptionRate, subtract(now, redemptionPriceUpdateTime), RAY),
252           _redemptionPrice
253         );
254         if (_redemptionPrice == 0) _redemptionPrice = 1;
255         redemptionPriceUpdateTime = now;
256         emit UpdateRedemptionPrice(_redemptionPrice);
257         // Return updated redemption price
258         return _redemptionPrice;
259     }
260     /**
261      * @notice Fetch the latest redemption price by first updating it
262      */
263     function redemptionPrice() public returns (uint) {
264         if (now > redemptionPriceUpdateTime) return updateRedemptionPrice();
265         return _redemptionPrice;
266     }
267 
268     // --- Update value ---
269     /**
270      * @notice Update the collateral price inside the system (inside SAFEEngine)
271      * @param collateralType The collateral we want to update prices (safety and liquidation prices) for
272      */
273     function updateCollateralPrice(bytes32 collateralType) external {
274         (uint256 priceFeedValue, bool hasValidValue) =
275           collateralTypes[collateralType].orcl.getResultWithValidity();
276         uint redemptionPrice_ = redemptionPrice();
277         uint256 safetyPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].safetyCRatio) : 0;
278         uint256 liquidationPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].liquidationCRatio) : 0;
279 
280         safeEngine.modifyParameters(collateralType, "safetyPrice", safetyPrice_);
281         safeEngine.modifyParameters(collateralType, "liquidationPrice", liquidationPrice_);
282         emit UpdateCollateralPrice(collateralType, priceFeedValue, safetyPrice_, liquidationPrice_);
283     }
284 
285     /**
286      * @notice Disable this contract (normally called by GlobalSettlement)
287      */
288     function disableContract() external isAuthorized {
289         contractEnabled = 0;
290         redemptionRate = RAY;
291         emit DisableContract();
292     }
293 
294     /**
295      * @notice Fetch the safety CRatio of a specific collateral type
296      * @param collateralType The collateral price we want the safety CRatio for
297      */
298     function safetyCRatio(bytes32 collateralType) public view returns (uint256) {
299         return collateralTypes[collateralType].safetyCRatio;
300     }
301     /**
302      * @notice Fetch the liquidation CRatio of a specific collateral type
303      * @param collateralType The collateral price we want the liquidation CRatio for
304      */
305     function liquidationCRatio(bytes32 collateralType) public view returns (uint256) {
306         return collateralTypes[collateralType].liquidationCRatio;
307     }
308     /**
309      * @notice Fetch the oracle price feed of a specific collateral type
310      * @param collateralType The collateral price we want the oracle price feed for
311      */
312     function orcl(bytes32 collateralType) public view returns (address) {
313         return address(collateralTypes[collateralType].orcl);
314     }
315 }