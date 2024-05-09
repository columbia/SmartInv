1 pragma solidity ^0.4.24;
2 
3 // File: contracts\interfaces\ERC20_Interface.sol
4 
5 //ERC20 function interface
6 interface ERC20_Interface {
7   function totalSupply() external constant returns (uint);
8   function balanceOf(address _owner) external constant returns (uint);
9   function transfer(address _to, uint _amount) external returns (bool);
10   function transferFrom(address _from, address _to, uint _amount) external returns (bool);
11   function approve(address _spender, uint _amount) external returns (bool);
12   function allowance(address _owner, address _spender) external constant returns (uint);
13 }
14 
15 // File: contracts\libraries\SafeMath.sol
16 
17 //Slightly modified SafeMath library - includes a min function
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 
43   function min(uint a, uint b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 // File: contracts\Exchange.sol
49 
50 /**
51 *Exchange creates an exchange for the swaps.
52 */
53 contract Exchange{ 
54     using SafeMath for uint256;
55 
56     /*Variables*/
57 
58     
59     /*Structs*/
60     //This is the base data structure for an order (the maker of the order and the price)
61     struct Order {
62         address maker;// the placer of the order
63         uint price;// The price in wei
64         uint amount;
65         address asset;
66     }
67 
68     struct ListAsset {
69         uint price;
70         uint amount;
71         bool isLong;  
72     }
73 
74     //order_nonce;
75     uint internal order_nonce;
76     address public owner; //The owner of the market contract
77     address[] public openDdaListAssets;
78     //Index telling where a specific tokenId is in the forSale array
79     address[] public openBooks;
80     mapping (address => uint) public openDdaListIndex;
81     mapping(address => ListAsset) public listOfAssets;
82     //Maps an OrderID to the list of orders
83     mapping(uint256 => Order) public orders;
84     //An mapping of a token address to the orderID's
85     mapping(address =>  uint256[]) public forSale;
86     //Index telling where a specific tokenId is in the forSale array
87     mapping(uint256 => uint256) internal forSaleIndex;
88     
89     //mapping of address to position in openBooks
90     mapping (address => uint) internal openBookIndex;
91     //mapping of user to their orders
92     mapping(address => uint[]) public userOrders;
93     //mapping from orderId to userOrder position
94     mapping(uint => uint) internal userOrderIndex;
95     //A list of the blacklisted addresses
96     mapping(address => bool) internal blacklist;
97     
98 
99     /*Events*/
100     event OrderPlaced(address _sender,address _token, uint256 _amount, uint256 _price);
101     event Sale(address _sender,address _token, uint256 _amount, uint256 _price);
102     event OrderRemoved(address _sender,address _token, uint256 _amount, uint256 _price);
103 
104     /*Modifiers*/
105     /**
106     *@dev Access modifier for Owner functionality
107     */
108     modifier onlyOwner() {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     /*Functions*/
114     /**
115     *@dev the constructor argument to set the owner and initialize the array.
116     */
117     constructor() public{
118         owner = msg.sender;
119         openBooks.push(address(0));
120         order_nonce = 1;
121     }
122 
123     /**
124     *@dev list allows a party to place an order on the orderbook
125     *@param _tokenadd address of the drct tokens
126     *@param _amount number of DRCT tokens
127     *@param _price uint256 price of all tokens in wei
128     */
129     function list(address _tokenadd, uint256 _amount, uint256 _price) external {
130         require(blacklist[msg.sender] == false);
131         require(_price > 0);
132         ERC20_Interface token = ERC20_Interface(_tokenadd);
133         require(token.allowance(msg.sender,address(this)) >= _amount);
134         if(forSale[_tokenadd].length == 0){
135             forSale[_tokenadd].push(0);
136             }
137         forSaleIndex[order_nonce] = forSale[_tokenadd].length;
138         forSale[_tokenadd].push(order_nonce);
139         orders[order_nonce] = Order({
140             maker: msg.sender,
141             asset: _tokenadd,
142             price: _price,
143             amount:_amount
144         });
145         emit OrderPlaced(msg.sender,_tokenadd,_amount,_price);
146         if(openBookIndex[_tokenadd] == 0 ){    
147             openBookIndex[_tokenadd] = openBooks.length;
148             openBooks.push(_tokenadd);
149         }
150         userOrderIndex[order_nonce] = userOrders[msg.sender].length;
151         userOrders[msg.sender].push(order_nonce);
152         order_nonce += 1;
153     }
154 
155     /**
156     *@dev list allows DDA to list an order 
157     *@param _asset address 
158     *@param _amount of asset
159     *@param _price uint256 price per unit in wei
160     *@param _isLong true if it is long
161     */
162     //Then you would have a mapping from an asset to its price/ quantity when you list it.
163     function listDda(address _asset, uint256 _amount, uint256 _price, bool _isLong) public onlyOwner() {
164         require(blacklist[msg.sender] == false);
165         ListAsset storage listing = listOfAssets[_asset];
166         listing.price = _price;
167         listing.amount= _amount;
168         listing.isLong= _isLong;
169         openDdaListIndex[_asset] = openDdaListAssets.length;
170         openDdaListAssets.push(_asset);
171         
172     }
173 
174     /**
175     *@dev list allows a DDA to remove asset 
176     *@param _asset address 
177     */
178     function unlistDda(address _asset) public onlyOwner() {
179         require(blacklist[msg.sender] == false);
180         uint256 indexToDelete;
181         uint256 lastAcctIndex;
182         address lastAdd;
183         ListAsset storage listing = listOfAssets[_asset];
184         listing.price = 0;
185         listing.amount= 0;
186         listing.isLong= false;
187         indexToDelete = openDdaListIndex[_asset];
188         lastAcctIndex = openDdaListAssets.length.sub(1);
189         lastAdd = openDdaListAssets[lastAcctIndex];
190         openDdaListAssets[indexToDelete]=lastAdd;
191         openDdaListIndex[lastAdd]= indexToDelete;
192         openDdaListAssets.length--;
193         openDdaListIndex[_asset] = 0;
194     }
195 
196     /**
197     *@dev buy allows a party to partially fill an order
198     *@param _asset is the address of the assset listed
199     *@param _amount is the amount of tokens to buy
200     */
201     function buyPerUnit(address _asset, uint256 _amount) external payable {
202         require(blacklist[msg.sender] == false);
203         ListAsset storage listing = listOfAssets[_asset];
204         require(_amount <= listing.amount);
205         uint totalPrice = _amount.mul(listing.price);
206         require(msg.value == totalPrice);
207         ERC20_Interface token = ERC20_Interface(_asset);
208         if(token.allowance(owner,address(this)) >= _amount){
209             assert(token.transferFrom(owner,msg.sender, _amount));
210             owner.transfer(totalPrice);
211             listing.amount= listing.amount.sub(_amount);
212         }
213     }
214 
215     /**
216     *@dev unlist allows a party to remove their order from the orderbook
217     *@param _orderId is the uint256 ID of order
218     */
219     function unlist(uint256 _orderId) external{
220         require(forSaleIndex[_orderId] > 0);
221         Order memory _order = orders[_orderId];
222         require(msg.sender== _order.maker || msg.sender == owner);
223         unLister(_orderId,_order);
224         emit OrderRemoved(msg.sender,_order.asset,_order.amount,_order.price);
225     }
226 
227     /**
228     *@dev buy allows a party to fill an order
229     *@param _orderId is the uint256 ID of order
230     */
231     function buy(uint256 _orderId) external payable {
232         Order memory _order = orders[_orderId];
233         require(_order.price != 0 && _order.maker != address(0) && _order.asset != address(0) && _order.amount != 0);
234         require(msg.value == _order.price);
235         require(blacklist[msg.sender] == false);
236         address maker = _order.maker;
237         ERC20_Interface token = ERC20_Interface(_order.asset);
238         if(token.allowance(_order.maker,address(this)) >= _order.amount){
239             assert(token.transferFrom(_order.maker,msg.sender, _order.amount));
240             maker.transfer(_order.price);
241         }
242         unLister(_orderId,_order);
243         emit Sale(msg.sender,_order.asset,_order.amount,_order.price);
244     }
245 
246     /**
247     *@dev getOrder lists the price,amount, and maker of a specific token for a sale
248     *@param _orderId uint256 ID of order
249     *@return address of the party selling
250     *@return uint of the price of the sale (in wei)
251     *@return uint of the order amount of the sale
252     *@return address of the token
253     */
254     function getOrder(uint256 _orderId) external view returns(address,uint,uint,address){
255         Order storage _order = orders[_orderId];
256         return (_order.maker,_order.price,_order.amount,_order.asset);
257     }
258 
259     /**
260     *@dev allows the owner to change who the owner is
261     *@param _owner is the address of the new owner
262     */
263     function setOwner(address _owner) public onlyOwner() {
264         owner = _owner;
265     }
266 
267     /**
268     *@notice This allows the owner to stop a malicious party from spamming the orderbook
269     *@dev Allows the owner to blacklist addresses from using this exchange
270     *@param _address the address of the party to blacklist
271     *@param _motion true or false depending on if blacklisting or not
272     */
273     function blacklistParty(address _address, bool _motion) public onlyOwner() {
274         blacklist[_address] = _motion;
275     }
276 
277     /**
278     *@dev Allows parties to see if one is blacklisted
279     *@param _address the address of the party to blacklist
280     *@return bool true for is blacklisted
281     */
282     function isBlacklist(address _address) public view returns(bool) {
283         return blacklist[_address];
284     }
285 
286     /**
287     *@dev getOrderCount allows parties to query how many orders are on the book
288     *@param _token address used to count the number of orders
289     *@return _uint of the number of orders in the orderbook
290     */
291     function getOrderCount(address _token) public constant returns(uint) {
292         return forSale[_token].length;
293     }
294 
295     /**
296     *@dev Gets number of open orderbooks
297     *@return _uint of the number of tokens with open orders
298     */
299     function getBookCount() public constant returns(uint) {
300         return openBooks.length;
301     }
302 
303     /**
304     *@dev getOrders allows parties to get an array of all orderId's open for a given token
305     *@param _token address of the drct token
306     *@return _uint[] an array of the orders in the orderbook
307     */
308     function getOrders(address _token) public constant returns(uint[]) {
309         return forSale[_token];
310     }
311 
312     /**
313     *@dev getUserOrders allows parties to get an array of all orderId's open for a given user
314     *@param _user address 
315     *@return _uint[] an array of the orders in the orderbook for the user
316     */
317     function getUserOrders(address _user) public constant returns(uint[]) {
318         return userOrders[_user];
319     }
320 
321     /**
322     *@dev getter function to get all openDdaListAssets
323     */
324     function getopenDdaListAssets() view public returns (address[]){
325         return openDdaListAssets;
326     }
327     /**
328     *@dev Gets the DDA List Asset information for the specifed 
329     *asset address
330     *@param _assetAddress for DDA list
331     *@return price, amount and true if isLong
332     */
333     function getDdaListAssetInfo(address _assetAddress) public view returns(uint, uint, bool){
334         return(listOfAssets[_assetAddress].price,listOfAssets[_assetAddress].amount,listOfAssets[_assetAddress].isLong);
335     }
336     /**
337     *@dev An internal function to update mappings when an order is removed from the book
338     *@param _orderId is the uint256 ID of order
339     *@param _order is the struct containing the details of the order
340     */
341     function unLister(uint256 _orderId, Order _order) internal{
342             uint256 tokenIndex;
343             uint256 lastTokenIndex;
344             address lastAdd;
345             uint256  lastToken;
346         if(forSale[_order.asset].length == 2){
347             tokenIndex = openBookIndex[_order.asset];
348             lastTokenIndex = openBooks.length.sub(1);
349             lastAdd = openBooks[lastTokenIndex];
350             openBooks[tokenIndex] = lastAdd;
351             openBookIndex[lastAdd] = tokenIndex;
352             openBooks.length--;
353             openBookIndex[_order.asset] = 0;
354             forSale[_order.asset].length -= 2;
355         }
356         else{
357             tokenIndex = forSaleIndex[_orderId];
358             lastTokenIndex = forSale[_order.asset].length.sub(1);
359             lastToken = forSale[_order.asset][lastTokenIndex];
360             forSale[_order.asset][tokenIndex] = lastToken;
361             forSaleIndex[lastToken] = tokenIndex;
362             forSale[_order.asset].length--;
363         }
364         forSaleIndex[_orderId] = 0;
365         orders[_orderId] = Order({
366             maker: address(0),
367             price: 0,
368             amount:0,
369             asset: address(0)
370         });
371         if(userOrders[_order.maker].length > 1){
372             tokenIndex = userOrderIndex[_orderId];
373             lastTokenIndex = userOrders[_order.maker].length.sub(1);
374             lastToken = userOrders[_order.maker][lastTokenIndex];
375             userOrders[_order.maker][tokenIndex] = lastToken;
376             userOrderIndex[lastToken] = tokenIndex;
377         }
378         userOrders[_order.maker].length--;
379         userOrderIndex[_orderId] = 0;
380     }
381 }