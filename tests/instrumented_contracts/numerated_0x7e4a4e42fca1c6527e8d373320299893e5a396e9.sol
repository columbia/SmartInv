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
45 
46 contract ParallelWorld {
47   using SafeMath for uint256;
48 
49   event TransactionOccured(uint256 indexed _itemId, uint256 _price, address indexed _oldowner, address indexed _newowner);
50   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
51   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
52   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
53   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
54 
55   address private owner;
56   address public referraltokencontract;
57   mapping (address => bool) private admins;
58   IItemRegistry private itemRegistry;
59   bool private erc721Enabled = false;
60 
61   uint256 private increaseLimit1 = 0.02 ether;
62   uint256 private increaseLimit2 = 0.5 ether;
63   uint256 private increaseLimit3 = 2.0 ether;
64   uint256 private increaseLimit4 = 5.0 ether;
65 
66   uint256 public enddate = 1531673100; //World Cup Finals game end date/time
67 
68   uint256[] private listedItems;
69   mapping (uint256 => address) private ownerOfItem;
70   mapping (uint256 => uint256) private startingPriceOfItem;
71   mapping (uint256 => uint256) private priceOfItem;
72   mapping (uint256 => address) private approvedOfItem;
73   mapping (uint256 => bytes32) private nameofItem;
74 
75   mapping (address => bytes32) private ownerAlias;
76   mapping (address => bytes32) private ownerEmail;
77   mapping (address => bytes32) private ownerPhone;
78 
79   function ParallelWorld () public {
80     owner = msg.sender;
81     admins[owner] = true;
82   }
83 
84   /* Modifiers */
85   modifier onlyOwner() {
86     require(owner == msg.sender);
87     _;
88   }
89 
90   modifier onlyAdmins() {
91     require(admins[msg.sender]);
92     _;
93   }
94 
95   modifier onlyERC721() {
96     require(erc721Enabled);
97     _;
98   }
99 
100   /* Owner */
101   function setOwner (address _owner) onlyOwner() public {
102     owner = _owner;
103   }
104 
105   function getOwner() public view returns (address){
106     return owner;
107   }
108 
109   function setReferralTokenContract (address _referraltokencontract) onlyOwner() public {
110     referraltokencontract = _referraltokencontract;
111   }
112 
113   function setItemRegistry (address _itemRegistry) onlyOwner() public {
114     itemRegistry = IItemRegistry(_itemRegistry);
115   }
116 
117   function addAdmin (address _admin) onlyOwner() public {
118     admins[_admin] = true;
119   }
120 
121   function removeAdmin (address _admin) onlyOwner() public {
122     delete admins[_admin];
123   }
124 
125   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
126   function enableERC721 () onlyOwner() public {
127     erc721Enabled = true;
128   }
129 
130 
131   //award prize to winner, and developer already took 10% from individual transactions
132   function awardprize(uint256 _itemId) onlyOwner() public{
133     uint256 winneramount;
134 
135     winneramount = this.balance;
136 
137     if (ownerOf(_itemId) != address(this))
138     {
139       //winner gets the prize amount minus developer cut
140       ownerOf(_itemId).transfer(winneramount);
141     }
142     
143 
144   }
145 
146   /* Listing */
147   function populateFromItemRegistry (uint256[] _itemIds) onlyOwner() public {
148     for (uint256 i = 0; i < _itemIds.length; i++) {
149       if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
150         continue;
151       }
152 
153       listItemFromRegistry(_itemIds[i]);
154     }
155   }
156 
157   function listItemFromRegistry (uint256 _itemId) onlyOwner() public {
158     require(itemRegistry != address(0));
159     require(itemRegistry.ownerOf(_itemId) != address(0));
160     require(itemRegistry.priceOf(_itemId) > 0);
161     require(itemRegistry.nameOf(_itemId).length > 0 );
162 
163     uint256 price = itemRegistry.priceOf(_itemId);
164     address itemOwner = itemRegistry.ownerOf(_itemId);
165     bytes32 nameofItemlocal = itemRegistry.nameOf(_itemId);
166     listItem(_itemId, price, itemOwner, nameofItemlocal);
167   }
168 
169   function listMultipleItems (uint256[] _itemIds, uint256[] _price, address _owner, bytes32[] _nameofItem) onlyAdmins() external {
170     for (uint256 i = 0; i < _itemIds.length; i++) {
171       listItem(_itemIds[i], _price[i], _owner, _nameofItem[i]);
172     }
173   }
174 
175   function listItem (uint256 _itemId, uint256 _price, address _owner, bytes32 _nameofItem) onlyAdmins() public {
176     require(_price > 0);
177     require(priceOfItem[_itemId] == 0);
178     require(ownerOfItem[_itemId] == address(0));
179     
180 
181     ownerOfItem[_itemId] = this; //set the contract as original owner of teams
182     priceOfItem[_itemId] = _price;
183     startingPriceOfItem[_itemId] = _price;
184     nameofItem[_itemId] = _nameofItem;
185     listedItems.push(_itemId);
186   }
187 
188   function addItem(uint256 _itemId, uint256 _price) onlyAdmins() public returns (uint256 _pricereturn){
189     priceOfItem[_itemId] = _price;
190     return priceOfItem[_itemId];
191   }
192 
193   /* Buying */
194   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
195     if (_price < increaseLimit1) {
196       return _price.mul(210).div(100); //added 110%
197     } else if (_price < increaseLimit2) {
198       return _price.mul(140).div(100); //added 40%
199     } else if (_price < increaseLimit3) {
200       return _price.mul(128).div(100); //added 28%
201     } else if (_price < increaseLimit4) {
202       return _price.mul(120).div(100); //added 20%
203     } else {
204       return _price.mul(117).div(100); //added 17%
205     }
206   }
207 
208   function calculatePrizeCut (uint256 _price) public view returns (uint256 _devCut) {
209     if (_price < increaseLimit1) {
210       return _price.mul(26).div(100); // 26%
211     } else if (_price < increaseLimit2) {
212       return _price.mul(14).div(100); // 14%
213     } else if (_price < increaseLimit3) {
214       return _price.mul(10).div(100); // 10%
215     } else if (_price < increaseLimit4) {
216       return _price.mul(8).div(100); // 8%
217     } else {
218       return _price.mul(7).div(100); // 7%
219     }
220   }
221 
222   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
223     return _price.mul(10).div(100); //10%
224   }
225 
226 
227   function buy (uint256 _itemId) payable public {
228     require(priceOf(_itemId) > 0);
229     require(ownerOf(_itemId) != address(0));
230     require(msg.value >= nextPriceOf(_itemId));
231     require(ownerOf(_itemId) != msg.sender);
232     require(!isContract(msg.sender));
233     require(msg.sender != address(0));
234     require(now < enddate); //team buying can only happen before end date
235 
236     address oldOwner = ownerOf(_itemId);
237     address newOwner = msg.sender;
238     uint256 price = priceOf(_itemId);
239     
240     _transfer(oldOwner, newOwner, _itemId);
241     priceOfItem[_itemId] = nextPriceOf(_itemId);
242     
243     uint256 excess = msg.value.sub(priceOfItem[_itemId]);
244 
245     TransactionOccured(_itemId, priceOfItem[_itemId], oldOwner, newOwner);
246 
247     // Transfer payment to old owner minus the cut for the final prize.  Don't transfer funds though if old owner is this contract
248     if (oldOwner != address(this))
249     {
250       uint256 pricedifference = priceOfItem[_itemId].sub(price);
251       //send to old owner,the original amount they paid, plus 20% of the price difference between what they paid and new owner pays
252       uint256 oldOwnercut = priceOfItem[_itemId].sub(pricedifference.mul(80).div(100));
253       oldOwner.transfer(oldOwnercut);
254       
255       //send to developer, 10% of price diff
256       owner.transfer(calculateDevCut(pricedifference));
257     
258     }
259     else
260     {
261       //first transaction to purchase from contract, send 10% of tx to dev
262       owner.transfer(calculateDevCut(msg.value));
263     
264     }
265 
266     if (excess > 0) {
267       newOwner.transfer(excess);
268     }
269     
270   }
271 
272   /* ERC721 */
273   function implementsERC721() public view returns (bool _implements) {
274     return erc721Enabled;
275   }
276 
277   function name() public pure returns (string _name) {
278     return "Parallel World Cup";
279   }
280 
281   function symbol() public pure returns (string _symbol) {
282     return "PWC";
283   }
284 
285   function totalSupply() public view returns (uint256 _totalSupply) {
286     return listedItems.length;
287   }
288 
289   function balanceOf (address _owner) public view returns (uint256 _balance) {
290     uint256 counter = 0;
291 
292     for (uint256 i = 0; i < listedItems.length; i++) {
293       if (ownerOf(listedItems[i]) == _owner) {
294         counter++;
295       }
296     }
297 
298     return counter;
299   }
300 
301   function ownerOf (uint256 _itemId) public view returns (address _owner) {
302     return ownerOfItem[_itemId];
303   }
304 
305   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
306     uint256[] memory items = new uint256[](balanceOf(_owner));
307 
308     uint256 itemCounter = 0;
309     for (uint256 i = 0; i < listedItems.length; i++) {
310       if (ownerOf(listedItems[i]) == _owner) {
311         items[itemCounter] = listedItems[i];
312         itemCounter += 1;
313       }
314     }
315 
316     return items;
317   }
318 
319   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
320     return priceOf(_itemId) > 0;
321   }
322 
323   function approvedFor(uint256 _itemId) public view returns (address _approved) {
324     return approvedOfItem[_itemId];
325   }
326 
327   function approve(address _to, uint256 _itemId) onlyERC721() public {
328     require(msg.sender != _to);
329     require(tokenExists(_itemId));
330     require(ownerOf(_itemId) == msg.sender);
331 
332     if (_to == 0) {
333       if (approvedOfItem[_itemId] != 0) {
334         delete approvedOfItem[_itemId];
335         Approval(msg.sender, 0, _itemId);
336       }
337     } else {
338       approvedOfItem[_itemId] = _to;
339       Approval(msg.sender, _to, _itemId);
340     }
341   }
342 
343   /* Transferring a team to another owner will entitle the new owner the profits from `buy` */
344   function transfer(address _to, uint256 _itemId) onlyERC721() public {
345     require(msg.sender == ownerOf(_itemId));
346     _transfer(msg.sender, _to, _itemId);
347   }
348 
349   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
350     require(approvedFor(_itemId) == msg.sender);
351     _transfer(_from, _to, _itemId);
352   }
353 
354   function _transfer(address _from, address _to, uint256 _itemId) internal {
355     require(tokenExists(_itemId));
356     require(ownerOf(_itemId) == _from);
357     require(_to != address(0));
358     require(_to != address(this));
359 
360     ownerOfItem[_itemId] = _to;
361     approvedOfItem[_itemId] = 0;
362 
363     Transfer(_from, _to, _itemId);
364   }
365 
366   function setownerInfo(address _ownerAddress, bytes32 _ownerAlias, bytes32 _ownerEmail, bytes32 _ownerPhone) public
367   {
368       ownerAlias[_ownerAddress] = _ownerAlias;
369       ownerEmail[_ownerAddress] = _ownerEmail;
370       ownerPhone[_ownerAddress] = _ownerPhone;
371   }
372 
373   /* Read */
374   function isAdmin (address _admin) public view returns (bool _isAdmin) {
375     return admins[_admin];
376   }
377 
378   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
379     return startingPriceOfItem[_itemId];
380   }
381 
382   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
383     return priceOfItem[_itemId];
384   }
385 
386   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
387     return calculateNextPrice(priceOf(_itemId));
388   }
389 
390   function nameOf (uint256 _itemId) public view returns (bytes32 _name) {
391     return nameofItem[_itemId];
392   }
393 
394   function allOf (uint256 _itemId) external view returns (uint256 _itemIdreturn, address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice, bytes32 _name) {
395     return (_itemId, ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId), nameOf(_itemId));
396   }
397 
398   function getenddate () public view returns (uint256 _enddate) {
399     return enddate;
400   }
401 
402   function getlistedItems() external view returns(uint256[] _listedItems){
403     return(listedItems);
404   }
405 
406   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
407     uint256[] memory items = new uint256[](_take);
408 
409     for (uint256 i = 0; i < _take; i++) {
410       items[i] = listedItems[_from + i];
411     }
412 
413     return items;
414   }
415 
416   function getprizeamount() public view returns(uint256 _prizeamount)
417   {
418     return this.balance;
419   }
420 
421   function getownerInfo (address _owner) public view returns (bytes32 _name, bytes32 _email, bytes32 _phone) {
422     return (ownerAlias[_owner], ownerEmail[_owner], ownerPhone[_owner]);
423   }
424 
425   /* Util */
426   function isContract(address addr) internal view returns (bool) {
427     uint size;
428     assembly { size := extcodesize(addr) } // solium-disable-line
429     return size > 0;
430   }
431 
432   
433 }
434 
435 interface IItemRegistry {
436   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
437   function ownerOf (uint256 _itemId) public view returns (address _owner);
438   function priceOf (uint256 _itemId) public view returns (uint256 _price);
439   function nameOf (uint256 _itemId) public view returns (bytes32 _nameofItemlocal);
440 }