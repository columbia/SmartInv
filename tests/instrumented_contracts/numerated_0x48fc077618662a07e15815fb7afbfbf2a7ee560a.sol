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
45 contract ERC20 {
46     function allowance(address owner, address spender) public view returns (uint256);
47     function transferFrom(address from, address to, uint256 value) public returns (bool);
48     function approve(address spender, uint256 value) public returns (bool);
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public returns (bool);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 interface LandManagementInterface {
57     function ownerAddress() external view returns (address);
58     function managerAddress() external view returns (address);
59     function communityAddress() external view returns (address);
60     function dividendManagerAddress() external view returns (address);
61     function walletAddress() external view returns (address);
62     //    function unicornTokenAddress() external view returns (address);
63     function candyToken() external view returns (address);
64     function megaCandyToken() external view returns (address);
65     function userRankAddress() external view returns (address);
66     function candyLandAddress() external view returns (address);
67     function candyLandSaleAddress() external view returns (address);
68 
69     function isUnicornContract(address _unicornContractAddress) external view returns (bool);
70 
71     function paused() external view returns (bool);
72     function presaleOpen() external view returns (bool);
73     function firstRankForFree() external view returns (bool);
74 
75     function ethLandSaleOpen() external view returns (bool);
76 
77     function landPriceWei() external view returns (uint);
78     function landPriceCandy() external view returns (uint);
79 
80     function registerInit(address _contract) external;
81 }
82 
83 interface UserRankInterface  {
84     function buyNextRank() external;
85     function buyRank(uint _index) external;
86     function getIndividualPrice(address _user, uint _index) external view returns (uint);
87     function getRankPriceEth(uint _index) external view returns (uint);
88     function getRankPriceCandy(uint _index) external view returns (uint);
89     function getRankLandLimit(uint _index) external view returns (uint);
90     function getRankTitle(uint _index) external view returns (string);
91     function getUserRank(address _user) external view returns (uint);
92     function getUserLandLimit(address _user) external view returns (uint);
93     function ranksCount() external view returns (uint);
94     function getNextRank(address _user)  external returns (uint);
95     function getPreSaleRank(address owner, uint _index) external;
96     function getRank(address owner, uint _index) external;
97 }
98 
99 contract MegaCandyInterface is ERC20 {
100     function transferFromSystem(address _from, address _to, uint256 _value) public returns (bool);
101     function burn(address _from, uint256 _value) public returns (bool);
102     function mint(address _to, uint256 _amount) public returns (bool);
103 }
104 
105 
106 contract LandAccessControl {
107 
108     LandManagementInterface public landManagement;
109 
110     function LandAccessControl(address _landManagementAddress) public {
111         landManagement = LandManagementInterface(_landManagementAddress);
112         landManagement.registerInit(this);
113     }
114 
115     modifier onlyOwner() {
116         require(msg.sender == landManagement.ownerAddress());
117         _;
118     }
119 
120     modifier onlyManager() {
121         require(msg.sender == landManagement.managerAddress());
122         _;
123     }
124 
125     modifier onlyCommunity() {
126         require(msg.sender == landManagement.communityAddress());
127         _;
128     }
129 
130     modifier whenNotPaused() {
131         require(!landManagement.paused());
132         _;
133     }
134 
135     modifier whenPaused {
136         require(landManagement.paused());
137         _;
138     }
139 
140     modifier onlyWhileEthSaleOpen {
141         require(landManagement.ethLandSaleOpen());
142         _;
143     }
144 
145     modifier onlyLandManagement() {
146         require(msg.sender == address(landManagement));
147         _;
148     }
149 
150     modifier onlyUnicornContract() {
151         require(landManagement.isUnicornContract(msg.sender));
152         _;
153     }
154 
155     modifier onlyCandyLand() {
156         require(msg.sender == address(landManagement.candyLandAddress()));
157         _;
158     }
159 
160 
161     modifier whilePresaleOpen() {
162         require(landManagement.presaleOpen());
163         _;
164     }
165 
166     function isGamePaused() external view returns (bool) {
167         return landManagement.paused();
168     }
169 }
170 
171 
172 contract CanReceiveApproval {
173     event ReceiveApproval(address from, uint256 value, address token);
174 
175     mapping (bytes4 => bool) allowedFuncs;
176 
177     modifier onlyPayloadSize(uint numwords) {
178         assert(msg.data.length >= numwords * 32 + 4);
179         _;
180     }
181 
182     modifier onlySelf(){
183         require(msg.sender == address(this));
184         _;
185     }
186 
187 
188     function bytesToBytes4(bytes b) internal pure returns (bytes4 out) {
189         for (uint i = 0; i < 4; i++) {
190             out |= bytes4(b[i] & 0xFF) >> (i << 3);
191         }
192     }
193 
194 }
195 
196 
197 contract CandyLand is ERC20, LandAccessControl, CanReceiveApproval {
198     using SafeMath for uint256;
199 
200     UserRankInterface public userRank;
201     MegaCandyInterface public megaCandy;
202     ERC20 public candyToken;
203 
204     struct Gardener {
205         uint period;
206         uint price;
207         bool exists;
208     }
209 
210     struct Garden {
211         uint count;
212         uint startTime;
213         address owner;
214         uint gardenerId;
215         uint lastCropTime;
216         uint plantationIndex;
217         uint ownerPlantationIndex;
218     }
219 
220     string public constant name = "Unicorn Land";
221     string public constant symbol = "Land";
222     uint8 public constant decimals = 0;
223 
224     uint256 totalSupply_;
225     uint256 public MAX_SUPPLY = 30000;
226 
227     uint public constant plantedTime = 1 hours;
228     uint public constant plantedRate = 1 ether;
229     //uint public constant priceRate = 1 ether;
230 
231     mapping(address => uint256) balances;
232     mapping(address => mapping (address => uint256)) internal allowed;
233     mapping(address => uint256) planted;
234 
235     mapping(uint => Gardener) public gardeners;
236     // Mapping from garden ID to Garde struct
237     mapping(uint => Garden) public gardens;
238 
239     // garden index => gardenId
240     mapping(uint => uint) public plantation;
241     uint public plantationSize = 0;
242 
243     //user plantations
244     // owner => array (index => gardenId)
245     mapping(address => mapping(uint => uint)) public ownerPlantation;
246     mapping(address => uint) public ownerPlantationSize;
247 
248 
249     uint gardenerId = 0;
250     uint gardenId = 0;
251 
252 
253     event Mint(address indexed to, uint256 amount);
254     event MakePlant(address indexed owner, uint gardenId, uint count, uint gardenerId);
255     event GetCrop(address indexed owner, uint gardenId, uint  megaCandyCount);
256     event NewGardenerAdded(uint gardenerId, uint _period, uint _price);
257     event GardenerChange(uint gardenerId, uint _period, uint _price);
258     event NewLandLimit(uint newLimit);
259     event TokensTransferred(address wallet, uint value);
260 
261     function CandyLand(address _landManagementAddress) LandAccessControl(_landManagementAddress) public {
262         allowedFuncs[bytes4(keccak256("_receiveMakePlant(address,uint256,uint256)"))] = true;
263 
264         addGardener(24,   700000000000000000);
265         addGardener(120, 3000000000000000000);
266         addGardener(240, 5000000000000000000);
267         addGardener(720,12000000000000000000);
268     }
269 
270 
271     function init() onlyLandManagement whenPaused external {
272         userRank = UserRankInterface(landManagement.userRankAddress());
273         megaCandy = MegaCandyInterface(landManagement.megaCandyToken());
274         candyToken = ERC20(landManagement.candyToken());
275     }
276 
277 
278     function totalSupply() public view returns (uint256) {
279         return totalSupply_;
280     }
281 
282     function transfer(address _to, uint256 _value) public returns (bool) {
283         require(_to != address(0));
284         require(_value <= balances[msg.sender].sub(planted[msg.sender]));
285         require(balances[_to].add(_value) <= userRank.getUserLandLimit(_to));
286 
287         // SafeMath.sub will throw if there is not enough balance.
288         balances[msg.sender] = balances[msg.sender].sub(_value);
289         balances[_to] = balances[_to].add(_value);
290         emit Transfer(msg.sender, _to, _value);
291         return true;
292     }
293 
294     function balanceOf(address _owner) public view returns (uint256 balance) {
295         return balances[_owner];
296     }
297 
298     function plantedOf(address _owner) public view returns (uint256 balance) {
299         return planted[_owner];
300     }
301 
302     function freeLandsOf(address _owner) public view returns (uint256 balance) {
303         return balances[_owner].sub(planted[_owner]);
304     }
305 
306     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
307         require(_to != address(0));
308         require(_value <= balances[_from].sub(planted[_from]));
309         require(_value <= allowed[_from][msg.sender]);
310         require(balances[_to].add(_value) <= userRank.getUserLandLimit(_to));
311 
312         balances[_from] = balances[_from].sub(_value);
313         balances[_to] = balances[_to].add(_value);
314         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
315         emit Transfer(_from, _to, _value);
316         return true;
317     }
318 
319     function approve(address _spender, uint256 _value) public returns (bool) {
320         allowed[msg.sender][_spender] = _value;
321         emit Approval(msg.sender, _spender, _value);
322         return true;
323     }
324 
325     function allowance(address _owner, address _spender) public view returns (uint256) {
326         return allowed[_owner][_spender];
327     }
328 
329     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
330         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
331         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
332         return true;
333     }
334 
335     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
336         uint oldValue = allowed[msg.sender][_spender];
337         if (_subtractedValue > oldValue) {
338             allowed[msg.sender][_spender] = 0;
339         } else {
340             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
341         }
342         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
343         return true;
344     }
345 
346     function transferFromSystem(address _from, address _to, uint256 _value) onlyUnicornContract public returns (bool) {
347         require(_to != address(0));
348         require(_value <= balances[_from].sub(planted[_from]));
349         //    require(_value <= balances[_from]);
350         require(balances[_to].add(_value) <= userRank.getUserLandLimit(_to));
351 
352         balances[_from] = balances[_from].sub(_value);
353         balances[_to] = balances[_to].add(_value);
354         emit Transfer(_from, _to, _value);
355         return true;
356     }
357 
358     function mint(address _to, uint256 _amount) onlyUnicornContract public returns (bool) {
359         require(totalSupply_.add(_amount) <= MAX_SUPPLY);
360         require(balances[_to].add(_amount) <= userRank.getUserLandLimit(_to));
361         totalSupply_ = totalSupply_.add(_amount);
362         balances[_to] = balances[_to].add(_amount);
363         emit Mint(_to, _amount);
364         emit Transfer(address(0), _to, _amount);
365         return true;
366     }
367 
368 
369     function makePlant(uint _count, uint _gardenerId) public {
370         _makePlant(msg.sender, _count, _gardenerId);
371     }
372 
373 
374     function _receiveMakePlant(address _beneficiary, uint _count, uint _gardenerId) onlySelf onlyPayloadSize(3) public {
375         _makePlant(_beneficiary, _count, _gardenerId);
376     }
377 
378 
379     function _makePlant(address _owner, uint _count, uint _gardenerId) internal {
380         require(_count <= balances[_owner].sub(planted[_owner]) && _count > 0);
381 
382         //require(candyToken.transferFrom(msg.sender, this, _count.mul(priceRate)));
383 
384         if (_gardenerId > 0) {
385             require(gardeners[_gardenerId].exists);
386             require(candyToken.transferFrom(_owner, this, gardeners[_gardenerId].price.mul(_count)));
387         }
388 
389         gardens[++gardenId] = Garden({
390             count: _count,
391             startTime: now,
392             owner: _owner,
393             gardenerId: _gardenerId,
394             lastCropTime: now,
395             plantationIndex: plantationSize,
396             ownerPlantationIndex: ownerPlantationSize[_owner]
397             });
398 
399         planted[_owner] = planted[_owner].add(_count);
400         //update global plantation list
401         plantation[plantationSize++] = gardenId;
402         //update user plantation list
403         ownerPlantation[_owner][ownerPlantationSize[_owner]++] = gardenId;
404 
405         emit MakePlant(_owner, gardenId, _count, gardenerId);
406     }
407 
408 
409     function getCrop(uint _gardenId) public {
410         require(msg.sender == gardens[_gardenId].owner);
411         require(now >= gardens[_gardenId].lastCropTime.add(plantedTime));
412 
413         uint crop = 0;
414         uint cropCount = 1;
415         uint remainingCrops = 0;
416 
417         if (gardens[_gardenId].gardenerId > 0) {
418             uint finishTime = gardens[_gardenId].startTime.add(gardeners[gardens[_gardenId].gardenerId].period);
419             //время текущей сбоки урожая
420             uint currentCropTime = now < finishTime ? now : finishTime;
421             //количество урожаев которое соберем сейчас
422             cropCount = currentCropTime.sub(gardens[_gardenId].lastCropTime).div(plantedTime);
423             //время последней сборки урожая + время 1 урожая на количество урожаев которое соберем сейчас
424             gardens[_gardenId].lastCropTime = gardens[_gardenId].lastCropTime.add(cropCount.mul(plantedTime));
425             //количество оставшихся урожаев
426             remainingCrops = finishTime.sub(gardens[_gardenId].lastCropTime).div(plantedTime);
427         }
428 
429         crop = gardens[_gardenId].count.mul(plantedRate).mul(cropCount);
430         if (remainingCrops == 0) {
431             planted[msg.sender] = planted[msg.sender].sub(gardens[_gardenId].count);
432 
433             //delete from global plantation list
434             gardens[plantation[--plantationSize]].plantationIndex = gardens[_gardenId].plantationIndex;
435             plantation[gardens[_gardenId].plantationIndex] = plantation[plantationSize];
436             delete plantation[plantationSize];
437 
438             //delete from user plantation list
439             gardens[ownerPlantation[msg.sender][--ownerPlantationSize[msg.sender]]].ownerPlantationIndex = gardens[_gardenId].ownerPlantationIndex;
440             ownerPlantation[msg.sender][gardens[_gardenId].ownerPlantationIndex] = ownerPlantation[msg.sender][ownerPlantationSize[msg.sender]];
441             delete ownerPlantation[msg.sender][ownerPlantationSize[msg.sender]];
442 
443             delete gardens[_gardenId];
444 
445         }
446 
447         megaCandy.mint(msg.sender, crop);
448         emit GetCrop(msg.sender, _gardenId, crop);
449     }
450 
451 
452     function addGardener(uint _period, uint _price) onlyOwner public  {
453         gardeners[++gardenerId] = Gardener({
454             period: _period * 1 hours,
455             price: _price,
456             exists: true
457             });
458         emit NewGardenerAdded(gardenerId, _period, _price);
459     }
460 
461 
462     function editGardener(uint _gardenerId, uint _period, uint _price) onlyOwner public  {
463         require(gardeners[_gardenerId].exists);
464         Gardener storage g = gardeners[_gardenerId];
465         g.period = _period;
466         g.price = _price;
467         emit GardenerChange(_gardenerId, _period, _price);
468     }
469 
470 
471     function getUserLandLimit(address _user) public view returns(uint) {
472         return userRank.getRankLandLimit(userRank.getUserRank(_user)).sub(balances[_user]);
473     }
474 
475 
476     function setLandLimit() external onlyCommunity {
477         require(totalSupply_ == MAX_SUPPLY);
478         MAX_SUPPLY = MAX_SUPPLY.add(1000);
479         emit NewLandLimit(MAX_SUPPLY);
480     }
481 
482     //1% - 100, 10% - 1000 50% - 5000
483     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
484         uint _amount = _value.mul(_percent).div(10000);
485         return (_amount);
486     }
487 
488 
489     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
490         //require(_token == landManagement.candyToken());
491         require(msg.sender == address(candyToken));
492         require(allowedFuncs[bytesToBytes4(_extraData)]);
493         require(address(this).call(_extraData));
494         emit ReceiveApproval(_from, _value, _token);
495     }
496 
497 
498     function withdrawTokens() onlyManager public {
499         require(candyToken.balanceOf(this) > 0);
500         candyToken.transfer(landManagement.walletAddress(), candyToken.balanceOf(this));
501         emit TokensTransferred(landManagement.walletAddress(), candyToken.balanceOf(this));
502     }
503 
504 }