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
45 contract ItemToken {
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
62 
63   uint256[] private listedItems;
64   mapping (uint256 => address) private ownerOfItem;
65   mapping (uint256 => uint256) private startingPriceOfItem;
66   mapping (uint256 => uint256) private priceOfItem;
67   mapping (uint256 => address) private approvedOfItem;
68 
69   function ItemToken () public {
70     owner = msg.sender;
71     admins[owner] = true;
72   }
73 
74   /* Modifiers */
75   modifier onlyOwner() {
76     require(owner == msg.sender);
77     _;
78   }
79 
80   modifier onlyAdmins() {
81     require(admins[msg.sender]);
82     _;
83   }
84 
85   modifier onlyERC721() {
86     require(erc721Enabled);
87     _;
88   }
89 
90   /* Owner */
91   function setOwner (address _owner) onlyOwner() public {
92     owner = _owner;
93   }
94 
95   function setItemRegistry (address _itemRegistry) onlyOwner() public {
96     itemRegistry = IItemRegistry(_itemRegistry);
97   }
98 
99   function addAdmin (address _admin) onlyOwner() public {
100     admins[_admin] = true;
101   }
102 
103   function removeAdmin (address _admin) onlyOwner() public {
104     delete admins[_admin];
105   }
106 
107   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
108   function enableERC721 () onlyOwner() public {
109     erc721Enabled = true;
110   }
111 
112   /* Withdraw */
113   /*
114     NOTICE: These functions withdraw the developer's cut which is left
115     in the contract by `buy`. User funds are immediately sent to the old
116     owner in `buy`, no user funds are left in the contract.
117   */
118   function withdrawAll () onlyOwner() public {
119     owner.transfer(this.balance);
120   }
121 
122   function withdrawAmount (uint256 _amount) onlyOwner() public {
123     owner.transfer(_amount);
124   }
125 
126   /* Listing */
127   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
128     for (uint256 i = 0; i < _itemIds.length; i++) {
129       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
130         continue;
131       }
132 
133       listItemFromRegistry(_itemIds[i]);
134     }
135   }
136 
137   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
138     require(itemRegistry != address(0));
139     require(itemRegistry.ownerOf(_itemId) != address(0));
140     require(itemRegistry.priceOf(_itemId) > 0);
141 
142     uint256 price = itemRegistry.priceOf(_itemId);
143     address itemOwner = itemRegistry.ownerOf(_itemId);
144     listItem(_itemId, price, itemOwner);
145   }
146 
147   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
148     for (uint256 i = 0; i < _itemIds.length; i++) {
149       listItem(_itemIds[i], _price, _owner);
150     }
151   }
152 
153   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
154     require(_price > 0);
155     require(priceOfItem[_itemId] == 0);
156     require(ownerOfItem[_itemId] == address(0));
157 
158     ownerOfItem[_itemId] = _owner;
159     priceOfItem[_itemId] = _price;
160     startingPriceOfItem[_itemId] = _price;
161     listedItems.push(_itemId);
162   }
163 
164   /* Buying */
165   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
166     if (_price < increaseLimit1) {
167       return _price.mul(200).div(95);
168     } else if (_price < increaseLimit2) {
169       return _price.mul(135).div(96);
170     } else if (_price < increaseLimit3) {
171       return _price.mul(125).div(97);
172     } else if (_price < increaseLimit4) {
173       return _price.mul(117).div(97);
174     } else {
175       return _price.mul(115).div(98);
176     }
177   }
178 
179   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
180     if (_price < increaseLimit1) {
181       return _price.mul(5).div(100); // 5%
182     } else if (_price < increaseLimit2) {
183       return _price.mul(4).div(100); // 4%
184     } else if (_price < increaseLimit3) {
185       return _price.mul(3).div(100); // 3%
186     } else if (_price < increaseLimit4) {
187       return _price.mul(3).div(100); // 3%
188     } else {
189       return _price.mul(2).div(100); // 2%
190     }
191   }
192 
193   /*
194      Buy a estate directly from the contract for the calculated price
195      which ensures that the owner gets a profit.  All Estates that
196      have been listed can be bought by this method. User funds are sent
197      directly to the previous owner and are never stored in the contract.
198   */
199   function buy (uint256 _itemId) payable public {
200     require(priceOf(_itemId) > 0);
201     require(ownerOf(_itemId) != address(0));
202     require(msg.value >= priceOf(_itemId));
203     require(ownerOf(_itemId) != msg.sender);
204     require(!isContract(msg.sender));
205     require(msg.sender != address(0));
206 
207     address oldOwner = ownerOf(_itemId);
208     address newOwner = msg.sender;
209     uint256 price = priceOf(_itemId);
210     uint256 excess = msg.value.sub(price);
211 
212     _transfer(oldOwner, newOwner, _itemId);
213     priceOfItem[_itemId] = nextPriceOf(_itemId);
214 
215     Bought(_itemId, newOwner, price);
216     Sold(_itemId, oldOwner, price);
217 
218     // Devevloper's cut which is left in contract and accesed by
219     // `withdrawAll` and `withdrawAmountTo` methods.
220     uint256 devCut = calculateDevCut(price);
221 
222     // Transfer payment to old owner minus the developer's cut.
223     oldOwner.transfer(price.sub(devCut));
224 
225     if (excess > 0) {
226       newOwner.transfer(excess);
227     }
228   }
229 
230   /* ERC721 */
231   function implementsERC721() public view returns (bool _implements) {
232     return erc721Enabled;
233   }
234 
235   function name() public pure returns (string _name) {
236     return "Blockchina.io";
237   }
238 
239   function symbol() public pure returns (string _symbol) {
240     return "BCN";
241   }
242 
243   function totalSupply() public view returns (uint256 _totalSupply) {
244     return listedItems.length;
245   }
246 
247   function balanceOf (address _owner) public view returns (uint256 _balance) {
248     uint256 counter = 0;
249 
250     for (uint256 i = 0; i < listedItems.length; i++) {
251       if (ownerOf(listedItems[i]) == _owner) {
252         counter++;
253       }
254     }
255 
256     return counter;
257   }
258 
259   function ownerOf (uint256 _itemId) public view returns (address _owner) {
260     return ownerOfItem[_itemId];
261   }
262 
263   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
264     uint256[] memory items = new uint256[](balanceOf(_owner));
265 
266     uint256 itemCounter = 0;
267     for (uint256 i = 0; i < listedItems.length; i++) {
268       if (ownerOf(listedItems[i]) == _owner) {
269         items[itemCounter] = listedItems[i];
270         itemCounter += 1;
271       }
272     }
273 
274     return items;
275   }
276 
277   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
278     return priceOf(_itemId) > 0;
279   }
280 
281   function approvedFor(uint256 _itemId) public view returns (address _approved) {
282     return approvedOfItem[_itemId];
283   }
284 
285   function approve(address _to, uint256 _itemId) onlyERC721() public {
286     require(msg.sender != _to);
287     require(tokenExists(_itemId));
288     require(ownerOf(_itemId) == msg.sender);
289 
290     if (_to == 0) {
291       if (approvedOfItem[_itemId] != 0) {
292         delete approvedOfItem[_itemId];
293         Approval(msg.sender, 0, _itemId);
294       }
295     } else {
296       approvedOfItem[_itemId] = _to;
297       Approval(msg.sender, _to, _itemId);
298     }
299   }
300 
301   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
302   function transfer(address _to, uint256 _itemId) onlyERC721() public {
303     require(msg.sender == ownerOf(_itemId));
304     _transfer(msg.sender, _to, _itemId);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
308     require(approvedFor(_itemId) == msg.sender);
309     _transfer(_from, _to, _itemId);
310   }
311 
312   function _transfer(address _from, address _to, uint256 _itemId) internal {
313     require(tokenExists(_itemId));
314     require(ownerOf(_itemId) == _from);
315     require(_to != address(0));
316     require(_to != address(this));
317 
318     ownerOfItem[_itemId] = _to;
319     approvedOfItem[_itemId] = 0;
320 
321     Transfer(_from, _to, _itemId);
322   }
323 
324   /* Read */
325   function isAdmin (address _admin) public view returns (bool _isAdmin) {
326     return admins[_admin];
327   }
328 
329   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
330     return startingPriceOfItem[_itemId];
331   }
332 
333   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
334     return priceOfItem[_itemId];
335   }
336 
337   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
338     return calculateNextPrice(priceOf(_itemId));
339   }
340 
341   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
342     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
343   }
344 
345   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
346     uint256[] memory items = new uint256[](_take);
347 
348     for (uint256 i = 0; i < _take; i++) {
349       items[i] = listedItems[_from + i];
350     }
351 
352     return items;
353   }
354 
355   /* Util */
356   function isContract(address addr) internal view returns (bool) {
357     uint size;
358     assembly { size := extcodesize(addr) } // solium-disable-line
359     return size > 0;
360   }
361 }
362 
363 interface IItemRegistry {
364   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
365   function ownerOf (uint256 _itemId) public view returns (address _owner);
366   function priceOf (uint256 _itemId) public view returns (uint256 _price);
367 }