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
70 contract CryptoMoe is ERC721{
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
90   mapping (uint256 => uint256) private freeOfItem;
91   mapping (uint256 => address) private approvedOfItem;
92 
93   function CryptoMoe () public {
94     owner = msg.sender;
95     admins[owner] = true;    
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
193      return _price.mul(5).div(100);
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
234 
235   function name() public view returns (string name) {
236     return "cryptomoe.io";
237   }
238 
239   function symbol() public view returns (string symbol) {
240     return "CMOE";
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
285   function approve(address _to, uint256 _itemId) public {
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
302   function transfer(address _to, uint256 _itemId) public {
303     require(msg.sender == ownerOf(_itemId));
304     _transfer(msg.sender, _to, _itemId);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _itemId) public {
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
329   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
330     return priceOfItem[_itemId];
331   }
332 
333   function freeOf (uint256 _itemId) public view returns (uint256 _free) {
334     return freeOfItem[_itemId];
335   }  
336 
337   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
338     return calculateNextPrice(priceOf(_itemId));
339   }
340 
341   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice, uint256 _free) {
342     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId), freeOf(_itemId));
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
361   
362   function changePrice(uint256 _itemId, uint256 _price) {
363     require(_price >= 0);
364     require(msg.sender == ownerOfItem[_itemId]);
365     require(now >= freeOfItem[_itemId]);
366     priceOfItem[_itemId] = _price;
367   }
368   
369   function issueCard(uint256 l, uint256 r, uint256 price, uint frozen) onlyAdmins() public {
370     for (uint256 i = l; i <= r; i++) {
371       require(ownerOf(i) == address(0));
372       require(price > 0);
373       ownerOfItem[i] = msg.sender;
374       priceOfItem[i] = price;
375       freeOfItem[i] = now + frozen;
376       listedItems.push(i);
377     }      
378    }  
379 }   
380 
381 interface IItemRegistry {
382   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
383   function ownerOf (uint256 _itemId) public view returns (address _owner);
384   function priceOf (uint256 _itemId) public view returns (uint256 _price);
385 }