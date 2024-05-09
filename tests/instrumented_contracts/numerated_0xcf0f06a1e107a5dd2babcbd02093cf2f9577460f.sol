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
88   IERC20 token;
89 
90   struct Product {
91     uint id;
92     uint price;
93     uint unconfirmedRequests;
94     address[] buyers;
95     mapping (address => bool) isConfirmed;
96     address retailer;
97     address model;
98   }
99 
100   Product[] products;
101   
102   event Purchase(uint _id, uint _price, address _buyer, address _retailer, address _model);
103   
104   constructor(address _tokenAddress) public {
105     token = IERC20(_tokenAddress);
106   }
107 
108   function addProduct(uint _productId, uint _price) public {
109     require(_productId > 0);
110     require(_price > 0);
111     
112     Product memory _product = findProductById(_productId);
113     require(_product.id == 0);
114     
115     _product.id = _productId;
116     _product.price = _price;
117     _product.retailer = msg.sender;
118     _product.model = address(0);
119     
120     products.push(_product);
121     
122   }
123 
124   function addProducts(uint[] calldata _productIds, uint[] calldata _prices) external {
125     require(_productIds.length > 0);
126     require(_prices.length > 0);
127     require(_productIds.length == _prices.length);
128 
129     for(uint i = 0; i < _productIds.length; i++) {
130       addProduct(_productIds[i], _prices[i]);
131     }
132   }
133   
134   function purchaseRequest(uint _productId) external {
135     (Product memory _product, uint index) = findProductAndIndexById(_productId);
136     require(_productId != 0 && _product.id == _productId);
137     require(_product.price <= token.balanceOf(msg.sender));
138     
139     products[index] = _product;
140     
141     if(products[index].unconfirmedRequests == 0){
142        requestedProducts = requestedProducts.add(1);
143     }
144     
145     if(!isBuyerExist(index, msg.sender)) {
146         products[index].unconfirmedRequests = products[index].unconfirmedRequests.add(1);
147         products[index].buyers.push(msg.sender);
148     } else if(products[index].isConfirmed[msg.sender]){
149         products[index].unconfirmedRequests = products[index].unconfirmedRequests.add(1);
150     }
151     
152     
153     products[index].isConfirmed[msg.sender] = false;
154   }
155   
156   function isBuyerExist(uint _index, address _buyer) internal view returns(bool) {
157     
158     for(uint y = 0; y < products[_index].buyers.length; y++) {
159       if(products[_index].buyers[y] == _buyer) {
160         return true;
161       }
162     }
163     
164     return false;
165     
166   }
167 
168   function getProductPrice(uint _productId) external view returns(uint) {
169     Product memory _product = findProductById(_productId);
170     return _product.price;
171   }
172 
173   function getProductRetailer(uint _productId) external view returns(address) {
174     Product memory _product = findProductById(_productId);
175     return _product.retailer;
176   }
177   
178   function getProductBuyers(uint _productId) public view returns(address[] memory) {
179     Product memory _product = findProductById(_productId);
180     return _product.buyers;
181   }
182   
183   function getRequestedProducts() public view returns(uint[] memory) {
184     uint index;
185     uint[] memory results = new uint[](requestedProducts);
186     for(uint i = 0; i < products.length; i++) {
187         if(products[i].unconfirmedRequests > 0) {
188             results[index] = products[i].id;
189             index = index.add(1);
190         }
191     }
192     return results;
193   }
194   
195   function getRequestedProductsBy(address _buyer) public view returns(uint[] memory) {
196     uint index;
197     uint[] memory results = new uint[](requestedProducts);
198     for(uint i = 0; i < products.length; i++) {
199         if(products[i].unconfirmedRequests > 0 && products[i].isConfirmed[_buyer] == false) {
200             results[index] = products[i].id;
201             index = index.add(1);
202         }
203     }
204     return results;
205   }
206   
207   function getProductBuyersWithUnconfirmedRequests(uint _productId) external view returns(address[] memory) {
208     uint index;
209     (Product memory _product, uint i) = findProductAndIndexById(_productId);
210     address[] memory buyers = getProductBuyers(_productId);
211     address[] memory results = new address[](_product.unconfirmedRequests);
212     
213     for(uint y = 0; y < buyers.length; y++) {
214       if(!products[i].isConfirmed[buyers[y]]) {
215         results[index] = buyers[y];
216         index = index.add(1);
217       }
218     }
219     
220     return results;
221   }
222   
223   function isClientPayed(uint _productId, address _client) external view returns(bool) {
224     uint index = findProductIndexById(_productId);
225     return products[index].isConfirmed[_client];
226   }
227 
228   function confirmPurchase(uint _productId, address _buyer, address _model) external {
229     require(_productId != 0);
230 
231     (Product memory _product, uint index) = findProductAndIndexById(_productId);
232     
233     require(msg.sender == _product.retailer && _product.buyers.length != 0 && isBuyerExist(index, _buyer) && !products[index].isConfirmed[_buyer] && token.allowance(_buyer, address(this)) >= _product.price); 
234     
235     _product.model = _model;
236 
237     token.transferFrom(_buyer, _product.retailer, _product.price.mul(90).div(100));
238     token.transferFrom(_buyer, _product.model, _product.price.mul(6).div(100));
239     
240     products[index] = _product;
241     
242     products[index].isConfirmed[_buyer] = true;
243     
244     products[index].unconfirmedRequests = products[index].unconfirmedRequests.sub(1);
245     if(products[index].unconfirmedRequests == 0){
246        requestedProducts = requestedProducts.sub(1);
247     }
248     
249     emit Purchase(_productId, _product.price, _buyer, _product.retailer, _model);
250   }
251 
252   function findProductAndIndexById(uint _productId) internal view returns(Product memory, uint) {
253     for(uint i = 0; i < products.length; i++) {
254        if(products[i].id == _productId){
255          return (products[i], i);
256        }
257     }
258     
259     Product memory product;
260     
261     return (product, 0);
262   }
263   
264   function findProductIndexById(uint _productId) internal view returns(uint) {
265     for(uint i = 0; i < products.length; i++) {
266        if(products[i].id == _productId){
267          return i;
268        }
269     }
270     
271     return 0;
272   }
273   
274   function findProductById(uint _productId) internal view returns(Product memory) {
275     for(uint i = 0; i < products.length; i++) {
276        if(products[i].id == _productId){
277          return products[i];
278        }
279     }
280     
281     Product memory product;
282     
283     return product;
284   }
285   
286   
287 }