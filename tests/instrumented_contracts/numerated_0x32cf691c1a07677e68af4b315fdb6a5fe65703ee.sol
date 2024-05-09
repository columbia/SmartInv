1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  *
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     // A hashmap to help keep track of list of all owners
14     mapping(address => uint) public allOwnersMap;
15 
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor () public {
22         owner = msg.sender;
23         allOwnersMap[msg.sender] = 1;
24     }
25 
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner, "You're not the owner!");
32         _;
33     }
34 
35 
36     /**
37      * @dev Throws if called by any account other than the all owners in the history of
38      * the smart contract.
39      */
40     modifier onlyAnyOwners() {
41         require(allOwnersMap[msg.sender] == 1, "You're not the owner or never were the owner!");
42         _;
43     }
44 
45 
46     /**
47      * @dev Allows the current owner to transfer control of the contract to a newOwner.
48      * @param newOwner The address to transfer ownership to.
49      */
50     function transferOwnership(address newOwner) public onlyOwner {
51         require(newOwner != address(0));
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54 
55         // Keep track of list of owners
56         allOwnersMap[newOwner] = 1;
57     }
58 
59 
60     // transfer ownership event
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 }
63 
64 
65 
66 
67 
68 
69 
70 
71 
72 /**
73  * @title Suicidable
74  *
75  * @dev Suicidable is special contract with functions to suicide. This is a security measure added in
76  * incase Bitwords gets hacked.
77  */
78 contract Suicidable is Ownable {
79     bool public hasSuicided = false;
80 
81 
82     /**
83      * @dev Throws if called the contract has not yet suicided
84      */
85     modifier hasNotSuicided() {
86         require(hasSuicided == false, "Contract has suicided!");
87         _;
88     }
89 
90 
91     /**
92      * @dev Suicides the entire smart contract
93      */
94     function suicideContract() public onlyAnyOwners {
95         hasSuicided = true;
96         emit SuicideContract(msg.sender);
97     }
98 
99 
100     // suicide contract event
101     event SuicideContract(address indexed owner);
102 }
103 
104 
105 
106 /**
107  * @title Migratable
108  *
109  * @dev Migratable is special contract which allows the funds of a smart-contact to be migrated
110  * to a new smart contract.
111  */
112 contract Migratable is Suicidable {
113     bool public hasRequestedForMigration = false;
114     uint public requestedForMigrationAt = 0;
115     address public migrationDestination;
116 
117     function() public payable {
118 
119     }
120 
121     /**
122      * @dev Allows for a migration request to be created, all migrations requests
123      * are timelocked by 7 days.
124      *
125      * @param destination   The destination to send the ether to.
126      */
127     function requestForMigration(address destination) public onlyOwner {
128         hasRequestedForMigration = true;
129         requestedForMigrationAt = now;
130         migrationDestination = destination;
131 
132         emit MigrateFundsRequested(msg.sender, destination);
133     }
134 
135     /**
136      * @dev Cancels a migration
137      */
138     function cancelMigration() public onlyOwner hasNotSuicided {
139         hasRequestedForMigration = false;
140         requestedForMigrationAt = 0;
141 
142         emit MigrateFundsCancelled(msg.sender);
143     }
144 
145     /**
146      * @dev Approves a migration and suicides the entire smart contract
147      */
148     function approveMigration(uint gasCostInGwei) public onlyOwner hasNotSuicided {
149         require(hasRequestedForMigration, "please make a migration request");
150         require(requestedForMigrationAt + 604800 < now, "migration is timelocked for 7 days");
151         require(gasCostInGwei > 0, "gas cost must be more than 0");
152         require(gasCostInGwei < 20, "gas cost can't be more than 20");
153 
154         // Figure out how much ether to send
155         uint gasLimit = 21000;
156         uint gasPrice = gasCostInGwei * 1000000000;
157         uint gasCost = gasLimit * gasPrice;
158         uint etherToSend = address(this).balance - gasCost;
159 
160         require(etherToSend > 0, "not enough balance in smart contract");
161 
162         // Send the funds to the new smart contract
163         emit MigrateFundsApproved(msg.sender, etherToSend);
164         migrationDestination.transfer(etherToSend);
165 
166         // suicide the contract so that no more funds/actions can take place
167         suicideContract();
168     }
169 
170     // events
171     event MigrateFundsCancelled(address indexed by);
172     event MigrateFundsRequested(address indexed by, address indexed newSmartContract);
173     event MigrateFundsApproved(address indexed by, uint amount);
174 }
175 
176 
177 
178 /**
179  * @title Bitwords
180  *
181  * @dev The Bitwords smart contract that allows advertisers and publishers to
182  * safetly deposit/receive ether and interact with the Bitwords platform.
183  *
184  * TODO:
185  *  - timelock all chargeAdvertiser requests
186  *  - if suicide is called, then all timelocked requests need to be stopped and then later reversed
187  */
188 contract Bitwords is Migratable {
189     mapping(address => uint) public advertiserBalances;
190 
191     // This mapping overrides the default bitwords cut for a specific publisher.
192     mapping(address => uint) public bitwordsCutOverride;
193 
194     // The bitwords address, where all the 30% cut is received ETH
195     address public bitwordsWithdrawlAddress;
196 
197     // How much cut out of 100 Bitwords takes. By default 10%
198     uint public bitwordsCutOutof100 = 10;
199 
200     // To store the advertiserChargeRequests
201     // TODO: this needs to be used for the timelock
202     struct advertiserChargeRequest {
203         address advertiser;
204         address publisher;
205         uint amount;
206         uint requestedAt;
207         uint processAfter;
208     }
209 
210     // How much days should each refund request be timelocked for
211     uint public refundRequestTimelock = 7 days;
212 
213     // To store refund request
214     struct refundRequest {
215         address advertiser;
216         uint amount;
217         uint requestedAt;
218         uint processAfter;
219     }
220 
221     // An array of all the refund requests submitted by advertisers.
222     refundRequest[] public refundQueue;
223 
224     // variables that help track where in the refund loop we are in.
225     mapping(address => uint) private advertiserRefundRequestsIndex;
226     uint private lastProccessedIndex = 0;
227 
228 
229     /**
230      * @dev The Bitwords constructor sets the address where all the withdrawals will
231      * happen.
232      */
233     constructor () public {
234         bitwordsWithdrawlAddress = msg.sender;
235     }
236 
237     /**
238      * Anybody who deposits ether to the smart contract will be considered as an
239      * advertiser and will get that much ether debitted into his account.
240      */
241     function() public payable {
242         advertiserBalances[msg.sender] += msg.value;
243         emit Deposit(msg.sender, msg.value, advertiserBalances[msg.sender]);
244     }
245 
246     /**
247      * Used by the owner to set the withdrawal address for Bitwords. This address
248      * is where Bitwords will receive all the cut from the advertisements.
249      *
250      * @param newAddress    the new withdrawal address
251      */
252     function setBitwordsWithdrawlAddress (address newAddress) hasNotSuicided onlyOwner public {
253         bitwordsWithdrawlAddress = newAddress;
254 
255         emit BitwordsWithdrawlAddressChanged(msg.sender, newAddress);
256     }
257 
258     /**
259      * Change the cut that Bitwords takes.
260      *
261      * @param cut   the amount of cut that Bitwords takes.
262      */
263     function setBitwordsCut (uint cut) hasNotSuicided onlyOwner public {
264         require(cut <= 30, "cut cannot be more than 30%");
265         require(cut >= 0, "cut should be greater than 0%");
266         bitwordsCutOutof100 = cut;
267 
268         emit BitwordsCutChanged(msg.sender, cut);
269     }
270 
271     /**
272      * Set the new timelock for refund reuqests
273      *
274      * @param newTimelock   the new timelock
275      */
276     function setRefundTimelock (uint newTimelock) hasNotSuicided onlyOwner public {
277         require(newTimelock >= 0, "timelock has to be greater than 0");
278         refundRequestTimelock = newTimelock;
279 
280         emit TimelockChanged(msg.sender, newTimelock);
281     }
282 
283     /**
284      * Process all the refund requests in the queue. This is called by the Bitwords
285      * server ideally right after chargeAdvertisers has been called.
286      *
287      * This function will only process refunds that have passed it's timelock and
288      * it will only refund maximum to how much the advertiser currently has in
289      * his balance.
290      */
291     bool private inProcessRefunds = false;
292     function processRefunds () onlyAnyOwners public {
293         // prevent reentry bug
294         require(!inProcessRefunds, "prevent reentry bug");
295         inProcessRefunds = true;
296 
297         for (uint j = lastProccessedIndex; j < refundQueue.length; j++) {
298             // If we haven't passed the timelock for this refund request, then
299             // we stop the loop. Reaching here means that all the requests
300             // in next iterations have also not reached their timelocks.
301             if (refundQueue[j].processAfter > now) break;
302 
303             // Find the minimum that needs to be withdrawn. This is important
304             // because since every call to chargeAdvertisers might update the
305             // advertiser's balance, it is possible that the amount that the
306             // advertiser requests for is small.
307             uint cappedAmount = refundQueue[j].amount;
308             if (advertiserBalances[refundQueue[j].advertiser] < cappedAmount)
309                 cappedAmount = advertiserBalances[refundQueue[j].advertiser];
310 
311             // This refund is now invalid, skip it
312             if (cappedAmount <= 0) {
313                 lastProccessedIndex++;
314                 continue;
315             }
316 
317             // deduct advertiser's balance and send the ether
318             advertiserBalances[refundQueue[j].advertiser] -= cappedAmount;
319             refundQueue[j].advertiser.transfer(cappedAmount);
320             refundQueue[j].amount = 0;
321 
322             // Emit events
323             emit RefundAdvertiserProcessed(refundQueue[j].advertiser, cappedAmount, advertiserBalances[refundQueue[j].advertiser]);
324 
325             // Increment the last proccessed index, effectively marking this
326             // refund request as completed.
327             lastProccessedIndex++;
328         }
329 
330         inProcessRefunds = false;
331     }
332 
333     /**
334      * Anybody can credit ether on behalf of an advertiser
335      *
336      * @param advertiser    The advertiser to credit ether to
337      */
338     function creditAdvertiser (address advertiser) hasNotSuicided public payable {
339         advertiserBalances[advertiser] += msg.value;
340         emit Deposit(advertiser, msg.value, advertiserBalances[msg.sender]);
341     }
342 
343     /**
344      * Anybody can credit ether on behalf of an advertiser
345      *
346      * @param publisher    The address of the publisher
347      * @param cut          How much cut should be taken from this publisher
348      */
349     function setPublisherCut (address publisher, uint cut) hasNotSuicided onlyOwner public {
350         require(cut <= 30, "cut cannot be more than 30%");
351         require(cut >= 0, "cut should be greater than 0%");
352 
353         bitwordsCutOverride[publisher] = cut;
354         emit SetPublisherCut(publisher, cut);
355     }
356 
357     /**
358      * Charge the advertiser with whatever clicks have been served by the ad engine.
359      *
360      * @param advertisers           Array of address of the advertiser from whom we should debit ether
361      * @param costs                 Array of the cost to be paid to publisher by advertisers
362      * @param publishers            Array of address of the publisher from whom we should credit ether
363      * @param publishersToCredit    Array of indices of publishers that need to be credited than debited.
364      */
365     bool private inChargeAdvertisers = false;
366     function chargeAdvertisers (address[] advertisers, uint[] costs, address[] publishers, uint[] publishersToCredit) hasNotSuicided onlyOwner public {
367         // Prevent re-entry bug
368         require(!inChargeAdvertisers, "avoid rentry bug");
369         inChargeAdvertisers = true;
370 
371         uint creditArrayIndex = 0;
372 
373         for (uint i = 0; i < advertisers.length; i++) {
374             uint toWithdraw = costs[i];
375 
376             // First check if all advertisers have enough balance and cap it if needed
377             if (advertiserBalances[advertisers[i]] <= 0) {
378                 emit InsufficientBalance(advertisers[i], advertiserBalances[advertisers[i]], costs[i]);
379                 continue;
380             }
381             if (advertiserBalances[advertisers[i]] < toWithdraw) toWithdraw = advertiserBalances[advertisers[i]];
382 
383             // Update the advertiser's balance
384             advertiserBalances[advertisers[i]] -= toWithdraw;
385             emit DeductFromAdvertiser(advertisers[i], toWithdraw, advertiserBalances[advertisers[i]]);
386 
387             // Calculate how much cut Bitwords should take
388             uint bitwordsCut = bitwordsCutOutof100;
389             if (bitwordsCutOverride[publishers[i]] > 0 && bitwordsCutOverride[publishers[i]] <= 30) {
390                 bitwordsCut = bitwordsCutOverride[publishers[i]];
391             }
392 
393             // Figure out how much should go to Bitwords and to the publishers.
394             uint publisherNetCut = toWithdraw * (100 - bitwordsCut) / 100;
395             uint bitwordsNetCut = toWithdraw - publisherNetCut;
396 
397             // Send the ether to the publisher and to Bitwords
398             // Either decide to credit the ether as an advertiser
399             if (publishersToCredit.length > creditArrayIndex && publishersToCredit[creditArrayIndex] == i) {
400                 creditArrayIndex++;
401                 advertiserBalances[publishers[i]] += publisherNetCut;
402                 emit CreditPublisher(publishers[i], publisherNetCut, advertisers[i], advertiserBalances[publishers[i]]);
403             } else { // or send it to the publisher.
404                 publishers[i].transfer(publisherNetCut);
405                 emit PayoutToPublisher(publishers[i], publisherNetCut, advertisers[i]);
406             }
407 
408             // send bitwords it's cut
409             bitwordsWithdrawlAddress.transfer(bitwordsNetCut);
410             emit PayoutToBitwords(bitwordsWithdrawlAddress, bitwordsNetCut, advertisers[i]);
411         }
412 
413         inChargeAdvertisers = false;
414     }
415 
416     /**
417      * Called by Bitwords to manually refund an advertiser.
418      *
419      * @param advertiser    The advertiser address to be refunded
420      * @param amount        The amount the advertiser would like to withdraw
421      */
422     bool private inRefundAdvertiser = false;
423     function refundAdvertiser (address advertiser, uint amount) onlyAnyOwners public {
424         // Ensure that the advertiser has enough balance to refund the smart
425         // contract
426         require(amount > 0, "Amount should be greater than 0");
427         require(advertiserBalances[advertiser] > 0, "Advertiser has no balance");
428         require(advertiserBalances[advertiser] >= amount, "Insufficient balance to refund");
429 
430         // Prevent re-entry bug
431         require(!inRefundAdvertiser, "avoid rentry bug");
432         inRefundAdvertiser = true;
433 
434         // deduct balance and send the ether
435         advertiserBalances[advertiser] -= amount;
436         advertiser.transfer(amount);
437 
438         // Emit events
439         emit RefundAdvertiserProcessed(advertiser, amount, advertiserBalances[advertiser]);
440 
441         inRefundAdvertiser = false;
442     }
443 
444     /**
445      * Called by Bitwords to invalidate a refund sent by an advertiser.
446      */
447     function invalidateAdvertiserRefund (uint refundIndex) hasNotSuicided onlyOwner public {
448         require(refundIndex >= 0, "index should be greater than 0");
449         require(refundQueue.length >=  refundIndex, "index is out of bounds");
450         refundQueue[refundIndex].amount = 0;
451 
452         emit RefundAdvertiserCancelled(refundQueue[refundIndex].advertiser);
453     }
454 
455     /**
456      * Called by an advertiser when he/she would like to make a refund request.
457      *
458      * @param amount    The amount the advertiser would like to withdraw
459      */
460     function requestForRefund (uint amount) public {
461         // Make sure that advertisers are requesting a refund for how much ever
462         // ether they have.
463         require(amount > 0, "Amount should be greater than 0");
464         require(advertiserBalances[msg.sender] > 0, "You have no balance");
465         require(advertiserBalances[msg.sender] >= amount, "Insufficient balance to refund");
466 
467         // push the refund request in a refundQueue so that it can be processed
468         // later.
469         refundQueue.push(refundRequest(msg.sender, amount, now, now + refundRequestTimelock));
470 
471         // Add the index into a hashmap for later use
472         advertiserRefundRequestsIndex[msg.sender] = refundQueue.length - 1;
473 
474         // Emit events
475         emit RefundAdvertiserRequested(msg.sender, amount, refundQueue.length - 1);
476     }
477 
478     /**
479      * Called by an advertiser when he/she wants to manually process a refund
480      * that he/she has requested for earlier.
481      *
482      * This function will first find a refund request, check if it's valid (as
483      * in, has it passed it's timelock?, is there enough balance? etc.) and
484      * then process it, updating the advertiser's balance along the way.
485      */
486     mapping(address => bool) private inProcessMyRefund;
487     function processMyRefund () public {
488         // Check if a refund request even exists for this advertiser?
489         require(advertiserRefundRequestsIndex[msg.sender] >= 0, "no refund request found");
490 
491         // Get the refund request details
492         uint refundRequestIndex = advertiserRefundRequestsIndex[msg.sender];
493 
494         // Check if the refund has been proccessed
495         require(refundQueue[refundRequestIndex].amount > 0, "refund already proccessed");
496 
497         // Check if the advertiser has enough balance to request for this refund?
498         require(
499             advertiserBalances[msg.sender] >= refundQueue[refundRequestIndex].amount,
500             "advertiser balance is low; refund amount is invalid."
501         );
502 
503         // Check the timelock
504         require(
505             now > refundQueue[refundRequestIndex].processAfter,
506             "timelock for this request has not passed"
507         );
508 
509         // Prevent reentry bug
510         require(!inProcessMyRefund[msg.sender], "prevent re-entry bug");
511         inProcessMyRefund[msg.sender] = true;
512 
513         // Send the amount
514         uint amount = refundQueue[refundRequestIndex].amount;
515         msg.sender.transfer(amount);
516 
517         // update the new balance and void this request.
518         refundQueue[refundRequestIndex].amount = 0;
519         advertiserBalances[msg.sender] -= amount;
520 
521         // reset the reentry flag
522         inProcessMyRefund[msg.sender] = false;
523 
524         // Emit events
525         emit SelfRefundAdvertiser(msg.sender, amount, advertiserBalances[msg.sender]);
526         emit RefundAdvertiserProcessed(msg.sender, amount, advertiserBalances[msg.sender]);
527     }
528 
529     /** Events */
530     event BitwordsCutChanged(address indexed _to, uint _value);
531     event BitwordsWithdrawlAddressChanged(address indexed _to, address indexed _from);
532     event CreditPublisher(address indexed _to, uint _value, address indexed _from, uint _newBalance);
533     event DeductFromAdvertiser(address indexed _to, uint _value, uint _newBalance);
534     event Deposit(address indexed _to, uint _value, uint _newBalance);
535     event InsufficientBalance(address indexed _to, uint _balance, uint _valueToDeduct);
536     event PayoutToBitwords(address indexed _to, uint _value, address indexed _from);
537     event PayoutToPublisher(address indexed _to, uint _value, address indexed _from);
538     event RefundAdvertiserCancelled(address indexed _to);
539     event RefundAdvertiserProcessed(address indexed _to, uint _value, uint _newBalance);
540     event RefundAdvertiserRequested(address indexed _to, uint _value, uint requestIndex);
541     event SelfRefundAdvertiser(address indexed _to, uint _value, uint _newBalance);
542     event SetPublisherCut(address indexed _to, uint _value);
543     event TimelockChanged(address indexed _to, uint _value);
544 }