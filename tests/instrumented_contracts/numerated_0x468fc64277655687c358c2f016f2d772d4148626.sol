1 contract PoolOwnersInterface {
2     bool public distributionActive;
3     function sendOwnership(address _receiver, uint256 _amount) public;
4     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public;
5     function getOwnerTokens(address _owner) public returns (uint);
6 }
7 
8 contract ERC20Basic {
9     uint256 public totalSupply;
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 contract ERC20 is ERC20Basic {
16     function allowance(address owner, address spender) public view returns (uint256);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner, "Sender not authorised.");
78     _;
79   }
80 
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner public {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95     @title ItMap, a solidity iterable map
96     @dev Credit to: https://gist.github.com/ethers/7e6d443818cbc9ad2c38efa7c0f363d1
97  */
98 library itmap {
99     struct entry {
100         // Equal to the index of the key of this item in keys, plus 1.
101         uint keyIndex;
102         uint value;
103     }
104 
105     struct itmap {
106         mapping(uint => entry) data;
107         uint[] keys;
108     }
109 
110     function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
111         entry storage e = self.data[key];
112         e.value = value;
113         if (e.keyIndex > 0) {
114             return true;
115         } else {
116             e.keyIndex = ++self.keys.length;
117             self.keys[e.keyIndex - 1] = key;
118             return false;
119         }
120     }
121 
122     function remove(itmap storage self, uint key) internal returns (bool success) {
123         entry storage e = self.data[key];
124 
125         if (e.keyIndex == 0) {
126             return false;
127         }
128 
129         if (e.keyIndex < self.keys.length) {
130             // Move an existing element into the vacated key slot.
131             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
132             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
133         }
134 
135         self.keys.length -= 1;
136         delete self.data[key];
137         return true;
138     }
139 
140     function contains(itmap storage self, uint key) internal view returns (bool exists) {
141         return self.data[key].keyIndex > 0;
142     }
143 
144     function size(itmap storage self) internal view returns (uint) {
145         return self.keys.length;
146     }
147 
148     function get(itmap storage self, uint key) internal view returns (uint) {
149         return self.data[key].value;
150     }
151 
152     function getKey(itmap storage self, uint idx) internal view returns (uint) {
153         return self.keys[idx];
154     }
155 }
156 
157 
158 /**
159     @title OwnersExchange
160     @dev Allow for trustless exchange of LP owners tokens
161  */
162 contract OwnersExchange is Ownable {
163 
164     using SafeMath for uint;
165     using itmap for itmap.itmap;
166 
167     enum ORDER_TYPE {
168         NULL, BUY, SELL
169     }
170     uint public orderCount;
171     uint public fee;
172     uint public lockedFees;
173     uint public totalFees;
174     mapping(uint => uint) public feeBalances;
175     address[] public addressRegistry; 
176     mapping(address => uint) public addressIndex;
177 
178     itmap.itmap orderBook;
179 
180     PoolOwnersInterface public poolOwners;
181     ERC20 public feeToken;
182 
183     event NewOrder(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
184     event OrderRemoved(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
185     event OrderFilled(ORDER_TYPE indexed orderType, address indexed sender, address receiver, uint price, uint amount);
186 
187     /**
188         @dev Initialise the contract
189         @param _poolOwners Set the address of the PoolOwners contract used in this DEX
190      */
191     constructor(address _poolOwners, address _feeToken) public {
192         require(_poolOwners != address(0), "_poolOwners needs to be set");
193         poolOwners = PoolOwnersInterface(_poolOwners);
194         feeToken = ERC20(_feeToken);
195         addressRegistry.push(address(0));
196         orderCount = 1;
197     }
198 
199     /**
200         @dev Register an address to a uint allowing packing in orders
201         @param _address The address to register
202      */
203     function addressRegister(address _address) private returns (uint) {
204         if (addressIndex[_address] != 0) {
205             return addressIndex[_address];
206         } else {
207             require(addressRegistry.length < 1 << 32, "Registered addresses hit maximum");
208             addressIndex[_address] = addressRegistry.length;
209             addressRegistry.push(_address);
210             return addressRegistry.length - 1;
211         }
212     }
213 
214     /**
215         @dev ERC677 Reciever for fee token transfer (Always expected to be LINK)
216         @param _sender The address of the sender of the token
217         @param _value The amount of token received
218         @param _data Extra data, not needed in this use-case
219      */
220     function onTokenTransfer(address _sender, uint256 _value, bytes _data) public {
221         require(msg.sender == address(feeToken), "Sender needs to be the fee token");
222         uint index = addressRegister(_sender);
223         feeBalances[index] = feeBalances[index].add(_value);
224         totalFees = totalFees.add(_value);
225     }
226 
227     /**
228         @dev Allow users to withdraw any tokens used for fees
229         @param _value The amount wanting to be withdrawn
230      */
231     function withdrawFeeToken(uint256 _value) public {
232         uint index = addressRegister(msg.sender);
233         require(feeBalances[index] >= _value, "You're withdrawing more than your balance");
234         feeBalances[index] = feeBalances[index].sub(_value);
235         totalFees = totalFees.sub(_value);
236         if (feeBalances[index] == 0) {
237             delete feeBalances[index];
238         }
239         feeToken.transfer(msg.sender, _value);
240     }
241 
242     /**
243         @dev Set the fee percentage
244         @param _fee The percentage of fees to be taken in LINK
245      */
246     function setFee(uint _fee) public onlyOwner {
247         require(_fee <= 500 finney, "Fees can't be more than 50%");
248         fee = _fee;
249     }
250 
251     /**
252         @dev Returns the fee cost based on a price & amount
253         @param _price The price of the order
254         @param _amount The amount requested
255      */
256     function feeForOrder(uint _price, uint _amount) public view returns (uint) {
257         return _price
258             .mul(_amount)
259             .div(1 ether)
260             .mul(fee)
261             .div(1 ether);
262     }
263 
264     /**
265         @dev Returns the ETH cost of an order
266         @param _price The price of the order
267         @param _amount The amount requested
268      */
269     function costOfOrder(uint _price, uint _amount) public pure returns (uint) {
270         return _price.mul(_amount).div(1 ether);
271     }
272 
273     /**
274         @dev Create a new sell order
275         @param _price The price of the order per 1 ether of token
276         @param _amount The amount of tokens being sent
277      */
278     function addSellOrder(uint _price, uint _amount) public {
279         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
280 
281         require(_price > 0, "Price needs to be greater than 0");
282         require(_amount > 0, "Amount needs to be greater than 0");
283 
284         uint orderFee = feeForOrder(_price, _amount);
285         uint index = addressRegister(msg.sender);
286         if (orderFee > 0) {
287             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
288             feeBalances[index] = feeBalances[index].sub(orderFee);
289         }
290         poolOwners.sendOwnershipFrom(msg.sender, this, _amount);
291 
292         require(
293             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.SELL) << 32 | index) << 111 | _price) << 111) | _amount), 
294             "Map replacement detected"
295         );
296         orderCount += 1;
297     
298         emit NewOrder(ORDER_TYPE.SELL, msg.sender, _price, _amount);
299     }
300 
301     /**
302         @dev Add a new buy order, ETH sent needs to equal: (price * amount) / 18
303         @param _price The price of the buy order per 1 ether of LP token
304         @param _amount The amount of tokens wanting to be purchased
305      */
306     function addBuyOrder(uint _price, uint _amount) public payable {
307         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
308 
309         require(_price > 0, "Price needs to be greater than 0");
310         require(_amount > 0, "Amount needs to be greater than 0");
311 
312         uint orderFee = feeForOrder(_price, _amount);
313         uint index = addressRegister(msg.sender);
314         if (orderFee > 0) {
315             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
316             feeBalances[index] = feeBalances[index].sub(orderFee);
317         }
318 
319         uint cost = _price.mul(_amount).div(1 ether);
320         require(_price.mul(_amount) == cost.mul(1 ether), "The price and amount of this order is too small");
321         require(msg.value == cost, "ETH sent needs to equal the cost");
322 
323         require(
324             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.BUY) << 32 | index) << 111 | _price) << 111) | _amount), 
325             "Map replacement detected"
326         );
327         orderCount += 1;
328     
329         emit NewOrder(ORDER_TYPE.BUY, msg.sender, _price, _amount);
330     }
331 
332     /**
333         @dev Remove a buy order and refund ETH back to the sender
334         @param _key The key of the order in the book
335      */
336     function removeBuyOrder(uint _key) public {
337         uint order = orderBook.get(_key);
338         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
339         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
340         uint index = addressIndex[msg.sender];
341         require(index == (order << 2) >> 224, "You are not the sender of this order");
342 
343         uint price = (order << 34) >> 145;
344         uint amount = (order << 145) >> 145;
345         require(orderBook.remove(_key), "Map remove failed");
346 
347         uint orderFee = feeForOrder(price, amount);
348         if (orderFee > 0) {
349             feeBalances[index] = feeBalances[index].add(orderFee);
350         }
351 
352         uint cost = price.mul(amount).div(1 ether);
353         msg.sender.transfer(cost);
354 
355         emit OrderRemoved(orderType, msg.sender, price, amount);
356     }
357 
358     /**
359         @dev Remove a sell order and refund the LP tokens back to the sender
360         @param _key The key of the order in the book
361      */
362     function removeSellOrder(uint _key) public {
363         uint order = orderBook.get(_key);
364         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
365         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
366         uint index = addressIndex[msg.sender];
367         require(index == (order << 2) >> 224, "You are not the sender of this order");
368 
369         uint price = (order << 34) >> 145;
370         uint amount = (order << 145) >> 145;
371         require(orderBook.remove(_key), "Map remove failed");
372 
373         uint orderFee = feeForOrder(price, amount);
374         if (orderFee > 0) {
375             feeBalances[index] = feeBalances[index].add(orderFee);
376         }
377 
378         poolOwners.sendOwnership(msg.sender, amount);
379 
380         emit OrderRemoved(orderType, msg.sender, price, amount);
381     }
382 
383     /**
384         @dev Fill a sell order in the order book
385         @dev Orders have to be filled in whole amounts
386         @param _key Key of the order as per orderbook
387      */
388     function fillSellOrder(uint _key) public payable {
389         uint order = orderBook.get(_key);
390         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
391         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
392         uint index = addressRegister(msg.sender);
393         require(index != (order << 2) >> 224, "You cannot fill your own order");
394 
395         uint price = (order << 34) >> 145;
396         uint amount = (order << 145) >> 145;
397 
398         uint orderFee = feeForOrder(price, amount);
399         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
400 
401         uint cost = price.mul(amount).div(1 ether);
402         require(msg.value == cost, "ETH sent needs to equal the cost");
403 
404         require(orderBook.remove(_key), "Map remove failed");
405 
406         addressRegistry[(order << 2) >> 224].transfer(msg.value);
407         poolOwners.sendOwnership(msg.sender, amount);
408 
409         if (orderFee > 0) {
410             feeBalances[index] = feeBalances[index].sub(orderFee);
411             uint totalFee = orderFee.mul(2);
412             totalFees = totalFees.sub(totalFee);
413             feeToken.transfer(poolOwners, totalFee);
414         }
415 
416         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
417     }
418 
419     /**
420         @dev Fill a buy order in the order book
421         @dev Orders have to be filled in whole amounts
422         @param _key Key of the order, which is the buyers address
423      */
424     function fillBuyOrder(uint _key) public {
425         uint order = orderBook.get(_key);
426         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
427         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
428         uint index = addressRegister(msg.sender);
429         require(index != (order << 2) >> 224, "You cannot fill your own order");
430 
431         uint price = (order << 34) >> 145;
432         uint amount = (order << 145) >> 145;
433 
434         uint orderFee = feeForOrder(price, amount);
435         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
436 
437         uint cost = price.mul(amount).div(1 ether);
438         
439         require(orderBook.remove(_key), "Map remove failed");
440 
441         msg.sender.transfer(cost);
442         poolOwners.sendOwnershipFrom(msg.sender, addressRegistry[(order << 2) >> 224], amount);
443 
444         if (orderFee > 0) {
445             feeBalances[index] = feeBalances[index].sub(orderFee);
446             uint totalFee = orderFee.mul(2);
447             totalFees = totalFees.sub(totalFee);
448             feeToken.transfer(poolOwners, totalFee);
449         }
450 
451         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
452     }
453 
454     /**
455         @dev Send any fee token earned via PoolOwners distribution back to be re-distributed
456      */
457     function withdrawDistributedToPoolOwners() public {
458         uint balance = feeToken.balanceOf(this).sub(totalFees);
459         require(balance > 0, "There is no distributed fee token balance in the contract");
460         feeToken.transfer(poolOwners, balance);
461     }
462 
463     /**
464         @dev Get a single order by its key
465         @param _key The key of the order as per the book
466      */
467     function getOrder(uint _key) public view returns (ORDER_TYPE, address, uint, uint) {
468         uint order = orderBook.get(_key);
469         return (
470             ORDER_TYPE(order >> 254), 
471             addressRegistry[(order << 2) >> 224], 
472             (order << 34) >> 145, 
473             (order << 145) >> 145
474         );
475     }
476 
477     /**
478         @dev Get a batch of 10 orders by a given array of keys
479         @dev ID's has to be equal or less than 10 in length, or an empty response is given
480         @param _start The starting index in the order book to return from
481      */
482     function getOrders(uint _start) public view returns (
483         uint[10] keys,
484         address[10] addresses, 
485         ORDER_TYPE[10] orderTypes, 
486         uint[10] prices, 
487         uint[10] amounts
488     ) {
489         for (uint i = 0; i < 10; i++) {
490             if (orderBook.size() == _start + i) {
491                 break;
492             }
493             uint key = orderBook.getKey(_start + i);
494             keys[i] = key;
495             uint order = orderBook.get(key);
496             addresses[i] = addressRegistry[(order << 2) >> 224];
497             orderTypes[i] = ORDER_TYPE(order >> 254);
498             prices[i] = (order << 34) >> 145;
499             amounts[i] = (order << 145) >> 145;
500         }
501         return (keys, addresses, orderTypes, prices, amounts);
502     }
503 
504     /**
505         @dev Get an orderbook key from the orderbook index
506         @param _i The index to fetch the key for
507      */
508     function getOrderBookKey(uint _i) public view returns (uint key) {
509         if (_i < orderBook.size()) {
510             key = orderBook.getKey(_i);
511         } else {
512             key = 0;
513         }
514         return key;
515     }
516 
517     /**
518         @dev Get orderbook keys in batches of 10
519         @param _start The start of the index for the batch
520      */
521     function getOrderBookKeys(uint _start) public view returns (uint[10] keys) {
522         for (uint i = 0; i < 10; i++) {
523             if (i + _start < orderBook.size()) {
524                 keys[i] = orderBook.getKey(_start + i);
525             } else {
526                 keys[i] = 0;
527             }
528         }
529         return keys;
530     }
531 
532     /**
533         @dev Get the orderbook size to allow for batch fetching of keys
534      */
535     function getOrderBookSize() public view returns (uint) {
536         return orderBook.size();
537     }
538 
539     /**
540         @dev Verify that the number being passed fits into 111 bits for packing
541         @param _val The value to check
542      */
543     function is111bit(uint _val) private pure returns (bool) {
544         return (_val < 1 << 111);
545     }
546 
547 }