1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ItemToken {
46   using SafeMath for uint256; // Loading the SafeMath library
47 
48   // Events of the contract
49   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
50   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
51   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
52   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
53 
54 
55   address private owner; // owner of the contract
56   address private charityAddress; // address of the charity
57   mapping (address => bool) private admins; // admins of the contract
58   IItemRegistry private itemRegistry; // Item registry
59   bool private erc721Enabled = false;
60 
61   // limits for devcut
62   uint256 private increaseLimit1 = 0.02 ether;
63   uint256 private increaseLimit2 = 0.5 ether;
64   uint256 private increaseLimit3 = 2.0 ether;
65   uint256 private increaseLimit4 = 5.0 ether;
66 
67   uint256[] private listedItems; // array of items
68   mapping (uint256 => address) private ownerOfItem; // owner of the item
69   mapping (uint256 => uint256) private startingPriceOfItem; // starting price of the item
70   mapping (uint256 => uint256) private previousPriceOfItem; // previous price of the item
71   mapping (uint256 => uint256) private priceOfItem; // actual price of the item
72   mapping (uint256 => uint256) private charityCutOfItem; // charity cut of the item
73   mapping (uint256 => address) private approvedOfItem; // item is approved for this address
74 
75   // constructor
76   constructor() public {
77     owner = msg.sender;
78     admins[owner] = true;
79   }
80 
81   // modifiers
82   modifier onlyOwner() {
83     require(owner == msg.sender);
84     _;
85   }
86 
87   modifier onlyAdmins() {
88     require(admins[msg.sender]);
89     _;
90   }
91 
92   modifier onlyERC721() {
93     require(erc721Enabled);
94     _;
95   }
96 
97   // contract owner
98   function setOwner (address _owner) onlyOwner() public {
99     owner = _owner;
100   }
101 
102   // Set charity address
103   function setCharity (address _charityAddress) onlyOwner() public {
104     charityAddress = _charityAddress;
105   }
106 
107   // Set item registry
108   function setItemRegistry (address _itemRegistry) onlyOwner() public {
109     itemRegistry = IItemRegistry(_itemRegistry);
110   }
111 
112   // Add admin
113   function addAdmin (address _admin) onlyOwner() public {
114     admins[_admin] = true;
115   }
116 
117   // Remove admin
118   function removeAdmin (address _admin) onlyOwner() public {
119     delete admins[_admin];
120   }
121 
122   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
123   function enableERC721 () onlyOwner() public {
124     erc721Enabled = true;
125   }
126 
127   // Withdraw
128   function withdrawAll () onlyOwner() public {
129     owner.transfer(address(this).balance);
130   }
131 
132   function withdrawAmount (uint256 _amount) onlyOwner() public {
133     owner.transfer(_amount);
134   }
135 
136   // Listing
137   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
138     for (uint256 i = 0; i < _itemIds.length; i++) {
139       if (charityCutOfItem[_itemIds[i]] > 0 || priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
140         continue;
141       }
142 
143       listItemFromRegistry(_itemIds[i]);
144     }
145   }
146 
147   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
148     require(itemRegistry != address(0));
149     require(itemRegistry.ownerOf(_itemId) != address(0));
150     require(itemRegistry.priceOf(_itemId) > 0);
151     require(itemRegistry.charityCutOf(_itemId) > 0);
152 
153     uint256 price = itemRegistry.priceOf(_itemId);
154     uint256 charityCut = itemRegistry.charityCutOf(_itemId);
155     address itemOwner = itemRegistry.ownerOf(_itemId);
156     listItem(_itemId, price, itemOwner, charityCut);
157   }
158 
159   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner, uint256 _charityCut) onlyAdmins() external {
160     for (uint256 i = 0; i < _itemIds.length; i++) {
161       listItem(_itemIds[i], _price, _owner, _charityCut);
162     }
163   }
164 
165   function listItem (uint256 _itemId, uint256 _price, address _owner, uint256 _charityCut) onlyAdmins() public {
166     require(_price > 0);
167     require(_charityCut >= 10);
168     require(_charityCut <= 100);
169     require(priceOfItem[_itemId] == 0);
170     require(ownerOfItem[_itemId] == address(0));
171     require(charityCutOfItem[_itemId] == 0);
172 
173     ownerOfItem[_itemId] = _owner;
174     priceOfItem[_itemId] = _price;
175     startingPriceOfItem[_itemId] = _price;
176     charityCutOfItem[_itemId] = _charityCut;
177     previousPriceOfItem[_itemId] = 0;
178     listedItems.push(_itemId);
179   }
180 
181   // Buy
182   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
183     if (_price < increaseLimit1) {
184       return _price.mul(200).div(95);
185     } else if (_price < increaseLimit2) {
186       return _price.mul(135).div(96);
187     } else if (_price < increaseLimit3) {
188       return _price.mul(125).div(97);
189     } else if (_price < increaseLimit4) {
190       return _price.mul(117).div(97);
191     } else {
192       return _price.mul(115).div(98);
193     }
194   }
195 
196   // Dev cut
197   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
198     if (_price < increaseLimit1) {
199       return _price.mul(5).div(100); // 5%
200     } else if (_price < increaseLimit2) {
201       return _price.mul(4).div(100); // 4%
202     } else if (_price < increaseLimit3) {
203       return _price.mul(3).div(100); // 3%
204     } else if (_price < increaseLimit4) {
205       return _price.mul(3).div(100); // 3%
206     } else {
207       return _price.mul(2).div(100); // 2%
208     }
209   }
210 
211   // Buy function
212   function buy (uint256 _itemId, uint256 _charityCutNew) payable public {
213     require(priceOf(_itemId) > 0); // price of the token has to be greater than zero
214     require(_charityCutNew >= 10); // minimum charity cut is 10%
215     require(_charityCutNew <= 100); // maximum charity cut is 100%
216     require(charityCutOf(_itemId) >= 10); // minimum charity cut is 10%
217     require(charityCutOf(_itemId) <= 100); // maximum charity cut is 100%
218     require(ownerOf(_itemId) != address(0)); // owner is not 0x0
219     require(msg.value >= priceOf(_itemId)); // msg.value has to be greater than the price of the token
220     require(ownerOf(_itemId) != msg.sender); // the owner cannot buy her own token
221     require(!isContract(msg.sender)); // message sender is not a contract
222     require(msg.sender != address(0)); // message sender is not 0x0
223 
224     address oldOwner = ownerOf(_itemId); // old owner of the token
225     address newOwner = msg.sender; // new owner of the token
226     uint256 price = priceOf(_itemId); // price of the token
227     uint256 previousPrice = previousPriceOf(_itemId); // previous price of the token (oldOwner bought it for this price)
228     uint256 charityCut = charityCutOf(_itemId); // actual charity cut of the token (oldOwner set this value)
229     uint256 excess = msg.value.sub(price); // excess
230     
231     charityCutOfItem[_itemId] = _charityCutNew; // update the charity cut array
232     previousPriceOfItem[_itemId] = priceOf(_itemId); // update the previous price array
233     priceOfItem[_itemId] = nextPriceOf(_itemId); // update price of item
234 
235     _transfer(oldOwner, newOwner, _itemId); // transfer token from oldOwner to newOwner
236 
237     emit Bought(_itemId, newOwner, price); // bought event
238     emit Sold(_itemId, oldOwner, price); // sold event
239 
240     // Devevloper's cut which is left in contract and accesed by
241     // `withdrawAll` and `withdrawAmountTo` methods.
242     uint256 devCut = calculateDevCut(price); // calculate dev cut
243     // Charity contribution
244     uint256 charityAmount = ((price.sub(devCut)).sub(previousPrice)).mul(charityCut).div(100); // calculate the charity cut
245     
246     charityAddress.transfer(charityAmount); // transfer payment to the address of the charity
247     oldOwner.transfer((price.sub(devCut)).sub(charityAmount)); // transfer payment to old owner minus the dev cut and the charity cut
248 
249     
250     if (excess > 0) {
251       newOwner.transfer(excess); // transfer the excess
252     }
253   }
254 
255   function implementsERC721() public view returns (bool _implements) {
256     return erc721Enabled;
257   }
258 
259   function name() public pure returns (string _name) {
260     return "Tokenimals";
261   }
262 
263   function symbol() public pure returns (string _symbol) {
264     return "TKS";
265   }
266 
267   function totalSupply() public view returns (uint256 _totalSupply) {
268     return listedItems.length;
269   }
270 
271   // balance of an address
272   function balanceOf (address _owner) public view returns (uint256 _balance) {
273     uint256 counter = 0;
274 
275     for (uint256 i = 0; i < listedItems.length; i++) {
276       if (ownerOf(listedItems[i]) == _owner) {
277         counter++;
278       }
279     }
280 
281     return counter;
282   }
283 
284   // owner of token
285   function ownerOf (uint256 _itemId) public view returns (address _owner) {
286     return ownerOfItem[_itemId];
287   }
288 
289   // tokens of an address
290   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
291     uint256[] memory items = new uint256[](balanceOf(_owner));
292 
293     uint256 itemCounter = 0;
294     for (uint256 i = 0; i < listedItems.length; i++) {
295       if (ownerOf(listedItems[i]) == _owner) {
296         items[itemCounter] = listedItems[i];
297         itemCounter += 1;
298       }
299     }
300 
301     return items;
302   }
303 
304   // token exists
305   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
306     return priceOf(_itemId) > 0;
307   }
308 
309   // approved for
310   function approvedFor(uint256 _itemId) public view returns (address _approved) {
311     return approvedOfItem[_itemId];
312   }
313 
314   // approve
315   function approve(address _to, uint256 _itemId) onlyERC721() public {
316     require(msg.sender != _to);
317     require(tokenExists(_itemId));
318     require(ownerOf(_itemId) == msg.sender);
319 
320     if (_to == 0) {
321       if (approvedOfItem[_itemId] != 0) {
322         delete approvedOfItem[_itemId];
323         emit Approval(msg.sender, 0, _itemId);
324       }
325     } else {
326       approvedOfItem[_itemId] = _to;
327       emit Approval(msg.sender, _to, _itemId);
328     }
329   }
330 
331   function transfer(address _to, uint256 _itemId) onlyERC721() public {
332     require(msg.sender == ownerOf(_itemId));
333     _transfer(msg.sender, _to, _itemId);
334   }
335 
336   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
337     require(approvedFor(_itemId) == msg.sender);
338     _transfer(_from, _to, _itemId);
339   }
340 
341   function _transfer(address _from, address _to, uint256 _itemId) internal {
342     require(tokenExists(_itemId));
343     require(ownerOf(_itemId) == _from);
344     require(_to != address(0));
345     require(_to != address(this));
346 
347     ownerOfItem[_itemId] = _to;
348     approvedOfItem[_itemId] = 0;
349 
350     emit Transfer(_from, _to, _itemId);
351   }
352 
353   // read
354   function isAdmin (address _admin) public view returns (bool _isAdmin) {
355     return admins[_admin];
356   }
357 
358   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
359     return startingPriceOfItem[_itemId];
360   }
361 
362   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
363     return priceOfItem[_itemId];
364   }
365 
366   function previousPriceOf (uint256 _itemId) public view returns (uint256 _previousPrice) {
367     return previousPriceOfItem[_itemId];
368   }
369 
370   function charityCutOf (uint256 _itemId) public view returns (uint256 _charityCut) {
371     return charityCutOfItem[_itemId];
372   }
373 
374   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
375     return calculateNextPrice(priceOf(_itemId));
376   }
377 
378   function readCharityAddress () public view returns (address _charityAddress) {
379     return charityAddress;
380   }
381 
382   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, uint256 _charityCut) {
383     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId), charityCutOf(_itemId));
384   }
385 
386   // selfdestruct
387   function ownerkill() public onlyOwner {
388         selfdestruct(owner);
389   }
390 
391   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
392     uint256[] memory items = new uint256[](_take);
393 
394     for (uint256 i = 0; i < _take; i++) {
395       items[i] = listedItems[_from + i];
396     }
397 
398     return items;
399   }
400 
401   // util
402   function isContract(address addr) internal view returns (bool) {
403     uint size;
404     assembly { size := extcodesize(addr) } // solium-disable-line
405     return size > 0;
406   }
407 
408 }
409 
410 interface IItemRegistry {
411   function itemsForSaleLimit (uint256 _from, uint256 _take) external view returns (uint256[] _items);
412   function ownerOf (uint256 _itemId) external view returns (address _owner);
413   function priceOf (uint256 _itemId) external view returns (uint256 _price);
414   function charityCutOf (uint256 _itemId) external view returns (uint256 _charityCut);
415 }