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
229         auctions[_auctionId].winner = _winner;
230         auctions[_auctionId].finalPrice = _finalPrice;
231         if (_executeTime > 0) {
232             auctions[_auctionId].executeTime = now + (_executeTime * 1 minutes);
233         }
234         emit SetWinner(_winner, _auctionId, _finalPrice, _executeTime);
235     }
236 
237 
238     function getToken(uint _auctionId) external {
239         require(auctions[_auctionId].exists);
240         require(!auctions[_auctionId].executed);
241         require(now <= auctions[_auctionId].executeTime);
242         require(msg.sender == auctions[_auctionId].winner);
243 
244         uint fullPrice = auctions[_auctionId].finalPrice;
245         require(arconaToken.transferFrom(msg.sender, this, fullPrice));
246 
247         if (!inWhiteList(msg.sender)) {
248             uint fee = valueFromPercent(fullPrice, auctionFee);
249             fullPrice = fullPrice.sub(fee).sub(gasInTokens);
250         }
251         arconaToken.transfer(auctions[_auctionId].owner, fullPrice);
252 
253         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].winner, auctions[_auctionId].tokenId));
254         auctions[_auctionId].executed = true;
255         emit GetToken(_auctionId, msg.sender);
256     }
257 
258 
259     function cancelAuction(uint _auctionId) external {
260         require(auctions[_auctionId].exists);
261         require(!auctions[_auctionId].executed);
262         require(msg.sender == auctions[_auctionId].owner);
263         require(now > auctions[_auctionId].executeTime);
264 
265         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].owner, auctions[_auctionId].tokenId));
266         emit CancelAuction(_auctionId);
267     }
268 
269     function restartAuction(uint _auctionId, uint _startPrice, uint _duration) external {
270         require(auctions[_auctionId].exists);
271         require(!auctions[_auctionId].executed);
272         require(msg.sender == auctions[_auctionId].owner);
273         require(now > auctions[_auctionId].executeTime);
274 
275         auctions[_auctionId].startPrice = _startPrice;
276         auctions[_auctionId].stopTime = now + (_duration * 1 minutes);
277         auctions[_auctionId].executeTime = now + (_duration * 1 minutes) + defaultExecuteTime;
278         emit RestartAuction(_auctionId);
279     }
280 
281     function migrateAuction(uint _auctionId, address _newAuction) external {
282         require(auctions[_auctionId].exists);
283         require(!auctions[_auctionId].executed);
284         require(msg.sender == auctions[_auctionId].owner);
285         require(now > auctions[_auctionId].executeTime);
286 
287         require(ERC721Interface(auctions[_auctionId].token).approve(_newAuction, auctions[_auctionId].tokenId));
288         require(NewAuctionContract(_newAuction).receiveAuction(
289                 auctions[_auctionId].token,
290                 auctions[_auctionId].tokenId,
291                 auctions[_auctionId].startPrice,
292                 auctions[_auctionId].stopTime
293             ));
294     }
295 
296 
297     function ownerAuctionCount(address _owner) external view returns (uint256) {
298         return ownedAuctions[_owner].length;
299     }
300 
301 
302     function auctionsOf(address _owner) external view returns (uint256[]) {
303         return ownedAuctions[_owner];
304     }
305 
306 
307     function addAcceptedToken(address _token) onlyAdmin external {
308         require(_token != address(0));
309         acceptedTokens[_token] = true;
310         emit AddAcceptedToken(_token);
311     }
312 
313 
314     function delAcceptedToken(address _token) onlyAdmin external {
315         require(acceptedTokens[_token]);
316         acceptedTokens[_token] = false;
317         emit DelAcceptedToken(_token);
318     }
319 
320 
321     function addWhiteList(address _address) onlyAdmin external {
322         require(_address != address(0));
323         whiteList[_address] = true;
324         emit AddWhiteList(_address);
325     }
326 
327 
328     function delWhiteList(address _address) onlyAdmin external {
329         require(whiteList[_address]);
330         whiteList[_address] = false;
331         emit DelWhiteList(_address);
332     }
333 
334 
335     function setDefaultExecuteTime(uint _hours) onlyAdmin external {
336         defaultExecuteTime = _hours * 1 hours;
337     }
338 
339 
340     function setAuctionFee(uint _fee) onlyAdmin external {
341         auctionFee = _fee;
342     }
343 
344 
345     function setGasInTokens(uint _gasInTokens) onlyAdmin external {
346         gasInTokens = _gasInTokens;
347     }
348 
349 
350     function setMinDuration(uint _minDuration) onlyAdmin external {
351         minDuration = _minDuration;
352     }
353 
354 
355     function setMaxDuration(uint _maxDuration) onlyAdmin external {
356         maxDuration = _maxDuration;
357     }
358 
359 
360     function setProfitAddress(address _profitAddress) onlyOwner external {
361         require(_profitAddress != address(0));
362         profitAddress = _profitAddress;
363     }
364 
365 
366     function isAcceptedToken(address _token) public view returns (bool) {
367         return acceptedTokens[_token];
368     }
369 
370 
371     function inWhiteList(address _address) public view returns (bool) {
372         return whiteList[_address];
373     }
374 
375 
376     function withdrawTokens() onlyAdmin public {
377         require(arconaToken.balanceOf(this) > 0);
378         arconaToken.transfer(profitAddress, arconaToken.balanceOf(this));
379     }
380 
381     //1% - 100, 10% - 1000 50% - 5000
382     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
383         uint _amount = _value.mul(_percent).div(10000);
384         return (_amount);
385     }
386 
387     function destruct() onlyOwner public {
388         selfdestruct(owner);
389     }
390 }