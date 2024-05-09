1 pragma solidity ^0.4.13;
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
45 contract CryptoSanguoToken {
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
58   uint256 private increaseLimit1 = 0.02 ether;
59   uint256 private increaseLimit2 = 0.5 ether;
60   uint256 private increaseLimit3 = 2.0 ether;
61   uint256 private increaseLimit4 = 5.0 ether;
62   uint256 private min_value = 0.01 ether;
63 
64   uint256[] private listedItems;
65   mapping (uint256 => address) private ownerOfItem;
66   mapping (uint256 => uint256) private startingPriceOfItem;
67   mapping (uint256 => uint256) private priceOfItem;
68   mapping (uint256 => address) private approvedOfItem;
69 
70   function CryptoSanguoToken () public {
71     owner = msg.sender;
72     admins[owner] = true;
73     issueCard(1, 7, 5);
74   }
75 
76   /* Modifiers */
77   modifier onlyOwner() {
78     require(owner == msg.sender);
79     _;
80   }
81 
82   modifier onlyAdmins() {
83     require(admins[msg.sender]);
84     _;
85   }
86 
87   modifier onlyERC721() {
88     require(erc721Enabled);
89     _;
90   }
91   
92   /* Owner */
93   function setOwner (address _owner) onlyOwner() public {
94     owner = _owner;
95   }
96 
97   function setItemRegistry (address _itemRegistry) onlyOwner() public {
98     itemRegistry = IItemRegistry(_itemRegistry);
99   }
100 
101   function addAdmin (address _admin) onlyOwner() public {
102     admins[_admin] = true;
103   }
104 
105   function removeAdmin (address _admin) onlyOwner() public {
106     delete admins[_admin];
107   }
108 
109   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
110   function enableERC721 () onlyOwner() public {
111     erc721Enabled = true;
112   }
113 
114   /* Withdraw */
115   /*
116     NOTICE: These functions withdraw the developer's cut which is left
117     in the contract by `buy`. User funds are immediately sent to the old
118     owner in `buy`, no user funds are left in the contract.
119   */
120   function withdrawAll () onlyOwner() public {
121     owner.transfer(this.balance);
122   }
123 
124   function withdrawAmount (uint256 _amount) onlyOwner() public {
125     owner.transfer(_amount);
126   }
127 
128   /* Listing */
129   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
130     for (uint256 i = 0; i < _itemIds.length; i++) {
131       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
132         continue;
133       }
134 
135       listItemFromRegistry(_itemIds[i]);
136     }
137   }
138 
139   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
140     require(itemRegistry != address(0));
141     require(itemRegistry.ownerOf(_itemId) != address(0));
142     require(itemRegistry.priceOf(_itemId) > 0);
143 
144     uint256 price = itemRegistry.priceOf(_itemId);
145     address itemOwner = itemRegistry.ownerOf(_itemId);
146     listItem(_itemId, price, itemOwner);
147   }
148 
149   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
150     for (uint256 i = 0; i < _itemIds.length; i++) {
151       listItem(_itemIds[i], _price, _owner);
152     }
153   }
154 
155   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
156     require(_price > 0);
157     require(priceOfItem[_itemId] == 0);
158     require(ownerOfItem[_itemId] == address(0));
159 
160     ownerOfItem[_itemId] = _owner;
161     priceOfItem[_itemId] = _price * min_value;
162     startingPriceOfItem[_itemId] = _price * min_value;
163     listedItems.push(_itemId);
164   }
165 
166   /* Buying */
167   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
168     if (_price < increaseLimit1) {
169       return _price.mul(200).div(92);
170     } else if (_price < increaseLimit2) {
171       return _price.mul(135).div(93);
172     } else if (_price < increaseLimit3) {
173       return _price.mul(125).div(94);
174     } else if (_price < increaseLimit4) {
175       return _price.mul(117).div(94);
176     } else {
177       return _price.mul(115).div(95);
178     }
179   }
180 
181   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
182     if (_price < increaseLimit1) {
183       return _price.mul(8).div(100); // 8%
184     } else if (_price < increaseLimit2) {
185       return _price.mul(7).div(100); // 7%
186     } else if (_price < increaseLimit3) {
187       return _price.mul(6).div(100); // 6%
188     } else if (_price < increaseLimit4) {
189       return _price.mul(6).div(100); // 6%
190     } else {
191       return _price.mul(5).div(100); // 5%
192     }
193   }
194 
195   /*
196      Buy a country directly from the contract for the calculated price
197      which ensures that the owner gets a profit.  All countries that
198      have been listed can be bought by this method. User funds are sent
199      directly to the previous owner and are never stored in the contract.
200   */
201   function buy (uint256 _itemId) payable public {
202     require(priceOf(_itemId) > 0);
203     require(ownerOf(_itemId) != address(0));
204     require(msg.value >= priceOf(_itemId));
205     require(ownerOf(_itemId) != msg.sender);
206     require(!isContract(msg.sender));
207     require(msg.sender != address(0));
208 
209     address oldOwner = ownerOf(_itemId);
210     address newOwner = msg.sender;
211     uint256 price = priceOf(_itemId);
212     uint256 excess = msg.value.sub(price);
213 
214     _transfer(oldOwner, newOwner, _itemId);
215     priceOfItem[_itemId] = nextPriceOf(_itemId);
216 
217     Bought(_itemId, newOwner, price);
218     Sold(_itemId, oldOwner, price);
219 
220     // Devevloper's cut which is left in contract and accesed by
221     // `withdrawAll` and `withdrawAmountTo` methods.
222     uint256 devCut = calculateDevCut(price);
223 
224     // Transfer payment to old owner minus the developer's cut.
225     oldOwner.transfer(price.sub(devCut));
226 
227     if (excess > 0) {
228       newOwner.transfer(excess);
229     }
230   }
231 
232   /* ERC721 */
233   function implementsERC721() public view returns (bool _implements) {
234     return erc721Enabled;
235   }
236 
237   function name() public pure returns (string _name) {
238     return "CryptoSanguo.io";
239   }
240 
241   function symbol() public pure returns (string _symbol) {
242     return "CSG";
243   }
244 
245   function totalSupply() public view returns (uint256 _totalSupply) {
246     return listedItems.length;
247   }
248 
249   function balanceOf (address _owner) public view returns (uint256 _balance) {
250     uint256 counter = 0;
251 
252     for (uint256 i = 0; i < listedItems.length; i++) {
253       if (ownerOf(listedItems[i]) == _owner) {
254         counter++;
255       }
256     }
257 
258     return counter;
259   }
260 
261   function ownerOf (uint256 _itemId) public view returns (address _owner) {
262     return ownerOfItem[_itemId];
263   }
264 
265   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
266     uint256[] memory items = new uint256[](balanceOf(_owner));
267 
268     uint256 itemCounter = 0;
269     for (uint256 i = 0; i < listedItems.length; i++) {
270       if (ownerOf(listedItems[i]) == _owner) {
271         items[itemCounter] = listedItems[i];
272         itemCounter += 1;
273       }
274     }
275 
276     return items;
277   }
278 
279   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
280     return priceOf(_itemId) > 0;
281   }
282 
283   function approvedFor(uint256 _itemId) public view returns (address _approved) {
284     return approvedOfItem[_itemId];
285   }
286 
287   function approve(address _to, uint256 _itemId) onlyERC721() public {
288     require(msg.sender != _to);
289     require(tokenExists(_itemId));
290     require(ownerOf(_itemId) == msg.sender);
291 
292     if (_to == 0) {
293       if (approvedOfItem[_itemId] != 0) {
294         delete approvedOfItem[_itemId];
295         Approval(msg.sender, 0, _itemId);
296       }
297     } else {
298       approvedOfItem[_itemId] = _to;
299       Approval(msg.sender, _to, _itemId);
300     }
301   }
302 
303   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
304   function transfer(address _to, uint256 _itemId) onlyERC721() public {
305     require(msg.sender == ownerOf(_itemId));
306     _transfer(msg.sender, _to, _itemId);
307   }
308 
309   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
310     require(approvedFor(_itemId) == msg.sender);
311     _transfer(_from, _to, _itemId);
312   }
313 
314   function _transfer(address _from, address _to, uint256 _itemId) internal {
315     require(tokenExists(_itemId));
316     require(ownerOf(_itemId) == _from);
317     require(_to != address(0));
318     require(_to != address(this));
319 
320     ownerOfItem[_itemId] = _to;
321     approvedOfItem[_itemId] = 0;
322 
323     Transfer(_from, _to, _itemId);
324   }
325 
326   /* Read */
327   function isAdmin (address _admin) public view returns (bool _isAdmin) {
328     return admins[_admin];
329   }
330 
331   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
332     return startingPriceOfItem[_itemId];
333   }
334 
335   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
336     return priceOfItem[_itemId];
337   }
338 
339   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
340     return calculateNextPrice(priceOf(_itemId));
341   }
342 
343   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
344     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
345   }
346 
347   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
348     uint256[] memory items = new uint256[](_take);
349 
350     for (uint256 i = 0; i < _take; i++) {
351       items[i] = listedItems[_from + i];
352     }
353 
354     return items;
355   }
356 
357   /* Util */
358   function isContract(address addr) internal view returns (bool) {
359     uint size;
360     assembly { size := extcodesize(addr) } // solium-disable-line
361     return size > 0;
362   }
363   
364   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
365     require(_price > 0);
366     require(admins[ownerOfItem[_itemId]]);
367     priceOfItem[_itemId] = _price * min_value;
368   }
369   
370   function issueCard(uint256 l, uint256 r, uint256 price) onlyAdmins() public {
371     for (uint256 i = l; i <= r; i++) {
372       ownerOfItem[i] = msg.sender;
373       priceOfItem[i] = price * min_value;
374       listedItems.push(i);
375     }      
376   }  
377 }
378 
379 interface IItemRegistry {
380   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
381   function ownerOf (uint256 _itemId) public view returns (address _owner);
382   function priceOf (uint256 _itemId) public view returns (uint256 _price);
383 }