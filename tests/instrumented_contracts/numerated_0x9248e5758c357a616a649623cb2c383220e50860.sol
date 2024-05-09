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
157 /**
158     @title OwnersExchange
159     @dev Allow for trustless exchange of LP owners tokens
160  */
161 contract OwnersExchange is Ownable {
162 
163     using SafeMath for uint;
164     using itmap for itmap.itmap;
165 
166     enum ORDER_TYPE {
167         NULL, BUY, SELL
168     }
169     uint public orderCount;
170     uint public fee;
171     uint public lockedFees;
172     uint public totalFees;
173     mapping(uint => uint) public feeBalances;
174     address[] public addressRegistry; 
175     mapping(address => uint) public addressIndex;
176 
177     itmap.itmap orderBook;
178 
179     PoolOwnersInterface public poolOwners;
180     ERC20 public feeToken;
181 
182     event NewOrder(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
183     event OrderRemoved(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
184     event OrderFilled(ORDER_TYPE indexed orderType, address indexed sender, address receiver, uint price, uint amount);
185 
186     /**
187         @dev Initialise the contract
188         @param _poolOwners Set the address of the PoolOwners contract used in this DEX
189      */
190     constructor(address _poolOwners, address _feeToken) public {
191         require(_poolOwners != address(0), "_poolOwners needs to be set");
192         poolOwners = PoolOwnersInterface(_poolOwners);
193         feeToken = ERC20(_feeToken);
194         addressRegistry.push(address(0));
195         orderCount = 1;
196     }
197 
198     /**
199         @dev Register an address to a uint allowing packing in orders
200         @param _address The address to register
201      */
202     function addressRegister(address _address) private returns (uint) {
203         if (addressIndex[_address] != 0) {
204             return addressIndex[_address];
205         } else {
206             require(addressRegistry.length < 1 << 32, "Registered addresses hit maximum");
207             addressIndex[_address] = addressRegistry.length;
208             addressRegistry.push(_address);
209             return addressRegistry.length - 1;
210         }
211     }
212 
213     /**
214         @dev ERC677 Reciever for fee token transfer (Always expected to be LINK)
215         @param _sender The address of the sender of the token
216         @param _value The amount of token received
217         @param _data Extra data, not needed in this use-case
218      */
219     function onTokenTransfer(address _sender, uint256 _value, bytes _data) public {
220         require(msg.sender == address(feeToken), "Sender needs to be the fee token");
221         uint index = addressRegister(_sender);
222         feeBalances[index] = feeBalances[index].add(_value);
223         totalFees = totalFees.add(_value);
224     }
225 
226     /**
227         @dev Allow users to withdraw any tokens used for fees
228         @param _value The amount wanting to be withdrawn
229      */
230     function withdrawFeeToken(uint256 _value) public {
231         uint index = addressRegister(msg.sender);
232         require(feeBalances[index] >= _value, "You're withdrawing more than your balance");
233         feeBalances[index] = feeBalances[index].sub(_value);
234         totalFees = totalFees.sub(_value);
235         if (feeBalances[index] == 0) {
236             delete feeBalances[index];
237         }
238         feeToken.transfer(msg.sender, _value);
239     }
240 
241     /**
242         @dev Set the fee percentage
243         @param _fee The percentage of fees to be taken in LINK
244      */
245     function setFee(uint _fee) public onlyOwner {
246         require(_fee <= 500 finney, "Fees can't be more than 50%");
247         fee = _fee;
248     }
249 
250     /**
251         @dev Returns the fee cost based on a price & amount
252         @param _price The price of the order
253         @param _amount The amount requested
254      */
255     function feeForOrder(uint _price, uint _amount) public view returns (uint) {
256         return _price
257             .mul(_amount)
258             .div(1 ether)
259             .mul(fee)
260             .div(1 ether);
261     }
262 
263     /**
264         @dev Returns the ETH cost of an order
265         @param _price The price of the order
266         @param _amount The amount requested
267      */
268     function costOfOrder(uint _price, uint _amount) public pure returns (uint) {
269         return _price.mul(_amount).div(1 ether);
270     }
271 
272     /**
273         @dev Create a new sell order
274         @param _price The price of the order per 1 ether of token
275         @param _amount The amount of tokens being sent
276      */
277     function addSellOrder(uint _price, uint _amount) public {
278         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
279 
280         require(_price > 0, "Price needs to be greater than 0");
281         require(_amount > 0, "Amount needs to be greater than 0");
282 
283         uint orderFee = feeForOrder(_price, _amount);
284         uint index = addressRegister(msg.sender);
285         if (orderFee > 0) {
286             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
287             feeBalances[index] = feeBalances[index].sub(orderFee);
288             feeBalances[0] = feeBalances[0].add(orderFee);
289             lockedFees = lockedFees.add(orderFee);
290         }
291         poolOwners.sendOwnershipFrom(msg.sender, this, _amount);
292 
293         require(
294             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.SELL) << 32 | index) << 111 | _price) << 111) | _amount), 
295             "Map replacement detected"
296         );
297         orderCount += 1;
298     
299         emit NewOrder(ORDER_TYPE.SELL, msg.sender, _price, _amount);
300     }
301 
302     /**
303         @dev Add a new buy order, ETH sent needs to equal: (price * amount) / 18
304         @param _price The price of the buy order per 1 ether of LP token
305         @param _amount The amount of tokens wanting to be purchased
306      */
307     function addBuyOrder(uint _price, uint _amount) public payable {
308         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
309 
310         require(_price > 0, "Price needs to be greater than 0");
311         require(_amount > 0, "Amount needs to be greater than 0");
312 
313         uint orderFee = feeForOrder(_price, _amount);
314         uint index = addressRegister(msg.sender);
315         if (orderFee > 0) {
316             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
317             feeBalances[index] = feeBalances[index].sub(orderFee);
318             feeBalances[0] = feeBalances[0].add(orderFee);
319             lockedFees = lockedFees.add(orderFee);
320         }
321 
322         uint cost = _price.mul(_amount).div(1 ether);
323         require(_price.mul(_amount) == cost.mul(1 ether), "The price and amount of this order is too small");
324         require(msg.value == cost, "ETH sent needs to equal the cost");
325 
326         require(
327             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.BUY) << 32 | index) << 111 | _price) << 111) | _amount), 
328             "Map replacement detected"
329         );
330         orderCount += 1;
331     
332         emit NewOrder(ORDER_TYPE.BUY, msg.sender, _price, _amount);
333     }
334 
335     /**
336         @dev Remove a buy order and refund ETH back to the sender
337         @param _key The key of the order in the book
338      */
339     function removeBuyOrder(uint _key) public {
340         uint order = orderBook.get(_key);
341         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
342         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
343         uint index = addressIndex[msg.sender];
344         require(index == (order << 2) >> 224, "You are not the sender of this order");
345 
346         uint price = (order << 34) >> 145;
347         uint amount = (order << 145) >> 145;
348         require(orderBook.remove(_key), "Map remove failed");
349 
350         uint orderFee = feeForOrder(price, amount);
351         feeBalances[index] = feeBalances[index].add(orderFee);
352         feeBalances[0] = feeBalances[0].sub(orderFee);
353         lockedFees = lockedFees.sub(orderFee);
354 
355         uint cost = price.mul(amount).div(1 ether);
356         msg.sender.transfer(cost);
357 
358         emit OrderRemoved(orderType, msg.sender, price, amount);
359     }
360 
361     /**
362         @dev Remove a sell order and refund the LP tokens back to the sender
363         @param _key The key of the order in the book
364      */
365     function removeSellOrder(uint _key) public {
366         uint order = orderBook.get(_key);
367         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
368         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
369         uint index = addressIndex[msg.sender];
370         require(index == (order << 2) >> 224, "You are not the sender of this order");
371 
372         uint price = (order << 34) >> 145;
373         uint amount = (order << 145) >> 145;
374         require(orderBook.remove(_key), "Map remove failed");
375 
376         uint orderFee = feeForOrder(price, amount);
377         feeBalances[index] = feeBalances[index].add(orderFee);
378         feeBalances[0] = feeBalances[0].sub(orderFee);
379         lockedFees = lockedFees.sub(orderFee);
380 
381         poolOwners.sendOwnership(msg.sender, amount);
382 
383         emit OrderRemoved(orderType, msg.sender, price, amount);
384     }
385 
386     /**
387         @dev Fill a sell order in the order book
388         @dev Orders have to be filled in whole amounts
389         @param _key Key of the order as per orderbook
390      */
391     function fillSellOrder(uint _key) public payable {
392         uint order = orderBook.get(_key);
393         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
394         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
395         uint index = addressRegister(msg.sender);
396         require(index != (order << 2) >> 224, "You cannot fill your own order");
397 
398         uint price = (order << 34) >> 145;
399         uint amount = (order << 145) >> 145;
400 
401         uint orderFee = feeForOrder(price, amount);
402         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
403 
404         uint cost = price.mul(amount).div(1 ether);
405         require(msg.value == cost, "ETH sent needs to equal the cost");
406 
407         require(orderBook.remove(_key), "Map remove failed");
408 
409         addressRegistry[(order << 2) >> 224].transfer(msg.value);
410         poolOwners.sendOwnership(msg.sender, amount);
411 
412         if (orderFee > 0) {
413             feeBalances[index] = feeBalances[index].sub(orderFee);
414             feeBalances[0] = feeBalances[0].add(orderFee);
415             lockedFees = lockedFees.sub(orderFee);
416         }
417 
418         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
419     }
420 
421     /**
422         @dev Fill a buy order in the order book
423         @dev Orders have to be filled in whole amounts
424         @param _key Key of the order, which is the buyers address
425      */
426     function fillBuyOrder(uint _key) public {
427         uint order = orderBook.get(_key);
428         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
429         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
430         uint index = addressRegister(msg.sender);
431         require(index != (order << 2) >> 224, "You cannot fill your own order");
432 
433         uint price = (order << 34) >> 145;
434         uint amount = (order << 145) >> 145;
435 
436         uint orderFee = feeForOrder(price, amount);
437         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
438 
439         uint cost = price.mul(amount).div(1 ether);
440         
441         require(orderBook.remove(_key), "Map remove failed");
442 
443         msg.sender.transfer(cost);
444         poolOwners.sendOwnershipFrom(msg.sender, addressRegistry[(order << 2) >> 224], amount);
445 
446         if (orderFee > 0) {
447             feeBalances[index] = feeBalances[index].sub(orderFee);
448             feeBalances[0] = feeBalances[0].add(orderFee);
449             lockedFees = lockedFees.sub(orderFee);
450         }
451 
452         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
453     }
454 
455     /**
456         @dev Send tokens earned via fees back to PoolOwners to be re-distributed
457      */
458     function withdrawFeesToPoolOwners() public {
459         uint feeBalance = feeBalances[0];
460         require(feeBalance > lockedFees, "Contract doesn't have a withdrawable fee balance");
461         feeBalances[0] = lockedFees;
462         uint amount = feeBalance.sub(lockedFees);
463         totalFees = totalFees.sub(amount);
464         feeToken.transfer(poolOwners, amount);
465     }
466 
467     /**
468         @dev Send any fee token earned via PoolOwners distribution back to be re-distributed
469      */
470     function withdrawDistributedToPoolOwners() public {
471         uint balance = feeToken.balanceOf(this).sub(totalFees);
472         require(balance > 0, "There is no distributed fee token balance in the contract");
473         feeToken.transfer(poolOwners, balance);
474     }
475 
476     /**
477         @dev Get a single order by its key
478         @param _key The key of the order as per the book
479      */
480     function getOrder(uint _key) public view returns (ORDER_TYPE, address, uint, uint) {
481         uint order = orderBook.get(_key);
482         return (
483             ORDER_TYPE(order >> 254), 
484             addressRegistry[(order << 2) >> 224], 
485             (order << 34) >> 145, 
486             (order << 145) >> 145
487         );
488     }
489 
490     /**
491         @dev Get a batch of 10 orders by a given array of keys
492         @dev ID's has to be equal or less than 10 in length, or an empty response is given
493         @param _start The starting index in the order book to return from
494      */
495     function getOrders(uint _start) public view returns (
496         uint[10] keys,
497         address[10] addresses, 
498         ORDER_TYPE[10] orderTypes, 
499         uint[10] prices, 
500         uint[10] amounts
501     ) {
502         for (uint i = 0; i < 10; i++) {
503             if (orderBook.size() == _start + i) {
504                 break;
505             }
506             uint key = orderBook.getKey(_start + i);
507             keys[i] = key;
508             uint order = orderBook.get(key);
509             addresses[i] = addressRegistry[(order << 2) >> 224];
510             orderTypes[i] = ORDER_TYPE(order >> 254);
511             prices[i] = (order << 34) >> 145;
512             amounts[i] = (order << 145) >> 145;
513         }
514         return (keys, addresses, orderTypes, prices, amounts);
515     }
516 
517     /**
518         @dev Get an orderbook key from the orderbook index
519         @param _i The index to fetch the key for
520      */
521     function getOrderBookKey(uint _i) public view returns (uint key) {
522         if (_i < orderBook.size()) {
523             key = orderBook.getKey(_i);
524         } else {
525             key = 0;
526         }
527         return key;
528     }
529 
530     /**
531         @dev Get orderbook keys in batches of 10
532         @param _start The start of the index for the batch
533      */
534     function getOrderBookKeys(uint _start) public view returns (uint[10] keys) {
535         for (uint i = 0; i < 10; i++) {
536             if (i + _start < orderBook.size()) {
537                 keys[i] = orderBook.getKey(_start + i);
538             } else {
539                 keys[i] = 0;
540             }
541         }
542         return keys;
543     }
544 
545     /**
546         @dev Get the orderbook size to allow for batch fetching of keys
547      */
548     function getOrderBookSize() public view returns (uint) {
549         return orderBook.size();
550     }
551 
552     /**
553         @dev Verify that the number being passed fits into 111 bits for packing
554         @param _val The value to check
555      */
556     function is111bit(uint _val) private pure returns (bool) {
557         return (_val < 1 << 111);
558     }
559 
560 }