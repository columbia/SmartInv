1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 
111 
112 
113 //////////////CONTRACT//////////////
114 
115 
116 
117 
118 contract Marketplace is Upgradable {
119     using SafeMath256 for uint256;
120 
121     struct Auction {
122         address seller;
123         uint256 startPrice;
124         uint256 endPrice;
125         uint16 period; // in hours
126         uint256 created;
127         bool isGold; // gold or ether
128     }
129 
130     uint256 constant MULTIPLIER = 1000000; // for more accurate calculations
131     uint16 constant MAX_PERIOD = 8760; // 8760 hours = 1 year
132 
133     uint8 constant FLAT_TYPE = 0;
134     uint8 constant INCREASING_TYPE = 1;
135     uint8 constant DUTCH_TYPE = 2;
136 
137     mapping (address => uint256[]) internal ownedTokens;
138     mapping (uint256 => uint256) internal ownedTokensIndex;
139     mapping (uint256 => uint256) allTokensIndex;
140     mapping (uint256 => Auction) tokenToAuction;
141 
142     uint256[] allTokens;
143 
144     constructor() public {}
145 
146     function sellToken(
147         uint256 _tokenId,
148         address _seller,
149         uint256 _startPrice,
150         uint256 _endPrice,
151         uint16 _period,
152         bool _isGold
153     ) external onlyController {
154         Auction memory _auction;
155 
156         require(_startPrice > 0 && _endPrice > 0, "price must be more than 0");
157         if (_startPrice != _endPrice) {
158             require(_period > 0 && _period <= MAX_PERIOD, "wrong period value");
159         }
160         _auction = Auction(_seller, _startPrice, _endPrice, _period, now, _isGold);
161 
162         // if auction doesn't exist
163         if (tokenToAuction[_tokenId].seller == address(0)) {
164             uint256 length = ownedTokens[_seller].length;
165             ownedTokens[_seller].push(_tokenId);
166             ownedTokensIndex[_tokenId] = length;
167 
168             allTokensIndex[_tokenId] = allTokens.length;
169             allTokens.push(_tokenId);
170         }
171         tokenToAuction[_tokenId] = _auction;
172     }
173 
174     function removeFromAuction(uint256 _tokenId) external onlyController {
175         address _seller = tokenToAuction[_tokenId].seller;
176         require(_seller != address(0), "token is not on sale");
177         _remove(_seller, _tokenId);
178     }
179 
180     function buyToken(
181         uint256 _tokenId,
182         uint256 _value,
183         uint256 _expectedPrice,
184         bool _expectedIsGold
185     ) external onlyController returns (uint256 price) {
186         Auction memory _auction = tokenToAuction[_tokenId];
187 
188         require(_auction.seller != address(0), "invalid address");
189         require(_auction.isGold == _expectedIsGold, "wrong currency");
190         price = _getCurrentPrice(_tokenId);
191         require(price <= _expectedPrice, "wrong price");
192         require(price <= _value, "not enough ether/gold");
193 
194         _remove(_auction.seller, _tokenId);
195     }
196 
197     function _remove(address _from, uint256 _tokenId) internal {
198         require(allTokens.length > 0, "no auctions");
199 
200         delete tokenToAuction[_tokenId];
201 
202         _removeFrom(_from, _tokenId);
203 
204         uint256 tokenIndex = allTokensIndex[_tokenId];
205         uint256 lastTokenIndex = allTokens.length.sub(1);
206         uint256 lastToken = allTokens[lastTokenIndex];
207 
208         allTokens[tokenIndex] = lastToken;
209         allTokens[lastTokenIndex] = 0;
210 
211         allTokens.length--;
212         allTokensIndex[_tokenId] = 0;
213         allTokensIndex[lastToken] = tokenIndex;
214     }
215 
216     function _removeFrom(address _from, uint256 _tokenId) internal {
217         require(ownedTokens[_from].length > 0, "no seller auctions");
218 
219         uint256 tokenIndex = ownedTokensIndex[_tokenId];
220         uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
221         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
222 
223         ownedTokens[_from][tokenIndex] = lastToken;
224         ownedTokens[_from][lastTokenIndex] = 0;
225 
226         ownedTokens[_from].length--;
227         ownedTokensIndex[_tokenId] = 0;
228         ownedTokensIndex[lastToken] = tokenIndex;
229     }
230 
231     function _getCurrentPrice(uint256 _id) internal view returns (uint256) {
232         Auction memory _auction = tokenToAuction[_id];
233         if (_auction.startPrice == _auction.endPrice) {
234             return _auction.startPrice;
235         }
236         return _calculateCurrentPrice(
237             _auction.startPrice,
238             _auction.endPrice,
239             _auction.period,
240             _auction.created
241         );
242     }
243 
244     function _calculateCurrentPrice(
245         uint256 _startPrice,
246         uint256 _endPrice,
247         uint16 _period,
248         uint256 _created
249     ) internal view returns (uint256) {
250         bool isIncreasingType = _startPrice < _endPrice;
251         uint256 _fullPeriod = uint256(1 hours).mul(_period); // price changing period
252         uint256 _interval = isIncreasingType ? _endPrice.sub(_startPrice) : _startPrice.sub(_endPrice);
253         uint256 _pastTime = now.sub(_created);
254         if (_pastTime >= _fullPeriod) return _endPrice;
255         // how much is _pastTime in percents to period
256         uint256 _percent = MULTIPLIER.sub(_fullPeriod.sub(_pastTime).mul(MULTIPLIER).div(_fullPeriod));
257         uint256 _diff = _interval.mul(_percent).div(MULTIPLIER);
258         return isIncreasingType ? _startPrice.add(_diff) : _startPrice.sub(_diff);
259     }
260 
261     // GETTERS
262 
263     function sellerOf(uint256 _id) external view returns (address) {
264         return tokenToAuction[_id].seller;
265     }
266 
267     function getAuction(uint256 _id) external view returns (
268         address, uint256, uint256, uint256, uint16, uint256, bool
269     ) {
270         Auction memory _auction = tokenToAuction[_id];
271         return (
272             _auction.seller,
273             _getCurrentPrice(_id),
274             _auction.startPrice,
275             _auction.endPrice,
276             _auction.period,
277             _auction.created,
278             _auction.isGold
279         );
280     }
281 
282     function tokensOfOwner(address _owner) external view returns (uint256[]) {
283         return ownedTokens[_owner];
284     }
285 
286     function getAllTokens() external view returns (uint256[]) {
287         return allTokens;
288     }
289 
290     function totalSupply() public view returns (uint256) {
291         return allTokens.length;
292     }
293 }
294 
295 
296 contract DragonMarketplace is Marketplace {}