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
95     mapping (address => uint) purchaseAmount;
96     mapping (address => bool) isConfirmed;
97     address retailer;
98     address model;
99   }
100 
101   Product[] products;
102   
103   event Purchase(uint _id, uint _price, address _buyer, address _retailer, address _model);
104   
105   constructor(address _tokenAddress) public {
106     token = IERC20(_tokenAddress);
107   }
108 
109   function addProduct(uint _productId, uint _price) public {
110     require(_productId > 0);
111     require(_price > 0);
112     
113     Product memory _product = findProductById(_productId);
114     require(_product.id == 0);
115     
116     _product.id = _productId;
117     _product.price = _price;
118     _product.retailer = msg.sender;
119     _product.model = address(0);
120     
121     products.push(_product);
122     
123   }
124 
125   function addProducts(uint[] calldata _productIds, uint[] calldata _prices) external {
126     require(_productIds.length > 0);
127     require(_prices.length > 0);
128     require(_productIds.length == _prices.length);
129 
130     for(uint i = 0; i < _productIds.length; i++) {
131       addProduct(_productIds[i], _prices[i]);
132     }
133   }
134   
135   function purchaseRequest(uint _productId, uint _amount) external {
136     (Product memory _product, uint index) = findProductAndIndexById(_productId);
137     require(_productId != 0 && _product.id == _productId);
138     require(_product.price <= token.balanceOf(msg.sender));
139     require(_amount > 0);
140     
141     products[index] = _product;
142     products[index].buyers.push(msg.sender);
143     products[index].purchaseAmount[msg.sender] = _amount;
144     if(products[index].unconfirmedRequests == 0){
145        requestedProducts = requestedProducts.add(1);
146     }
147     products[index].unconfirmedRequests = products[index].unconfirmedRequests.add(1);
148   }
149 
150   function getProductPrice(uint _productId) external view returns(uint) {
151     Product memory _product = findProductById(_productId);
152     return _product.price;
153   }
154 
155   function getProductRetailer(uint _productId) external view returns(address) {
156     Product memory _product = findProductById(_productId);
157     return _product.retailer;
158   }
159   
160   function getProductBuyers(uint _productId) public view returns(address[] memory) {
161     Product memory _product = findProductById(_productId);
162     return _product.buyers;
163   }
164   
165   function getRequestedProducts() public view returns(uint[] memory) {
166     uint index;
167     uint[] memory results = new uint[](requestedProducts);
168     for(uint i = 0; i < products.length; i++) {
169         if(products[i].unconfirmedRequests > 0) {
170             results[index] = products[i].id;
171             index = index.add(1);
172         }
173     }
174     return results;
175   }
176   
177   function getRequestedProductsBy(address _buyer) public view returns(uint[] memory) {
178     uint index;
179     uint[] memory results = new uint[](requestedProducts);
180     for(uint i = 0; i < products.length; i++) {
181         if(products[i].unconfirmedRequests > 0 && products[i].purchaseAmount[_buyer] > 0 && products[i].isConfirmed[_buyer] == false) {
182             results[index] = products[i].id;
183             index = index.add(1);
184         }
185     }
186     return results;
187   }
188   
189   function getProductBuyersWithUnconfirmedRequests(uint _productId) external view returns(address[] memory) {
190     uint index;
191     (Product memory _product, uint i) = findProductAndIndexById(_productId);
192     address[] memory buyers = getProductBuyers(_productId);
193     address[] memory results = new address[](_product.unconfirmedRequests);
194     
195     for(uint y = 0; y < buyers.length; y++) {
196       if(!products[i].isConfirmed[buyers[y]]) {
197         results[index] = buyers[y];
198         index = index.add(1);
199       }
200     }
201     
202     return results;
203   }
204   
205   function isClientPayed(uint _productId, address _client) external view returns(bool) {
206     uint index = findProductIndexById(_productId);
207     return products[index].isConfirmed[_client];
208   }
209 
210   function confirmPurchase(uint _productId, address _buyer, address _model) external {
211     require(_productId != 0);
212 
213     (Product memory _product, uint index) = findProductAndIndexById(_productId);
214     
215     require(msg.sender == _product.retailer && _product.buyers.length != 0 && token.allowance(_buyer, address(this)) >= _product.price); 
216     require(products[index].purchaseAmount[_buyer] > 0);
217     
218     _product.model = _model;
219 
220     token.transferFrom(_buyer, _product.retailer, _product.price.mul(90).div(100));
221     token.transferFrom(_buyer, _product.model, _product.price.mul(6).div(100));
222     
223     products[index] = _product;
224     
225     products[index].isConfirmed[_buyer] = true;
226     products[index].unconfirmedRequests = products[index].unconfirmedRequests.sub(1);
227     if(products[index].unconfirmedRequests == 0){
228        requestedProducts = requestedProducts.sub(1);
229     }
230     
231     emit Purchase(_productId, _product.price, _buyer, _product.retailer, _model);
232   }
233 
234   function findProductAndIndexById(uint _productId) internal view returns(Product memory, uint) {
235     for(uint i = 0; i < products.length; i++) {
236        if(products[i].id == _productId){
237          return (products[i], i);
238        }
239     }
240     
241     Product memory product;
242     
243     return (product, 0);
244   }
245   
246   function findProductIndexById(uint _productId) internal view returns(uint) {
247     for(uint i = 0; i < products.length; i++) {
248        if(products[i].id == _productId){
249          return i;
250        }
251     }
252     
253     return 0;
254   }
255   
256   function findProductById(uint _productId) internal view returns(Product memory) {
257     for(uint i = 0; i < products.length; i++) {
258        if(products[i].id == _productId){
259          return products[i];
260        }
261     }
262     
263     Product memory product;
264     
265     return product;
266   }
267   
268   
269 }