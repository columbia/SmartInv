1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4 
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   function transferOwnership(address newOwner) onlyOwner public {
12     require(newOwner != address(0));
13     owner = newOwner;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21 }
22 
23 contract DnaMixer {
24     function mixDna(uint256 dna1, uint256 dna2, uint256 seed) public pure returns (uint256);
25 }
26 
27 
28 contract CpData is Ownable {
29 
30     struct Girl {
31         uint256 dna;
32         uint64 creationTime;
33         uint32 sourceGirl1;
34         uint32 sourceGirl2;
35         uint16 gen;
36         uint8 combinesLeft;
37         uint64 combineCooledDown;
38     }
39 
40     struct Auction {
41         address seller;
42         uint128 startingPriceWei;
43         uint128 endingPriceWei;
44         uint64 duration;
45         uint64 creationTime;
46         bool isCombine;
47     }
48 
49     event NewGirl(address owner, uint256 girlId, uint256 sourceGirl1, uint256 sourceGirl2, uint256 dna);
50     event Transfer(address from, address to, uint256 girlId);
51     event AuctionCreated(uint256 girlId, uint256 startingPriceWei, uint256 endingPriceWei, uint256 duration, bool isCombine);
52     event AuctionCompleted(uint256 girlId, uint256 priceWei, address winner);
53     event AuctionCancelled(uint256 girlId);
54 
55     uint256 public constant OWNERS_AUCTION_CUT = 350;
56 
57     uint256 public constant MAX_PROMO_GIRLS = 6000;
58     uint256 public promoCreatedCount;
59     
60     uint256 public constant MAX_GEN0_GIRLS = 30000;
61     uint256 public gen0CreatedCount;
62         
63     DnaMixer public dnaMixer;
64 
65     Girl[] girls;
66 
67     mapping (uint256 => address) public girlIdToOwner;
68     mapping (uint256 => Auction) public girlIdToAuction;
69     
70 }
71 
72 
73 contract CpInternals is CpData {
74 
75     function _transfer(address _from, address _to, uint256 _girlId) internal {
76         girlIdToOwner[_girlId] = _to;        
77         Transfer(_from, _to, _girlId);
78     }
79 
80     function _createGirl(uint256 _sourceGirlId1, uint256 _sourceGirlId2, uint256 _gen, uint256 _dna, address _owner) internal returns (uint) {
81         require(_sourceGirlId1 < girls.length || _sourceGirlId1 == 0);
82         require(_sourceGirlId2 < girls.length || _sourceGirlId2 == 0);
83         require(_gen < 65535);
84 
85         Girl memory _girl = Girl({
86             dna: _dna,
87             sourceGirl1: uint32(_sourceGirlId1),
88             sourceGirl2: uint32(_sourceGirlId2),
89             gen: uint16(_gen),
90             creationTime: uint64(now),
91             combinesLeft: 10,
92             combineCooledDown: 0
93         });
94 
95         uint256 newGirlId = girls.push(_girl) - 1;
96         NewGirl(_owner, newGirlId, _sourceGirlId1, _sourceGirlId2, _girl.dna);
97         _transfer(0, _owner, newGirlId);
98 
99         return newGirlId;
100     }
101 
102      function _combineGirls(Girl storage _sourceGirl1, Girl storage _sourceGirl2, uint256 _girl1Id, uint256 _girl2Id, address _owner) internal returns(uint256) {
103         uint16 maxGen = _sourceGirl1.gen;
104 
105         if (_sourceGirl2.gen > _sourceGirl1.gen) {
106             maxGen = _sourceGirl2.gen;
107         }
108 
109         uint256 seed = block.number + maxGen + block.timestamp;
110         uint256 newDna = dnaMixer.mixDna(_sourceGirl1.dna, _sourceGirl2.dna, seed);
111 
112         _sourceGirl1.combinesLeft -= 1;
113         _sourceGirl2.combinesLeft -= 1;
114         _sourceGirl1.combineCooledDown = uint64(now) + 6 hours;
115         _sourceGirl2.combineCooledDown = uint64(now) + 6 hours;
116 
117         return _createGirl(_girl1Id, _girl2Id, maxGen + 1, newDna, _owner);
118     }
119 
120     function _getAuctionPrice(Auction storage _auction) internal view returns (uint256) {
121         uint256 secondsPassed = 0;
122 
123         if (now > _auction.creationTime) {
124             secondsPassed = now - _auction.creationTime;
125         }
126 
127         uint256 price = _auction.endingPriceWei;
128 
129         if (secondsPassed < _auction.duration) {
130             uint256 priceSpread = _auction.startingPriceWei - _auction.endingPriceWei;
131             uint256 deltaPrice = priceSpread * secondsPassed / _auction.duration;
132             price = _auction.startingPriceWei - deltaPrice;
133         }
134 
135         return price;
136     }
137 
138 }
139 
140 
141 contract CpApis is CpInternals {
142 
143     function getGirl(uint256 _id) external view returns (uint256 dna, uint256 sourceGirlId1, uint256 sourceGirlId2, uint256 gen, uint256 creationTime, uint8 combinesLeft, uint64 combineCooledDown) {
144         Girl storage girl = girls[_id];
145         dna = girl.dna;
146         sourceGirlId1 = girl.sourceGirl1;
147         sourceGirlId2 = girl.sourceGirl2;
148         gen = girl.gen;
149         creationTime = girl.creationTime;
150         combinesLeft = girl.combinesLeft;
151         combineCooledDown = girl.combineCooledDown;
152     }
153 
154     function createPromoGirl(uint256 _dna) external onlyOwner {
155         require(promoCreatedCount < MAX_PROMO_GIRLS);
156 
157         promoCreatedCount++;
158         _createGirl(0, 0, 0, _dna, owner);
159     }
160 
161     function createGen0(uint256 _dna) external onlyOwner {
162         require(gen0CreatedCount < MAX_GEN0_GIRLS);
163 
164         gen0CreatedCount++;
165         _createGirl(0, 0, 0, _dna, owner);
166     }
167 
168     function setDnaMixerAddress(address _address) external onlyOwner {
169         dnaMixer = DnaMixer(_address);
170     }
171     
172     function transfer(address _to, uint256 _girlId) external {
173         require(_to != address(0));
174         require(_to != address(this));
175         require(girlIdToOwner[_girlId] == msg.sender);
176         Auction storage auction = girlIdToAuction[_girlId];
177         require(auction.creationTime == 0);
178         _transfer(msg.sender, _to, _girlId);
179     }
180 
181     function ownerOf(uint256 _girlId) external view returns (address owner) {
182         owner = girlIdToOwner[_girlId];
183         require(owner != address(0));
184     }
185     
186     function createAuction(uint256 _girlId, uint256 _startingPriceWei, uint256 _endingPriceWei, uint256 _duration, bool _isCombine) external {
187         require(_startingPriceWei > _endingPriceWei);
188         require(_startingPriceWei > 0);
189         require(_startingPriceWei == uint256(uint128(_startingPriceWei)));
190         require(_endingPriceWei == uint256(uint128(_endingPriceWei)));
191         require(_duration == uint256(uint64(_duration)));
192         require(girlIdToOwner[_girlId] == msg.sender);
193 
194         if (_isCombine) {
195             Girl storage girl = girls[_girlId];
196             require(girl.combinesLeft > 0);
197             require(girl.combineCooledDown < now);
198         }
199 
200         Auction memory auction = Auction(
201             msg.sender,
202             uint128(_startingPriceWei),
203             uint128(_endingPriceWei),
204             uint64(_duration),
205             uint64(now),
206             _isCombine
207         );
208 
209         girlIdToAuction[_girlId] = auction;
210 
211         AuctionCreated(_girlId, _startingPriceWei, _endingPriceWei, _duration, _isCombine);
212     }
213     
214     function bid(uint256 _girlId, uint256 _myGirl) external payable {
215         Auction storage auction = girlIdToAuction[_girlId];
216 
217         require(auction.startingPriceWei > 0);
218         require(!auction.isCombine || (auction.isCombine && _girlId > 0));
219 
220         uint256 price = _getAuctionPrice(auction);
221         require(msg.value >= price);
222         bool isCombine = auction.isCombine;
223 
224         if (isCombine) {
225             Girl storage sourceGirl1 = girls[_girlId];
226             Girl storage sourceGirl2 = girls[_myGirl];
227     
228             require(sourceGirl1.combinesLeft > 0);
229             require(sourceGirl2.combinesLeft > 0);
230             require(sourceGirl1.combineCooledDown < now);
231             require(sourceGirl2.combineCooledDown < now);
232         }
233 
234         address seller = auction.seller;
235         delete girlIdToAuction[_girlId];
236 
237         if (price > 0) {
238             uint256 cut = price * (OWNERS_AUCTION_CUT / 10000);
239             seller.transfer(price - cut);
240         }
241 
242         msg.sender.transfer(msg.value - price);
243 
244         if (isCombine) {
245             _combineGirls(sourceGirl1, sourceGirl2, _girlId, _myGirl, msg.sender);
246         } else {
247             _transfer(seller, msg.sender, _girlId);
248         }
249 
250         AuctionCompleted(_girlId, price, msg.sender);
251     }
252 
253     function combineMyGirls(uint256 _girlId1, uint256 _girlId2) external payable {
254         require(_girlId1 != _girlId2);
255         require(girlIdToOwner[_girlId1] == msg.sender);
256         require(girlIdToOwner[_girlId2] == msg.sender);
257                         
258         Girl storage sourceGirl1 = girls[_girlId1];
259         Girl storage sourceGirl2 = girls[_girlId2];
260 
261         require(sourceGirl1.combinesLeft > 0);
262         require(sourceGirl2.combinesLeft > 0);
263         require(sourceGirl1.combineCooledDown < now);
264         require(sourceGirl2.combineCooledDown < now);
265 
266         _combineGirls(sourceGirl1, sourceGirl2, _girlId1, _girlId2, msg.sender);
267     }
268 
269     function cancelAuction(uint256 _girlId) external {
270         Auction storage auction = girlIdToAuction[_girlId];
271         require(auction.startingPriceWei > 0);
272 
273         require(msg.sender == auction.seller);
274         delete girlIdToAuction[_girlId];
275         AuctionCancelled(_girlId);
276     }
277     
278     function getAuction(uint256 _girlId) external view returns(address seller, uint256 startingPriceWei, uint256 endingPriceWei, uint256 duration, uint256 startedAt, bool isCombine) {
279         Auction storage auction = girlIdToAuction[_girlId];
280         require(auction.startingPriceWei > 0);
281 
282         return (auction.seller, auction.startingPriceWei, auction.endingPriceWei, auction.duration, auction.creationTime, auction.isCombine);
283     }
284 
285     function getGirlsAuctionPrice(uint256 _girlId) external view returns (uint256) {
286         Auction storage auction = girlIdToAuction[_girlId];
287         require(auction.startingPriceWei > 0);
288 
289         return _getAuctionPrice(auction);
290     }
291 
292     function withdrawBalance() external onlyOwner {
293         owner.transfer(this.balance);
294     }
295 }
296 
297 
298 contract CryptoPussyMain is CpApis {
299 
300     function CryptoPussyMain() public payable {
301         owner = msg.sender;
302         _createGirl(0, 0, 0, uint256(-1), owner);
303     }
304 
305     function() external payable {
306         require(msg.sender == address(0));
307     }
308 }