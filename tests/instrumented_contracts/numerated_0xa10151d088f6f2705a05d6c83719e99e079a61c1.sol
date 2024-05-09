1 pragma solidity ^0.4.22;
2 
3 // File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: node_modules/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: contracts/Marketplace.sol
121 
122 // Note about numbers:
123 //   All prices and exchange rates are in "decimal fixed-point", that is, scaled by 10^18, like ETH vs wei.
124 //   Seconds are integers as usual.
125 contract Marketplace is Ownable {
126     using SafeMath for uint256;
127 
128     // product events
129     event ProductCreated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
130     event ProductUpdated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
131     event ProductDeleted(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
132     event ProductRedeployed(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
133     event ProductOwnershipOffered(address indexed owner, bytes32 indexed id, address indexed to);
134     event ProductOwnershipChanged(address indexed newOwner, bytes32 indexed id, address indexed oldOwner);
135 
136     // subscription events
137     event Subscribed(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
138     event NewSubscription(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
139     event SubscriptionExtended(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
140     event SubscriptionTransferred(bytes32 indexed productId, address indexed from, address indexed to, uint secondsTransferred);
141 
142     // currency events
143     event ExchangeRatesUpdated(uint timestamp, uint dataInUsd);
144 
145     enum ProductState {
146         NotDeployed,                // non-existent or deleted
147         Deployed                    // created or redeployed
148     }
149 
150     enum Currency {
151         DATA,                       // "token wei" (10^-18 DATA)
152         USD                         // attodollars (10^-18 USD)
153     }
154 
155     struct Product {
156         bytes32 id;
157         string name;
158         address owner;
159         address beneficiary;        // account where revenue is directed to
160         uint pricePerSecond;
161         Currency priceCurrency;
162         uint minimumSubscriptionSeconds;
163         ProductState state;
164         mapping(address => TimeBasedSubscription) subscriptions;
165         address newOwnerCandidate;  // Two phase hand-over to minimize the chance that the product ownership is lost to a non-existent address.
166     }
167 
168     struct TimeBasedSubscription {        
169         uint endTimestamp;
170     }
171 
172     /////////////// Marketplace lifecycle /////////////////
173 
174     ERC20 public datacoin;
175 
176     address public currencyUpdateAgent;
177 
178     function Marketplace(address datacoinAddress, address currencyUpdateAgentAddress) Ownable() public {        
179         _initialize(datacoinAddress, currencyUpdateAgentAddress);
180     }
181 
182     function _initialize(address datacoinAddress, address currencyUpdateAgentAddress) internal {
183         currencyUpdateAgent = currencyUpdateAgentAddress;
184         datacoin = ERC20(datacoinAddress);
185     }
186 
187     ////////////////// Product management /////////////////
188 
189     mapping (bytes32 => Product) public products;
190     function getProduct(bytes32 id) public view returns (string name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state) {
191         return (
192             products[id].name,
193             products[id].owner,
194             products[id].beneficiary,
195             products[id].pricePerSecond,
196             products[id].priceCurrency,
197             products[id].minimumSubscriptionSeconds,
198             products[id].state
199         );
200     }
201 
202     // also checks that p exists: p.owner == 0 for non-existent products    
203     modifier onlyProductOwner(bytes32 productId) {
204         Product storage p = products[productId];
205         require(p.id != 0x0, "error_notFound");
206         require(p.owner == msg.sender || owner == msg.sender, "error_productOwnersOnly");
207         _;
208     }
209 
210     function createProduct(bytes32 id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
211         require(id != 0x0, "error_nullProductId");
212         require(pricePerSecond > 0, "error_freeProductsNotSupported");
213         Product storage p = products[id];
214         require(p.id == 0x0, "error_alreadyExists");
215         products[id] = Product(id, name, msg.sender, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, ProductState.Deployed, 0);
216         emit ProductCreated(msg.sender, id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
217     }
218 
219     /**
220     * Stop offering the product
221     */
222     function deleteProduct(bytes32 productId) public onlyProductOwner(productId) {        
223         Product storage p = products[productId];
224         require(p.state == ProductState.Deployed, "error_notDeployed");
225         p.state = ProductState.NotDeployed;
226         emit ProductDeleted(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
227     }
228 
229     /**
230     * Return product to market
231     */
232     function redeployProduct(bytes32 productId) public onlyProductOwner(productId) {        
233         Product storage p = products[productId];
234         require(p.state == ProductState.NotDeployed, "error_mustBeNotDeployed");
235         p.state = ProductState.Deployed;
236         emit ProductRedeployed(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
237     }
238 
239     function updateProduct(bytes32 productId, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public onlyProductOwner(productId) {
240         require(pricePerSecond > 0, "error_freeProductsNotSupported");
241         Product storage p = products[productId]; 
242         p.name = name;
243         p.beneficiary = beneficiary;
244         p.pricePerSecond = pricePerSecond;
245         p.priceCurrency = currency;
246         p.minimumSubscriptionSeconds = minimumSubscriptionSeconds;        
247         emit ProductUpdated(p.owner, p.id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
248     }
249 
250     /**
251     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
252     */
253     function offerProductOwnership(bytes32 productId, address newOwnerCandidate) public onlyProductOwner(productId) {
254         // that productId exists is already checked in onlyProductOwner
255         products[productId].newOwnerCandidate = newOwnerCandidate;
256         emit ProductOwnershipOffered(products[productId].owner, productId, newOwnerCandidate);
257     }
258 
259     /**
260     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
261     */
262     function claimProductOwnership(bytes32 productId) public whenNotHalted {
263         // also checks that productId exists (newOwnerCandidate is zero for non-existent)
264         Product storage p = products[productId]; 
265         require(msg.sender == p.newOwnerCandidate, "error_notPermitted");
266         emit ProductOwnershipChanged(msg.sender, productId, p.owner);
267         p.owner = msg.sender;
268         p.newOwnerCandidate = 0;
269     }
270 
271     /////////////// Subscription management ///////////////
272 
273     function getSubscription(bytes32 productId, address subscriber) public view returns (bool isValid, uint endTimestamp) {
274         TimeBasedSubscription storage sub;
275         (isValid, , sub) = _getSubscription(productId, subscriber);
276         endTimestamp = sub.endTimestamp;        
277     }
278 
279     function getSubscriptionTo(bytes32 productId) public view returns (bool isValid, uint endTimestamp) {
280         return getSubscription(productId, msg.sender);
281     }
282 
283     /**
284      * Purchases access to this stream for msg.sender.
285      * If the address already has a valid subscription, extends the subscription by the given period.
286      */
287     function buy(bytes32 productId, uint subscriptionSeconds) public whenNotHalted {
288         var (, product, sub) = _getSubscription(productId, msg.sender);
289         require(product.state == ProductState.Deployed, "error_notDeployed");
290         _addSubscription(product, msg.sender, subscriptionSeconds, sub);
291 
292         uint price = getPriceInData(subscriptionSeconds, product.pricePerSecond, product.priceCurrency);        
293         require(datacoin.transferFrom(msg.sender, product.beneficiary, price), "error_paymentFailed");
294     }
295 
296     /**
297     * Checks if the given address currently has a valid subscription
298     */
299     function hasValidSubscription(bytes32 productId, address subscriber) public constant returns (bool isValid) {
300         (isValid, ,) = _getSubscription(productId, subscriber);
301     }
302 
303     /**
304     * Transfer a valid subscription from msg.sender to a new address.
305     * If the address already has a valid subscription, extends the subscription by the msg.sender's remaining period.
306     */
307     function transferSubscription(bytes32 productId, address newSubscriber) public whenNotHalted {
308         var (isValid, product, sub) = _getSubscription(productId, msg.sender);
309         require(isValid, "error_subscriptionNotValid");
310         uint secondsLeft = sub.endTimestamp.sub(block.timestamp);        
311         TimeBasedSubscription storage newSub = product.subscriptions[newSubscriber];
312         _addSubscription(product, newSubscriber, secondsLeft, newSub);
313         delete product.subscriptions[msg.sender];
314         emit SubscriptionTransferred(productId, msg.sender, newSubscriber, secondsLeft);
315     }
316 
317     function _getSubscription(bytes32 productId, address subscriber) internal constant returns (bool subIsValid, Product storage, TimeBasedSubscription storage) {
318         Product storage p = products[productId];
319         require(p.id != 0x0, "error_notFound");
320         TimeBasedSubscription storage s = p.subscriptions[subscriber];
321         return (s.endTimestamp >= block.timestamp, p, s);
322     }
323     
324     function _addSubscription(Product storage p, address subscriber, uint addSeconds, TimeBasedSubscription storage oldSub) internal {
325         uint endTimestamp;
326         if (oldSub.endTimestamp > block.timestamp) {
327             require(addSeconds > 0, "error_topUpTooSmall");
328             endTimestamp = oldSub.endTimestamp.add(addSeconds);
329             oldSub.endTimestamp = endTimestamp;  
330             emit SubscriptionExtended(p.id, subscriber, endTimestamp);
331         } else {
332             require(addSeconds >= p.minimumSubscriptionSeconds, "error_newSubscriptionTooSmall");
333             endTimestamp = block.timestamp.add(addSeconds);
334             TimeBasedSubscription memory newSub = TimeBasedSubscription(endTimestamp);
335             p.subscriptions[subscriber] = newSub;
336             emit NewSubscription(p.id, subscriber, endTimestamp);
337         }
338         emit Subscribed(p.id, subscriber, endTimestamp);
339     }
340 
341     // TODO: transfer allowance to another Marketplace contract
342     // Mechanism basically is that this Marketplace draws from the allowance and credits
343     //   the account on another Marketplace; OR that there is a central credit pool (say, an ERC20 token)
344     // Creating another ERC20 token for this could be a simple fix: it would need the ability to transfer allowances
345 
346     /////////////// Currency management ///////////////    
347 
348     // Exchange rates are formatted as "decimal fixed-point", that is, scaled by 10^18, like ether.
349     //        Exponent: 10^18 15 12  9  6  3  0
350     //                      |  |  |  |  |  |  |
351     uint public dataPerUsd = 100000000000000000;   // ~= 0.1 DATA/USD
352 
353     /**
354     * Update currency exchange rates; all purchases are still billed in DATAcoin
355     * @param timestamp in seconds when the exchange rates were last updated
356     * @param dataUsd how many data atoms (10^-18 DATA) equal one USD dollar
357     */
358     function updateExchangeRates(uint timestamp, uint dataUsd) public {
359         require(msg.sender == currencyUpdateAgent, "error_notPermitted");
360         require(dataUsd > 0);
361         dataPerUsd = dataUsd;
362         emit ExchangeRatesUpdated(timestamp, dataUsd);
363     }
364 
365     /**
366     * Helper function to calculate (hypothetical) subscription cost for given seconds and price, using current exchange rates.
367     * @param subscriptionSeconds length of hypothetical subscription, as a non-scaled integer
368     * @param price nominal price scaled by 10^18 ("token wei" or "attodollars")
369     * @param unit unit of the number price
370     */    
371     function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) public view returns (uint datacoinAmount) {
372         if (unit == Currency.DATA) {
373             return price.mul(subscriptionSeconds);
374         }
375         return price.mul(dataPerUsd).div(10**18).mul(subscriptionSeconds);
376     }
377 
378     /////////////// Admin functionality ///////////////
379     
380     event Halted();
381     event Resumed();
382     bool public halted = false;
383 
384     modifier whenNotHalted() {
385         require(!halted || owner == msg.sender, "error_halted");
386         _;
387     }
388     function halt() public onlyOwner {
389         halted = true;
390         emit Halted();
391     }
392     function resume() public onlyOwner {
393         halted = false;
394         emit Resumed();
395     }
396 
397     function reInitialize(address datacoinAddress, address currencyUpdateAgentAddress) public onlyOwner {
398         _initialize(datacoinAddress, currencyUpdateAgentAddress);
399     }
400 }