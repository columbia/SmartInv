1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IOracle.sol";
5 import "./ICollateralizationOracleWrapper.sol";
6 import "../../Constants.sol";
7 import "../../utils/Timed.sol";
8 import "../../refs/CoreRef.sol";
9 
10 interface IPausable {
11     function paused() external view returns (bool);
12 }
13 
14 /// @title Fei Protocol's Collateralization Oracle
15 /// @author eswak
16 /// @notice Reads a list of PCVDeposit that report their amount of collateral
17 ///         and the amount of protocol-owned FEI they manage, to deduce the
18 ///         protocol-wide collateralization ratio.
19 contract CollateralizationOracleWrapper is Timed, ICollateralizationOracleWrapper, CoreRef {
20     using Decimal for Decimal.D256;
21 
22     // ----------- Properties --------------------------------------------------
23 
24     /// @notice address of the CollateralizationOracle to memoize
25     address public override collateralizationOracle;
26 
27     /// @notice cached value of the Protocol Controlled Value
28     uint256 public override cachedProtocolControlledValue;
29     /// @notice cached value of the User Circulating FEI
30     uint256 public override cachedUserCirculatingFei;
31     /// @notice cached value of the Protocol Equity
32     int256 public override cachedProtocolEquity;
33 
34     /// @notice deviation threshold to consider cached values outdated, in basis
35     ///         points (base 10_000)
36     uint256 public override deviationThresholdBasisPoints;
37 
38     /// @notice a flag to override pause behavior for reads
39     bool public override readPauseOverride;
40 
41     // ----------- Constructor -------------------------------------------------
42 
43     /// @notice CollateralizationOracleWrapper constructor
44     /// @param _core Fei Core for reference.
45     /// @param _validityDuration the duration after which a reading becomes outdated.
46     constructor(address _core, uint256 _validityDuration) CoreRef(_core) Timed(_validityDuration) {}
47 
48     /// @notice CollateralizationOracleWrapper initializer
49     /// @param _core Fei Core for reference.
50     /// @param _collateralizationOracle the CollateralizationOracle to inspect.
51     /// @param _validityDuration the duration after which a reading becomes outdated.
52     /// @param _deviationThresholdBasisPoints threshold for deviation after which
53     ///        keepers should call the update() function.
54     function initialize(
55         address _core,
56         address _collateralizationOracle,
57         uint256 _validityDuration,
58         uint256 _deviationThresholdBasisPoints
59     ) public {
60         require(collateralizationOracle == address(0), "CollateralizationOracleWrapper: initialized");
61         CoreRef._initialize(_core);
62         _setDuration(_validityDuration);
63         collateralizationOracle = _collateralizationOracle;
64         deviationThresholdBasisPoints = _deviationThresholdBasisPoints;
65 
66         // Shared admin with other oracles
67         _setContractAdminRole(keccak256("ORACLE_ADMIN_ROLE"));
68     }
69 
70     // ----------- Setter methods ----------------------------------------------
71 
72     /// @notice set the address of the CollateralizationOracle to inspect, and
73     /// to cache values from.
74     /// @param _newCollateralizationOracle the address of the new oracle.
75     function setCollateralizationOracle(address _newCollateralizationOracle) external override onlyGovernor {
76         require(_newCollateralizationOracle != address(0), "CollateralizationOracleWrapper: invalid address");
77         address _oldCollateralizationOracle = collateralizationOracle;
78 
79         collateralizationOracle = _newCollateralizationOracle;
80 
81         emit CollateralizationOracleUpdate(msg.sender, _oldCollateralizationOracle, _newCollateralizationOracle);
82     }
83 
84     /// @notice set the deviation threshold in basis points, used to detect if the
85     /// cached value deviated significantly from the actual fresh readings.
86     /// @param _newDeviationThresholdBasisPoints the new value to set.
87     function setDeviationThresholdBasisPoints(uint256 _newDeviationThresholdBasisPoints)
88         external
89         override
90         onlyGovernorOrAdmin
91     {
92         require(
93             _newDeviationThresholdBasisPoints > 0 && _newDeviationThresholdBasisPoints <= 10_000,
94             "CollateralizationOracleWrapper: invalid basis points"
95         );
96         uint256 _oldDeviationThresholdBasisPoints = deviationThresholdBasisPoints;
97 
98         deviationThresholdBasisPoints = _newDeviationThresholdBasisPoints;
99 
100         emit DeviationThresholdUpdate(msg.sender, _oldDeviationThresholdBasisPoints, _newDeviationThresholdBasisPoints);
101     }
102 
103     /// @notice set the validity duration of the cached collateralization values.
104     /// @param _validityDuration the new validity duration
105     /// This function will emit a DurationUpdate event from Timed.sol
106     function setValidityDuration(uint256 _validityDuration) external override onlyGovernorOrAdmin {
107         _setDuration(_validityDuration);
108     }
109 
110     /// @notice set the readPauseOverride flag
111     /// @param _readPauseOverride the new flag for readPauseOverride
112     function setReadPauseOverride(bool _readPauseOverride) external override onlyGuardianOrGovernor {
113         readPauseOverride = _readPauseOverride;
114         emit ReadPauseOverrideUpdate(_readPauseOverride);
115     }
116 
117     /// @notice governor or admin override to directly write to the cache
118     /// @dev used in emergencies where the underlying oracle is compromised or failing
119     function setCache(
120         uint256 _cachedProtocolControlledValue,
121         uint256 _cachedUserCirculatingFei,
122         int256 _cachedProtocolEquity
123     ) external override onlyGovernorOrAdmin {
124         _setCache(_cachedProtocolControlledValue, _cachedUserCirculatingFei, _cachedProtocolEquity);
125     }
126 
127     // ----------- IOracle override methods ------------------------------------
128     /// @notice update reading of the CollateralizationOracle
129     function update() external override whenNotPaused {
130         _update();
131     }
132 
133     /** 
134         @notice this method reverts if the oracle is not outdated
135         It is useful if the caller is incentivized for calling only when the deviation threshold or frequency has passed
136     */
137     function updateIfOutdated() external override whenNotPaused {
138         require(_update(), "CollateralizationOracleWrapper: not outdated");
139     }
140 
141     // returns true if the oracle was outdated at update time
142     function _update() internal returns (bool) {
143         bool outdated = isOutdated();
144 
145         // fetch a fresh round of information
146         (
147             uint256 _protocolControlledValue,
148             uint256 _userCirculatingFei,
149             int256 _protocolEquity,
150             bool _validityStatus
151         ) = ICollateralizationOracle(collateralizationOracle).pcvStats();
152 
153         outdated =
154             outdated ||
155             _isExceededDeviationThreshold(cachedProtocolControlledValue, _protocolControlledValue) ||
156             _isExceededDeviationThreshold(cachedUserCirculatingFei, _userCirculatingFei);
157 
158         // only update if valid
159         require(_validityStatus, "CollateralizationOracleWrapper: CollateralizationOracle is invalid");
160 
161         _setCache(_protocolControlledValue, _userCirculatingFei, _protocolEquity);
162 
163         return outdated;
164     }
165 
166     function _setCache(
167         uint256 _cachedProtocolControlledValue,
168         uint256 _cachedUserCirculatingFei,
169         int256 _cachedProtocolEquity
170     ) internal {
171         // set cache variables
172         cachedProtocolControlledValue = _cachedProtocolControlledValue;
173         cachedUserCirculatingFei = _cachedUserCirculatingFei;
174         cachedProtocolEquity = _cachedProtocolEquity;
175 
176         // reset time
177         _initTimed();
178 
179         // emit event
180         emit CachedValueUpdate(
181             msg.sender,
182             cachedProtocolControlledValue,
183             cachedUserCirculatingFei,
184             cachedProtocolEquity
185         );
186     }
187 
188     // @notice returns true if the cached values are outdated.
189     function isOutdated() public view override returns (bool outdated) {
190         // check if cached value is fresh
191         return isTimeEnded();
192     }
193 
194     /// @notice Get the current collateralization ratio of the protocol, from cache.
195     /// @return collateralRatio the current collateral ratio of the protocol.
196     /// @return validityStatus the current oracle validity status (false if any
197     ///         of the oracles for tokens held in the PCV are invalid, or if
198     ///         this contract is paused).
199     function read() external view override returns (Decimal.D256 memory collateralRatio, bool validityStatus) {
200         collateralRatio = Decimal.ratio(cachedProtocolControlledValue, cachedUserCirculatingFei);
201         validityStatus = _readNotPaused() && !isOutdated();
202     }
203 
204     // ----------- Wrapper-specific methods ------------------------------------
205     // @notice returns true if the cached values are obsolete, i.e. the actual CR
206     //         readings deviated from cached value by more than a threshold.
207     //         This function is intended to be called off-chain by keepers.
208     //         If executed on-chain, it consumes more gas than an actual update()
209     //         call _and_ does not persist the read values in the cached state.
210     function isExceededDeviationThreshold() public view override returns (bool obsolete) {
211         (
212             uint256 _protocolControlledValue,
213             uint256 _userCirculatingFei, // int256 _protocolEquity,
214             ,
215             bool _validityStatus
216         ) = ICollateralizationOracle(collateralizationOracle).pcvStats();
217 
218         require(_validityStatus, "CollateralizationOracleWrapper: CollateralizationOracle reading is invalid");
219 
220         return
221             _isExceededDeviationThreshold(cachedProtocolControlledValue, _protocolControlledValue) ||
222             _isExceededDeviationThreshold(cachedUserCirculatingFei, _userCirculatingFei);
223     }
224 
225     function _isExceededDeviationThreshold(uint256 cached, uint256 current) internal view returns (bool) {
226         uint256 delta = current > cached ? current - cached : cached - current;
227         uint256 deviationBaisPoints = (delta * Constants.BASIS_POINTS_GRANULARITY) / current;
228         return deviationBaisPoints > deviationThresholdBasisPoints;
229     }
230 
231     // @notice returns true if the cached values are obsolete or outdated, i.e.
232     //         the reading is too old, or the actual CR readings deviated from cached
233     //         value by more than a threshold.
234     //         This function is intended to be called off-chain by keepers, to
235     //         know if they should call the update() function. If executed on-chain,
236     //         it consumes more gas than an actual update() + read() call _and_
237     //         does not persist the read values in the cached state.
238     function isOutdatedOrExceededDeviationThreshold() external view override returns (bool) {
239         return isOutdated() || isExceededDeviationThreshold();
240     }
241 
242     // ----------- ICollateralizationOracle override methods -------------------
243 
244     /// @notice returns the Protocol-Controlled Value, User-circulating FEI, and
245     ///         Protocol Equity. If there is a fresh cached value, return it.
246     ///         Otherwise, call the CollateralizationOracle to get fresh data.
247     /// @return protocolControlledValue : the total USD value of all assets held
248     ///         by the protocol.
249     /// @return userCirculatingFei : the number of FEI not owned by the protocol.
250     /// @return protocolEquity : the difference between PCV and user circulating FEI.
251     ///         If there are more circulating FEI than $ in the PCV, equity is 0.
252     /// @return validityStatus : the current oracle validity status (false if any
253     ///         of the oracles for tokens held in the PCV are invalid, or if
254     ///         this contract is paused).
255     function pcvStats()
256         external
257         view
258         override
259         returns (
260             uint256 protocolControlledValue,
261             uint256 userCirculatingFei,
262             int256 protocolEquity,
263             bool validityStatus
264         )
265     {
266         validityStatus = _readNotPaused() && !isOutdated();
267         protocolControlledValue = cachedProtocolControlledValue;
268         userCirculatingFei = cachedUserCirculatingFei;
269         protocolEquity = cachedProtocolEquity;
270     }
271 
272     /// @notice returns true if the protocol is overcollateralized. Overcollateralization
273     ///         is defined as the protocol having more assets in its PCV (Protocol
274     ///         Controlled Value) than the circulating (user-owned) FEI, i.e.
275     ///         a positive Protocol Equity.
276     function isOvercollateralized() external view override returns (bool) {
277         require(!isOutdated(), "CollateralizationOracleWrapper: cache is outdated");
278         return cachedProtocolEquity > 0;
279     }
280 
281     // ----------- Wrapper-specific methods ------------------------------------
282 
283     /// @notice returns the Protocol-Controlled Value, User-circulating FEI, and
284     ///         Protocol Equity, from an actual fresh call to the CollateralizationOracle.
285     /// @return protocolControlledValue : the total USD value of all assets held
286     ///         by the protocol.
287     /// @return userCirculatingFei : the number of FEI not owned by the protocol.
288     /// @return protocolEquity : the difference between PCV and user circulating FEI.
289     ///         If there are more circulating FEI than $ in the PCV, equity is 0.
290     /// @return validityStatus : the current oracle validity status (false if any
291     ///         of the oracles for tokens held in the PCV are invalid, or if
292     ///         this contract is paused).
293     function pcvStatsCurrent()
294         external
295         view
296         override
297         returns (
298             uint256 protocolControlledValue,
299             uint256 userCirculatingFei,
300             int256 protocolEquity,
301             bool validityStatus
302         )
303     {
304         bool fetchedValidityStatus;
305         (protocolControlledValue, userCirculatingFei, protocolEquity, fetchedValidityStatus) = ICollateralizationOracle(
306             collateralizationOracle
307         ).pcvStats();
308 
309         validityStatus = fetchedValidityStatus && _readNotPaused();
310     }
311 
312     function _readNotPaused() internal view returns (bool) {
313         return readPauseOverride || !paused();
314     }
315 }
