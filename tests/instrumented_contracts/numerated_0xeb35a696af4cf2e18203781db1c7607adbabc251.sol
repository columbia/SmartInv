1 pragma solidity ^0.4.18;
2 
3 contract CryptoLandmarks {
4     using SafeMath for uint256;
5 
6     // ERC721 required events
7     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
8     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
9 
10     // Event fired whenever landmark is sold
11     event LandmarkSold(uint256 tokenId, uint256 price, uint256 nextPrice, address prevOwner, address owner);
12     
13     // Event fired when price of landmark changes
14     event PriceChanged(uint256 tokenId, uint256 price);
15 
16     // Event fired for every new landmark created
17     event LandmarkCreated(uint256 tokenId, uint256 groupId, uint256 price, address owner);
18 
19    
20     string public constant NAME = "CryptoLandmarks.co Landmarks"; 
21     string public constant SYMBOL = "LANDMARK"; 
22 
23     // Initial price of new Landmark
24     uint256 private startingPrice = 0.03 ether;
25     // Initial price of new Ambassador
26     uint256 private ambassadorStartingPrice = 3 ether;
27 
28     // count transactions after every withdrawal
29     uint256 public transactions = 0;
30 
31     // Contract roles
32     address public ceo;
33     address public coo;
34 
35     uint256[] private landmarks;
36     
37     // landmark to prices
38     mapping (uint256 => uint256) landmarkToMaxPrice;
39     mapping (uint256 => uint256) landmarkToPrice;
40     
41     // landmark to owner
42     mapping (uint256 => address) landmarkToOwner;
43     
44     // landmark to ambassador id
45     // ambassador is also landmark token
46     // every ambassador belongs to self
47     mapping (uint256 => uint256) landmarkToAmbassador;
48     
49     // ambassadors's landmarks count
50     mapping (uint256 => uint256) groupLandmarksCount;
51 
52     // withdraw cooldown date of landmark owner
53     mapping (address => uint256) public withdrawCooldown;
54 
55     mapping (uint256 => address) landmarkToApproved;
56     mapping (address => uint256) landmarkOwnershipCount;
57 
58 
59     function CryptoLandmarks() public {
60         ceo = msg.sender;
61         coo = msg.sender;
62     }
63 
64     function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
65         if (_price < 0.2 ether)
66             return _price.mul(2); // 200%
67         if (_price < 4 ether)
68             return _price.mul(17).div(10); // 170%
69         if (_price < 15 ether)
70             return _price.mul(141).div(100); // 141%
71         else
72             return _price.mul(134).div(100); // 134%
73     }
74 
75     function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
76         if (_price < 0.2 ether)
77             return 5; // 5%
78         if (_price < 4 ether)
79             return 4; // 4%
80         if (_price < 15 ether)
81             return 3; // 3%
82         else
83             return 2; // 2%
84     }   
85 
86     /*
87         Buy Landmark or Ambassador from contract for calculated price that ensures that:
88          - previous owner gets a profit
89          - specific Ambassador gets his/her fee
90          - every owner of Landmark in an Ambassador group gets a cut
91         All funds are sent directly to players and are never stored in the contract.
92 
93         Ambassador -> _tokenId < 1000
94         Landmark -> _tokenId >= 1000
95 
96     */
97     function buy(uint256 _tokenId) public payable {
98         address oldOwner = landmarkToOwner[_tokenId];
99         require(oldOwner != msg.sender);
100         require(msg.sender != address(0));
101         uint256 sellingPrice = priceOfLandmark(_tokenId);
102         require(msg.value >= sellingPrice);
103 
104         // excess that will be refunded
105         uint256 excess = msg.value.sub(sellingPrice);
106 
107         // id of a group = ambassador id
108         uint256 groupId = landmarkToAmbassador[_tokenId];
109 
110         // number of Landmarks in the group
111         uint256 groupMembersCount = groupLandmarksCount[groupId];
112 
113         // developer's cut in % (2-5)
114         uint256 devCut = calculateDevCut(sellingPrice);
115 
116         // for previous owner
117         uint256 payment;
118         
119         if (_tokenId < 1000) {
120             // Buying Ambassador
121             payment = sellingPrice.mul(SafeMath.sub(95, devCut)).div(100);
122         } else {
123             // Buying Landmark
124             payment = sellingPrice.mul(SafeMath.sub(90, devCut)).div(100);
125         }
126 
127         // 5% splitted per all group memebrs
128         uint256 feeGroupMember = (sellingPrice.mul(5).div(100)).div(groupMembersCount);
129 
130 
131         for (uint i = 0; i < totalSupply(); i++) {
132             uint id = landmarks[i];
133             if ( landmarkToAmbassador[id] == groupId ) {
134                 if ( _tokenId == id) {
135                     // Transfer payment to previous owner
136                     oldOwner.transfer(payment);
137                 }
138                 if (groupId == id && _tokenId >= 1000) {
139                     // Transfer 5% to Ambassador
140                     landmarkToOwner[id].transfer(sellingPrice.mul(5).div(100));
141                 }
142 
143                 // Transfer cut to every member of a group
144                 // since ambassador and old owner are also members they get a cut again too
145                 landmarkToOwner[id].transfer(feeGroupMember);
146             }
147         }
148         
149         uint256 nextPrice = calculateNextPrice(sellingPrice);
150 
151         // Set new price
152         landmarkToPrice[_tokenId] = nextPrice;
153 
154         // Set new maximum price
155         landmarkToMaxPrice[_tokenId] = nextPrice;
156 
157         // Transfer token
158         _transfer(oldOwner, msg.sender, _tokenId);
159 
160         // if overpaid, transfer excess back to sender
161         if (excess > 0) {
162             msg.sender.transfer(excess);
163         }
164 
165         // increment transactions counter
166         transactions++;
167 
168         // emit event
169         LandmarkSold(_tokenId, sellingPrice, nextPrice, oldOwner, msg.sender);
170     }
171 
172 
173     // owner can change price
174     function changePrice(uint256 _tokenId, uint256 _price) public {
175         // only owner can change price
176         require(landmarkToOwner[_tokenId] == msg.sender);
177 
178         // price cannot be higher than maximum price
179         require(landmarkToMaxPrice[_tokenId] >= _price);
180 
181         // set new price
182         landmarkToPrice[_tokenId] = _price;
183         
184         // emit event
185         PriceChanged(_tokenId, _price);
186     }
187 
188     function createLandmark(uint256 _tokenId, uint256 _groupId, address _owner, uint256 _price) public onlyCOO {
189         // token with id below 1000 is a Ambassador
190         if (_price <= 0 && _tokenId >= 1000) {
191             _price = startingPrice;
192         } else if (_price <= 0 && _tokenId < 1000) {
193             _price = ambassadorStartingPrice;
194         }
195         if (_owner == address(0)) {
196             _owner = coo;
197         }
198 
199         if (_tokenId < 1000) {
200             _groupId == _tokenId;
201         }
202 
203         landmarkToPrice[_tokenId] = _price;
204         landmarkToMaxPrice[_tokenId] = _price;
205         landmarkToAmbassador[_tokenId] = _groupId;
206         groupLandmarksCount[_groupId]++;
207         _transfer(address(0), _owner, _tokenId);
208 
209         landmarks.push(_tokenId);
210 
211         LandmarkCreated(_tokenId, _groupId, _price, _owner);
212     }
213 
214     function getLandmark(uint256 _tokenId) public view returns (
215         uint256 ambassadorId,
216         uint256 sellingPrice,
217         uint256 maxPrice,
218         uint256 nextPrice,
219         address owner
220     ) {
221         ambassadorId = landmarkToAmbassador[_tokenId];
222         sellingPrice = landmarkToPrice[_tokenId];
223         maxPrice = landmarkToMaxPrice[_tokenId];
224         nextPrice = calculateNextPrice(sellingPrice);
225         owner = landmarkToOwner[_tokenId];
226     }
227 
228     function priceOfLandmark(uint256 _tokenId) public view returns (uint256) {
229         return landmarkToPrice[_tokenId];
230     }
231 
232 
233     modifier onlyCEO() {
234         require(msg.sender == ceo);
235         _;
236     }
237     modifier onlyCOO() {
238         require(msg.sender == coo);
239         _;
240     }
241     modifier onlyCLevel() {
242         require(
243             msg.sender == ceo ||
244             msg.sender == coo
245         );
246         _;
247     }
248     modifier notCLevel() {
249         require(
250             msg.sender != ceo ||
251             msg.sender != coo
252         );
253         _;
254     }
255 
256     /*
257         Transfer 0.3% per token to sender
258         This function can be invoked by anyone who:
259          - has at least 3 tokens
260          - waited at least 1 week from previous withdrawal
261          - is not a ceo/coo
262         Additionally it can be invoked only:
263          - when total balance is greater than 1 eth
264          - after 10 transactions from previous withdrawal
265 
266 
267     */
268     function withdrawBalance() external notCLevel {
269         // only person owning more than 3 tokens can whitdraw
270         require(landmarkOwnershipCount[msg.sender] >= 3);
271         
272         // player can withdraw only week after his previous withdrawal
273         require(withdrawCooldown[msg.sender] <= now);
274 
275         // can be invoked after any 10 purchases from previous withdrawal
276         require(transactions >= 10);
277 
278         uint256 balance = this.balance;
279 
280         // balance must be greater than 0.3 ether
281         require(balance >= 0.3 ether);
282 
283         uint256 senderCut = balance.mul(3).div(1000).mul(landmarkOwnershipCount[msg.sender]);
284         
285         // transfer 0.3% per Landmark or Ambassador to sender
286         msg.sender.transfer(senderCut);
287 
288         // set sender withdraw cooldown
289         withdrawCooldown[msg.sender] = now + 1 weeks;
290 
291         // transfer rest to CEO 
292         ceo.transfer(balance.sub(senderCut));
293 
294         // set transactions counter to 0
295         transactions = 0;
296 
297     }
298 
299     function transferOwnership(address newOwner) public onlyCEO {
300         if (newOwner != address(0)) {
301             ceo = newOwner;
302         }
303     }
304 
305     function setCOO(address newCOO) public onlyCOO {
306         if (newCOO != address(0)) {
307             coo = newCOO;
308         }
309     }
310 
311     function _transfer(address _from, address _to, uint256 _tokenId) private {
312         landmarkOwnershipCount[_to]++;
313         landmarkToOwner[_tokenId] = _to;
314 
315         if (_from != address(0)) {
316             landmarkOwnershipCount[_from]--;
317             delete landmarkToApproved[_tokenId];
318         }
319         Transfer(_from, _to, _tokenId);
320     }
321 
322     //ERC721 methods
323     function implementsERC721() public pure returns (bool) {
324         return true;
325     }
326 
327     function totalSupply() public view returns (uint256) {
328         return landmarks.length;
329     }
330 
331     function name() public pure returns (string) {
332         return NAME;
333     }
334 
335     function symbol() public pure returns (string) {
336         return SYMBOL;
337     }
338 
339     function balanceOf(address _owner) public view returns (uint256 balance) {
340         return landmarkOwnershipCount[_owner];
341     }
342 
343     function ownerOf(uint256 _tokenId) public view returns (address owner) {
344         owner = landmarkToOwner[_tokenId];
345         require(owner != address(0));
346     }
347     function transfer(address _to, uint256 _tokenId) public {
348         require(_to != address(0));
349         require(landmarkToOwner[_tokenId] == msg.sender);
350 
351         _transfer(msg.sender, _to, _tokenId);
352     }
353     function approve(address _to, uint256 _tokenId) public {
354         require(landmarkToOwner[_tokenId] == msg.sender);
355         landmarkToApproved[_tokenId] = _to;
356         Approval(msg.sender, _to, _tokenId);
357     }
358     function transferFrom(address _from, address _to, uint256 _tokenId) public {
359         require(landmarkToApproved[_tokenId] == _to);
360         require(_to != address(0));
361         require(landmarkToOwner[_tokenId] == _from);
362 
363         _transfer(_from, _to, _tokenId);
364     }
365 
366     function tokensOfOwner(address _owner) public view returns(uint256[]) {
367         uint256 tokenCount = balanceOf(_owner);
368 
369         uint256[] memory result = new uint256[](tokenCount);
370         uint256 total = totalSupply();
371         uint256 resultIndex = 0;
372 
373         for(uint256 i = 0; i <= total; i++) {
374             if (landmarkToOwner[i] == _owner) {
375                 result[resultIndex] = i;
376                 resultIndex++;
377             }
378         }
379         return result;
380     }
381 
382 }
383 
384 
385 
386 /**
387  * @title SafeMath
388  * @dev Math operations with safety checks that throw on error
389  */
390 library SafeMath {
391 
392   /**
393   * @dev Multiplies two numbers, throws on overflow.
394   */
395   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
396     if (a == 0) {
397       return 0;
398     }
399     uint256 c = a * b;
400     assert(c / a == b);
401     return c;
402   }
403 
404   /**
405   * @dev Integer division of two numbers, truncating the quotient.
406   */
407   function div(uint256 a, uint256 b) internal pure returns (uint256) {
408     // assert(b > 0); // Solidity automatically throws when dividing by 0
409     uint256 c = a / b;
410     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
411     return c;
412   }
413 
414   /**
415   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
416   */
417   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
418     assert(b <= a);
419     return a - b;
420   }
421 
422   /**
423   * @dev Adds two numbers, throws on overflow.
424   */
425   function add(uint256 a, uint256 b) internal pure returns (uint256) {
426     uint256 c = a + b;
427     assert(c >= a);
428     return c;
429   }
430 }