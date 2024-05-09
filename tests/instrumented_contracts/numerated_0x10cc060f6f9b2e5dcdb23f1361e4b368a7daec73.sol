1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract UnicornInit {
33     function init() external;
34 }
35 
36 contract UnicornManagement {
37     using SafeMath for uint;
38 
39     address public ownerAddress;
40     address public managerAddress;
41     address public communityAddress;
42     address public walletAddress;
43     address public candyToken;
44     address public candyPowerToken;
45     address public dividendManagerAddress; //onlyCommunity
46     address public blackBoxAddress; //onlyOwner
47     address public unicornBreedingAddress; //onlyOwner
48     address public geneLabAddress; //onlyOwner
49     address public unicornTokenAddress; //onlyOwner
50 
51     uint public createDividendPercent = 375; //OnlyManager 4 digits. 10.5% = 1050
52     uint public sellDividendPercent = 375; //OnlyManager 4 digits. 10.5% = 1050
53     uint public subFreezingPrice = 1000000000000000000; //
54     uint64 public subFreezingTime = 1 hours;
55     uint public subTourFreezingPrice = 1000000000000000000; //
56     uint64 public subTourFreezingTime = 1 hours;
57     uint public createUnicornPrice = 50000000000000000;
58     uint public createUnicornPriceInCandy = 25000000000000000000; //25 tokens
59     uint public oraclizeFee = 3000000000000000; //0.003 ETH
60 
61     bool public paused = true;
62     bool public locked = false;
63 
64     mapping(address => bool) tournaments;//address
65 
66     event GamePaused();
67     event GameResumed();
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69     event NewManagerAddress(address managerAddress);
70     event NewCommunityAddress(address communityAddress);
71     event NewDividendManagerAddress(address dividendManagerAddress);
72     event NewWalletAddress(address walletAddress);
73     event NewCreateUnicornPrice(uint price, uint priceCandy);
74     event NewOraclizeFee(uint fee);
75     event NewSubFreezingPrice(uint price);
76     event NewSubFreezingTime(uint time);
77     event NewSubTourFreezingPrice(uint price);
78     event NewSubTourFreezingTime(uint time);
79     event NewCreateUnicornPrice(uint price);
80     event NewCreateDividendPercent(uint percent);
81     event NewSellDividendPercent(uint percent);
82     event AddTournament(address tournamentAddress);
83     event DelTournament(address tournamentAddress);
84     event NewBlackBoxAddress(address blackBoxAddress);
85     event NewBreedingAddress(address breedingAddress);
86 
87 
88     modifier onlyOwner() {
89         require(msg.sender == ownerAddress);
90         _;
91     }
92 
93     modifier onlyManager() {
94         require(msg.sender == managerAddress);
95         _;
96     }
97 
98     modifier onlyCommunity() {
99         require(msg.sender == communityAddress);
100         _;
101     }
102 
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     modifier whenPaused {
109         require(paused);
110         _;
111     }
112 
113     modifier whenUnlocked() {
114         require(!locked);
115         _;
116     }
117 
118     function lock() external onlyOwner whenPaused whenUnlocked {
119         locked = true;
120     }
121 
122     function UnicornManagement(address _candyToken) public {
123         ownerAddress = msg.sender;
124         managerAddress = msg.sender;
125         communityAddress = msg.sender;
126         walletAddress = msg.sender;
127         candyToken = _candyToken;
128         candyPowerToken = _candyToken;
129     }
130 
131 
132     struct InitItem {
133         uint listIndex;
134         bool exists;
135     }
136 
137     mapping (address => InitItem) private initItems;
138     address[] private initList;
139 
140     function registerInit(address _contract) external whenPaused {
141         require(msg.sender == ownerAddress || tx.origin == ownerAddress);
142 
143         if (!initItems[_contract].exists) {
144             initItems[_contract] = InitItem({
145                 listIndex: initList.length,
146                 exists: true
147                 });
148             initList.push(_contract);
149         }
150     }
151 
152     function unregisterInit(address _contract) external onlyOwner whenPaused {
153         require(initItems[_contract].exists && initList.length > 0);
154         uint lastIdx = initList.length - 1;
155         initItems[initList[lastIdx]].listIndex = initItems[_contract].listIndex;
156         initList[initItems[_contract].listIndex] = initList[lastIdx];
157         initList.length--;
158         delete initItems[_contract];
159 
160     }
161 
162     function runInit() external onlyOwner whenPaused {
163         for(uint i = 0; i < initList.length; i++) {
164             UnicornInit(initList[i]).init();
165         }
166     }
167 
168     function setCandyPowerToken(address _candyPowerToken) external onlyOwner whenPaused {
169         require(_candyPowerToken != address(0));
170         candyPowerToken = _candyPowerToken;
171     }
172 
173     function setUnicornToken(address _unicornTokenAddress) external onlyOwner whenPaused whenUnlocked {
174         require(_unicornTokenAddress != address(0));
175         //        require(unicornTokenAddress == address(0));
176         unicornTokenAddress = _unicornTokenAddress;
177     }
178 
179     function setBlackBox(address _blackBoxAddress) external onlyOwner whenPaused {
180         require(_blackBoxAddress != address(0));
181         blackBoxAddress = _blackBoxAddress;
182     }
183 
184     function setGeneLab(address _geneLabAddress) external onlyOwner whenPaused {
185         require(_geneLabAddress != address(0));
186         geneLabAddress = _geneLabAddress;
187     }
188 
189     function setUnicornBreeding(address _unicornBreedingAddress) external onlyOwner whenPaused whenUnlocked {
190         require(_unicornBreedingAddress != address(0));
191         //        require(unicornBreedingAddress == address(0));
192         unicornBreedingAddress = _unicornBreedingAddress;
193     }
194 
195     function setManagerAddress(address _managerAddress) external onlyOwner {
196         require(_managerAddress != address(0));
197         managerAddress = _managerAddress;
198         emit NewManagerAddress(_managerAddress);
199     }
200 
201     function setDividendManager(address _dividendManagerAddress) external onlyOwner {
202         require(_dividendManagerAddress != address(0));
203         dividendManagerAddress = _dividendManagerAddress;
204         emit NewDividendManagerAddress(_dividendManagerAddress);
205     }
206 
207     function setWallet(address _walletAddress) external onlyOwner {
208         require(_walletAddress != address(0));
209         walletAddress = _walletAddress;
210         emit NewWalletAddress(_walletAddress);
211     }
212 
213     function setTournament(address _tournamentAddress) external onlyOwner {
214         require(_tournamentAddress != address(0));
215         tournaments[_tournamentAddress] = true;
216         emit AddTournament(_tournamentAddress);
217     }
218 
219     function delTournament(address _tournamentAddress) external onlyOwner {
220         require(tournaments[_tournamentAddress]);
221         tournaments[_tournamentAddress] = false;
222         emit DelTournament(_tournamentAddress);
223     }
224 
225     function transferOwnership(address _ownerAddress) external onlyOwner {
226         require(_ownerAddress != address(0));
227         ownerAddress = _ownerAddress;
228         emit OwnershipTransferred(ownerAddress, _ownerAddress);
229     }
230 
231 
232     function setCreateDividendPercent(uint _percent) public onlyManager {
233         require(_percent < 2500);
234         //no more then 25%
235         createDividendPercent = _percent;
236         emit NewCreateDividendPercent(_percent);
237     }
238 
239     function setSellDividendPercent(uint _percent) public onlyManager {
240         require(_percent < 2500);
241         //no more then 25%
242         sellDividendPercent = _percent;
243         emit NewSellDividendPercent(_percent);
244     }
245 
246     //time in minutes
247     function setSubFreezingTime(uint64 _time) external onlyManager {
248         subFreezingTime = _time * 1 minutes;
249         emit NewSubFreezingTime(_time);
250     }
251 
252     //price in CandyCoins
253     function setSubFreezingPrice(uint _price) external onlyManager {
254         subFreezingPrice = _price;
255         emit NewSubFreezingPrice(_price);
256     }
257 
258 
259     //time in minutes
260     function setSubTourFreezingTime(uint64 _time) external onlyManager {
261         subTourFreezingTime = _time * 1 minutes;
262         emit NewSubTourFreezingTime(_time);
263     }
264 
265     //price in CandyCoins
266     function setSubTourFreezingPrice(uint _price) external onlyManager {
267         subTourFreezingPrice = _price;
268         emit NewSubTourFreezingPrice(_price);
269     }
270 
271     //in weis
272     function setOraclizeFee(uint _fee) external onlyManager {
273         oraclizeFee = _fee;
274         emit NewOraclizeFee(_fee);
275     }
276 
277     //price in weis
278     function setCreateUnicornPrice(uint _price, uint _candyPrice) external onlyManager {
279         createUnicornPrice = _price;
280         createUnicornPriceInCandy = _candyPrice;
281         emit NewCreateUnicornPrice(_price, _candyPrice);
282     }
283 
284     function setCommunity(address _communityAddress) external onlyCommunity {
285         require(_communityAddress != address(0));
286         communityAddress = _communityAddress;
287         emit NewCommunityAddress(_communityAddress);
288     }
289 
290 
291     function pause() external onlyOwner whenNotPaused {
292         paused = true;
293         emit GamePaused();
294     }
295 
296     function unpause() external onlyOwner whenPaused {
297         paused = false;
298         emit GameResumed();
299     }
300 
301 
302 
303     function isTournament(address _tournamentAddress) external view returns (bool) {
304         return tournaments[_tournamentAddress];
305     }
306 
307     function getCreateUnicornFullPrice() external view returns (uint) {
308         return createUnicornPrice.add(oraclizeFee);
309     }
310 
311     function getCreateUnicornFullPriceInCandy() external view returns (uint) {
312         return createUnicornPriceInCandy;
313     }
314 
315     function getHybridizationFullPrice(uint _price) external view returns (uint) {
316         return _price.add(valueFromPercent(_price, createDividendPercent));//.add(oraclizeFee);
317     }
318 
319     function getSellUnicornFullPrice(uint _price) external view returns (uint) {
320         return _price.add(valueFromPercent(_price, sellDividendPercent));//.add(oraclizeFee);
321     }
322 
323     //1% - 100, 10% - 1000 50% - 5000
324     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
325         uint _amount = _value.mul(_percent).div(10000);
326         return (_amount);
327     }
328 }