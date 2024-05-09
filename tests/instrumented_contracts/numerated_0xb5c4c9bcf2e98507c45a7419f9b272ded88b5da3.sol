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
81     mapping(address => mapping (address => uint)) public totalListed;//user to tokenamounts
82     mapping(address => ListAsset) public listOfAssets;
83     //Maps an OrderID to the list of orders
84     mapping(uint256 => Order) public orders;
85     //An mapping of a token address to the orderID's
86     mapping(address =>  uint256[]) public forSale;
87     //Index telling where a specific tokenId is in the forSale array
88     mapping(uint256 => uint256) internal forSaleIndex;
89     
90     //mapping of address to position in openBooks
91     mapping (address => uint) internal openBookIndex;
92     //mapping of user to their orders
93     mapping(address => uint[]) public userOrders;
94     //mapping from orderId to userOrder position
95     mapping(uint => uint) internal userOrderIndex;
96     //A list of the blacklisted addresses
97     mapping(address => bool) internal blacklist;
98     
99 
100     /*Events*/
101     event ListDDA(address _token, uint256 _amount, uint256 _price,bool _isLong);
102     event BuyDDA(address _token,address _sender, uint256 _amount, uint256 _price);
103     event UnlistDDA(address _token);
104     event OrderPlaced(uint _orderID, address _sender,address _token, uint256 _amount, uint256 _price);
105     event Sale(uint _orderID,address _sender,address _token, uint256 _amount, uint256 _price);
106     event OrderRemoved(uint _orderID,address _sender,address _token, uint256 _amount, uint256 _price);
107 
108     /*Modifiers*/
109     /**
110     *@dev Access modifier for Owner functionality
111     */
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116 
117     /*Functions*/
118     /**
119     *@dev the constructor argument to set the owner and initialize the array.
120     */
121     constructor() public{
122         owner = msg.sender;
123         openBooks.push(address(0));
124         order_nonce = 1;
125     }
126 
127     /**
128     *@dev list allows a party to place an order on the orderbook
129     *@param _tokenadd address of the drct tokens
130     *@param _amount number of DRCT tokens
131     *@param _price uint256 price of all tokens in wei
132     */
133     function list(address _tokenadd, uint256 _amount, uint256 _price) external {
134         require(blacklist[msg.sender] == false);
135         require(_price > 0);
136         ERC20_Interface token = ERC20_Interface(_tokenadd);
137         require(totalListed[msg.sender][_tokenadd] + _amount <= token.allowance(msg.sender,address(this)));
138         if(forSale[_tokenadd].length == 0){
139             forSale[_tokenadd].push(0);
140             }
141         forSaleIndex[order_nonce] = forSale[_tokenadd].length;
142         forSale[_tokenadd].push(order_nonce);
143         orders[order_nonce] = Order({
144             maker: msg.sender,
145             asset: _tokenadd,
146             price: _price,
147             amount:_amount
148         });
149         emit OrderPlaced(order_nonce,msg.sender,_tokenadd,_amount,_price);
150         if(openBookIndex[_tokenadd] == 0 ){    
151             openBookIndex[_tokenadd] = openBooks.length;
152             openBooks.push(_tokenadd);
153         }
154         userOrderIndex[order_nonce] = userOrders[msg.sender].length;
155         userOrders[msg.sender].push(order_nonce);
156         totalListed[msg.sender][_tokenadd] += _amount;
157         order_nonce += 1;
158     }
159 
160     /**
161     *@dev list allows DDA to list an order 
162     *@param _asset address 
163     *@param _amount of asset
164     *@param _price uint256 price per unit in wei
165     *@param _isLong true if it is long
166     */
167     //Then you would have a mapping from an asset to its price/ quantity when you list it.
168     function listDda(address _asset, uint256 _amount, uint256 _price, bool _isLong) public onlyOwner() {
169         require(blacklist[msg.sender] == false);
170         ListAsset storage listing = listOfAssets[_asset];
171         listing.price = _price;
172         listing.amount= _amount;
173         listing.isLong= _isLong;
174         openDdaListIndex[_asset] = openDdaListAssets.length;
175         openDdaListAssets.push(_asset);
176         emit ListDDA(_asset,_amount,_price,_isLong);
177         
178     }
179 
180     /**
181     *@dev list allows a DDA to remove asset 
182     *@param _asset address 
183     */
184     function unlistDda(address _asset) public onlyOwner() {
185         require(blacklist[msg.sender] == false);
186         uint256 indexToDelete;
187         uint256 lastAcctIndex;
188         address lastAdd;
189         ListAsset storage listing = listOfAssets[_asset];
190         listing.price = 0;
191         listing.amount= 0;
192         listing.isLong= false;
193         indexToDelete = openDdaListIndex[_asset];
194         lastAcctIndex = openDdaListAssets.length.sub(1);
195         lastAdd = openDdaListAssets[lastAcctIndex];
196         openDdaListAssets[indexToDelete]=lastAdd;
197         openDdaListIndex[lastAdd]= indexToDelete;
198         openDdaListAssets.length--;
199         openDdaListIndex[_asset] = 0;
200         emit UnlistDDA(_asset);
201     }
202 
203     /**
204     *@dev buy allows a party to partially fill an order
205     *@param _asset is the address of the assset listed
206     *@param _amount is the amount of tokens to buy
207     */
208     function buyPerUnit(address _asset, uint256 _amount) external payable {
209         require(blacklist[msg.sender] == false);
210         ListAsset storage listing = listOfAssets[_asset];
211         require(_amount <= listing.amount);
212         uint totalPrice = _amount.mul(listing.price);
213         require(msg.value == totalPrice);
214         ERC20_Interface token = ERC20_Interface(_asset);
215         if(token.allowance(owner,address(this)) >= _amount){
216             assert(token.transferFrom(owner,msg.sender, _amount));
217             owner.transfer(totalPrice);
218             listing.amount= listing.amount.sub(_amount);
219         }
220         emit BuyDDA(_asset,msg.sender,_amount,totalPrice);
221     }
222 
223     /**
224     *@dev unlist allows a party to remove their order from the orderbook
225     *@param _orderId is the uint256 ID of order
226     */
227     function unlist(uint256 _orderId) external{
228         require(forSaleIndex[_orderId] > 0);
229         Order memory _order = orders[_orderId];
230         require(msg.sender== _order.maker || msg.sender == owner);
231         unLister(_orderId,_order);
232         emit OrderRemoved(_orderId,msg.sender,_order.asset,_order.amount,_order.price);
233     }
234 
235     /**
236     *@dev buy allows a party to fill an order
237     *@param _orderId is the uint256 ID of order
238     */
239     function buy(uint256 _orderId) external payable {
240         Order memory _order = orders[_orderId];
241         require(_order.price != 0 && _order.maker != address(0) && _order.asset != address(0) && _order.amount != 0);
242         require(msg.value == _order.price);
243         require(blacklist[msg.sender] == false);
244         address maker = _order.maker;
245         ERC20_Interface token = ERC20_Interface(_order.asset);
246         if(token.allowance(_order.maker,address(this)) >= _order.amount){
247             assert(token.transferFrom(_order.maker,msg.sender, _order.amount));
248             maker.transfer(_order.price);
249         }
250         unLister(_orderId,_order);
251         emit Sale(_orderId,msg.sender,_order.asset,_order.amount,_order.price);
252     }
253 
254     /**
255     *@dev getOrder lists the price,amount, and maker of a specific token for a sale
256     *@param _orderId uint256 ID of order
257     *@return address of the party selling
258     *@return uint of the price of the sale (in wei)
259     *@return uint of the order amount of the sale
260     *@return address of the token
261     */
262     function getOrder(uint256 _orderId) external view returns(address,uint,uint,address){
263         Order storage _order = orders[_orderId];
264         return (_order.maker,_order.price,_order.amount,_order.asset);
265     }
266 
267     /**
268     *@dev allows the owner to change who the owner is
269     *@param _owner is the address of the new owner
270     */
271     function setOwner(address _owner) public onlyOwner() {
272         owner = _owner;
273     }
274 
275     /**
276     *@notice This allows the owner to stop a malicious party from spamming the orderbook
277     *@dev Allows the owner to blacklist addresses from using this exchange
278     *@param _address the address of the party to blacklist
279     *@param _motion true or false depending on if blacklisting or not
280     */
281     function blacklistParty(address _address, bool _motion) public onlyOwner() {
282         blacklist[_address] = _motion;
283     }
284 
285     /**
286     *@dev Allows parties to see if one is blacklisted
287     *@param _address the address of the party to blacklist
288     *@return bool true for is blacklisted
289     */
290     function isBlacklist(address _address) public view returns(bool) {
291         return blacklist[_address];
292     }
293 
294     /**
295     *@dev getOrderCount allows parties to query how many orders are on the book
296     *@param _token address used to count the number of orders
297     *@return _uint of the number of orders in the orderbook
298     */
299     function getOrderCount(address _token) public constant returns(uint) {
300         return forSale[_token].length;
301     }
302 
303     /**
304     *@dev Gets number of open orderbooks
305     *@return _uint of the number of tokens with open orders
306     */
307     function getBookCount() public constant returns(uint) {
308         return openBooks.length;
309     }
310 
311     /**
312     *@dev getOrders allows parties to get an array of all orderId's open for a given token
313     *@param _token address of the drct token
314     *@return _uint[] an array of the orders in the orderbook
315     */
316     function getOrders(address _token) public constant returns(uint[]) {
317         return forSale[_token];
318     }
319 
320     /**
321     *@dev getUserOrders allows parties to get an array of all orderId's open for a given user
322     *@param _user address 
323     *@return _uint[] an array of the orders in the orderbook for the user
324     */
325     function getUserOrders(address _user) public constant returns(uint[]) {
326         return userOrders[_user];
327     }
328 
329     /**
330     *@dev getter function to get all openDdaListAssets
331     */
332     function getopenDdaListAssets() view public returns (address[]){
333         return openDdaListAssets;
334     }
335     /**
336     *@dev Gets the DDA List Asset information for the specifed 
337     *asset address
338     *@param _assetAddress for DDA list
339     *@return price, amount and true if isLong
340     */
341     function getDdaListAssetInfo(address _assetAddress) public view returns(uint, uint, bool){
342         return(listOfAssets[_assetAddress].price,listOfAssets[_assetAddress].amount,listOfAssets[_assetAddress].isLong);
343     }
344 
345     /**
346     *@param _owner address
347     *@param _asset address
348     *@return Returns the total listed the owner has listed for the specified asset
349     */
350     function getTotalListed(address _owner, address _asset) public view returns (uint) {
351        return totalListed[_owner][_asset]; 
352     }
353 
354     /**
355     *@dev An internal function to update mappings when an order is removed from the book
356     *@param _orderId is the uint256 ID of order
357     *@param _order is the struct containing the details of the order
358     */
359     function unLister(uint256 _orderId, Order _order) internal{
360             uint256 tokenIndex;
361             uint256 lastTokenIndex;
362             address lastAdd;
363             uint256  lastToken;
364         totalListed[_order.maker][_order.asset] -= _order.amount;
365         if(forSale[_order.asset].length == 2){
366             tokenIndex = openBookIndex[_order.asset];
367             lastTokenIndex = openBooks.length.sub(1);
368             lastAdd = openBooks[lastTokenIndex];
369             openBooks[tokenIndex] = lastAdd;
370             openBookIndex[lastAdd] = tokenIndex;
371             openBooks.length--;
372             openBookIndex[_order.asset] = 0;
373             forSale[_order.asset].length -= 2;
374         }
375         else{
376             tokenIndex = forSaleIndex[_orderId];
377             lastTokenIndex = forSale[_order.asset].length.sub(1);
378             lastToken = forSale[_order.asset][lastTokenIndex];
379             forSale[_order.asset][tokenIndex] = lastToken;
380             forSaleIndex[lastToken] = tokenIndex;
381             forSale[_order.asset].length--;
382         }
383         forSaleIndex[_orderId] = 0;
384         orders[_orderId] = Order({
385             maker: address(0),
386             price: 0,
387             amount:0,
388             asset: address(0)
389         });
390         if(userOrders[_order.maker].length > 1){
391             tokenIndex = userOrderIndex[_orderId];
392             lastTokenIndex = userOrders[_order.maker].length.sub(1);
393             lastToken = userOrders[_order.maker][lastTokenIndex];
394             userOrders[_order.maker][tokenIndex] = lastToken;
395             userOrderIndex[lastToken] = tokenIndex;
396         }
397         userOrders[_order.maker].length--;
398         userOrderIndex[_orderId] = 0;
399     }
400 }