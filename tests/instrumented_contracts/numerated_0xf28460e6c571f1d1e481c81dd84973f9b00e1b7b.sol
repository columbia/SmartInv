1 // KpopItem is a ERC-721 item (https://github.com/ethereum/eips/issues/721)
2 // Each KpopItem has its connected KpopToken itemrity card
3 // Kpop.io is the official website
4 
5 pragma solidity ^0.4.18;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract ERC721 {
55   function approve(address _to, uint _itemId) public;
56   function balanceOf(address _owner) public view returns (uint balance);
57   function implementsERC721() public pure returns (bool);
58   function ownerOf(uint _itemId) public view returns (address addr);
59   function takeOwnership(uint _itemId) public;
60   function totalSupply() public view returns (uint total);
61   function transferFrom(address _from, address _to, uint _itemId) public;
62   function transfer(address _to, uint _itemId) public;
63 
64   event Transfer(address indexed from, address indexed to, uint itemId);
65   event Approval(address indexed owner, address indexed approved, uint itemId);
66 }
67 
68 contract KpopCeleb is ERC721 {
69   function ownerOf(uint _celebId) public view returns (address addr);
70 }
71 
72 contract KpopItem is ERC721 {
73   address public author;
74   address public coauthor;
75   address public manufacturer;
76 
77   string public constant NAME = "KpopItem";
78   string public constant SYMBOL = "KpopItem";
79 
80   uint public GROWTH_BUMP = 0.4 ether;
81   uint public MIN_STARTING_PRICE = 0.001 ether;
82   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
83   uint public DIVIDEND = 3;
84 
85   address public KPOP_CELEB_CONTRACT_ADDRESS = 0x0;
86   address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;
87 
88   struct Item {
89     string name;
90   }
91 
92   Item[] public items;
93 
94   mapping(uint => address) public itemIdToOwner;
95   mapping(uint => uint) public itemIdToPrice;
96   mapping(address => uint) public userToNumItems;
97   mapping(uint => address) public itemIdToApprovedRecipient;
98   mapping(uint => uint[6]) public itemIdToTraitValues;
99   mapping(uint => uint) public itemIdToCelebId;
100 
101   event Transfer(address indexed from, address indexed to, uint itemId);
102   event Approval(address indexed owner, address indexed approved, uint itemId);
103   event ItemSold(uint itemId, uint oldPrice, uint newPrice, string itemName, address prevOwner, address newOwner);
104   event TransferToWinner(uint itemId, uint oldPrice, uint newPrice, string itemName, address prevOwner, address newOwner);
105 
106   function KpopItem() public {
107     author = msg.sender;
108     coauthor = msg.sender;
109   }
110 
111   function _transfer(address _from, address _to, uint _itemId) private {
112     require(ownerOf(_itemId) == _from);
113     require(!isNullAddress(_to));
114     require(balanceOf(_from) > 0);
115 
116     uint prevBalances = balanceOf(_from) + balanceOf(_to);
117     itemIdToOwner[_itemId] = _to;
118     userToNumItems[_from]--;
119     userToNumItems[_to]++;
120 
121     delete itemIdToApprovedRecipient[_itemId];
122 
123     Transfer(_from, _to, _itemId);
124 
125     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
126   }
127 
128   function buy(uint _itemId) payable public {
129     address prevOwner = ownerOf(_itemId);
130     uint currentPrice = itemIdToPrice[_itemId];
131 
132     require(prevOwner != msg.sender);
133     require(!isNullAddress(msg.sender));
134     require(msg.value >= currentPrice);
135 
136     // Set dividend
137     uint dividend = uint(SafeMath.div(SafeMath.mul(currentPrice, DIVIDEND), 100));
138 
139     // Take a cut
140     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 90), 100));
141 
142     uint leftover = SafeMath.sub(msg.value, currentPrice);
143     uint newPrice;
144 
145     _transfer(prevOwner, msg.sender, _itemId);
146 
147     if (currentPrice < GROWTH_BUMP) {
148       newPrice = SafeMath.mul(currentPrice, 2);
149     } else {
150       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
151     }
152 
153     itemIdToPrice[_itemId] = newPrice;
154 
155     // Pay the prev owner of the item
156     if (prevOwner != address(this)) {
157       prevOwner.transfer(payment);
158     }
159 
160     // Pay dividend to the current owner of the celeb that's connected to the item
161     uint celebId = celebOf(_itemId);
162     KpopCeleb KPOP_CELEB = KpopCeleb(KPOP_CELEB_CONTRACT_ADDRESS);
163     address celebOwner = KPOP_CELEB.ownerOf(celebId);
164     if (celebOwner != address(this) && !isNullAddress(celebOwner)) {
165       celebOwner.transfer(dividend);
166     }
167 
168     ItemSold(_itemId, currentPrice, newPrice,
169       items[_itemId].name, prevOwner, msg.sender);
170 
171     msg.sender.transfer(leftover);
172   }
173 
174   function balanceOf(address _owner) public view returns (uint balance) {
175     return userToNumItems[_owner];
176   }
177 
178   function ownerOf(uint _itemId) public view returns (address addr) {
179     return itemIdToOwner[_itemId];
180   }
181 
182   function celebOf(uint _itemId) public view returns (uint celebId) {
183     return itemIdToCelebId[_itemId];
184   }
185 
186   function totalSupply() public view returns (uint total) {
187     return items.length;
188   }
189 
190   function transfer(address _to, uint _itemId) public {
191     _transfer(msg.sender, _to, _itemId);
192   }
193 
194   /** START FUNCTIONS FOR AUTHORS **/
195 
196   function createItem(string _name, uint _price, uint _celebId, address _owner, uint[6] _traitValues) public onlyManufacturer {
197     require(_price >= MIN_STARTING_PRICE);
198 
199     address owner = _owner == 0x0 ? author : _owner;
200     uint itemId = items.push(Item(_name)) - 1;
201     itemIdToOwner[itemId] = owner;
202     itemIdToPrice[itemId] = _price;
203     itemIdToCelebId[itemId] = _celebId;
204     itemIdToTraitValues[itemId] = _traitValues; // TODO: fetch celeb traits later
205     userToNumItems[owner]++;
206   }
207 
208   function updateItem(uint _itemId, string _name, uint[6] _traitValues) public onlyAuthors {
209     require(_itemId >= 0 && _itemId < totalSupply());
210 
211     items[_itemId].name = _name;
212     itemIdToTraitValues[_itemId] = _traitValues;
213   }
214 
215   function withdraw(uint _amount, address _to) public onlyAuthors {
216     require(!isNullAddress(_to));
217     require(_amount <= this.balance);
218 
219     _to.transfer(_amount);
220   }
221 
222   function withdrawAll() public onlyAuthors {
223     require(author != 0x0);
224     require(coauthor != 0x0);
225 
226     uint halfBalance = uint(SafeMath.div(this.balance, 2));
227 
228     author.transfer(halfBalance);
229     coauthor.transfer(halfBalance);
230   }
231 
232   function setCoAuthor(address _coauthor) public onlyAuthor {
233     require(!isNullAddress(_coauthor));
234 
235     coauthor = _coauthor;
236   }
237 
238   function setManufacturer(address _manufacturer) public onlyAuthors {
239     require(!isNullAddress(_manufacturer));
240 
241     manufacturer = _manufacturer;
242   }
243 
244   /** END FUNCTIONS FOR AUTHORS **/
245 
246   function getItem(uint _itemId) public view returns (
247     string name,
248     uint price,
249     address owner,
250     uint[6] traitValues,
251     uint celebId
252   ) {
253     name = items[_itemId].name;
254     price = itemIdToPrice[_itemId];
255     owner = itemIdToOwner[_itemId];
256     traitValues = itemIdToTraitValues[_itemId];
257     celebId = celebOf(_itemId);
258   }
259 
260   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
261 
262   function approve(address _to, uint _itemId) public {
263     require(msg.sender == ownerOf(_itemId));
264 
265     itemIdToApprovedRecipient[_itemId] = _to;
266 
267     Approval(msg.sender, _to, _itemId);
268   }
269 
270   function transferFrom(address _from, address _to, uint _itemId) public {
271     require(ownerOf(_itemId) == _from);
272     require(isApproved(_to, _itemId));
273     require(!isNullAddress(_to));
274 
275     _transfer(_from, _to, _itemId);
276   }
277 
278   function takeOwnership(uint _itemId) public {
279     require(!isNullAddress(msg.sender));
280     require(isApproved(msg.sender, _itemId));
281 
282     address currentOwner = itemIdToOwner[_itemId];
283 
284     _transfer(currentOwner, msg.sender, _itemId);
285   }
286 
287   function transferToWinner(address _winner, address _loser, uint _itemId) public onlyArena {
288     require(!isNullAddress(_winner));
289     require(!isNullAddress(_loser));
290     require(ownerOf(_itemId) == _loser);
291 
292     // Reset item price
293     uint oldPrice = itemIdToPrice[_itemId];
294     uint newPrice = MIN_STARTING_PRICE;
295     itemIdToPrice[_itemId] = newPrice;
296 
297     _transfer(_loser, _winner, _itemId);
298 
299     TransferToWinner(_itemId, oldPrice, newPrice, items[_itemId].name, _loser, _winner);
300   }
301 
302   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
303 
304   function implementsERC721() public pure returns (bool) {
305     return true;
306   }
307 
308   /** MODIFIERS **/
309 
310   modifier onlyAuthor() {
311     require(msg.sender == author);
312     _;
313   }
314 
315   modifier onlyAuthors() {
316     require(msg.sender == author || msg.sender == coauthor);
317     _;
318   }
319 
320   modifier onlyManufacturer() {
321     require(msg.sender == author || msg.sender == coauthor || msg.sender == manufacturer);
322     _;
323   }
324 
325   modifier onlyArena() {
326     require(msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);
327     _;
328   }
329 
330   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
331 
332   function setMinStartingPrice(uint _price) public onlyAuthors {
333     MIN_STARTING_PRICE = _price;
334   }
335 
336   function setGrowthBump(uint _bump) public onlyAuthors {
337     GROWTH_BUMP = _bump;
338   }
339 
340   function setDividend(uint _dividend) public onlyAuthors {
341     DIVIDEND = _dividend;
342   }
343 
344   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
345     PRICE_INCREASE_SCALE = _scale;
346   }
347 
348   function setKpopCelebContractAddress(address _address) public onlyAuthors {
349     KPOP_CELEB_CONTRACT_ADDRESS = _address;
350   }
351 
352   function setKpopArenaContractAddress(address _address) public onlyAuthors {
353     KPOP_ARENA_CONTRACT_ADDRESS = _address;
354   }
355 
356   /** PRIVATE FUNCTIONS **/
357 
358   function isApproved(address _to, uint _itemId) private view returns (bool) {
359     return itemIdToApprovedRecipient[_itemId] == _to;
360   }
361 
362   function isNullAddress(address _addr) private pure returns (bool) {
363     return _addr == 0x0;
364   }
365 }