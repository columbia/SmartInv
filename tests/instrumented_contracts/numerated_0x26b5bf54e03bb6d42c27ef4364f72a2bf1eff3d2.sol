1 pragma solidity ^0.4.19;
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
50 
51     // Required Events
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
54 }
55 
56 
57 contract CryptoBeauty is AccessControl, ERC721 {
58     // Event fired for every new beauty created
59     event Creation(uint256 tokenId, string name, address owner);
60 
61     // Event fired whenever beauty is sold
62     event Purchase(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address owner, uint256 charityId);
63 
64     // Event fired when price of beauty changes
65     event PriceChange(uint256 tokenId, uint256 price);
66 
67     // Event fired when charities are modified
68     event Charity(uint256 charityId, address charity);
69 
70     string public constant NAME = "Crypto Beauty"; 
71     string public constant SYMBOL = "BEAUTY"; 
72 
73     // Initial price of card
74     uint256 private startingPrice = 0.005 ether;
75     uint256 private increaseLimit1 = 0.5 ether;
76     uint256 private increaseLimit2 = 50.0  ether;
77     uint256 private increaseLimit3 = 100.0  ether;
78 
79     // Charities enabled in the future
80     bool charityEnabled;
81 
82     // Beauty card
83     struct Beauty {
84         // unique name of beauty
85         string name;
86 
87         // selling price
88         uint256 price;
89 
90         // maximum price
91         uint256 maxPrice;
92     }
93 
94     Beauty[] public beauties;
95 
96     address[] public charities;
97     
98     mapping (uint256 => address) public beautyToOwner;
99     mapping (address => uint256) public beautyOwnershipCount;
100     mapping (uint256 => address) public beautyToApproved;
101 
102     function CryptoBeauty() public {
103         owner = msg.sender;
104         admins.push(msg.sender);
105         charityEnabled = false;
106     }
107 
108     function implementsERC721() public pure returns (bool) {
109         return true;
110     }
111 
112     function totalSupply() public view returns (uint256) {
113         return beauties.length;
114     }
115 
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return beautyOwnershipCount[_owner];
118     }
119     function ownerOf(uint256 _tokenId) public view returns (address owner) {
120         owner = beautyToOwner[_tokenId];
121         require(owner != address(0));
122     }
123 
124     function transfer(address _to, uint256 _tokenId) public {
125         require(_to != address(0));
126         require(beautyToOwner[_tokenId] == msg.sender);
127 
128         _transfer(msg.sender, _to, _tokenId);
129     }
130     function approve(address _to, uint256 _tokenId) public {
131         require(beautyToOwner[_tokenId] == msg.sender);
132         beautyToApproved[_tokenId] = _to;
133         Approval(msg.sender, _to, _tokenId);
134     }
135     function transferFrom(address _from, address _to, uint256 _tokenId) public {
136         require(beautyToApproved[_tokenId] == _to);
137         require(_to != address(0));
138         require(beautyToOwner[_tokenId] == _from);
139 
140         _transfer(_from, _to, _tokenId);
141     }
142     function name() public pure returns (string) {
143         return NAME;
144     }
145     function symbol() public pure returns (string) {
146         return SYMBOL;
147     }
148 
149     function addCharity(address _charity) public onlyAdmins {
150         require(_charity != address(0));
151 
152         uint256 newCharityId = charities.push(_charity) - 1;
153 
154         // emit charity event
155         Charity(newCharityId, _charity);
156     }
157 
158     function deleteCharity(uint256 _charityId) public onlyAdmins {
159         delete charities[_charityId];
160 
161         // emit charity event
162         Charity(_charityId, address(0));
163     }
164 
165     function getCharity(uint256 _charityId) public view returns (address) {
166         return charities[_charityId];
167     }
168 
169     function createBeauty(string _name, address _owner, uint256 _price) public onlyAdmins {
170         if (_price <= 0.005 ether) {
171             _price = startingPrice;
172         }
173         
174         Beauty memory _beauty = Beauty({
175             name: _name,
176             price: _price,
177             maxPrice: _price
178         });
179         uint256 newBeautyId = beauties.push(_beauty) - 1;
180 
181         Creation(newBeautyId, _name, _owner);
182 
183         _transfer(address(0), _owner, newBeautyId);
184 
185 
186     }
187     
188     function newBeauty(string _name, uint256 _price) public onlyAdmins {
189         createBeauty(_name, msg.sender, _price);
190     }
191 
192     function getBeauty(uint256 _tokenId) public view returns (
193         string beautyName,
194         uint256 sellingPrice,
195         uint256 maxPrice,
196         address owner
197     ) {
198         Beauty storage beauty = beauties[_tokenId];
199         beautyName = beauty.name;
200         sellingPrice = beauty.price;
201         maxPrice = beauty.maxPrice;
202         owner = beautyToOwner[_tokenId];
203     }
204 
205 
206     function purchase(uint256 _tokenId, uint256 _charityId) public payable {
207         // seller
208         address oldOwner = beautyToOwner[_tokenId];
209         // current price
210         uint sellingPrice = beauties[_tokenId].price;
211         // buyer
212         address newOwner = msg.sender;
213         
214         require(oldOwner != newOwner);
215         require(newOwner != address(0));
216         require(msg.value >= sellingPrice);
217         
218         uint256 devCut;
219         uint256 nextPrice;
220 
221         if (sellingPrice < increaseLimit1) {
222           devCut = SafeMath.div(SafeMath.mul(sellingPrice, 5), 100); // 5%
223           nextPrice = SafeMath.div(SafeMath.mul(sellingPrice, 200), 95);
224         } else if (sellingPrice < increaseLimit2) {
225           devCut = SafeMath.div(SafeMath.mul(sellingPrice, 4), 100); // 4%
226           nextPrice = SafeMath.div(SafeMath.mul(sellingPrice, 135), 96);
227         } else if (sellingPrice < increaseLimit3) {
228           devCut = SafeMath.div(SafeMath.mul(sellingPrice, 3), 100); // 3%
229           nextPrice = SafeMath.div(SafeMath.mul(sellingPrice, 125), 97);
230         } else {
231           devCut = SafeMath.div(SafeMath.mul(sellingPrice, 2), 100); // 2%
232           nextPrice = SafeMath.div(SafeMath.mul(sellingPrice, 115), 98);
233         }
234 
235         uint256 excess = SafeMath.sub(msg.value, sellingPrice);
236 
237         if (charityEnabled == true) {
238             
239             // address of choosen charity
240             address charity = charities[_charityId];
241 
242             // check if charity address is not null
243             require(charity != address(0));
244             
245             // 1% of selling price
246             uint256 donate = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 1), 100));
247 
248             // transfer money to charity
249             charity.transfer(donate);
250             
251         }
252 
253         // set new price
254         beauties[_tokenId].price = nextPrice;
255         
256         // set maximum price
257         beauties[_tokenId].maxPrice = nextPrice;
258 
259         // transfer card to buyer
260         _transfer(oldOwner, newOwner, _tokenId);
261 
262         // transfer money to seller
263         if (oldOwner != address(this)) {
264             oldOwner.transfer(SafeMath.sub(sellingPrice, devCut));
265         }
266 
267         // emit event that beauty was sold;
268         Purchase(_tokenId, sellingPrice, beauties[_tokenId].price, oldOwner, newOwner, _charityId);
269         
270         // transfer excess back to buyer
271         if (excess > 0) {
272             newOwner.transfer(excess);
273         }  
274     }
275 
276     // owner can change price
277     function changePrice(uint256 _tokenId, uint256 _price) public {
278         // only owner can change price
279         require(beautyToOwner[_tokenId] == msg.sender);
280 
281         // price cannot be higher than maximum price
282         require(beauties[_tokenId].maxPrice >= _price);
283 
284         // set new price
285         beauties[_tokenId].price = _price;
286         
287         // emit event
288         PriceChange(_tokenId, _price);
289     }
290 
291     function priceOfBeauty(uint256 _tokenId) public view returns (uint256) {
292         return beauties[_tokenId].price;
293     }
294 
295     function tokensOfOwner(address _owner) public view returns(uint256[]) {
296         uint256 tokenCount = balanceOf(_owner);
297 
298         uint256[] memory result = new uint256[](tokenCount);
299         uint256 total = totalSupply();
300         uint256 resultIndex = 0;
301 
302         for(uint256 i = 0; i <= total; i++) {
303             if (beautyToOwner[i] == _owner) {
304                 result[resultIndex] = i;
305                 resultIndex++;
306             }
307         }
308         return result;
309     }
310 
311 
312     function _transfer(address _from, address _to, uint256 _tokenId) private {
313         beautyOwnershipCount[_to]++;
314         beautyToOwner[_tokenId] = _to;
315 
316         if (_from != address(0)) {
317             beautyOwnershipCount[_from]--;
318             delete beautyToApproved[_tokenId];
319         }
320         Transfer(_from, _to, _tokenId);
321     }
322 
323     function enableCharity() external onlyOwner {
324         require(!charityEnabled);
325         charityEnabled = true;
326     }
327 
328     function disableCharity() external onlyOwner {
329         require(charityEnabled);
330         charityEnabled = false;
331     }
332 
333     function withdrawAll() external onlyAdmins {
334         msg.sender.transfer(this.balance);
335     }
336 
337     function withdrawAmount(uint256 _amount) external onlyAdmins {
338         msg.sender.transfer(_amount);
339     }
340 
341 }
342 
343 
344 /**
345  * @title SafeMath
346  * @dev Math operations with safety checks that throw on error
347  */
348 library SafeMath {
349 
350   /**
351   * @dev Multiplies two numbers, throws on overflow.
352   */
353   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354     if (a == 0) {
355       return 0;
356     }
357     uint256 c = a * b;
358     assert(c / a == b);
359     return c;
360   }
361 
362   /**
363   * @dev Integer division of two numbers, truncating the quotient.
364   */
365   function div(uint256 a, uint256 b) internal pure returns (uint256) {
366     // assert(b > 0); // Solidity automatically throws when dividing by 0
367     uint256 c = a / b;
368     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
369     return c;
370   }
371 
372   /**
373   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
374   */
375   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
376     assert(b <= a);
377     return a - b;
378   }
379 
380   /**
381   * @dev Adds two numbers, throws on overflow.
382   */
383   function add(uint256 a, uint256 b) internal pure returns (uint256) {
384     uint256 c = a + b;
385     assert(c >= a);
386     return c;
387   }
388 }