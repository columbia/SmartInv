1 pragma solidity 0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 interface IERC20 {
54   function totalSupply() external view returns (uint256);
55 
56   function balanceOf(address who) external view returns (uint256);
57 
58   function allowance(address owner, address spender)
59     external view returns (uint256);
60 
61   function transfer(address to, uint256 value) external returns (bool);
62 
63   function approve(address spender, uint256 value)
64     external returns (bool);
65 
66   function transferFrom(address from, address to, uint256 value)
67     external returns (bool);
68 
69   event Transfer(
70     address indexed from,
71     address indexed to,
72     uint256 value
73   );
74 
75   event Approval(
76     address indexed owner,
77     address indexed spender,
78     uint256 value
79   );
80 }
81 
82 contract PurchaseContract {
83     
84   using SafeMath for uint256;
85   
86   uint requestedProducts;
87   
88   address applicationAddress = 0x8eDE6C5CDfFd4C6a8e6Da2157A37CE45A0602dB0;
89 
90   IERC20 token;
91 
92   struct Product {
93     uint id;
94     uint price;
95     uint unconfirmedRequests;
96     address[] buyers;
97     mapping (address => bool) isConfirmed;
98     address retailer;
99     address model;
100   }
101 
102   Product[] products;
103   
104   event Purchase(uint _id, uint _price, address _buyer, address _retailer, address _model);
105   
106   constructor(address _tokenAddress) public {
107     token = IERC20(_tokenAddress);
108   }
109 
110   function addProduct(uint _productId, uint _price) public {
111     require(_productId > 0);
112     require(_price > 0);
113     
114     Product memory _product = findProductById(_productId);
115     require(_product.id == 0);
116     
117     _product.id = _productId;
118     _product.price = _price;
119     _product.retailer = msg.sender;
120     _product.model = address(0);
121     
122     products.push(_product);
123     
124   }
125 
126   function addProducts(uint[] calldata _productIds, uint[] calldata _prices) external {
127     require(_productIds.length > 0);
128     require(_prices.length > 0);
129     require(_productIds.length == _prices.length);
130 
131     for(uint i = 0; i < _productIds.length; i++) {
132       addProduct(_productIds[i], _prices[i]);
133     }
134   }
135   
136   function purchaseRequest(uint _productId) external {
137     (Product memory _product, uint index) = findProductAndIndexById(_productId);
138     require(_productId != 0 && _product.id == _productId);
139     require(_product.price <= token.balanceOf(msg.sender));
140     
141     products[index] = _product;
142     
143     if(products[index].unconfirmedRequests == 0){
144        requestedProducts = requestedProducts.add(1);
145     }
146     
147     if(!isBuyerExist(index, msg.sender)) {
148         products[index].unconfirmedRequests = products[index].unconfirmedRequests.add(1);
149         products[index].buyers.push(msg.sender);
150     } else if(products[index].isConfirmed[msg.sender]){
151         products[index].unconfirmedRequests = products[index].unconfirmedRequests.add(1);
152     }
153     
154     
155     products[index].isConfirmed[msg.sender] = false;
156   }
157   
158   function isBuyerExist(uint _index, address _buyer) internal view returns(bool) {
159     
160     for(uint y = 0; y < products[_index].buyers.length; y++) {
161       if(products[_index].buyers[y] == _buyer) {
162         return true;
163       }
164     }
165     
166     return false;
167     
168   }
169 
170   function getProductPrice(uint _productId) external view returns(uint) {
171     Product memory _product = findProductById(_productId);
172     return _product.price;
173   }
174 
175   function getProductRetailer(uint _productId) external view returns(address) {
176     Product memory _product = findProductById(_productId);
177     return _product.retailer;
178   }
179   
180   function getProductBuyers(uint _productId) public view returns(address[] memory) {
181     Product memory _product = findProductById(_productId);
182     return _product.buyers;
183   }
184   
185   function getRequestedProducts() public view returns(uint[] memory) {
186     uint index;
187     uint[] memory results = new uint[](requestedProducts);
188     for(uint i = 0; i < products.length; i++) {
189         if(products[i].unconfirmedRequests > 0) {
190             results[index] = products[i].id;
191             index = index.add(1);
192         }
193     }
194     return results;
195   }
196   
197   function getRequestedProductsBy(address _buyer) public view returns(uint[] memory) {
198     uint index;
199     
200     for(uint i = 0; i < products.length; i++) {
201         if(products[i].unconfirmedRequests > 0 && isBuyerExist(i, _buyer) && products[i].isConfirmed[_buyer] == false) {
202             index = index.add(1);
203         }
204     }
205     
206     uint[] memory results = new uint[](index);
207     index = 0;
208     
209     for(uint i = 0; i < products.length; i++) {
210         if(products[i].unconfirmedRequests > 0 && isBuyerExist(i, _buyer) && products[i].isConfirmed[_buyer] == false) {
211             results[index] = products[i].id;
212             index = index.add(1);
213         }
214     }
215     return results;
216   }
217   
218   function getProductBuyersWithUnconfirmedRequests(uint _productId) external view returns(address[] memory) {
219     uint index;
220     (Product memory _product, uint i) = findProductAndIndexById(_productId);
221     address[] memory buyers = getProductBuyers(_productId);
222     address[] memory results = new address[](_product.unconfirmedRequests);
223     
224     for(uint y = 0; y < buyers.length; y++) {
225       if(!products[i].isConfirmed[buyers[y]]) {
226         results[index] = buyers[y];
227         index = index.add(1);
228       }
229     }
230     
231     return results;
232   }
233   
234   function isClientPayed(uint _productId, address _client) external view returns(bool) {
235     uint index = findProductIndexById(_productId);
236     return products[index].isConfirmed[_client];
237   }
238 
239   function confirmPurchase(uint _productId, address _buyer, address _model) external {
240     require(_productId != 0);
241 
242     (Product memory _product, uint index) = findProductAndIndexById(_productId);
243     
244     require(msg.sender == _product.retailer && _product.buyers.length != 0 && isBuyerExist(index, _buyer) && !products[index].isConfirmed[_buyer] && token.allowance(_buyer, address(this)) >= _product.price); 
245     
246     _product.model = _model;
247 
248     token.transferFrom(_buyer, _product.retailer, _product.price.mul(90).div(100));
249     token.transferFrom(_buyer, _product.model, _product.price.mul(4).div(100));
250     token.transferFrom(_buyer, applicationAddress, _product.price.mul(5).div(100));
251     
252     products[index] = _product;
253     
254     products[index].isConfirmed[_buyer] = true;
255     
256     products[index].unconfirmedRequests = products[index].unconfirmedRequests.sub(1);
257     if(products[index].unconfirmedRequests == 0){
258        requestedProducts = requestedProducts.sub(1);
259     }
260     
261     emit Purchase(_productId, _product.price, _buyer, _product.retailer, _model);
262   }
263 
264   function findProductAndIndexById(uint _productId) internal view returns(Product memory, uint) {
265     for(uint i = 0; i < products.length; i++) {
266        if(products[i].id == _productId){
267          return (products[i], i);
268        }
269     }
270     
271     Product memory product;
272     
273     return (product, 0);
274   }
275   
276   function findProductIndexById(uint _productId) internal view returns(uint) {
277     for(uint i = 0; i < products.length; i++) {
278        if(products[i].id == _productId){
279          return i;
280        }
281     }
282     
283     return 0;
284   }
285   
286   function findProductById(uint _productId) internal view returns(Product memory) {
287     for(uint i = 0; i < products.length; i++) {
288        if(products[i].id == _productId){
289          return products[i];
290        }
291     }
292     
293     Product memory product;
294     
295     return product;
296   }
297   
298   
299 }