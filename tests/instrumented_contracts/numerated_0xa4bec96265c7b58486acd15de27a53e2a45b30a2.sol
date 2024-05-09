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
36   function withdrawAll () onlyOwner() public {
37     owner.transfer(this.balance);
38   }
39 
40   function withdrawAmountTo (uint256 _amount, address _to) onlyOwner() public {
41     _to.transfer(_amount);
42   }
43 
44   function listItem (uint256 _itemId, uint256 _price, ItemClass _class, address _owner) onlyOwner() public {
45     require(_price > 0);
46     require(priceOfItem[_itemId] == 0);
47     require(ownerOfItem[_itemId] == address(0));
48     require(_class <= ItemClass.TIER4);
49 
50     ownerOfItem[_itemId] = _owner;
51     priceOfItem[_itemId] = _price;
52     startingPriceOfItem[_itemId] = _price;
53     classOfItem[_itemId] = _class;
54     listedItems.push(_itemId);
55   }
56 
57   function listMultipleItems (uint256[] _itemIds, uint256 _price, ItemClass _class) onlyOwner() external {
58     for (uint256 i = 0; i < _itemIds.length; i++) {
59       listItem(_itemIds[i], _price, _class, msg.sender);
60     }
61   }
62 
63   /* Read */
64   function balanceOf (address _owner) public view returns (uint256 _balance) {
65     uint256 counter = 0;
66 
67     for (uint256 i = 0; i < listedItems.length; i++) {
68       if (ownerOf(listedItems[i]) == _owner) {
69         counter++;
70       }
71     }
72 
73     return counter;
74   }
75 
76   function ownerOf (uint256 _itemId) public view returns (address _owner) {
77     return ownerOfItem[_itemId];
78   }
79 
80   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
81     return startingPriceOfItem[_itemId];
82   }
83 
84   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
85     return priceOfItem[_itemId];
86   }
87 
88   function classOf (uint256 _itemId) public view returns (ItemClass _class) {
89     return classOfItem[_itemId];
90   }
91 
92   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
93     return calculateNextPrice(priceOf(_itemId), classOf(_itemId));
94   }
95 
96   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, ItemClass _class, uint256 _nextPrice) {
97     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), classOf(_itemId), nextPriceOf(_itemId));
98   }
99 
100   function itemsOfOwner (address _owner) public view returns (uint256[] _items) {
101     uint256[] memory items = new uint256[](balanceOf(_owner));
102 
103     uint256 itemCounter = 0;
104     for (uint256 i = 0; i < listedItems.length; i++) {
105       if (ownerOf(listedItems[i]) == _owner) {
106         items[itemCounter] = listedItems[i];
107         itemCounter += 1;
108       }
109     }
110 
111     return items;
112   }
113 
114   function numberOfItemsForSale () public view returns (uint256 _n) {
115     return listedItems.length;
116   }
117 
118   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
119     uint256[] memory items = new uint256[](_take);
120 
121     for (uint256 i = 0; i < _take; i++) {
122       items[i] = listedItems[_from + i];
123     }
124 
125     return items;
126   }
127 
128   function allItemsForSale () public view returns (uint256[] _items) {
129     return listedItems;
130   }
131 
132   /* Next price */
133   function calculateNextPrice (uint256 _currentPrice, ItemClass _class) public pure returns (uint256 _newPrice) {
134     if (_class == ItemClass.TIER1) {
135       if (_currentPrice <= 0.05 ether) {
136         return _currentPrice.mul(2); // 2
137       } else if (_currentPrice <= 0.5 ether) {
138         return _currentPrice.mul(117).div(100); // 1.17
139       } else {
140         return _currentPrice.mul(112).div(100); // 1.12
141       }
142     }
143 
144     if (_class == ItemClass.TIER2) {
145       if (_currentPrice <= 0.1 ether) {
146         return _currentPrice.mul(2); // 2
147       } else if (_currentPrice <= 0.5 ether) {
148         return _currentPrice.mul(118).div(100); // 1.18
149       } else {
150         return _currentPrice.mul(113).div(100); // 1.13
151       }
152     }
153 
154     if (_class == ItemClass.TIER3) {
155       if (_currentPrice <= 0.15 ether) {
156         return _currentPrice * 2; // 2
157       } else if (_currentPrice <= 0.5 ether) {
158         return _currentPrice.mul(119).div(100); // 1.19
159       } else {
160         return _currentPrice.mul(114).div(100); // 1.14
161       }
162     }
163 
164     if (_class == ItemClass.TIER4) {
165       if (_currentPrice <= 0.2 ether) {
166         return _currentPrice.mul(2); // 2
167       } else if (_currentPrice <= 0.5 ether) {
168         return _currentPrice.mul(120).div(100); // 1.2
169       } else {
170         return  _currentPrice.mul(115).div(100); // 1.15
171       }
172     }
173   }
174 
175   /* Buy */
176   function buy (uint256 _itemId) payable public {
177     require(priceOf(_itemId) > 0);
178     require(ownerOf(_itemId) != address(0));
179     require(msg.value >= priceOf(_itemId));
180     require(ownerOf(_itemId) != msg.sender);
181     require(!isContract(msg.sender));
182 
183     address oldOwner = ownerOf(_itemId);
184     address newOwner = msg.sender;
185     uint256 price = priceOf(_itemId);
186     uint256 excess = msg.value - price;
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
200 
201     if (excess > 0) {
202       newOwner.transfer(excess);
203     }
204   }
205 
206   /* Util */
207   function isContract(address addr) internal view returns (bool) {
208     uint size;
209     assembly { size := extcodesize(addr) } // solium-disable-line
210     return size > 0;
211   }
212 }
213 
214 library SafeMath {
215 
216   /**
217   * @dev Multiplies two numbers, throws on overflow.
218   */
219   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220     if (a == 0) {
221       return 0;
222     }
223     uint256 c = a * b;
224     assert(c / a == b);
225     return c;
226   }
227 
228   /**
229   * @dev Integer division of two numbers, truncating the quotient.
230   */
231   function div(uint256 a, uint256 b) internal pure returns (uint256) {
232     // assert(b > 0); // Solidity automatically throws when dividing by 0
233     uint256 c = a / b;
234     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235     return c;
236   }
237 
238   /**
239   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
240   */
241   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
242     assert(b <= a);
243     return a - b;
244   }
245 
246   /**
247   * @dev Adds two numbers, throws on overflow.
248   */
249   function add(uint256 a, uint256 b) internal pure returns (uint256) {
250     uint256 c = a + b;
251     assert(c >= a);
252     return c;
253   }
254 }