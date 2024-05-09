1 pragma solidity ^0.4.24;
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
45 contract CryptoBeauty {
46   using SafeMath for uint256;
47 
48   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
49   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
50   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
51   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
52 
53   address private owner;
54   bool private erc721Enabled = false;
55 
56   uint256 private increaseLimit1 = 0.2 ether;
57   uint256 private increaseLimit2 = 5 ether;
58   uint256 private increaseLimit3 = 30 ether;
59   uint256 private increaseLimit4 = 90 ether;
60 
61   uint256[] private listedItems;
62   mapping (uint256 => address) private ownerOfItem;
63   mapping (uint256 => uint256) private priceOfItem;
64   mapping (uint256 => address) private approvedOfItem;
65   mapping (address => string) private ownerNameOfItem;
66 
67   constructor() public {
68     owner = msg.sender;
69   }
70 
71   /* Modifiers */
72   modifier onlyOwner() {
73     require(owner == msg.sender);
74     _;
75   }
76 
77   modifier onlyERC721() {
78     require(erc721Enabled);
79     _;
80   }
81 
82   /* Owner */
83   function setOwner (address _owner) onlyOwner() public {
84     owner = _owner;
85   }
86 
87   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
88   function enableERC721 () onlyOwner() public {
89     erc721Enabled = true;
90   }
91 
92   /* Withdraw */
93   /*
94     NOTICE: These functions withdraw the developer's cut which is left
95     in the contract by `buy`. User funds are immediately sent to the old
96     owner in `buy`, no user funds are left in the contract.
97   */
98   function withdrawAll () onlyOwner() public {
99     owner.transfer(address(this).balance);
100   }
101 
102   function withdrawAmount (uint256 _amount) onlyOwner() public {
103     owner.transfer(_amount);
104   }
105 
106   function getCurrentBalance() public view returns (uint256 balance) {
107       return address(this).balance;
108   }
109 
110   function listItem (uint256 _itemId, uint256 _price, address _owner) onlyOwner() public {
111     require(_price > 0);
112     require(priceOfItem[_itemId] == 0);
113     require(ownerOfItem[_itemId] == address(0));
114 
115     ownerOfItem[_itemId] = _owner;
116     priceOfItem[_itemId] = _price;
117     listedItems.push(_itemId);
118   }
119 
120   function setOwnerName (address _owner, string _name) public {
121     require(keccak256(abi.encodePacked(ownerNameOfItem[_owner])) != keccak256(abi.encodePacked(_name)));
122     ownerNameOfItem[_owner] = _name;
123   }
124 
125   function getOwnerName (address _owner) public view returns (string _name) {
126     return ownerNameOfItem[_owner];
127   }
128 
129   /* Buying */
130   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
131     if (_price < increaseLimit1) {
132       return _price.mul(200).div(98);
133     } else if (_price < increaseLimit2) {
134       return _price.mul(135).div(97);
135     } else if (_price < increaseLimit3) {
136       return _price.mul(125).div(96);
137     } else if (_price < increaseLimit4) {
138       return _price.mul(117).div(95);
139     } else {
140       return _price.mul(115).div(95);
141     }
142   }
143 
144   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
145     if (_price < increaseLimit1) {
146       return _price.mul(8).div(100); // 8%
147     } else if (_price < increaseLimit2) {
148       return _price.mul(7).div(100); // 7%
149     } else if (_price < increaseLimit3) {
150       return _price.mul(6).div(100); // 6%
151     } else if (_price < increaseLimit4) {
152       return _price.mul(5).div(100); // 5%
153     } else {
154       return _price.mul(5).div(100); // 5%
155     }
156   }
157 
158   /*
159      Buy a country directly from the contract for the calculated price
160      which ensures that the owner gets a profit.  All militaries that
161      have been listed can be bought by this method. User funds are sent
162      directly to the previous owner and are never stored in the contract.
163   */
164   function buy (uint256 _itemId) payable public {
165     require(priceOf(_itemId) > 0);
166     require(ownerOf(_itemId) != address(0));
167     require(msg.value >= priceOf(_itemId));
168     require(ownerOf(_itemId) != msg.sender);
169     require(!isContract(msg.sender));
170     require(msg.sender != address(0));
171 
172     address oldOwner = ownerOf(_itemId);
173     address newOwner = msg.sender;
174     uint256 price = priceOf(_itemId);
175     uint256 excess = msg.value.sub(price);
176 
177     _transfer(oldOwner, newOwner, _itemId);
178     priceOfItem[_itemId] = nextPriceOf(_itemId);
179 
180     emit Bought(_itemId, newOwner, price);
181     emit Sold(_itemId, oldOwner, price);
182 
183     // Devevloper's cut which is left in contract and accesed by
184     // `withdrawAll` and `withdrawAmountTo` methods.
185     uint256 devCut = calculateDevCut(price);
186 
187     // Transfer payment to old owner minus the developer's cut.
188     oldOwner.transfer(price.sub(devCut));
189 
190     if (excess > 0) {
191       newOwner.transfer(excess);
192     }
193   }
194 
195   /* ERC721 */
196   function implementsERC721() public view returns (bool _implements) {
197     return erc721Enabled;
198   }
199 
200   function name() public pure returns (string _name) {
201     return "CryptoBeauty";
202   }
203 
204   function symbol() public pure returns (string _symbol) {
205     return "CRBT";
206   }
207 
208   function totalSupply() public view returns (uint256 _totalSupply) {
209     return listedItems.length;
210   }
211 
212   function balanceOf (address _owner) public view returns (uint256 _balance) {
213     uint256 counter = 0;
214 
215     for (uint256 i = 0; i < listedItems.length; i++) {
216       if (ownerOf(listedItems[i]) == _owner) {
217         counter++;
218       }
219     }
220 
221     return counter;
222   }
223 
224   function ownerOf (uint256 _itemId) public view returns (address _owner) {
225     return ownerOfItem[_itemId];
226   }
227 
228   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
229     uint256[] memory items = new uint256[](balanceOf(_owner));
230 
231     uint256 itemCounter = 0;
232     for (uint256 i = 0; i < listedItems.length; i++) {
233       if (ownerOf(listedItems[i]) == _owner) {
234         items[itemCounter] = listedItems[i];
235         itemCounter += 1;
236       }
237     }
238 
239     return items;
240   }
241 
242   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
243     return priceOf(_itemId) > 0;
244   }
245 
246   function approvedFor(uint256 _itemId) public view returns (address _approved) {
247     return approvedOfItem[_itemId];
248   }
249 
250   /* Transferring a beauty to another owner will entitle the new owner the profits from `buy` */
251   function transfer(address _to, uint256 _itemId) onlyERC721() public {
252     require(msg.sender == ownerOf(_itemId));
253     _transfer(msg.sender, _to, _itemId);
254   }
255 
256   function _transfer(address _from, address _to, uint256 _itemId) internal {
257     require(tokenExists(_itemId));
258     require(ownerOf(_itemId) == _from);
259     require(_to != address(0));
260     require(_to != address(this));
261 
262     ownerOfItem[_itemId] = _to;
263     approvedOfItem[_itemId] = 0;
264 
265     emit Transfer(_from, _to, _itemId);
266   }
267 
268   /* Read */
269   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
270     return priceOfItem[_itemId];
271   }
272 
273   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
274     return calculateNextPrice(priceOf(_itemId));
275   }
276 
277   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
278     return (ownerOf(_itemId),priceOf(_itemId), nextPriceOf(_itemId));
279   }
280 
281   /* Util */
282   function isContract(address addr) internal view returns (bool) {
283     uint size;
284     assembly { size := extcodesize(addr) } // solium-disable-line
285     return size > 0;
286   }
287 }