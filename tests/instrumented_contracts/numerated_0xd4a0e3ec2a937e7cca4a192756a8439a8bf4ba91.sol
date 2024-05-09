1 pragma solidity 0.6.7;
2 
3 abstract contract DSValueLike {
4     function getResultWithValidity() virtual external view returns (uint256, bool);
5 }
6 abstract contract FSMWrapperLike {
7     function renumerateCaller(address) virtual external;
8 }
9 
10 contract OSM {
11     // --- Auth ---
12     mapping (address => uint) public authorizedAccounts;
13     /**
14      * @notice Add auth to an account
15      * @param account Account to add auth to
16      */
17     function addAuthorization(address account) virtual external isAuthorized {
18         authorizedAccounts[account] = 1;
19         emit AddAuthorization(account);
20     }
21     /**
22      * @notice Remove auth from an account
23      * @param account Account to remove auth from
24      */
25     function removeAuthorization(address account) virtual external isAuthorized {
26         authorizedAccounts[account] = 0;
27         emit RemoveAuthorization(account);
28     }
29     /**
30     * @notice Checks whether msg.sender can call an authed function
31     **/
32     modifier isAuthorized {
33         require(authorizedAccounts[msg.sender] == 1, "OSM/account-not-authorized");
34         _;
35     }
36 
37     // --- Stop ---
38     uint256 public stopped;
39     modifier stoppable { require(stopped == 0, "OSM/is-stopped"); _; }
40 
41     // --- Variables ---
42     address public priceSource;
43     uint16  constant ONE_HOUR = uint16(3600);
44     uint16  public updateDelay = ONE_HOUR;
45     uint64  public lastUpdateTime;
46 
47     // --- Structs ---
48     struct Feed {
49         uint128 value;
50         uint128 isValid;
51     }
52 
53     Feed currentFeed;
54     Feed nextFeed;
55 
56     // --- Events ---
57     event AddAuthorization(address account);
58     event RemoveAuthorization(address account);
59     event ModifyParameters(bytes32 parameter, uint256 val);
60     event ModifyParameters(bytes32 parameter, address val);
61     event Start();
62     event Stop();
63     event ChangePriceSource(address priceSource);
64     event ChangeDelay(uint16 delay);
65     event RestartValue();
66     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
67 
68     constructor (address priceSource_) public {
69         authorizedAccounts[msg.sender] = 1;
70         priceSource = priceSource_;
71         if (priceSource != address(0)) {
72           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
73           if (hasValidValue) {
74             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
75             currentFeed = nextFeed;
76             lastUpdateTime = latestUpdateTime(currentTime());
77             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
78           }
79         }
80         emit AddAuthorization(msg.sender);
81         emit ChangePriceSource(priceSource);
82     }
83 
84     // --- Math ---
85     function addition(uint64 x, uint64 y) internal pure returns (uint64 z) {
86         z = x + y;
87         require(z >= x);
88     }
89 
90     // --- Core Logic ---
91     /*
92     * @notify Stop the OSM
93     */
94     function stop() external isAuthorized {
95         stopped = 1;
96         emit Stop();
97     }
98     /*
99     * @notify Start the OSM
100     */
101     function start() external isAuthorized {
102         stopped = 0;
103         emit Start();
104     }
105 
106     /*
107     * @notify Change the oracle from which the OSM reads
108     * @param priceSource_ The address of the oracle from which the OSM reads
109     */
110     function changePriceSource(address priceSource_) external isAuthorized {
111         priceSource = priceSource_;
112         emit ChangePriceSource(priceSource);
113     }
114 
115     /*
116     * @notify Helper that returns the current block timestamp
117     */
118     function currentTime() internal view returns (uint) {
119         return block.timestamp;
120     }
121 
122     /*
123     * @notify Return the latest update time
124     * @param timestamp Custom reference timestamp to determine the latest update time from
125     */
126     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
127         require(updateDelay != 0, "OSM/update-delay-is-zero");
128         return uint64(timestamp - (timestamp % updateDelay));
129     }
130 
131     /*
132     * @notify Change the delay between updates
133     * @param delay The new delay
134     */
135     function changeDelay(uint16 delay) external isAuthorized {
136         require(delay > 0, "OSM/delay-is-zero");
137         updateDelay = delay;
138         emit ChangeDelay(updateDelay);
139     }
140 
141     /*
142     * @notify Restart/set to zero the feeds stored in the OSM
143     */
144     function restartValue() external isAuthorized {
145         currentFeed = nextFeed = Feed(0, 0);
146         stopped = 1;
147         emit RestartValue();
148     }
149 
150     /*
151     * @notify View function that returns whether the delay between calls has been passed
152     */
153     function passedDelay() public view returns (bool ok) {
154         return currentTime() >= uint(addition(lastUpdateTime, uint64(updateDelay)));
155     }
156 
157     /*
158     * @notify Update the price feeds inside the OSM
159     */
160     function updateResult() virtual external stoppable {
161         // Check if the delay passed
162         require(passedDelay(), "OSM/not-passed");
163         // Read the price from the median
164         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
165         // If the value is valid, update storage
166         if (hasValidValue) {
167             // Update state
168             currentFeed    = nextFeed;
169             nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);
170             lastUpdateTime = latestUpdateTime(currentTime());
171             // Emit event
172             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
173         }
174     }
175 
176     // --- Getters ---
177     /*
178     * @notify Internal helper that reads a price and its validity from the priceSource
179     */
180     function getPriceSourceUpdate() internal view returns (uint256, bool) {
181         try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
182           return (priceFeedValue, hasValidValue);
183         }
184         catch(bytes memory) {
185           return (0, false);
186         }
187     }
188     /*
189     * @notify Return the current feed value and its validity
190     */
191     function getResultWithValidity() external view returns (uint256,bool) {
192         return (uint(currentFeed.value), currentFeed.isValid == 1);
193     }
194     /*
195     * @notify Return the next feed's value and its validity
196     */
197     function getNextResultWithValidity() external view returns (uint256,bool) {
198         return (nextFeed.value, nextFeed.isValid == 1);
199     }
200     /*
201     * @notify Return the current feed's value only if it's valid, otherwise revert
202     */
203     function read() external view returns (uint256) {
204         require(currentFeed.isValid == 1, "OSM/no-current-value");
205         return currentFeed.value;
206     }
207 }
208 
209 contract ExternallyFundedOSM is OSM {
210     // --- Variables ---
211     FSMWrapperLike public fsmWrapper;
212 
213     // --- Evemts ---
214     event FailRenumerateCaller(address wrapper, address caller);
215 
216     constructor (address priceSource_) public OSM(priceSource_) {}
217 
218     // --- Administration ---
219     /*
220     * @notify Modify an address parameter
221     * @param parameter The parameter name
222     * @param val The new value for the parameter
223     */
224     function modifyParameters(bytes32 parameter, address val) external isAuthorized {
225         if (parameter == "fsmWrapper") {
226           require(val != address(0), "ExternallyFundedOSM/invalid-fsm-wrapper");
227           fsmWrapper = FSMWrapperLike(val);
228         }
229         else revert("ExternallyFundedOSM/modify-unrecognized-param");
230         emit ModifyParameters(parameter, val);
231     }
232 
233     /*
234     * @notify Update the price feeds inside the OSM
235     */
236     function updateResult() override external stoppable {
237         // Check if the delay passed
238         require(passedDelay(), "ExternallyFundedOSM/not-passed");
239         // Check that the wrapper is set
240         require(address(fsmWrapper) != address(0), "ExternallyFundedOSM/null-wrapper");
241         // Read the price from the median
242         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
243         // If the value is valid, update storage
244         if (hasValidValue) {
245             // Update state
246             currentFeed    = nextFeed;
247             nextFeed       = Feed(uint128(uint(priceFeedValue)), 1);
248             lastUpdateTime = latestUpdateTime(currentTime());
249             // Emit event
250             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
251             // Pay the caller
252             try fsmWrapper.renumerateCaller(msg.sender) {}
253             catch(bytes memory revertReason) {
254               emit FailRenumerateCaller(address(fsmWrapper), msg.sender);
255             }
256         }
257     }
258 }