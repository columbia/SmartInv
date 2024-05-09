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
45 contract AVToken {
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
70   function AVToken () public {
71     owner = msg.sender;
72     admins[owner] = true;
73     issueCard(1, 4, 5);
74     issueCard(5, 22, 1);
75   }
76 
77   /* Modifiers */
78   modifier onlyOwner() {
79     require(owner == msg.sender);
80     _;
81   }
82 
83   modifier onlyAdmins() {
84     require(admins[msg.sender]);
85     _;
86   }
87 
88   modifier onlyERC721() {
89     require(erc721Enabled);
90     _;
91   }
92   
93   /* Owner */
94   function setOwner (address _owner) onlyOwner() public {
95     owner = _owner;
96   }
97 
98   function setItemRegistry (address _itemRegistry) onlyOwner() public {
99     itemRegistry = IItemRegistry(_itemRegistry);
100   }
101 
102   function addAdmin (address _admin) onlyOwner() public {
103     admins[_admin] = true;
104   }
105 
106   function removeAdmin (address _admin) onlyOwner() public {
107     delete admins[_admin];
108   }
109 
110   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
111   function enableERC721 () onlyOwner() public {
112     erc721Enabled = true;
113   }
114 
115   /* Withdraw */
116   /*
117     NOTICE: These functions withdraw the developer's cut which is left
118     in the contract by `buy`. User funds are immediately sent to the old
119     owner in `buy`, no user funds are left in the contract.
120   */
121   function withdrawAll () onlyOwner() public {
122     owner.transfer(this.balance);
123   }
124 
125   function withdrawAmount (uint256 _amount) onlyOwner() public {
126     owner.transfer(_amount);
127   }
128 
129   /* Listing */
130   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
131     for (uint256 i = 0; i < _itemIds.length; i++) {
132       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
133         continue;
134       }
135 
136       listItemFromRegistry(_itemIds[i]);
137     }
138   }
139 
140   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
141     require(itemRegistry != address(0));
142     require(itemRegistry.ownerOf(_itemId) != address(0));
143     require(itemRegistry.priceOf(_itemId) > 0);
144 
145     uint256 price = itemRegistry.priceOf(_itemId);
146     address itemOwner = itemRegistry.ownerOf(_itemId);
147     listItem(_itemId, price, itemOwner);
148   }
149 
150   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
151     for (uint256 i = 0; i < _itemIds.length; i++) {
152       listItem(_itemIds[i], _price, _owner);
153     }
154   }
155 
156   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
157     require(_price > 0);
158     require(priceOfItem[_itemId] == 0);
159     require(ownerOfItem[_itemId] == address(0));
160 
161     ownerOfItem[_itemId] = _owner;
162     priceOfItem[_itemId] = _price;
163     startingPriceOfItem[_itemId] = _price;
164     listedItems.push(_itemId);
165   }
166 
167   /* Buying */
168   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
169     if (_price < increaseLimit1) {
170       return _price.mul(200).div(92);
171     } else if (_price < increaseLimit2) {
172       return _price.mul(135).div(93);
173     } else if (_price < increaseLimit3) {
174       return _price.mul(125).div(94);
175     } else if (_price < increaseLimit4) {
176       return _price.mul(117).div(94);
177     } else {
178       return _price.mul(115).div(95);
179     }
180   }
181 
182   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
183     if (_price < increaseLimit1) {
184       return _price.mul(8).div(100); // 8%
185     } else if (_price < increaseLimit2) {
186       return _price.mul(7).div(100); // 7%
187     } else if (_price < increaseLimit3) {
188       return _price.mul(6).div(100); // 6%
189     } else if (_price < increaseLimit4) {
190       return _price.mul(6).div(100); // 6%
191     } else {
192       return _price.mul(5).div(100); // 5%
193     }
194   }
195 
196   /*
197      Buy a country directly from the contract for the calculated price
198      which ensures that the owner gets a profit.  All countries that
199      have been listed can be bought by this method. User funds are sent
200      directly to the previous owner and are never stored in the contract.
201   */
202   function buy (uint256 _itemId) payable public {
203     require(priceOf(_itemId) > 0);
204     require(ownerOf(_itemId) != address(0));
205     require(msg.value >= priceOf(_itemId));
206     require(ownerOf(_itemId) != msg.sender);
207     require(!isContract(msg.sender));
208     require(msg.sender != address(0));
209 
210     address oldOwner = ownerOf(_itemId);
211     address newOwner = msg.sender;
212     uint256 price = priceOf(_itemId);
213     uint256 excess = msg.value.sub(price);
214 
215     _transfer(oldOwner, newOwner, _itemId);
216     priceOfItem[_itemId] = nextPriceOf(_itemId);
217 
218     Bought(_itemId, newOwner, price);
219     Sold(_itemId, oldOwner, price);
220 
221     // Devevloper's cut which is left in contract and accesed by
222     // `withdrawAll` and `withdrawAmountTo` methods.
223     uint256 devCut = calculateDevCut(price);
224 
225     // Transfer payment to old owner minus the developer's cut.
226     oldOwner.transfer(price.sub(devCut));
227 
228     if (excess > 0) {
229       newOwner.transfer(excess);
230     }
231   }
232 
233   /* ERC721 */
234   function implementsERC721() public view returns (bool _implements) {
235     return erc721Enabled;
236   }
237 
238   function name() public pure returns (string _name) {
239     return "CryptoAV.io";
240   }
241 
242   function symbol() public pure returns (string _symbol) {
243     return "CAV";
244   }
245 
246   function totalSupply() public view returns (uint256 _totalSupply) {
247     return listedItems.length;
248   }
249 
250   function balanceOf (address _owner) public view returns (uint256 _balance) {
251     uint256 counter = 0;
252 
253     for (uint256 i = 0; i < listedItems.length; i++) {
254       if (ownerOf(listedItems[i]) == _owner) {
255         counter++;
256       }
257     }
258 
259     return counter;
260   }
261 
262   function ownerOf (uint256 _itemId) public view returns (address _owner) {
263     return ownerOfItem[_itemId];
264   }
265 
266   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
267     uint256[] memory items = new uint256[](balanceOf(_owner));
268 
269     uint256 itemCounter = 0;
270     for (uint256 i = 0; i < listedItems.length; i++) {
271       if (ownerOf(listedItems[i]) == _owner) {
272         items[itemCounter] = listedItems[i];
273         itemCounter += 1;
274       }
275     }
276 
277     return items;
278   }
279 
280   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
281     return priceOf(_itemId) > 0;
282   }
283 
284   function approvedFor(uint256 _itemId) public view returns (address _approved) {
285     return approvedOfItem[_itemId];
286   }
287 
288   function approve(address _to, uint256 _itemId) onlyERC721() public {
289     require(msg.sender != _to);
290     require(tokenExists(_itemId));
291     require(ownerOf(_itemId) == msg.sender);
292 
293     if (_to == 0) {
294       if (approvedOfItem[_itemId] != 0) {
295         delete approvedOfItem[_itemId];
296         Approval(msg.sender, 0, _itemId);
297       }
298     } else {
299       approvedOfItem[_itemId] = _to;
300       Approval(msg.sender, _to, _itemId);
301     }
302   }
303 
304   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
305   function transfer(address _to, uint256 _itemId) onlyERC721() public {
306     require(msg.sender == ownerOf(_itemId));
307     _transfer(msg.sender, _to, _itemId);
308   }
309 
310   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
311     require(approvedFor(_itemId) == msg.sender);
312     _transfer(_from, _to, _itemId);
313   }
314 
315   function _transfer(address _from, address _to, uint256 _itemId) internal {
316     require(tokenExists(_itemId));
317     require(ownerOf(_itemId) == _from);
318     require(_to != address(0));
319     require(_to != address(this));
320 
321     ownerOfItem[_itemId] = _to;
322     approvedOfItem[_itemId] = 0;
323 
324     Transfer(_from, _to, _itemId);
325   }
326 
327   /* Read */
328   function isAdmin (address _admin) public view returns (bool _isAdmin) {
329     return admins[_admin];
330   }
331 
332   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
333     return startingPriceOfItem[_itemId];
334   }
335 
336   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
337     return priceOfItem[_itemId];
338   }
339 
340   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
341     return calculateNextPrice(priceOf(_itemId));
342   }
343 
344   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
345     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
346   }
347 
348   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
349     uint256[] memory items = new uint256[](_take);
350 
351     for (uint256 i = 0; i < _take; i++) {
352       items[i] = listedItems[_from + i];
353     }
354 
355     return items;
356   }
357 
358   /* Util */
359   function isContract(address addr) internal view returns (bool) {
360     uint size;
361     assembly { size := extcodesize(addr) } // solium-disable-line
362     return size > 0;
363   }
364   
365   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
366     require(_price > 0);
367     require(admins[ownerOfItem[_itemId]]);
368     priceOfItem[_itemId] = _price * min_value;
369   }
370   
371   function issueCard(uint256 l, uint256 r, uint256 price) onlyAdmins() public {
372     for (uint256 i = l; i <= r; i++) {
373       ownerOfItem[i] = msg.sender;
374       priceOfItem[i] = price * min_value;
375       listedItems.push(i);
376     }      
377   }  
378 }
379 
380 interface IItemRegistry {
381   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
382   function ownerOf (uint256 _itemId) public view returns (address _owner);
383   function priceOf (uint256 _itemId) public view returns (uint256 _price);
384 }