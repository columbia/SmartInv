1 pragma solidity ^0.4.11;
2 
3 // ==== DISCLAIMER ====
4 //
5 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
6 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
7 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
8 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
9 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
10 //
11 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
12 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
13 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
14 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
15 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
16 // ====
17 //
18 
19 /// @author Santiment LLC
20 /// @title  Subscription Module for SAN - santiment token
21 
22 contract Base {
23 
24     function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
25     function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
26 
27     modifier only(address allowed) {
28         if (msg.sender != allowed) throw;
29         _;
30     }
31 
32 
33     ///@return True if `_addr` is a contract
34     function isContract(address _addr) constant internal returns (bool) {
35         if (_addr == 0) return false;
36         uint size;
37         assembly {
38             size := extcodesize(_addr)
39         }
40         return (size > 0);
41     }
42 
43     // *************************************************
44     // *          reentrancy handling                  *
45     // *************************************************
46 
47     //@dev predefined locks (up to uint bit length, i.e. 256 possible)
48     uint constant internal L00 = 2 ** 0;
49     uint constant internal L01 = 2 ** 1;
50     uint constant internal L02 = 2 ** 2;
51     uint constant internal L03 = 2 ** 3;
52     uint constant internal L04 = 2 ** 4;
53     uint constant internal L05 = 2 ** 5;
54 
55     //prevents reentrancy attacs: specific locks
56     uint private bitlocks = 0;
57     modifier noReentrancy(uint m) {
58         var _locks = bitlocks;
59         if (_locks & m > 0) throw;
60         bitlocks |= m;
61         _;
62         bitlocks = _locks;
63     }
64 
65     modifier noAnyReentrancy {
66         var _locks = bitlocks;
67         if (_locks > 0) throw;
68         bitlocks = uint(-1);
69         _;
70         bitlocks = _locks;
71     }
72 
73     ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
74     ///     developer should make the caller function reentrant-safe if it use a reentrant function.
75     modifier reentrant { _; }
76 
77 }
78 
79 contract Owned is Base {
80 
81     address public owner;
82     address public newOwner;
83 
84     function Owned() {
85         owner = msg.sender;
86     }
87 
88     function transferOwnership(address _newOwner) only(owner) {
89         newOwner = _newOwner;
90     }
91 
92     function acceptOwnership() only(newOwner) {
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95     }
96 
97     event OwnershipTransferred(address indexed _from, address indexed _to);
98 
99 }
100 
101 
102 contract ERC20 is Owned {
103 
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
106 
107     function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
108         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
109             balances[msg.sender] -= _value;
110             balances[_to] += _value;
111             Transfer(msg.sender, _to, _value);
112             return true;
113         } else { return false; }
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
117         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
118             balances[_to] += _value;
119             balances[_from] -= _value;
120             allowed[_from][msg.sender] -= _value;
121             Transfer(_from, _to, _value);
122             return true;
123         } else { return false; }
124     }
125 
126     function balanceOf(address _owner) constant returns (uint256 balance) {
127         return balances[_owner];
128     }
129 
130     function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
137         return allowed[_owner][_spender];
138     }
139 
140     mapping (address => uint256) balances;
141     mapping (address => mapping (address => uint256)) allowed;
142 
143     uint256 public totalSupply;
144     bool    public isStarted = false;
145 
146     modifier onlyHolder(address holder) {
147         if (balanceOf(holder) == 0) throw;
148         _;
149     }
150 
151     modifier isStartedOnly() {
152         if (!isStarted) throw;
153         _;
154     }
155 
156 }
157 
158 //Decision made.
159 // 1 - Provider is solely responsible to consider failed sub charge as an error and stop the service,
160 //    therefore there is no separate error state or counter for that in this Token Contract.
161 //
162 // 2 - A call originated from the user (isContract(msg.sender)==false) should throw an exception on error,
163 //     but it should return "false" on error if called from other contract (isContract(msg.sender)==true).
164 //     Reason: thrown exception are easier to see in wallets, returned boolean values are easier to evaluate in the code of the calling contract.
165 //
166 // 3 - Service providers are responsible for firing events in case of offer changes;
167 //     it is theirs decision to inform DApps about offer changes or not.
168 //
169 
170 
171 ///@dev an base class to implement by Service Provider contract to be notified about subscription changes (in-Tx notification).
172 ///     Additionally it contains standard events to be fired by service provider on offer changes.
173 ///     see alse EVM events logged by subscription module.
174 //
175 contract ServiceProvider {
176 
177     ///@dev get human readable descriptor (or url) for this Service provider
178     //
179     function info() constant public returns(string);
180 
181     ///@dev called to post-approve/reject incoming single payment.
182     ///@return `false` causes an exception and reverts the payment.
183     //
184     function onPayment(address _from, uint _value, bytes _paymentData) public returns (bool);
185 
186     ///@dev called to post-approve/reject subscription charge.
187     ///@return `false` causes an exception and reverts the operation.
188     //
189     function onSubExecuted(uint subId) public returns (bool);
190 
191     ///@dev called to post-approve/reject a creation of the subscription.
192     ///@return `false` causes an exception and reverts the operation.
193     //
194     function onSubNew(uint newSubId, uint offerId) public returns (bool);
195 
196     ///@dev called to notify service provider about subscription cancellation.
197     ///     Provider is not able to prevent the cancellation.
198     ///@return <<reserved for future implementation>>
199     //
200     function onSubCanceled(uint subId, address caller) public returns (bool);
201 
202     ///@dev called to notify service provider about subscription got hold/unhold.
203     ///@return `false` causes an exception and reverts the operation.
204     //
205     function onSubUnHold(uint subId, address caller, bool isOnHold) public returns (bool);
206 
207 
208     ///@dev following events should be used by ServiceProvider contract to notify DApps about offer changes.
209     ///     SubscriptionModule do not this notification and expects it from Service Provider if desired.
210     ///
211     ///@dev to be fired by ServiceProvider on new Offer created in a platform.
212     event OfferCreated(uint offerId,  bytes descriptor, address provider);
213 
214     ///@dev to be fired by ServiceProvider on Offer updated.
215     event OfferUpdated(uint offerId,  bytes descriptor, uint oldExecCounter, address provider);
216 
217     ///@dev to be fired by ServiceProvider on Offer canceled.
218     event OfferCanceled(uint offerId, bytes descriptor, address provider);
219 
220     ///@dev to be fired by ServiceProvider on Offer hold/unhold status changed.
221     event OfferUnHold(uint offerId,   bytes descriptor, bool isOnHoldNow, address provider);
222 } //ServiceProvider
223 
224 ///@notice XRateProvider is an external service providing an exchange rate from external currency to SAN token.
225 /// it used for subscriptions priced in other currency than SAN (even calculated and paid formally in SAN).
226 /// if non-default XRateProvider is set for some subscription, then the amount in SAN for every periodic payment
227 /// will be recalculated using provided exchange rate.
228 ///
229 /// Please note, that the exchange rate fraction is (uint32,uint32) number. It should be enough to express
230 /// any real exchange rate volatility. Nevertheless you are advised to avoid too big numbers in the fraction.
231 /// Possiibly you could implement the ratio of multiple token per SAN in order to keep the average ratio around 1:1.
232 ///
233 /// The default XRateProvider (with id==0) defines exchange rate 1:1 and represents exchange rate of SAN token to itself.
234 /// this provider is set by defalult and thus the subscription becomes nominated in SAN.
235 //
236 contract XRateProvider {
237 
238     //@dev returns current exchange rate (in form of a simple fraction) from other currency to SAN (f.e. ETH:SAN).
239     //@dev fraction numbers are restricted to uint16 to prevent overflow in calculations;
240     function getRate() public returns (uint32 /*nominator*/, uint32 /*denominator*/);
241 
242     //@dev provides a code for another currency, f.e. "ETH" or "USD"
243     function getCode() public returns (string);
244 }
245 
246 
247 //@dev data structure for SubscriptionModule
248 contract SubscriptionBase {
249 
250     enum SubState   {NOT_EXIST, BEFORE_START, PAID, CHARGEABLE, ON_HOLD, CANCELED, EXPIRED, FINALIZED}
251     enum OfferState {NOT_EXIST, BEFORE_START, ACTIVE, SOLD_OUT, ON_HOLD, EXPIRED}
252 
253     string[] internal SUB_STATES   = ["NOT_EXIST", "BEFORE_START", "PAID", "CHARGEABLE", "ON_HOLD", "CANCELED", "EXPIRED", "FINALIZED" ];
254     string[] internal OFFER_STATES = ["NOT_EXIST", "BEFORE_START", "ACTIVE", "SOLD_OUT", "ON_HOLD", "EXPIRED"];
255 
256     //@dev subscription and subscription offer use the same structure. Offer is technically a template for subscription.
257     struct Subscription {
258         address transferFrom;   // customer (unset in subscription offer)
259         address transferTo;     // service provider
260         uint pricePerHour;      // price in SAN per hour (possibly recalculated using exchange rate)
261         uint32 initialXrate_n;  // nominator
262         uint32 initialXrate_d;  // denominator
263         uint16 xrateProviderId; // id of a registered exchange rate provider
264         uint paidUntil;         // subscription is paid until time
265         uint chargePeriod;      // subscription can't be charged more often than this period
266         uint depositAmount;     // upfront deposit on creating subscription (possibly recalculated using exchange rate)
267 
268         uint startOn;           // for offer: can't be accepted before  <startOn> ; for subscription: can't be charged before <startOn>
269         uint expireOn;          // for offer: can't be accepted after  <expireOn> ; for subscription: can't be charged after  <expireOn>
270         uint execCounter;       // for offer: max num of subscriptions available  ; for subscription: num of charges made.
271         bytes descriptor;       // subscription payload (subject): evaluated by service provider.
272         uint onHoldSince;       // subscription: on-hold since time or 0 if not onHold. offer: unused: //ToDo: to be implemented
273     }
274 
275     struct Deposit {
276         uint value;         // value on deposit
277         address owner;      // usually a customer
278         bytes descriptor;   // service related descriptor to be evaluated by service provider
279     }
280 
281     event NewSubscription(address customer, address service, uint offerId, uint subId);
282     event NewDeposit(uint depositId, uint value, address sender);
283     event NewXRateProvider(address addr, uint16 xRateProviderId, address sender);
284     event DepositReturned(uint depositId, address returnedTo);
285     event SubscriptionDepositReturned(uint subId, uint amount, address returnedTo, address sender);
286     event OfferOnHold(uint offerId, bool onHold, address sender);
287     event OfferCanceled(uint offerId, address sender);
288     event SubOnHold(uint offerId, bool onHold, address sender);
289     event SubCanceled(uint subId, address sender);
290 
291 }
292 
293 ///@dev an Interface for SubscriptionModule.
294 ///     extracted here for better overview.
295 ///     see detailed documentation in implementation module.
296 contract SubscriptionModule is SubscriptionBase, Base {
297 
298     ///@dev ***** module configuration *****
299     function attachToken(address token) public;
300 
301     ///@dev ***** single payment handling *****
302     function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public reentrant returns (bool success);
303     function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public reentrant returns (bool success);
304 
305     ///@dev ***** subscription handling *****
306     ///@dev some functions are marked as reentrant, even theirs implementation is marked with noReentrancy(LOCK).
307     ///     This is intentionally because these noReentrancy(LOCK) restrictions can be lifted in the future.
308     //      Functions would become reentrant.
309     function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public reentrant returns (uint newSubId);
310     function cancelSubscription(uint subId) reentrant public;
311     function cancelSubscription(uint subId, uint gasReserve) reentrant public;
312     function holdSubscription(uint subId) public reentrant returns (bool success);
313     function unholdSubscription(uint subId) public reentrant returns (bool success);
314     function executeSubscription(uint subId) public reentrant returns (bool success);
315     function postponeDueDate(uint subId, uint newDueDate) public returns (bool success);
316     function returnSubscriptionDesposit(uint subId) public;
317     function claimSubscriptionDeposit(uint subId) public;
318     function state(uint subId) public constant returns(string state);
319     function stateCode(uint subId) public constant returns(uint stateCode);
320 
321     ///@dev ***** subscription offer handling *****
322     function createSubscriptionOffer(uint _price, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositValue, uint _startOn, bytes _descriptor) public reentrant returns (uint subId);
323     function updateSubscriptionOffer(uint offerId, uint _offerLimit) public;
324     function holdSubscriptionOffer(uint offerId) public returns (bool success);
325     function unholdSubscriptionOffer(uint offerId) public returns (bool success);
326     function cancelSubscriptionOffer(uint offerId) public returns (bool);
327 
328     ///@dev ***** simple deposit handling *****
329     function createDeposit(uint _value, bytes _descriptor) public returns (uint subId);
330     function claimDeposit(uint depositId) public;
331 
332     ///@dev ***** ExchangeRate provider *****
333     function registerXRateProvider(XRateProvider addr) public returns (uint16 xrateProviderId);
334 
335     ///@dev ***** Service provider (payment receiver) *****
336     function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public;
337     function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public;
338 
339 
340     ///@dev ***** convenience subscription getter *****
341     function subscriptionDetails(uint subId) public constant returns(
342         address transferFrom,
343         address transferTo,
344         uint pricePerHour,
345         uint32 initialXrate_n, //nominator
346         uint32 initialXrate_d, //denominator
347         uint16 xrateProviderId,
348         uint chargePeriod,
349         uint startOn,
350         bytes descriptor
351     );
352 
353     function subscriptionStatus(uint subId) public constant returns(
354         uint depositAmount,
355         uint expireOn,
356         uint execCounter,
357         uint paidUntil,
358         uint onHoldSince
359     );
360 
361     enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
362     event Payment(address _from, address _to, uint _value, uint _fee, address sender, PaymentStatus status, uint subId);
363     event ServiceProviderEnabled(address addr, bytes moreInfo);
364     event ServiceProviderDisabled(address addr, bytes moreInfo);
365 
366 } //SubscriptionModule
367 
368 contract ERC20ModuleSupport {
369     function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender) public returns(bool success);
370     function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender) public returns (bool success);
371     function _mintFromDeposit(address owner, uint amount) public;
372     function _burnForDeposit(address owner, uint amount) public returns(bool success);
373 }
374 
375 //@dev implementation
376 contract SubscriptionModuleImpl is SubscriptionModule, Owned  {
377 
378     string public constant VERSION = "0.1.0";
379 
380     // *************************************************
381     // *              contract states                  *
382     // *************************************************
383 
384     ///@dev list of all registered service provider contracts implemented as a map for better lookup.
385     mapping (address=>bool) public providerRegistry;
386 
387     ///@dev all subscriptions and offers (incl. FINALIZED).
388     mapping (uint => Subscription) public subscriptions;
389 
390     ///@dev all active simple deposits gived by depositId.
391     mapping (uint => Deposit) public deposits;
392 
393     ///@dev addresses of registered exchange rate providers.
394     XRateProvider[] public xrateProviders;
395 
396     ///@dev ongoing counter for subscription ids starting from 1.
397     ///     Current value represents an id of last created subscription.
398     uint public subscriptionCounter = 0;
399 
400     ///@dev ongoing counter for simple deposit ids starting from 1.
401     ///     Current value represents an id of last created deposit.
402     uint public depositCounter = 0;
403 
404     ///@dev Token contract with ERC20ModuleSupport addon.
405     ///     Subscription Module operates on its balances via ERC20ModuleSupport interface as trusted module.
406     ERC20ModuleSupport public san;
407 
408 
409 
410     // *************************************************
411     // *     reject all ether sent to this contract    *
412     // *************************************************
413     function () {
414         throw;
415     }
416 
417 
418 
419     // *************************************************
420     // *            setup and configuration            *
421     // *************************************************
422 
423     ///@dev constructor
424     function SubscriptionModuleImpl() {
425         owner = msg.sender;
426         xrateProviders.push(XRateProvider(this)); //this is a default SAN:SAN (1:1) provider with default id == 0
427     }
428 
429 
430     ///@dev attach SAN token to work with; can be done only once.
431     function attachToken(address token) public {
432         assert(address(san) == 0); //only in new deployed state
433         san = ERC20ModuleSupport(token);
434     }
435 
436 
437     ///@dev register a new service provider to the platform.
438     function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public only(owner) {
439         providerRegistry[addr] = true;
440         ServiceProviderEnabled(addr, moreInfo);
441     }
442 
443 
444     ///@dev de-register the service provider with given `addr`.
445     function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public only(owner) {
446         delete providerRegistry[addr];
447         ServiceProviderDisabled(addr, moreInfo);
448     }
449 
450 
451     ///@dev register new exchange rate provider.
452     ///     XRateProvider can't be de-registered, because they could be still in use by some subscription.
453     function registerXRateProvider(XRateProvider addr) public only(owner) returns (uint16 xrateProviderId) {
454         xrateProviderId = uint16(xrateProviders.length);
455         xrateProviders.push(addr);
456         NewXRateProvider(addr, xrateProviderId, msg.sender);
457     }
458 
459 
460     ///@dev xrateProviders length accessor.
461     function getXRateProviderLength() public constant returns (uint) {
462         return xrateProviders.length;
463     }
464 
465 
466     // *************************************************
467     // *           single payment methods              *
468     // *************************************************
469 
470     ///@notice makes single payment to service provider.
471     ///@param _value - amount of SAN token to sent
472     ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
473     ///@param _to - service provider contract
474     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
475     //
476     function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public reentrant returns (bool success) {
477         if (san._fulfillPayment(msg.sender, _to, _value, 0, msg.sender)) {
478             // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
479             assert (ServiceProvider(_to).onPayment(msg.sender, _value, _paymentData));                      // <=== possible reentrancy
480             return true;
481         }
482         if (isContract(msg.sender)) { return false; }
483         else { throw; }
484     }
485 
486 
487     ///@notice makes single preapproved payment to service provider. An amount must be already preapproved by payment sender to recepient.
488     ///@param _value - amount of SAN token to sent
489     ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
490     ///@param _from - sender of the payment (other than msg.sender)
491     ///@param _to - service provider contract
492     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
493     //
494     function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public reentrant returns (bool success) {
495         if (san._fulfillPreapprovedPayment(_from, _to, _value, msg.sender)) {
496             // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
497             assert (ServiceProvider(_to).onPayment(_from, _value, _paymentData));                           // <=== possible reentrancy
498             return true;
499         }
500         if (isContract(msg.sender)) { return false; }
501         else { throw; }
502     }
503 
504 
505     // *************************************************
506     // *            subscription handling              *
507     // *************************************************
508 
509     ///@dev convenience getter for some subscription fields
510     function subscriptionDetails(uint subId) public constant returns (
511         address transferFrom,
512         address transferTo,
513         uint pricePerHour,
514         uint32 initialXrate_n, //nominator
515         uint32 initialXrate_d, //denominator
516         uint16 xrateProviderId,
517         uint chargePeriod,
518         uint startOn,
519         bytes descriptor
520     ) {
521         Subscription sub = subscriptions[subId];
522         return (sub.transferFrom, sub.transferTo, sub.pricePerHour, sub.initialXrate_n, sub.initialXrate_d, sub.xrateProviderId, sub.chargePeriod, sub.startOn, sub.descriptor);
523     }
524 
525 
526     ///@dev convenience getter for some subscription fields
527     ///     a caller must know, that the subscription with given id exists, because all these fields can be 0 even the subscription with given id exists.
528     function subscriptionStatus(uint subId) public constant returns(
529         uint depositAmount,
530         uint expireOn,
531         uint execCounter,
532         uint paidUntil,
533         uint onHoldSince
534     ) {
535         Subscription sub = subscriptions[subId];
536         return (sub.depositAmount, sub.expireOn, sub.execCounter, sub.paidUntil, sub.onHoldSince);
537     }
538 
539 
540     ///@notice execute periodic subscription payment.
541     ///        Any of customer, service provider and platform owner can execute this function.
542     ///        This ensures, that the subscription charge doesn't become delayed.
543     ///        At least the platform owner has an incentive to get fee and thus can trigger the function.
544     ///        An execution fails if subscription is not in status `CHARGEABLE`.
545     ///@param subId - subscription to be charged.
546     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
547     //
548     function executeSubscription(uint subId) public noReentrancy(L00) returns (bool) {
549         Subscription storage sub = subscriptions[subId];
550         assert (msg.sender == sub.transferFrom || msg.sender == sub.transferTo || msg.sender == owner);
551         if (_subscriptionState(sub)==SubState.CHARGEABLE) {
552             var _from = sub.transferFrom;
553             var _to = sub.transferTo;
554             var _value = _amountToCharge(sub);
555             if (san._fulfillPayment(_from, _to, _value, subId, msg.sender)) {
556                 sub.paidUntil  = max(sub.paidUntil, sub.startOn) + sub.chargePeriod;
557                 ++sub.execCounter;
558                 // a ServiceProvider (a ServiceProvider) has here an opportunity to verify and reject the payment
559                 assert (ServiceProvider(_to).onSubExecuted(subId));
560                 return true;
561             }
562         }
563         if (isContract(msg.sender)) { return false; }
564         else { throw; }
565     }
566 
567 
568     ///@notice move `paidUntil` forward to given `newDueDate`. It waives payments for given time.
569     ///        This function can be used by service provider to `give away` some service time for free.
570     ///@param subId - id of subscription to be postponed.
571     ///@param newDueDate - new `paidUntil` datetime; require `newDueDate > paidUntil`.
572     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
573     //
574     function postponeDueDate(uint subId, uint newDueDate) public returns (bool success){
575         Subscription storage sub = subscriptions[subId];
576         assert (_isSubscription(sub));
577         assert (sub.transferTo == msg.sender); //only Service Provider is allowed to postpone the DueDate
578         if (sub.paidUntil < newDueDate) {
579             sub.paidUntil = newDueDate;
580             return true;
581         } else if (isContract(msg.sender)) { return false; }
582           else { throw; }
583     }
584 
585 
586     ///@dev return current status as a name of a subscription (or an offer) with given id;
587     function state(uint subOrOfferId) public constant returns(string state) {
588         Subscription subOrOffer = subscriptions[subOrOfferId];
589         return _isOffer(subOrOffer)
590               ? OFFER_STATES[uint(_offerState(subOrOffer))]
591               : SUB_STATES[uint(_subscriptionState(subOrOffer))];
592     }
593 
594 
595     ///@dev return current status as a code of a subscription (or an offer) with given id;
596     function stateCode(uint subOrOfferId) public constant returns(uint stateCode) {
597         Subscription subOrOffer = subscriptions[subOrOfferId];
598         return _isOffer(subOrOffer)
599               ? uint(_offerState(subOrOffer))
600               : uint(_subscriptionState(subOrOffer));
601     }
602 
603 
604     function _offerState(Subscription storage sub) internal constant returns(OfferState status) {
605         if (!_isOffer(sub)) {
606             return OfferState.NOT_EXIST;
607         } else if (sub.startOn > now) {
608             return OfferState.BEFORE_START;
609         } else if (sub.onHoldSince > 0) {
610             return OfferState.ON_HOLD;
611         } else if (now <= sub.expireOn) {
612             return sub.execCounter > 0
613                 ? OfferState.ACTIVE
614                 : OfferState.SOLD_OUT;
615         } else {
616             return OfferState.EXPIRED;
617         }
618     }
619 
620     function _subscriptionState(Subscription storage sub) internal constant returns(SubState status) {
621         if (!_isSubscription(sub)) {
622             return SubState.NOT_EXIST;
623         } else if (sub.startOn > now) {
624             return SubState.BEFORE_START;
625         } else if (sub.onHoldSince > 0) {
626             return SubState.ON_HOLD;
627         } else if (sub.paidUntil >= sub.expireOn) {
628             return now < sub.expireOn
629                 ? SubState.CANCELED
630                 : sub.depositAmount > 0
631                     ? SubState.EXPIRED
632                     : SubState.FINALIZED;
633         } else if (sub.paidUntil <= now) {
634             return SubState.CHARGEABLE;
635         } else {
636             return SubState.PAID;
637         }
638     }
639 
640 
641     ///@notice create a new subscription offer.
642     ///@dev only registered service provider is allowed to create offers.
643     ///@dev subscription uses SAN token for payment, but an exact amount to be paid or deposit is calculated using exchange rate from external xrateProvider (previosly registered on platform).
644     ///    This allows to create a subscription bound to another token or even fiat currency.
645     ///@param _pricePerHour - subscription price per hour in SAN
646     ///@param _xrateProviderId - id of external exchange rate provider from subscription currency to SAN; "0" means subscription is priced in SAN natively.
647     ///@param _chargePeriod - time period to charge; subscription can't be charged more often than this period. Time units are native ethereum time, returning by `now`, i.e. seconds.
648     ///@param _expireOn - offer can't be accepted after this time.
649     ///@param _offerLimit - how many subscription are available to created from this offer; there is no magic number for unlimited offer -- use big number instead.
650     ///@param _depositAmount - upfront deposit required for creating a subscription; this deposit becomes fully returned on subscription is over.
651     ///       currently this deposit is not subject of platform fees and will be refunded in full. Next versions of this module can use deposit in case of outstanding payments.
652     ///@param _startOn - a subscription from this offer can't be created before this time. Time units are native ethereum time, returning by `now`, i.e. seconds.
653     ///@param _descriptor - arbitrary bytes as an offer descriptor. This descriptor is copied into subscription and then service provider becomes it passed in notifications.
654     //
655     function createSubscriptionOffer(uint _pricePerHour, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositAmount, uint _startOn, bytes _descriptor)
656     public
657     noReentrancy(L01)
658     onlyRegisteredProvider
659     returns (uint subId) {
660         assert (_startOn < _expireOn);
661         assert (_chargePeriod <= 10 years); //sanity check
662         var (_xrate_n, _xrate_d) = _xrateProviderId == 0
663                                  ? (1,1)
664                                  : XRateProvider(xrateProviders[_xrateProviderId]).getRate(); // <=== possible reentrancy
665         assert (_xrate_n > 0 && _xrate_d > 0);
666         subscriptions[++subscriptionCounter] = Subscription ({
667             transferFrom    : 0,                  // empty transferFrom field means we have an offer, not a subscription
668             transferTo      : msg.sender,         // service provider is a beneficiary of subscripton payments
669             pricePerHour    : _pricePerHour,      // price per hour in SAN (recalculated from base currency if needed)
670             xrateProviderId : _xrateProviderId,   // id of registered exchange rate provider or zero if an offer is nominated in SAN.
671             initialXrate_n  : _xrate_n,           // fraction nominator of the initial exchange rate
672             initialXrate_d  : _xrate_d,           // fraction denominator of the initial exchange rate
673             paidUntil       : 0,                  // service is considered to be paid until this time; no charge is possible while subscription is paid for now.
674             chargePeriod    : _chargePeriod,      // period in seconds (ethereum block time unit) to charge.
675             depositAmount   : _depositAmount,     // deposit required for subscription accept.
676             startOn         : _startOn,
677             expireOn        : _expireOn,
678             execCounter     : _offerLimit,
679             descriptor      : _descriptor,
680             onHoldSince     : 0                   // offer is not on hold by default.
681         });
682         return subscriptionCounter;               // returns an id of the new offer.
683     }
684 
685 
686     ///@notice updates currently available number of subscription for this offer.
687     ///        Other offer's parameter can't be updated because they are considered to be a public offer reviewed by customers.
688     ///        The service provider should recreate the offer as a new one in case of other changes.
689     //
690     function updateSubscriptionOffer(uint _offerId, uint _offerLimit) public {
691         Subscription storage offer = subscriptions[_offerId];
692         assert (_isOffer(offer));
693         assert (offer.transferTo == msg.sender); //only Provider is allowed to update the offer.
694         offer.execCounter = _offerLimit;
695     }
696 
697 
698     ///@notice accept given offer and create a new subscription on the base of it.
699     ///
700     ///@dev the service provider (offer.`transferTo`) becomes notified about new subscription by call `onSubNew(newSubId, _offerId)`.
701     ///     It is provider's responsibility to retrieve and store any necessary information about offer and this new subscription. Some of info is only available at this point.
702     ///     The Service Provider can also reject the new subscription by throwing an exception or returning `false` from `onSubNew(newSubId, _offerId)` event handler.
703     ///@param _offerId   - id of the offer to be accepted
704     ///@param _expireOn  - subscription expiration time; no charges are possible behind this time.
705     ///@param _startOn   - subscription start time; no charges are possible before this time.
706     ///                    If the `_startOn` is in the past or is zero, it means start the subscription ASAP.
707     //
708     function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public noReentrancy(L02) returns (uint newSubId) {
709         assert (_startOn < _expireOn);
710         Subscription storage offer = subscriptions[_offerId];
711         assert (_isOffer(offer));
712         assert (offer.startOn == 0     || offer.startOn  <= now);
713         assert (offer.expireOn == 0    || offer.expireOn >= now);
714         assert (offer.onHoldSince == 0);
715         assert (offer.execCounter > 0);
716         --offer.execCounter;
717         newSubId = ++subscriptionCounter;
718         //create a clone of the offer...
719         Subscription storage newSub = subscriptions[newSubId] = offer;
720         //... and adjust some fields specific to subscription
721         newSub.transferFrom = msg.sender;
722         newSub.execCounter = 0;
723         newSub.paidUntil = newSub.startOn = max(_startOn, now);     //no debts before actual creation time!
724         newSub.expireOn = _expireOn;
725         newSub.depositAmount = _applyXchangeRate(newSub.depositAmount, newSub);                    // <=== possible reentrancy
726         //depositAmount is now stored in the sub, so burn the same amount from customer's account.
727         assert (san._burnForDeposit(msg.sender, newSub.depositAmount));
728         assert (ServiceProvider(newSub.transferTo).onSubNew(newSubId, _offerId));                  // <=== possible reentrancy; service provider can still reject the new subscription here
729 
730         NewSubscription(newSub.transferFrom, newSub.transferTo, _offerId, newSubId);
731         return newSubId;
732     }
733 
734 
735     ///@notice cancel an offer given by `offerId`.
736     ///@dev sets offer.`expireOn` to `expireOn`.
737     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
738     //
739     function cancelSubscriptionOffer(uint offerId) public returns (bool) {
740         Subscription storage offer = subscriptions[offerId];
741         assert (_isOffer(offer));
742         assert (offer.transferTo == msg.sender || owner == msg.sender); //only service provider or platform owner is allowed to cancel the offer
743         if (offer.expireOn>now){
744             offer.expireOn = now;
745             OfferCanceled(offerId, msg.sender);
746             return true;
747         }
748         if (isContract(msg.sender)) { return false; }
749         else { throw; }
750     }
751 
752 
753     ///@notice cancel an subscription given by `subId` (a graceful version).
754     ///@notice IMPORTANT: a malicious service provider can consume all gas and preventing subscription from cancellation.
755     ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
756     ///         see `cancelSubscription(uint subId, uint gasReserve)` for more documentation.
757     //
758     function cancelSubscription(uint subId) public {
759         return cancelSubscription(subId, 0);
760     }
761 
762 
763     ///@notice cancel an subscription given by `subId` (a forced version).
764     ///        Cancellation means no further charges to this subscription are possible. The provided subscription deposit can be withdrawn only `paidUntil` period is over.
765     ///        Depending on nature of the service provided, the service provider can allow an immediate deposit withdrawal by `returnSubscriptionDesposit(uint subId)` call, but its on his own.
766     ///        In some business cases a deposit must remain locked until `paidUntil` period is over even, the subscription is already canceled.
767     ///@notice gasReserve is a gas amount reserved for contract execution AFTER service provider becomes `onSubCanceled(uint256,address)` notification.
768     ///        It guarantees, that cancellation becomes executed even a (malicious) service provider consumes all gas provided.
769     ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
770     ///        This difference is because the customer must always have a possibility to cancel his contract even the service provider disagree on cancellation.
771     ///@param subId - subscription to be cancelled
772     ///@param gasReserve - gas reserved for call finalization (minimum reservation is 10000 gas)
773     //
774     function cancelSubscription(uint subId, uint gasReserve) public noReentrancy(L03) {
775         Subscription storage sub = subscriptions[subId];
776         assert (sub.transferFrom == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to cancel it
777         assert (_isSubscription(sub));
778         var _to = sub.transferTo;
779         sub.expireOn = max(now, sub.paidUntil);
780         if (msg.sender != _to) {
781             //supress re-throwing of exceptions; reserve enough gas to finish this function
782             gasReserve = max(gasReserve,10000);  //reserve minimum 10000 gas
783             assert (msg.gas > gasReserve);       //sanity check
784             if (_to.call.gas(msg.gas-gasReserve)(bytes4(sha3("onSubCanceled(uint256,address)")), subId, msg.sender)) {     // <=== possible reentrancy
785                 //do nothing. it is notification only.
786                 //Later: is it possible to evaluate return value here? If is better to return the subscription deposit here.
787             }
788         }
789         SubCanceled(subId, msg.sender);
790     }
791 
792 
793     ///@notice place an active offer on hold; it means no subscriptions can be created from this offer.
794     ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
795     ///@param offerId - id of the offer to be placed on hold.
796     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
797     //
798     function holdSubscriptionOffer(uint offerId) public returns (bool success) {
799         Subscription storage offer = subscriptions[offerId];
800         assert (_isOffer(offer));
801         require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can place the offer on hold.
802         if (offer.onHoldSince == 0) {
803             offer.onHoldSince = now;
804             OfferOnHold(offerId, true, msg.sender);
805             return true;
806         }
807         if (isContract(msg.sender)) { return false; }
808         else { throw; }
809     }
810 
811 
812     ///@notice resume on-hold offer; subscriptions can be created from this offer again (if other conditions are met).
813     ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
814     ///@param offerId - id of the offer to be resumed.
815     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
816     //
817     function unholdSubscriptionOffer(uint offerId) public returns (bool success) {
818         Subscription storage offer = subscriptions[offerId];
819         assert (_isOffer(offer));
820         require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can reactivate the offer.
821         if (offer.onHoldSince > 0) {
822             offer.onHoldSince = 0;
823             OfferOnHold(offerId, false, msg.sender);
824             return true;
825         }
826         if (isContract(msg.sender)) { return false; }
827         else { throw; }
828     }
829 
830 
831     ///@notice called by customer or service provider to place a subscription on hold.
832     ///        If call is originated by customer the service provider can reject the request.
833     ///        A subscription on hold will not be charged. The service is usually not provided as well.
834     ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
835     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
836     //
837     function holdSubscription(uint subId) public noReentrancy(L04) returns (bool success) {
838         Subscription storage sub = subscriptions[subId];
839         assert (_isSubscription(sub));
840         var _to = sub.transferTo;
841         require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
842         if (sub.onHoldSince == 0) {
843             if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, true)) {          // <=== possible reentrancy
844                 sub.onHoldSince = now;
845                 SubOnHold(subId, true, msg.sender);
846                 return true;
847             }
848         }
849         if (isContract(msg.sender)) { return false; }
850         else { throw; }
851     }
852 
853 
854     ///@notice called by customer or service provider to unhold subscription.
855     ///        If call is originated by customer the service provider can reject the request.
856     ///        A subscription on hold will not be charged. The service is usually not provided as well.
857     ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
858     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
859     //
860     function unholdSubscription(uint subId) public noReentrancy(L05) returns (bool success) {
861         Subscription storage sub = subscriptions[subId];
862         assert (_isSubscription(sub));
863         var _to = sub.transferTo;
864         require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
865         if (sub.onHoldSince > 0) {
866             if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, false)) {         // <=== possible reentrancy
867                 sub.paidUntil += now - sub.onHoldSince;
868                 sub.onHoldSince = 0;
869                 SubOnHold(subId, false, msg.sender);
870                 return true;
871             }
872         }
873         if (isContract(msg.sender)) { return false; }
874         else { throw; }
875     }
876 
877 
878 
879     // *************************************************
880     // *              deposit handling                 *
881     // *************************************************
882 
883     ///@notice can be called by provider on CANCELED subscription to return a subscription deposit to customer immediately.
884     ///        Customer can anyway collect his deposit after `paidUntil` period is over.
885     ///@param subId - subscription holding the deposit
886     //
887     function returnSubscriptionDesposit(uint subId) public {
888         Subscription storage sub = subscriptions[subId];
889         assert (_subscriptionState(sub) == SubState.CANCELED);
890         assert (sub.depositAmount > 0); //sanity check
891         assert (sub.transferTo == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to release deposit.
892         sub.expireOn = now;
893         _returnSubscriptionDesposit(subId, sub);
894     }
895 
896 
897     ///@notice called by customer on EXPIRED subscription (`paidUntil` period is over) to collect a subscription deposit.
898     ///        Customer can anyway collect his deposit after `paidUntil` period is over.
899     ///@param subId - subscription holding the deposit
900     //
901     function claimSubscriptionDeposit(uint subId) public {
902         Subscription storage sub = subscriptions[subId];
903         assert (_subscriptionState(sub) == SubState.EXPIRED);
904         assert (sub.transferFrom == msg.sender);
905         assert (sub.depositAmount > 0);
906         _returnSubscriptionDesposit(subId, sub);
907     }
908 
909 
910     //@dev returns subscription deposit to customer
911     function _returnSubscriptionDesposit(uint subId, Subscription storage sub) internal {
912         uint depositAmount = sub.depositAmount;
913         sub.depositAmount = 0;
914         san._mintFromDeposit(sub.transferFrom, depositAmount);
915         SubscriptionDepositReturned(subId, depositAmount, sub.transferFrom, msg.sender);
916     }
917 
918 
919     ///@notice create simple unlocked deposit, required by some services. It can be considered as prove of customer's stake.
920     ///        This desposit can be claimed back by the customer at anytime.
921     ///        The service provider is responsible to check the deposit before providing the service.
922     ///@param _value - non zero deposit amount.
923     ///@param _descriptor - is a uniq key, usually given by service provider to the customer in order to make this deposit unique.
924     ///        Service Provider should reject deposit with unknown descriptor, because most probably it is in use for some another service.
925     ///@return depositId - a handle to claim back the deposit later.
926     //
927     function createDeposit(uint _value, bytes _descriptor) public returns (uint depositId) {
928         require (_value > 0);
929         assert (san._burnForDeposit(msg.sender,_value));
930         deposits[++depositCounter] = Deposit ({
931             owner : msg.sender,
932             value : _value,
933             descriptor : _descriptor
934         });
935         NewDeposit(depositCounter, _value, msg.sender);
936         return depositCounter;
937     }
938 
939 
940     ///@notice return previously created deposit to the user. User can collect only own deposit.
941     ///        The service provider is responsible to check the deposit before providing the service.
942     ///@param _depositId - an id of the deposit to be collected.
943     //
944     function claimDeposit(uint _depositId) public {
945         var deposit = deposits[_depositId];
946         require (deposit.owner == msg.sender);
947         var value = deposits[_depositId].value;
948         delete deposits[_depositId];
949         san._mintFromDeposit(msg.sender, value);
950         DepositReturned(_depositId, msg.sender);
951     }
952 
953 
954 
955     // *************************************************
956     // *            some internal functions            *
957     // *************************************************
958 
959     function _amountToCharge(Subscription storage sub) internal reentrant returns (uint) {
960         return _applyXchangeRate(sub.pricePerHour * sub.chargePeriod, sub) / 1 hours;       // <==== reentrant function usage
961     }
962 
963     function _applyXchangeRate(uint amount, Subscription storage sub) internal reentrant returns (uint) {  // <== actually called from reentrancy guarded context only (i.e. externally secured)
964         if (sub.xrateProviderId > 0) {
965             // xrate_n: nominator
966             // xrate_d: denominator of the exchange rate fraction.
967             var (xrate_n, xrate_d) = XRateProvider(xrateProviders[sub.xrateProviderId]).getRate();        // <=== possible reentrancy
968             amount = amount * sub.initialXrate_n * xrate_d / sub.initialXrate_d / xrate_n;
969         }
970         return amount;
971     }
972 
973     function _isOffer(Subscription storage sub) internal constant returns (bool){
974         return sub.transferFrom == 0 && sub.transferTo != 0;
975     }
976 
977     function _isSubscription(Subscription storage sub) internal constant returns (bool){
978         return sub.transferFrom != 0 && sub.transferTo != 0;
979     }
980 
981     function _exists(Subscription storage sub) internal constant returns (bool){
982         return sub.transferTo != 0;   //existing subscription or offer has always transferTo set.
983     }
984 
985     modifier onlyRegisteredProvider(){
986         if (!providerRegistry[msg.sender]) throw;
987         _;
988     }
989 
990 } //SubscriptionModuleImpl