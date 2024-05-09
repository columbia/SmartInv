1 pragma solidity ^ 0.4.18;
2 library SafeMath {
3     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
4         if (a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns(uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns(uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 contract UECToken {
26     using SafeMath for uint256;
27     event Bought(uint256 indexed _itemId, address indexed _owner, uint256 _price);
28     event Sold(uint256 indexed _itemId, address indexed _owner, uint256 _price);
29     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
30     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
31     event ReNameEvent(uint256 indexed _itemId, address indexed _owner, bytes32 indexed _itemName);
32     address private owner;
33     mapping(address => bool) private admins;
34     IItemRegistry private itemRegistry;
35     bool private erc721Enabled = false;
36     uint256 private increaseLimit1 = 0.02 ether;
37     uint256 private increaseLimit2 = 0.5 ether;
38     uint256 private increaseLimit3 = 2.0 ether;
39     uint256 private increaseLimit4 = 5.0 ether;
40     uint256[] private listedItems;
41     mapping(uint256 => address) private ownerOfItem;
42     mapping(uint256 => uint256) private startingPriceOfItem;
43     mapping(uint256 => uint256) private priceOfItem;
44     mapping(uint256 => address) private approvedOfItem;
45     mapping(uint256 => bytes32) private nameOfItem;
46     mapping(uint256 => address) private nameAddressOfItem;
47     string private constant p_contract_name = "UniverseCoin UEC";
48     string private constant p_contract_symbol = "UEC";
49     uint256 private p_itemName_len = 5;
50     uint256 private p_itemName_price = 1000000000000000000;
51     mapping(address => string) private accountOfNick;
52     mapping(address => uint256) private accountOfPrice;
53     mapping(address => string) private countryofNick;
54     uint256 accountPrice = 1000000000000000;
55     event SetNick(string indexed _nick, string indexed _countryName, address indexed _owner);
56     event SetNickPrice(uint256 indexed _accountOfPrice, address indexed _owner);
57     function accountOfN(address _owner) public view returns(string _nick) {
58         return accountOfNick[_owner];
59     }
60     function accountOfP(address _owner) public view returns(uint256 _nick) {
61         return accountOfPrice[_owner];
62     }
63     function countryofN(address _owner) public view returns(string _nick) {
64         return countryofNick[_owner];
65     }
66     function setNick(string _nick, string _countryname) payable public {
67         require(bytes(_nick).length > 2);
68         require(bytes(_countryname).length > 2);
69         uint256 accountPriceCurrent = accountPrice;
70         if (accountOfP(msg.sender) <= 0) {
71             accountPriceCurrent = accountPrice;
72         } else {
73             accountPriceCurrent = accountOfP(msg.sender);
74             accountPriceCurrent = accountPriceCurrent*2;
75         }
76         if (msg.value != accountPriceCurrent) {
77             return;
78         }
79         accountOfNick[msg.sender] = _nick;
80         accountOfPrice[msg.sender] = accountPriceCurrent;
81         countryofNick[msg.sender] = _countryname;
82         SetNick(_nick, _countryname, msg.sender);
83         SetNickPrice(accountPriceCurrent,msg.sender);
84     }
85     function UECToken() public {
86         owner = msg.sender;
87         admins[owner] = true;
88     }
89     modifier onlyOwner() {
90         require(owner == msg.sender);
91         _;
92     }
93     modifier onlyAdmins() {
94         require(admins[msg.sender]);
95         _;
96     }
97     modifier onlyERC721() {
98         require(erc721Enabled);
99         _;
100     }
101     function setItemName(uint256 _itemId, bytes32 _itemName) payable public {
102         require(priceOf(_itemId) > 0);
103         require(msg.sender != nameAddressOfItem[_itemId]);
104         nameOfItem[_itemId] = _itemName;
105         nameAddressOfItem[_itemId] = msg.sender;
106     }
107     function setOwner(address _owner) onlyOwner() public {
108         owner = _owner;
109     }
110     function setItemRegistry(address _itemRegistry) onlyOwner() public {
111         itemRegistry = IItemRegistry(_itemRegistry);
112     }
113     function addAdmin(address _admin) onlyOwner() public {
114         admins[_admin] = true;
115     }
116     function removeAdmin(address _admin) onlyOwner() public {
117         delete admins[_admin];
118     }
119     function enableERC721() onlyOwner() public {
120         erc721Enabled = true;
121     }
122     function withdrawAll() onlyOwner() public {
123         owner.transfer(this.balance);
124     }
125     function withdrawAmount(uint256 _amount) onlyOwner() public {
126         owner.transfer(_amount);
127     }
128     function populateFromItemRegistry(uint256[] _itemIds) onlyOwner() public {
129         for (uint256 i = 0; i < _itemIds.length; i++) {
130             if (priceOfItem[_itemIds[i]] > 0 || itemRegistry.priceOf(_itemIds[i]) == 0) {
131                 continue;
132             }
133             listItemFromRegistry(_itemIds[i]);
134         }
135     }
136     function listItemFromRegistry(uint256 _itemId) onlyOwner() public {
137         require(itemRegistry != address(0));
138         require(itemRegistry.ownerOf(_itemId) != address(0));
139         require(itemRegistry.priceOf(_itemId) > 0);
140         uint256 price = itemRegistry.priceOf(_itemId);
141         address itemOwner = itemRegistry.ownerOf(_itemId);
142         listItem(_itemId, price,itemOwner,'',itemOwner);
143     }
144     function listMultipleItems(uint256[] _itemIds, uint256 _price, address _owner, bytes32 _itemName) onlyAdmins() external {
145         for (uint256 i = 0; i < _itemIds.length; i++) {
146             listItem(_itemIds[i], _price, _owner, _itemName,_owner);
147         }
148     }
149     function listItem(uint256 _itemId, uint256 _price, address _owner, bytes32 _itemName, address _itemNameAddress) onlyAdmins() public {
150         require(_price > 0);
151         require(priceOfItem[_itemId] == 0);
152         require(ownerOfItem[_itemId] == address(0));
153         ownerOfItem[_itemId] = _owner;
154         priceOfItem[_itemId] = _price;
155         nameOfItem[_itemId] = _itemName;
156         nameAddressOfItem[_itemId] = _itemNameAddress;
157         startingPriceOfItem[_itemId] = _price;
158         listedItems.push(_itemId);
159     }
160     function calculateNextPrice(uint256 _price) public view returns(uint256 _nextPrice) {
161         if (_price < increaseLimit1) {
162             return _price.mul(200).div(95);
163         } else if (_price < increaseLimit2) {
164             return _price.mul(135).div(96);
165         } else if (_price < increaseLimit3) {
166             return _price.mul(125).div(97);
167         } else if (_price < increaseLimit4) {
168             return _price.mul(117).div(97);
169         } else {
170             return _price.mul(115).div(98);
171         }
172     }
173     function calculateDevCut(uint256 _price) public view returns(uint256 _devCut) {
174         if (_price < increaseLimit1) {
175             return _price.mul(5).div(100);
176         } else if (_price < increaseLimit2) {
177             return _price.mul(4).div(100);
178         } else if (_price < increaseLimit3) {
179             return _price.mul(3).div(100);
180         } else if (_price < increaseLimit4) {
181             return _price.mul(3).div(100);
182         } else {
183             return _price.mul(2).div(100);
184         }
185     }
186     function buy(uint256 _itemId) payable public {
187         require(priceOf(_itemId) > 0);
188         require(ownerOf(_itemId) != address(0));
189         require(msg.value >= priceOf(_itemId));
190         require(ownerOf(_itemId) != msg.sender);
191         require(!isContract(msg.sender));
192         require(msg.sender != address(0));
193         address oldOwner = ownerOf(_itemId);
194         address newOwner = msg.sender;
195         uint256 price = priceOf(_itemId);
196         uint256 excess = msg.value.sub(price);
197         _transfer(oldOwner, newOwner, _itemId);
198         priceOfItem[_itemId] = nextPriceOf(_itemId);
199         Bought(_itemId, newOwner, price);
200         Sold(_itemId, oldOwner, price);
201         uint256 devCut = calculateDevCut(price);
202         oldOwner.transfer(price.sub(devCut));
203         if (excess > 0) {
204             newOwner.transfer(excess);
205         }
206     }
207     function implementsERC721() public view returns(bool _implements) {
208         return erc721Enabled;
209     }
210     function name() public pure returns(string _name) {
211         return p_contract_name;
212     }
213     function symbol() public pure returns(string _symbol) {
214         return p_contract_symbol;
215     }
216     function totalSupply() public view returns(uint256 _totalSupply) {
217         return listedItems.length;
218     }
219     function balanceOf(address _owner) public view returns(uint256 _balance) {
220         uint256 counter = 0;
221         for (uint256 i = 0; i < listedItems.length; i++) {
222             if (ownerOf(listedItems[i]) == _owner) {
223                 counter++;
224             }
225         }
226         return counter;
227     }
228     function ownerOf(uint256 _itemId) public view returns(address _owner) {
229         return ownerOfItem[_itemId];
230     }
231     function tokensOf(address _owner) public view returns(uint256[] _tokenIds) {
232         uint256[] memory items = new uint256[](balanceOf(_owner));
233         uint256 itemCounter = 0;
234         for (uint256 i = 0; i < listedItems.length; i++) {
235             if (ownerOf(listedItems[i]) == _owner) {
236                 items[itemCounter] = listedItems[i];
237                 itemCounter += 1;
238             }
239         }
240         return items;
241     }
242     function tokenExists(uint256 _itemId) public view returns(bool _exists) {
243         return priceOf(_itemId) > 0;
244     }
245     function approvedFor(uint256 _itemId) public view returns(address _approved) {
246         return approvedOfItem[_itemId];
247     }
248     function approve(address _to, uint256 _itemId) onlyERC721() public {
249         require(msg.sender != _to);
250         require(tokenExists(_itemId));
251         require(ownerOf(_itemId) == msg.sender);
252         if (_to == 0) {
253             if (approvedOfItem[_itemId] != 0) {
254                 delete approvedOfItem[_itemId];
255                 Approval(msg.sender, 0, _itemId);
256             }
257         } else {
258             approvedOfItem[_itemId] = _to;
259             Approval(msg.sender, _to, _itemId);
260         }
261     }
262     function transfer(address _to, uint256 _itemId) onlyERC721() public {
263         require(msg.sender == ownerOf(_itemId));
264         _transfer(msg.sender, _to, _itemId);
265     }
266     function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
267         require(approvedFor(_itemId) == msg.sender);
268         _transfer(_from, _to, _itemId);
269     }
270     function _transfer(address _from, address _to, uint256 _itemId) internal {
271         require(tokenExists(_itemId));
272         require(ownerOf(_itemId) == _from);
273         require(_to != address(0));
274         require(_to != address(this));
275         ownerOfItem[_itemId] = _to;
276         approvedOfItem[_itemId] = 0;
277         Transfer(_from, _to, _itemId);
278     }
279     function isAdmin(address _admin) public view returns(bool _isAdmin) {
280         return admins[_admin];
281     }
282     function startingPriceOf(uint256 _itemId) public view returns(uint256 _startingPrice) {
283         return startingPriceOfItem[_itemId];
284     }
285     function priceOf(uint256 _itemId) public view returns(uint256 _price) {
286         return priceOfItem[_itemId];
287     }
288     function nextPriceOf(uint256 _itemId) public view returns(uint256 _nextPrice) {
289         return calculateNextPrice(priceOf(_itemId));
290     }
291     function itemNameOf(uint256 _itemId) public view returns(bytes32 _itemName) {
292         return nameOfItem[_itemId];
293     }
294     function itemNameAddress(uint256 _itemId) public view returns(address _itemNameAddress) {
295         return nameAddressOfItem[_itemId];
296     }
297     function itemsForSaleLimit(uint256 _from, uint256 _take) public view returns(uint256[] _items) {
298         uint256[] memory items = new uint256[](_take);
299         for (uint256 i = 0; i < _take; i++) {
300             items[i] = listedItems[_from + i];
301         }
302         return items;
303     }
304     function isContract(address addr) internal view returns(bool) {
305         uint size;
306         assembly {
307             size: =extcodesize(addr)
308         }
309         return size > 0;
310     }
311 }
312 interface IItemRegistry {
313     function itemsForSaleLimit(uint256 _from, uint256 _take) public view returns(uint256[] _items);
314     function ownerOf(uint256 _itemId) public view returns(address _owner);
315     function priceOf(uint256 _itemId) public view returns(uint256 _price);
316 }