1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-19
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9 * @title Ownable
10 * @dev The Ownable contract has an owner address, and provides basic authorization control
11 * functions, this simplifies the implementation of "user permissions".
12 */
13 contract Ownable {
14     address public owner;
15 
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20     /**
21     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22     * account.
23     */
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28 
29     /**
30     * @dev Throws if called by any account other than the owner.
31     */
32     modifier onlyOwner() {
33         require(msg.sender == owner);
34         _;
35     }
36 
37 
38     /**
39     * @dev Allows the current owner to transfer control of the contract to a newOwner.
40     * @param newOwner The address to transfer ownership to.
41     */
42     function transferOwnership(address newOwner) public onlyOwner {
43         require(newOwner != address(0));
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46     }
47 
48 }
49 
50 library SafeMath {
51 
52   
53   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54     if (a == 0) {
55       return 0;
56     }
57     uint256 c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75  
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 contract NewEscrow is Ownable {
84 
85     enum OrderStatus { Pending, Completed, Refunded, Disputed }
86 
87     event PaymentCreation(uint indexed orderId, address indexed customer, uint value);
88     event PaymentCompletion(uint indexed orderId, address indexed customer, uint value, OrderStatus status);
89     
90     uint orderCount;
91     
92     struct Order {
93         uint orderId;
94         address customer;
95         uint value;
96         OrderStatus status;
97         uint quantity;
98         uint itemId;
99         address disputeCreatedBy;
100         bool paymentStatus;
101         bool paymentMade;
102         
103     }
104     
105     struct Item {
106         uint quantity;
107         string name;
108         uint price;
109     }
110     
111     mapping(uint => Item) public items;
112     mapping(uint => Order) public orders;
113     
114     address public admin;
115     address public seller;    
116     
117     modifier onlyDisputed(uint256 _orderID) {
118         require(orders[_orderID].status != OrderStatus.Disputed);
119         _;
120     }
121     
122     modifier onlySeller() {
123         require(msg.sender == seller);
124         _;
125     }
126     
127     modifier onlyDisputeEnder(uint256 _orderID,address _caller) {
128         require(_caller == admin || _caller == orders[_orderID].disputeCreatedBy);
129         _;
130     }
131     
132     modifier onlyDisputeCreater(uint256 _orderID,address _caller) {
133         require(_caller == seller || _caller == orders[_orderID].customer);
134         _;
135     }
136     
137      modifier onlyAdminOrBuyer(uint256 _orderID, address _caller) {
138         require( _caller == admin || _caller == orders[_orderID].customer);
139         _;
140     }
141     
142      modifier onlyBuyer(uint256 _orderID, address _caller) {
143         require(_caller == orders[_orderID].customer);
144         _;
145     }
146     
147     
148     modifier onlyAdminOrSeller(address _caller) {
149         require(_caller == admin || _caller == seller);
150         _;
151     }
152     
153     constructor (address _seller) public {
154         admin = 0x382468fb5070Ae19e9D82ec388e79AE4e43d890D;
155         seller = _seller;
156         orderCount = 1;
157     }
158     
159     function buyProduct(uint _itemId, uint _itemQuantity) public payable {
160         require(msg.value > 0);
161         require(msg.value == (items[_itemId].price * _itemQuantity));
162         require(!orders[orderCount].paymentMade);
163         require(msg.sender != seller && msg.sender != admin);
164         orders[orderCount].paymentMade = true;
165         createPayment(_itemId, msg.sender, _itemQuantity);
166     }
167     
168     function createPayment(uint _itemId, address _customer, uint _itemQuantity) internal {
169        
170         require(items[_itemId].quantity >= _itemQuantity);
171     
172         orders[orderCount].orderId = orderCount;
173         
174         items[_itemId].quantity = items[_itemId].quantity - _itemQuantity;
175         
176         uint totalPrice = _itemQuantity * items[_itemId].price;
177         
178         orders[orderCount].value = totalPrice;
179         orders[orderCount].quantity = _itemQuantity;
180         orders[orderCount].customer = _customer;
181         orders[orderCount].itemId = _itemId;
182         orders[orderCount].status = OrderStatus.Pending;
183         
184         emit PaymentCreation(orderCount, _customer, totalPrice);
185         orderCount = orderCount + 1;
186     }
187     
188     function addItem(uint _itemId, string _itemName, uint _quantity, uint _price) external onlySeller  {
189 
190         items[_itemId].name = _itemName;
191         items[_itemId].quantity = _quantity;
192         items[_itemId].price = _price;
193     }
194     
195     
196     function release(uint _orderId) public onlyDisputed(_orderId) onlyAdminOrBuyer(_orderId,msg.sender) {
197     
198         completePayment(_orderId, seller, OrderStatus.Completed);
199         
200     }
201     
202     function refund(uint _orderId, uint _itemId) public onlyDisputed(_orderId) onlyAdminOrSeller(msg.sender){
203         
204         items[_itemId].quantity = items[_itemId].quantity + orders[_orderId].quantity;
205         
206         incompletePayment(_orderId, orders[_orderId].customer, OrderStatus.Refunded);
207     }
208 
209 
210     function completePayment(uint _orderId, address _receiver, OrderStatus _status) private {
211         require(orders[_orderId].paymentStatus != true);
212         
213         Order storage payment = orders[_orderId];
214      
215         uint adminSupply = SafeMath.div(SafeMath.mul(orders[_orderId].value, 7), 100);
216         
217         uint sellerSupply = SafeMath.div(SafeMath.mul(orders[_orderId].value, 93), 100);
218         
219         _receiver.transfer(sellerSupply);
220         
221         admin.transfer(adminSupply);
222         
223         orders[_orderId].status = _status;
224         
225         orders[_orderId].paymentStatus = true;
226         
227         emit PaymentCompletion(_orderId, _receiver, payment.value, _status);
228     }
229     
230     function incompletePayment(uint _orderId, address _receiver, OrderStatus _status) private {
231         require(orders[_orderId].paymentStatus != true);                        
232         
233         Order storage payment = orders[_orderId];
234         
235         _receiver.transfer(orders[_orderId].value);
236        
237         orders[_orderId].status = _status;
238         
239         orders[_orderId].paymentStatus = true;
240         
241         emit PaymentCompletion(_orderId, _receiver, payment.value, _status);
242     }
243     
244      function openDispute (uint256 _orderID) external onlyDisputeCreater(_orderID,msg.sender){ 
245         orders[_orderID].status = OrderStatus.Disputed;
246         orders[_orderID].disputeCreatedBy = msg.sender;
247     }
248     
249     function closeDispute (uint256 _orderID,uint256 _itemId, address _paymentSendTo) external onlyDisputeEnder(_orderID,msg.sender){
250         if (msg.sender == admin)
251         {
252             if (_paymentSendTo == orders[_orderID].customer)
253             {
254                 orders[_orderID].status = OrderStatus.Refunded;
255                 refund(_orderID, _itemId);
256             }
257             else if (_paymentSendTo == seller)
258             {
259                 orders[_orderID].status = OrderStatus.Completed;
260                 release(_orderID);
261             }
262         }
263         else if (msg.sender == orders[_orderID].customer)
264         {
265             orders[_orderID].status = OrderStatus.Completed;
266             release(_orderID);
267         }
268         else if (msg.sender == seller)
269         {
270             orders[_orderID].status = OrderStatus.Refunded;
271             refund(_orderID, _itemId);
272         }
273     }
274 
275 }