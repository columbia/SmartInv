1 // File: contracts/interface/PoolOwnersInterface.sol
2 
3 pragma solidity ^0.4.23;
4 
5 contract PoolOwnersInterface {
6 
7     bool public distributionActive;
8 
9     function sendOwnership(address _receiver, uint256 _amount) public;
10     function sendOwnershipFrom(address _owner, address _receiver, uint256 _amount) public;
11     function getOwnerTokens(address _owner) public view returns (uint);
12     function getOwnerPercentage(address _owner) public view returns (uint);
13 
14 }
15 
16 // File: contracts/std/ERC20Basic.sol
17 
18 pragma solidity ^0.4.2;
19 
20 /**
21  * @title ERC20Basic
22  * @dev Simpler version of ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/179
24  */
25 contract ERC20Basic {
26     uint256 public totalSupply;
27     function balanceOf(address who) public view returns (uint256);
28     function transfer(address to, uint256 value) public returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 }
31 
32 // File: contracts/std/ERC20.sol
33 
34 pragma solidity ^0.4.2;
35 
36 
37 /**
38  * @title ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/20
40  */
41 contract ERC20 is ERC20Basic {
42     function allowance(address owner, address spender) public view returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 // File: contracts/std/SafeMath.sol
49 
50 pragma solidity ^0.4.2;
51 
52 
53 /**
54  * @title SafeMath
55  * @dev Math operations with safety checks that throw on error
56  */
57 library SafeMath {
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a * b;
60     assert(a == 0 || c / a == b);
61     return c;
62   }
63 
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     assert(b <= a);
73     return a - b;
74   }
75 
76   function add(uint256 a, uint256 b) internal pure returns (uint256) {
77     uint256 c = a + b;
78     assert(c >= a);
79     return c;
80   }
81 }
82 
83 // File: contracts/std/Ownable.sol
84 
85 pragma solidity ^0.4.2;
86 
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108 
109   /**
110    * @dev Throws if called by any account other than the owner.
111    */
112   modifier onlyOwner() {
113     require(msg.sender == owner, "Sender not authorised");
114     _;
115   }
116 
117 
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address newOwner) onlyOwner public {
123     require(newOwner != address(0));
124     emit OwnershipTransferred(owner, newOwner);
125     owner = newOwner;
126   }
127 
128 }
129 
130 // File: contracts/lib/ItMap.sol
131 
132 pragma solidity ^0.4.3;
133 
134 /**
135     @title ItMap, a solidity iterable map
136     @dev Credit to: https://gist.github.com/ethers/7e6d443818cbc9ad2c38efa7c0f363d1
137  */
138 library itmap {
139     struct entry {
140         // Equal to the index of the key of this item in keys, plus 1.
141         uint keyIndex;
142         uint value;
143     }
144 
145     struct itmap {
146         mapping(uint => entry) data;
147         uint[] keys;
148     }
149 
150     function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
151         entry storage e = self.data[key];
152         e.value = value;
153         if (e.keyIndex > 0) {
154             return true;
155         } else {
156             e.keyIndex = ++self.keys.length;
157             self.keys[e.keyIndex - 1] = key;
158             return false;
159         }
160     }
161 
162     function remove(itmap storage self, uint key) internal returns (bool success) {
163         entry storage e = self.data[key];
164 
165         if (e.keyIndex == 0) {
166             return false;
167         }
168 
169         if (e.keyIndex < self.keys.length) {
170             // Move an existing element into the vacated key slot.
171             self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;
172             self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];
173         }
174 
175         self.keys.length -= 1;
176         delete self.data[key];
177         return true;
178     }
179 
180     function contains(itmap storage self, uint key) internal view returns (bool exists) {
181         return self.data[key].keyIndex > 0;
182     }
183 
184     function size(itmap storage self) internal view returns (uint) {
185         return self.keys.length;
186     }
187 
188     function get(itmap storage self, uint key) internal view returns (uint) {
189         return self.data[key].value;
190     }
191 
192     function getKey(itmap storage self, uint idx) internal view returns (uint) {
193         return self.keys[idx];
194     }
195 }
196 
197 // File: contracts/OwnersExchange.sol
198 
199 pragma solidity ^0.4.23;
200 
201 
202 
203 
204 
205 
206 /**
207     @title OwnersExchange
208     @dev Allow for trustless exchange of LP owners tokens
209  */
210 contract OwnersExchange is Ownable {
211 
212     using SafeMath for uint;
213     using itmap for itmap.itmap;
214 
215     enum ORDER_TYPE {
216         NULL, BUY, SELL
217     }
218     uint public orderCount;
219     uint public fee;
220     uint public lockedFees;
221     uint public totalFees;
222     mapping(uint => uint) public feeBalances;
223     address[] public addressRegistry; 
224     mapping(address => uint) public addressIndex;
225 
226     itmap.itmap orderBook;
227 
228     PoolOwnersInterface public poolOwners;
229     ERC20 public feeToken;
230 
231     event NewOrder(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
232     event OrderRemoved(ORDER_TYPE indexed orderType, address indexed sender, uint price, uint amount);
233     event OrderFilled(ORDER_TYPE indexed orderType, address indexed sender, address receiver, uint price, uint amount);
234 
235     /**
236         @dev Initialise the contract
237         @param _poolOwners Set the address of the PoolOwners contract used in this DEX
238      */
239     constructor(address _poolOwners, address _feeToken) public {
240         require(_poolOwners != address(0), "_poolOwners needs to be set");
241         poolOwners = PoolOwnersInterface(_poolOwners);
242         feeToken = ERC20(_feeToken);
243         addressRegistry.push(address(0));
244         orderCount = 1;
245     }
246 
247     /**
248         @dev Register an address to a uint allowing packing in orders
249         @param _address The address to register
250      */
251     function addressRegister(address _address) private returns (uint) {
252         if (addressIndex[_address] != 0) {
253             return addressIndex[_address];
254         } else {
255             require(addressRegistry.length < 1 << 32, "Registered addresses hit maximum");
256             addressIndex[_address] = addressRegistry.length;
257             addressRegistry.push(_address);
258             return addressRegistry.length - 1;
259         }
260     }
261 
262     /**
263         @dev ERC677 Reciever for fee token transfer (Always expected to be LINK)
264         @param _sender The address of the sender of the token
265         @param _value The amount of token received
266         @param _data Extra data, not needed in this use-case
267      */
268     function onTokenTransfer(address _sender, uint256 _value, bytes _data) public {
269         require(msg.sender == address(feeToken), "Sender needs to be the fee token");
270         uint index = addressRegister(_sender);
271         feeBalances[index] = feeBalances[index].add(_value);
272         totalFees = totalFees.add(_value);
273     }
274 
275     /**
276         @dev Allow users to withdraw any tokens used for fees
277         @param _value The amount wanting to be withdrawn
278      */
279     function withdrawFeeToken(uint256 _value) public {
280         uint index = addressRegister(msg.sender);
281         require(feeBalances[index] >= _value, "You're withdrawing more than your balance");
282         feeBalances[index] = feeBalances[index].sub(_value);
283         totalFees = totalFees.sub(_value);
284         if (feeBalances[index] == 0) {
285             delete feeBalances[index];
286         }
287         feeToken.transfer(msg.sender, _value);
288     }
289 
290     /**
291         @dev Set the fee percentage
292         @param _fee The percentage of fees to be taken in LINK
293      */
294     function setFee(uint _fee) public onlyOwner {
295         require(_fee <= 500 finney, "Fees can't be more than 50%");
296         fee = _fee;
297     }
298 
299     /**
300         @dev Returns the fee cost based on a price & amount
301         @param _price The price of the order
302         @param _amount The amount requested
303      */
304     function feeForOrder(uint _price, uint _amount) public view returns (uint) {
305         return _price
306             .mul(_amount)
307             .div(1 ether)
308             .mul(fee)
309             .div(1 ether);
310     }
311 
312     /**
313         @dev Returns the ETH cost of an order
314         @param _price The price of the order
315         @param _amount The amount requested
316      */
317     function costOfOrder(uint _price, uint _amount) public pure returns (uint) {
318         return _price.mul(_amount).div(1 ether);
319     }
320 
321     /**
322         @dev Create a new sell order
323         @param _price The price of the order per 1 ether of token
324         @param _amount The amount of tokens being sent
325      */
326     function addSellOrder(uint _price, uint _amount) public {
327         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
328 
329         require(_price > 0, "Price needs to be greater than 0");
330         require(_amount > 0, "Amount needs to be greater than 0");
331 
332         uint orderFee = feeForOrder(_price, _amount);
333         uint index = addressRegister(msg.sender);
334         if (orderFee > 0) {
335             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
336             feeBalances[index] = feeBalances[index].sub(orderFee);
337         }
338         poolOwners.sendOwnershipFrom(msg.sender, this, _amount);
339 
340         require(
341             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.SELL) << 32 | index) << 111 | _price) << 111) | _amount), 
342             "Map replacement detected"
343         );
344         orderCount += 1;
345     
346         emit NewOrder(ORDER_TYPE.SELL, msg.sender, _price, _amount);
347     }
348 
349     /**
350         @dev Add a new buy order, ETH sent needs to equal: (price * amount) / 18
351         @param _price The price of the buy order per 1 ether of LP token
352         @param _amount The amount of tokens wanting to be purchased
353      */
354     function addBuyOrder(uint _price, uint _amount) public payable {
355         require(is111bit(_price) && is111bit(_amount), "Price or amount exceeds 111 bits");
356 
357         require(_price > 0, "Price needs to be greater than 0");
358         require(_amount > 0, "Amount needs to be greater than 0");
359 
360         uint orderFee = feeForOrder(_price, _amount);
361         uint index = addressRegister(msg.sender);
362         if (orderFee > 0) {
363             require(feeBalances[index] >= orderFee, "You do not have enough deposited for fees");
364             feeBalances[index] = feeBalances[index].sub(orderFee);
365         }
366 
367         uint cost = _price.mul(_amount).div(1 ether);
368         require(_price.mul(_amount) == cost.mul(1 ether), "The price and amount of this order is too small");
369         require(msg.value == cost, "ETH sent needs to equal the cost");
370 
371         require(
372             !orderBook.insert(orderCount, (((uint(ORDER_TYPE.BUY) << 32 | index) << 111 | _price) << 111) | _amount), 
373             "Map replacement detected"
374         );
375         orderCount += 1;
376     
377         emit NewOrder(ORDER_TYPE.BUY, msg.sender, _price, _amount);
378     }
379 
380     /**
381         @dev Remove a buy order and refund ETH back to the sender
382         @param _key The key of the order in the book
383      */
384     function removeBuyOrder(uint _key) public {
385         uint order = orderBook.get(_key);
386         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
387         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
388         uint index = addressIndex[msg.sender];
389         require(index == (order << 2) >> 224, "You are not the sender of this order");
390 
391         uint price = (order << 34) >> 145;
392         uint amount = (order << 145) >> 145;
393         require(orderBook.remove(_key), "Map remove failed");
394 
395         uint orderFee = feeForOrder(price, amount);
396         if (orderFee > 0) {
397             feeBalances[index] = feeBalances[index].add(orderFee);
398         }
399 
400         uint cost = price.mul(amount).div(1 ether);
401         msg.sender.transfer(cost);
402 
403         emit OrderRemoved(orderType, msg.sender, price, amount);
404     }
405 
406     /**
407         @dev Remove a sell order and refund the LP tokens back to the sender
408         @param _key The key of the order in the book
409      */
410     function removeSellOrder(uint _key) public {
411         uint order = orderBook.get(_key);
412         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
413         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
414         uint index = addressIndex[msg.sender];
415         require(index == (order << 2) >> 224, "You are not the sender of this order");
416 
417         uint price = (order << 34) >> 145;
418         uint amount = (order << 145) >> 145;
419         require(orderBook.remove(_key), "Map remove failed");
420 
421         uint orderFee = feeForOrder(price, amount);
422         if (orderFee > 0) {
423             feeBalances[index] = feeBalances[index].add(orderFee);
424         }
425 
426         poolOwners.sendOwnership(msg.sender, amount);
427 
428         emit OrderRemoved(orderType, msg.sender, price, amount);
429     }
430 
431     /**
432         @dev Fill a sell order in the order book
433         @dev Orders have to be filled in whole amounts
434         @param _key Key of the order as per orderbook
435      */
436     function fillSellOrder(uint _key) public payable {
437         uint order = orderBook.get(_key);
438         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
439         require(orderType == ORDER_TYPE.SELL, "This is not a sell order");
440         uint index = addressRegister(msg.sender);
441         require(index != (order << 2) >> 224, "You cannot fill your own order");
442 
443         uint price = (order << 34) >> 145;
444         uint amount = (order << 145) >> 145;
445 
446         uint orderFee = feeForOrder(price, amount);
447         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
448 
449         uint cost = price.mul(amount).div(1 ether);
450         require(msg.value == cost, "ETH sent needs to equal the cost");
451 
452         require(orderBook.remove(_key), "Map remove failed");
453 
454         addressRegistry[(order << 2) >> 224].transfer(msg.value);
455         poolOwners.sendOwnership(msg.sender, amount);
456 
457         if (orderFee > 0) {
458             feeBalances[index] = feeBalances[index].sub(orderFee);
459             uint totalFee = orderFee.mul(2);
460             totalFees = totalFees.sub(totalFee);
461             feeToken.transfer(poolOwners, totalFee);
462         }
463 
464         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
465     }
466 
467     /**
468         @dev Fill a buy order in the order book
469         @dev Orders have to be filled in whole amounts
470         @param _key Key of the order, which is the buyers address
471      */
472     function fillBuyOrder(uint _key) public {
473         uint order = orderBook.get(_key);
474         ORDER_TYPE orderType = ORDER_TYPE(order >> 254);
475         require(orderType == ORDER_TYPE.BUY, "This is not a buy order");
476         uint index = addressRegister(msg.sender);
477         require(index != (order << 2) >> 224, "You cannot fill your own order");
478 
479         uint price = (order << 34) >> 145;
480         uint amount = (order << 145) >> 145;
481 
482         uint orderFee = feeForOrder(price, amount);
483         require(feeBalances[index] >= orderFee, "You do not have enough deposited fees to fill this order");
484 
485         uint cost = price.mul(amount).div(1 ether);
486         
487         require(orderBook.remove(_key), "Map remove failed");
488 
489         msg.sender.transfer(cost);
490         poolOwners.sendOwnershipFrom(msg.sender, addressRegistry[(order << 2) >> 224], amount);
491 
492         if (orderFee > 0) {
493             feeBalances[index] = feeBalances[index].sub(orderFee);
494             uint totalFee = orderFee.mul(2);
495             totalFees = totalFees.sub(totalFee);
496             feeToken.transfer(poolOwners, totalFee);
497         }
498 
499         emit OrderFilled(orderType, addressRegistry[(order << 2) >> 224], msg.sender, price, amount);
500     }
501 
502     /**
503         @dev Send any fee token earned via PoolOwners distribution back to be re-distributed
504      */
505     function withdrawDistributedToPoolOwners() public {
506         uint balance = feeToken.balanceOf(this).sub(totalFees);
507         require(balance > 0, "There is no distributed fee token balance in the contract");
508         feeToken.transfer(poolOwners, balance);
509     }
510 
511     /**
512         @dev Get a single order by its key
513         @param _key The key of the order as per the book
514      */
515     function getOrder(uint _key) public view returns (ORDER_TYPE, address, uint, uint) {
516         uint order = orderBook.get(_key);
517         return (
518             ORDER_TYPE(order >> 254), 
519             addressRegistry[(order << 2) >> 224], 
520             (order << 34) >> 145, 
521             (order << 145) >> 145
522         );
523     }
524 
525     /**
526         @dev Get a batch of 10 orders by a given array of keys
527         @dev ID's has to be equal or less than 10 in length, or an empty response is given
528         @param _start The starting index in the order book to return from
529      */
530     function getOrders(uint _start) public view returns (
531         uint[10] keys,
532         address[10] addresses, 
533         ORDER_TYPE[10] orderTypes, 
534         uint[10] prices, 
535         uint[10] amounts
536     ) {
537         for (uint i = 0; i < 10; i++) {
538             if (orderBook.size() == _start + i) {
539                 break;
540             }
541             uint key = orderBook.getKey(_start + i);
542             keys[i] = key;
543             uint order = orderBook.get(key);
544             addresses[i] = addressRegistry[(order << 2) >> 224];
545             orderTypes[i] = ORDER_TYPE(order >> 254);
546             prices[i] = (order << 34) >> 145;
547             amounts[i] = (order << 145) >> 145;
548         }
549         return (keys, addresses, orderTypes, prices, amounts);
550     }
551 
552     /**
553         @dev Get an orderbook key from the orderbook index
554         @param _i The index to fetch the key for
555      */
556     function getOrderBookKey(uint _i) public view returns (uint key) {
557         if (_i < orderBook.size()) {
558             key = orderBook.getKey(_i);
559         } else {
560             key = 0;
561         }
562         return key;
563     }
564 
565     /**
566         @dev Get orderbook keys in batches of 10
567         @param _start The start of the index for the batch
568      */
569     function getOrderBookKeys(uint _start) public view returns (uint[10] keys) {
570         for (uint i = 0; i < 10; i++) {
571             if (i + _start < orderBook.size()) {
572                 keys[i] = orderBook.getKey(_start + i);
573             } else {
574                 keys[i] = 0;
575             }
576         }
577         return keys;
578     }
579 
580     /**
581         @dev Get the orderbook size to allow for batch fetching of keys
582      */
583     function getOrderBookSize() public view returns (uint) {
584         return orderBook.size();
585     }
586 
587     /**
588         @dev Verify that the number being passed fits into 111 bits for packing
589         @param _val The value to check
590      */
591     function is111bit(uint _val) private pure returns (bool) {
592         return (_val < 1 << 111);
593     }
594 
595 }