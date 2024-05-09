1 pragma solidity 0.4.25;
2 
3 library SafeMath256 {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 
29     function pow(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) return 0;
31         if (b == 0) return 1;
32 
33         uint256 c = a ** b;
34         assert(c / (a ** (b - 1)) == a);
35         return c;
36     }
37 }
38 
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     function _validateAddress(address _addr) internal pure {
45         require(_addr != address(0), "invalid address");
46     }
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner() {
53         require(msg.sender == owner, "not a contract owner");
54         _;
55     }
56 
57     function transferOwnership(address newOwner) public onlyOwner {
58         _validateAddress(newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 
65 contract Controllable is Ownable {
66     mapping(address => bool) controllers;
67 
68     modifier onlyController {
69         require(_isController(msg.sender), "no controller rights");
70         _;
71     }
72 
73     function _isController(address _controller) internal view returns (bool) {
74         return controllers[_controller];
75     }
76 
77     function _setControllers(address[] _controllers) internal {
78         for (uint256 i = 0; i < _controllers.length; i++) {
79             _validateAddress(_controllers[i]);
80             controllers[_controllers[i]] = true;
81         }
82     }
83 }
84 
85 contract Upgradable is Controllable {
86     address[] internalDependencies;
87     address[] externalDependencies;
88 
89     function getInternalDependencies() public view returns(address[]) {
90         return internalDependencies;
91     }
92 
93     function getExternalDependencies() public view returns(address[]) {
94         return externalDependencies;
95     }
96 
97     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
98         for (uint256 i = 0; i < _newDependencies.length; i++) {
99             _validateAddress(_newDependencies[i]);
100         }
101         internalDependencies = _newDependencies;
102     }
103 
104     function setExternalDependencies(address[] _newDependencies) public onlyOwner {
105         externalDependencies = _newDependencies;
106         _setControllers(_newDependencies);
107     }
108 }
109 
110 contract Gold {
111     function remoteTransfer(address _to, uint256 _value) external;
112 }
113 
114 contract GoldMarketplaceStorage {
115     function () external payable;
116     function transferGold(address, uint256) external;
117     function transferEth(address, uint256) external;
118     function createSellOrder(address, uint256, uint256) external;
119     function cancelSellOrder(address) external;
120     function updateSellOrder(address, uint256, uint256) external;
121     function createBuyOrder(address, uint256, uint256) external;
122     function cancelBuyOrder(address) external;
123     function updateBuyOrder(address, uint256, uint256) external;
124     function orderOfSeller(address) external view returns (uint256, address, uint256, uint256);
125     function orderOfBuyer(address) external view returns (uint256, address, uint256, uint256);
126     function sellOrdersAmount() external view returns (uint256);
127     function buyOrdersAmount() external view returns (uint256);
128 }
129 
130 
131 
132 
133 //////////////CONTRACT//////////////
134 
135 
136 
137 
138 contract GoldMarketplace is Upgradable {
139     using SafeMath256 for uint256;
140 
141     GoldMarketplaceStorage _storage_;
142     Gold goldTokens;
143 
144     uint256 constant GOLD_DECIMALS = uint256(10) ** 18;
145 
146 
147     function _calculateFullPrice(
148         uint256 _price,
149         uint256 _amount
150     ) internal pure returns (uint256) {
151         return _price.mul(_amount).div(GOLD_DECIMALS);
152     }
153 
154     function _transferGold(address _to, uint256 _value) internal {
155         goldTokens.remoteTransfer(_to, _value);
156     }
157 
158     function _min(uint256 _a, uint256 _b) internal pure returns (uint256) {
159         return _a <= _b ? _a : _b;
160     }
161 
162     function _safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return b > a ? 0 : a.sub(b);
164     }
165 
166     function _checkPrice(uint256 _value) internal pure {
167         require(_value > 0, "price must be greater than 0");
168     }
169 
170     function _checkAmount(uint256 _value) internal pure {
171         require(_value > 0, "amount must be greater than 0");
172     }
173 
174     function _checkActualPrice(uint256 _expected, uint256 _actual) internal pure {
175         require(_expected == _actual, "wrong actual price");
176     }
177 
178     // SELL
179 
180     function createSellOrder(
181         address _user,
182         uint256 _price,
183         uint256 _amount
184     ) external onlyController {
185         _checkPrice(_price);
186         _checkAmount(_amount);
187 
188         _transferGold(address(_storage_), _amount);
189 
190         _storage_.createSellOrder(_user, _price, _amount);
191     }
192 
193     function cancelSellOrder(address _user) external onlyController {
194         ( , , , uint256 _amount) = _storage_.orderOfSeller(_user);
195         _storage_.transferGold(_user, _amount);
196         _storage_.cancelSellOrder(_user);
197     }
198 
199     function fillSellOrder(
200         address _buyer,
201         uint256 _value,
202         address _seller,
203         uint256 _expectedPrice,
204         uint256 _amount
205     ) external onlyController returns (uint256 price) {
206         uint256 _available;
207         ( , , price, _available) = _storage_.orderOfSeller(_seller);
208 
209         _checkAmount(_amount);
210         require(_amount <= _available, "seller has no enough gold");
211         _checkActualPrice(_expectedPrice, price);
212 
213         uint256 _fullPrice = _calculateFullPrice(price, _amount);
214         require(_fullPrice > 0, "no free gold, sorry");
215         require(_fullPrice <= _value, "not enough ether");
216 
217         _seller.transfer(_fullPrice);
218         if (_value > _fullPrice) {
219             _buyer.transfer(_value.sub(_fullPrice));
220         }
221         _storage_.transferGold(_buyer, _amount);
222 
223         _available = _available.sub(_amount);
224 
225         if (_available == 0) {
226             _storage_.cancelSellOrder(_seller);
227         } else {
228             _storage_.updateSellOrder(_seller, price, _available);
229         }
230     }
231 
232     // BUY
233 
234     function () external payable onlyController {}
235 
236     function createBuyOrder(
237         address _user,
238         uint256 _value, // eth
239         uint256 _price,
240         uint256 _amount
241     ) external onlyController {
242         _checkPrice(_price);
243         _checkAmount(_amount);
244 
245         uint256 _fullPrice = _calculateFullPrice(_price, _amount);
246         require(_fullPrice == _value, "wrong eth value");
247 
248         address(_storage_).transfer(_value);
249 
250         _storage_.createBuyOrder(_user, _price, _amount);
251     }
252 
253     function cancelBuyOrder(address _user) external onlyController {
254         ( , address _buyer, uint256 _price, uint256 _amount) = _storage_.orderOfBuyer(_user);
255         require(_buyer == _user, "user addresses are not equal");
256 
257         uint256 _fullPrice = _calculateFullPrice(_price, _amount);
258         _storage_.transferEth(_user, _fullPrice);
259 
260         _storage_.cancelBuyOrder(_user);
261     }
262 
263     function fillBuyOrder(
264         address _seller,
265         address _buyer,
266         uint256 _expectedPrice,
267         uint256 _amount
268     ) external onlyController returns (uint256 price) {
269         uint256 _needed;
270         ( , , price, _needed) = _storage_.orderOfBuyer(_buyer);
271 
272         _checkAmount(_amount);
273         require(_amount <= _needed, "buyer do not need so much");
274         _checkActualPrice(_expectedPrice, price);
275 
276         uint256 _fullPrice = _calculateFullPrice(price, _amount);
277 
278         _transferGold(_buyer, _amount);
279         _storage_.transferEth(_seller, _fullPrice);
280 
281         _needed = _needed.sub(_amount);
282 
283         if (_needed == 0) {
284             _storage_.cancelBuyOrder(_buyer);
285         } else {
286             _storage_.updateBuyOrder(_buyer, price, _needed);
287         }
288     }
289 
290     // UPDATE CONTRACT
291 
292     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
293         super.setInternalDependencies(_newDependencies);
294 
295         _storage_ = GoldMarketplaceStorage(_newDependencies[0]);
296         goldTokens = Gold(_newDependencies[1]);
297     }
298 }