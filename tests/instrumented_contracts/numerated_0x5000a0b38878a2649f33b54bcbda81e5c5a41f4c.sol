1 pragma solidity ^0.4.19;
2 
3 
4 library SafeMath {
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
61     function name() public view returns (string _name);
62     function symbol() public view returns (string _symbol);
63     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
64     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
65 
66     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
67     // function supportsInterface(bytes4 _interfaceID) external view returns (bool);
68 }
69 
70 contract CryptoMotors is ERC721{
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
82   uint256 private increaseLimit1 = 0.02 ether;
83   uint256 private increaseLimit2 = 0.5 ether;
84   uint256 private increaseLimit3 = 2.0 ether;
85   uint256 private increaseLimit4 = 5.0 ether;
86 
87   uint256[] private listedItems;
88   mapping (uint256 => address) private ownerOfItem;
89   mapping (uint256 => uint256) private priceOfItem;
90   mapping (uint256 => address) private approvedOfItem;
91 
92   function CryptoMotors () public {
93     owner = msg.sender;
94     admins[owner] = true;    
95     issueCards(1, 4, 0.1 ether);
96     issueCards(5, 7, 0.4 ether);
97   }
98 
99   /* Modifiers */
100   modifier onlyOwner() {
101     require(owner == msg.sender);
102     _;
103   }
104 
105   modifier onlyAdmins() {
106     require(admins[msg.sender]);
107     _;
108   }
109 
110   /* Owner */
111   function setOwner (address _owner) onlyOwner() public {
112     owner = _owner;
113   }
114 
115   function setItemRegistry (address _itemRegistry) onlyOwner() public {
116     itemRegistry = IItemRegistry(_itemRegistry);
117   }
118 
119   function addAdmin (address _admin) onlyOwner() public {
120     admins[_admin] = true;
121   }
122 
123   function removeAdmin (address _admin) onlyOwner() public {
124     delete admins[_admin];
125   }
126 
127   /* Withdraw */
128   /*
129     NOTICE: These functions withdraw the developer's cut which is left
130     in the contract by `buy`. User funds are immediately sent to the old
131     owner in `buy`, no user funds are left in the contract.
132   */
133   function withdrawAll () onlyAdmins() public {
134    msg.sender.transfer(this.balance);
135   }
136 
137   function withdrawAmount (uint256 _amount) onlyAdmins() public {
138     msg.sender.transfer(_amount);
139   }
140 
141   /* Listing */
142   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
143     for (uint256 i = 0; i < _itemIds.length; i++) {
144       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
145         continue;
146       }
147 
148       listItemFromRegistry(_itemIds[i]);
149     }
150   }
151 
152   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
153     require(itemRegistry != address(0));
154     require(itemRegistry.ownerOf(_itemId) != address(0));
155     require(itemRegistry.priceOf(_itemId) > 0);
156 
157     uint256 price = itemRegistry.priceOf(_itemId);
158     address itemOwner = itemRegistry.ownerOf(_itemId);
159     listItem(_itemId, price, itemOwner);
160   }
161 
162   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
163     for (uint256 i = 0; i < _itemIds.length; i++) {
164       listItem(_itemIds[i], _price, _owner);
165     }
166   }
167 
168   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
169     require(_price > 0);
170     require(priceOfItem[_itemId] == 0);
171     require(ownerOfItem[_itemId] == address(0));
172 
173     ownerOfItem[_itemId] = _owner;
174     priceOfItem[_itemId] = _price;
175     listedItems.push(_itemId);
176   }
177 
178   /* Buying */
179   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
180     if (_price < increaseLimit1) {
181       return _price.mul(200).div(95);
182     } else if (_price < increaseLimit2) {
183       return _price.mul(135).div(96);
184     } else if (_price < increaseLimit3) {
185       return _price.mul(125).div(97);
186     } else if (_price < increaseLimit4) {
187       return _price.mul(117).div(97);
188     } else {
189       return _price.mul(115).div(98);
190     }
191   }
192 
193   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
194     if (_price < increaseLimit1) {
195       return _price.mul(5).div(100); // 5%
196     } else if (_price < increaseLimit2) {
197       return _price.mul(6).div(100); // 6%
198     } else if (_price < increaseLimit3) {
199       return _price.mul(4).div(100); // 4%
200     } else if (_price < increaseLimit4) {
201       return _price.mul(4).div(100); // 4%
202     } else {
203       return _price.mul(3).div(100); // 3%
204     }
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
220 
221     address oldOwner = ownerOf(_itemId);
222     address newOwner = msg.sender;
223     uint256 price = priceOf(_itemId);
224     uint256 excess = msg.value.sub(price);
225 
226     _transfer(oldOwner, newOwner, _itemId);
227     priceOfItem[_itemId] = nextPriceOf(_itemId);
228 
229     Bought(_itemId, newOwner, price);
230     Sold(_itemId, oldOwner, price);
231 
232     // Devevloper's cut which is left in contract and accesed by
233     // `withdrawAll` and `withdrawAmountTo` methods.
234     uint256 devCut = calculateDevCut(price);
235 
236     // Transfer payment to old owner minus the developer's cut.
237     oldOwner.transfer(price.sub(devCut));
238 
239     if (excess > 0) {
240       newOwner.transfer(excess);
241     }
242   }
243 
244   /* ERC721 */
245 
246   function name() public view returns (string _name) {
247     return "CryptoMotors";
248   }
249 
250   function symbol() public view returns (string _symbol) {
251     return "MOTO";
252   }
253 
254   function totalSupply() public view returns (uint256 _totalSupply) {
255     return listedItems.length;
256   }
257 
258   function balanceOf (address _owner) public view returns (uint256 _balance) {
259     uint256 counter = 0;
260 
261     for (uint256 i = 0; i < listedItems.length; i++) {
262       if (ownerOf(listedItems[i]) == _owner) {
263         counter++;
264       }
265     }
266 
267     return counter;
268   }
269 
270   function ownerOf (uint256 _itemId) public view returns (address _owner) {
271     return ownerOfItem[_itemId];
272   }
273 
274   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
275     uint256[] memory items = new uint256[](balanceOf(_owner));
276 
277     uint256 itemCounter = 0;
278     for (uint256 i = 0; i < listedItems.length; i++) {
279       if (ownerOf(listedItems[i]) == _owner) {
280         items[itemCounter] = listedItems[i];
281         itemCounter += 1;
282       }
283     }
284 
285     return items;
286   }
287 
288   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
289     return priceOf(_itemId) > 0;
290   }
291 
292   function approvedFor(uint256 _itemId) public view returns (address _approved) {
293     return approvedOfItem[_itemId];
294   }
295 
296   function approve(address _to, uint256 _itemId) public {
297     require(msg.sender != _to);
298     require(tokenExists(_itemId));
299     require(ownerOf(_itemId) == msg.sender);
300 
301     if (_to == 0) {
302       if (approvedOfItem[_itemId] != 0) {
303         delete approvedOfItem[_itemId];
304         Approval(msg.sender, 0, _itemId);
305       }
306     } else {
307       approvedOfItem[_itemId] = _to;
308       Approval(msg.sender, _to, _itemId);
309     }
310   }
311 
312   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
313   function transfer(address _to, uint256 _itemId) public {
314     require(msg.sender == ownerOf(_itemId));
315     _transfer(msg.sender, _to, _itemId);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _itemId) public {
319     require(approvedFor(_itemId) == msg.sender);
320     _transfer(_from, _to, _itemId);
321   }
322 
323   function _transfer(address _from, address _to, uint256 _itemId) internal {
324     require(tokenExists(_itemId));
325     require(ownerOf(_itemId) == _from);
326     require(_to != address(0));
327     require(_to != address(this));
328 
329     ownerOfItem[_itemId] = _to;
330     approvedOfItem[_itemId] = 0;
331 
332     Transfer(_from, _to, _itemId);
333   }
334 
335   /* Read */
336   function isAdmin (address _admin) public view returns (bool _isAdmin) {
337     return admins[_admin];
338   }
339 
340   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
341     return priceOfItem[_itemId];
342   }
343 
344   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
345     return calculateNextPrice(priceOf(_itemId));
346   }
347 
348   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
349     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
350   }
351 
352   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
353     uint256[] memory items = new uint256[](_take);
354 
355     for (uint256 i = 0; i < _take; i++) {
356       items[i] = listedItems[_from + i];
357     }
358 
359     return items;
360   }
361 
362   /* Util */
363   function isContract(address _addr) internal view returns (bool) {
364     uint size;
365     assembly { size := extcodesize(_addr) } // solium-disable-line
366     return size > 0;
367   }
368   
369   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
370     require(_price > 0);
371     require(admins[ownerOfItem[_itemId]]);
372     priceOfItem[_itemId] = _price;
373   }
374   
375   function issueCards(uint256 _from, uint256 _to, uint256 _price) public onlyAdmins() {
376     for (uint256 i = _from; i <= _to; i++) {
377       // DO NOT issue twice, block it
378       if (ownerOfItem[i] == address(0)) {
379         ownerOfItem[i] = msg.sender;
380         priceOfItem[i] = _price;
381         listedItems.push(i);
382       }
383     }      
384    }  
385 }   
386 
387 interface IItemRegistry {
388   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
389   function ownerOf (uint256 _itemId) public view returns (address _owner);
390   function priceOf (uint256 _itemId) public view returns (uint256 _price);
391 }