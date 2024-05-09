1 pragma solidity ^0.4.19;
2 library SafeMath {
3 /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14   /**
15   * @dev Integer division of two numbers, truncating the quotient.
16   */
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18        uint256 c = a / b;
19     return c;
20   }
21   /**
22   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23   */
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28   /**
29   * @dev Adds two numbers, throws on overflow.
30   */
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
38 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
39 contract ERC721 {
40     // Required methods
41     function totalSupply() public view returns (uint256 total);
42     function balanceOf(address _owner) public view returns (uint256 balance);
43     function ownerOf(uint256 _tokenId) public view returns (address owner);
44     function approve(address _to, uint256 _tokenId) public;
45     function transfer(address _to, uint256 _tokenId) public;
46     function transferFrom(address _from, address _to, uint256 _tokenId) public;
47     // Events
48     event Transfer(address from, address to, uint256 tokenId);
49     event Approval(address owner, address approved, uint256 tokenId);
50 }
51 contract soccer is ERC721{
52       using SafeMath for uint256;
53   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
54   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
55   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
56   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
57   address private owner;
58 
59   mapping (address => bool) private admins;
60   IItemRegistry private itemRegistry;
61   //Default ether level
62   uint256 private increaseLimit1 = 0.02 ether;
63   uint256 private increaseLimit2 = 0.5 ether;
64   uint256 private increaseLimit3 = 3.0 ether;
65   uint256 private increaseLimit4 = 7.0 ether;
66   //Defualt a Item property
67 
68   uint256 public cut;
69   uint256[] private listedItems;
70   mapping (uint256 => address) private ownerOfItem;
71   mapping (uint256 => uint256) private priceOfItem;
72   mapping (uint256 => address) private approvedOfItem;
73 
74   function soccer () public {
75     owner = msg.sender;
76     admins[owner] = true;   
77     issueCard(1, 4, 0.111111 ether);
78   }
79 
80   // Modifiers
81   modifier onlyOwner() {
82     require(owner == msg.sender);
83     _;
84   }
85   
86   modifier onlyAdmins() {
87     require(admins[msg.sender]);
88     _;
89   }
90 
91   /**
92   *  Buying,Very importent part;
93   */
94 
95   // Account next price for item
96   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
97     if (_price < increaseLimit1) {
98       return _price.mul(200).div(95);
99     } else if (_price < increaseLimit2) {
100       return _price.mul(100).div(66);
101     } else if (_price < increaseLimit3) {
102       return _price.mul(133).div(97);
103     } else if (_price < increaseLimit4) {
104       return _price.mul(117).div(97);
105     } else {
106       return _price.mul(115).div(98);
107     }
108   }
109 
110   // Account service cost
111   function calculateDevCut (uint256 _price) public view returns (uint256 _devCut) {
112     if (_price < increaseLimit1) {
113       return _price.mul(5).div(100); // 5%
114     } else if (_price < increaseLimit2) {
115       return _price.mul(5).div(100); // 5%
116     } else if (_price < increaseLimit3) {
117       return _price.mul(5).div(100); // 5%
118     } else if (_price < increaseLimit4) {
119       return _price.mul(4).div(100); // 4%
120     } else {
121       return _price.mul(4).div(100); // 4%
122     }
123   }
124 
125   // Buy item
126       function buy (uint256 _itemId) payable public {
127         
128               address oldOwner = ownerOf(_itemId);
129               address newOwner = msg.sender;
130               uint256 price = priceOf(_itemId);
131              
132               _transfer(oldOwner, newOwner, _itemId); 
133               priceOfItem[_itemId] = nextPriceOf(_itemId);
134              
135               Bought(_itemId, newOwner, price);
136               Sold(_itemId, oldOwner, price);
137 
138               uint256 devCut = calculateDevCut(price);
139               cut = price.sub(devCut);
140               oldOwner.transfer(price.sub(devCut));
141       }
142 
143   /* ERC721 */
144 
145   function name() public view returns (string name) {
146     return "cryptosports.top";
147   }
148 
149   function symbol() public view returns (string symbol) {
150     return "SGS";
151   }
152 
153   //teams total number
154 
155   function totalSupply() public view returns (uint256 _totalSupply) {
156     return listedItems.length;
157   }
158 
159   function balanceOf (address _owner) public view returns (uint256 _balance) {
160     uint256 counter = 0;
161  
162     for (uint256 i = 0; i < listedItems.length; i++) {
163       if (ownerOf(listedItems[i]) == _owner) {
164         counter++;
165       }
166     }
167 
168     return counter;
169   }
170 
171   //teams owner
172 
173   function ownerOf (uint256 _itemId) public view returns (address _owner) {
174     return ownerOfItem[_itemId];
175   }
176 
177   function tokensOf (address _owner) public view returns (uint256[] _tokenIds) {
178 
179     uint256[] memory items = new uint256[](balanceOf(_owner));
180     uint256 itemCounter = 0;
181 
182     for (uint256 i = 0; i < listedItems.length; i++) {
183       if (ownerOf(listedItems[i]) == _owner) {
184         items[itemCounter] = listedItems[i];
185         itemCounter += 1;
186       }
187     }
188 
189     return items;
190   }
191 
192 
193   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
194     return priceOf(_itemId) > 0;
195   }
196 
197   function approvedFor(uint256 _itemId) public view returns (address _approved) {
198     return approvedOfItem[_itemId];
199   }
200 
201   function approve(address _to, uint256 _itemId) public {
202     require(msg.sender != _to);
203     require(tokenExists(_itemId));
204     require(ownerOf(_itemId) == msg.sender);
205 
206     if (_to == 0) {
207       if (approvedOfItem[_itemId] != 0) {
208         delete approvedOfItem[_itemId];
209         emit Approval(msg.sender, 0, _itemId);
210       }
211     } else {
212       approvedOfItem[_itemId] = _to;
213       emit Approval(msg.sender, _to, _itemId);
214     }
215   }
216 
217   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
218 
219   function transfer(address _to, uint256 _itemId) public {
220     require(msg.sender == ownerOf(_itemId));
221     _transfer(msg.sender, _to, _itemId);
222   }
223 
224   function transferFrom(address _from, address _to, uint256 _itemId) public {
225     require(approvedFor(_itemId) == msg.sender);
226     _transfer(_from, _to, _itemId);
227   }
228 
229   function _transfer(address _from, address _to, uint256 _itemId) internal {
230     require(tokenExists(_itemId));
231     require(ownerOf(_itemId) == _from);
232     require(_to != address(0));
233     require(_to != address(this));
234     
235     ownerOfItem[_itemId] = _to;
236     approvedOfItem[_itemId] = 0;
237     emit Transfer(_from, _to, _itemId);
238   }
239   /* Read */
240   function isAdmin (address _admin) public view returns (bool _isAdmin) {
241     return admins[_admin];
242   }
243 
244   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
245     return priceOfItem[_itemId];
246   }
247 
248   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
249     return calculateNextPrice(priceOf(_itemId));
250   }
251 
252   //all team property content
253   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _price, uint256 _nextPrice) {
254     return (ownerOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
255   }
256 
257   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
258     uint256[] memory items = new uint256[](_take);
259     for (uint256 i = 0; i < _take; i++) {
260       items[i] = listedItems[_from + i];
261     }
262     return items;
263   }
264 
265   /* Util */
266 
267   function isContract(address addr) internal view returns (bool) {
268     uint size;
269     assembly { size := extcodesize(addr) } // solium-disable-line
270     return size > 0;
271   }
272 
273   function changePrice(uint256 _itemId, uint256 _price) public onlyAdmins() {
274     require(_price > 0);
275     require(admins[ownerOfItem[_itemId]]);
276     priceOfItem[_itemId] = _price;
277   }
278 
279   function issueCard(uint256 l, uint256 r, uint256 price) onlyAdmins() public {
280     for (uint256 i = l; i <= r; i++) {
281       ownerOfItem[i] = msg.sender;
282       priceOfItem[i] = price;
283       listedItems.push(i);
284     }     
285    } 
286 }  
287 
288 interface IItemRegistry {
289 
290   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items);
291   function ownerOf (uint256 _itemId) public view returns (address _owner);
292   function priceOf (uint256 _itemId) public view returns (uint256 _price);
293 }