1 pragma solidity ^0.4.17;
2 
3 contract ERC20 {
4     uint public totalSupply;
5     function balanceOf(address who) public constant returns (uint);
6     function allowance(address owner, address spender) public constant returns (uint);
7 
8     function transfer(address to, uint value) public returns (bool ok);
9     function transferFrom(address from, address to, uint value) public returns (bool ok);
10     function approve(address spender, uint value) public returns (bool ok);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract SafeMath {
16     function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         if (a == 0) {
18             return 0;
19         }
20         c = a * b;
21         sAssert(c / a == b);
22         return c;
23     }
24 
25     function safeSub(uint a, uint b) pure internal returns (uint) {
26         sAssert(b <= a);
27         return a - b;
28     }
29 
30     function safeAdd(uint a, uint b) pure internal returns (uint) {
31         uint c = a + b;
32         sAssert(c>=a && c>=b);
33         return c;
34     }
35 
36     function sAssert(bool assertion) pure internal {
37         if (!assertion) {
38             revert();
39         }
40     }
41 }
42 
43 contract ArrayUtil {
44     function indexOf(bytes32[] array, bytes32 value)
45       internal
46       view
47       returns(uint)
48     {
49         bool found = false;
50         uint index = 0;
51 
52         for (uint i = 0; i < array.length; i++) {
53             if (array[i] == value) {
54                 found = true;
55                 index = i;
56                 break;
57             }
58         }
59 
60         require(found);
61         return index;
62     }
63 
64     function remove(bytes32[] array, bytes32 value)
65       internal
66       returns(bytes32[])
67     {
68         uint index = indexOf(array, value);
69         return removeAtIndex(array, index);
70     }
71 
72     function removeAtIndex(bytes32[] array, uint index)
73       internal
74       returns(bytes32[])
75     {
76         if (index >= array.length) return;
77 
78         bytes32[] memory arrayNew = new bytes32[](array.length - 1);
79 
80         for (uint i = 0; i < arrayNew.length; i++) {
81             if(i != index && i < index){
82                 arrayNew[i] = array[i];
83             } else {
84                 arrayNew[i] = array[i+1];
85             }
86         }
87 
88         delete array;
89         return arrayNew;
90     }
91 }
92 
93 
94 contract CentralityGiftShop is SafeMath, ArrayUtil {
95     // Struct and enum
96     struct Inventory {
97         string thumbURL;
98         string photoURL;
99         string name;
100         string description;
101     }
102 
103     struct Order {
104         bytes32 inventoryId;
105         uint price;
106         uint quantity;
107         string name;
108         string description;
109     }
110 
111     // Instance variables
112     mapping(bytes32 => Inventory) public stock;
113     mapping(bytes32 => uint) public stockPrice;
114     mapping(bytes32 => uint) public stockAvailableQuantity;
115     bytes32[] public stocks;
116 
117     address public owner;
118     address public paymentContractAddress;
119 
120     mapping(address => Order[]) orders;
121 
122     // Modifier
123     modifier onlyOwner() {
124         if (msg.sender != owner) {
125             revert();
126         }
127         _;
128     }
129 
130     // Init
131     function CentralityGiftShop()
132       public
133     {
134         owner = msg.sender;
135     }
136 
137     // Admin
138     function setPaymentContractAddress(address contractAddress)
139       public
140       onlyOwner()
141     {
142         paymentContractAddress = contractAddress;
143     }
144 
145     function withdraw()
146       public
147       onlyOwner()
148     {
149         require(paymentContractAddress != 0x0);
150 
151         uint balance = ERC20(paymentContractAddress).balanceOf(this);
152         require(balance > 0);
153 
154         if (!ERC20(paymentContractAddress).transfer(msg.sender, balance)) {
155             revert();
156         }
157     }
158 
159     function addInventory(
160         bytes32 inventoryId,
161         string thumbURL,
162         string photoURL,
163         string name,
164         string description,
165         uint price,
166         uint availableQuantity
167     )
168       public
169       onlyOwner()
170     {
171         Inventory memory inventory = Inventory({
172             thumbURL: thumbURL,
173             photoURL: photoURL,
174             name: name,
175             description: description
176         });
177 
178         stock[inventoryId] = inventory;
179         stockPrice[inventoryId] = price;
180         stockAvailableQuantity[inventoryId] = availableQuantity;
181 
182         stocks.push(inventoryId);
183     }
184 
185     function removeInventory(bytes32 inventoryId)
186       public
187       onlyOwner()
188     {
189         stocks = remove(stocks, inventoryId);
190     }
191 
192     function purchaseFor(address buyer, bytes32 inventoryId, uint quantity)
193      public
194      onlyOwner()
195     {
196         uint price = stockPrice[inventoryId];
197 
198         // Check if the order is sane
199         require(price > 0);
200         require(quantity > 0);
201         require(stockPrice[inventoryId] > 0);
202         require(safeSub(stockAvailableQuantity[inventoryId], quantity) >= 0);
203 
204         //Place Order
205         Inventory storage inventory = stock[inventoryId];
206 
207         Order memory order = Order({
208             name: inventory.name,
209             description: inventory.description,
210             inventoryId: inventoryId,
211             price: price,
212             quantity: quantity
213         });
214 
215         orders[buyer].push(order);
216         stockAvailableQuantity[inventoryId] = safeSub(stockAvailableQuantity[inventoryId], quantity);
217     }
218 
219     // Public
220     function getStockLength()
221       public
222       view
223       returns(uint) 
224     {
225         return stocks.length;
226     }
227     
228     function getOrderLength(address buyer)
229       public
230       view
231       returns(uint) 
232     {
233         return orders[buyer].length;
234     }
235 
236     function getOrder(address buyer, uint index)
237       public
238       view
239       returns(bytes32, uint, uint, string, string) 
240     {
241         Order o = orders[buyer][index];
242         return (o.inventoryId, o.price, o.quantity, o.name, o.description);
243     }
244     
245     function purchase(bytes32 inventoryId, uint quantity)
246       public
247     {
248         uint index = indexOf(stocks, inventoryId);
249         uint price = stockPrice[inventoryId];
250 
251         // Check if the order is sane
252         require(price > 0);
253         require(quantity > 0);
254         require(stockPrice[inventoryId] > 0);
255         require(safeSub(stockAvailableQuantity[inventoryId], quantity) >= 0);
256 
257         // Check cost
258         uint cost = safeMul(price, quantity);
259         require(cost > 0);
260 
261         if (!ERC20(paymentContractAddress).transferFrom(msg.sender, this, cost)) {
262             revert();
263         }
264 
265         Inventory storage inventory = stock[inventoryId];
266 
267         Order memory order = Order({
268             name: inventory.name,
269             description: inventory.description,
270             inventoryId: inventoryId,
271             price: price,
272             quantity: quantity
273         });
274 
275         orders[msg.sender].push(order);
276         stockAvailableQuantity[inventoryId] = safeSub(stockAvailableQuantity[inventoryId], quantity);
277     }
278 
279     // Default
280     function () public {
281         // Do not accept ether
282         revert();
283     }
284 }