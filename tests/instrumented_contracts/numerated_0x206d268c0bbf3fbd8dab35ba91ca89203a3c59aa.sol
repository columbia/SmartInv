1 pragma solidity ^0.6.7;
2 
3 abstract contract DSValueLike {
4     function getResultWithValidity() virtual external view returns (uint256, bool);
5 }
6 
7 contract DSM {
8     // --- Auth ---
9     mapping (address => uint) public authorizedAccounts;
10     /**
11     * @notice Add auth to an account
12     * @param account Account to add auth to
13     */
14     function addAuthorization(address account) external isAuthorized {
15         authorizedAccounts[account] = 1;
16         emit AddAuthorization(account);
17     }
18     /**
19     * @notice Remove auth from an account
20     * @param account Account to remove auth from
21     */
22     function removeAuthorization(address account) external isAuthorized {
23         authorizedAccounts[account] = 0;
24         emit RemoveAuthorization(account);
25     }
26     /**
27     * @notice Checks whether msg.sender can call an authed function
28     **/
29     modifier isAuthorized {
30         require(authorizedAccounts[msg.sender] == 1, "DSM/account-not-authorized");
31         _;
32     }
33 
34     // --- Stop ---
35     uint256 public stopped;
36     modifier stoppable { require(stopped == 0, "DSM/is-stopped"); _; }
37 
38     // --- Math ---
39     function add(uint64 x, uint64 y) internal pure returns (uint64 z) {
40         z = x + y;
41         require(z >= x);
42     }
43 
44     address public priceSource;
45     uint16  public updateDelay = ONE_HOUR;      // [seconds]
46     uint64  public lastUpdateTime;              // [timestamp]
47     uint256 public newPriceDeviation;           // [wad]
48 
49     uint16  constant ONE_HOUR = uint16(3600);   // [seconds]
50     uint256 public constant WAD = 10 ** 18;
51 
52     struct Feed {
53         uint128 value;
54         uint128 isValid;
55     }
56 
57     Feed currentFeed;
58     Feed nextFeed;
59 
60     // --- Events ---
61     event AddAuthorization(address account);
62     event RemoveAuthorization(address account);
63     event Start();
64     event Stop();
65     event ChangePriceSource(address priceSource);
66     event ChangeDeviation(uint deviation);
67     event ChangeDelay(uint16 delay);
68     event RestartValue();
69     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
70 
71     constructor (address priceSource_, uint256 deviation) public {
72         require(both(deviation > 0, deviation < WAD), "DSM/invalid-deviation");
73         authorizedAccounts[msg.sender] = 1;
74         priceSource = priceSource_;
75         newPriceDeviation = deviation;
76         if (priceSource != address(0)) {
77           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
78           if (hasValidValue) {
79             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
80             currentFeed = nextFeed;
81             lastUpdateTime = latestUpdateTime(currentTime());
82             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
83           }
84         }
85         emit AddAuthorization(msg.sender);
86         emit ChangePriceSource(priceSource);
87         emit ChangeDeviation(deviation);
88     }
89 
90     // --- Boolean Logic ---
91     function both(bool x, bool y) internal pure returns (bool z) {
92         assembly{ z := and(x, y)}
93     }
94 
95     // --- Math ---
96     function subtract(uint x, uint y) public pure returns (uint z) {
97         z = x - y;
98         require(z <= x);
99     }
100     function multiply(uint x, uint y) public pure returns (uint z) {
101         require(y == 0 || (z = x * y) / y == x);
102     }
103     function wmultiply(uint x, uint y) public pure returns (uint z) {
104         z = multiply(x, y) / WAD;
105     }
106 
107     // --- Administration ---
108     function stop() external isAuthorized {
109         stopped = 1;
110         emit Stop();
111     }
112     function start() external isAuthorized {
113         stopped = 0;
114         emit Start();
115     }
116 
117     function changePriceSource(address priceSource_) external isAuthorized {
118         priceSource = priceSource_;
119         emit ChangePriceSource(priceSource);
120     }
121 
122     // --- Utils ---
123     function currentTime() internal view returns (uint) {
124         return block.timestamp;
125     }
126 
127     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
128         require(updateDelay != 0, "DSM/update-delay-is-zero");
129         return uint64(timestamp - (timestamp % updateDelay));
130     }
131 
132     function changeNextPriceDeviation(uint deviation) external isAuthorized {
133         require(both(deviation > 0, deviation < WAD), "DSM/invalid-deviation");
134         newPriceDeviation = deviation;
135         emit ChangeDeviation(deviation);
136     }
137 
138     function changeDelay(uint16 delay) external isAuthorized {
139         require(delay > 0, "DSM/delay-is-zero");
140         updateDelay = delay;
141         emit ChangeDelay(updateDelay);
142     }
143 
144     function restartValue() external isAuthorized {
145         currentFeed = nextFeed = Feed(0, 0);
146         stopped = 1;
147         emit RestartValue();
148     }
149 
150     function passedDelay() public view returns (bool ok) {
151         return currentTime() >= add(lastUpdateTime, updateDelay);
152     }
153 
154     function updateResult() external stoppable {
155         require(passedDelay(), "DSM/not-passed");
156         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
157         if (hasValidValue) {
158             currentFeed.isValid = nextFeed.isValid;
159             currentFeed.value   = getNextBoundedPrice();
160             nextFeed            = Feed(uint128(priceFeedValue), 1);
161             lastUpdateTime      = latestUpdateTime(currentTime());
162             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
163         }
164     }
165 
166     // --- Getters ---
167     function getPriceSourceUpdate() internal view returns (uint256, bool) {
168         try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
169           return (priceFeedValue, hasValidValue);
170         }
171         catch(bytes memory) {
172           return (0, false);
173         }
174     }
175 
176     function getNextBoundedPrice() public view returns (uint128 boundedPrice) {
177         boundedPrice = nextFeed.value;
178         if (currentFeed.value == 0) return boundedPrice;
179 
180         uint128 lowerBound = uint128(wmultiply(uint(currentFeed.value), newPriceDeviation));
181         uint128 upperBound = uint128(wmultiply(uint(currentFeed.value), subtract(multiply(uint(2), WAD), newPriceDeviation)));
182 
183         if (nextFeed.value < lowerBound) {
184           boundedPrice = lowerBound;
185         } else if (nextFeed.value > upperBound) {
186           boundedPrice = upperBound;
187         }
188     }
189 
190     function getNextPriceLowerBound() public view returns (uint128) {
191         return uint128(wmultiply(uint(currentFeed.value), newPriceDeviation));
192     }
193 
194     function getNextPriceUpperBound() public view returns (uint128) {
195         return uint128(wmultiply(uint(currentFeed.value), subtract(multiply(uint(2), WAD), newPriceDeviation)));
196     }
197 
198     function getResultWithValidity() external view returns (uint256, bool) {
199         return (uint(currentFeed.value), currentFeed.isValid == 1);
200     }
201 
202     function getNextResultWithValidity() external view returns (uint256, bool) {
203         return (nextFeed.value, nextFeed.isValid == 1);
204     }
205 
206     function read() external view returns (uint256) {
207         require(currentFeed.isValid == 1, "DSM/no-current-value");
208         return currentFeed.value;
209     }
210 }