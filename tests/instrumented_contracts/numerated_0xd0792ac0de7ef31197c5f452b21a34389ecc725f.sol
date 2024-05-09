1 pragma solidity ^0.4.19;
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
70 contract CryptoWaterMargin is ERC721{
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
92   function CryptoWaterMargin () public {
93     owner = msg.sender;
94     admins[owner] = true;    
95     issueCard(1, 6, 0.1 ether);
96   }
97 
98   /* Modifiers */
99   modifier onlyOwner() {
100     require(owner == msg.sender);
101     _;
102   }
103 
104   modifier onlyAdmins() {
105     require(admins[msg.sender]);
106     _;
107   }
108 
109   /* Owner */
110   function setOwner (address _owner) onlyOwner() public {
111     owner = _owner;
112   }
113 
114   function setItemRegistry (address _itemRegistry) onlyOwner() public {
115     itemRegistry = IItemRegistry(_itemRegistry);
116   }
117 
118   function addAdmin (address _admin) onlyOwner() public {
119     admins[_admin] = true;
120   }
121 
122   function removeAdmin (address _admin) onlyOwner() public {
123     delete admins[_admin];
124   }
125 
126   /* Withdraw */
127   /*
128     NOTICE: These functions withdraw the developer's cut which is left
129     in the contract by `buy`. User funds are immediately sent to the old
130     owner in `buy`, no user funds are left in the contract.
131   */
132   function withdrawAll () onlyAdmins() public {
133    msg.sender.transfer(this.balance);
134   }
135 
136   function withdrawAmount (uint256 _amount) onlyAdmins() public {
137     msg.sender.transfer(_amount);
138   }
139 
140   /* Listing */
141   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
142     for (uint256 i = 0; i < _itemIds.length; i++) {
143       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
144         continue;
145       }
146 
147       listItemFromRegistry(_itemIds[i]);
148     }
149   }
150 
151   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
152     require(itemRegistry != address(0));
153     require(itemRegistry.ownerOf(_itemId) != address(0));
154     require(itemRegistry.priceOf(_itemId) > 0);
155 
156     uint256 price = itemRegistry.priceOf(_itemId);
157     address itemOwner = itemRegistry.ownerOf(_itemId);
158     listItem(_itemId, price, itemOwner);
159   }
160 
161   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
162     for (uint256 i = 0; i < _itemIds.length; i++) {
163       listItem(_itemIds[i], _price, _owner);
164     }
165   }
166 
167   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
168     require(_price > 0);
169     require(priceOfItem[_itemId] == 0);
170     require(ownerOfItem[_itemId] == address(0));
171 
172     ownerOfItem[_itemId] = _owner;
173     priceOfItem[_itemId] = _price;
174     listedItems.push(_itemId);
175   }
176 
177   /* Buying */
178   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
179     if (_price < increaseLimit1) {
180       return _price.mul(200).div(95);
181     } else if (_price < increaseLimit2) {
182       return _price.mul(135).div(96);
183     } else if (_price < increaseLimit3) {
184       return _price.mul(125).div(97);
185     } else if (_price < increaseLimit4) {
186       return _price.mul(117).div(97);
187     } else {
188       return _price.mul(115).div(98);
189     }
190   }
191 
192   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
193     if (_price < increaseLimit1) {
194       return _price.mul(5).div(100); // 5%
195     } else if (_price < increaseLimit2) {
196       return _price.mul(4).div(100); // 4%
197     } else if (_price < increaseLimit3) {
198       return _price.mul(3).div(100); // 3%
199     } else if (_price < increaseLimit4) {
200       return _price.mul(3).div(100); // 3%
201     } else {
202       return _price.mul(2).div(100); // 2%
203     }
204   }
205 
206   /*
207      Buy a country directly from the contract for the calculated price
208      which ensures that the owner gets a profit.  All countries that
209      have been listed can be bought by this method. User funds are sent
210      directly to the previous owner and are never stored in the contract.
211   */
212   function buy (uint256 _itemId) payable public {
213     require(priceOf(_itemId) > 0);
214     require(ownerOf(_itemId) != address(0));
215     require(msg.value >= priceOf(_itemId));
216     require(ownerOf(_itemId) != msg.sender);
217     require(!isContract(msg.sender));
218     require(msg.sender != address(0));
219 
220     address oldOwner = ownerOf(_itemId);
221     address newOwner = msg.sender;
222     uint256 price = priceOf(_itemId);
223     uint256 excess = msg.value.sub(price);
224 
225     _transfer(oldOwner, newOwner, _itemId);
226     priceOfItem[_itemId] = nextPriceOf(_itemId);
227 
228     Bought(_itemId, newOwner, price);
229     Sold(_itemId, oldOwner, price);
230 
231     // Devevloper's cut which is left in contract and accesed by
232     // `withdrawAll` and `withdrawAmountTo` methods.
233     uint256 devCut = calculateDevCut(price);
234 
235     // Transfer payment to old owner minus the developer's cut.
236     oldOwner.transfer(price.sub(devCut));
237 
238     if (excess > 0) {
239       newOwner.transfer(excess);
240     }
241   }
242 
243   /* ERC721 */
244 
245   function name() public view returns (string name) {
246     return "Cryptohero.pro";
247   }
248 
249   function symbol() public view returns (string symbol) {
250     return "CTH";
251   }
252 
253   function totalSupply() public view returns (uint256 _totalSupply) {
254     return listedItems.length;
255   }
256 
257   function balanceOf (address _owner) public view returns (uint256 _balance) {
258     uint256 counter = 0;
259 
260     for (uint256 i = 0; i < listedItems.length; i++) {
261       if (ownerOf(listedItems[i]) == _owner) {
262         counter++;
263       }
264     }
265 
266     return counter;
267   }
268 
269   function ownerOf (uint256 _itemId) public view returns (address _owner) {
270     return ownerOfItem[_itemId];
271   }
272 
273   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
274     uint256[] memory items = new uint256[](balanceOf(_owner));
275 
276     uint256 itemCounter = 0;
277     for (uint256 i = 0; i < listedItems.length; i++) {
278       if (ownerOf(listedItems[i]) == _owner) {
279         items[itemCounter] = listedItems[i];
280         itemCounter += 1;
281       }
282     }
283 
284     return items;
285   }
286 
287   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
288     return priceOf(_itemId) > 0;
289   }
290 
291   function approvedFor(uint256 _itemId) public view returns (address _approved) {
292     return approvedOfItem[_itemId];
293   }
294 
295   function approve(address _to, uint256 _itemId) public {
296     require(msg.sender != _to);
297     require(tokenExists(_itemId));
298     require(ownerOf(_itemId) == msg.sender);
299 
300     if (_to == 0) {
301       if (approvedOfItem[_itemId] != 0) {
302         delete approvedOfItem[_itemId];
303         Approval(msg.sender, 0, _itemId);
304       }
305     } else {
306       approvedOfItem[_itemId] = _to;
307       Approval(msg.sender, _to, _itemId);
308     }
309   }
310 
311   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
312   function transfer(address _to, uint256 _itemId) public {
313     require(msg.sender == ownerOf(_itemId));
314     _transfer(msg.sender, _to, _itemId);
315   }
316 
317   function transferFrom(address _from, address _to, uint256 _itemId) public {
318     require(approvedFor(_itemId) == msg.sender);
319     _transfer(_from, _to, _itemId);
320   }
321 
322   function _transfer(address _from, address _to, uint256 _itemId) internal {
323     require(tokenExists(_itemId));
324     require(ownerOf(_itemId) == _from);
325     require(_to != address(0));
326     require(_to != address(this));
327 
328     ownerOfItem[_itemId] = _to;
329     approvedOfItem[_itemId] = 0;
330 
331     Transfer(_from, _to, _itemId);
332   }
333 
334   /* Read */
335   function isAdmin (address _admin) public view returns (bool _isAdmin) {
336     return admins[_admin];
337   }
338 
339   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
340     return priceOfItem[_itemId];
341   }
342 
343   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
344     return calculateNextPrice(priceOf(_itemId));
345   }
346 
347   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
348     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
349   }
350 
351   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
352     uint256[] memory items = new uint256[](_take);
353 
354     for (uint256 i = 0; i < _take; i++) {
355       items[i] = listedItems[_from + i];
356     }
357 
358     return items;
359   }
360 
361   /* Util */
362   function isContract(address addr) internal view returns (bool) {
363     uint size;
364     assembly { size := extcodesize(addr) } // solium-disable-line
365     return size > 0;
366   }
367   
368   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
369     require(_price > 0);
370     require(admins[ownerOfItem[_itemId]]);
371     priceOfItem[_itemId] = _price;
372   }
373   
374   function issueCard(uint256 l, uint256 r, uint256 price) onlyAdmins() public {
375     for (uint256 i = l; i <= r; i++) {
376       ownerOfItem[i] = msg.sender;
377       priceOfItem[i] = price;
378       listedItems.push(i);
379     }      
380    }  
381 }   
382 
383 interface IItemRegistry {
384   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
385   function ownerOf (uint256 _itemId) public view returns (address _owner);
386   function priceOf (uint256 _itemId) public view returns (uint256 _price);
387 }