1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  */
6 contract Ownable {
7   address public owner;
8 
9   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 }
37 
38 /**
39  * @title SafeMath Library
40  */
41 library SafeMath {
42   /**
43   * @dev Multiplies two numbers, throws on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     if (a == 0) {
47       return 0;
48     }
49     uint256 c = a * b;
50     assert(c / a == b);
51     return c;
52   }
53 
54   /**
55   * @dev Integer division of two numbers, truncating the quotient.
56   */
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   /**
65   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
66   */
67   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   /**
73   * @dev Adds two numbers, throws on overflow.
74   */
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 /**
83  * @title BlockMarketCore
84  */
85 contract BlockMarket is Ownable {
86   struct Stock {
87     string  name;
88     uint256 priceIncrease;
89     uint256 dividendAmount;
90     uint256 lastAction;
91     uint256 dividendsPaid;
92   }
93 
94   struct Share {
95     address holder;
96     uint256 purchasePrice;
97   }
98 
99   Stock[] public stocks;
100   Share[] public shares;
101   mapping (uint256 => uint256[]) public stockShares;
102 
103   event CompanyListed(string company, uint256 basePrice);
104   event DividendPaid(address shareholder, uint256 amount);
105   event ShareSold(
106     uint256 stockId,
107     uint256 shareId,
108     uint256 oldPrice,
109     uint256 newPrice,
110     address oldOwner,
111     address newOwner
112   );
113 
114   /**
115    * @dev A fallback function to catch, uh... let's call them gifts.
116    */
117   function () payable public { }
118 
119   /**
120    * @dev Adds a new stock to the game
121    * @param _name the name of the stock (e.g. "Kodak")
122    * @param _initialPrice the original cost of the stock's shares (in Wei)
123    * @param _priceIncrease the amount by which the shares should increase upon sale (i.e. 120 = 20% increase)
124    * @param _dividendAmount the amount of each purchase that should be split among dividend recipients
125    * @param _numShares the number of shares of this stock available for purchase
126    */
127   function addStock(
128     string  _name,
129     uint256 _initialPrice,
130     uint256 _priceIncrease,
131     uint256 _dividendAmount,
132     uint8   _numShares
133   ) public onlyOwner returns (uint256 stockId) {
134     stockId = stocks.length;
135 
136     stocks.push(
137       Stock(
138         _name,
139         _priceIncrease == 0 ? 130 : _priceIncrease, // 30% by default
140         _dividendAmount == 0 ? 110 : _dividendAmount, // 10% by default
141         block.timestamp,
142         0
143       )
144     );
145 
146     for(uint8 i = 0; i < _numShares; i++) {
147       stockShares[stockId].push(shares.length);
148       shares.push(Share(owner, _initialPrice));
149     }
150 
151     CompanyListed(_name, _initialPrice);
152   }
153 
154   /**
155    * @dev Purchase a share from its current owner
156    * @param _stockId the ID of the stock that owns the share
157    * @param _shareId the ID of the specific share to purchase
158    */
159   function purchase(uint256 _stockId, uint256 _shareId) public payable {
160     require(_stockId < stocks.length && _shareId < shares.length);
161 
162     // look up the assets
163     Stock storage stock = stocks[_stockId];
164     uint256[] storage sharesForStock = stockShares[_stockId];
165     Share storage share = shares[sharesForStock[_shareId]];
166 
167     // look up the share's current holder
168     address previousHolder = share.holder;
169 
170     // determine the current price for the share
171     uint256 currentPrice = getPurchasePrice(
172       share.purchasePrice,
173       stock.priceIncrease
174     );
175     require(msg.value >= currentPrice);
176 
177     // return any excess payment
178     if (msg.value > currentPrice) {
179       msg.sender.transfer(SafeMath.sub(msg.value, currentPrice));
180     }
181 
182     // calculate dividend holders' shares
183     uint256 dividendPerRecipient = getDividendPayout(
184       currentPrice,
185       stock.dividendAmount,
186       sharesForStock.length - 1
187     );
188 
189     // calculate the previous owner's share
190     uint256 previousHolderShare = SafeMath.sub(
191       currentPrice,
192       SafeMath.mul(dividendPerRecipient, sharesForStock.length - 1)
193     );
194 
195     // calculate the transaction fee - 1/40 = 2.5% fee
196     uint256 fee = SafeMath.div(previousHolderShare, 40);
197     owner.transfer(fee);
198 
199     // payout the previous shareholder
200     previousHolder.transfer(SafeMath.sub(previousHolderShare, fee));
201 
202     // payout the dividends
203     for(uint8 i = 0; i < sharesForStock.length; i++) {
204       if (i != _shareId) {
205         shares[sharesForStock[i]].holder.transfer(dividendPerRecipient);
206         stock.dividendsPaid = SafeMath.add(stock.dividendsPaid, dividendPerRecipient);
207         DividendPaid(
208           shares[sharesForStock[i]].holder,
209           dividendPerRecipient
210         );
211       }
212     }
213 
214     ShareSold(
215       _stockId,
216       _shareId,
217       share.purchasePrice,
218       currentPrice,
219       share.holder,
220       msg.sender
221     );
222 
223     // update share information
224     share.holder = msg.sender;
225     share.purchasePrice = currentPrice;
226     stock.lastAction = block.timestamp;
227   }
228 
229   /**
230    * @dev Calculates the current purchase price for the given stock share
231    * @param _stockId the ID of the stock that owns the share
232    * @param _shareId the ID of the specific share to purchase
233    */
234   function getCurrentPrice(
235     uint256 _stockId,
236     uint256 _shareId
237   ) public view returns (uint256 currentPrice) {
238     require(_stockId < stocks.length && _shareId < shares.length);
239     currentPrice = SafeMath.div(
240       SafeMath.mul(stocks[_stockId].priceIncrease, shares[_shareId].purchasePrice),
241       100
242     );
243   }
244 
245   /**
246    * @dev Calculates the current token owner's payout amount if the token sells
247    * @param _currentPrice the current total sale price of the asset
248    * @param _priceIncrease the percentage of price increase per sale
249    */
250   function getPurchasePrice(
251     uint256 _currentPrice,
252     uint256 _priceIncrease
253   ) internal pure returns (uint256 currentPrice) {
254     currentPrice = SafeMath.div(
255       SafeMath.mul(_currentPrice, _priceIncrease),
256       100
257     );
258   }
259 
260   /**
261    * @dev Calculates the payout of each dividend recipient in the event of a share sale.
262    * @param _purchasePrice the current total sale price of the asset
263    * @param _stockDividend the percentage of the sale allocated for dividends
264    * @param _numDividends the number of dividend holders to share the total dividend amount
265    */
266   function getDividendPayout(
267     uint256 _purchasePrice,
268     uint256 _stockDividend,
269     uint256 _numDividends
270   ) public pure returns (uint256 dividend) {
271     uint256 dividendPerRecipient = SafeMath.sub(
272       SafeMath.div(SafeMath.mul(_purchasePrice, _stockDividend), 100),
273       _purchasePrice
274     );
275     dividend = SafeMath.div(dividendPerRecipient, _numDividends);
276   }
277 
278   /**
279   * @dev Fetches the number of stocks available
280   */
281   function getStockCount() public view returns (uint256) {
282     return stocks.length;
283   }
284 
285   /**
286   * @dev Fetches the share IDs connected to the given stock
287   * @param _stockId the ID of the stock to count shares of
288   */
289   function getStockShares(uint256 _stockId) public view returns (uint256[]) {
290     return stockShares[_stockId];
291   }
292 
293   /**
294    * @dev Transfers a set amount of ETH from the contract to the specified address
295    * @notice Proceeds are paid out right away, but the contract might receive unexpected funds
296    */
297   function withdraw(uint256 _amount, address _destination) public onlyOwner {
298     require(_destination != address(0));
299     require(_amount <= this.balance);
300     _destination.transfer(_amount == 0 ? this.balance : _amount);
301   }
302 }