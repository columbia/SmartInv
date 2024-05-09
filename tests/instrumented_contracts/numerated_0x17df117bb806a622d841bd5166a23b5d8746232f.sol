1 pragma solidity ^0.4.13;
2 
3 contract ItemRegistry {
4   using SafeMath for uint256;
5 
6   enum ItemClass {TIER1, TIER2, TIER3, TIER4}
7 
8   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
9   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
10 
11   address public owner;
12   uint256 cutNumerator = 5;
13   uint256 cutDenominator = 100;
14 
15   uint256[] private listedItems;
16   mapping (uint256 => address) private ownerOfItem;
17   mapping (uint256 => uint256) private startingPriceOfItem;
18   mapping (uint256 => uint256) private priceOfItem;
19   mapping (uint256 => ItemClass) private classOfItem;
20 
21   function ItemRegistry () public {
22     owner = msg.sender;
23   }
24 
25   /* Modifiers */
26   modifier onlyOwner() {
27     require(owner == msg.sender);
28     _;
29   }
30 
31   /* Admin */
32   function setOwner (address _owner) onlyOwner() public {
33     owner = _owner;
34   }
35 
36   function setCut (uint256 _n, uint256 _d) onlyOwner() public {
37     cutNumerator = _n;
38     cutDenominator = _d;
39   }
40 
41   function withdraw () onlyOwner() public {
42     owner.transfer(this.balance);
43   }
44 
45   function listItem (uint256 _itemId, uint256 _price, ItemClass _class) onlyOwner() public {
46     require(_price > 0);
47     require(priceOfItem[_itemId] == 0);
48     require(ownerOfItem[_itemId] == address(0));
49     require(_class <= ItemClass.TIER4);
50 
51     ownerOfItem[_itemId] = owner;
52     priceOfItem[_itemId] = _price;
53     startingPriceOfItem[_itemId] = _price;
54     classOfItem[_itemId] = _class;
55     listedItems.push(_itemId);
56   }
57 
58   function listMultipleItems (uint256[] _itemIds, uint256 _price, ItemClass _class) onlyOwner() external {
59     for (uint256 i = 0; i < _itemIds.length; i++) {
60       listItem(_itemIds[i], _price, _class);
61     }
62   }
63 
64   /* Read */
65   function balanceOf (address _owner) public view returns (uint256 _balance) {
66     uint256 counter = 0;
67 
68     for (uint256 i = 0; i < listedItems.length; i++) {
69       if (ownerOf(listedItems[i]) == _owner) {
70         counter++;
71       }
72     }
73 
74     return counter;
75   }
76 
77   function ownerOf (uint256 _itemId) public view returns (address _owner) {
78     return ownerOfItem[_itemId];
79   }
80 
81   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
82     return startingPriceOfItem[_itemId];
83   }
84 
85   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
86     return priceOfItem[_itemId];
87   }
88 
89   function classOf (uint256 _itemId) public view returns (ItemClass _class) {
90     return classOfItem[_itemId];
91   }
92 
93   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
94     return calculateNextPrice(priceOf(_itemId), classOf(_itemId));
95   }
96 
97   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, ItemClass _class, uint256 _nextPrice) {
98     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), classOf(_itemId), nextPriceOf(_itemId));
99   }
100 
101   function itemsOfOwner (address _owner) public view returns (uint256[] _items) {
102     uint256[] memory items = new uint256[](balanceOf(_owner));
103 
104     uint256 itemCounter = 0;
105     for (uint256 i = 0; i < listedItems.length; i++) {
106       if (ownerOf(listedItems[i]) == _owner) {
107         items[itemCounter] = listedItems[i];
108         itemCounter += 1;
109       }
110     }
111 
112     return items;
113   }
114 
115   function numberOfItemsForSale () public view returns (uint256 _n) {
116     return listedItems.length;
117   }
118 
119   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
120     uint256[] memory items = new uint256[](_take);
121 
122     for (uint256 i = 0; i < _take; i++) {
123       items[i] = listedItems[_from + i];
124     }
125 
126     return items;
127   }
128 
129   function allItemsForSale () public view returns (uint256[] _items) {
130     return listedItems;
131   }
132 
133   /* Next price */
134   function calculateNextPrice (uint256 _currentPrice, ItemClass _class) public pure returns (uint256 _newPrice) {
135     if (_class == ItemClass.TIER1) {
136       if (_currentPrice <= 0.05 ether) {
137         return _currentPrice.mul(2); // 2
138       } else if (_currentPrice <= 0.5 ether) {
139         return _currentPrice.mul(117).div(100); // 1.17
140       } else {
141         return _currentPrice.mul(112).div(100); // 1.12
142       }
143     }
144 
145     if (_class == ItemClass.TIER2) {
146       if (_currentPrice <= 0.1 ether) {
147         return _currentPrice.mul(2); // 2
148       } else if (_currentPrice <= 0.5 ether) {
149         return _currentPrice.mul(118).div(100); // 1.18
150       } else {
151         return _currentPrice.mul(113).div(100); // 1.13
152       }
153     }
154 
155     if (_class == ItemClass.TIER3) {
156       if (_currentPrice <= 0.15 ether) {
157         return _currentPrice * 2; // 2
158       } else if (_currentPrice <= 0.5 ether) {
159         return _currentPrice.mul(119).div(100); // 1.19
160       } else {
161         return _currentPrice.mul(114).div(100); // 1.14
162       }
163     }
164 
165     if (_class == ItemClass.TIER4) {
166       if (_currentPrice <= 0.2 ether) {
167         return _currentPrice.mul(2); // 2
168       } else if (_currentPrice <= 0.5 ether) {
169         return _currentPrice.mul(120).div(100); // 1.2
170       } else {
171         return  _currentPrice.mul(115).div(100); // 1.15
172       }
173     }
174   }
175 
176   /* Buy */
177   function buy (uint256 _itemId) payable public {
178     require(priceOf(_itemId) > 0);
179     require(ownerOf(_itemId) != address(0));
180     require(msg.value == priceOf(_itemId));
181     require(ownerOf(_itemId) != msg.sender);
182     require(!isContract(msg.sender));
183 
184     address oldOwner = ownerOf(_itemId);
185     address newOwner = msg.sender;
186     uint256 price = priceOf(_itemId);
187 
188     ownerOfItem[_itemId] = newOwner;
189     priceOfItem[_itemId] = nextPriceOf(_itemId);
190 
191     Bought(_itemId, newOwner, price);
192     Sold(_itemId, oldOwner, price);
193 
194     uint256 cut = 0;
195     if (cutDenominator > 0 && cutNumerator > 0) {
196       cut = price.mul(cutNumerator).div(cutDenominator);
197     }
198 
199     oldOwner.transfer(price - cut);
200   }
201 
202   /* Util */
203   function isContract(address addr) internal view returns (bool) {
204     uint size;
205     assembly { size := extcodesize(addr) } // solium-disable-line
206     return size > 0;
207   }
208 }
209 
210 library SafeMath {
211 
212   /**
213   * @dev Multiplies two numbers, throws on overflow.
214   */
215   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216     if (a == 0) {
217       return 0;
218     }
219     uint256 c = a * b;
220     assert(c / a == b);
221     return c;
222   }
223 
224   /**
225   * @dev Integer division of two numbers, truncating the quotient.
226   */
227   function div(uint256 a, uint256 b) internal pure returns (uint256) {
228     // assert(b > 0); // Solidity automatically throws when dividing by 0
229     uint256 c = a / b;
230     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231     return c;
232   }
233 
234   /**
235   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
236   */
237   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238     assert(b <= a);
239     return a - b;
240   }
241 
242   /**
243   * @dev Adds two numbers, throws on overflow.
244   */
245   function add(uint256 a, uint256 b) internal pure returns (uint256) {
246     uint256 c = a + b;
247     assert(c >= a);
248     return c;
249   }
250 }