1 pragma solidity ^0.4.23;
2 
3 contract TecoIco {
4     function bonusOf(address _owner) public view returns (uint256);
5 }
6 
7 contract TecoToken {
8     function balanceOf(address who) public view returns (uint256);
9 
10     function allowance(address _owner, address _spender) public view returns (uint256);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function approve(address spender, uint256 value) public returns (bool);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28         // benefit is lost if 'b' is also tested.
29         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers, truncating the quotient.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         // uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return a / b;
47     }
48 
49     /**
50     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     /**
58     * @dev Adds two numbers, throws on overflow.
59     */
60     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 
68 
69 /**
70  * @title Ownable
71  * @dev The Ownable contract has an owner address, and provides basic authorization control
72  * functions, this simplifies the implementation of "user permissions".
73  */
74 contract Ownable {
75     address public owner;
76 
77 
78     event OwnershipRenounced(address indexed previousOwner);
79     event OwnershipTransferred(
80         address indexed previousOwner,
81         address indexed newOwner
82     );
83 
84 
85     /**
86      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
87      * account.
88      */
89     constructor() public {
90         owner = msg.sender;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     /**
102      * @dev Allows the current owner to relinquish control of the contract.
103      * @notice Renouncing to ownership will leave the contract without an owner.
104      * It will not be possible to call the functions with the `onlyOwner`
105      * modifier anymore.
106      */
107     function renounceOwnership() public onlyOwner {
108         emit OwnershipRenounced(owner);
109         owner = address(0);
110     }
111 
112     /**
113      * @dev Allows the current owner to transfer control of the contract to a newOwner.
114      * @param _newOwner The address to transfer ownership to.
115      */
116     function transferOwnership(address _newOwner) public onlyOwner {
117         _transferOwnership(_newOwner);
118     }
119 
120     /**
121      * @dev Transfers control of the contract to a newOwner.
122      * @param _newOwner The address to transfer ownership to.
123      */
124     function _transferOwnership(address _newOwner) internal {
125         require(_newOwner != address(0));
126         emit OwnershipTransferred(owner, _newOwner);
127         owner = _newOwner;
128     }
129 }
130 
131 
132 contract TecoBuyBack is Ownable {
133     using SafeMath for uint256;
134 
135     TecoIco public tecoIco;
136     TecoToken public tecoToken;
137 
138     mapping(address => uint256) tokensBought;
139 
140     uint256 public rate;
141     uint256 public numOrders;
142 
143     enum OrderStatus {None, Pending, Payed, Deleted}
144 
145     struct Order {
146         address investor;
147         uint amount;
148         OrderStatus status;
149     }
150 
151     mapping(uint256 => Order) orders;
152 
153     constructor(TecoIco _tecoIco, TecoToken _tecoToken) public{
154         require(_tecoIco != address(0));
155         require(_tecoToken != address(0));
156 
157         tecoIco = _tecoIco;
158         tecoToken = _tecoToken;
159     }
160 
161     function() external payable {}
162 
163     function withdrawAllFunds()
164     public
165     onlyOwner
166     {
167         owner.transfer(address(this).balance);
168     }
169 
170     function withdrawFunds(uint value)
171     public
172     onlyOwner
173     {
174         owner.transfer(value);
175     }
176 
177     function availableBonuses(address investor) public view returns (uint256) {
178         if (tecoIco.bonusOf(investor) <= tokensBought[investor]) return 0;
179         return tecoIco.bonusOf(investor).sub(tokensBought[investor]);
180     }
181 
182     function setRate(uint256 _rate)
183     public
184     onlyOwner
185     {
186         rate = _rate;
187     }
188 
189     function createOrder(uint256 _amount)
190     public
191     returns (uint256)
192     {
193         require(availableBonuses(msg.sender) >= _amount);
194         require(tecoToken.allowance(msg.sender, address(this)) >= _amount);
195         orders[numOrders++] = Order(msg.sender, _amount, OrderStatus.Pending);
196         return numOrders - 1;
197     }
198 
199     function calculateSum(uint256 amount)
200     public
201     view
202     returns (uint256)
203     {
204         return amount.div(rate);
205     }
206 
207     function orderSum(uint256 orderId)
208     public
209     view
210     returns (uint256)
211     {
212         return calculateSum(orders[orderId].amount);
213     }
214 
215     function payOrders(uint256 orderId_1, uint256 orderId_2, uint256 orderId_3, uint256 orderId_4, uint256 orderId_5)
216     public
217     onlyOwner
218     {
219         if (orderId_1 >= 0) payOrder(orderId_1);
220         if (orderId_2 >= 0) payOrder(orderId_2);
221         if (orderId_3 >= 0) payOrder(orderId_3);
222         if (orderId_4 >= 0) payOrder(orderId_4);
223         if (orderId_5 >= 0) payOrder(orderId_5);
224     }
225 
226     function payOrder(uint256 orderId)
227     public
228     onlyOwner
229     {
230         require(address(this).balance >= orderSum(orderId));
231         require(orders[orderId].status == OrderStatus.Pending);
232 
233         orders[orderId].status = OrderStatus.Payed;
234         orders[orderId].investor.transfer(orderSum(orderId));
235         tecoToken.transferFrom(orders[orderId].investor, owner, orders[orderId].amount);
236         tokensBought[orders[orderId].investor] += orders[orderId].amount;
237     }
238 
239     function deleteOrder(uint256 orderId)
240     public
241     {
242         require(orders[orderId].investor == msg.sender || owner == msg.sender);
243         require(orders[orderId].status == OrderStatus.Pending);
244         orders[orderId].status = OrderStatus.Deleted;
245     }
246 
247     function getOrderInvestor(uint256 orderId)
248     public
249     view
250     returns (address)
251     {
252         return orders[orderId].investor;
253     }
254 
255     function getOrderAmount(uint256 orderId)
256     public
257     view
258     returns (uint256)
259     {
260         return orders[orderId].amount;
261     }
262 
263     function getOrderStatus(uint256 orderId)
264     public
265     view
266     returns (OrderStatus)
267     {
268         return orders[orderId].status;
269     }
270 
271     function getTokensBought(address investor)
272     public
273     view
274     returns (uint256)
275     {
276         return tokensBought[investor];
277     }
278 }