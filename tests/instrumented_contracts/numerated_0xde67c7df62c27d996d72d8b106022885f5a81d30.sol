1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Utils/Math.sol
4 
5 library MathUtils {
6     function add(uint a, uint b) internal pure returns (uint) {
7         uint result = a + b;
8 
9         if (a == 0 || b == 0) {
10             return result;
11         }
12 
13         require(result > a && result > b);
14 
15         return result;
16     }
17 
18     function sub(uint a, uint b) internal pure returns (uint) {
19         require(a >= b);
20 
21         return a - b;
22     }
23 
24     function mul(uint a, uint b) internal pure returns (uint) {
25         if (a == 0 || b == 0) {
26             return 0;
27         }
28 
29         uint result = a * b;
30 
31         require(result / a == b);
32 
33         return result;
34     }
35 }
36 
37 // File: contracts/Utils/Ownable.sol
38 
39 contract Ownable {
40     address public owner;
41 
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     function isOwner() view public returns (bool) {
47         return msg.sender == owner;
48     }
49 
50     modifier grantOwner {
51         require(isOwner());
52         _;
53     }
54 }
55 
56 // File: contracts/Crowdsale/CrowdsaleToken.sol
57 
58 interface CrowdsaleToken {
59     function transfer(address destination, uint amount) external returns (bool);
60     function balanceOf(address account) external view returns (uint);
61     function burn(uint amount) external;
62 }
63 
64 // File: contracts/Crowdsale/CryptoPoliceCrowdsale.sol
65 
66 contract CryptoPoliceCrowdsale is Ownable {
67     using MathUtils for uint;
68     
69     enum CrowdsaleState {
70         Pending, Started, Ended, Paused, SoldOut
71     }
72 
73     struct ExchangeRate {
74         uint tokens;
75         uint price;
76     }
77 
78     struct Participant {
79         bool identified;
80         uint processedDirectWeiAmount;
81         uint processedExternalWeiAmount;
82         uint suspendedDirectWeiAmount;
83         uint suspendedExternalWeiAmount;
84     }
85 
86     event ExternalPaymentReminder(uint weiAmount, bytes32 paymentChecksum);
87     event PaymentSuspended(address participant);
88     event PaymentProcessed(uint weiAmount, address participant, bytes32 paymentChecksum, uint tokenAmount);
89 
90     uint public constant THRESHOLD1 = 270000000e18;
91     uint public constant THRESHOLD2 = 350000000e18;
92     uint public constant THRESHOLD3 = 490000000e18;
93     uint public constant THRESHOLD4 = 510000000e18;
94 
95     uint public constant RELEASE_THRESHOLD = 11111111e18;
96 
97     address public admin;
98 
99     /**
100      * Amount of tokens sold in this crowdsale
101      */
102     uint public tokensSold;
103 
104     /**
105      * Minimum number of Wei that can be exchanged for tokens
106      */
107     uint public minSale = 0.01 ether;
108     
109     /**
110      * Amount of direct Wei paid to the contract that has not yet been processed
111      */
112     uint public suspendedPayments = 0;
113 
114     /**
115      * Token that will be sold
116      */
117     CrowdsaleToken public token;
118     
119     /**
120      * State in which the crowdsale is in
121      */
122     CrowdsaleState public state = CrowdsaleState.Pending;
123 
124     /**
125      * List of exchange rates for each token volume
126      */
127     ExchangeRate[4] public exchangeRates;
128     
129     bool public crowdsaleEndedSuccessfully = false;
130 
131     /**
132      * Number of Wei that can be paid without carrying out KYC process
133      */
134     uint public unidentifiedSaleLimit = 1.45 ether;
135 
136     /**
137      * Crowdsale participants that have made payments
138      */
139     mapping(address => Participant) public participants;
140 
141     /**
142      * Map external payment reference hash to that payment description
143      */
144     mapping(bytes32 => string) public externalPaymentDescriptions;
145 
146     /**
147      * Map participants to list of their external payment reference hashes
148      */
149     mapping(address => bytes32[]) public participantExternalPaymentChecksums;
150 
151     mapping(address => bytes32[]) public participantSuspendedExternalPaymentChecksums;
152 
153     /**
154      * Map external payment checksum to payment amount
155      */
156     mapping(bytes32 => uint) public suspendedExternalPayments;
157 
158     mapping(address => bool) public bannedParticipants;
159 
160     bool public revertSuspendedPayment = false;
161 
162     /**
163      * 1) Process payment when crowdsale started by sending tokens in return
164      * 2) Issue a refund when crowdsale ended unsuccessfully 
165      */
166     function () public payable {
167         if (state == CrowdsaleState.Ended) {
168             msg.sender.transfer(msg.value);
169             refundParticipant(msg.sender);
170         } else {
171             require(state == CrowdsaleState.Started, "Crowdsale currently inactive");
172             processPayment(msg.sender, msg.value, "");
173         }
174     }
175 
176     /**
177      * Recursively caluclates number of tokens that can be exchanged for given payment 
178      *
179      * @param salePosition Number of tokens processed in crowdsale so far
180      * @param _paymentReminder Number of Wei remaining from payment so far
181      * @param _processedTokenCount Number of tokens that can be exchanged so far
182      *
183      * @return paymentReminder Number of Wei remaining from payment
184      * @return processedTokenCount Number of tokens that can be exchanged
185      * @return soldOut Indicates whether or not there would be no more tokens left after this exchange
186      */
187     function exchangeCalculator(uint salePosition, uint _paymentReminder, uint _processedTokenCount)
188     internal view returns (uint paymentReminder, uint processedTokenCount, bool soldOut)
189     {
190         uint threshold = getTreshold(salePosition);
191         ExchangeRate memory currentExchangeRate = getExchangeRate(threshold);
192 
193         // how many round number of portions are left for exchange
194         uint availablePortions = (threshold - salePosition) / currentExchangeRate.tokens;
195 
196         // this indicates that there are no leftover tokens that can be exchanged
197         // without stepping over threshold
198         if (availablePortions == 0) {
199             if (threshold == THRESHOLD4) {
200                 return (_paymentReminder, _processedTokenCount, true);
201             }
202             // move sale position to current threshold
203             return exchangeCalculator(threshold, _paymentReminder, _processedTokenCount);
204         }
205 
206         uint requestedPortions = _paymentReminder / currentExchangeRate.price;
207         uint portions = requestedPortions > availablePortions ? availablePortions : requestedPortions;
208         uint newProcessedTokenCount = _processedTokenCount + portions * currentExchangeRate.tokens;
209         uint newPaymentReminder = _paymentReminder - portions * currentExchangeRate.price;
210         uint newSalePosition = salePosition + newProcessedTokenCount;
211 
212         if (newPaymentReminder < currentExchangeRate.price) {
213             return (newPaymentReminder, newProcessedTokenCount, false);
214         }
215         
216         return exchangeCalculator(newSalePosition, newPaymentReminder, newProcessedTokenCount);
217     }
218 
219     function processPayment(address participant, uint payment, bytes32 externalPaymentChecksum) internal {
220         require(payment >= minSale, "Payment must be greather or equal to sale minimum");
221         require(bannedParticipants[participant] == false, "Participant is banned");
222 
223         uint paymentReminder;
224         uint processedTokenCount;
225         bool soldOut;
226 
227         (paymentReminder, processedTokenCount, soldOut) = exchangeCalculator(tokensSold, payment, 0);
228 
229         // how much was actually spent from this payment
230         uint spent = payment - paymentReminder;
231         bool directPayment = externalPaymentChecksum == "";
232 
233         if (participants[participant].identified == false) {
234             // how much participant has spent in crowdsale so far
235             uint spendings = participants[participant].processedDirectWeiAmount
236                 .add(participants[participant].processedExternalWeiAmount).add(spent);
237 
238             bool hasSuspendedPayments = participants[participant].suspendedDirectWeiAmount > 0 || participants[participant].suspendedExternalWeiAmount > 0;
239 
240             // due to fluctuations of unidentified payment limit, it might not be reached
241             // suspend current payment if participant currently has suspended payments or limit reached
242             if (hasSuspendedPayments || spendings > unidentifiedSaleLimit) {
243                 require(revertSuspendedPayment == false, "Participant does not comply with KYC");
244 
245                 suspendedPayments = suspendedPayments + payment;
246 
247                 if (directPayment) {
248                     participants[participant].suspendedDirectWeiAmount = participants[participant].suspendedDirectWeiAmount.add(payment);
249                 } else {
250                     participantSuspendedExternalPaymentChecksums[participant].push(externalPaymentChecksum);
251                     participants[participant].suspendedExternalWeiAmount = participants[participant].suspendedExternalWeiAmount.add(payment);
252                     suspendedExternalPayments[externalPaymentChecksum] = payment;
253                 }
254 
255                 emit PaymentSuspended(participant);
256 
257                 return;
258             }
259         }
260 
261         // unspent reminder must be returned back to participant
262         if (paymentReminder > 0) {
263             if (directPayment) {
264                 participant.transfer(paymentReminder);
265             } else {
266                 emit ExternalPaymentReminder(paymentReminder, externalPaymentChecksum);
267             }
268         }
269 
270         if (directPayment) {
271             participants[participant].processedDirectWeiAmount = participants[participant].processedDirectWeiAmount.add(spent);
272         } else {
273             participants[participant].processedExternalWeiAmount = participants[participant].processedExternalWeiAmount.add(spent);
274         }
275 
276         require(token.transfer(participant, processedTokenCount), "Failed to transfer tokens");
277         
278         if (soldOut) {
279             state = CrowdsaleState.SoldOut;
280         }
281         
282         tokensSold = tokensSold + processedTokenCount;
283 
284         emit PaymentProcessed(spent, participant, externalPaymentChecksum, processedTokenCount);
285     }
286 
287     /**
288      * Intended when other currencies are received and owner has to carry out exchange
289      * for those payments aligned to Wei
290      */
291     function proxyExchange(address beneficiary, uint payment, string description, bytes32 checksum)
292     public grantOwnerOrAdmin
293     {
294         require(beneficiary != address(0), "Beneficiary not specified");
295         require(bytes(description).length > 0, "Description not specified");
296         require(checksum.length > 0, "Checksum not specified");
297         // make sure that payment has not been processed yet
298         require(bytes(externalPaymentDescriptions[checksum]).length == 0, "Payment already processed");
299 
300         processPayment(beneficiary, payment, checksum);
301         
302         externalPaymentDescriptions[checksum] = description;
303         participantExternalPaymentChecksums[beneficiary].push(checksum);
304     }
305 
306     /**
307      * Command for owner to start crowdsale
308      */
309     function startCrowdsale(address crowdsaleToken, address adminAddress) public grantOwner {
310         require(state == CrowdsaleState.Pending);
311         setAdmin(adminAddress);
312         token = CrowdsaleToken(crowdsaleToken);
313         require(token.balanceOf(address(this)) == 510000000e18);
314         state = CrowdsaleState.Started;
315     }
316 
317     function pauseCrowdsale() public grantOwnerOrAdmin {
318         require(state == CrowdsaleState.Started);
319         state = CrowdsaleState.Paused;
320     }
321 
322     function unPauseCrowdsale() public grantOwnerOrAdmin {
323         require(state == CrowdsaleState.Paused);
324         state = CrowdsaleState.Started;
325     }
326 
327     /**
328      * Command for owner to end crowdsale
329      */
330     function endCrowdsale(bool success) public grantOwner notEnded {
331         state = CrowdsaleState.Ended;
332         crowdsaleEndedSuccessfully = success;
333 
334         uint balance = address(this).balance;
335 
336         if (success && balance > 0) {
337             uint amount = balance.sub(suspendedPayments);
338             owner.transfer(amount);
339         }
340     }
341 
342     function markParticipantIdentifiend(address participant) public grantOwnerOrAdmin notEnded {
343         participants[participant].identified = true;
344 
345         if (participants[participant].suspendedDirectWeiAmount > 0) {
346             processPayment(participant, participants[participant].suspendedDirectWeiAmount, "");
347             suspendedPayments = suspendedPayments.sub(participants[participant].suspendedDirectWeiAmount);
348             participants[participant].suspendedDirectWeiAmount = 0;
349         }
350 
351         if (participants[participant].suspendedExternalWeiAmount > 0) {
352             bytes32[] storage checksums = participantSuspendedExternalPaymentChecksums[participant];
353             for (uint i = 0; i < checksums.length; i++) {
354                 processPayment(participant, suspendedExternalPayments[checksums[i]], checksums[i]);
355                 suspendedExternalPayments[checksums[i]] = 0;
356             }
357             participants[participant].suspendedExternalWeiAmount = 0;
358             participantSuspendedExternalPaymentChecksums[participant] = new bytes32[](0);
359         }
360     }
361 
362     function unidentifyParticipant(address participant) public grantOwnerOrAdmin notEnded {
363         participants[participant].identified = false;
364     }
365 
366     function returnSuspendedPayments(address participant) public grantOwnerOrAdmin {
367         returnDirectPayments(participant, false, true);
368         returnExternalPayments(participant, false, true);
369     }
370 
371     function updateUnidentifiedSaleLimit(uint limit) public grantOwnerOrAdmin notEnded {
372         unidentifiedSaleLimit = limit;
373     }
374 
375     function updateMinSale(uint weiAmount) public grantOwnerOrAdmin {
376         minSale = weiAmount;
377     }
378 
379     /**
380      * Allow crowdsale participant to get refunded
381      */
382     function refundParticipant(address participant) internal {
383         require(state == CrowdsaleState.Ended);
384         require(crowdsaleEndedSuccessfully == false);
385         
386         returnDirectPayments(participant, true, true);
387         returnExternalPayments(participant, true, true);
388     }
389 
390     function refund(address participant) public grantOwner {
391         refundParticipant(participant);
392     }
393 
394     function burnLeftoverTokens(uint8 percentage) public grantOwner {
395         require(state == CrowdsaleState.Ended);
396         require(percentage <= 100 && percentage > 0);
397 
398         uint balance = token.balanceOf(address(this));
399 
400         if (balance > 0) {
401             uint amount = balance / (100 / percentage);
402             token.burn(amount);
403         }
404     }
405 
406     function updateExchangeRate(uint8 idx, uint tokens, uint price) public grantOwnerOrAdmin {
407         require(tokens > 0 && price > 0);
408         require(idx >= 0 && idx <= 3);
409 
410         exchangeRates[idx] = ExchangeRate({
411             tokens: tokens,
412             price: price
413         });
414     }
415 
416     function ban(address participant) public grantOwnerOrAdmin {
417         bannedParticipants[participant] = true;
418     }
419 
420     function unBan(address participant) public grantOwnerOrAdmin {
421         bannedParticipants[participant] = false;
422     }
423 
424     function getExchangeRate(uint threshold) internal view returns (ExchangeRate) {
425         uint8 idx = exchangeRateIdx(threshold);
426 
427         ExchangeRate storage rate = exchangeRates[idx];
428 
429         require(rate.tokens > 0 && rate.price > 0, "Exchange rate not set");
430 
431         return rate;
432     }
433 
434     function getTreshold(uint salePosition) internal pure returns (uint) {
435         if (salePosition < THRESHOLD1) {
436             return THRESHOLD1;
437         }
438         if (salePosition < THRESHOLD2) {
439             return THRESHOLD2;
440         }
441         if (salePosition < THRESHOLD3) {
442             return THRESHOLD3;
443         }
444         if (salePosition < THRESHOLD4) {
445             return THRESHOLD4;
446         }
447 
448         assert(false);
449     }
450 
451     function exchangeRateIdx(uint threshold) internal pure returns (uint8) {
452         if (threshold == THRESHOLD1) {
453             return 0;
454         }
455         if (threshold == THRESHOLD2) {
456             return 1;
457         }
458         if (threshold == THRESHOLD3) {
459             return 2;
460         }
461         if (threshold == THRESHOLD4) {
462             return 3;
463         }
464 
465         assert(false);
466     }
467 
468     function updateRevertSuspendedPayment(bool value) public grantOwnerOrAdmin {
469         revertSuspendedPayment = value;
470     }
471 
472     /**
473      * Transfer Wei sent to the contract directly back to the participant
474      *
475      * @param participant Participant
476      * @param processed Whether or not processed payments should be included
477      * @param suspended Whether or not suspended payments should be included
478      */
479     function returnDirectPayments(address participant, bool processed, bool suspended) internal {
480         if (processed && participants[participant].processedDirectWeiAmount > 0) {
481             participant.transfer(participants[participant].processedDirectWeiAmount);
482             participants[participant].processedDirectWeiAmount = 0;
483         }
484 
485         if (suspended && participants[participant].suspendedDirectWeiAmount > 0) {
486             participant.transfer(participants[participant].suspendedDirectWeiAmount);
487             participants[participant].suspendedDirectWeiAmount = 0;
488         }
489     }
490 
491     /**
492      * Signal that externally made payments should be returned back to the participant
493      *
494      * @param participant Participant
495      * @param processed Whether or not processed payments should be included
496      * @param suspended Whether or not suspended payments should be included
497      */
498     function returnExternalPayments(address participant, bool processed, bool suspended) internal {
499         if (processed && participants[participant].processedExternalWeiAmount > 0) {
500             participants[participant].processedExternalWeiAmount = 0;
501         }
502         
503         if (suspended && participants[participant].suspendedExternalWeiAmount > 0) {
504             participants[participant].suspendedExternalWeiAmount = 0;
505         }
506     }
507 
508     function setAdmin(address adminAddress) public grantOwner {
509         admin = adminAddress;
510         require(isAdminSet());
511     }
512 
513     function transwerFunds(uint amount) public grantOwner {
514         require(RELEASE_THRESHOLD <= tokensSold, "There are not enaugh tokens sold");
515         
516         uint transferAmount = amount;
517         uint balance = address(this).balance;
518 
519         if (balance < amount) {
520             transferAmount = balance;
521         }
522 
523         owner.transfer(transferAmount);
524     } 
525 
526     function isAdminSet() internal view returns(bool) {
527         return admin != address(0);
528     }
529 
530     function isAdmin() internal view returns(bool) {
531         return isAdminSet() && msg.sender == admin;
532     }
533 
534     function isCrowdsaleSuccessful() public view returns(bool) {
535         return state == CrowdsaleState.Ended && crowdsaleEndedSuccessfully;
536     }
537 
538     modifier notEnded {
539         require(state != CrowdsaleState.Ended, "Crowdsale ended");
540         _;
541     }
542 
543     modifier grantOwnerOrAdmin() {
544         require(isOwner() || isAdmin());
545         _;
546     }
547 }