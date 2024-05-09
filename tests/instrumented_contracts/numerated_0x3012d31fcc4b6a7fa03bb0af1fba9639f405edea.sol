1 pragma solidity ^0.4.24;
2 /* CryptoCountries.io Cities */
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Managed {
34   event DeclareEmergency (string _reason);
35   event ResolveEmergency ();
36 
37   address private addressOfOwner;
38   address[] private addressesOfAdmins;
39   bool private isInEmergency;
40 
41   constructor () public {
42     addressOfOwner = msg.sender;
43     isInEmergency = false;
44   }
45 
46   /* Modifiers */
47   modifier onlyOwner () {
48     require(addressOfOwner == msg.sender);
49     _;
50   }
51 
52   modifier onlyAdmins () {
53     require(isAdmin(msg.sender));
54     _;
55   }
56 
57   modifier notEmergency () {
58     require(!isInEmergency);
59     _;
60   }
61 
62   /* Admin */
63   function transferOwnership (address _owner) onlyOwner() public {
64     clearAdmins();
65     addressOfOwner = _owner;
66   }
67 
68   function addAdmin (address _admin) onlyOwner() public {
69     addressesOfAdmins.push(_admin);
70   }
71 
72   function removeAdmin (address _admin) onlyOwner() public {
73     require(isAdmin(_admin));
74 
75     uint256 length = addressesOfAdmins.length;
76     address swap = addressesOfAdmins[length - 1];
77     uint256 index = 0;
78 
79     for (uint256 i = 0; i < length; i++) {
80       if (addressesOfAdmins[i] == _admin) {
81         index = i;
82       }
83     }
84 
85     addressesOfAdmins[index] = swap;
86     delete addressesOfAdmins[length - 1];
87     addressesOfAdmins.length--;
88   }
89 
90   function clearAdmins () onlyOwner() public {
91     require(addressesOfAdmins.length > 0);
92     addressesOfAdmins.length = 0;
93   }
94 
95   /* Emergency protocol */
96   function declareEmergency (string _reason) onlyOwner() public {
97     require(!isInEmergency);
98     isInEmergency = true;
99     emit DeclareEmergency(_reason);
100   }
101 
102   function resolveEmergency () onlyOwner() public {
103     require(isInEmergency);
104     isInEmergency = false;
105     emit ResolveEmergency();
106   }
107 
108   /* Read */
109   function owner () public view returns (address _owner) {
110     return addressOfOwner;
111   }
112 
113   function admins () public view returns (address[] _admins) {
114     return addressesOfAdmins;
115   }
116 
117   function emergency () public view returns (bool _emergency) {
118     return isInEmergency;
119   }
120 
121   function isAdmin (address _admin) public view returns (bool _isAdmin) {
122     if (_admin == addressOfOwner) {
123       return true;
124     }
125 
126     for (uint256 i = 0; i < addressesOfAdmins.length; i++) {
127       if (addressesOfAdmins[i] == _admin) {
128         return true;
129       }
130     }
131 
132     return false;
133   }
134 }
135 
136 interface ICountryToken {
137   function ownerOf (uint256) external view returns (address);
138   function priceOf (uint256) external view returns (uint256);
139 }
140 
141 contract CityToken is Managed {
142   using SafeMath for uint256;
143 
144   event List (uint256 indexed _itemId, address indexed _owner, uint256 _price);
145   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
146   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
147   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
148   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
149 
150   ICountryToken private countryToken;
151   bool private erc721Enabled = false;
152 
153   uint256[] private listedItems;
154   mapping (uint256 => address) private ownerOfItem;
155   mapping (uint256 => uint256) private priceOfItem;
156   mapping (uint256 => uint256) private countryOfItem;
157   mapping (uint256 => uint256[]) private itemsOfCountry;
158   mapping (uint256 => address) private approvedOfItem;
159 
160   /* Constructor */
161   constructor () public {
162   }
163 
164   /* Modifiers */
165   modifier hasCountryToken () {
166     require(countryToken != address(0));
167     _;
168   }
169 
170   modifier onlyERC721() {
171     require(erc721Enabled);
172     _;
173   }
174 
175   /* Initilization */
176   function setCountryToken (address _countryToken) onlyOwner() public {
177     countryToken = ICountryToken(_countryToken);
178   }
179 
180   /* Withdraw */
181   /*
182     NOTICE: These functions withdraw the developer's cut which is left
183     in the contract by `buy`. User funds are immediately sent to the old
184     owner in `buy`, no user funds are left in the contract.
185   */
186   function withdrawAll () onlyOwner() public {
187     owner().transfer(address(this).balance);
188   }
189 
190   function withdrawAmount (uint256 _amount) onlyOwner() public {
191     owner().transfer(_amount);
192   }
193 
194   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
195   function enableERC721 () onlyOwner() public {
196     erc721Enabled = true;
197   }
198 
199   /* Listing */
200   function listMultipleItems (uint256[] _itemIds, uint256[] _countryIds, uint256 _price, address _owner) onlyAdmins() notEmergency() hasCountryToken() external {
201     require(_itemIds.length == _countryIds.length);
202 
203     for (uint256 i = 0; i < _itemIds.length; i++) {
204       listItem(_itemIds[i], _countryIds[i], _price, _owner);
205     }
206   }
207 
208   function listItem (uint256 _itemId, uint256 _countryId, uint256 _price, address _owner) onlyAdmins() notEmergency() hasCountryToken() public {
209     require(countryToken != address(0));
210     require(_price > 0);
211     require(priceOf(_itemId) == 0);
212     require(ownerOf(_itemId) == address(0));
213     require(countryToken.ownerOf(_countryId) != address(0));
214     require(countryToken.priceOf(_countryId) > 0);
215 
216     ownerOfItem[_itemId] = _owner;
217     priceOfItem[_itemId] = _price;
218     countryOfItem[_itemId] = _countryId;
219 
220     listedItems.push(_itemId);
221     itemsOfCountry[_countryId].push(_itemId);
222 
223     emit List(_itemId, _owner, _price);
224   }
225 
226   /* Market */
227   function calculateNextPrice (uint256 _price) public pure returns (uint256 _nextPrice) {
228     return _price.mul(120).div(94);
229   }
230 
231   function calculateDevCut (uint256 _price) public pure returns (uint256 _devCut) {
232     return _price.mul(3).div(100); // 3%
233   }
234 
235   function calculateCountryCut (uint256 _price) public pure returns (uint256 _countryCut) {
236     return _price.mul(3).div(100); // 3%
237   }
238 
239   function buy (uint256 _itemId) notEmergency() hasCountryToken() payable public {
240     require(priceOf(_itemId) > 0);
241     require(ownerOf(_itemId) != address(0));
242     require(msg.value >= priceOf(_itemId));
243     require(ownerOf(_itemId) != msg.sender);
244     require(msg.sender != address(0));
245     require(countryToken.ownerOf(countryOf(_itemId)) != address(0));
246 
247     address oldOwner = ownerOf(_itemId);
248     address newOwner = msg.sender;
249     address countryOwner = countryToken.ownerOf(countryOf(_itemId));
250     uint256 price = priceOf(_itemId);
251     uint256 excess = msg.value.sub(price);
252 
253     _transfer(oldOwner, newOwner, _itemId);
254     priceOfItem[_itemId] = nextPriceOf(_itemId);
255 
256     emit Bought(_itemId, newOwner, price);
257     emit Sold(_itemId, oldOwner, price);
258 
259     uint256 devCut = calculateDevCut(price);
260     uint256 countryCut = calculateCountryCut(price);
261     uint256 totalCut = devCut + countryCut;
262 
263     countryOwner.transfer(countryCut);
264     oldOwner.transfer(price.sub(totalCut));
265 
266     if (excess > 0) {
267       newOwner.transfer(excess);
268     }
269   }
270 
271   /* Read */
272   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
273     return priceOf(_itemId) > 0;
274   }
275 
276   function countrySupply (uint256 _countryId) public view returns (uint256 _countrySupply) {
277     return itemsOfCountry[_countryId].length;
278   }
279 
280   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
281     return priceOfItem[_itemId];
282   }
283 
284   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
285     return calculateNextPrice(priceOf(_itemId));
286   }
287 
288   function countryOf (uint256 _itemId) public view returns (uint256 _countryId) {
289     return countryOfItem[_itemId];
290   }
291 
292   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice, uint256 _countryId) {
293     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId), countryOf(_itemId));
294   }
295 
296   function allItems (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
297     if (totalSupply() == 0) {
298       return new uint256[](0);
299     }
300 
301     uint256[] memory items = new uint256[](_take);
302 
303     for (uint256 i = 0; i < _take; i++) {
304       items[i] = listedItems[_from + i];
305     }
306 
307     return items;
308   }
309 
310   function countryItems (uint256 _countryId, uint256 _from, uint256 _take) public view returns (uint256[] _items) {
311     if (countrySupply(_countryId) == 0) {
312       return new uint256[](0);
313     }
314 
315     uint256[] memory items = new uint256[](_take);
316 
317     for (uint256 i = 0; i < _take; i++) {
318       items[i] = itemsOfCountry[_countryId][_from + i];
319     }
320 
321     return items;
322   }
323 
324   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
325     uint256[] memory items = new uint256[](balanceOf(_owner));
326 
327     uint256 itemCounter = 0;
328     for (uint256 i = 0; i < listedItems.length; i++) {
329       if (ownerOf(listedItems[i]) == _owner) {
330         items[itemCounter] = listedItems[i];
331         itemCounter += 1;
332       }
333     }
334 
335     return items;
336   }
337 
338   /* ERC721 */
339   function implementsERC721 () public view returns (bool _implements) {
340     return erc721Enabled;
341   }
342 
343   function balanceOf (address _owner) public view returns (uint256 _balance) {
344     uint256 counter = 0;
345 
346     for (uint256 i = 0; i < listedItems.length; i++) {
347       if (ownerOf(listedItems[i]) == _owner) {
348         counter++;
349       }
350     }
351 
352     return counter;
353   }
354 
355   function ownerOf (uint256 _itemId) public view returns (address _owner) {
356     return ownerOfItem[_itemId];
357   }
358 
359   function transfer(address _to, uint256 _itemId) onlyERC721() public {
360     require(msg.sender == ownerOf(_itemId));
361     _transfer(msg.sender, _to, _itemId);
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
365     require(getApproved(_itemId) == msg.sender);
366     _transfer(_from, _to, _itemId);
367   }
368 
369   function approve(address _to, uint256 _itemId) onlyERC721() public {
370     require(msg.sender != _to);
371     require(tokenExists(_itemId));
372     require(ownerOf(_itemId) == msg.sender);
373 
374     if (_to == 0) {
375       if (approvedOfItem[_itemId] != 0) {
376         delete approvedOfItem[_itemId];
377         emit Approval(msg.sender, 0, _itemId);
378       }
379     } else {
380       approvedOfItem[_itemId] = _to;
381       emit Approval(msg.sender, _to, _itemId);
382     }
383   }
384 
385   function getApproved (uint256 _itemId) public view returns (address _approved) {
386     require(tokenExists(_itemId));
387     return approvedOfItem[_itemId];
388   }
389 
390   function name () public pure returns (string _name) {
391     return "CryptoCountries.io Cities";
392   }
393 
394   function symbol () public pure returns (string _symbol) {
395     return "CC2";
396   }
397 
398   function tokenURI (uint256 _itemId) public pure returns (string) {
399     return _concat("https://cryptocountries.io/api/metadata/city/", _uintToString(_itemId));
400   }
401 
402   function totalSupply () public view returns (uint256 _totalSupply) {
403     return listedItems.length;
404   }
405 
406   function tokenByIndex (uint256 _index) public view returns (uint256 _itemId) {
407     require(_index < totalSupply());
408     return listedItems[_index];
409   }
410 
411   function tokenOfOwnerByIndex (address _owner, uint256 _index) public view returns (uint256 _itemId) {
412     require(_index < balanceOf(_owner));
413 
414     uint count = 0;
415     for (uint i = 0; i < listedItems.length; i++) {
416       uint itemId = listedItems[i];
417       if (ownerOf(itemId) == _owner) {
418         if (count == _index) { return itemId; }
419         count += 1;
420       }
421     }
422 
423     assert(false);
424   }
425 
426   /* Internal */
427   function _transfer(address _from, address _to, uint256 _itemId) internal {
428     require(tokenExists(_itemId));
429     require(ownerOf(_itemId) == _from);
430     require(_to != address(0));
431     require(_to != address(this));
432 
433     ownerOfItem[_itemId] = _to;
434     approvedOfItem[_itemId] = 0;
435 
436     emit Transfer(_from, _to, _itemId);
437   }
438 
439   function _uintToString (uint i) internal pure returns (string) {
440 		if (i == 0) return "0";
441 
442 		uint j = i;
443 		uint len;
444 		while (j != 0){
445 			len++;
446 			j /= 10;
447 		}
448 
449 		bytes memory bstr = new bytes(len);
450 
451 		uint k = len - 1;
452 		while (i != 0) {
453 			bstr[k--] = byte(48 + i % 10);
454 			i /= 10;
455 		}
456 
457 		return string(bstr);
458   }
459 
460   function _concat(string _a, string _b) internal pure returns (string) {
461     bytes memory _ba = bytes(_a);
462     bytes memory _bb = bytes(_b);
463     string memory ab = new string(_ba.length + _bb.length);
464     bytes memory bab = bytes(ab);
465     uint k = 0;
466     for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
467     for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
468     return string(bab);
469   }
470 }