1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract ERC721 {
4   function approve(address _to, uint256 _tokenId) public;
5   function balanceOf(address _owner) public view returns (uint256 balance);
6   function implementsERC721() public pure returns (bool);
7   function ownerOf(uint256 _tokenId) public view returns (address addr);
8   function takeOwnership(uint256 _tokenId) public;
9   function totalSupply() public view returns (uint256 total);
10   function transferFrom(address _from, address _to, uint256 _tokenId) public;
11   function transfer(address _to, uint256 _tokenId) public;
12 
13   event Transfer(address indexed from, address indexed to, uint256 tokenId);
14   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
15 }
16 
17 
18 contract CryptoRides is ERC721 {
19   event Created(uint256 tokenId, string name, bytes7 plateNumber, address owner);
20   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name, bytes7 plateNumber);
21   event Transfer(address from, address to, uint256 tokenId);
22 
23   string public constant NAME = "CryptoRides"; // solhint-disable-line
24   string public constant SYMBOL = "CryptoRidesToken"; // solhint-disable-line
25   uint256 private startingPrice = 0.001 ether;
26   uint256 private constant PROMO_CREATION_LIMIT = 5000;
27   uint256 private firstStepLimit =  0.053613 ether;
28   uint256 private secondStepLimit = 0.564957 ether;
29 
30   mapping (uint256 => address) public tokenIdToOwner;
31   mapping (address => uint256) private ownershipTokenCount;
32   mapping (uint256 => address) public tokenIdToApproved;
33   mapping (uint256 => uint256) private tokenIdToPrice;
34 
35   address public ceoAddress;
36   address public cooAddress;
37 
38   uint256 public promoCreatedCount;
39 
40   struct Ride {
41     string name;
42     bytes7 plateNumber;
43   }
44   Ride[] private rides;
45 
46   modifier onlyCEO() {
47     require(msg.sender == ceoAddress);
48     _;
49   }
50 
51   modifier onlyCOO() {
52     require(msg.sender == cooAddress);
53     _;
54   }
55 
56   modifier onlyCLevel() {
57     require(
58       msg.sender == ceoAddress ||
59       msg.sender == cooAddress
60     );
61     _;
62   }
63 
64   function CryptoRides() public {
65     ceoAddress = msg.sender;
66     cooAddress = msg.sender;
67   }
68 
69   function approve( address _to, uint256 _tokenId) public {
70     // Caller must own token.
71     require(_owns(msg.sender, _tokenId));
72 
73     tokenIdToApproved[_tokenId] = _to;
74 
75     Approval(msg.sender, _to, _tokenId);
76   }
77 
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return ownershipTokenCount[_owner];
80   }
81 
82   function createPromoRide(address _owner, string _name, bytes7 _plateNo, uint256 _price) public onlyCOO {
83     require(promoCreatedCount < PROMO_CREATION_LIMIT);
84 
85     address rideOwner = _owner;
86     if (rideOwner == address(0)) {
87       rideOwner = cooAddress;
88     }
89 
90     if (_price <= 0) {
91       _price = startingPrice;
92     }
93 
94     promoCreatedCount++;
95     _createRide(_name, _plateNo, rideOwner, _price);
96   }
97 
98   function createContractRide(string _name, bytes7 _plateNo) public onlyCOO {
99     _createRide(_name, _plateNo, address(this), startingPrice);
100   }
101 
102   function getRide(uint256 _tokenId) public view returns (
103     string rideName,
104     bytes7 plateNumber,
105     uint256 sellingPrice,
106     address owner
107   ) {
108     Ride storage ride = rides[_tokenId];
109     rideName = ride.name;
110     plateNumber = ride.plateNumber;
111     sellingPrice = tokenIdToPrice[_tokenId];
112     owner = tokenIdToOwner[_tokenId];
113   }
114 
115   function implementsERC721() public pure returns (bool) {
116     return true;
117   }
118 
119   function name() public pure returns (string) {
120     return NAME;
121   }
122 
123   function ownerOf(uint256 _tokenId)
124     public
125     view
126     returns (address owner)
127   {
128     owner = tokenIdToOwner[_tokenId];
129     require(owner != address(0));
130   }
131 
132   function payout(address _to) public onlyCLevel {
133     _payout(_to);
134   }
135 
136   function purchase(uint256 _tokenId, bytes7 _plateNumber) public payable {
137     address oldOwner = tokenIdToOwner[_tokenId];
138     address newOwner = msg.sender;
139 
140     uint256 sellingPrice = tokenIdToPrice[_tokenId];
141 
142     require(oldOwner != newOwner);
143 
144     require(_addressNotNull(newOwner));
145 
146     require(msg.value >= sellingPrice);
147 
148     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 92), 100));
149     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
150 
151     // Update prices
152     if (sellingPrice < firstStepLimit) {
153       // first stage
154       tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 92);
155     } else if (sellingPrice < secondStepLimit) {
156       // second stage
157       tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 120), 92);
158     } else {
159       // third stage
160       tokenIdToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), 92);
161     }
162 
163     _transfer(oldOwner, newOwner, _tokenId);
164 
165     // Pay previous tokenOwner if owner is not contract
166     if (oldOwner != address(this)) {
167       oldOwner.transfer(payment); //(1-0.08)
168     }
169 
170     TokenSold(_tokenId, sellingPrice, tokenIdToPrice[_tokenId], oldOwner, newOwner, rides[_tokenId].name, _plateNumber);
171 
172     msg.sender.transfer(purchaseExcess);
173     rides[_tokenId].plateNumber = _plateNumber;
174   }
175 
176   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
177     return tokenIdToPrice[_tokenId];
178   }
179 
180   function setCEO(address _newCEO) public onlyCEO {
181     require(_newCEO != address(0));
182 
183     ceoAddress = _newCEO;
184   }
185 
186   function setCOO(address _newCOO) public onlyCEO {
187     require(_newCOO != address(0));
188 
189     cooAddress = _newCOO;
190   }
191 
192   function symbol() public pure returns (string) {
193     return SYMBOL;
194   }
195 
196   function takeOwnership(uint256 _tokenId) public {
197     address newOwner = msg.sender;
198     address oldOwner = tokenIdToOwner[_tokenId];
199 
200     // Safety check to prevent against an unexpected 0x0 default.
201     require(_addressNotNull(newOwner));
202 
203     // Making sure transfer is approved
204     require(_approved(newOwner, _tokenId));
205 
206     _transfer(oldOwner, newOwner, _tokenId);
207   }
208 
209   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
210     uint256 tokenCount = balanceOf(_owner);
211     if (tokenCount == 0) {
212         // Return an empty array
213       return new uint256[](0);
214     } else {
215       uint256[] memory result = new uint256[](tokenCount);
216       uint256 totalRides = totalSupply();
217       uint256 resultIndex = 0;
218 
219       uint256 rideId;
220       for (rideId = 0; rideId <= totalRides; rideId++) {
221         if (tokenIdToOwner[rideId] == _owner) {
222           result[resultIndex] = rideId;
223           resultIndex++;
224         }
225       }
226       return result;
227     }
228   }
229 
230   function totalSupply() public view returns (uint256 total) {
231     return rides.length;
232   }
233 
234   function transfer( address _to, uint256 _tokenId) public {
235     require(_owns(msg.sender, _tokenId));
236     require(_addressNotNull(_to));
237 
238     _transfer(msg.sender, _to, _tokenId);
239   }
240 
241   function transferFrom(address _from, address _to, uint256 _tokenId) public {
242     require(_owns(_from, _tokenId));
243     require(_approved(_to, _tokenId));
244     require(_addressNotNull(_to));
245 
246     _transfer(_from, _to, _tokenId);
247   }
248 
249   function _addressNotNull(address _to) private pure returns (bool) {
250     return _to != address(0);
251   }
252 
253   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
254     return tokenIdToApproved[_tokenId] == _to;
255   }
256 
257   function _createRide(string _name, bytes7 _plateNo, address _owner, uint256 _price) private {
258     Ride memory _ride = Ride({
259       name: _name, 
260       plateNumber: _plateNo
261     });
262     uint256 newRideId = rides.push(_ride) - 1;
263 
264     require(newRideId == uint256(uint32(newRideId)));
265 
266     Created(newRideId, _name, _plateNo, _owner);
267 
268     tokenIdToPrice[newRideId] = _price;
269 
270     _transfer(address(0), _owner, newRideId);
271   }
272 
273   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
274     return claimant == tokenIdToOwner[_tokenId];
275   }
276 
277   function _payout(address _to) private {
278     if (_to == address(0)) {
279       ceoAddress.transfer(this.balance);
280     } else {
281       _to.transfer(this.balance);
282     }
283   }
284 
285   function _transfer(address _from, address _to, uint256 _tokenId) private {
286     // Since the number of rides is capped to 2^32 we can't overflow this
287     ownershipTokenCount[_to]++;
288     //transfer ownership
289     tokenIdToOwner[_tokenId] = _to;
290 
291     // When creating new rides _from is 0x0, but we can't account that address.
292     if (_from != address(0)) {
293       ownershipTokenCount[_from]--;
294       // clear any previously approved ownership exchange
295       delete tokenIdToApproved[_tokenId];
296     }
297 
298     // Emit the transfer event.
299     Transfer(_from, _to, _tokenId);
300   }
301 }
302 library SafeMath {
303   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304     if (a == 0) {
305       return 0;
306     }
307     uint256 c = a * b;
308     assert(c / a == b);
309     return c;
310   }
311   function div(uint256 a, uint256 b) internal pure returns (uint256) {
312     // assert(b > 0); // Solidity automatically throws when dividing by 0
313     uint256 c = a / b;
314     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
315     return c;
316   }
317   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318     assert(b <= a);
319     return a - b;
320   }
321   function add(uint256 a, uint256 b) internal pure returns (uint256) {
322     uint256 c = a + b;
323     assert(c >= a);
324     return c;
325   }
326 }