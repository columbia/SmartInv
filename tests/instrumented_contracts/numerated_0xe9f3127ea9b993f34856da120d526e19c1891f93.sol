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
121 //TODO CHECK duration before deploy in mainnet
122 contract AuctionContract is Ownable {
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
165 
166     constructor(address _token, address _profitAddress) public {
167         arconaToken = ERC20(_token);
168         profitAddress = _profitAddress;
169     }
170 
171 
172     function() public payable {
173         if (!users[msg.sender]) {
174             users[msg.sender] = true;
175             emit AddUser(msg.sender);
176         }
177     }
178 
179 
180     function receiveCreateAuction(address _from, address _token, uint _tokenId, uint _startPrice, uint _duration) public returns (bool) {
181         require(isAcceptedToken(_token));
182         require(_duration >= minDuration && _duration <= maxDuration);
183         _createAuction(_from, _token, _tokenId, _startPrice, _duration);
184         emit ReceiveCreateAuction(_from, _tokenId, _token);
185         return true;
186     }
187 
188 
189     function createAuction(address _token, uint _tokenId, uint _startPrice, uint _duration) external returns (bool) {
190         require(isAcceptedToken(_token));
191         require(_duration >= minDuration && _duration <= maxDuration);
192         _createAuction(msg.sender, _token, _tokenId, _startPrice, _duration);
193         return true;
194     }
195 
196 
197     function _createAuction(address _from, address _token, uint _tokenId, uint _startPrice, uint _duration) internal returns (uint) {
198         require(ERC721Interface(_token).transferFrom(_from, this, _tokenId));
199 
200         auctions[++lastAuctionId] = Auction({
201             owner : _from,
202             token : _token,
203             tokenId : _tokenId,
204             startPrice : _startPrice,
205             //startTime : now,
206             stopTime : now + (_duration * 1 minutes),
207             winner : address(0),
208             executeTime : now + (_duration * 1 minutes) + defaultExecuteTime,
209             finalPrice : 0,
210             executed : false,
211             exists: true
212             });
213 
214         auctionIndex[_token][_tokenId] = lastAuctionId;
215         ownedAuctions[_from].push(lastAuctionId);
216 
217         emit NewAuction(_from, _tokenId, lastAuctionId);
218         return lastAuctionId;
219     }
220 
221 
222     function setWinner(address _winner, uint _auctionId, uint _finalPrice, uint _executeTime) onlyAdmin external {
223         require(auctions[_auctionId].exists);
224         require(!auctions[_auctionId].executed);
225         require(now > auctions[_auctionId].stopTime);
226         //require(auctions[_auctionId].winner == address(0));
227         require(_finalPrice >= auctions[_auctionId].startPrice);
228         auctions[_auctionId].winner = _winner;
229         auctions[_auctionId].finalPrice = _finalPrice;
230         if (_executeTime > 0) {
231             auctions[_auctionId].executeTime = now + (_executeTime * 1 minutes);
232         }
233         emit SetWinner(_winner, _auctionId, _finalPrice, _executeTime);
234     }
235 
236 
237     function getToken(uint _auctionId) external {
238         require(auctions[_auctionId].exists);
239         require(!auctions[_auctionId].executed);
240         require(now <= auctions[_auctionId].executeTime);
241         require(msg.sender == auctions[_auctionId].winner);
242 
243         uint fullPrice = auctions[_auctionId].finalPrice;
244         require(arconaToken.transferFrom(msg.sender, this, fullPrice));
245 
246         if (!inWhiteList(msg.sender)) {
247             uint fee = valueFromPercent(fullPrice, auctionFee);
248             fullPrice = fullPrice.sub(fee).sub(gasInTokens);
249         }
250         arconaToken.transfer(auctions[_auctionId].owner, fullPrice);
251 
252         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].winner, auctions[_auctionId].tokenId));
253         auctions[_auctionId].executed = true;
254         emit GetToken(_auctionId, msg.sender);
255     }
256 
257 
258     function cancelAuction(uint _auctionId) external {
259         require(auctions[_auctionId].exists);
260         require(!auctions[_auctionId].executed);
261         require(msg.sender == auctions[_auctionId].owner);
262         require(now > auctions[_auctionId].executeTime);
263 
264         require(ERC721Interface(auctions[_auctionId].token).transfer(auctions[_auctionId].owner, auctions[_auctionId].tokenId));
265         emit CancelAuction(_auctionId);
266     }
267 
268 
269     function migrateAuction(uint _auctionId, address _newAuction) external {
270         require(auctions[_auctionId].exists);
271         require(!auctions[_auctionId].executed);
272         require(msg.sender == auctions[_auctionId].owner);
273         require(now > auctions[_auctionId].executeTime);
274 
275         require(ERC721Interface(auctions[_auctionId].token).approve(_newAuction, auctions[_auctionId].tokenId));
276         require(NewAuctionContract(_newAuction).receiveAuction(
277                 auctions[_auctionId].token,
278                 auctions[_auctionId].tokenId,
279                 auctions[_auctionId].startPrice,
280                 auctions[_auctionId].stopTime
281             ));
282     }
283 
284 
285     function ownerAuctionCount(address _owner) external view returns (uint256) {
286         return ownedAuctions[_owner].length;
287     }
288 
289 
290     function auctionsOf(address _owner) external view returns (uint256[]) {
291         return ownedAuctions[_owner];
292     }
293 
294 
295     function addAcceptedToken(address _token) onlyAdmin external {
296         require(_token != address(0));
297         acceptedTokens[_token] = true;
298         emit AddAcceptedToken(_token);
299     }
300 
301 
302     function delAcceptedToken(address _token) onlyAdmin external {
303         require(acceptedTokens[_token]);
304         acceptedTokens[_token] = false;
305         emit DelAcceptedToken(_token);
306     }
307 
308 
309     function addWhiteList(address _address) onlyAdmin external {
310         require(_address != address(0));
311         whiteList[_address] = true;
312         emit AddWhiteList(_address);
313     }
314 
315 
316     function delWhiteList(address _address) onlyAdmin external {
317         require(whiteList[_address]);
318         whiteList[_address] = false;
319         emit DelWhiteList(_address);
320     }
321 
322 
323     function setDefaultExecuteTime(uint _hours) onlyAdmin external {
324         defaultExecuteTime = _hours * 1 hours;
325     }
326 
327 
328     function setAuctionFee(uint _fee) onlyAdmin external {
329         auctionFee = _fee;
330     }
331 
332 
333     function setGasInTokens(uint _gasInTokens) onlyAdmin external {
334         gasInTokens = _gasInTokens;
335     }
336 
337 
338     function setMinDuration(uint _minDuration) onlyAdmin external {
339         minDuration = _minDuration;
340     }
341 
342 
343     function setMaxDuration(uint _maxDuration) onlyAdmin external {
344         maxDuration = _maxDuration;
345     }
346 
347 
348     function setProfitAddress(address _profitAddress) onlyOwner external {
349         require(_profitAddress != address(0));
350         profitAddress = _profitAddress;
351     }
352 
353 
354     function isAcceptedToken(address _token) public view returns (bool) {
355         return acceptedTokens[_token];
356     }
357 
358 
359     function inWhiteList(address _address) public view returns (bool) {
360         return whiteList[_address];
361     }
362 
363 
364     function withdrawTokens() onlyAdmin public {
365         require(arconaToken.balanceOf(this) > 0);
366         arconaToken.transfer(profitAddress, arconaToken.balanceOf(this));
367     }
368 
369     //1% - 100, 10% - 1000 50% - 5000
370     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
371         uint _amount = _value.mul(_percent).div(10000);
372         return (_amount);
373     }
374 }