1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/fs14a1fn2n0n355szi63iq33n5yzygnk-geb/dapp/geb/src/OracleRelayer.sol
4 
5 pragma solidity =0.6.7;
6 
7 ////// /nix/store/fs14a1fn2n0n355szi63iq33n5yzygnk-geb/dapp/geb/src/OracleRelayer.sol
8 /// OracleRelayer.sol
9 
10 // This program is free software: you can redistribute it and/or modify
11 // it under the terms of the GNU Affero General Public License as published by
12 // the Free Software Foundation, either version 3 of the License, or
13 // (at your option) any later version.
14 //
15 // This program is distributed in the hope that it will be useful,
16 // but WITHOUT ANY WARRANTY; without even the implied warranty of
17 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
18 // GNU Affero General Public License for more details.
19 //
20 // You should have received a copy of the GNU Affero General Public License
21 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
22 
23 /* pragma solidity 0.6.7; */
24 
25 abstract contract SAFEEngineLike_9 {
26     function modifyParameters(bytes32, bytes32, uint256) virtual external;
27 }
28 
29 abstract contract OracleLike_3 {
30     function getResultWithValidity() virtual public view returns (uint256, bool);
31 }
32 
33 contract OracleRelayer {
34     // --- Auth ---
35     mapping (address => uint256) public authorizedAccounts;
36     /**
37      * @notice Add auth to an account
38      * @param account Account to add auth to
39      */
40     function addAuthorization(address account) external isAuthorized {
41         authorizedAccounts[account] = 1;
42         emit AddAuthorization(account);
43     }
44     /**
45      * @notice Remove auth from an account
46      * @param account Account to remove auth from
47      */
48     function removeAuthorization(address account) external isAuthorized {
49         authorizedAccounts[account] = 0;
50         emit RemoveAuthorization(account);
51     }
52     /**
53     * @notice Checks whether msg.sender can call an authed function
54     **/
55     modifier isAuthorized {
56         require(authorizedAccounts[msg.sender] == 1, "OracleRelayer/account-not-authorized");
57         _;
58     }
59 
60     // --- Data ---
61     struct CollateralType {
62         // Usually an oracle security module that enforces delays to fresh price feeds
63         OracleLike_3 orcl;
64         // CRatio used to compute the 'safePrice' - the price used when generating debt in SAFEEngine
65         uint256 safetyCRatio;
66         // CRatio used to compute the 'liquidationPrice' - the price used when liquidating SAFEs
67         uint256 liquidationCRatio;
68     }
69 
70     // Data about each collateral type
71     mapping (bytes32 => CollateralType) public collateralTypes;
72 
73     SAFEEngineLike_9 public safeEngine;
74 
75     // Whether this contract is enabled
76     uint256 public contractEnabled;
77     // Virtual redemption price (not the most updated value)
78     uint256 internal _redemptionPrice;                                                        // [ray]
79     // The force that changes the system users' incentives by changing the redemption price
80     uint256 public redemptionRate;                                                            // [ray]
81     // Last time when the redemption price was changed
82     uint256 public redemptionPriceUpdateTime;                                                 // [unix epoch time]
83     // Upper bound for the per-second redemption rate
84     uint256 public redemptionRateUpperBound;                                                  // [ray]
85     // Lower bound for the per-second redemption rate
86     uint256 public redemptionRateLowerBound;                                                  // [ray]
87 
88     // --- Events ---
89     event AddAuthorization(address account);
90     event RemoveAuthorization(address account);
91     event DisableContract();
92     event ModifyParameters(
93         bytes32 collateralType,
94         bytes32 parameter,
95         address addr
96     );
97     event ModifyParameters(bytes32 parameter, uint256 data);
98     event ModifyParameters(
99         bytes32 collateralType,
100         bytes32 parameter,
101         uint256 data
102     );
103     event UpdateRedemptionPrice(uint256 redemptionPrice);
104     event UpdateCollateralPrice(
105       bytes32 indexed collateralType,
106       uint256 priceFeedValue,
107       uint256 safetyPrice,
108       uint256 liquidationPrice
109     );
110 
111     // --- Init ---
112     constructor(address safeEngine_) public {
113         authorizedAccounts[msg.sender] = 1;
114 
115         safeEngine                     = SAFEEngineLike_9(safeEngine_);
116         _redemptionPrice               = RAY;
117         redemptionRate                 = RAY;
118         redemptionPriceUpdateTime      = now;
119         redemptionRateUpperBound       = RAY * WAD;
120         redemptionRateLowerBound       = 1;
121         contractEnabled                = 1;
122 
123         emit AddAuthorization(msg.sender);
124     }
125 
126     // --- Math ---
127     uint256 constant WAD = 10 ** 18;
128     uint256 constant RAY = 10 ** 27;
129 
130     function subtract(uint256 x, uint256 y) internal pure returns (uint256 z) {
131         z = x - y;
132         require(z <= x, "OracleRelayer/sub-underflow");
133     }
134     function multiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
135         require(y == 0 || (z = x * y) / y == x, "OracleRelayer/mul-overflow");
136     }
137     function rmultiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
138         // always rounds down
139         z = multiply(x, y) / RAY;
140     }
141     function rdivide(uint256 x, uint256 y) internal pure returns (uint256 z) {
142         require(y > 0, "OracleRelayer/rdiv-by-zero");
143         z = multiply(x, RAY) / y;
144     }
145     function rpower(uint256 x, uint256 n, uint256 base) internal pure returns (uint256 z) {
146         assembly {
147             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
148             default {
149                 switch mod(n, 2) case 0 { z := base } default { z := x }
150                 let half := div(base, 2)  // for rounding.
151                 for { n := div(n, 2) } n { n := div(n,2) } {
152                     let xx := mul(x, x)
153                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
154                     let xxRound := add(xx, half)
155                     if lt(xxRound, xx) { revert(0,0) }
156                     x := div(xxRound, base)
157                     if mod(n,2) {
158                         let zx := mul(z, x)
159                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
160                         let zxRound := add(zx, half)
161                         if lt(zxRound, zx) { revert(0,0) }
162                         z := div(zxRound, base)
163                     }
164                 }
165             }
166         }
167     }
168 
169     // --- Administration ---
170     /**
171      * @notice Modify oracle price feed addresses
172      * @param collateralType Collateral whose oracle we change
173      * @param parameter Name of the parameter
174      * @param addr New oracle address
175      */
176     function modifyParameters(
177         bytes32 collateralType,
178         bytes32 parameter,
179         address addr
180     ) external isAuthorized {
181         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
182         if (parameter == "orcl") collateralTypes[collateralType].orcl = OracleLike_3(addr);
183         else revert("OracleRelayer/modify-unrecognized-param");
184         emit ModifyParameters(
185             collateralType,
186             parameter,
187             addr
188         );
189     }
190     /**
191      * @notice Modify redemption rate/price related parameters
192      * @param parameter Name of the parameter
193      * @param data New param value
194      */
195     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
196         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
197         require(data > 0, "OracleRelayer/null-data");
198         if (parameter == "redemptionPrice") {
199           _redemptionPrice = data;
200         }
201         else if (parameter == "redemptionRate") {
202           require(now == redemptionPriceUpdateTime, "OracleRelayer/redemption-price-not-updated");
203           uint256 adjustedRate = data;
204           if (data > redemptionRateUpperBound) {
205             adjustedRate = redemptionRateUpperBound;
206           } else if (data < redemptionRateLowerBound) {
207             adjustedRate = redemptionRateLowerBound;
208           }
209           redemptionRate = adjustedRate;
210         }
211         else if (parameter == "redemptionRateUpperBound") {
212           require(data > RAY, "OracleRelayer/invalid-redemption-rate-upper-bound");
213           redemptionRateUpperBound = data;
214         }
215         else if (parameter == "redemptionRateLowerBound") {
216           require(data < RAY, "OracleRelayer/invalid-redemption-rate-lower-bound");
217           redemptionRateLowerBound = data;
218         }
219         else revert("OracleRelayer/modify-unrecognized-param");
220         emit ModifyParameters(
221             parameter,
222             data
223         );
224     }
225     /**
226      * @notice Modify CRatio related parameters
227      * @param collateralType Collateral whose parameters we change
228      * @param parameter Name of the parameter
229      * @param data New param value
230      */
231     function modifyParameters(
232         bytes32 collateralType,
233         bytes32 parameter,
234         uint256 data
235     ) external isAuthorized {
236         require(contractEnabled == 1, "OracleRelayer/contract-not-enabled");
237         if (parameter == "safetyCRatio") {
238           require(data >= collateralTypes[collateralType].liquidationCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
239           collateralTypes[collateralType].safetyCRatio = data;
240         }
241         else if (parameter == "liquidationCRatio") {
242           require(data <= collateralTypes[collateralType].safetyCRatio, "OracleRelayer/safety-lower-than-liquidation-cratio");
243           collateralTypes[collateralType].liquidationCRatio = data;
244         }
245         else revert("OracleRelayer/modify-unrecognized-param");
246         emit ModifyParameters(
247             collateralType,
248             parameter,
249             data
250         );
251     }
252 
253     // --- Redemption Price Update ---
254     /**
255      * @notice Update the redemption price using the current redemption rate
256      */
257     function updateRedemptionPrice() internal returns (uint256) {
258         // Update redemption price
259         _redemptionPrice = rmultiply(
260           rpower(redemptionRate, subtract(now, redemptionPriceUpdateTime), RAY),
261           _redemptionPrice
262         );
263         if (_redemptionPrice == 0) _redemptionPrice = 1;
264         redemptionPriceUpdateTime = now;
265         emit UpdateRedemptionPrice(_redemptionPrice);
266         // Return updated redemption price
267         return _redemptionPrice;
268     }
269     /**
270      * @notice Fetch the latest redemption price by first updating it
271      */
272     function redemptionPrice() public returns (uint256) {
273         if (now > redemptionPriceUpdateTime) return updateRedemptionPrice();
274         return _redemptionPrice;
275     }
276 
277     // --- Update value ---
278     /**
279      * @notice Update the collateral price inside the system (inside SAFEEngine)
280      * @param collateralType The collateral we want to update prices (safety and liquidation prices) for
281      */
282     function updateCollateralPrice(bytes32 collateralType) external {
283         (uint256 priceFeedValue, bool hasValidValue) =
284           collateralTypes[collateralType].orcl.getResultWithValidity();
285         uint256 redemptionPrice_ = redemptionPrice();
286         uint256 safetyPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint256(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].safetyCRatio) : 0;
287         uint256 liquidationPrice_ = hasValidValue ? rdivide(rdivide(multiply(uint256(priceFeedValue), 10 ** 9), redemptionPrice_), collateralTypes[collateralType].liquidationCRatio) : 0;
288 
289         safeEngine.modifyParameters(collateralType, "safetyPrice", safetyPrice_);
290         safeEngine.modifyParameters(collateralType, "liquidationPrice", liquidationPrice_);
291         emit UpdateCollateralPrice(collateralType, priceFeedValue, safetyPrice_, liquidationPrice_);
292     }
293 
294     /**
295      * @notice Disable this contract (normally called by GlobalSettlement)
296      */
297     function disableContract() external isAuthorized {
298         contractEnabled = 0;
299         redemptionRate = RAY;
300         emit DisableContract();
301     }
302 
303     /**
304      * @notice Fetch the safety CRatio of a specific collateral type
305      * @param collateralType The collateral type we want the safety CRatio for
306      */
307     function safetyCRatio(bytes32 collateralType) public view returns (uint256) {
308         return collateralTypes[collateralType].safetyCRatio;
309     }
310     /**
311      * @notice Fetch the liquidation CRatio of a specific collateral type
312      * @param collateralType The collateral type we want the liquidation CRatio for
313      */
314     function liquidationCRatio(bytes32 collateralType) public view returns (uint256) {
315         return collateralTypes[collateralType].liquidationCRatio;
316     }
317     /**
318      * @notice Fetch the oracle price feed of a specific collateral type
319      * @param collateralType The collateral type we want the oracle price feed for
320      */
321     function orcl(bytes32 collateralType) public view returns (address) {
322         return address(collateralTypes[collateralType].orcl);
323     }
324 }
