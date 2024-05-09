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
86   uint purchasedProductsCount;
87   uint unPurchasedProductsCount;
88 
89   IERC20 token;
90 
91   struct Product {
92     uint id;
93     uint price;
94     address buyer;
95     address retailer;
96     address model;
97     bool purchased;
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
108   function addProduct(uint _productId, uint _price) external {
109     require(_productId > 0);
110     require(_price > 0);
111 
112     products.push(Product(_productId, _price, address(0), msg.sender, address(0), false));
113     unPurchasedProductsCount = unPurchasedProductsCount.add(1);
114   }
115 
116   function addProducts(uint[] calldata _productIds, uint[] calldata _prices) external {
117     require(_productIds.length > 0);
118     require(_prices.length > 0);
119     require(_productIds.length == _prices.length);
120 
121     for(uint i = 0; i < _productIds.length; i++) {
122       require(_productIds[i] > 0 && _prices[i] > 0); 
123       products.push(Product(_productIds[i], _prices[i], address(0), msg.sender, address(0), false));
124       unPurchasedProductsCount = unPurchasedProductsCount.add(1);
125     }
126   }
127   
128   function purchaseRequest(uint _productId) external {
129     (Product memory _product, uint index) = findProductAndIndexById(_productId);
130     require(_productId != 0 && _product.id == _productId && _product.purchased == false);
131     require(_product.buyer == address(0));
132     require(_product.price <= token.balanceOf(msg.sender));
133     _product.buyer = msg.sender;
134      products[index] = _product;
135   }
136 
137   function getProductPrice(uint _productId) external view returns(uint) {
138     Product memory _product = findProductById(_productId);
139     return _product.price;
140   }
141 
142   function getProductRetailer(uint _productId) external view returns(address) {
143     Product memory _product = findProductById(_productId);
144     return _product.retailer;
145   }
146   
147   function getProductBuyer(uint _productId) external view returns(address) {
148     Product memory _product = findProductById(_productId);
149     return _product.buyer;
150   }
151   
152   function isPurchased(uint _productId) external view returns(bool) {
153     Product memory _product = findProductById(_productId);
154     return _product.purchased;
155   }
156 
157   function getUnPurchasedProducts() external view returns(uint[] memory) {
158     uint index;
159     bool isEmpty = true;
160     uint[] memory results = new uint[](unPurchasedProductsCount);
161 
162     for(uint i = 0; i < products.length; i++) {
163        if(!products[i].purchased){
164          results[index] = products[i].id;
165          index = index.add(1);
166          isEmpty = false;
167        }
168     }
169     
170     if(isEmpty) {
171         return new uint[](1);
172     }
173     
174     return results;
175   }
176   
177   function getPurchasedProducts() external view returns(uint[] memory) {
178     uint index;
179     bool isEmpty = true;
180     uint[] memory results = new uint[](purchasedProductsCount);
181 
182     for(uint i = 0; i < products.length; i++) {
183        if(products[i].purchased){
184          results[index] = products[i].id;
185          index = index.add(1);
186          isEmpty = false;
187        }
188     }
189     
190     if(isEmpty) {
191         return new uint[](1);
192     }
193 
194     return results;
195   }
196 
197   function confirmPurchase(uint _productId, address _model) external {
198     require(_productId != 0);
199 
200     (Product memory _product, uint index) = findProductAndIndexById(_productId);
201 
202     require(msg.sender == _product.retailer && _product.buyer != address(0) && token.allowance(_product.buyer, address(this)) >= _product.price); 
203 
204     _product.model = _model;
205 
206     token.transferFrom(_product.buyer, _product.retailer, _product.price.mul(90).div(100));
207     token.transferFrom(_product.buyer, _product.model, _product.price.mul(6).div(100));
208     
209     _product.purchased = true;
210     purchasedProductsCount = purchasedProductsCount.add(1);
211     unPurchasedProductsCount = unPurchasedProductsCount.sub(1);
212     
213     products[index] = _product;
214 
215     emit Purchase(_productId, _product.price, _product.buyer, _product.retailer, _model);
216   }
217 
218   function findProductAndIndexById(uint _productId) internal view returns(Product memory, uint) {
219     for(uint i = 0; i < products.length; i++) {
220        if(products[i].id == _productId){
221          return (products[i], i);
222        }
223     }
224     
225     return (Product(0, 1, address(0), address(0), address(0), false), 0);
226   }
227   
228   function findProductById(uint _productId) internal view returns(Product memory) {
229     for(uint i = 0; i < products.length; i++) {
230        if(products[i].id == _productId){
231          return products[i];
232        }
233     }
234     
235     return Product(0, 1, address(0), address(0), address(0), false);
236   }
237   
238   
239 }