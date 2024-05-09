1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 interface UnicornManagementInterface {
46 
47     function ownerAddress() external view returns (address);
48     function managerAddress() external view returns (address);
49     function communityAddress() external view returns (address);
50     function dividendManagerAddress() external view returns (address);
51     function walletAddress() external view returns (address);
52     function unicornTokenAddress() external view returns (address);
53     function candyToken() external view returns (address);
54     function candyPowerToken() external view returns (address);
55     function unicornBreedingAddress() external view returns (address);
56 
57 
58     function paused() external view returns (bool);
59     function locked() external view returns (bool);
60     //    function locked() external view returns (bool);
61 
62     //service
63     function registerInit(address _contract) external;
64 
65 }
66 
67 
68 interface LandInit {
69     function init() external;
70 }
71 
72 contract LandManagement {
73     using SafeMath for uint;
74 
75     UnicornManagementInterface public unicornManagement;
76 
77     //    address public ownerAddress;
78     //    address public managerAddress;
79     //    address public communityAddress;
80     //    address public walletAddress;
81     //    address public candyToken;
82     //    address public megaCandyToken;
83     //    address public dividendManagerAddress; //onlyCommunity
84     //address public unicornTokenAddress; //onlyOwner
85     address public userRankAddress;
86     address public candyLandAddress;
87     address public candyLandSaleAddress;
88 
89     mapping(address => bool) unicornContracts;//address
90 
91     bool public ethLandSaleOpen = true;
92     bool public presaleOpen = true;
93     bool public firstRankForFree = true;
94 
95     uint public landPriceWei = 2412000000000000000;
96     uint public landPriceCandy = 720000000000000000000;
97 
98     event AddUnicornContract(address indexed _unicornContractAddress);
99     event DelUnicornContract(address indexed _unicornContractAddress);
100     event NewUserRankAddress(address userRankAddress);
101     event NewCandyLandAddress(address candyLandAddress);
102     event NewCandyLandSaleAddress(address candyLandSaleAddress);
103     event NewLandPrice(uint _price, uint _candyPrice);
104 
105     modifier onlyOwner() {
106         require(msg.sender == ownerAddress());
107         _;
108     }
109 
110     modifier onlyManager() {
111         require(msg.sender == managerAddress());
112         _;
113     }
114 
115 
116     modifier whenNotPaused() {
117         require(!unicornManagement.paused());
118         _;
119     }
120 
121     modifier whenPaused {
122         require(unicornManagement.paused());
123         _;
124     }
125 
126 
127     modifier onlyUnicornManagement() {
128         require(msg.sender == address(unicornManagement));
129         _;
130     }
131 
132     modifier whenUnlocked() {
133         require(!unicornManagement.locked());
134         _;
135     }
136 
137 
138 
139     function LandManagement(address _unicornManagementAddress) public {
140         unicornManagement = UnicornManagementInterface(_unicornManagementAddress);
141         unicornManagement.registerInit(this);
142     }
143 
144 
145     function init() onlyUnicornManagement whenPaused external {
146         for(uint i = 0; i < initList.length; i++) {
147             LandInit(initList[i]).init();
148         }
149     }
150 
151 
152     struct InitItem {
153         uint listIndex;
154         bool exists;
155     }
156 
157     mapping (address => InitItem) private initItems;
158     address[] private initList;
159 
160     function registerInit(address _contract) external whenPaused {
161         require(msg.sender == ownerAddress() || tx.origin == ownerAddress());
162 
163         if (!initItems[_contract].exists) {
164             initItems[_contract] = InitItem({
165                 listIndex: initList.length,
166                 exists: true
167                 });
168             initList.push(_contract);
169         }
170     }
171 
172     function unregisterInit(address _contract) external onlyOwner whenPaused {
173         require(initItems[_contract].exists && initList.length > 0);
174         uint lastIdx = initList.length - 1;
175         initItems[initList[lastIdx]].listIndex = initItems[_contract].listIndex;
176         initList[initItems[_contract].listIndex] = initList[lastIdx];
177         initList.length--;
178         delete initItems[_contract];
179 
180     }
181 
182 
183     function runInit() external onlyOwner whenPaused {
184         for(uint i = 0; i < initList.length; i++) {
185             LandInit(initList[i]).init();
186         }
187     }
188 
189 
190     function ownerAddress() public view returns (address) {
191         return unicornManagement.ownerAddress();
192     }
193 
194     function managerAddress() public view returns (address) {
195         return unicornManagement.managerAddress();
196     }
197 
198     function communityAddress() public view returns (address) {
199         return unicornManagement.communityAddress();
200     }
201 
202     function walletAddress() public view returns (address) {
203         return unicornManagement.walletAddress();
204     }
205 
206     function candyToken() public view returns (address) {
207         return unicornManagement.candyToken();
208     }
209 
210     function megaCandyToken() public view returns (address) {
211         return unicornManagement.candyPowerToken();
212     }
213 
214     function dividendManagerAddress() public view returns (address) {
215         return unicornManagement.dividendManagerAddress();
216     }
217 
218     function setUnicornContract(address _unicornContractAddress) public onlyOwner whenUnlocked {
219         require(_unicornContractAddress != address(0));
220         unicornContracts[_unicornContractAddress] = true;
221         emit AddUnicornContract(_unicornContractAddress);
222     }
223 
224     function delUnicornContract(address _unicornContractAddress) external onlyOwner whenUnlocked{
225         require(unicornContracts[_unicornContractAddress]);
226         unicornContracts[_unicornContractAddress] = false;
227         emit DelUnicornContract(_unicornContractAddress);
228     }
229 
230     function isUnicornContract(address _unicornContractAddress) external view returns (bool) {
231         return unicornContracts[_unicornContractAddress];
232     }
233 
234 
235 
236     function setUserRank(address _userRankAddress) external onlyOwner whenPaused whenUnlocked {
237         require(_userRankAddress != address(0));
238         userRankAddress = _userRankAddress;
239         emit NewUserRankAddress(userRankAddress);
240     }
241 
242     function setCandyLand(address _candyLandAddress) external onlyOwner whenPaused whenUnlocked {
243         require(_candyLandAddress != address(0));
244         candyLandAddress = _candyLandAddress;
245         setUnicornContract(candyLandAddress);
246         emit NewCandyLandAddress(candyLandAddress);
247     }
248 
249     function setCandyLandSale(address _candyLandSaleAddress) external onlyOwner whenPaused whenUnlocked {
250         require(_candyLandSaleAddress != address(0));
251         candyLandSaleAddress = _candyLandSaleAddress;
252         setUnicornContract(candyLandSaleAddress);
253         emit NewCandyLandSaleAddress(candyLandSaleAddress);
254     }
255 
256 
257     function paused() public view returns(bool) {
258         return unicornManagement.paused();
259     }
260 
261 
262     function stopLandEthSale() external onlyOwner {
263         require(ethLandSaleOpen);
264         ethLandSaleOpen = false;
265     }
266 
267     function openLandEthSale() external onlyOwner {
268         require(!ethLandSaleOpen);
269         ethLandSaleOpen = true;
270     }
271 
272     function stopPresale() external onlyOwner {
273         require(presaleOpen);
274         presaleOpen = false;
275     }
276 
277     function setFirstRankForFree(bool _firstRankForFree) external onlyOwner {
278         require(firstRankForFree != _firstRankForFree);
279         firstRankForFree = _firstRankForFree;
280     }
281 
282 
283     //price in weis
284     function setLandPrice(uint _price, uint _candyPrice) external onlyManager {
285         landPriceWei = _price;
286         landPriceCandy = _candyPrice;
287         emit NewLandPrice(_price, _candyPrice);
288     }
289 
290     //1% - 100, 10% - 1000 50% - 5000
291     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
292         uint _amount = _value.mul(_percent).div(10000);
293         return (_amount);
294     }
295 }