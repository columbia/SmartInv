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
48 
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50 
51     function approve(address spender, uint256 value) public returns (bool);
52 
53     function totalSupply() public view returns (uint256);
54 
55     function balanceOf(address who) public view returns (uint256);
56 
57     function transfer(address to, uint256 value) public returns (bool);
58 
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 interface LandManagementInterface {
65     function ownerAddress() external view returns (address);
66 
67     function managerAddress() external view returns (address);
68 
69     function communityAddress() external view returns (address);
70 
71     function dividendManagerAddress() external view returns (address);
72 
73     function walletAddress() external view returns (address);
74     //    function unicornTokenAddress() external view returns (address);
75     function candyToken() external view returns (address);
76 
77     function megaCandyToken() external view returns (address);
78 
79     function userRankAddress() external view returns (address);
80 
81     function candyLandAddress() external view returns (address);
82 
83     function candyLandSaleAddress() external view returns (address);
84 
85     function isUnicornContract(address _unicornContractAddress) external view returns (bool);
86 
87     function paused() external view returns (bool);
88 
89     function presaleOpen() external view returns (bool);
90 
91     function firstRankForFree() external view returns (bool);
92 
93     function ethLandSaleOpen() external view returns (bool);
94 
95     function landPriceWei() external view returns (uint);
96 
97     function landPriceCandy() external view returns (uint);
98 
99     function registerInit(address _contract) external;
100 }
101 
102 interface UserRankInterface {
103     function buyNextRank() external;
104 
105     function buyRank(uint _index) external;
106 
107     function getIndividualPrice(address _user, uint _index) external view returns (uint);
108 
109     function getRankPriceEth(uint _index) external view returns (uint);
110 
111     function getRankPriceCandy(uint _index) external view returns (uint);
112 
113     function getRankLandLimit(uint _index) external view returns (uint);
114 
115     function getRankTitle(uint _index) external view returns (string);
116 
117     function getUserRank(address _user) external view returns (uint);
118 
119     function getUserLandLimit(address _user) external view returns (uint);
120 
121     function ranksCount() external view returns (uint);
122 
123     function getNextRank(address _user) external returns (uint);
124 
125     function getPreSaleRank(address owner, uint _index) external;
126 
127     function getRank(address owner, uint _index) external;
128 }
129 
130 
131 contract LandAccessControl {
132 
133     LandManagementInterface public landManagement;
134 
135     function LandAccessControl(address _landManagementAddress) public {
136         landManagement = LandManagementInterface(_landManagementAddress);
137         landManagement.registerInit(this);
138     }
139 
140     modifier onlyOwner() {
141         require(msg.sender == landManagement.ownerAddress());
142         _;
143     }
144 
145     modifier onlyManager() {
146         require(msg.sender == landManagement.managerAddress());
147         _;
148     }
149 
150     modifier onlyCommunity() {
151         require(msg.sender == landManagement.communityAddress());
152         _;
153     }
154 
155     modifier whenNotPaused() {
156         require(!landManagement.paused());
157         _;
158     }
159 
160     modifier whenPaused {
161         require(landManagement.paused());
162         _;
163     }
164 
165     modifier onlyWhileEthSaleOpen {
166         require(landManagement.ethLandSaleOpen());
167         _;
168     }
169 
170     modifier onlyLandManagement() {
171         require(msg.sender == address(landManagement));
172         _;
173     }
174 
175     modifier onlyUnicornContract() {
176         require(landManagement.isUnicornContract(msg.sender));
177         _;
178     }
179 
180     modifier onlyCandyLand() {
181         require(msg.sender == address(landManagement.candyLandAddress()));
182         _;
183     }
184 
185 
186     modifier whilePresaleOpen() {
187         require(landManagement.presaleOpen());
188         _;
189     }
190 
191     function isGamePaused() external view returns (bool) {
192         return landManagement.paused();
193     }
194 }
195 
196 
197 contract CanReceiveApproval {
198     event ReceiveApproval(address from, uint256 value, address token);
199 
200     mapping(bytes4 => bool) allowedFuncs;
201 
202     modifier onlyPayloadSize(uint numwords) {
203         assert(msg.data.length >= numwords * 32 + 4);
204         _;
205     }
206 
207     modifier onlySelf(){
208         require(msg.sender == address(this));
209         _;
210     }
211 
212 
213     function bytesToBytes4(bytes b) internal pure returns (bytes4 out) {
214         for (uint i = 0; i < 4; i++) {
215             out |= bytes4(b[i] & 0xFF) >> (i << 3);
216         }
217     }
218 
219 }
220 
221 
222 contract CandyLandInterface is ERC20 {
223     function transferFromSystem(address _from, address _to, uint256 _value) public returns (bool);
224 
225     function mint(address _to, uint256 _amount) public returns (bool);
226 
227     function MAX_SUPPLY() external view returns (uint);
228 }
229 
230 interface DividendManagerInterface {
231     function payDividend() external payable;
232 }
233 //TODO marketplace
234 contract CandyLandSale is LandAccessControl, CanReceiveApproval {
235     using SafeMath for uint256;
236 
237     UserRankInterface public userRank;
238     ERC20 public candyToken;
239     CandyLandInterface public candyLand;
240 
241     event FundsTransferred(address dividendManager, uint value);
242     event TokensTransferred(address wallet, uint value);
243     event BuyLand(address indexed owner, uint count);
244 
245 
246     function CandyLandSale(address _landManagementAddress) LandAccessControl(_landManagementAddress) public {
247         allowedFuncs[bytes4(keccak256("_receiveBuyLandForCandy(address,uint256)"))] = true;
248     }
249 
250 
251     function init() onlyLandManagement whenPaused external {
252         userRank = UserRankInterface(landManagement.userRankAddress());
253         candyToken = ERC20(landManagement.candyToken());
254         candyLand = CandyLandInterface(landManagement.candyLandAddress());
255     }
256     
257     function() public payable {
258         buyLandForEth();
259     }
260 
261     function buyLandForEth() onlyWhileEthSaleOpen public payable {
262         require(candyLand.totalSupply() <= candyLand.MAX_SUPPLY());
263         //MAX_SUPPLY проверяется так же в _mint
264         uint landPriceWei = landManagement.landPriceWei();
265         require(msg.value >= landPriceWei);
266 
267         uint weiAmount = msg.value;
268         uint landCount = 0;
269         uint _landAmount = 0;
270         uint userRankIndex = userRank.getUserRank(msg.sender);
271         uint ranksCount = userRank.ranksCount();
272 
273         for (uint i = userRankIndex; i <= ranksCount && weiAmount >= landPriceWei; i++) {
274 
275             uint userLandLimit = userRank.getRankLandLimit(i).sub(candyLand.balanceOf(msg.sender)).sub(_landAmount);
276             landCount = weiAmount.div(landPriceWei);
277 
278             if (landCount <= userLandLimit) {
279 
280                 _landAmount = _landAmount.add(landCount);
281                 weiAmount = weiAmount.sub(landCount.mul(landPriceWei));
282                 break;
283 
284             } else {
285                 /*
286                   Заведомо больше чем лимит, поэтому забираем весь лимит и если это не последнний ранг и есть
287                   деньги на следубщий покупаем его и переходим на новый шаг.
288                 */
289                 _landAmount = _landAmount.add(userLandLimit);
290                 weiAmount = weiAmount.sub(userLandLimit.mul(landPriceWei));
291 
292                 uint nextPrice = (i == 0 && landManagement.firstRankForFree()) ? 0 : userRank.getRankPriceEth(i + 1);
293 
294                 if (i == ranksCount || weiAmount < nextPrice) {
295                     break;
296                 }
297 
298                 userRank.getNextRank(msg.sender);
299                 weiAmount = weiAmount.sub(nextPrice);
300             }
301 
302         }
303 
304         require(_landAmount > 0);
305         candyLand.mint(msg.sender, _landAmount);
306 
307         emit BuyLand(msg.sender, _landAmount);
308 
309         if (weiAmount > 0) {
310             msg.sender.transfer(weiAmount);
311         }
312 
313     }
314 
315 
316     function buyLandForCandy(uint _count) external {
317         _buyLandForCandy(msg.sender, _count);
318     }
319 
320     function _receiveBuyLandForCandy(address _owner, uint _count) onlySelf onlyPayloadSize(2) public {
321         _buyLandForCandy(_owner, _count);
322     }
323 
324 
325     function findRankByCount(uint _rank, uint _totalRanks, uint _balance, uint _count) internal view returns (uint, uint) {
326         uint landLimit = userRank.getRankLandLimit(_rank).sub(_balance);
327         if (_count > landLimit && _rank < _totalRanks) {
328             return findRankByCount(_rank + 1, _totalRanks, _balance, _count);
329         }
330         return (_rank, landLimit);
331     }
332 
333     function getBuyLandInfo(address _owner, uint _count) public view returns (uint, uint, uint){
334         uint rank = userRank.getUserRank(_owner);
335         uint neededRank;
336         uint landLimit;
337         uint totalPrice;
338         (neededRank, landLimit) = findRankByCount(
339             rank,
340             userRank.ranksCount(),
341             candyLand.balanceOf(_owner),
342             _count
343         );
344 
345         uint landPriceCandy = landManagement.landPriceCandy();
346 
347         if (_count > landLimit) {
348             _count = landLimit;
349         }
350         require(_count > 0);
351 
352         if (rank < neededRank) {
353             totalPrice = userRank.getIndividualPrice(_owner, neededRank);
354             if (rank == 0 && landManagement.firstRankForFree()) {
355                 totalPrice = totalPrice.sub(userRank.getRankPriceCandy(1));
356             }
357         }
358         totalPrice = totalPrice.add(_count.mul(landPriceCandy));
359 
360         return (rank, neededRank, totalPrice);
361     }
362 
363     function _buyLandForCandy(address _owner, uint _count) internal {
364         require(_count > 0);
365         require(candyLand.totalSupply().add(_count) <= candyLand.MAX_SUPPLY());
366         uint rank;
367         uint neededRank;
368         uint totalPrice;
369 
370         (rank, neededRank, totalPrice) = getBuyLandInfo(_owner, _count);
371         require(candyToken.transferFrom(_owner, this, totalPrice));
372         if (rank < neededRank) {
373             userRank.getRank(_owner, neededRank);
374         }
375         candyLand.mint(_owner, _count);
376         emit BuyLand(_owner, _count);
377     }
378 
379     function createPresale(address _owner, uint _count, uint _rankIndex) onlyManager whilePresaleOpen public {
380         require(candyLand.totalSupply().add(_count) <= candyLand.MAX_SUPPLY());
381         userRank.getRank(_owner, _rankIndex);
382         candyLand.mint(_owner, _count);
383     }
384 
385 
386     function withdrawTokens() onlyManager public {
387         require(candyToken.balanceOf(this) > 0);
388         candyToken.transfer(landManagement.walletAddress(), candyToken.balanceOf(this));
389         emit TokensTransferred(landManagement.walletAddress(), candyToken.balanceOf(this));
390     }
391 
392 
393     function transferEthersToDividendManager(uint _value) onlyManager public {
394         require(address(this).balance >= _value);
395         DividendManagerInterface dividendManager = DividendManagerInterface(landManagement.dividendManagerAddress());
396         dividendManager.payDividend.value(_value)();
397         emit FundsTransferred(landManagement.dividendManagerAddress(), _value);
398     }
399 
400 
401     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
402         //require(_token == landManagement.candyToken());
403         require(msg.sender == address(candyToken));
404         require(allowedFuncs[bytesToBytes4(_extraData)]);
405         require(address(this).call(_extraData));
406         emit ReceiveApproval(_from, _value, _token);
407     }
408 }