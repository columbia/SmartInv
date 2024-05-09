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
45 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
46 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
47 contract ERC721 {
48     // Required methods
49     function totalSupply() public view returns (uint256 total);
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function ownerOf(uint256 _tokenId) public view returns (address owner);
52     function approve(address _to, uint256 _tokenId) public;
53     function transfer(address _to, uint256 _tokenId) public;
54     function transferFrom(address _from, address _to, uint256 _tokenId) public;
55 
56     // Events
57     event Transfer(address from, address to, uint256 tokenId);
58     event Approval(address owner, address approved, uint256 tokenId);
59 
60     // Optional
61     // function name() public view returns (string name);
62     // function symbol() public view returns (string symbol);
63     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
64     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
65 
66     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
67     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
68 }
69 
70 contract CryptoWuxiaVoting is ERC721{
71   using SafeMath for uint256;
72 
73   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
74   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
75   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
76   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
77 
78   address private owner;
79   mapping (address => bool) private admins;
80   IItemRegistry private itemRegistry;
81 
82   uint256 private increaseLimit1 = 0.01 ether;
83   uint256 private increaseLimit2 = 0.1 ether;
84   uint256 private increaseLimit3 = 1.0 ether;
85   uint256 private increaseLimit4 = 5.0 ether;
86   uint256 private canBuy = 1;
87 
88   uint256[] private listedItems;
89   mapping (uint256 => address) private ownerOfItem;
90   mapping (uint256 => uint256) private priceOfItem;
91   /* if some one buy a card, how much he will win*/
92   mapping (uint256 => uint256) private profitOfItem;
93   mapping (uint256 => address) private approvedOfItem;
94 
95   function CryptoWuxiaVoting () public {
96     owner = msg.sender;
97     admins[owner] = true;
98   }
99 
100   /* Modifiers */
101   modifier onlyOwner() {
102     require(owner == msg.sender);
103     _;
104   }
105 
106   modifier onlyAdmins() {
107     require(admins[msg.sender]);
108     _;
109   }
110 
111   /* Owner */
112   function setOwner (address _owner) onlyOwner() public {
113     owner = _owner;
114   }
115 
116   function setItemRegistry (address _itemRegistry) onlyOwner() public {
117     itemRegistry = IItemRegistry(_itemRegistry);
118   }
119 
120   function addAdmin (address _admin) onlyOwner() public {
121     admins[_admin] = true;
122   }
123 
124   function removeAdmin (address _admin) onlyOwner() public {
125     delete admins[_admin];
126   }
127 
128   /* when vote end, we need stop buy to frozen the result.*/
129   function stopBuy () onlyOwner() public {
130     canBuy = 0;
131   }
132 
133   function startBuy () onlyOwner() public {
134     canBuy = 1;
135   }
136   /* Withdraw */
137   /*
138     NOTICE: These functions withdraw the developer's cut which is left
139     in the contract by `buy`. User funds are immediately sent to the old
140     owner in `buy`, no user funds are left in the contract.
141   */
142   function withdrawAll () onlyAdmins() public {
143    msg.sender.transfer(this.balance);
144   }
145 
146   function withdrawAmount (uint256 _amount) onlyAdmins() public {
147     msg.sender.transfer(_amount);
148   }
149 
150   /* Listing */
151   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
152     for (uint256 i = 0; i < _itemIds.length; i++) {
153       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
154         continue;
155       }
156       listItemFromRegistry(_itemIds[i]);
157     }
158   }
159 
160   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
161     require(itemRegistry != address(0));
162     require(itemRegistry.ownerOf(_itemId) != address(0));
163     require(itemRegistry.priceOf(_itemId) > 0);
164 
165     uint256 price = itemRegistry.priceOf(_itemId);
166     address itemOwner = itemRegistry.ownerOf(_itemId);
167     listItem(_itemId, price, itemOwner);
168   }
169 
170   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
171     for (uint256 i = 0; i < _itemIds.length; i++) {
172       listItem(_itemIds[i], _price, _owner);
173     }
174   }
175 
176   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
177     require(_price > 0);
178     require(priceOfItem[_itemId] == 0);
179     require(ownerOfItem[_itemId] == address(0));
180 
181     ownerOfItem[_itemId] = _owner;
182     priceOfItem[_itemId] = _price;
183     listedItems.push(_itemId);
184   }
185 
186   /* Buying */
187   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
188     if (_price < increaseLimit1) {
189       return _price.mul(200).div(100);
190     } else if (_price < increaseLimit2) {
191       return _price.mul(150).div(100);
192     } else if (_price < increaseLimit3) {
193       return _price.mul(130).div(100);
194     } else if (_price < increaseLimit4) {
195       return _price.mul(120).div(100);
196     } else {
197       return _price.mul(110).div(100);
198     }
199   }
200 
201 
202   function calculateDevCut (uint256 _profit) public view returns (uint256 _devCut) {
203     // dev got 80 percent of profit, and then send to top voter
204     return _profit.mul(80).div(100);
205   }
206 
207   /*
208      Buy a country directly from the contract for the calculated price
209      which ensures that the owner gets a profit.  All countries that
210      have been listed can be bought by this method. User funds are sent
211      directly to the previous owner and are never stored in the contract.
212   */
213   function buy (uint256 _itemId) payable public {
214     require(priceOf(_itemId) > 0);
215     require(ownerOf(_itemId) != address(0));
216     require(msg.value >= priceOf(_itemId));
217     require(ownerOf(_itemId) != msg.sender);
218     require(!isContract(msg.sender));
219     require(msg.sender != address(0));
220     require(canBuy > 0);
221 
222     address oldOwner = ownerOf(_itemId);
223     address newOwner = msg.sender;
224     uint256 price = priceOf(_itemId);
225     uint256 profit = profitOfItem[_itemId];
226     uint256 excess = msg.value.sub(price);
227 
228     _transfer(oldOwner, newOwner, _itemId);
229 
230     // update price and profit
231     uint256 next_price = nextPriceOf(_itemId);
232     priceOfItem[_itemId] = next_price;
233     uint256 next_profit = next_price - price;
234     profitOfItem[_itemId] = next_profit;
235 
236     Bought(_itemId, newOwner, price);
237     Sold(_itemId, oldOwner, price);
238 
239     // Devevloper's cut which is left in contract and accesed by
240     // `withdrawAll` and `withdrawAmountTo` methods.
241     uint256 devCut = calculateDevCut(profit);
242 
243     // Transfer payment to old owner minus the developer's cut.
244     oldOwner.transfer(price.sub(devCut));
245 
246     if (excess > 0) {
247       newOwner.transfer(excess);
248     }
249   }
250 
251   /* ERC721 */
252 
253   function name() public view returns (string name) {
254     return "Ethwuxia.pro";
255   }
256 
257   function symbol() public view returns (string symbol) {
258     return "EWX";
259   }
260 
261   function totalSupply() public view returns (uint256 _totalSupply) {
262     return listedItems.length;
263   }
264 
265   function balanceOf (address _owner) public view returns (uint256 _balance) {
266     uint256 counter = 0;
267 
268     for (uint256 i = 0; i < listedItems.length; i++) {
269       if (ownerOf(listedItems[i]) == _owner) {
270         counter++;
271       }
272     }
273 
274     return counter;
275   }
276 
277   function ownerOf (uint256 _itemId) public view returns (address _owner) {
278     return ownerOfItem[_itemId];
279   }
280 
281   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
282     uint256[] memory items = new uint256[](balanceOf(_owner));
283 
284     uint256 itemCounter = 0;
285     for (uint256 i = 0; i < listedItems.length; i++) {
286       if (ownerOf(listedItems[i]) == _owner) {
287         items[itemCounter] = listedItems[i];
288         itemCounter += 1;
289       }
290     }
291 
292     return items;
293   }
294 
295   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
296     return priceOf(_itemId) > 0;
297   }
298 
299   function approvedFor(uint256 _itemId) public view returns (address _approved) {
300     return approvedOfItem[_itemId];
301   }
302 
303   function approve(address _to, uint256 _itemId) public {
304     require(msg.sender != _to);
305     require(tokenExists(_itemId));
306     require(ownerOf(_itemId) == msg.sender);
307 
308     if (_to == 0) {
309       if (approvedOfItem[_itemId] != 0) {
310         delete approvedOfItem[_itemId];
311         Approval(msg.sender, 0, _itemId);
312       }
313     } else {
314       approvedOfItem[_itemId] = _to;
315       Approval(msg.sender, _to, _itemId);
316     }
317   }
318 
319   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
320   function transfer(address _to, uint256 _itemId) public {
321     require(msg.sender == ownerOf(_itemId));
322     _transfer(msg.sender, _to, _itemId);
323   }
324 
325   function transferFrom(address _from, address _to, uint256 _itemId) public {
326     require(approvedFor(_itemId) == msg.sender);
327     _transfer(_from, _to, _itemId);
328   }
329 
330   function _transfer(address _from, address _to, uint256 _itemId) internal {
331     require(tokenExists(_itemId));
332     require(ownerOf(_itemId) == _from);
333     require(_to != address(0));
334     require(_to != address(this));
335 
336     ownerOfItem[_itemId] = _to;
337     approvedOfItem[_itemId] = 0;
338 
339     Transfer(_from, _to, _itemId);
340   }
341 
342   /* Read */
343   function isAdmin (address _admin) public view returns (bool _isAdmin) {
344     return admins[_admin];
345   }
346 
347   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
348     return priceOfItem[_itemId];
349   }
350 
351   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
352     return calculateNextPrice(priceOf(_itemId));
353   }
354 
355   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
356     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
357   }
358 
359   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
360     uint256[] memory items = new uint256[](_take);
361 
362     for (uint256 i = 0; i < _take; i++) {
363       items[i] = listedItems[_from + i];
364     }
365 
366     return items;
367   }
368 
369   /* Util */
370   function isContract(address addr) internal view returns (bool) {
371     uint size;
372     assembly { size := extcodesize(addr) } // solium-disable-line
373     return size > 0;
374   }
375 
376   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
377     require(_price > 0);
378     require(admins[ownerOfItem[_itemId]]);
379     priceOfItem[_itemId] = _price;
380   }
381 
382   function issueCard(uint256 l, uint256 r, uint256 price) onlyAdmins() public {
383     for (uint256 i = l; i <= r; i++) {
384       ownerOfItem[i] = msg.sender;
385       priceOfItem[i] = price;
386       listedItems.push(i);
387     }
388    }
389 }
390 
391 interface IItemRegistry {
392   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
393   function ownerOf (uint256 _itemId) public view returns (address _owner);
394   function priceOf (uint256 _itemId) public view returns (uint256 _price);
395 }