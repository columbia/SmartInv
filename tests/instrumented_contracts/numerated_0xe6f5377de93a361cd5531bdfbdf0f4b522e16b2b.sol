1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-03
3 */
4 
5 pragma solidity 0.6.7;
6 
7 abstract contract DSValueLike {
8     function getResultWithValidity() virtual external view returns (uint256, bool);
9 }
10 
11 contract OSM {
12     // --- Auth ---
13     mapping (address => uint) public authorizedAccounts;
14     /**
15     * @notice Add auth to an account
16     * @param account Account to add auth to
17     */
18     function addAuthorization(address account) external isAuthorized {
19         authorizedAccounts[account] = 1;
20         emit AddAuthorization(account);
21     }
22     /**
23     * @notice Remove auth from an account
24     * @param account Account to remove auth from
25     */
26     function removeAuthorization(address account) external isAuthorized {
27         authorizedAccounts[account] = 0;
28         emit RemoveAuthorization(account);
29     }
30     /**
31     * @notice Checks whether msg.sender can call an authed function
32     **/
33     modifier isAuthorized {
34         require(authorizedAccounts[msg.sender] == 1, "OSM/account-not-authorized");
35         _;
36     }
37 
38     // --- Stop ---
39     uint256 public stopped;
40     modifier stoppable { require(stopped == 0, "OSM/is-stopped"); _; }
41 
42     // --- Math ---
43     function add(uint64 x, uint64 y) internal pure returns (uint64 z) {
44         z = x + y;
45         require(z >= x);
46     }
47 
48     address public priceSource;
49     uint16  constant ONE_HOUR = uint16(3600);
50     uint16  public updateDelay = ONE_HOUR;
51     uint64  public lastUpdateTime;
52 
53     struct Feed {
54         uint128 value;
55         uint128 isValid;
56     }
57 
58     Feed currentFeed;
59     Feed nextFeed;
60 
61     // --- Events ---
62     event AddAuthorization(address account);
63     event RemoveAuthorization(address account);
64     event Start();
65     event Stop();
66     event ChangePriceSource(address priceSource);
67     event ChangeDelay(uint16 delay);
68     event RestartValue();
69     event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);
70 
71     constructor (address priceSource_) public {
72         authorizedAccounts[msg.sender] = 1;
73         priceSource = priceSource_;
74         if (priceSource != address(0)) {
75           (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
76           if (hasValidValue) {
77             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
78             currentFeed = nextFeed;
79             lastUpdateTime = latestUpdateTime(currentTime());
80             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
81           }
82         }
83         emit AddAuthorization(msg.sender);
84         emit ChangePriceSource(priceSource);
85     }
86 
87     function stop() external isAuthorized {
88         stopped = 1;
89         emit Stop();
90     }
91     function start() external isAuthorized {
92         stopped = 0;
93         emit Start();
94     }
95 
96     function changePriceSource(address priceSource_) external isAuthorized {
97         priceSource = priceSource_;
98         emit ChangePriceSource(priceSource);
99     }
100 
101     function currentTime() internal view returns (uint) {
102         return block.timestamp;
103     }
104 
105     function latestUpdateTime(uint timestamp) internal view returns (uint64) {
106         require(updateDelay != 0, "OSM/update-delay-is-zero");
107         return uint64(timestamp - (timestamp % updateDelay));
108     }
109 
110     function changeDelay(uint16 delay) external isAuthorized {
111         require(delay > 0, "OSM/delay-is-zero");
112         updateDelay = delay;
113         emit ChangeDelay(updateDelay);
114     }
115 
116     function restartValue() external isAuthorized {
117         currentFeed = nextFeed = Feed(0, 0);
118         stopped = 1;
119         emit RestartValue();
120     }
121 
122     function passedDelay() public view returns (bool ok) {
123         return currentTime() >= add(lastUpdateTime, updateDelay);
124     }
125 
126     function getPriceSourceUpdate() internal view returns (uint256, bool) {
127         try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
128           return (priceFeedValue, hasValidValue);
129         }
130         catch(bytes memory) {
131           return (0, false);
132         }
133     }
134 
135     function updateResult() external stoppable {
136         require(passedDelay(), "OSM/not-passed");
137         (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
138         if (hasValidValue) {
139             currentFeed = nextFeed;
140             nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
141             lastUpdateTime = latestUpdateTime(currentTime());
142             emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
143         }
144     }
145 
146     function getResultWithValidity() external view returns (uint256,bool) {
147         return (uint(currentFeed.value), currentFeed.isValid == 1);
148     }
149 
150     function getNextResultWithValidity() external view returns (uint256,bool) {
151         return (nextFeed.value, nextFeed.isValid == 1);
152     }
153 
154     function read() external view returns (uint256) {
155         require(currentFeed.isValid == 1, "OSM/no-current-value");
156         return currentFeed.value;
157     }
158 }