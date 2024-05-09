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
45 contract CryptoMilitary {
46   using SafeMath for uint256;
47 
48   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
49   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
50   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
51   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
52 
53   address private owner;
54   mapping (address => bool) private admins;
55   IItemRegistry private itemRegistry;
56   bool private erc721Enabled = false;
57 
58   uint256 private increaseLimit1 = 0.2 ether;
59   uint256 private increaseLimit2 = 5 ether;
60   uint256 private increaseLimit3 = 30 ether;
61   uint256 private increaseLimit4 = 90 ether;
62 
63   uint256[] private listedItems;
64   mapping (uint256 => address) private ownerOfItem;
65   mapping (uint256 => uint256) private startingPriceOfItem;
66   mapping (uint256 => uint256) private priceOfItem;
67   mapping (uint256 => address) private approvedOfItem;
68   mapping (address => string) private ownerNameOfItem;
69 
70   function CryptoMilitary () public {
71     owner = msg.sender;
72     admins[owner] = true;
73   }
74 
75   /* Modifiers */
76   modifier onlyOwner() {
77     require(owner == msg.sender);
78     _;
79   }
80 
81   modifier onlyAdmins() {
82     require(admins[msg.sender]);
83     _;
84   }
85 
86   modifier onlyERC721() {
87     require(erc721Enabled);
88     _;
89   }
90 
91   /* Owner */
92   function setOwner (address _owner) onlyOwner() public {
93     owner = _owner;
94   }
95 
96   function setItemRegistry (address _itemRegistry) onlyOwner() public {
97     itemRegistry = IItemRegistry(_itemRegistry);
98   }
99 
100   function addAdmin (address _admin) onlyOwner() public {
101     admins[_admin] = true;
102   }
103 
104   function removeAdmin (address _admin) onlyOwner() public {
105     delete admins[_admin];
106   }
107 
108   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
109   function enableERC721 () onlyOwner() public {
110     erc721Enabled = true;
111   }
112 
113   /* Withdraw */
114   /*
115     NOTICE: These functions withdraw the developer's cut which is left
116     in the contract by `buy`. User funds are immediately sent to the old
117     owner in `buy`, no user funds are left in the contract.
118   */
119   function withdrawAll () onlyOwner() public {
120     owner.transfer(this.balance);
121   }
122 
123   function withdrawAmount (uint256 _amount) onlyOwner() public {
124     owner.transfer(_amount);
125   }
126 
127   function getCurrentBalance() public view returns (uint256 balance) {
128       return this.balance;
129   }
130 
131   /* Listing */
132   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
133     for (uint256 i = 0; i < _itemIds.length; i++) {
134       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
135         continue;
136       }
137 
138       listItemFromRegistry(_itemIds[i]);
139     }
140   }
141 
142   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
143     require(itemRegistry != address(0));
144     require(itemRegistry.ownerOf(_itemId) != address(0));
145     require(itemRegistry.priceOf(_itemId) > 0);
146 
147     uint256 price = itemRegistry.priceOf(_itemId);
148     address itemOwner = itemRegistry.ownerOf(_itemId);
149 
150     listItem(_itemId, price, itemOwner);
151   }
152 
153   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
154     for (uint256 i = 0; i < _itemIds.length; i++) {
155       listItem(_itemIds[i], _price, _owner);
156     }
157   }
158 
159   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
160     require(_price > 0);
161     require(priceOfItem[_itemId] == 0);
162     require(ownerOfItem[_itemId] == address(0));
163 
164     ownerOfItem[_itemId] = _owner;
165     priceOfItem[_itemId] = _price;
166     startingPriceOfItem[_itemId] = _price;
167     listedItems.push(_itemId);
168   }
169 
170 
171   function setOwnerName (address _owner, string _name) public {
172     require(keccak256(ownerNameOfItem[_owner]) != keccak256(_name));
173     ownerNameOfItem[_owner] = _name;
174   }
175 
176   function getOwnerName (address _owner) public view returns (string _name) {
177     return ownerNameOfItem[_owner];
178   }
179 
180   /* Buying */
181   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
182     if (_price < increaseLimit1) {
183       return _price.mul(200).div(98);
184     } else if (_price < increaseLimit2) {
185       return _price.mul(135).div(97);
186     } else if (_price < increaseLimit3) {
187       return _price.mul(125).div(96);
188     } else if (_price < increaseLimit4) {
189       return _price.mul(117).div(95);
190     } else {
191       return _price.mul(115).div(95);
192     }
193   }
194 
195   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
196     if (_price < increaseLimit1) {
197       return _price.mul(8).div(100); // 8%
198     } else if (_price < increaseLimit2) {
199       return _price.mul(7).div(100); // 7%
200     } else if (_price < increaseLimit3) {
201       return _price.mul(6).div(100); // 6%
202     } else if (_price < increaseLimit4) {
203       return _price.mul(5).div(100); // 5%
204     } else {
205       return _price.mul(5).div(100); // 5%
206     }
207   }
208 
209   /*
210      Buy a country directly from the contract for the calculated price
211      which ensures that the owner gets a profit.  All militaries that
212      have been listed can be bought by this method. User funds are sent
213      directly to the previous owner and are never stored in the contract.
214   */
215   function buy (uint256 _itemId) payable public {
216     require(priceOf(_itemId) > 0);
217     require(ownerOf(_itemId) != address(0));
218     require(msg.value >= priceOf(_itemId));
219     require(ownerOf(_itemId) != msg.sender);
220     require(!isContract(msg.sender));
221     require(msg.sender != address(0));
222 
223     address oldOwner = ownerOf(_itemId);
224     address newOwner = msg.sender;
225     uint256 price = priceOf(_itemId);
226     uint256 excess = msg.value.sub(price);
227 
228     _transfer(oldOwner, newOwner, _itemId);
229     priceOfItem[_itemId] = nextPriceOf(_itemId);
230 
231     emit Bought(_itemId, newOwner, price);
232     emit Sold(_itemId, oldOwner, price);
233 
234     // Devevloper's cut which is left in contract and accesed by
235     // `withdrawAll` and `withdrawAmountTo` methods.
236     uint256 devCut = calculateDevCut(price);
237 
238     // Transfer payment to old owner minus the developer's cut.
239     oldOwner.transfer(price.sub(devCut));
240 
241     if (excess > 0) {
242       newOwner.transfer(excess);
243     }
244   }
245 
246   /* ERC721 */
247   function implementsERC721() public view returns (bool _implements) {
248     return erc721Enabled;
249   }
250 
251   function name() public pure returns (string _name) {
252     return "CryptoMilitary";
253   }
254 
255   function symbol() public pure returns (string _symbol) {
256     return "CMT";
257   }
258 
259   function totalSupply() public view returns (uint256 _totalSupply) {
260     return listedItems.length;
261   }
262 
263   function balanceOf (address _owner) public view returns (uint256 _balance) {
264     uint256 counter = 0;
265 
266     for (uint256 i = 0; i < listedItems.length; i++) {
267       if (ownerOf(listedItems[i]) == _owner) {
268         counter++;
269       }
270     }
271 
272     return counter;
273   }
274 
275   function ownerOf (uint256 _itemId) public view returns (address _owner) {
276     return ownerOfItem[_itemId];
277   }
278 
279   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
280     uint256[] memory items = new uint256[](balanceOf(_owner));
281 
282     uint256 itemCounter = 0;
283     for (uint256 i = 0; i < listedItems.length; i++) {
284       if (ownerOf(listedItems[i]) == _owner) {
285         items[itemCounter] = listedItems[i];
286         itemCounter += 1;
287       }
288     }
289 
290     return items;
291   }
292 
293   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
294     return priceOf(_itemId) > 0;
295   }
296 
297   function approvedFor(uint256 _itemId) public view returns (address _approved) {
298     return approvedOfItem[_itemId];
299   }
300 
301   function approve(address _to, uint256 _itemId) onlyERC721() public {
302     require(msg.sender != _to);
303     require(tokenExists(_itemId));
304     require(ownerOf(_itemId) == msg.sender);
305 
306     if (_to == 0) {
307       if (approvedOfItem[_itemId] != 0) {
308         delete approvedOfItem[_itemId];
309         emit Approval(msg.sender, 0, _itemId);
310       }
311     } else {
312       approvedOfItem[_itemId] = _to;
313       emit Approval(msg.sender, _to, _itemId);
314     }
315   }
316 
317   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
318   function transfer(address _to, uint256 _itemId) onlyERC721() public {
319     require(msg.sender == ownerOf(_itemId));
320     _transfer(msg.sender, _to, _itemId);
321   }
322 
323   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
324     require(approvedFor(_itemId) == msg.sender);
325     _transfer(_from, _to, _itemId);
326   }
327 
328   function _transfer(address _from, address _to, uint256 _itemId) internal {
329     require(tokenExists(_itemId));
330     require(ownerOf(_itemId) == _from);
331     require(_to != address(0));
332     require(_to != address(this));
333 
334     ownerOfItem[_itemId] = _to;
335     approvedOfItem[_itemId] = 0;
336 
337     emit Transfer(_from, _to, _itemId);
338   }
339 
340   /* Read */
341   function isAdmin (address _admin) public view returns (bool _isAdmin) {
342     return admins[_admin];
343   }
344 
345   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
346     return startingPriceOfItem[_itemId];
347   }
348 
349   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
350     return priceOfItem[_itemId];
351   }
352 
353   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
354     return calculateNextPrice(priceOf(_itemId));
355   }
356 
357   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
358     return (ownerOf(_itemId),priceOf(_itemId), nextPriceOf(_itemId));
359   }
360 
361   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
362     uint256[] memory items = new uint256[](_take);
363 
364     for (uint256 i = 0; i < _take; i++) {
365       items[i] = listedItems[_from + i];
366     }
367 
368     return items;
369   }
370 
371   /* Util */
372   function isContract(address addr) internal view returns (bool) {
373     uint size;
374     assembly { size := extcodesize(addr) } // solium-disable-line
375     return size > 0;
376   }
377 }
378 
379 interface IItemRegistry {
380   function itemsForSaleLimit (uint256 _from, uint256 _take) external view returns (uint256[] _items);
381   function ownerOf (uint256 _itemId) external view returns (address _owner);
382   function priceOf (uint256 _itemId) external view returns (uint256 _price);
383 }