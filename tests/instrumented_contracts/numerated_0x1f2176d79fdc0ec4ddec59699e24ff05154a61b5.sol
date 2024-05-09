1 pragma solidity ^0.4.24;
2 
3 //Slightly modified SafeMath library - includes a min function
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function min(uint a, uint b) internal pure returns (uint256) {
30     return a < b ? a : b;
31   }
32 }
33 
34 //ERC20 function interface
35 interface ERC20_Interface {
36   function totalSupply() external constant returns (uint);
37   function balanceOf(address _owner) external constant returns (uint);
38   function transfer(address _to, uint _amount) external returns (bool);
39   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
40   function approve(address _spender, uint _amount) external returns (bool);
41   function allowance(address _owner, address _spender) external constant returns (uint);
42 }
43 
44 
45 /**
46 *Exchange creates an exchange for the swaps.
47 */
48 contract Exchange{ 
49     using SafeMath for uint256;
50 
51     /*Variables*/
52     address public owner; //The owner of the market contract
53     
54     /*Structs*/
55     //This is the base data structure for an order (the maker of the order and the price)
56     struct Order {
57         address maker;// the placer of the order
58         uint price;// The price in wei
59         uint amount;
60         address asset;
61     }
62 
63     struct ListAsset {
64         uint price;
65         uint amount;
66     }
67 
68     mapping(address => ListAsset) public listOfAssets;
69     //Maps an OrderID to the list of orders
70     mapping(uint256 => Order) public orders;
71     //An mapping of a token address to the orderID's
72     mapping(address =>  uint256[]) public forSale;
73     //Index telling where a specific tokenId is in the forSale array
74     mapping(uint256 => uint256) internal forSaleIndex;
75     //Index telling where a specific tokenId is in the forSale array
76     address[] public openBooks;
77     //mapping of address to position in openBooks
78     mapping (address => uint) internal openBookIndex;
79     //mapping of user to their orders
80     mapping(address => uint[]) public userOrders;
81     //mapping from orderId to userOrder position
82     mapping(uint => uint) internal userOrderIndex;
83     //A list of the blacklisted addresses
84     mapping(address => bool) internal blacklist;
85     //order_nonce;
86     uint internal order_nonce;
87 
88     /*Events*/
89     event OrderPlaced(address _sender,address _token, uint256 _amount, uint256 _price);
90     event Sale(address _sender,address _token, uint256 _amount, uint256 _price);
91     event OrderRemoved(address _sender,address _token, uint256 _amount, uint256 _price);
92 
93     /*Modifiers*/
94     /**
95     *@dev Access modifier for Owner functionality
96     */
97     modifier onlyOwner() {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     /*Functions*/
103     /**
104     *@dev the constructor argument to set the owner and initialize the array.
105     */
106     constructor() public{
107         owner = msg.sender;
108         openBooks.push(address(0));
109         order_nonce = 1;
110     }
111 
112     /**
113     *@dev list allows a party to place an order on the orderbook
114     *@param _tokenadd address of the drct tokens
115     *@param _amount number of DRCT tokens
116     *@param _price uint256 price of all tokens in wei
117     */
118     function list(address _tokenadd, uint256 _amount, uint256 _price) external {
119         require(blacklist[msg.sender] == false);
120         require(_price > 0);
121         ERC20_Interface token = ERC20_Interface(_tokenadd);
122         require(token.allowance(msg.sender,address(this)) >= _amount);
123         if(forSale[_tokenadd].length == 0){
124             forSale[_tokenadd].push(0);
125             }
126         forSaleIndex[order_nonce] = forSale[_tokenadd].length;
127         forSale[_tokenadd].push(order_nonce);
128         orders[order_nonce] = Order({
129             maker: msg.sender,
130             asset: _tokenadd,
131             price: _price,
132             amount:_amount
133         });
134         emit OrderPlaced(msg.sender,_tokenadd,_amount,_price);
135         if(openBookIndex[_tokenadd] == 0 ){    
136             openBookIndex[_tokenadd] = openBooks.length;
137             openBooks.push(_tokenadd);
138         }
139         userOrderIndex[order_nonce] = userOrders[msg.sender].length;
140         userOrders[msg.sender].push(order_nonce);
141         order_nonce += 1;
142     }
143 
144     /**
145     *@dev list allows a party to list an order on the orderbook
146     *@param _asset address of the drct tokens
147     *@param _amount number of DRCT tokens
148     *@param _price uint256 price per unit in wei
149     */
150     //Then you would have a mapping from an asset to its price/ quantity when you list it.
151     function listDda(address _asset, uint256 _amount, uint256 _price) public onlyOwner() {
152         require(blacklist[msg.sender] == false);
153         ListAsset storage listing = listOfAssets[_asset];
154         listing.price = _price;
155         listing.amount= _amount;
156     }
157 
158     /**
159     *@dev buy allows a party to partially fill an order
160     *@param _asset is the address of the assset listed
161     *@param _amount is the amount of tokens to buy
162     */
163     function buyPerUnit(address _asset, uint256 _amount) external payable {
164         require(blacklist[msg.sender] == false);
165         ListAsset storage listing = listOfAssets[_asset];
166         require(_amount <= listing.amount);
167         require(msg.value == _amount.mul(listing.price));
168         listing.amount= listing.amount.sub(_amount);
169     }
170 
171     /**
172     *@dev unlist allows a party to remove their order from the orderbook
173     *@param _orderId is the uint256 ID of order
174     */
175     function unlist(uint256 _orderId) external{
176         require(forSaleIndex[_orderId] > 0);
177         Order memory _order = orders[_orderId];
178         require(msg.sender== _order.maker || msg.sender == owner);
179         unLister(_orderId,_order);
180         emit OrderRemoved(msg.sender,_order.asset,_order.amount,_order.price);
181     }
182 
183     /**
184     *@dev buy allows a party to fill an order
185     *@param _orderId is the uint256 ID of order
186     */
187     function buy(uint256 _orderId) external payable {
188         Order memory _order = orders[_orderId];
189         require(_order.price != 0 && _order.maker != address(0) && _order.asset != address(0) && _order.amount != 0);
190         require(msg.value == _order.price);
191         require(blacklist[msg.sender] == false);
192         address maker = _order.maker;
193         ERC20_Interface token = ERC20_Interface(_order.asset);
194         if(token.allowance(_order.maker,address(this)) >= _order.amount){
195             assert(token.transferFrom(_order.maker,msg.sender, _order.amount));
196             maker.transfer(_order.price);
197         }
198         unLister(_orderId,_order);
199         emit Sale(msg.sender,_order.asset,_order.amount,_order.price);
200     }
201 
202     /**
203     *@dev getOrder lists the price,amount, and maker of a specific token for a sale
204     *@param _orderId uint256 ID of order
205     *@return address of the party selling
206     *@return uint of the price of the sale (in wei)
207     *@return uint of the order amount of the sale
208     *@return address of the token
209     */
210     function getOrder(uint256 _orderId) external view returns(address,uint,uint,address){
211         Order storage _order = orders[_orderId];
212         return (_order.maker,_order.price,_order.amount,_order.asset);
213     }
214 
215     /**
216     *@dev allows the owner to change who the owner is
217     *@param _owner is the address of the new owner
218     */
219     function setOwner(address _owner) public onlyOwner() {
220         owner = _owner;
221     }
222 
223     /**
224     *@notice This allows the owner to stop a malicious party from spamming the orderbook
225     *@dev Allows the owner to blacklist addresses from using this exchange
226     *@param _address the address of the party to blacklist
227     *@param _motion true or false depending on if blacklisting or not
228     */
229     function blacklistParty(address _address, bool _motion) public onlyOwner() {
230         blacklist[_address] = _motion;
231     }
232 
233     /**
234     *@dev Allows parties to see if one is blacklisted
235     *@param _address the address of the party to blacklist
236     *@return bool true for is blacklisted
237     */
238     function isBlacklist(address _address) public view returns(bool) {
239         return blacklist[_address];
240     }
241 
242     /**
243     *@dev getOrderCount allows parties to query how many orders are on the book
244     *@param _token address used to count the number of orders
245     *@return _uint of the number of orders in the orderbook
246     */
247     function getOrderCount(address _token) public constant returns(uint) {
248         return forSale[_token].length;
249     }
250 
251     /**
252     *@dev Gets number of open orderbooks
253     *@return _uint of the number of tokens with open orders
254     */
255     function getBookCount() public constant returns(uint) {
256         return openBooks.length;
257     }
258 
259     /**
260     *@dev getOrders allows parties to get an array of all orderId's open for a given token
261     *@param _token address of the drct token
262     *@return _uint[] an array of the orders in the orderbook
263     */
264     function getOrders(address _token) public constant returns(uint[]) {
265         return forSale[_token];
266     }
267 
268     /**
269     *@dev getUserOrders allows parties to get an array of all orderId's open for a given user
270     *@param _user address 
271     *@return _uint[] an array of the orders in the orderbook for the user
272     */
273     function getUserOrders(address _user) public constant returns(uint[]) {
274         return userOrders[_user];
275     }
276 
277     /**
278     *@dev An internal function to update mappings when an order is removed from the book
279     *@param _orderId is the uint256 ID of order
280     *@param _order is the struct containing the details of the order
281     */
282     function unLister(uint256 _orderId, Order _order) internal{
283             uint256 tokenIndex;
284             uint256 lastTokenIndex;
285             address lastAdd;
286             uint256  lastToken;
287         if(forSale[_order.asset].length == 2){
288             tokenIndex = openBookIndex[_order.asset];
289             lastTokenIndex = openBooks.length.sub(1);
290             lastAdd = openBooks[lastTokenIndex];
291             openBooks[tokenIndex] = lastAdd;
292             openBookIndex[lastAdd] = tokenIndex;
293             openBooks.length--;
294             openBookIndex[_order.asset] = 0;
295             forSale[_order.asset].length -= 2;
296         }
297         else{
298             tokenIndex = forSaleIndex[_orderId];
299             lastTokenIndex = forSale[_order.asset].length.sub(1);
300             lastToken = forSale[_order.asset][lastTokenIndex];
301             forSale[_order.asset][tokenIndex] = lastToken;
302             forSaleIndex[lastToken] = tokenIndex;
303             forSale[_order.asset].length--;
304         }
305         forSaleIndex[_orderId] = 0;
306         orders[_orderId] = Order({
307             maker: address(0),
308             price: 0,
309             amount:0,
310             asset: address(0)
311         });
312         if(userOrders[_order.maker].length > 1){
313             tokenIndex = userOrderIndex[_orderId];
314             lastTokenIndex = userOrders[_order.maker].length.sub(1);
315             lastToken = userOrders[_order.maker][lastTokenIndex];
316             userOrders[_order.maker][tokenIndex] = lastToken;
317             userOrderIndex[lastToken] = tokenIndex;
318         }
319         userOrders[_order.maker].length--;
320         userOrderIndex[_orderId] = 0;
321     }
322 }