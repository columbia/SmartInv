1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/bna431n14gaiilbd4nj2wsgpa08vq265-geb-rrfm-rate-setter/dapp/geb-rrfm-rate-setter/src/PIRateSetter.sol
4 
5 pragma solidity =0.6.7;
6 
7 ////// /nix/store/npsy3mivgrrb261vicfv9nqb6dza0y3c-geb-treasury-reimbursement/dapp/geb-treasury-reimbursement/src/math/GebMath.sol
8 /* pragma solidity 0.6.7; */
9 
10 contract GebMath {
11     uint256 public constant RAY = 10 ** 27;
12     uint256 public constant WAD = 10 ** 18;
13 
14     function ray(uint x) public pure returns (uint z) {
15         z = multiply(x, 10 ** 9);
16     }
17     function rad(uint x) public pure returns (uint z) {
18         z = multiply(x, 10 ** 27);
19     }
20     function minimum(uint x, uint y) public pure returns (uint z) {
21         z = (x <= y) ? x : y;
22     }
23     function addition(uint x, uint y) public pure returns (uint z) {
24         z = x + y;
25         require(z >= x, "uint-uint-add-overflow");
26     }
27     function subtract(uint x, uint y) public pure returns (uint z) {
28         z = x - y;
29         require(z <= x, "uint-uint-sub-underflow");
30     }
31     function multiply(uint x, uint y) public pure returns (uint z) {
32         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
33     }
34     function rmultiply(uint x, uint y) public pure returns (uint z) {
35         z = multiply(x, y) / RAY;
36     }
37     function rdivide(uint x, uint y) public pure returns (uint z) {
38         z = multiply(x, RAY) / y;
39     }
40     function wdivide(uint x, uint y) public pure returns (uint z) {
41         z = multiply(x, WAD) / y;
42     }
43     function wmultiply(uint x, uint y) public pure returns (uint z) {
44         z = multiply(x, y) / WAD;
45     }
46     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
47         assembly {
48             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
49             default {
50                 switch mod(n, 2) case 0 { z := base } default { z := x }
51                 let half := div(base, 2)  // for rounding.
52                 for { n := div(n, 2) } n { n := div(n,2) } {
53                     let xx := mul(x, x)
54                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
55                     let xxRound := add(xx, half)
56                     if lt(xxRound, xx) { revert(0,0) }
57                     x := div(xxRound, base)
58                     if mod(n,2) {
59                         let zx := mul(z, x)
60                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
61                         let zxRound := add(zx, half)
62                         if lt(zxRound, zx) { revert(0,0) }
63                         z := div(zxRound, base)
64                     }
65                 }
66             }
67         }
68     }
69 }
70 
71 ////// /nix/store/bna431n14gaiilbd4nj2wsgpa08vq265-geb-rrfm-rate-setter/dapp/geb-rrfm-rate-setter/src/PIRateSetter.sol
72 // Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC, Reflexer Labs, INC.
73 
74 // This program is free software: you can redistribute it and/or modify
75 // it under the terms of the GNU General Public License as published by
76 // the Free Software Foundation, either version 3 of the License, or
77 // (at your option) any later version.
78 
79 // This program is distributed in the hope that it will be useful,
80 // but WITHOUT ANY WARRANTY; without even the implied warranty of
81 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
82 // GNU General Public License for more details.
83 
84 // You should have received a copy of the GNU General Public License
85 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
86 
87 /* pragma solidity 0.6.7; */
88 
89 /* import "geb-treasury-reimbursement/math/GebMath.sol"; */
90 
91 abstract contract OracleLike_2 {
92     function getResultWithValidity() virtual external view returns (uint256, bool);
93 }
94 abstract contract OracleRelayerLike_2 {
95     function redemptionPrice() virtual external returns (uint256);
96 }
97 abstract contract SetterRelayer_2 {
98     function relayRate(uint256, address) virtual external;
99 }
100 abstract contract PIDCalculator_1 {
101     function computeRate(uint256, uint256, uint256) virtual external returns (uint256);
102     function rt(uint256, uint256, uint256) virtual external view returns (uint256);
103     function pscl() virtual external view returns (uint256);
104     function tlv() virtual external view returns (uint256);
105 }
106 
107 contract PIRateSetter is GebMath {
108     // --- Auth ---
109     mapping (address => uint) public authorizedAccounts;
110     /**
111      * @notice Add auth to an account
112      * @param account Account to add auth to
113      */
114     function addAuthorization(address account) external isAuthorized {
115         authorizedAccounts[account] = 1;
116         emit AddAuthorization(account);
117     }
118     /**
119      * @notice Remove auth from an account
120      * @param account Account to remove auth from
121      */
122     function removeAuthorization(address account) external isAuthorized {
123         authorizedAccounts[account] = 0;
124         emit RemoveAuthorization(account);
125     }
126     /**
127     * @notice Checks whether msg.sender can call an authed function
128     **/
129     modifier isAuthorized {
130         require(authorizedAccounts[msg.sender] == 1, "PIRateSetter/account-not-authorized");
131         _;
132     }
133 
134     // --- Variables ---
135     // When the price feed was last updated
136     uint256 public lastUpdateTime;                  // [timestamp]
137     // Enforced gap between calls
138     uint256 public updateRateDelay;                 // [seconds]
139     // Whether the leak is set to zero by default
140     uint256 public defaultLeak;                     // [0 or 1]
141 
142     // --- System Dependencies ---
143     // OSM or medianizer for the system coin
144     OracleLike_2                public orcl;
145     // OracleRelayer where the redemption price is stored
146     OracleRelayerLike_2         public oracleRelayer;
147     // The contract that will pass the new redemption rate to the oracle relayer
148     SetterRelayer_2             public setterRelayer;
149     // Calculator for the redemption rate
150     PIDCalculator_1             public pidCalculator;
151 
152     // --- Events ---
153     event AddAuthorization(address account);
154     event RemoveAuthorization(address account);
155     event ModifyParameters(
156       bytes32 parameter,
157       address addr
158     );
159     event ModifyParameters(
160       bytes32 parameter,
161       uint256 val
162     );
163     event UpdateRedemptionRate(
164         uint marketPrice,
165         uint redemptionPrice,
166         uint redemptionRate
167     );
168     event FailUpdateRedemptionRate(
169         uint marketPrice,
170         uint redemptionPrice,
171         uint redemptionRate,
172         bytes reason
173     );
174 
175     constructor(
176       address oracleRelayer_,
177       address setterRelayer_,
178       address orcl_,
179       address pidCalculator_,
180       uint256 updateRateDelay_
181     ) public {
182         require(oracleRelayer_ != address(0), "PIRateSetter/null-oracle-relayer");
183         require(setterRelayer_ != address(0), "PIRateSetter/null-setter-relayer");
184         require(orcl_ != address(0), "PIRateSetter/null-orcl");
185         require(pidCalculator_ != address(0), "PIRateSetter/null-calculator");
186 
187         authorizedAccounts[msg.sender] = 1;
188         defaultLeak                    = 1;
189 
190         oracleRelayer    = OracleRelayerLike_2(oracleRelayer_);
191         setterRelayer    = SetterRelayer_2(setterRelayer_);
192         orcl             = OracleLike_2(orcl_);
193         pidCalculator    = PIDCalculator_1(pidCalculator_);
194 
195         updateRateDelay  = updateRateDelay_;
196 
197         emit AddAuthorization(msg.sender);
198         emit ModifyParameters("orcl", orcl_);
199         emit ModifyParameters("oracleRelayer", oracleRelayer_);
200         emit ModifyParameters("setterRelayer", setterRelayer_);
201         emit ModifyParameters("pidCalculator", pidCalculator_);
202         emit ModifyParameters("updateRateDelay", updateRateDelay_);
203     }
204 
205     // --- Boolean Logic ---
206     function either(bool x, bool y) internal pure returns (bool z) {
207         assembly{ z := or(x, y)}
208     }
209 
210     // --- Management ---
211     /*
212     * @notify Modify the address of a contract that the setter is connected to
213     * @param parameter Contract name
214     * @param addr The new contract address
215     */
216     function modifyParameters(bytes32 parameter, address addr) external isAuthorized {
217         require(addr != address(0), "PIRateSetter/null-addr");
218         if (parameter == "orcl") orcl = OracleLike_2(addr);
219         else if (parameter == "oracleRelayer") oracleRelayer = OracleRelayerLike_2(addr);
220         else if (parameter == "setterRelayer") setterRelayer = SetterRelayer_2(addr);
221         else if (parameter == "pidCalculator") {
222           pidCalculator = PIDCalculator_1(addr);
223         }
224         else revert("PIRateSetter/modify-unrecognized-param");
225         emit ModifyParameters(
226           parameter,
227           addr
228         );
229     }
230     /*
231     * @notify Modify a uint256 parameter
232     * @param parameter The parameter name
233     * @param val The new parameter value
234     */
235     function modifyParameters(bytes32 parameter, uint256 val) external isAuthorized {
236         if (parameter == "updateRateDelay") {
237           require(val > 0, "PIRateSetter/null-update-delay");
238           updateRateDelay = val;
239         }
240         else if (parameter == "defaultLeak") {
241           require(val <= 1, "PIRateSetter/invalid-default-leak");
242           defaultLeak = val;
243         }
244         else revert("PIRateSetter/modify-unrecognized-param");
245         emit ModifyParameters(
246           parameter,
247           val
248         );
249     }
250 
251     // --- Feedback Mechanism ---
252     /**
253     * @notice Compute and set a new redemption rate
254     * @param feeReceiver The proposed address that should receive the reward for calling this function
255     *        (unless it's address(0) in which case msg.sender will get it)
256     **/
257     function updateRate(address feeReceiver) external {
258         // The fee receiver must not be null
259         require(feeReceiver != address(0), "PIRateSetter/null-fee-receiver");
260         // Check delay between calls
261         require(either(subtract(now, lastUpdateTime) >= updateRateDelay, lastUpdateTime == 0), "PIRateSetter/wait-more");
262         // Get price feed updates
263         (uint256 marketPrice, bool hasValidValue) = orcl.getResultWithValidity();
264         // If the oracle has a value
265         require(hasValidValue, "PIRateSetter/invalid-oracle-value");
266         // If the price is non-zero
267         require(marketPrice > 0, "PIRateSetter/null-price");
268         // Get the latest redemption price
269         uint redemptionPrice = oracleRelayer.redemptionPrice();
270         // Calculate the rate
271         uint256 iapcr      = (defaultLeak == 1) ? RAY : rpower(pidCalculator.pscl(), pidCalculator.tlv(), RAY);
272         uint256 calculated = pidCalculator.computeRate(
273             marketPrice,
274             redemptionPrice,
275             iapcr
276         );
277         // Store the timestamp of the update
278         lastUpdateTime = now;
279         // Update the rate using the setter relayer
280         try setterRelayer.relayRate(calculated, feeReceiver) {
281           // Emit success event
282           emit UpdateRedemptionRate(
283             ray(marketPrice),
284             redemptionPrice,
285             calculated
286           );
287         }
288         catch(bytes memory revertReason) {
289           emit FailUpdateRedemptionRate(
290             ray(marketPrice),
291             redemptionPrice,
292             calculated,
293             revertReason
294           );
295         }
296     }
297 
298     // --- Getters ---
299     /**
300     * @notice Get the market price from the system coin oracle
301     **/
302     function getMarketPrice() external view returns (uint256) {
303         (uint256 marketPrice, ) = orcl.getResultWithValidity();
304         return marketPrice;
305     }
306     /**
307     * @notice Get the redemption and the market prices for the system coin
308     **/
309     function getRedemptionAndMarketPrices() external returns (uint256 marketPrice, uint256 redemptionPrice) {
310         (marketPrice, ) = orcl.getResultWithValidity();
311         redemptionPrice = oracleRelayer.redemptionPrice();
312     }
313 }
