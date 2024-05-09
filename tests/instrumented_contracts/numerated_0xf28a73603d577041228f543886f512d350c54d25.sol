1 pragma solidity ^0.4.18;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
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
87     OwnershipTransferred(owner, newOwner);
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
122 // TODO: Add require reasons as soon as Solidity 0.4.22 is out (now commented out)
123 //   follow progress at https://github.com/ethereum/solidity/projects/6
124 contract Marketplace is Ownable {
125     using SafeMath for uint256;
126 
127     // product events
128     event ProductCreated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
129     event ProductUpdated(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
130     event ProductDeleted(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
131     event ProductRedeployed(address indexed owner, bytes32 indexed id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds);
132     event ProductOwnershipOffered(address indexed owner, bytes32 indexed id, address indexed to);
133     event ProductOwnershipChanged(address indexed newOwner, bytes32 indexed id, address indexed oldOwner);
134 
135     // subscription events
136     event Subscribed(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
137     event NewSubscription(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
138     event SubscriptionExtended(bytes32 indexed productId, address indexed subscriber, uint endTimestamp);
139     event SubscriptionTransferred(bytes32 indexed productId, address indexed from, address indexed to, uint secondsTransferred, uint datacoinTransferred);    
140 
141     // currency events
142     event ExchangeRatesUpdated(uint timestamp, uint dataInUsd);
143 
144     enum ProductState {
145         NotDeployed,                // non-existent or deleted
146         Deployed                    // created or redeployed
147     }
148 
149     enum Currency {
150         DATA,                       // data atoms or "wei" (10^-18 DATA)
151         USD                         // nanodollars (10^-9 USD)
152     }
153 
154     struct Product {
155         bytes32 id;
156         string name;
157         address owner;
158         address beneficiary;        // account where revenue is directed to
159         uint pricePerSecond;
160         Currency priceCurrency;
161         uint minimumSubscriptionSeconds;
162         ProductState state;
163         mapping(address => TimeBasedSubscription) subscriptions;
164         address newOwnerCandidate;  // Two phase hand-over to minimize the chance that the product ownership is lost to a non-existent address.
165     }
166 
167     struct TimeBasedSubscription {        
168         uint endTimestamp;
169     }
170 
171     mapping (bytes32 => Product) products;
172     function getProduct(bytes32 id) public view returns (string name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state) {
173         return (
174             products[id].name,
175             products[id].owner,
176             products[id].beneficiary,
177             products[id].pricePerSecond,
178             products[id].priceCurrency,
179             products[id].minimumSubscriptionSeconds,
180             products[id].state
181         );
182     }
183 
184     function getSubscription(bytes32 productId, address subscriber) public view returns (bool isValid, uint endTimestamp) {
185         TimeBasedSubscription storage sub;
186         (isValid, , sub) = _getSubscription(productId, subscriber);
187         endTimestamp = sub.endTimestamp;        
188     }
189 
190     function getSubscriptionTo(bytes32 productId) public view returns (bool isValid, uint endTimestamp) {
191         return getSubscription(productId, msg.sender);
192     }
193 
194     ERC20 datacoin;
195 
196     address public currencyUpdateAgent;
197 
198     function Marketplace(address datacoinAddress, address currencyUpdateAgentAddress) Ownable() public {        
199         _initialize(datacoinAddress, currencyUpdateAgentAddress);
200     }
201 
202     function _initialize(address datacoinAddress, address currencyUpdateAgentAddress) internal {
203         currencyUpdateAgent = currencyUpdateAgentAddress;
204         datacoin = ERC20(datacoinAddress);
205     }
206 
207     ////////////////// Product management /////////////////
208 
209     // also checks that p exists: p.owner == 0 for non-existent products    
210     modifier onlyProductOwner(bytes32 productId) {
211         Product storage p = products[productId];
212         require(p.owner == msg.sender || owner == msg.sender); //, "Only product owner may call this function");
213         _;
214     }
215 
216     function createProduct(bytes32 id, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public whenNotHalted {
217         require(id != 0); //, "Product ID can't be empty/null");
218         require(pricePerSecond > 0); //, "Free streams go through different channel");
219         Product storage p = products[id];
220         require(p.id == 0); //, "Product with this ID already exists");        
221         products[id] = Product(id, name, msg.sender, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds, ProductState.Deployed, 0);
222         emit ProductCreated(msg.sender, id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
223     }
224 
225     /**
226     * Stop offering the product
227     */
228     function deleteProduct(bytes32 productId) public onlyProductOwner(productId) {        
229         Product storage p = products[productId];
230         require(p.state == ProductState.Deployed);
231         p.state = ProductState.NotDeployed;
232         emit ProductDeleted(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
233     }
234 
235     /**
236     * Return product to market
237     */
238     function redeployProduct(bytes32 productId) public onlyProductOwner(productId) {        
239         Product storage p = products[productId];
240         require(p.state == ProductState.NotDeployed);
241         p.state = ProductState.Deployed;
242         emit ProductRedeployed(p.owner, productId, p.name, p.beneficiary, p.pricePerSecond, p.priceCurrency, p.minimumSubscriptionSeconds);
243     }
244 
245     function updateProduct(bytes32 productId, string name, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds) public onlyProductOwner(productId) {
246         require(pricePerSecond > 0); //, "Free streams go through different channel");
247         Product storage p = products[productId]; 
248         p.name = name;
249         p.beneficiary = beneficiary;
250         p.pricePerSecond = pricePerSecond;
251         p.priceCurrency = currency;
252         p.minimumSubscriptionSeconds = minimumSubscriptionSeconds;        
253         emit ProductUpdated(p.owner, p.id, name, beneficiary, pricePerSecond, currency, minimumSubscriptionSeconds);
254     }
255 
256     /**
257     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
258     */
259     function offerProductOwnership(bytes32 productId, address newOwnerCandidate) public onlyProductOwner(productId) {
260         // that productId exists is already checked in onlyProductOwner
261         products[productId].newOwnerCandidate = newOwnerCandidate;
262         emit ProductOwnershipOffered(products[productId].owner, productId, newOwnerCandidate);
263     }
264 
265     /**
266     * Changes ownership of the product. Two phase hand-over minimizes the chance that the product ownership is lost to a non-existent address.
267     */
268     function claimProductOwnership(bytes32 productId) public whenNotHalted {
269         // also checks that productId exists (newOwnerCandidate is zero for non-existent)
270         Product storage p = products[productId]; 
271         require(msg.sender == p.newOwnerCandidate);
272         emit ProductOwnershipChanged(msg.sender, productId, p.owner);
273         p.owner = msg.sender;
274         p.newOwnerCandidate = 0;
275     }
276 
277     /////////////// Subscription management ///////////////
278 
279     /**
280      * Purchases access to this stream for msg.sender.
281      * If the address already has a valid subscription, extends the subscription by the given period.
282      */
283     function buy(bytes32 productId, uint subscriptionSeconds) public whenNotHalted {
284         Product storage product;
285         TimeBasedSubscription storage sub;
286         (, product, sub) = _getSubscription(productId, msg.sender);
287         require(product.state == ProductState.Deployed); //, "Product has been deleted");        
288         _addSubscription(product, msg.sender, subscriptionSeconds, sub);
289 
290         uint price = _toDatacoin(product.pricePerSecond.mul(subscriptionSeconds), product.priceCurrency);
291         require(datacoin.transferFrom(msg.sender, product.beneficiary, price));  //, "Not enough DATAcoin allowance");
292     }
293 
294     /**
295     * Checks if the given address currently has a valid subscription
296     */
297     function hasValidSubscription(bytes32 productId, address subscriber) public constant returns (bool isValid) {
298         (isValid, ,) = _getSubscription(productId, subscriber);
299     }
300 
301     /**
302     * Transfer a valid subscription from msg.sender to a new address.
303     * If the address already has a valid subscription, extends the subscription by the msg.sender's remaining period.
304     */
305     function transferSubscription(bytes32 productId, address newSubscriber) public whenNotHalted {
306         bool isValid = false;
307         Product storage product;
308         TimeBasedSubscription storage sub;
309         (isValid, product, sub) = _getSubscription(productId, msg.sender);
310         require(isValid);   //, "Only valid subscriptions can be transferred");
311         uint secondsLeft = sub.endTimestamp.sub(block.timestamp);
312         uint datacoinLeft = secondsLeft.mul(product.pricePerSecond);
313         TimeBasedSubscription storage newSub = product.subscriptions[newSubscriber];
314         _addSubscription(product, newSubscriber, secondsLeft, newSub);
315         delete product.subscriptions[msg.sender];
316         emit SubscriptionTransferred(productId, msg.sender, newSubscriber, secondsLeft, datacoinLeft);
317     }
318 
319     function _getSubscription(bytes32 productId, address subscriber) internal constant returns (bool subIsValid, Product storage, TimeBasedSubscription storage) {
320         Product storage p = products[productId];
321         require(p.id != 0); //, "Product doesn't exist");
322         TimeBasedSubscription storage s = p.subscriptions[subscriber];
323         return (s.endTimestamp >= block.timestamp, p, s);
324     }
325     
326     function _addSubscription(Product storage p, address subscriber, uint addSeconds, TimeBasedSubscription storage oldSub) internal {
327         uint endTimestamp;
328         if (oldSub.endTimestamp > block.timestamp) {
329             require(addSeconds > 0); //, "Must top up worth at least one second");
330             endTimestamp = oldSub.endTimestamp.add(addSeconds);
331             oldSub.endTimestamp = endTimestamp;  
332             emit SubscriptionExtended(p.id, subscriber, endTimestamp);
333         } else {
334             require(addSeconds >= p.minimumSubscriptionSeconds); //, "More ether required to meet the minimum subscription period");
335             endTimestamp = block.timestamp.add(addSeconds);
336             TimeBasedSubscription memory newSub = TimeBasedSubscription(endTimestamp);
337             p.subscriptions[subscriber] = newSub;
338             emit NewSubscription(p.id, subscriber, endTimestamp);
339         }
340         emit Subscribed(p.id, subscriber, endTimestamp);
341     }
342 
343     // TODO: transfer allowance to another Marketplace contract
344     // Mechanism basically is that this Marketplace draws from the allowance and credits
345     //   the account on another Marketplace; OR that there is a central credit pool (say, an ERC20 token)
346     // Creating another ERC20 token for this could be a simple fix: it would need the ability to transfer allowances
347 
348     /////////////// Currency management ///////////////
349 
350     uint public dataPerUsd = 1;
351 
352     /**
353     * Update currency exchange rates; all purchases are still billed in DATAcoin
354     * @param timestamp in seconds when the exchange rates were last updated
355     * @param dataUsd how many data atoms (10^-18 DATA) equal one nanodollar (10^-9 USD)
356     */
357     function updateExchangeRates(uint timestamp, uint dataUsd) public {
358         require(msg.sender == currencyUpdateAgent);
359         require(dataUsd > 0);
360         dataPerUsd = dataUsd;
361         emit ExchangeRatesUpdated(timestamp, dataUsd);
362     }
363 
364     /**
365     * Allow updating currency exchange rates even if time of exchange rate isn't known
366     */
367     function updateExchangeRates(uint dataUsd) public {
368         require(msg.sender == currencyUpdateAgent);
369         dataPerUsd = dataUsd;
370         emit ExchangeRatesUpdated(block.timestamp, dataUsd);
371     }    
372 
373     function _toDatacoin(uint number, Currency unit) view internal returns (uint datacoinAmount) {
374         if (unit == Currency.DATA) {
375             return number;
376         }
377         return number.mul(dataPerUsd);
378     }
379 
380     /////////////// Admin functionality ///////////////
381     
382     event Halted();
383     event Resumed();
384     bool public halted = false;
385 
386     modifier whenNotHalted() {
387         require(!halted || owner == msg.sender);
388         _;
389     }
390     function halt() public onlyOwner {
391         halted = true;
392         emit Halted();
393     }
394     function resume() public onlyOwner {
395         halted = false;
396         emit Resumed();
397     }
398 
399     function reInitialize(address datacoinAddress, address currencyUpdateAgentAddress) public onlyOwner {
400         _initialize(datacoinAddress, currencyUpdateAgentAddress);
401     }
402 }