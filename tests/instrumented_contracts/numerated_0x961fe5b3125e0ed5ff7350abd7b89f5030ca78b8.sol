1 /*  
2     Subscrypto
3     Copyright (C) 2019 Subscrypto Team
4 
5     This program is free software: you can redistribute it and/or modify
6     it under the terms of the GNU General Public License as published by
7     the Free Software Foundation, either version 3 of the License, or
8     (at your option) any later version.
9 
10     This program is distributed in the hope that it will be useful,
11     but WITHOUT ANY WARRANTY; without even the implied warranty of
12     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13     GNU General Public License for more details.
14 
15     You should have received a copy of the GNU General Public License
16     along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 */
18 
19 pragma solidity 0.5.2;
20 
21 /**
22  * @title SafeMath
23  * @dev Unsigned math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     /**
27      * @dev Multiplies two unsigned integers, reverts on overflow.
28      */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45      */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57      */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Adds two unsigned integers, reverts on overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77      * reverts when dividing by zero.
78      */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 }
84 
85 
86 contract Medianizer {
87     function read() public view returns (bytes32);
88 }
89 
90 
91 contract Weth {
92     mapping(address => mapping(address => uint)) public allowance;
93     mapping(address => uint) public balanceOf;
94 
95     function transferFrom(address src, address dst, uint wad) public returns (bool);
96 }
97 
98 
99 /// @author The Subscrypto Team
100 /// @title Subscrypto recurring payments
101 contract Subscrypto {
102     using SafeMath for uint;
103     Medianizer public daiPriceContract;
104     Weth public wethContract;
105 
106     /**
107      * Constructor
108      * @param daiMedianizerContract address
109      * @param wethContractAddress address
110      */
111     constructor(address daiMedianizerContract, address wethContractAddress) public {
112         daiPriceContract = Medianizer(daiMedianizerContract);
113         wethContract = Weth(wethContractAddress);
114     }
115 
116     event NewSubscription(
117         address indexed subscriber,
118         address indexed receiver,
119         uint daiCents,
120         uint32 interval
121     );
122 
123     event Unsubscribe(
124         address indexed subscriber, 
125         address indexed receiver
126     );
127 
128     event ReceiverPaymentsCollected(
129         address indexed receiver,
130         uint weiAmount,
131         uint startIndex,
132         uint endIndex
133     );
134 
135     event SubscriptionPaid(
136         address indexed subscriber,
137         address indexed receiver,
138         uint weiAmount,
139         uint daiCents,
140         uint48 effectiveTimestamp
141     );
142 
143     event UnfundedPayment(
144         address indexed subscriber,
145         address indexed receiver,
146         uint weiAmount,
147         uint daiCents
148     );
149 
150     event StaleSubscription(
151         address indexed subscriber,
152         address indexed receiver
153     );
154 
155     event SubscriptionDeactivated(
156         address indexed subscriber,
157         address indexed receiver
158     );
159 
160     event SubscriptionReactivated(
161         address indexed subscriber,
162         address indexed receiver
163     );
164 
165     // Conservative amount of gas used per loop in executeDebits()
166     uint constant MIN_GAS_PER_EXECUTE_DEBIT = 45000;
167     // Force subscribers to use multiple accounts when this limit is reached.
168     uint constant MAX_SUBSCRIPTION_PER_SUBSCRIBER = 10000;
169     // Minimum payment of 1 DAI
170     uint constant MIN_SUBSCRIPTION_DAI_CENTS = 100;
171 
172     struct Subscription {
173         bool    isActive;        //  1 byte
174         uint48  nextPaymentTime; //  6 bytes
175         uint32  interval;        //  4 bytes
176         address subscriber;      // 20 bytes
177         address receiver;        // 20 bytes
178         uint    daiCents;        // 32 bytes
179     }
180 
181     // global counter for suscriptions
182     uint64 nextIndex = 1;
183 
184     // source of truth for subscriptions
185     mapping(uint64 => Subscription) public subscriptions;
186 
187     // subscriber => receiver => subsciptionIndex
188     mapping(address => mapping(address => uint64)) public subscriberReceiver;
189 
190     // receiver => subs array
191     mapping(address => uint64[]) public receiverSubs;
192 
193     // subscriber => subs array
194     mapping(address => uint64[]) public subscriberSubs;
195 
196     /**
197      * Create a new subscription. Must be called by the subscriber's account.
198      * First payment of `daiCents` is paid on creation.
199      * Actual payment is made in Wrapped Ether (wETH) using currenct DAI-ETH conversion rate.
200      * @param receiver address
201      * @param daiCents subscription amount in hundredths of DAI
202      * @param interval seconds between payments
203      */
204     function subscribe(address receiver, uint daiCents, uint32 interval) external {
205         uint weiAmount = daiCentsToEthWei(daiCents, ethPriceInDaiWad());
206         uint64 existingIndex = subscriberReceiver[msg.sender][receiver];
207         require(subscriptions[existingIndex].daiCents == 0, "Subscription exists");
208         require(daiCents >= MIN_SUBSCRIPTION_DAI_CENTS, "Subsciption amount too low");
209         require(interval >= 86400, "Interval must be at least 1 day");
210         require(interval <= 31557600, "Interval must be at most 1 year");
211         require(subscriberSubs[msg.sender].length < MAX_SUBSCRIPTION_PER_SUBSCRIBER,"Subscription count limit reached");
212 
213         // first payment
214         require(wethContract.transferFrom(msg.sender, receiver, weiAmount), "wETH transferFrom() failed");
215 
216         // add to subscription mappings
217         subscriptions[nextIndex] = Subscription(
218             true,
219             uint48(now.add(interval)),
220             interval,
221             msg.sender,
222             receiver,
223             daiCents
224         );
225         subscriberReceiver[msg.sender][receiver] = nextIndex;
226         receiverSubs[receiver].push(nextIndex);
227         subscriberSubs[msg.sender].push(nextIndex);
228 
229         emit NewSubscription(msg.sender, receiver, daiCents, interval);
230         emit SubscriptionPaid(msg.sender, receiver, weiAmount, daiCents, uint48(now));
231 
232         nextIndex++;
233     }
234     
235     /**
236      * Deactivate a subscription. Must be called by the subscriber's account.
237      * Payments cannot be collected from deactivated subscriptons.
238      * @param receiver address used to identify the unique subscriber-receiver pair.
239      * @return success
240      */
241     function deactivateSubscription(address receiver) external returns (bool) {
242         uint64 index = subscriberReceiver[msg.sender][receiver];
243         require(index != 0, "Subscription does not exist");
244 
245         Subscription storage sub = subscriptions[index];
246         require(sub.isActive, "Subscription is already disabled");
247         require(sub.daiCents > 0, "Subscription does not exist");
248 
249         sub.isActive = false;
250         emit SubscriptionDeactivated(msg.sender, receiver);
251 
252         return true;
253     }
254 
255     /**
256      * Reactivate a subscription. Must be called by the subscriber's account.
257      * If less than one interval has passed since the last payment, no payment is collected now.
258      * Otherwise it is treated as a new subscription starting now, and the first payment is collected.
259      * No back-payments are collected.
260      * @param receiver addres used to identify the unique subscriber-receiver pair.
261      * @return success
262      */
263     function reactivateSubscription(address receiver) external returns (bool) {
264         uint64 index = subscriberReceiver[msg.sender][receiver];
265         require(index != 0, "Subscription does not exist");
266 
267         Subscription storage sub = subscriptions[index];
268         require(!sub.isActive, "Subscription is already active");
269 
270         sub.isActive = true;
271         emit SubscriptionReactivated(msg.sender, receiver);
272 
273         if (calculateUnpaidIntervalsUntil(sub, now) > 0) {
274             // only make a payment if at least one interval has lapsed since the last payment
275             uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceInDaiWad());
276             require(wethContract.transferFrom(msg.sender, receiver, weiAmount), "Insufficient funds to reactivate subscription");
277             emit SubscriptionPaid(msg.sender, receiver, weiAmount, sub.daiCents, uint48(now));
278         }
279 
280         sub.nextPaymentTime = uint48(now.add(sub.interval));
281 
282         return true;
283     }
284 
285     /**
286      * Delete a subscription. Must be called by the subscriber's account.
287      * @param receiver address used to identify the unique subscriber-receiver pair.
288      */
289     function unsubscribe(address receiver) external {
290         uint64 index = subscriberReceiver[msg.sender][receiver];
291         require(index != 0, "Subscription does not exist");
292         delete subscriptions[index];
293         delete subscriberReceiver[msg.sender][receiver];
294         deleteElement(subscriberSubs[msg.sender], index);
295         emit Unsubscribe(msg.sender, receiver);
296     }
297 
298     /**
299      * Delete a subscription. Must be called by the receiver's account.
300      * @param subscriber address used to identify the unique subscriber-receiver pair.
301      */
302     function unsubscribeByReceiver(address subscriber) external {
303         uint64 index = subscriberReceiver[subscriber][msg.sender];
304         require(index != 0, "Subscription does not exist");
305         delete subscriptions[index];
306         delete subscriberReceiver[subscriber][msg.sender];
307         deleteElement(subscriberSubs[subscriber], index);
308         emit Unsubscribe(subscriber, msg.sender);
309     }
310 
311     /**
312      * Collect all available *funded* payments for a receiver's account.
313      * Helper function that calls executeDebitsRange() with the full range.
314      * Will process as many payments as possible with the gas provided and exit gracefully.
315      * 
316      * @param receiver address
317      */
318     function executeDebits(address receiver) external {
319         executeDebitsRange(receiver, 0, receiverSubs[receiver].length);
320     }
321 
322     /**
323      * A read-only version of executeDebits()
324      * Calculates uncollected *funded* payments for a receiver.
325      * @param receiver address
326      * @return total unclaimed value in wei
327      */
328     function getTotalUnclaimedPayments(address receiver) external view returns (uint) {
329         uint totalPayment = 0;
330         uint ethPriceWad = ethPriceInDaiWad();
331 
332         for (uint i = 0; i < receiverSubs[receiver].length; i++) {
333             Subscription storage sub = subscriptions[receiverSubs[receiver][i]];
334 
335             if (sub.isActive && sub.daiCents != 0) {
336                 uint wholeUnpaidIntervals = calculateUnpaidIntervalsUntil(sub, now);
337                 if (wholeUnpaidIntervals > 0) {
338                     uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceWad);
339                     uint authorizedBalance = allowedBalance(sub.subscriber);
340 
341                     do {
342                         if (authorizedBalance >= weiAmount) {
343                             totalPayment = totalPayment.add(weiAmount);
344                             authorizedBalance = authorizedBalance.sub(weiAmount);
345                         }
346                         wholeUnpaidIntervals = wholeUnpaidIntervals.sub(1);
347                     } while (wholeUnpaidIntervals > 0);
348                 }
349             }
350         }
351 
352         return totalPayment;
353     }
354 
355     /**
356      * Calculates a subscriber's total outstanding payments in daiCents
357      * @param subscriber address
358      * @param time in seconds. If `time` < `now`, then we simply use `now`
359      * @return total amount owed at `time` in daiCents
360      */
361     function outstandingBalanceUntil(address subscriber, uint time) external view returns (uint) {
362         uint until = time <= now ? now : time;
363 
364         uint64[] memory subs = subscriberSubs[subscriber];
365 
366         uint totalDaiCents = 0;
367         for (uint64 i = 0; i < subs.length; i++) {
368             Subscription memory sub = subscriptions[subs[i]];
369             if (sub.isActive) {
370                 totalDaiCents = totalDaiCents.add(sub.daiCents.mul(calculateUnpaidIntervalsUntil(sub, until)));
371             }
372         }
373 
374         return totalDaiCents;
375     }
376 
377     /**
378      * Collect available *funded* payments for a receiver's account within a certain range of receiverSubs[receiver].
379      * Will process as many payments as possible with the gas provided and exit gracefully.
380      * 
381      * @param receiver address
382      * @param start starting index of receiverSubs[receiver]
383      * @param end ending index of receiverSubs[receiver]
384      * @return last processed index
385      */
386     function executeDebitsRange(address receiver, uint start, uint end) public returns (uint) {
387         uint64[] storage subs = receiverSubs[receiver];
388         require(subs.length > 0, "receiver has no subscriptions");
389         require(start < end && end <= subs.length, "wrong arguments for range");
390         uint totalPayment = 0;
391         uint ethPriceWad = ethPriceInDaiWad();
392 
393         uint last = end;
394         uint i = start;
395         while (i < last) {
396             if (gasleft() < MIN_GAS_PER_EXECUTE_DEBIT) {
397                 break;
398             }
399             Subscription storage sub = subscriptions[subs[i]];
400 
401             // delete empty subs
402             while (sub.daiCents == 0 && subs.length > 0) {
403                 uint lastIndex = subs.length.sub(1);
404                 subs[i] = subs[lastIndex];
405                 delete(subs[lastIndex]);
406                 subs.length = lastIndex;
407                 if (last > lastIndex) {
408                     last = lastIndex;
409                 }
410                 if (lastIndex > 0) {
411                     sub = subscriptions[subs[i]];
412                 }
413             }
414 
415             if (sub.isActive && sub.daiCents != 0) {
416                 uint wholeUnpaidIntervals = calculateUnpaidIntervalsUntil(sub, now);
417                 if (wholeUnpaidIntervals > 0) {
418                     uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceWad);
419                     uint authorizedBalance = allowedBalance(sub.subscriber);
420 
421                     do {
422                         if (authorizedBalance >= weiAmount) {
423                             assert(wethContract.transferFrom(sub.subscriber, receiver, weiAmount));
424                             sub.nextPaymentTime = calculateNextPaymentTime(sub);
425                             totalPayment = totalPayment.add(weiAmount);
426                             emit SubscriptionPaid(sub.subscriber, receiver, weiAmount, sub.daiCents, sub.nextPaymentTime);
427                         } else {
428                             emit UnfundedPayment(sub.subscriber, receiver, weiAmount, sub.daiCents);
429 
430                             if (wholeUnpaidIntervals >= 2) {
431                                 sub.isActive = false;
432                                 emit SubscriptionDeactivated(sub.subscriber, receiver);
433                                 emit StaleSubscription(sub.subscriber, receiver);
434                                 break;
435                             }
436                         }
437                         wholeUnpaidIntervals = wholeUnpaidIntervals.sub(1);
438                     } while (wholeUnpaidIntervals > 0);
439                 }
440             }
441 
442             i++;
443         }
444 
445         emit ReceiverPaymentsCollected(receiver, totalPayment, start, i);
446         return i;
447     }
448 
449     /**
450      * Calculates how much wETH balance Subscrypto is authorized to use on bealf of `payer`.
451      * Returns the minimum(payer's wETH balance, amount authorized to Subscrypto).
452      * @param payer address
453      * @return wad amount of wETH available for Subscrypto payments
454      */
455     function allowedBalance(address payer) public view returns (uint) {
456         uint balance = wethContract.balanceOf(payer);
457         uint allowance = wethContract.allowance(payer, address(this));
458 
459         return balance > allowance ? allowance : balance;
460     }
461 
462     /**
463      * Calls the DAI medianizer contract to get the current exchange rate for ETH-DAI
464      * @return current ETH price in DAI (wad format)
465      */
466     function ethPriceInDaiWad() public view returns (uint) {
467         uint price = uint(daiPriceContract.read());
468         require(price > 1, "Invalid price for DAI.");
469         return price;
470     }
471 
472     /**
473      * Helper function to search for and delete an array element without leaving a gap.
474      * Array size is also decremented.
475      * DO NOT USE if ordering is important.
476      * @param array array to be modified
477      * @param element value to be removed
478      */
479     function deleteElement(uint64[] storage array, uint64 element) internal {
480         uint lastIndex = array.length.sub(1);
481         for (uint i = 0; i < array.length; i++) {
482             if (array[i] == element) {
483                 array[i] = array[lastIndex];
484                 delete(array[lastIndex]);
485                 array.length = lastIndex;
486                 break;
487             }
488         }
489     }
490 
491     /**
492      * Calculates how many whole unpaid intervals (will) have elapsed since the last payment at a specific `time`.
493      * DOES NOT check if subscriber account is funded.
494      * @param sub Subscription object
495      * @param time timestamp in seconds
496      * @return number of unpaid intervals
497      */
498     function calculateUnpaidIntervalsUntil(Subscription memory sub, uint time) internal view returns (uint) {
499         require(time >= now, "don't use a time before now");
500 
501         if (time > sub.nextPaymentTime) {
502             return ((time.sub(sub.nextPaymentTime)).div(sub.interval)).add(1);
503         }
504 
505         return 0;
506     }
507 
508     /**
509      * Safely calculate the next payment timestamp for a Subscription
510      * @param sub Subscription object
511      * @return uint48 timestamp in seconds of the next payment
512      */
513     function calculateNextPaymentTime(Subscription memory sub) internal pure returns (uint48) {
514         uint48 nextPaymentTime = sub.nextPaymentTime + sub.interval;
515         assert(nextPaymentTime > sub.nextPaymentTime);
516         return nextPaymentTime;
517     }
518 
519     /**
520      * Converts DAI (cents) to ETH (wei) without losing precision
521      * @param daiCents one hundreth of a DAI
522      * @param ethPriceWad price from calling ethPriceInDaiWad()
523      * @return ETH value denominated in wei
524      */
525     function daiCentsToEthWei(uint daiCents, uint ethPriceWad) internal pure returns (uint) {
526         return centsToWad(daiCents).mul(10**18).div(ethPriceWad);
527     }
528 
529     /**
530      * Converts amount in cents (hundredths of DAI) to amount in wad
531      * @param cents daiCents (hundredths of DAI)
532      * @return amount of dai in wad
533      */
534     function centsToWad(uint cents) internal pure returns (uint) {
535         return cents.mul(10**16);
536     }
537 }