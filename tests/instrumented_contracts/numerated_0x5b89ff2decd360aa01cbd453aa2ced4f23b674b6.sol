1 pragma solidity >=0.6.7;
2 
3 abstract contract DSValueLike {
4     function getResultWithValidity() virtual external view returns (uint256, bool);
5 }
6 
7 contract OSM {
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
30         require(authorizedAccounts[msg.sender] == 1, "OSM/account-not-authorized");
31         _;
32     }
33 
34     // --- Stop ---
35     uint256 public stopped;
36     modifier stoppable { require(stopped == 0, "OSM/is-stopped"); _; }
37 
38     // --- Math ---
39     function add(uint64 x, uint64 y) internal pure returns (uint64 z) {
40         z = x + y;
41         require(z >= x);
42     }
43 
44     address public priceSource;
45     uint16  constant ONE_HOUR = uint16(3600);
46     uint16  public updateDelay = ONE_HOUR;
47     uint64  public lastUpdateTime;
48 
49     struct Feed {
50         uint128 value;
51         uint128 isValid;
52     }
53 
54     Feed currentFeed;
55     Feed nextFeed;
56 
57     // --- Events ---
58     event AddAuthorization(address account);
59     event RemoveAuthorization(address account);
60     event Start();
61     event Stop();
62     event ChangePriceSource(address priceSource);
63     event ChangeDelay(uint16 delay);
64     event RestartValue();
65     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
66 
67     constructor (address priceSource_) public {
68         authorizedAccounts[msg.sender] = 1;
69         priceSource = priceSource_;
70         if (priceSource != address(0)) {
71           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
72           if (hasValidValue) {
73             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
74             currentFeed = nextFeed;
75             lastUpdateTime = latestUpdateTime(currentTime());
76             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
77           }
78         }
79         emit AddAuthorization(msg.sender);
80         emit ChangePriceSource(priceSource);
81     }
82 
83     function stop() external isAuthorized {
84         stopped = 1;
85         emit Stop();
86     }
87     function start() external isAuthorized {
88         stopped = 0;
89         emit Start();
90     }
91 
92     function changePriceSource(address priceSource_) external isAuthorized {
93         priceSource = priceSource_;
94         emit ChangePriceSource(priceSource);
95     }
96 
97     function currentTime() internal view returns (uint) {
98         return block.timestamp;
99     }
100 
101     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
102         require(updateDelay != 0, "OSM/update-delay-is-zero");
103         return uint64(timestamp - (timestamp % updateDelay));
104     }
105 
106     function changeDelay(uint16 delay) external isAuthorized {
107         require(delay > 0, "OSM/delay-is-zero");
108         updateDelay = delay;
109         emit ChangeDelay(updateDelay);
110     }
111 
112     function restartValue() external isAuthorized {
113         currentFeed = nextFeed = Feed(0, 0);
114         stopped = 1;
115         emit RestartValue();
116     }
117 
118     function passedDelay() public view returns (bool ok) {
119         return currentTime() >= add(lastUpdateTime, updateDelay);
120     }
121 
122     function getPriceSourceUpdate() internal view returns (uint256, bool) {
123         try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
124           return (priceFeedValue, hasValidValue);
125         }
126         catch(bytes memory) {
127           return (0, false);
128         }
129     }
130 
131     function updateResult() external stoppable {
132         require(passedDelay(), "OSM/not-passed");
133         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
134         if (hasValidValue) {
135             currentFeed = nextFeed;
136             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
137             lastUpdateTime = latestUpdateTime(currentTime());
138             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
139         }
140     }
141 
142     function getResultWithValidity() external view returns (uint256,bool) {
143         return (uint(currentFeed.value), currentFeed.isValid == 1);
144     }
145 
146     function getNextResultWithValidity() external view returns (uint256,bool) {
147         return (nextFeed.value, nextFeed.isValid == 1);
148     }
149 
150     function read() external view returns (uint256) {
151         require(currentFeed.isValid == 1, "OSM/no-current-value");
152         return currentFeed.value;
153     }
154 }