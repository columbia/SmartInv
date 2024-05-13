1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IOracle.sol";
5 import "./ICollateralizationOracle.sol";
6 import "../../refs/CoreRef.sol";
7 import "../../pcv/IPCVDepositBalances.sol";
8 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
9 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
10 
11 interface IPausable {
12     function paused() external view returns (bool);
13 }
14 
15 /// @title Fei Protocol's Collateralization Oracle
16 /// @author eswak
17 /// @notice Reads a list of PCVDeposit that report their amount of collateral
18 ///         and the amount of protocol-owned FEI they manage, to deduce the
19 ///         protocol-wide collateralization ratio.
20 contract CollateralizationOracle is ICollateralizationOracle, CoreRef {
21     using Decimal for Decimal.D256;
22     using SafeCast for uint256;
23     using EnumerableSet for EnumerableSet.AddressSet;
24 
25     // ----------- Events -----------
26 
27     event DepositAdd(address from, address indexed deposit, address indexed token);
28     event DepositRemove(address from, address indexed deposit);
29     event OracleUpdate(address from, address indexed token, address indexed oldOracle, address indexed newOracle);
30 
31     // ----------- Properties -----------
32 
33     /// @notice Map of oracles to use to get USD values of assets held in
34     ///         PCV deposits. This map is used to get the oracle address from
35     ///         and ERC20 address.
36     mapping(address => address) public tokenToOracle;
37     /// @notice Map from token address to an array of deposit addresses. It is
38     //          used to iterate on all deposits while making oracle requests
39     //          only once.
40     mapping(address => EnumerableSet.AddressSet) private tokenToDeposits;
41     /// @notice Map from deposit address to token address. It is used like an
42     ///         indexed version of the pcvDeposits array, to check existence
43     ///         of a PCVdeposit in the current config.
44     mapping(address => address) public depositToToken;
45     /// @notice Array of all tokens held in the PCV. Used for iteration on tokens
46     ///         and oracles.
47     EnumerableSet.AddressSet private tokensInPcv;
48 
49     // ----------- Constructor -----------
50 
51     /// @notice CollateralizationOracle constructor
52     /// @param _core Fei Core for reference
53     /// @param _deposits the initial list of PCV deposits
54     /// @param _tokens the initial supported tokens for oracle
55     /// @param _oracles the matching set of oracles for _tokens
56     constructor(
57         address _core,
58         address[] memory _deposits,
59         address[] memory _tokens,
60         address[] memory _oracles
61     ) CoreRef(_core) {
62         _setOracles(_tokens, _oracles);
63         _addDeposits(_deposits);
64 
65         // Shared admin with other oracles
66         _setContractAdminRole(keccak256("ORACLE_ADMIN_ROLE"));
67     }
68 
69     // ----------- Convenience getters -----------
70 
71     /// @notice returns true if a token is held in the pcv
72     function isTokenInPcv(address token) external view returns (bool) {
73         return tokensInPcv.contains(token);
74     }
75 
76     /// @notice returns an array of the addresses of tokens held in the pcv.
77     function getTokensInPcv() external view returns (address[] memory) {
78         return tokensInPcv.values();
79     }
80 
81     /// @notice returns token at index i of the array of PCV tokens
82     function getTokenInPcv(uint256 i) external view returns (address) {
83         return tokensInPcv.at(i);
84     }
85 
86     /// @notice returns an array of the deposits holding a given token.
87     function getDepositsForToken(address _token) external view returns (address[] memory) {
88         return tokenToDeposits[_token].values();
89     }
90 
91     /// @notice returns the address of deposit at index i of token _token
92     function getDepositForToken(address token, uint256 i) external view returns (address) {
93         return tokenToDeposits[token].at(i);
94     }
95 
96     // ----------- State-changing methods -----------
97 
98     /// @notice Add a PCVDeposit to the list of deposits inspected by the
99     ///         collateralization ratio oracle.
100     ///         note : this function reverts if the deposit is already in the list.
101     ///         note : this function reverts if the deposit's token has no oracle.
102     /// @param _deposit : the PCVDeposit to add to the list.
103     function addDeposit(address _deposit) external onlyGovernorOrAdmin {
104         _addDeposit(_deposit);
105     }
106 
107     /// @notice adds a list of multiple PCV deposits. See addDeposit.
108     function addDeposits(address[] memory _deposits) external onlyGovernorOrAdmin {
109         _addDeposits(_deposits);
110     }
111 
112     function _addDeposits(address[] memory _deposits) internal {
113         for (uint256 i = 0; i < _deposits.length; i++) {
114             _addDeposit(_deposits[i]);
115         }
116     }
117 
118     function _addDeposit(address _deposit) internal {
119         // if the PCVDeposit is already listed, revert.
120         require(depositToToken[_deposit] == address(0), "CollateralizationOracle: deposit duplicate");
121 
122         // get the token in which the deposit reports its token
123         address _token = IPCVDepositBalances(_deposit).balanceReportedIn();
124 
125         // revert if there is no oracle of this deposit's token
126         require(tokenToOracle[_token] != address(0), "CollateralizationOracle: no oracle");
127 
128         // update maps & arrays for faster access
129         depositToToken[_deposit] = _token;
130         tokenToDeposits[_token].add(_deposit);
131         tokensInPcv.add(_token);
132 
133         // emit event
134         emit DepositAdd(msg.sender, _deposit, _token);
135     }
136 
137     /// @notice Remove a PCVDeposit from the list of deposits inspected by
138     ///         the collateralization ratio oracle.
139     ///         note : this function reverts if the input deposit is not found.
140     /// @param _deposit : the PCVDeposit address to remove from the list.
141     function removeDeposit(address _deposit) external onlyGovernorOrAdmin {
142         _removeDeposit(_deposit);
143     }
144 
145     /// @notice removes a list of multiple PCV deposits. See removeDeposit.
146     function removeDeposits(address[] memory _deposits) external onlyGovernorOrAdmin {
147         for (uint256 i = 0; i < _deposits.length; i++) {
148             _removeDeposit(_deposits[i]);
149         }
150     }
151 
152     function _removeDeposit(address _deposit) internal {
153         // get the token in which the deposit reports its token
154         address _token = depositToToken[_deposit];
155 
156         // revert if the deposit is not found
157         require(_token != address(0), "CollateralizationOracle: deposit not found");
158 
159         // update maps & arrays for faster access
160         // deposits array for the deposit's token
161         depositToToken[_deposit] = address(0);
162         tokenToDeposits[_token].remove(_deposit);
163 
164         // if it was the last deposit to have this token, remove this token from
165         // the arrays also
166         if (tokenToDeposits[_token].length() == 0) {
167             tokensInPcv.remove(_token);
168         }
169 
170         // emit event
171         emit DepositRemove(msg.sender, _deposit);
172     }
173 
174     /// @notice Swap a PCVDeposit with a new one, for instance when a new version
175     ///         of a deposit (holding the same token) is deployed.
176     /// @param _oldDeposit : the PCVDeposit to remove from the list.
177     /// @param _newDeposit : the PCVDeposit to add to the list.
178     function swapDeposit(address _oldDeposit, address _newDeposit) external onlyGovernorOrAdmin {
179         _removeDeposit(_oldDeposit);
180         _addDeposit(_newDeposit);
181     }
182 
183     /// @notice Set the price feed oracle (in USD) for a given asset.
184     /// @param _token : the asset to add price oracle for
185     /// @param _newOracle : price feed oracle for the given asset
186     function setOracle(address _token, address _newOracle) external onlyGovernorOrAdmin {
187         _setOracle(_token, _newOracle);
188     }
189 
190     /// @notice adds a list of token oracles. See setOracle.
191     function setOracles(address[] memory _tokens, address[] memory _oracles) public onlyGovernorOrAdmin {
192         _setOracles(_tokens, _oracles);
193     }
194 
195     function _setOracles(address[] memory _tokens, address[] memory _oracles) internal {
196         require(_tokens.length == _oracles.length, "CollateralizationOracle: length mismatch");
197         for (uint256 i = 0; i < _tokens.length; i++) {
198             _setOracle(_tokens[i], _oracles[i]);
199         }
200     }
201 
202     function _setOracle(address _token, address _newOracle) internal {
203         require(_token != address(0), "CollateralizationOracle: token must be != 0x0");
204         require(_newOracle != address(0), "CollateralizationOracle: oracle must be != 0x0");
205 
206         // add oracle to the map(ERC20Address) => OracleAddress
207         address _oldOracle = tokenToOracle[_token];
208         tokenToOracle[_token] = _newOracle;
209 
210         // emit event
211         emit OracleUpdate(msg.sender, _token, _oldOracle, _newOracle);
212     }
213 
214     // ----------- IOracle override methods -----------
215     /// @notice update all oracles required for this oracle to work that are not
216     ///         paused themselves.
217     function update() external override whenNotPaused {
218         for (uint256 i = 0; i < tokensInPcv.length(); i++) {
219             address _oracle = tokenToOracle[tokensInPcv.at(i)];
220             if (!IPausable(_oracle).paused()) {
221                 IOracle(_oracle).update();
222             }
223         }
224     }
225 
226     // @notice returns true if any of the oracles required for this oracle to
227     //         work are outdated.
228     function isOutdated() external view override returns (bool) {
229         bool _outdated = false;
230         for (uint256 i = 0; i < tokensInPcv.length() && !_outdated; i++) {
231             address _oracle = tokenToOracle[tokensInPcv.at(i)];
232             if (!IPausable(_oracle).paused()) {
233                 _outdated = _outdated || IOracle(_oracle).isOutdated();
234             }
235         }
236         return _outdated;
237     }
238 
239     /// @notice Get the current collateralization ratio of the protocol.
240     /// @return collateralRatio the current collateral ratio of the protocol.
241     /// @return validityStatus the current oracle validity status (false if any
242     ///         of the oracles for tokens held in the PCV are invalid, or if
243     ///         this contract is paused).
244     function read() public view override returns (Decimal.D256 memory collateralRatio, bool validityStatus) {
245         // fetch PCV stats
246         (
247             uint256 _protocolControlledValue,
248             uint256 _userCirculatingFei, // we don't need protocol equity
249             ,
250             bool _valid
251         ) = pcvStats();
252 
253         // The protocol collateralization ratio is defined as the total USD
254         // value of assets held in the PCV, minus the circulating FEI.
255         collateralRatio = Decimal.ratio(_protocolControlledValue, _userCirculatingFei);
256         validityStatus = _valid;
257     }
258 
259     // ----------- ICollateralizationOracle override methods -----------
260 
261     /// @notice returns the Protocol-Controlled Value, User-circulating FEI, and
262     ///         Protocol Equity.
263     /// @return protocolControlledValue : the total USD value of all assets held
264     ///         by the protocol.
265     /// @return userCirculatingFei : the number of FEI not owned by the protocol.
266     /// @return protocolEquity : the signed difference between PCV and user circulating FEI.
267     /// @return validityStatus : the current oracle validity status (false if any
268     ///         of the oracles for tokens held in the PCV are invalid, or if
269     ///         this contract is paused).
270     function pcvStats()
271         public
272         view
273         override
274         returns (
275             uint256 protocolControlledValue,
276             uint256 userCirculatingFei,
277             int256 protocolEquity,
278             bool validityStatus
279         )
280     {
281         uint256 _protocolControlledFei = 0;
282         validityStatus = !paused();
283 
284         // For each token...
285         for (uint256 i = 0; i < tokensInPcv.length(); i++) {
286             address _token = tokensInPcv.at(i);
287             uint256 _totalTokenBalance = 0;
288 
289             // For each deposit...
290             for (uint256 j = 0; j < tokenToDeposits[_token].length(); j++) {
291                 address _deposit = tokenToDeposits[_token].at(j);
292 
293                 // read the deposit, and increment token balance/protocol fei
294                 (uint256 _depositBalance, uint256 _depositFei) = IPCVDepositBalances(_deposit).resistantBalanceAndFei();
295                 _totalTokenBalance += _depositBalance;
296                 _protocolControlledFei += _depositFei;
297             }
298 
299             // If the protocol holds non-zero balance of tokens, fetch the oracle price to
300             // increment PCV by _totalTokenBalance * oracle price USD.
301             if (_totalTokenBalance != 0) {
302                 (Decimal.D256 memory _oraclePrice, bool _oracleValid) = IOracle(tokenToOracle[_token]).read();
303                 if (!_oracleValid) {
304                     validityStatus = false;
305                 }
306                 protocolControlledValue += _oraclePrice.mul(_totalTokenBalance).asUint256();
307             }
308         }
309 
310         userCirculatingFei = fei().totalSupply() - _protocolControlledFei;
311         protocolEquity = protocolControlledValue.toInt256() - userCirculatingFei.toInt256();
312     }
313 
314     /// @notice returns true if the protocol is overcollateralized. Overcollateralization
315     ///         is defined as the protocol having more assets in its PCV (Protocol
316     ///         Controlled Value) than the circulating (user-owned) FEI, i.e.
317     ///         a positive Protocol Equity.
318     function isOvercollateralized() external view override whenNotPaused returns (bool) {
319         (, , int256 _protocolEquity, bool _valid) = pcvStats();
320         require(_valid, "CollateralizationOracle: reading is invalid");
321         return _protocolEquity > 0;
322     }
323 }
