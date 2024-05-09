1 // KpopItem is a ERC-721 item (https://github.com/ethereum/eips/issues/721)
2 // Each KpopItem has its connected KpopToken itemrity card
3 // Kpop.io is the official website
4 
5 pragma solidity ^0.4.18;
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract ERC721 {
50   function approve(address _to, uint _itemId) public;
51   function balanceOf(address _owner) public view returns (uint balance);
52   function implementsERC721() public pure returns (bool);
53   function ownerOf(uint _itemId) public view returns (address addr);
54   function takeOwnership(uint _itemId) public;
55   function totalSupply() public view returns (uint total);
56   function transferFrom(address _from, address _to, uint _itemId) public;
57   function transfer(address _to, uint _itemId) public;
58 
59   event Transfer(address indexed from, address indexed to, uint itemId);
60   event Approval(address indexed owner, address indexed approved, uint itemId);
61 }
62 
63 contract KpopCeleb is ERC721 {
64   function ownerOf(uint _celebId) public view returns (address addr);
65 }
66 
67 contract KpopItem is ERC721 {
68   address public author;
69   address public coauthor;
70   address public manufacturer;
71 
72   string public constant NAME = "KpopItem";
73   string public constant SYMBOL = "KpopItem";
74 
75   uint public GROWTH_BUMP = 0.4 ether;
76   uint public MIN_STARTING_PRICE = 0.001 ether;
77   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
78   uint public DIVIDEND = 3;
79 
80   address public KPOP_CELEB_CONTRACT_ADDRESS = 0x0;
81   address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;
82 
83   struct Item {
84     string name;
85   }
86 
87   Item[] public items;
88 
89   mapping(uint => address) public itemIdToOwner;
90   mapping(uint => uint) public itemIdToPrice;
91   mapping(address => uint) public userToNumItems;
92   mapping(uint => address) public itemIdToApprovedRecipient;
93   mapping(uint => uint[6]) public itemIdToTraitValues;
94   mapping(uint => uint) public itemIdToCelebId;
95 
96   event Transfer(address indexed from, address indexed to, uint itemId);
97   event Approval(address indexed owner, address indexed approved, uint itemId);
98   event ItemSold(uint itemId, uint oldPrice, uint newPrice, string itemName, address prevOwner, address newOwner);
99   event TransferToWinner(uint itemId, uint oldPrice, uint newPrice, string itemName, address prevOwner, address newOwner);
100 
101   function KpopItem() public {
102     author = msg.sender;
103     coauthor = msg.sender;
104   }
105 
106   function _transfer(address _from, address _to, uint _itemId) private {
107     require(ownerOf(_itemId) == _from);
108     require(!isNullAddress(_to));
109     require(balanceOf(_from) > 0);
110 
111     uint prevBalances = balanceOf(_from) + balanceOf(_to);
112     itemIdToOwner[_itemId] = _to;
113     userToNumItems[_from]--;
114     userToNumItems[_to]++;
115 
116     delete itemIdToApprovedRecipient[_itemId];
117 
118     Transfer(_from, _to, _itemId);
119 
120     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
121   }
122 
123   function buy(uint _itemId) payable public {
124     address prevOwner = ownerOf(_itemId);
125     uint currentPrice = itemIdToPrice[_itemId];
126 
127     require(prevOwner != msg.sender);
128     require(!isNullAddress(msg.sender));
129     require(msg.value >= currentPrice);
130 
131     // Set dividend
132     uint dividend = uint(SafeMath.div(SafeMath.mul(currentPrice, DIVIDEND), 100));
133 
134     // Take a cut
135     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 90), 100));
136 
137     uint leftover = SafeMath.sub(msg.value, currentPrice);
138     uint newPrice;
139 
140     _transfer(prevOwner, msg.sender, _itemId);
141 
142     if (currentPrice < GROWTH_BUMP) {
143       newPrice = SafeMath.mul(currentPrice, 2);
144     } else {
145       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
146     }
147 
148     itemIdToPrice[_itemId] = newPrice;
149 
150     // Pay the prev owner of the item
151     if (prevOwner != address(this)) {
152       prevOwner.transfer(payment);
153     }
154 
155     // Pay dividend to the current owner of the celeb that's connected to the item
156     uint celebId = celebOf(_itemId);
157     KpopCeleb KPOP_CELEB = KpopCeleb(KPOP_CELEB_CONTRACT_ADDRESS);
158     address celebOwner = KPOP_CELEB.ownerOf(celebId);
159     if (celebOwner != address(this) && !isNullAddress(celebOwner)) {
160       celebOwner.transfer(dividend);
161     }
162 
163     ItemSold(_itemId, currentPrice, newPrice,
164       items[_itemId].name, prevOwner, msg.sender);
165 
166     msg.sender.transfer(leftover);
167   }
168 
169   function balanceOf(address _owner) public view returns (uint balance) {
170     return userToNumItems[_owner];
171   }
172 
173   function ownerOf(uint _itemId) public view returns (address addr) {
174     return itemIdToOwner[_itemId];
175   }
176 
177   function celebOf(uint _itemId) public view returns (uint celebId) {
178     return itemIdToCelebId[_itemId];
179   }
180 
181   function totalSupply() public view returns (uint total) {
182     return items.length;
183   }
184 
185   function transfer(address _to, uint _itemId) public {
186     _transfer(msg.sender, _to, _itemId);
187   }
188 
189   /** START FUNCTIONS FOR AUTHORS **/
190 
191   function createItem(string _name, uint _price, uint _celebId, uint[6] _traitValues) public onlyManufacturer {
192     require(_price >= MIN_STARTING_PRICE);
193 
194     uint itemId = items.push(Item(_name)) - 1;
195     itemIdToOwner[itemId] = author;
196     itemIdToPrice[itemId] = _price;
197     itemIdToCelebId[itemId] = _celebId;
198     itemIdToTraitValues[itemId] = _traitValues; // TODO: fetch celeb traits later
199     userToNumItems[author]++;
200   }
201 
202   function withdraw(uint _amount, address _to) public onlyAuthors {
203     require(!isNullAddress(_to));
204     require(_amount <= this.balance);
205 
206     _to.transfer(_amount);
207   }
208 
209   function withdrawAll() public onlyAuthors {
210     require(author != 0x0);
211     require(coauthor != 0x0);
212 
213     uint halfBalance = uint(SafeMath.div(this.balance, 2));
214 
215     author.transfer(halfBalance);
216     coauthor.transfer(halfBalance);
217   }
218 
219   function setCoAuthor(address _coauthor) public onlyAuthor {
220     require(!isNullAddress(_coauthor));
221 
222     coauthor = _coauthor;
223   }
224 
225   function setManufacturer(address _manufacturer) public onlyAuthors {
226     require(!isNullAddress(_manufacturer));
227 
228     manufacturer = _manufacturer;
229   }
230 
231   /** END FUNCTIONS FOR AUTHORS **/
232 
233   function getItem(uint _itemId) public view returns (
234     string name,
235     uint price,
236     address owner,
237     uint[6] traitValues,
238     uint celebId
239   ) {
240     name = items[_itemId].name;
241     price = itemIdToPrice[_itemId];
242     owner = itemIdToOwner[_itemId];
243     traitValues = itemIdToTraitValues[_itemId];
244     celebId = celebOf(_itemId);
245   }
246 
247   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
248 
249   function approve(address _to, uint _itemId) public {
250     require(msg.sender == ownerOf(_itemId));
251 
252     itemIdToApprovedRecipient[_itemId] = _to;
253 
254     Approval(msg.sender, _to, _itemId);
255   }
256 
257   function transferFrom(address _from, address _to, uint _itemId) public {
258     require(ownerOf(_itemId) == _from);
259     require(isApproved(_to, _itemId));
260     require(!isNullAddress(_to));
261 
262     _transfer(_from, _to, _itemId);
263   }
264 
265   function takeOwnership(uint _itemId) public {
266     require(!isNullAddress(msg.sender));
267     require(isApproved(msg.sender, _itemId));
268 
269     address currentOwner = itemIdToOwner[_itemId];
270 
271     _transfer(currentOwner, msg.sender, _itemId);
272   }
273 
274   function transferToWinner(address _winner, address _loser, uint _itemId) public onlyArena {
275     require(!isNullAddress(_winner));
276     require(!isNullAddress(_loser));
277     require(ownerOf(_itemId) == _loser);
278 
279     // Reset item price
280     uint oldPrice = itemIdToPrice[_itemId];
281     uint newPrice = MIN_STARTING_PRICE;
282     itemIdToPrice[_itemId] = newPrice;
283 
284     _transfer(_loser, _winner, _itemId);
285 
286     TransferToWinner(_itemId, oldPrice, newPrice, items[_itemId].name, _loser, _winner);
287   }
288 
289   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
290 
291   function implementsERC721() public pure returns (bool) {
292     return true;
293   }
294 
295   /** MODIFIERS **/
296 
297   modifier onlyAuthor() {
298     require(msg.sender == author);
299     _;
300   }
301 
302   modifier onlyAuthors() {
303     require(msg.sender == author || msg.sender == coauthor);
304     _;
305   }
306 
307   modifier onlyManufacturer() {
308     require(msg.sender == author || msg.sender == coauthor || msg.sender == manufacturer);
309     _;
310   }
311 
312   modifier onlyArena() {
313     require(msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);
314     _;
315   }
316 
317   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
318 
319   function setMinStartingPrice(uint _price) public onlyAuthors {
320     MIN_STARTING_PRICE = _price;
321   }
322 
323   function setGrowthBump(uint _bump) public onlyAuthors {
324     GROWTH_BUMP = _bump;
325   }
326 
327   function setDividend(uint _dividend) public onlyAuthors {
328     DIVIDEND = _dividend;
329   }
330 
331   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
332     PRICE_INCREASE_SCALE = _scale;
333   }
334 
335   function setKpopCelebContractAddress(address _address) public onlyAuthors {
336     KPOP_CELEB_CONTRACT_ADDRESS = _address;
337   }
338 
339   function setKpopArenaContractAddress(address _address) public onlyAuthors {
340     KPOP_ARENA_CONTRACT_ADDRESS = _address;
341   }
342 
343   /** PRIVATE FUNCTIONS **/
344 
345   function isApproved(address _to, uint _itemId) private view returns (bool) {
346     return itemIdToApprovedRecipient[_itemId] == _to;
347   }
348 
349   function isNullAddress(address _addr) private pure returns (bool) {
350     return _addr == 0x0;
351   }
352 }