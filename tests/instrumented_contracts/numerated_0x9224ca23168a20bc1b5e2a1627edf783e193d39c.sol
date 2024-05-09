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
55   bool private erc721Enabled = false;
56 
57   uint256 private increaseLimit1 = 0.02 ether;
58   uint256 private increaseLimit2 = 0.5 ether;
59   uint256 private increaseLimit3 = 2.0 ether;
60   uint256 private increaseLimit4 = 5.0 ether;
61 
62   uint256[] private listedItems;
63   mapping (uint256 => address) private ownerOfItem;
64   mapping (uint256 => uint256) private startingPriceOfItem;
65   mapping (uint256 => uint256) private priceOfItem;
66   mapping (uint256 => address) private approvedOfItem;
67 
68   function ItemToken () public {
69     owner = msg.sender;
70     admins[owner] = true;
71   }
72 
73   /* Modifiers */
74   modifier onlyOwner() {
75     require(owner == msg.sender);
76     _;
77   }
78 
79   modifier onlyAdmins() {
80     require(admins[msg.sender]);
81     _;
82   }
83 
84   modifier onlyERC721() {
85     require(erc721Enabled);
86     _;
87   }
88 
89   /* Owner */
90   function setOwner (address _owner) onlyOwner() public {
91     owner = _owner;
92   }
93 
94   function addAdmin (address _admin) onlyOwner() public {
95     admins[_admin] = true;
96   }
97 
98   function removeAdmin (address _admin) onlyOwner() public {
99     delete admins[_admin];
100   }
101 
102   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
103   function enableERC721 () onlyOwner() public {
104     erc721Enabled = true;
105   }
106 
107   /* Withdraw */
108   /*
109     NOTICE: These functions withdraw the developer's cut which is left
110     in the contract by `buy`. User funds are immediately sent to the old
111     owner in `buy`, no user funds are left in the contract.
112   */
113   function withdrawAll () onlyOwner() public {
114     owner.transfer(this.balance);
115   }
116 
117   function withdrawAmount (uint256 _amount) onlyOwner() public {
118     owner.transfer(_amount);
119   }
120 
121   /* Listing */
122   function listMultipleItems (uint256[] _itemIds, uint256 _price, address _owner) onlyAdmins() external {
123     for (uint256 i = 0; i < _itemIds.length; i++) {
124       listItem(_itemIds[i], _price, _owner);
125     }
126   }
127 
128   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyAdmins() public {
129     require(_price > 0);
130     require(priceOfItem[_itemId] == 0);
131     require(ownerOfItem[_itemId] == address(0));
132 
133     ownerOfItem[_itemId] = _owner;
134     priceOfItem[_itemId] = _price;
135     startingPriceOfItem[_itemId] = _price;
136     listedItems.push(_itemId);
137   }
138 
139   /* Buying */
140   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
141     if (_price < increaseLimit1) {
142       return _price.mul(200).div(95);
143     } else if (_price < increaseLimit2) {
144       return _price.mul(135).div(96);
145     } else if (_price < increaseLimit3) {
146       return _price.mul(125).div(97);
147     } else if (_price < increaseLimit4) {
148       return _price.mul(117).div(97);
149     } else {
150       return _price.mul(115).div(98);
151     }
152   }
153 
154   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
155     if (_price < increaseLimit1) {
156       return _price.mul(5).div(100); // 5%
157     } else if (_price < increaseLimit2) {
158       return _price.mul(4).div(100); // 4%
159     } else if (_price < increaseLimit3) {
160       return _price.mul(3).div(100); // 3%
161     } else if (_price < increaseLimit4) {
162       return _price.mul(3).div(100); // 3%
163     } else {
164       return _price.mul(2).div(100); // 2%
165     }
166   }
167 
168   /*
169      Buy a country directly from the contract for the calculated price
170      which ensures that the owner gets a profit.  All countries that
171      have been listed can be bought by this method. User funds are sent
172      directly to the previous owner and are never stored in the contract.
173   */
174   function buy (uint256 _itemId) payable public {
175     require(priceOf(_itemId) > 0);
176     require(ownerOf(_itemId) != address(0));
177     require(msg.value >= priceOf(_itemId));
178     require(ownerOf(_itemId) != msg.sender);
179     require(!isContract(msg.sender));
180     require(msg.sender != address(0));
181 
182     address oldOwner = ownerOf(_itemId);
183     address newOwner = msg.sender;
184     uint256 price = priceOf(_itemId);
185     uint256 excess = msg.value.sub(price);
186 
187     _transfer(oldOwner, newOwner, _itemId);
188     priceOfItem[_itemId] = nextPriceOf(_itemId);
189 
190     Bought(_itemId, newOwner, price);
191     Sold(_itemId, oldOwner, price);
192 
193     // Devevloper's cut which is left in contract and accesed by
194     // `withdrawAll` and `withdrawAmountTo` methods.
195     uint256 devCut = calculateDevCut(price);
196 
197     // Transfer payment to old owner minus the developer's cut.
198     oldOwner.transfer(price.sub(devCut));
199 
200     if (excess > 0) {
201       newOwner.transfer(excess);
202     }
203   }
204 
205   /* ERC721 */
206   function implementsERC721() public view returns (bool _implements) {
207     return erc721Enabled;
208   }
209 
210   function name() public pure returns (string _name) {
211     return "CryptoLeaders.app";
212   }
213 
214   function symbol() public pure returns (string _symbol) {
215     return "CLS";
216   }
217 
218   function totalSupply() public view returns (uint256 _totalSupply) {
219     return listedItems.length;
220   }
221 
222   function balanceOf (address _owner) public view returns (uint256 _balance) {
223     uint256 counter = 0;
224 
225     for (uint256 i = 0; i < listedItems.length; i++) {
226       if (ownerOf(listedItems[i]) == _owner) {
227         counter++;
228       }
229     }
230 
231     return counter;
232   }
233 
234   function ownerOf (uint256 _itemId) public view returns (address _owner) {
235     return ownerOfItem[_itemId];
236   }
237 
238   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
239     uint256[] memory items = new uint256[](balanceOf(_owner));
240 
241     uint256 itemCounter = 0;
242     for (uint256 i = 0; i < listedItems.length; i++) {
243       if (ownerOf(listedItems[i]) == _owner) {
244         items[itemCounter] = listedItems[i];
245         itemCounter += 1;
246       }
247     }
248 
249     return items;
250   }
251 
252   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
253     return priceOf(_itemId) > 0;
254   }
255 
256   function approvedFor(uint256 _itemId) public view returns (address _approved) {
257     return approvedOfItem[_itemId];
258   }
259 
260   function approve(address _to, uint256 _itemId) onlyERC721() public {
261     require(msg.sender != _to);
262     require(tokenExists(_itemId));
263     require(ownerOf(_itemId) == msg.sender);
264 
265     if (_to == 0) {
266       if (approvedOfItem[_itemId] != 0) {
267         delete approvedOfItem[_itemId];
268         Approval(msg.sender, 0, _itemId);
269       }
270     } else {
271       approvedOfItem[_itemId] = _to;
272       Approval(msg.sender, _to, _itemId);
273     }
274   }
275 
276   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
277   function transfer(address _to, uint256 _itemId) onlyERC721() public {
278     require(msg.sender == ownerOf(_itemId));
279     _transfer(msg.sender, _to, _itemId);
280   }
281 
282   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
283     require(approvedFor(_itemId) == msg.sender);
284     _transfer(_from, _to, _itemId);
285   }
286 
287   function _transfer(address _from, address _to, uint256 _itemId) internal {
288     require(tokenExists(_itemId));
289     require(ownerOf(_itemId) == _from);
290     require(_to != address(0));
291     require(_to != address(this));
292 
293     ownerOfItem[_itemId] = _to;
294     approvedOfItem[_itemId] = 0;
295 
296     Transfer(_from, _to, _itemId);
297   }
298 
299   /* Read */
300   function isAdmin (address _admin) public view returns (bool _isAdmin) {
301     return admins[_admin];
302   }
303 
304   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
305     return startingPriceOfItem[_itemId];
306   }
307 
308   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
309     return priceOfItem[_itemId];
310   }
311 
312   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
313     return calculateNextPrice(priceOf(_itemId));
314   }
315 
316   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
317     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
318   }
319 
320   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
321     uint256[] memory items = new uint256[](_take);
322 
323     for (uint256 i = 0; i < _take; i++) {
324       items[i] = listedItems[_from + i];
325     }
326 
327     return items;
328   }
329 
330   /* Util */
331   function isContract(address addr) internal view returns (bool) {
332     uint size;
333     assembly { size := extcodesize(addr) } // solium-disable-line
334     return size > 0;
335   }
336 }