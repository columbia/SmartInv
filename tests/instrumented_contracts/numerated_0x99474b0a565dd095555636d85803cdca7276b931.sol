1 pragma solidity ^0.4.18;
2 
3 contract AccessControl {
4     address public owner;
5     address[] public admins;
6 
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     modifier onlyAdmins {
13         bool found = false;
14 
15         for (uint i = 0; i < admins.length; i++) {
16             if (admins[i] == msg.sender) {
17                 found = true;
18                 break;
19             }
20         }
21         require(found);
22         _;
23     }
24 
25     function addAdmin(address _adminAddress) public onlyOwner {
26         admins.push(_adminAddress);
27     }
28 
29     function transferOwnership(address newOwner) public onlyOwner {
30         if (newOwner != address(0)) {
31             owner = newOwner;
32         }
33     }
34 
35 }
36 
37 contract ERC721 {
38     // Required Functions
39     function implementsERC721() public pure returns (bool);
40     function totalSupply() public view returns (uint256);
41     function balanceOf(address _owner) public view returns (uint256);
42     function ownerOf(uint256 _tokenId) public view returns (address);
43     function transfer(address _to, uint _tokenId) public;
44     function approve(address _to, uint256 _tokenId) public;
45     function transferFrom(address _from, address _to, uint256 _tokenId) public;
46 
47     // Optional Functions
48     function name() public pure returns (string);
49     function symbol() public pure returns (string);
50     // function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256);
51     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
52 
53     // Required Events
54     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56 }
57 
58 
59 contract CryptoLandmarks is AccessControl, ERC721 {
60     // Event fired for every new landmark created
61     event Creation(uint256 tokenId, string name, address owner);
62 
63     // Event fired whenever landmark is sold
64     event Purchase(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address owner, uint256 charityId);
65 
66     // Event fired when price of landmark changes
67     event PriceChange(uint256 tokenId, uint256 price);
68 
69     // Event fired when charities are modified
70     event Charity(uint256 charityId, address charity);
71 
72     string public constant NAME = "Crypto Landmarks"; 
73     string public constant SYMBOL = "LANDMARK"; 
74 
75     // Initial price of card
76     uint256 private startingPrice = 0.001 ether;
77 
78     // Charities enabled in the future
79     bool charityEnabled;
80 
81     // Landmark card
82     struct Landmark {
83         // unique name of landmark
84         string name;
85 
86         // selling price
87         uint256 price;
88 
89         // maximum price
90         uint256 maxPrice;
91     }
92 
93     Landmark[] public landmarks;
94 
95     address[] public charities;
96     
97     mapping (uint256 => address) public landmarkToOwner;
98     mapping (address => uint256) public landmarkOwnershipCount;
99     mapping (uint256 => address) public landmarkToApproved;
100 
101     function CryptoLandmarks() public {
102         owner = msg.sender;
103         admins.push(msg.sender);
104         charityEnabled = false;
105     }
106 
107     function implementsERC721() public pure returns (bool) {
108         return true;
109     }
110 
111     function totalSupply() public view returns (uint256) {
112         return landmarks.length;
113     }
114 
115     function balanceOf(address _owner) public view returns (uint256 balance) {
116         return landmarkOwnershipCount[_owner];
117     }
118     function ownerOf(uint256 _tokenId) public view returns (address owner) {
119         owner = landmarkToOwner[_tokenId];
120         require(owner != address(0));
121     }
122     function transfer(address _to, uint256 _tokenId) public {
123         require(_to != address(0));
124         require(landmarkToOwner[_tokenId] == msg.sender);
125 
126         _transfer(msg.sender, _to, _tokenId);
127     }
128     function approve(address _to, uint256 _tokenId) public {
129         require(landmarkToOwner[_tokenId] == msg.sender);
130         landmarkToApproved[_tokenId] = _to;
131         Approval(msg.sender, _to, _tokenId);
132     }
133     function transferFrom(address _from, address _to, uint256 _tokenId) public {
134         require(landmarkToApproved[_tokenId] == _to);
135         require(_to != address(0));
136         require(landmarkToOwner[_tokenId] == _from);
137 
138         _transfer(_from, _to, _tokenId);
139     }
140     function name() public pure returns (string) {
141         return NAME;
142     }
143     function symbol() public pure returns (string) {
144         return SYMBOL;
145     }
146 
147     function addCharity(address _charity) public onlyAdmins {
148         require(_charity != address(0));
149 
150         uint256 newCharityId = charities.push(_charity) - 1;
151 
152         // emit charity event
153         Charity(newCharityId, _charity);
154     }
155 
156     function deleteCharity(uint256 _charityId) public onlyAdmins {
157         delete charities[_charityId];
158 
159         // emit charity event
160         Charity(_charityId, address(0));
161     }
162 
163     function getCharity(uint256 _charityId) public view returns (address) {
164         return charities[_charityId];
165     }
166 
167     function createLandmark(string _name, address _owner, uint256 _price) public onlyAdmins {
168         if (_price <= 0) {
169             _price = startingPrice;
170         }
171         
172         Landmark memory _landmark = Landmark({
173             name: _name,
174             price: _price,
175             maxPrice: _price
176         });
177         uint256 newLandmarkId = landmarks.push(_landmark) - 1;
178 
179         Creation(newLandmarkId, _name, _owner);
180 
181         _transfer(address(0), _owner, newLandmarkId);
182 
183 
184     }
185 
186     function getLandmark(uint256 _tokenId) public view returns (
187         string landmarkName,
188         uint256 sellingPrice,
189         uint256 maxPrice,
190         address owner
191     ) {
192         Landmark storage landmark = landmarks[_tokenId];
193         landmarkName = landmark.name;
194         sellingPrice = landmark.price;
195         maxPrice = landmark.maxPrice;
196         owner = landmarkToOwner[_tokenId];
197     }
198 
199     function purchase(uint256 _tokenId, uint256 _charityId) public payable {
200         // seller
201         address oldOwner = landmarkToOwner[_tokenId];
202         // current price
203         uint sellingPrice = landmarks[_tokenId].price;
204         // buyer
205         address newOwner = msg.sender;
206         
207         
208         require(oldOwner != newOwner);
209         require(newOwner != address(0));
210         require(msg.value >= sellingPrice);
211 
212         uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 95), 100));
213         uint256 excess = SafeMath.sub(msg.value, sellingPrice);
214 
215         if (charityEnabled == true) {
216             
217             // address of choosen charity
218             address charity = charities[_charityId];
219 
220             // check if charity address is not null
221             require(charity != address(0));
222             
223             // 1% of selling price
224             uint256 donate = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 1), 100));
225 
226             // transfer money to charity
227             charity.transfer(donate);
228             
229         }
230 
231         uint priceIncrease = 120;
232 
233         // price doubles below 32 finney
234         if (sellingPrice <= 32 finney) {
235             priceIncrease = 200;
236         }
237 
238         // set new price
239         landmarks[_tokenId].price = SafeMath.div(SafeMath.mul(sellingPrice, priceIncrease), 95);
240         
241         // set maximum price
242         landmarks[_tokenId].maxPrice = SafeMath.div(SafeMath.mul(sellingPrice, priceIncrease), 95);
243 
244         // transfer card to buyer
245         _transfer(oldOwner, newOwner, _tokenId);
246 
247         // transfer money to seller
248         if (oldOwner != address(this)) {
249             oldOwner.transfer(payment);
250         }
251 
252         // emit event that landamrk was sold;
253         Purchase(_tokenId, sellingPrice, landmarks[_tokenId].price, oldOwner, newOwner, _charityId);
254         
255 
256         // transfer excess back to buyer
257         newOwner.transfer(excess);
258     }
259 
260     // owner can change price
261     function changePrice(uint256 _tokenId, uint256 _price) public {
262         // only owner can change price
263         require(landmarkToOwner[_tokenId] == msg.sender);
264 
265         // price cannot be higher than maximum price
266         require(landmarks[_tokenId].maxPrice >= _price);
267 
268         // set new price
269         landmarks[_tokenId].price = _price;
270         
271         // emit event
272         PriceChange(_tokenId, _price);
273     }
274 
275     function priceOfLandmark(uint256 _tokenId) public view returns (uint256) {
276         return landmarks[_tokenId].price;
277     }
278 
279     function tokensOfOwner(address _owner) public view returns(uint256[]) {
280         uint256 tokenCount = balanceOf(_owner);
281 
282         uint256[] memory result = new uint256[](tokenCount);
283         uint256 total = totalSupply();
284         uint256 resultIndex = 0;
285 
286         for(uint256 i = 0; i <= total; i++) {
287             if (landmarkToOwner[i] == _owner) {
288                 result[resultIndex] = i;
289                 resultIndex++;
290             }
291         }
292         return result;
293     }
294 
295 
296     function _transfer(address _from, address _to, uint256 _tokenId) private {
297         landmarkOwnershipCount[_to]++;
298         landmarkToOwner[_tokenId] = _to;
299 
300         if (_from != address(0)) {
301             landmarkOwnershipCount[_from]--;
302             delete landmarkToApproved[_tokenId];
303         }
304         Transfer(_from, _to, _tokenId);
305     }
306 
307     function enableCharity() external onlyOwner {
308         require(!charityEnabled);
309         charityEnabled = true;
310     }
311 
312     function disableCharity() external onlyOwner {
313         require(charityEnabled);
314         charityEnabled = false;
315     }
316 
317     function withdrawBalance() external onlyOwner {
318         owner.transfer(this.balance);
319     }
320 
321 }
322 
323 
324 /**
325  * @title SafeMath
326  * @dev Math operations with safety checks that throw on error
327  */
328 library SafeMath {
329 
330   /**
331   * @dev Multiplies two numbers, throws on overflow.
332   */
333   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
334     if (a == 0) {
335       return 0;
336     }
337     uint256 c = a * b;
338     assert(c / a == b);
339     return c;
340   }
341 
342   /**
343   * @dev Integer division of two numbers, truncating the quotient.
344   */
345   function div(uint256 a, uint256 b) internal pure returns (uint256) {
346     // assert(b > 0); // Solidity automatically throws when dividing by 0
347     uint256 c = a / b;
348     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
349     return c;
350   }
351 
352   /**
353   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
354   */
355   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356     assert(b <= a);
357     return a - b;
358   }
359 
360   /**
361   * @dev Adds two numbers, throws on overflow.
362   */
363   function add(uint256 a, uint256 b) internal pure returns (uint256) {
364     uint256 c = a + b;
365     assert(c >= a);
366     return c;
367   }
368 }