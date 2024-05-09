1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     /**
29     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 contract ERC20 {
47     function allowance(address owner, address spender) public view returns (uint256);
48     function transferFrom(address from, address to, uint256 value) public returns (bool);
49     function approve(address spender, uint256 value) public returns (bool);
50     function totalSupply() public view returns (uint256);
51     function balanceOf(address who) public view returns (uint256);
52     function transfer(address to, uint256 value) public returns (bool);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 
58 interface LandManagementInterface {
59     function ownerAddress() external view returns (address);
60     function managerAddress() external view returns (address);
61     function communityAddress() external view returns (address);
62     function dividendManagerAddress() external view returns (address);
63     function walletAddress() external view returns (address);
64     //    function unicornTokenAddress() external view returns (address);
65     function candyToken() external view returns (address);
66     function megaCandyToken() external view returns (address);
67     function userRankAddress() external view returns (address);
68     function candyLandAddress() external view returns (address);
69     function candyLandSaleAddress() external view returns (address);
70 
71     function isUnicornContract(address _unicornContractAddress) external view returns (bool);
72 
73     function paused() external view returns (bool);
74     function presaleOpen() external view returns (bool);
75     function firstRankForFree() external view returns (bool);
76 
77     function ethLandSaleOpen() external view returns (bool);
78 
79     function landPriceWei() external view returns (uint);
80     function landPriceCandy() external view returns (uint);
81 
82     function registerInit(address _contract) external;
83 }
84 
85 
86 
87 contract LandAccessControl {
88 
89     LandManagementInterface public landManagement;
90 
91     function LandAccessControl(address _landManagementAddress) public {
92         landManagement = LandManagementInterface(_landManagementAddress);
93         landManagement.registerInit(this);
94     }
95 
96     modifier onlyOwner() {
97         require(msg.sender == landManagement.ownerAddress());
98         _;
99     }
100 
101     modifier onlyManager() {
102         require(msg.sender == landManagement.managerAddress());
103         _;
104     }
105 
106     modifier onlyCommunity() {
107         require(msg.sender == landManagement.communityAddress());
108         _;
109     }
110 
111     modifier whenNotPaused() {
112         require(!landManagement.paused());
113         _;
114     }
115 
116     modifier whenPaused {
117         require(landManagement.paused());
118         _;
119     }
120 
121     modifier onlyWhileEthSaleOpen {
122         require(landManagement.ethLandSaleOpen());
123         _;
124     }
125 
126     modifier onlyLandManagement() {
127         require(msg.sender == address(landManagement));
128         _;
129     }
130 
131     modifier onlyUnicornContract() {
132         require(landManagement.isUnicornContract(msg.sender));
133         _;
134     }
135 
136     modifier onlyCandyLand() {
137         require(msg.sender == address(landManagement.candyLandAddress()));
138         _;
139     }
140 
141 
142     modifier whilePresaleOpen() {
143         require(landManagement.presaleOpen());
144         _;
145     }
146 
147     function isGamePaused() external view returns (bool) {
148         return landManagement.paused();
149     }
150 }
151 
152 
153 contract CanReceiveApproval {
154     event ReceiveApproval(address from, uint256 value, address token);
155 
156     mapping (bytes4 => bool) allowedFuncs;
157 
158     modifier onlyPayloadSize(uint numwords) {
159         assert(msg.data.length >= numwords * 32 + 4);
160         _;
161     }
162 
163     modifier onlySelf(){
164         require(msg.sender == address(this));
165         _;
166     }
167 
168 
169     function bytesToBytes4(bytes b) internal pure returns (bytes4 out) {
170         for (uint i = 0; i < 4; i++) {
171             out |= bytes4(b[i] & 0xFF) >> (i << 3);
172         }
173     }
174 
175 }
176 
177 
178 contract UserRank is LandAccessControl, CanReceiveApproval {
179     using SafeMath for uint256;
180 
181     ERC20 public candyToken;
182 
183     struct Rank{
184         uint landLimit;
185         uint priceCandy;
186         uint priceEth;
187         string title;
188     }
189 
190     mapping (uint => Rank) public ranks;
191     uint public ranksCount = 0;
192 
193     mapping (address => uint) public userRanks;
194 
195     event TokensTransferred(address wallet, uint value);
196     event NewRankAdded(uint index, uint _landLimit, string _title, uint _priceCandy, uint _priceEth);
197     event RankChange(uint index, uint priceCandy, uint priceEth);
198     event BuyNextRank(address indexed owner, uint index);
199     event BuyRank(address indexed owner, uint index);
200 
201 
202 
203     function UserRank(address _landManagementAddress) LandAccessControl(_landManagementAddress) public {
204 
205         allowedFuncs[bytes4(keccak256("_receiveBuyNextRank(address)"))] = true;
206         allowedFuncs[bytes4(keccak256("_receiveBuyRank(address,uint256)"))] = true;
207         //3350000000000000 for candy
208 
209         addRank(1,   36000000000000000000,   120600000000000000,"Cryptolord");
210         addRank(5,   144000000000000000000,  482400000000000000,"Forklord");
211         addRank(10,  180000000000000000000,  603000000000000000,"Decentralord");
212         addRank(20,  360000000000000000000,  1206000000000000000,"Technomaster");
213         addRank(50,  1080000000000000000000, 3618000000000000000,"Bitmaster");
214         addRank(100, 1800000000000000000000, 6030000000000000000,"Megamaster");
215         addRank(200, 3600000000000000000000, 12060000000000000000,"Cyberduke");
216         addRank(400, 7200000000000000000000, 24120000000000000000,"Nanoprince");
217         addRank(650, 9000000000000000000000, 30150000000000000000,"Hyperprince");
218         addRank(1000,12600000000000000000000,42210000000000000000,"Ethercaesar");
219 
220 
221     }
222 
223     function init() onlyLandManagement whenPaused external {
224         candyToken = ERC20(landManagement.candyToken());
225     }
226 
227 
228 
229     function addRank(uint _landLimit, uint _priceCandy, uint _priceEth, string _title) onlyOwner public  {
230         //стоимость добавляемого должна быть не ниже предыдущего
231         require(ranks[ranksCount].priceCandy <= _priceCandy && ranks[ranksCount].priceEth <= _priceEth);
232         ranksCount++;
233         Rank storage r = ranks[ranksCount];
234 
235         r.landLimit = _landLimit;
236         r.priceCandy = _priceCandy;
237         r.priceEth = _priceEth;
238         r.title = _title;
239         emit NewRankAdded(ranksCount, _landLimit,_title,_priceCandy,_priceEth);
240     }
241 
242 
243     function editRank(uint _index, uint _priceCandy, uint _priceEth) onlyManager public  {
244         require(_index > 0 && _index <= ranksCount);
245         if (_index > 1) {
246             require(ranks[_index - 1].priceCandy <= _priceCandy && ranks[_index - 1].priceEth <= _priceEth);
247         }
248         if (_index < ranksCount) {
249             require(ranks[_index + 1].priceCandy >= _priceCandy && ranks[_index + 1].priceEth >= _priceEth);
250         }
251 
252         Rank storage r = ranks[_index];
253         r.priceCandy = _priceCandy;
254         r.priceEth = _priceEth;
255         emit RankChange(_index, _priceCandy, _priceEth);
256     }
257 
258     function buyNextRank() public {
259         _buyNextRank(msg.sender);
260     }
261 
262     function _receiveBuyNextRank(address _beneficiary) onlySelf onlyPayloadSize(1) public {
263         _buyNextRank(_beneficiary);
264     }
265 
266     function buyRank(uint _index) public {
267         _buyRank(msg.sender, _index);
268     }
269 
270     function _receiveBuyRank(address _beneficiary, uint _index) onlySelf onlyPayloadSize(2) public {
271         _buyRank(_beneficiary, _index);
272     }
273 
274 
275     function _buyNextRank(address _beneficiary) internal {
276         uint _index = userRanks[_beneficiary] + 1;
277         require(_index <= ranksCount);
278 
279         require(candyToken.transferFrom(_beneficiary, this, ranks[_index].priceCandy));
280         userRanks[_beneficiary] = _index;
281         emit BuyNextRank(_beneficiary, _index);
282     }
283 
284 
285     function _buyRank(address _beneficiary, uint _index) internal {
286         require(_index <= ranksCount);
287         require(userRanks[_beneficiary] < _index);
288 
289         uint fullPrice = _getPrice(userRanks[_beneficiary], _index);
290 
291         require(candyToken.transferFrom(_beneficiary, this, fullPrice));
292         userRanks[_beneficiary] = _index;
293         emit BuyRank(_beneficiary, _index);
294     }
295 
296 
297     function getPreSaleRank(address _user, uint _index) onlyManager whilePresaleOpen public {
298         require(_index <= ranksCount);
299         require(userRanks[_user] < _index);
300         userRanks[_user] = _index;
301         emit BuyRank(_user, _index);
302     }
303 
304 
305 
306     function getNextRank(address _user) onlyUnicornContract public returns (uint) {
307         uint _index = userRanks[_user] + 1;
308         require(_index <= ranksCount);
309         userRanks[_user] = _index;
310         return _index;
311         emit BuyNextRank(msg.sender, _index);
312     }
313 
314 
315     function getRank(address _user, uint _index) onlyUnicornContract public {
316         require(_index <= ranksCount);
317         require(userRanks[_user] <= _index);
318         userRanks[_user] = _index;
319         emit BuyRank(_user, _index);
320     }
321 
322 
323     function _getPrice(uint _userRank, uint _index) private view returns (uint) {
324         uint fullPrice = 0;
325 
326         for(uint i = _userRank+1; i <= _index; i++)
327         {
328             fullPrice = fullPrice.add(ranks[i].priceCandy);
329         }
330 
331         return fullPrice;
332     }
333 
334 
335     function getIndividualPrice(address _user, uint _index) public view returns (uint) {
336         require(_index <= ranksCount);
337         require(userRanks[_user] < _index);
338 
339         return _getPrice(userRanks[_user], _index);
340     }
341 
342 
343     function getRankPriceCandy(uint _index) public view returns (uint) {
344         return ranks[_index].priceCandy;
345     }
346 
347 
348     function getRankPriceEth(uint _index) public view returns (uint) {
349         return ranks[_index].priceEth;
350     }
351 
352     function getRankLandLimit(uint _index) public view returns (uint) {
353         return ranks[_index].landLimit;
354     }
355 
356 
357     function getRankTitle(uint _index) public view returns (string) {
358         return ranks[_index].title;
359     }
360 
361     function getUserRank(address _user) public view returns (uint) {
362         return userRanks[_user];
363     }
364 
365     function getUserLandLimit(address _user) public view returns (uint) {
366         return ranks[userRanks[_user]].landLimit;
367     }
368 
369 
370     function withdrawTokens() public onlyManager  {
371         require(candyToken.balanceOf(this) > 0);
372         candyToken.transfer(landManagement.walletAddress(), candyToken.balanceOf(this));
373         emit TokensTransferred(landManagement.walletAddress(), candyToken.balanceOf(this));
374     }
375 
376 
377     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
378         //require(_token == landManagement.candyToken());
379         require(msg.sender == address(candyToken));
380         require(allowedFuncs[bytesToBytes4(_extraData)]);
381         require(address(this).call(_extraData));
382         emit ReceiveApproval(_from, _value, _token);
383     }
384 
385 }