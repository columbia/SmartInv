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
21 
22 /**
23  * @title SafeMath
24  * @dev Unsigned math operations with safety checks that revert on error
25  */
26 library SafeMath {
27     /**
28      * @dev Multiplies two unsigned integers, reverts on overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
32         // benefit is lost if 'b' is also tested.
33         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b);
40 
41         return c;
42     }
43 
44     /**
45      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
46      */
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         // Solidity only automatically asserts when dividing by 0
49         require(b > 0);
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52 
53         return c;
54     }
55 
56     /**
57      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b <= a);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Adds two unsigned integers, reverts on overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a);
72 
73         return c;
74     }
75 
76     /**
77      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
78      * reverts when dividing by zero.
79      */
80     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b != 0);
82         return a % b;
83     }
84 }
85 
86 
87 contract Medianizer {
88     function read() public view returns (bytes32);
89 }
90 
91 
92 contract Weth {
93     mapping(address => mapping(address => uint)) public allowance;
94     mapping(address => uint) public balanceOf;
95 
96     function transferFrom(address src, address dst, uint wad) public returns (bool);
97 }
98 
99 
100 /// @author The Subscrypto Team
101 /// @title Subscrypto recurring payments
102 contract Subscrypto {
103     using SafeMath for uint;
104     Medianizer public daiPriceContract;
105     Weth public wethContract;
106 
107     /**
108      * Constructor
109      * @param daiMedianizerContract address
110      * @param wethContractAddress address
111      */
112     constructor(address daiMedianizerContract, address wethContractAddress) public {
113         daiPriceContract = Medianizer(daiMedianizerContract);
114         wethContract = Weth(wethContractAddress);
115     }
116 
117     event NewSubscription(
118         address indexed subscriber,
119         address indexed receiver,
120         uint daiCents,
121         uint32 interval
122     );
123 
124     event Unsubscribe(
125         address indexed subscriber, 
126         address indexed receiver
127     );
128 
129     event ReceiverPaymentsCollected(
130         address indexed receiver,
131         uint weiAmount,
132         uint startIndex,
133         uint endIndex
134     );
135 
136     event PaymentCollected(
137         address indexed subscriber,
138         address indexed receiver,
139         uint weiAmount,
140         uint daiCents,
141         uint48 effectiveTimestamp
142     );
143 
144     event UnfundedPayment(
145         address indexed subscriber,
146         address indexed receiver,
147         uint weiAmount,
148         uint daiCents
149     );
150 
151     event StaleSubscription(
152         address indexed subscriber,
153         address indexed receiver
154     );
155 
156     event SubscriptionDeactivated(
157         address indexed subscriber,
158         address indexed receiver
159     );
160 
161     event SubscriptionReactivated(
162         address indexed subscriber,
163         address indexed receiver
164     );
165 
166     // Conservative amount of gas used per loop in collectPayments()
167     uint constant MIN_GAS_PER_COLLECT_PAYMENT = 45000;
168     // Force subscribers to use multiple accounts when this limit is reached.
169     uint constant MAX_SUBSCRIPTION_PER_SUBSCRIBER = 10000;
170     // Minimum payment of 1 DAI
171     uint constant MIN_SUBSCRIPTION_DAI_CENTS = 100;
172     // If this many intervals pass without being collected, mark as inactive
173     uint constant STALE_INTERVAL_THRESHOLD = 3;
174 
175     struct Subscription {
176         bool    isActive;        //  1 byte
177         uint48  nextPaymentTime; //  6 bytes
178         uint32  interval;        //  4 bytes
179         address subscriber;      // 20 bytes
180         address receiver;        // 20 bytes
181         uint    daiCents;        // 32 bytes
182     }
183 
184     // global counter for suscriptions
185     uint64 nextIndex = 1;
186 
187     // source of truth for subscriptions
188     mapping(uint64 => Subscription) public subscriptions;
189 
190     // subscriber => receiver => subsciptionIndex
191     mapping(address => mapping(address => uint64)) public subscriberReceiver;
192 
193     // receiver => subs array
194     mapping(address => uint64[]) public receiverSubs;
195 
196     // subscriber => subs array
197     mapping(address => uint64[]) public subscriberSubs;
198 
199     /**
200      * Create a new subscription. Must be called by the subscriber's account.
201      * First payment of `daiCents` is paid on creation.
202      * Actual payment is made in Wrapped Ether (wETH) using currenct DAI-ETH conversion rate.
203      * @param receiver address
204      * @param daiCents subscription amount in hundredths of DAI
205      * @param interval seconds between payments
206      */
207     function subscribe(address receiver, uint daiCents, uint32 interval) external {
208         uint weiAmount = daiCentsToEthWei(daiCents, ethPriceInDaiWad());
209         uint64 existingIndex = subscriberReceiver[msg.sender][receiver];
210         require(subscriptions[existingIndex].daiCents == 0, "Subscription exists");
211         require(daiCents >= MIN_SUBSCRIPTION_DAI_CENTS, "Subsciption amount too low");
212         require(interval >= 86400, "Interval must be at least 1 day");
213         require(interval <= 31557600, "Interval must be at most 1 year");
214         require(subscriberSubs[msg.sender].length < MAX_SUBSCRIPTION_PER_SUBSCRIBER,"Subscription count limit reached");
215 
216         // first payment
217         require(wethContract.transferFrom(msg.sender, receiver, weiAmount), "wETH transferFrom() failed");
218 
219         // add to subscription mappings
220         subscriptions[nextIndex] = Subscription(
221             true,
222             uint48(now.add(interval)),
223             interval,
224             msg.sender,
225             receiver,
226             daiCents
227         );
228         subscriberReceiver[msg.sender][receiver] = nextIndex;
229         receiverSubs[receiver].push(nextIndex);
230         subscriberSubs[msg.sender].push(nextIndex);
231 
232         emit NewSubscription(msg.sender, receiver, daiCents, interval);
233         emit PaymentCollected(msg.sender, receiver, weiAmount, daiCents, uint48(now));
234 
235         nextIndex++;
236     }
237     
238     /**
239      * Deactivate a subscription. Must be called by the subscriber's account.
240      * Payments cannot be collected from deactivated subscriptons.
241      * @param receiver address used to identify the unique subscriber-receiver pair.
242      * @return success
243      */
244     function deactivateSubscription(address receiver) external returns (bool) {
245         uint64 index = subscriberReceiver[msg.sender][receiver];
246         require(index != 0, "Subscription does not exist");
247 
248         Subscription storage sub = subscriptions[index];
249         require(sub.isActive, "Subscription is already disabled");
250         require(sub.daiCents > 0, "Subscription does not exist");
251 
252         sub.isActive = false;
253         emit SubscriptionDeactivated(msg.sender, receiver);
254 
255         return true;
256     }
257 
258     /**
259      * Reactivate a subscription. Must be called by the subscriber's account.
260      * If less than one interval has passed since the last payment, no payment is collected now.
261      * Otherwise it is treated as a new subscription starting now, and the first payment is collected.
262      * No back-payments are collected.
263      * @param receiver addres used to identify the unique subscriber-receiver pair.
264      * @return success
265      */
266     function reactivateSubscription(address receiver) external returns (bool) {
267         uint64 index = subscriberReceiver[msg.sender][receiver];
268         require(index != 0, "Subscription does not exist");
269 
270         Subscription storage sub = subscriptions[index];
271         require(!sub.isActive, "Subscription is already active");
272 
273         sub.isActive = true;
274         emit SubscriptionReactivated(msg.sender, receiver);
275 
276         if (calculateUnpaidIntervalsUntil(sub, now) > 0) {
277             // only make a payment if at least one interval has lapsed since the last payment
278             uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceInDaiWad());
279             require(wethContract.transferFrom(msg.sender, receiver, weiAmount), "Insufficient funds to reactivate subscription");
280             emit PaymentCollected(msg.sender, receiver, weiAmount, sub.daiCents, uint48(now));
281         }
282 
283         sub.nextPaymentTime = uint48(now.add(sub.interval));
284 
285         return true;
286     }
287 
288     /**
289      * Delete a subscription. Must be called by the subscriber's account.
290      * @param receiver address used to identify the unique subscriber-receiver pair.
291      */
292     function unsubscribe(address receiver) external {
293         uint64 index = subscriberReceiver[msg.sender][receiver];
294         require(index != 0, "Subscription does not exist");
295         delete subscriptions[index];
296         delete subscriberReceiver[msg.sender][receiver];
297         deleteElement(subscriberSubs[msg.sender], index);
298         emit Unsubscribe(msg.sender, receiver);
299     }
300 
301     /**
302      * Delete a subscription. Must be called by the receiver's account.
303      * @param subscriber address used to identify the unique subscriber-receiver pair.
304      */
305     function unsubscribeByReceiver(address subscriber) external {
306         uint64 index = subscriberReceiver[subscriber][msg.sender];
307         require(index != 0, "Subscription does not exist");
308         delete subscriptions[index];
309         delete subscriberReceiver[subscriber][msg.sender];
310         deleteElement(subscriberSubs[subscriber], index);
311         emit Unsubscribe(subscriber, msg.sender);
312     }
313 
314     /**
315      * Collect all available *funded* payments for a receiver's account.
316      * Helper function that calls collectPaymentsRange() with the full range.
317      * Will process as many payments as possible with the gas provided and exit gracefully.
318      * 
319      * @param receiver address
320      */
321     function collectPayments(address receiver) external {
322         collectPaymentsRange(receiver, 0, receiverSubs[receiver].length);
323     }
324 
325     /**
326      * A read-only version of collectPayments()
327      * Calculates uncollected *funded* payments for a receiver.
328      * @param receiver address
329      * @return total unclaimed value in wei
330      */
331     function getTotalUnclaimedPayments(address receiver) external view returns (uint) {
332         uint totalPayment = 0;
333         uint ethPriceWad = ethPriceInDaiWad();
334 
335         for (uint i = 0; i < receiverSubs[receiver].length; i++) {
336             Subscription storage sub = subscriptions[receiverSubs[receiver][i]];
337 
338             if (sub.isActive && sub.daiCents != 0) {
339                 uint wholeUnpaidIntervals = calculateUnpaidIntervalsUntil(sub, now);
340                 if (wholeUnpaidIntervals > 0 && wholeUnpaidIntervals < STALE_INTERVAL_THRESHOLD) {
341                     uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceWad);
342                     uint authorizedBalance = allowedBalance(sub.subscriber);
343 
344                     do {
345                         if (authorizedBalance >= weiAmount) {
346                             totalPayment = totalPayment.add(weiAmount);
347                             authorizedBalance = authorizedBalance.sub(weiAmount);
348                         }
349                         wholeUnpaidIntervals = wholeUnpaidIntervals.sub(1);
350                     } while (wholeUnpaidIntervals > 0);
351                 }
352             }
353         }
354 
355         return totalPayment;
356     }
357 
358     /**
359      * Calculates a subscriber's total outstanding payments in daiCents
360      * @param subscriber address
361      * @param time in seconds. If `time` < `now`, then we simply use `now`
362      * @return total amount owed at `time` in daiCents
363      */
364     function outstandingBalanceUntil(address subscriber, uint time) external view returns (uint) {
365         uint until = time <= now ? now : time;
366 
367         uint64[] memory subs = subscriberSubs[subscriber];
368 
369         uint totalDaiCents = 0;
370         for (uint64 i = 0; i < subs.length; i++) {
371             Subscription memory sub = subscriptions[subs[i]];
372             if (sub.isActive) {
373                 totalDaiCents = totalDaiCents.add(sub.daiCents.mul(calculateUnpaidIntervalsUntil(sub, until)));
374             }
375         }
376 
377         return totalDaiCents;
378     }
379 
380     /**
381      * Collect available *funded* payments for a receiver's account within a certain range of receiverSubs[receiver].
382      * Will process as many payments as possible with the gas provided and exit gracefully.
383      * 
384      * @param receiver address
385      * @param start starting index of receiverSubs[receiver]
386      * @param end ending index of receiverSubs[receiver]
387      * @return last processed index
388      */
389     function collectPaymentsRange(address receiver, uint start, uint end) public returns (uint) {
390         uint64[] storage subs = receiverSubs[receiver];
391         require(subs.length > 0, "receiver has no subscriptions");
392         require(start < end && end <= subs.length, "wrong arguments for range");
393         uint totalPayment = 0;
394         uint ethPriceWad = ethPriceInDaiWad();
395 
396         uint last = end;
397         uint i = start;
398         while (i < last) {
399             if (gasleft() < MIN_GAS_PER_COLLECT_PAYMENT) {
400                 break;
401             }
402             Subscription storage sub = subscriptions[subs[i]];
403 
404             // delete empty subs
405             while (sub.daiCents == 0 && subs.length > 0) {
406                 uint lastIndex = subs.length.sub(1);
407                 subs[i] = subs[lastIndex];
408                 delete(subs[lastIndex]);
409                 subs.length = lastIndex;
410                 if (last > lastIndex) {
411                     last = lastIndex;
412                 }
413                 if (lastIndex > 0) {
414                     sub = subscriptions[subs[i]];
415                 }
416             }
417 
418             if (sub.isActive && sub.daiCents != 0) {
419                 uint wholeUnpaidIntervals = calculateUnpaidIntervalsUntil(sub, now);
420                 
421                 if (wholeUnpaidIntervals > 0) {
422                     // this could be placed in the following else{} block, but the stack becomes too deep
423                     uint subscriberPayment = 0;
424 
425                     if (wholeUnpaidIntervals >= STALE_INTERVAL_THRESHOLD) {
426                         sub.isActive = false;
427                         emit SubscriptionDeactivated(sub.subscriber, receiver);
428                         emit StaleSubscription(sub.subscriber, receiver);
429                     } else {
430                         uint weiAmount = daiCentsToEthWei(sub.daiCents, ethPriceWad);
431                         uint authorizedBalance = allowedBalance(sub.subscriber);
432 
433                         do {
434                             if (authorizedBalance >= weiAmount) {
435                                 totalPayment = totalPayment.add(weiAmount);
436                                 subscriberPayment = subscriberPayment.add(weiAmount);
437                                 authorizedBalance = authorizedBalance.sub(weiAmount);
438                                 emit PaymentCollected(sub.subscriber, receiver, weiAmount, sub.daiCents, sub.nextPaymentTime);
439                                 sub.nextPaymentTime = calculateNextPaymentTime(sub);
440                             } else {
441                                 emit UnfundedPayment(sub.subscriber, receiver, weiAmount, sub.daiCents);
442                             }
443                             wholeUnpaidIntervals = wholeUnpaidIntervals.sub(1);
444                         } while (wholeUnpaidIntervals > 0);
445                     }
446 
447                     if (subscriberPayment > 0) {
448                         assert(wethContract.transferFrom(sub.subscriber, receiver, subscriberPayment));
449                     }
450                 }
451             }
452 
453             i++;
454         }
455 
456         emit ReceiverPaymentsCollected(receiver, totalPayment, start, i);
457         return i;
458     }
459 
460     /**
461      * Calculates how much wETH balance Subscrypto is authorized to use on bealf of `subscriber`.
462      * Returns the minimum(subscriber's wETH balance, amount authorized to Subscrypto).
463      * @param subscriber address
464      * @return wad amount of wETH available for Subscrypto payments
465      */
466     function allowedBalance(address subscriber) public view returns (uint) {
467         uint balance = wethContract.balanceOf(subscriber);
468         uint allowance = wethContract.allowance(subscriber, address(this));
469 
470         return balance > allowance ? allowance : balance;
471     }
472 
473     /**
474      * Calls the DAI medianizer contract to get the current exchange rate for ETH-DAI
475      * @return current ETH price in DAI (wad format)
476      */
477     function ethPriceInDaiWad() public view returns (uint) {
478         uint price = uint(daiPriceContract.read());
479         require(price > 1, "Invalid price for DAI.");
480         return price;
481     }
482 
483     /**
484      * Helper function to search for and delete an array element without leaving a gap.
485      * Array size is also decremented.
486      * DO NOT USE if ordering is important.
487      * @param array array to be modified
488      * @param element value to be removed
489      */
490     function deleteElement(uint64[] storage array, uint64 element) internal {
491         uint lastIndex = array.length.sub(1);
492         for (uint i = 0; i < array.length; i++) {
493             if (array[i] == element) {
494                 array[i] = array[lastIndex];
495                 delete(array[lastIndex]);
496                 array.length = lastIndex;
497                 break;
498             }
499         }
500     }
501 
502     /**
503      * Calculates how many whole unpaid intervals (will) have elapsed since the last payment at a specific `time`.
504      * DOES NOT check if subscriber account is funded.
505      * @param sub Subscription object
506      * @param time timestamp in seconds
507      * @return number of unpaid intervals
508      */
509     function calculateUnpaidIntervalsUntil(Subscription memory sub, uint time) internal view returns (uint) {
510         require(time >= now, "don't use a time before now");
511 
512         if (time > sub.nextPaymentTime) {
513             return ((time.sub(sub.nextPaymentTime)).div(sub.interval)).add(1);
514         }
515 
516         return 0;
517     }
518 
519     /**
520      * Safely calculate the next payment timestamp for a Subscription
521      * @param sub Subscription object
522      * @return uint48 timestamp in seconds of the next payment
523      */
524     function calculateNextPaymentTime(Subscription memory sub) internal pure returns (uint48) {
525         uint48 nextPaymentTime = sub.nextPaymentTime + sub.interval;
526         assert(nextPaymentTime > sub.nextPaymentTime);
527         return nextPaymentTime;
528     }
529 
530     /**
531      * Converts DAI (cents) to ETH (wei) without losing precision
532      * @param daiCents one hundreth of a DAI
533      * @param ethPriceWad price from calling ethPriceInDaiWad()
534      * @return ETH value denominated in wei
535      */
536     function daiCentsToEthWei(uint daiCents, uint ethPriceWad) internal pure returns (uint) {
537         return centsToWad(daiCents).mul(10**18).div(ethPriceWad);
538     }
539 
540     /**
541      * Converts amount in cents (hundredths of DAI) to amount in wad
542      * @param cents daiCents (hundredths of DAI)
543      * @return amount of dai in wad
544      */
545     function centsToWad(uint cents) internal pure returns (uint) {
546         return cents.mul(10**16);
547     }
548 }