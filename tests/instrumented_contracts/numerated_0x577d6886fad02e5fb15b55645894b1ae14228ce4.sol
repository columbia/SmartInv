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
110 contract ERC20 {
111     function transfer(address, uint256) public returns (bool);
112 }
113 
114 contract Gold is ERC20 {}
115 
116 
117 contract GoldMarketplaceStorage is Upgradable {
118     using SafeMath256 for uint256;
119 
120     Gold goldTokens;
121 
122     struct Order {
123         address user;
124         uint256 price;
125         uint256 amount;
126     }
127 
128     mapping (address => uint256) public userToSellOrderIndex;
129     mapping (address => uint256) public userToBuyOrderIndex;
130 
131     Order[] public sellOrders;
132     Order[] public buyOrders;
133 
134     constructor() public {
135         sellOrders.length = 1;
136         buyOrders.length = 1;
137     }
138 
139     function _ordersShouldExist(uint256 _amount) internal pure {
140         require(_amount > 1, "no orders"); // take a look at the constructor
141     }
142 
143     function _orderShouldNotExist(uint256 _index) internal pure {
144         require(_index == 0, "order already exists");
145     }
146 
147     function _orderShouldExist(uint256 _index) internal pure {
148         require(_index != 0, "order does not exist");
149     }
150 
151     function _sellOrderShouldExist(address _user) internal view {
152         _orderShouldExist(userToSellOrderIndex[_user]);
153     }
154 
155     function _buyOrderShouldExist(address _user) internal view {
156         _orderShouldExist(userToBuyOrderIndex[_user]);
157     }
158 
159     function transferGold(address _to, uint256 _value) external onlyController {
160         goldTokens.transfer(_to, _value);
161     }
162 
163     function transferEth(address _to, uint256 _value) external onlyController {
164         _to.transfer(_value);
165     }
166 
167     // SELL
168 
169     function createSellOrder(
170         address _user,
171         uint256 _price,
172         uint256 _amount
173     ) external onlyController {
174         _orderShouldNotExist(userToSellOrderIndex[_user]);
175 
176         Order memory _order = Order(_user, _price, _amount);
177         userToSellOrderIndex[_user] = sellOrders.length;
178         sellOrders.push(_order);
179     }
180 
181     function cancelSellOrder(
182         address _user
183     ) external onlyController {
184         _sellOrderShouldExist(_user);
185         _ordersShouldExist(sellOrders.length);
186 
187         uint256 _orderIndex = userToSellOrderIndex[_user];
188 
189         uint256 _lastOrderIndex = sellOrders.length.sub(1);
190         Order memory _lastOrder = sellOrders[_lastOrderIndex];
191 
192         userToSellOrderIndex[_lastOrder.user] = _orderIndex;
193         sellOrders[_orderIndex] = _lastOrder;
194 
195         sellOrders.length--;
196         delete userToSellOrderIndex[_user];
197     }
198 
199     function updateSellOrder(
200         address _user,
201         uint256 _price,
202         uint256 _amount
203     ) external onlyController {
204         _sellOrderShouldExist(_user);
205         uint256 _index = userToSellOrderIndex[_user];
206         sellOrders[_index].price = _price;
207         sellOrders[_index].amount = _amount;
208     }
209 
210     // BUY
211 
212     function () external payable onlyController {}
213 
214     function createBuyOrder(
215         address _user,
216         uint256 _price,
217         uint256 _amount
218     ) external onlyController {
219         _orderShouldNotExist(userToBuyOrderIndex[_user]);
220 
221         Order memory _order = Order(_user, _price, _amount);
222         userToBuyOrderIndex[_user] = buyOrders.length;
223         buyOrders.push(_order);
224     }
225 
226     function cancelBuyOrder(address _user) external onlyController {
227         _buyOrderShouldExist(_user);
228         _ordersShouldExist(buyOrders.length);
229 
230         uint256 _orderIndex = userToBuyOrderIndex[_user];
231 
232         uint256 _lastOrderIndex = buyOrders.length.sub(1);
233         Order memory _lastOrder = buyOrders[_lastOrderIndex];
234 
235         userToBuyOrderIndex[_lastOrder.user] = _orderIndex;
236         buyOrders[_orderIndex] = _lastOrder;
237 
238         buyOrders.length--;
239         delete userToBuyOrderIndex[_user];
240     }
241 
242     function updateBuyOrder(
243         address _user,
244         uint256 _price,
245         uint256 _amount
246     ) external onlyController {
247         _buyOrderShouldExist(_user);
248         uint256 _index = userToBuyOrderIndex[_user];
249         buyOrders[_index].price = _price;
250         buyOrders[_index].amount = _amount;
251     }
252 
253     // GETTERS
254 
255     function orderOfSeller(
256         address _user
257     ) external view returns (
258         uint256 index,
259         address user,
260         uint256 price,
261         uint256 amount
262     ) {
263         _sellOrderShouldExist(_user);
264         index = userToSellOrderIndex[_user];
265         Order memory order = sellOrders[index];
266         return (
267             index,
268             order.user,
269             order.price,
270             order.amount
271         );
272     }
273 
274     function orderOfBuyer(
275         address _user
276     ) external view returns (
277         uint256 index,
278         address user,
279         uint256 price,
280         uint256 amount
281     ) {
282         _buyOrderShouldExist(_user);
283         index = userToBuyOrderIndex[_user];
284         Order memory order = buyOrders[index];
285         return (
286             index,
287             order.user,
288             order.price,
289             order.amount
290         );
291     }
292 
293     function sellOrdersAmount() external view returns (uint256) {
294         return sellOrders.length;
295     }
296 
297     function buyOrdersAmount() external view returns (uint256) {
298         return buyOrders.length;
299     }
300 
301     // UPDATE CONTRACT
302 
303     function setInternalDependencies(address[] _newDependencies) public onlyOwner {
304         super.setInternalDependencies(_newDependencies);
305 
306         goldTokens = Gold(_newDependencies[0]);
307     }
308 }