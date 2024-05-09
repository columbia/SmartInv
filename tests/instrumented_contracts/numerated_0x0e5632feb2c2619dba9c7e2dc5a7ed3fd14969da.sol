1 pragma solidity 0.4.24;
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
32 contract ERC721Interface {
33     //ERC721
34     function balanceOf(address owner) public view returns (uint256 _balance);
35     function ownerOf(uint256 tokenID) public view returns (address owner);
36     function transfer(address to, uint256 tokenID) public returns (bool);
37     function approve(address to, uint256 tokenID) public returns (bool);
38     function takeOwnership(uint256 tokenID) public;
39     function totalSupply() public view returns (uint);
40     function owns(address owner, uint256 tokenID) public view returns (bool);
41     function allowance(address claimant, uint256 tokenID) public view returns (bool);
42     function transferFrom(address from, address to, uint256 tokenID) public returns (bool);
43     function createLand(address owner) external returns (uint);
44 }
45 
46 
47 contract ERC20 {
48     function allowance(address owner, address spender) public view returns (uint256);
49     function transferFrom(address from, address to, uint256 value) public returns (bool);
50     function approve(address spender, uint256 value) public returns (bool);
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address who) public view returns (uint256);
53     function transfer(address to, uint256 value) public returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 
59 contract Ownable {
60     address public owner;
61     mapping(address => bool) admins;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64     event AddAdmin(address indexed admin);
65     event DelAdmin(address indexed admin);
66 
67 
68     /**
69      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70      * account.
71      */
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(msg.sender == owner);
81         _;
82     }
83 
84     modifier onlyAdmin() {
85         require(isAdmin(msg.sender));
86         _;
87     }
88 
89 
90     function addAdmin(address _adminAddress) external onlyOwner {
91         require(_adminAddress != address(0));
92         admins[_adminAddress] = true;
93         emit AddAdmin(_adminAddress);
94     }
95 
96     function delAdmin(address _adminAddress) external onlyOwner {
97         require(admins[_adminAddress]);
98         admins[_adminAddress] = false;
99         emit DelAdmin(_adminAddress);
100     }
101 
102     function isAdmin(address _adminAddress) public view returns (bool) {
103         return admins[_adminAddress];
104     }
105     /**
106      * @dev Allows the current owner to transfer control of the contract to a newOwner.
107      * @param _newOwner The address to transfer ownership to.
108      */
109     function transferOwnership(address _newOwner) external onlyOwner {
110         require(_newOwner != address(0));
111         emit OwnershipTransferred(owner, _newOwner);
112         owner = _newOwner;
113     }
114 
115 }
116 
117 interface NewAuctionContract {
118     function receiveAuction(address _token, uint _tokenId, uint _startPrice, uint _stopTime) external returns (bool);
119 }
120 
121 
122 contract ArconaMarketplaceContract is Ownable {
123     using SafeMath for uint;
124 
125     ERC20 public arconaToken;
126 
127     struct Auction {
128         address owner;
129         address token;
130         uint tokenId;
131         uint startPrice;
132         uint stopTime;
133         address winner;
134         uint executeTime;
135         uint finalPrice;
136         bool executed;
137         bool exists;
138     }
139 
140     mapping(address => bool) public acceptedTokens;
141     mapping(address => bool) public whiteList;
142     mapping (address => bool) public users;
143     mapping(uint256 => Auction) public auctions;
144     //token => token_id = auction id
145     mapping (address => mapping (uint => uint)) public auctionIndex;
146     mapping(address => uint256[]) private ownedAuctions;
147     uint private lastAuctionId;
148     uint defaultExecuteTime = 24 hours;
149     uint public auctionFee = 300; //3%
150     uint public gasInTokens = 1000000000000000000;
151     uint public minDuration = 1;
152     uint public maxDuration = 20160;
153     address public profitAddress;
154 
155     event ReceiveCreateAuction(address from, uint tokenId, address token);
156     event AddAcceptedToken(address indexed token);
157     event DelAcceptedToken(address indexed token);
158     event AddWhiteList(address indexed addr);
159     event DelWhiteList(address indexed addr);
160     event NewAuction(address indexed owner, uint tokenId, uint auctionId);
161     event AddUser(address indexed user);
162     event GetToken(uint auctionId, address winner);
163     event SetWinner(address winner, uint auctionId, uint finalPrice, uint executeTime);
164     event CancelAuction(uint auctionId);
165     event RestartAuction(uint auctionId);
166 
167     constructor(address _token, address _profitAddress) public {
168         arconaToken = ERC20(_token);
169         profitAddress = _profitAddress;
170     }
171 
172 
173     function() public payable {
174         if (!users[msg.sender]) {
175             users[msg.sender] = true;
176             emit AddUser(msg.sender);
177         }
178     }
179 
180 
181     function receiveCreateAuction(address _from, address _token, uint _tokenId, uint _startPrice, uint _duration) public returns (bool) {
182         require(isAcceptedToken(_token));
183         require(_duration >= minDuration && _duration <= maxDuration);
184         _createAuction(_from, _token, _tokenId, _startPrice, _duration);
185         emit ReceiveCreateAuction(_from, _tokenId, _token);
186         return true;
187     }
188 
189 
190     function createAuction(address _token, uint _tokenId, uint _startPrice, uint _duration) external returns (bool) {
191         require(isAcceptedToken(_token));
192         require(_duration >= minDuration && _duration <= maxDuration);
193         _createAuction(msg.sender, _token, _tokenId, _startPrice, _duration);
194         return true;
195     }
196 
197 
198     function _createAuction(address _from, address _token, uint _tokenId, uint _startPrice, uint _duration) internal returns (uint) {
199         require(ERC721Interface(_token).transferFrom(_from, this, _tokenId));
200 
201         auctions[++lastAuctionId] = Auction({
202             owner : _from,
203             token : _token,
204             tokenId : _tokenId,
205             startPrice : _startPrice,
206             //startTime : now,
207             stopTime : now + (_duration * 1 minutes),
208             winner : address(0),
209             executeTime : now + (_duration * 1 minutes) + defaultExecuteTime,
210             finalPrice : 0,
211             executed : false,
212             exists: true
213             });
214 
215         auctionIndex[_token][_tokenId] = lastAuctionId;
216         ownedAuctions[_from].push(lastAuctionId);
217 
218         emit NewAuction(_from, _tokenId, lastAuctionId);
219         return lastAuctionId;
220     }
221 
222 
223     function setWinner(address _winner, uint _auctionId, uint _finalPrice, uint _executeTime) onlyAdmin external {
224         require(auctions[_auctionId].exists);
225         require(!auctions[_auctionId].executed);
226         require(now > auctions[_auctionId].stopTime);
227         //require(auctions[_auctionId].winner == address(0));
228         require(_finalPrice >= auctions[_auctionId].startPrice);
229 
230         auctions[_auctionId].winner = _winner;
231         auctions[_auctionId].finalPrice = _finalPrice;
232         if (_executeTime > 0) {
233             auctions[_auctionId].executeTime = now + (_executeTime * 1 minutes);
234         }
235         emit SetWinner(_winner, _auctionId, _finalPrice, _executeTime);
236     }
237 
238 
239     function getToken(uint _auctionId) external {
240         require(auctions[_auctionId].exists);
241         require(!auctions[_auctionId].executed);
242         require(now <= auctions[_auctionId].executeTime);
243         require(msg.sender == auctions[_auctionId].winner);
244 
245         uint fullPrice = auctions[_auctionId].finalPrice;
246         require(arconaToken.transferFrom(msg.sender, this, fullPrice));
247 
248         if (!inWhiteList(auctions[_auctionId].owner)) {
249             uint fee = valueFromPercent(fullPrice, auctionFee);
250             fullPrice = fullPrice.sub(fee).sub(gasInTokens);
251         }
252         arconaToken.transfer(auctions[_auctionId].owner, fullPrice);
253 
254         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].winner, auctions[_auctionId].tokenId));
255         auctions[_auctionId].executed = true;
256         emit GetToken(_auctionId, msg.sender);
257     }
258 
259 
260     function cancelAuction(uint _auctionId) external {
261         require(auctions[_auctionId].exists);
262         require(!auctions[_auctionId].executed);
263         require(msg.sender == auctions[_auctionId].owner);
264         require(now > auctions[_auctionId].executeTime);
265 
266         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].owner, auctions[_auctionId].tokenId));
267         emit CancelAuction(_auctionId);
268     }
269 
270     function restartAuction(uint _auctionId, uint _startPrice, uint _duration) external {
271         require(auctions[_auctionId].exists);
272         require(!auctions[_auctionId].executed);
273         require(msg.sender == auctions[_auctionId].owner);
274         require(now > auctions[_auctionId].executeTime);
275 
276         auctions[_auctionId].startPrice = _startPrice;
277         auctions[_auctionId].stopTime = now + (_duration * 1 minutes);
278         auctions[_auctionId].executeTime = now + (_duration * 1 minutes) + defaultExecuteTime;
279         emit RestartAuction(_auctionId);
280     }
281 
282     function migrateAuction(uint _auctionId, address _newAuction) external {
283         require(auctions[_auctionId].exists);
284         require(!auctions[_auctionId].executed);
285         require(msg.sender == auctions[_auctionId].owner);
286         require(now > auctions[_auctionId].executeTime);
287 
288         require(ERC721Interface(auctions[_auctionId].token).approve(_newAuction, auctions[_auctionId].tokenId));
289         require(NewAuctionContract(_newAuction).receiveAuction(
290                 auctions[_auctionId].token,
291                 auctions[_auctionId].tokenId,
292                 auctions[_auctionId].startPrice,
293                 auctions[_auctionId].stopTime
294             ));
295     }
296 
297 
298     function ownerAuctionCount(address _owner) external view returns (uint256) {
299         return ownedAuctions[_owner].length;
300     }
301 
302 
303     function auctionsOf(address _owner) external view returns (uint256[]) {
304         return ownedAuctions[_owner];
305     }
306 
307 
308     function addAcceptedToken(address _token) onlyAdmin external {
309         require(_token != address(0));
310         acceptedTokens[_token] = true;
311         emit AddAcceptedToken(_token);
312     }
313 
314 
315     function delAcceptedToken(address _token) onlyAdmin external {
316         require(acceptedTokens[_token]);
317         acceptedTokens[_token] = false;
318         emit DelAcceptedToken(_token);
319     }
320 
321 
322     function addWhiteList(address _address) onlyAdmin external {
323         require(_address != address(0));
324         whiteList[_address] = true;
325         emit AddWhiteList(_address);
326     }
327 
328 
329     function delWhiteList(address _address) onlyAdmin external {
330         require(whiteList[_address]);
331         whiteList[_address] = false;
332         emit DelWhiteList(_address);
333     }
334 
335 
336     function setDefaultExecuteTime(uint _hours) onlyAdmin external {
337         defaultExecuteTime = _hours * 1 hours;
338     }
339 
340 
341     function setAuctionFee(uint _fee) onlyAdmin external {
342         auctionFee = _fee;
343     }
344 
345 
346     function setGasInTokens(uint _gasInTokens) onlyAdmin external {
347         gasInTokens = _gasInTokens;
348     }
349 
350 
351     function setMinDuration(uint _minDuration) onlyAdmin external {
352         minDuration = _minDuration;
353     }
354 
355 
356     function setMaxDuration(uint _maxDuration) onlyAdmin external {
357         maxDuration = _maxDuration;
358     }
359 
360 
361     function setProfitAddress(address _profitAddress) onlyOwner external {
362         require(_profitAddress != address(0));
363         profitAddress = _profitAddress;
364     }
365 
366 
367     function isAcceptedToken(address _token) public view returns (bool) {
368         return acceptedTokens[_token];
369     }
370 
371 
372     function inWhiteList(address _address) public view returns (bool) {
373         return whiteList[_address];
374     }
375 
376 
377     function withdrawTokens() onlyAdmin public {
378         require(arconaToken.balanceOf(this) > 0);
379         arconaToken.transfer(profitAddress, arconaToken.balanceOf(this));
380     }
381 
382     //1% - 100, 10% - 1000 50% - 5000
383     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
384         uint _amount = _value.mul(_percent).div(10000);
385         return (_amount);
386     }
387 
388     function destruct() onlyOwner public {
389         selfdestruct(owner);
390     }
391 }