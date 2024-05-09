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
19 /// @author ethernian for Santiment LLC
20 /// @title  Subscription Module for SAN - santiment token
21 /// @notice report bugs to: bugs@ethernian.com
22 
23 contract Base {
24 
25     function max(uint a, uint b) returns (uint) { return a >= b ? a : b; }
26     function min(uint a, uint b) returns (uint) { return a <= b ? a : b; }
27 
28     modifier only(address allowed) {
29         if (msg.sender != allowed) throw;
30         _;
31     }
32 
33 
34     ///@return True if `_addr` is a contract
35     function isContract(address _addr) constant internal returns (bool) {
36         if (_addr == 0) return false;
37         uint size;
38         assembly {
39             size := extcodesize(_addr)
40         }
41         return (size > 0);
42     }
43 
44     // *************************************************
45     // *          reentrancy handling                  *
46     // *************************************************
47 
48     //@dev predefined locks (up to uint bit length, i.e. 256 possible)
49     uint constant internal L00 = 2 ** 0;
50     uint constant internal L01 = 2 ** 1;
51     uint constant internal L02 = 2 ** 2;
52     uint constant internal L03 = 2 ** 3;
53     uint constant internal L04 = 2 ** 4;
54     uint constant internal L05 = 2 ** 5;
55 
56     //prevents reentrancy attacs: specific locks
57     uint private bitlocks = 0;
58     modifier noReentrancy(uint m) {
59         var _locks = bitlocks;
60         if (_locks & m > 0) throw;
61         bitlocks |= m;
62         _;
63         bitlocks = _locks;
64     }
65 
66     modifier noAnyReentrancy {
67         var _locks = bitlocks;
68         if (_locks > 0) throw;
69         bitlocks = uint(-1);
70         _;
71         bitlocks = _locks;
72     }
73 
74     ///@dev empty marking modifier signaling to user of the marked function , that it can cause an reentrant call.
75     ///     developer should make the caller function reentrant-safe if it use a reentrant function.
76     modifier reentrant { _; }
77 
78 }
79 
80 contract Owned is Base {
81 
82     address public owner;
83     address public newOwner;
84 
85     function Owned() {
86         owner = msg.sender;
87     }
88 
89     function transferOwnership(address _newOwner) only(owner) {
90         newOwner = _newOwner;
91     }
92 
93     function acceptOwnership() only(newOwner) {
94         OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96     }
97 
98     event OwnershipTransferred(address indexed _from, address indexed _to);
99 
100 }
101 
102 
103 contract ERC20 is Owned {
104 
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
107 
108     function transfer(address _to, uint256 _value) isStartedOnly returns (bool success) {
109         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
110             balances[msg.sender] -= _value;
111             balances[_to] += _value;
112             Transfer(msg.sender, _to, _value);
113             return true;
114         } else { return false; }
115     }
116 
117     function transferFrom(address _from, address _to, uint256 _value) isStartedOnly returns (bool success) {
118         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
119             balances[_to] += _value;
120             balances[_from] -= _value;
121             allowed[_from][msg.sender] -= _value;
122             Transfer(_from, _to, _value);
123             return true;
124         } else { return false; }
125     }
126 
127     function balanceOf(address _owner) constant returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131     function approve(address _spender, uint256 _value) isStartedOnly returns (bool success) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
138         return allowed[_owner][_spender];
139     }
140 
141     mapping (address => uint256) balances;
142     mapping (address => mapping (address => uint256)) allowed;
143 
144     uint256 public totalSupply;
145     bool    public isStarted = false;
146 
147     modifier onlyHolder(address holder) {
148         if (balanceOf(holder) == 0) throw;
149         _;
150     }
151 
152     modifier isStartedOnly() {
153         if (!isStarted) throw;
154         _;
155     }
156 
157 }
158 
159 //Decision made.
160 // 1 - Provider is solely responsible to consider failed sub charge as an error and stop the service,
161 //    therefore there is no separate error state or counter for that in this Token Contract.
162 //
163 // 2 - A call originated from the user (isContract(msg.sender)==false) should throw an exception on error,
164 //     but it should return "false" on error if called from other contract (isContract(msg.sender)==true).
165 //     Reason: thrown exception are easier to see in wallets, returned boolean values are easier to evaluate in the code of the calling contract.
166 //
167 // 3 - Service providers are responsible for firing events in case of offer changes;
168 //     it is theirs decision to inform DApps about offer changes or not.
169 //
170 
171 
172 ///@dev an base class to implement by Service Provider contract to be notified about subscription changes (in-Tx notification).
173 ///     Additionally it contains standard events to be fired by service provider on offer changes.
174 ///     see alse EVM events logged by subscription module.
175 //
176 contract ServiceProvider {
177 
178     ///@dev get human readable descriptor (or url) for this Service provider
179     //
180     function info() constant public returns(string);
181 
182     ///@dev called to post-approve/reject incoming single payment.
183     ///@return `false` causes an exception and reverts the payment.
184     //
185     function onPayment(address _from, uint _value, bytes _paymentData) public returns (bool);
186 
187     ///@dev called to post-approve/reject subscription charge.
188     ///@return `false` causes an exception and reverts the operation.
189     //
190     function onSubExecuted(uint subId) public returns (bool);
191 
192     ///@dev called to post-approve/reject a creation of the subscription.
193     ///@return `false` causes an exception and reverts the operation.
194     //
195     function onSubNew(uint newSubId, uint offerId) public returns (bool);
196 
197     ///@dev called to notify service provider about subscription cancellation.
198     ///     Provider is not able to prevent the cancellation.
199     ///@return <<reserved for future implementation>>
200     //
201     function onSubCanceled(uint subId, address caller) public returns (bool);
202 
203     ///@dev called to notify service provider about subscription got hold/unhold.
204     ///@return `false` causes an exception and reverts the operation.
205     //
206     function onSubUnHold(uint subId, address caller, bool isOnHold) public returns (bool);
207 
208 
209     ///@dev following events should be used by ServiceProvider contract to notify DApps about offer changes.
210     ///     SubscriptionModule do not this notification and expects it from Service Provider if desired.
211     ///
212     ///@dev to be fired by ServiceProvider on new Offer created in a platform.
213     event OfferCreated(uint offerId,  bytes descriptor, address provider);
214 
215     ///@dev to be fired by ServiceProvider on Offer updated.
216     event OfferUpdated(uint offerId,  bytes descriptor, uint oldExecCounter, address provider);
217 
218     ///@dev to be fired by ServiceProvider on Offer canceled.
219     event OfferCanceled(uint offerId, bytes descriptor, address provider);
220 
221     ///@dev to be fired by ServiceProvider on Offer hold/unhold status changed.
222     event OfferUnHold(uint offerId,   bytes descriptor, bool isOnHoldNow, address provider);
223 } //ServiceProvider
224 
225 ///@notice XRateProvider is an external service providing an exchange rate from external currency to SAN token.
226 /// it used for subscriptions priced in other currency than SAN (even calculated and paid formally in SAN).
227 /// if non-default XRateProvider is set for some subscription, then the amount in SAN for every periodic payment
228 /// will be recalculated using provided exchange rate.
229 ///
230 /// Please note, that the exchange rate fraction is (uint32,uint32) number. It should be enough to express
231 /// any real exchange rate volatility. Nevertheless you are advised to avoid too big numbers in the fraction.
232 /// Possiibly you could implement the ratio of multiple token per SAN in order to keep the average ratio around 1:1.
233 ///
234 /// The default XRateProvider (with id==0) defines exchange rate 1:1 and represents exchange rate of SAN token to itself.
235 /// this provider is set by defalult and thus the subscription becomes nominated in SAN.
236 //
237 contract XRateProvider {
238 
239     //@dev returns current exchange rate (in form of a simple fraction) from other currency to SAN (f.e. ETH:SAN).
240     //@dev fraction numbers are restricted to uint16 to prevent overflow in calculations;
241     function getRate() public returns (uint32 /*nominator*/, uint32 /*denominator*/);
242 
243     //@dev provides a code for another currency, f.e. "ETH" or "USD"
244     function getCode() public returns (string);
245 }
246 
247 
248 //@dev data structure for SubscriptionModule
249 contract SubscriptionBase {
250 
251     enum SubState   {NOT_EXIST, BEFORE_START, PAID, CHARGEABLE, ON_HOLD, CANCELED, EXPIRED, FINALIZED}
252     enum OfferState {NOT_EXIST, BEFORE_START, ACTIVE, SOLD_OUT, ON_HOLD, EXPIRED}
253 
254     string[] internal SUB_STATES   = ["NOT_EXIST", "BEFORE_START", "PAID", "CHARGEABLE", "ON_HOLD", "CANCELED", "EXPIRED", "FINALIZED" ];
255     string[] internal OFFER_STATES = ["NOT_EXIST", "BEFORE_START", "ACTIVE", "SOLD_OUT", "ON_HOLD", "EXPIRED"];
256 
257     //@dev subscription and subscription offer use the same structure. Offer is technically a template for subscription.
258     struct Subscription {
259         address transferFrom;   // customer (unset in subscription offer)
260         address transferTo;     // service provider
261         uint pricePerHour;      // price in SAN per hour (possibly recalculated using exchange rate)
262         uint32 initialXrate_n;  // nominator
263         uint32 initialXrate_d;  // denominator
264         uint16 xrateProviderId; // id of a registered exchange rate provider
265         uint paidUntil;         // subscription is paid until time
266         uint chargePeriod;      // subscription can't be charged more often than this period
267         uint depositAmount;     // upfront deposit on creating subscription (possibly recalculated using exchange rate)
268 
269         uint startOn;           // for offer: can't be accepted before  <startOn> ; for subscription: can't be charged before <startOn>
270         uint expireOn;          // for offer: can't be accepted after  <expireOn> ; for subscription: can't be charged after  <expireOn>
271         uint execCounter;       // for offer: max num of subscriptions available  ; for subscription: num of charges made.
272         bytes descriptor;       // subscription payload (subject): evaluated by service provider.
273         uint onHoldSince;       // subscription: on-hold since time or 0 if not onHold. offer: unused: //ToDo: to be implemented
274     }
275 
276     struct Deposit {
277         uint value;         // value on deposit
278         address owner;      // usually a customer
279         uint createdOn;     // deposit created timestamp
280         uint lockTime;      // deposit locked for time period
281         bytes descriptor;   // service related descriptor to be evaluated by service provider
282     }
283 
284     event NewSubscription(address customer, address service, uint offerId, uint subId);
285     event NewDeposit(uint depositId, uint value, uint lockTime, address sender);
286     event NewXRateProvider(address addr, uint16 xRateProviderId, address sender);
287     event DepositReturned(uint depositId, address returnedTo);
288     event SubscriptionDepositReturned(uint subId, uint amount, address returnedTo, address sender);
289     event OfferOnHold(uint offerId, bool onHold, address sender);
290     event OfferCanceled(uint offerId, address sender);
291     event SubOnHold(uint offerId, bool onHold, address sender);
292     event SubCanceled(uint subId, address sender);
293     event SubModuleSuspended(uint suspendUntil);
294 
295 }
296 
297 ///@dev an Interface for SubscriptionModule.
298 ///     extracted here for better overview.
299 ///     see detailed documentation in implementation module.
300 contract SubscriptionModule is SubscriptionBase, Base {
301 
302     ///@dev ***** module configuration *****
303     function attachToken(address token) public;
304 
305     ///@dev ***** single payment handling *****
306     function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public reentrant returns (bool success);
307     function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public reentrant returns (bool success);
308 
309     ///@dev ***** subscription handling *****
310     ///@dev some functions are marked as reentrant, even theirs implementation is marked with noReentrancy(LOCK).
311     ///     This is intentionally because these noReentrancy(LOCK) restrictions can be lifted in the future.
312     //      Functions would become reentrant.
313     function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public reentrant returns (uint newSubId);
314     function cancelSubscription(uint subId) reentrant public;
315     function cancelSubscription(uint subId, uint gasReserve) reentrant public;
316     function holdSubscription(uint subId) public reentrant returns (bool success);
317     function unholdSubscription(uint subId) public reentrant returns (bool success);
318     function executeSubscription(uint subId) public reentrant returns (bool success);
319     function postponeDueDate(uint subId, uint newDueDate) public returns (bool success);
320     function returnSubscriptionDesposit(uint subId) public;
321     function claimSubscriptionDeposit(uint subId) public;
322     function state(uint subId) public constant returns(string state);
323     function stateCode(uint subId) public constant returns(uint stateCode);
324 
325     ///@dev ***** subscription offer handling *****
326     function createSubscriptionOffer(uint _price, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositValue, uint _startOn, bytes _descriptor) public reentrant returns (uint subId);
327     function updateSubscriptionOffer(uint offerId, uint _offerLimit) public;
328     function holdSubscriptionOffer(uint offerId) public returns (bool success);
329     function unholdSubscriptionOffer(uint offerId) public returns (bool success);
330     function cancelSubscriptionOffer(uint offerId) public returns (bool);
331 
332     ///@dev ***** simple deposit handling *****
333     function createDeposit(uint _value, uint lockTime, bytes _descriptor) public returns (uint subId);
334     function claimDeposit(uint depositId) public;
335 
336     ///@dev ***** ExchangeRate provider *****
337     function registerXRateProvider(XRateProvider addr) public returns (uint16 xrateProviderId);
338 
339     ///@dev ***** Service provider (payment receiver) *****
340     function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public;
341     function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public;
342 
343 
344     ///@dev ***** convenience subscription getter *****
345     function subscriptionDetails(uint subId) public constant returns(
346         address transferFrom,
347         address transferTo,
348         uint pricePerHour,
349         uint32 initialXrate_n, //nominator
350         uint32 initialXrate_d, //denominator
351         uint16 xrateProviderId,
352         uint chargePeriod,
353         uint startOn,
354         bytes descriptor
355     );
356 
357     function subscriptionStatus(uint subId) public constant returns(
358         uint depositAmount,
359         uint expireOn,
360         uint execCounter,
361         uint paidUntil,
362         uint onHoldSince
363     );
364 
365     enum PaymentStatus {OK, BALANCE_ERROR, APPROVAL_ERROR}
366     event Payment(address _from, address _to, uint _value, uint _fee, address sender, PaymentStatus status, uint subId);
367     event ServiceProviderEnabled(address addr, bytes moreInfo);
368     event ServiceProviderDisabled(address addr, bytes moreInfo);
369 
370 } //SubscriptionModule
371 
372 contract ERC20ModuleSupport {
373     function _fulfillPreapprovedPayment(address _from, address _to, uint _value, address msg_sender) public returns(bool success);
374     function _fulfillPayment(address _from, address _to, uint _value, uint subId, address msg_sender) public returns (bool success);
375     function _mintFromDeposit(address owner, uint amount) public;
376     function _burnForDeposit(address owner, uint amount) public returns(bool success);
377 }
378 
379 //@dev implementation
380 contract SubscriptionModuleImpl is SubscriptionModule, Owned  {
381 
382     string public constant VERSION = "0.2.0";
383 
384     // *************************************************
385     // *              contract states                  *
386     // *************************************************
387 
388     ///@dev suspend all module operation until this time (if in future); if the time is in past (or zero) - operates normally.
389     uint public suspendedUntil = 0;
390     function isSuspended() public constant returns(bool) { return suspendedUntil > now; }
391 
392     ///@dev list of all registered service provider contracts implemented as a map for better lookup.
393     mapping (address=>bool) public providerRegistry;
394 
395     ///@dev all subscriptions and offers (incl. FINALIZED).
396     mapping (uint => Subscription) public subscriptions;
397 
398     ///@dev all active simple deposits gived by depositId.
399     mapping (uint => Deposit) public deposits;
400 
401     ///@dev addresses of registered exchange rate providers.
402     XRateProvider[] public xrateProviders;
403 
404     ///@dev ongoing counter for subscription ids starting from 1.
405     ///     Current value represents an id of last created subscription.
406     uint public subscriptionCounter = 0;
407 
408     ///@dev ongoing counter for simple deposit ids starting from 1.
409     ///     Current value represents an id of last created deposit.
410     uint public depositCounter = 0;
411 
412     ///@dev Token contract with ERC20ModuleSupport addon.
413     ///     Subscription Module operates on its balances via ERC20ModuleSupport interface as trusted module.
414     ERC20ModuleSupport public san;
415 
416 
417 
418     // *************************************************
419     // *     reject all ether sent to this contract    *
420     // *************************************************
421     function () {
422         throw;
423     }
424 
425 
426 
427     // *************************************************
428     // *            setup and configuration            *
429     // *************************************************
430 
431     ///@dev constructor
432     function SubscriptionModuleImpl() {
433         owner = msg.sender;
434         xrateProviders.push(XRateProvider(this)); //this is a default SAN:SAN (1:1) provider with default id == 0
435     }
436 
437 
438     ///@dev attach SAN token to work with; can be done only once.
439     function attachToken(address token) public {
440         assert(address(san) == 0); //only in new deployed state
441         san = ERC20ModuleSupport(token);
442     }
443 
444 
445     ///@dev register a new service provider to the platform.
446     function enableServiceProvider(ServiceProvider addr, bytes moreInfo) public notSuspended only(owner) {
447         providerRegistry[addr] = true;
448         ServiceProviderEnabled(addr, moreInfo);
449     }
450 
451 
452     ///@dev de-register the service provider with given `addr`.
453     function disableServiceProvider(ServiceProvider addr, bytes moreInfo) public notSuspended only(owner) {
454         delete providerRegistry[addr];
455         ServiceProviderDisabled(addr, moreInfo);
456     }
457 
458     ///@dev suspend all module operations for given time.
459     function suspend(uint suspendTimeSec) public only(owner) {
460         suspendedUntil = now + suspendTimeSec;
461         SubModuleSuspended(suspendedUntil);
462     }
463 
464     ///@dev register new exchange rate provider.
465     ///     XRateProvider can't be de-registered, because they could be still in use by some subscription.
466     function registerXRateProvider(XRateProvider addr) public notSuspended only(owner) returns (uint16 xrateProviderId) {
467         xrateProviderId = uint16(xrateProviders.length);
468         xrateProviders.push(addr);
469         NewXRateProvider(addr, xrateProviderId, msg.sender);
470     }
471 
472 
473     ///@dev xrateProviders length accessor.
474     function getXRateProviderLength() public constant returns (uint) {
475         return xrateProviders.length;
476     }
477 
478 
479     // *************************************************
480     // *           single payment methods              *
481     // *************************************************
482 
483     ///@notice makes single payment to service provider.
484     ///@param _value - amount of SAN token to sent
485     ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
486     ///@param _to - service provider contract
487     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
488     //
489     function paymentTo(uint _value, bytes _paymentData, ServiceProvider _to) public notSuspended reentrant returns (bool success) {
490         if (san._fulfillPayment(msg.sender, _to, _value, 0, msg.sender)) {
491             // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
492             assert (ServiceProvider(_to).onPayment(msg.sender, _value, _paymentData));                      // <=== possible reentrancy
493             return true;
494         }
495         if (isContract(msg.sender)) { return false; }
496         else { throw; }
497     }
498 
499 
500     ///@notice makes single preapproved payment to service provider. An amount must be already preapproved by payment sender to recepient.
501     ///@param _value - amount of SAN token to sent
502     ///@param _paymentData - 'payment purpose' code usually issued by service provider to customer before payment.
503     ///@param _from - sender of the payment (other than msg.sender)
504     ///@param _to - service provider contract
505     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
506     //
507     function paymentFrom(uint _value, bytes _paymentData, address _from, ServiceProvider _to) public notSuspended reentrant returns (bool success) {
508         if (san._fulfillPreapprovedPayment(_from, _to, _value, msg.sender)) {
509             // a ServiceProvider (a ServiceProvider) has here an opportunity verify and reject the payment
510             assert (ServiceProvider(_to).onPayment(_from, _value, _paymentData));                           // <=== possible reentrancy
511             return true;
512         }
513         if (isContract(msg.sender)) { return false; }
514         else { throw; }
515     }
516 
517 
518     // *************************************************
519     // *            subscription handling              *
520     // *************************************************
521 
522     ///@dev convenience getter for some subscription fields
523     function subscriptionDetails(uint subId) public constant returns (
524         address transferFrom,
525         address transferTo,
526         uint pricePerHour,
527         uint32 initialXrate_n, //nominator
528         uint32 initialXrate_d, //denominator
529         uint16 xrateProviderId,
530         uint chargePeriod,
531         uint startOn,
532         bytes descriptor
533     ) {
534         Subscription sub = subscriptions[subId];
535         return (sub.transferFrom, sub.transferTo, sub.pricePerHour, sub.initialXrate_n, sub.initialXrate_d, sub.xrateProviderId, sub.chargePeriod, sub.startOn, sub.descriptor);
536     }
537 
538 
539     ///@dev convenience getter for some subscription fields
540     ///     a caller must know, that the subscription with given id exists, because all these fields can be 0 even the subscription with given id exists.
541     function subscriptionStatus(uint subId) public constant returns(
542         uint depositAmount,
543         uint expireOn,
544         uint execCounter,
545         uint paidUntil,
546         uint onHoldSince
547     ) {
548         Subscription sub = subscriptions[subId];
549         return (sub.depositAmount, sub.expireOn, sub.execCounter, sub.paidUntil, sub.onHoldSince);
550     }
551 
552 
553     ///@notice execute periodic subscription payment.
554     ///        Any of customer, service provider and platform owner can execute this function.
555     ///        This ensures, that the subscription charge doesn't become delayed.
556     ///        At least the platform owner has an incentive to get fee and thus can trigger the function.
557     ///        An execution fails if subscription is not in status `CHARGEABLE`.
558     ///@param subId - subscription to be charged.
559     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
560     //
561     function executeSubscription(uint subId) public notSuspended noReentrancy(L00) returns (bool) {
562         Subscription storage sub = subscriptions[subId];
563         assert (msg.sender == sub.transferFrom || msg.sender == sub.transferTo || msg.sender == owner);
564         if (_subscriptionState(sub)==SubState.CHARGEABLE) {
565             var _from = sub.transferFrom;
566             var _to = sub.transferTo;
567             var _value = _amountToCharge(sub);
568             if (san._fulfillPayment(_from, _to, _value, subId, msg.sender)) {
569                 sub.paidUntil  = max(sub.paidUntil, sub.startOn) + sub.chargePeriod;
570                 ++sub.execCounter;
571                 // a ServiceProvider (a ServiceProvider) has here an opportunity to verify and reject the payment
572                 assert (ServiceProvider(_to).onSubExecuted(subId));
573                 return true;
574             }
575         }
576         if (isContract(msg.sender)) { return false; }
577         else { throw; }
578     }
579 
580 
581     ///@notice move `paidUntil` forward to given `newDueDate`. It waives payments for given time.
582     ///        This function can be used by service provider to `give away` some service time for free.
583     ///@param subId - id of subscription to be postponed.
584     ///@param newDueDate - new `paidUntil` datetime; require `newDueDate > paidUntil`.
585     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
586     //
587     function postponeDueDate(uint subId, uint newDueDate) public notSuspended returns (bool success){
588         Subscription storage sub = subscriptions[subId];
589         assert (_isSubscription(sub));
590         assert (sub.transferTo == msg.sender); //only Service Provider is allowed to postpone the DueDate
591         if (sub.paidUntil < newDueDate) {
592             sub.paidUntil = newDueDate;
593             return true;
594         } else if (isContract(msg.sender)) { return false; }
595           else { throw; }
596     }
597 
598 
599     ///@dev return current status as a name of a subscription (or an offer) with given id;
600     function state(uint subOrOfferId) public constant returns(string state) {
601         Subscription subOrOffer = subscriptions[subOrOfferId];
602         return _isOffer(subOrOffer)
603               ? OFFER_STATES[uint(_offerState(subOrOffer))]
604               : SUB_STATES[uint(_subscriptionState(subOrOffer))];
605     }
606 
607 
608     ///@dev return current status as a code of a subscription (or an offer) with given id;
609     function stateCode(uint subOrOfferId) public constant returns(uint stateCode) {
610         Subscription subOrOffer = subscriptions[subOrOfferId];
611         return _isOffer(subOrOffer)
612               ? uint(_offerState(subOrOffer))
613               : uint(_subscriptionState(subOrOffer));
614     }
615 
616 
617     function _offerState(Subscription storage sub) internal constant returns(OfferState status) {
618         if (!_isOffer(sub)) {
619             return OfferState.NOT_EXIST;
620         } else if (sub.startOn > now) {
621             return OfferState.BEFORE_START;
622         } else if (sub.onHoldSince > 0) {
623             return OfferState.ON_HOLD;
624         } else if (now <= sub.expireOn) {
625             return sub.execCounter > 0
626                 ? OfferState.ACTIVE
627                 : OfferState.SOLD_OUT;
628         } else {
629             return OfferState.EXPIRED;
630         }
631     }
632 
633     function _subscriptionState(Subscription storage sub) internal constant returns(SubState status) {
634         if (!_isSubscription(sub)) {
635             return SubState.NOT_EXIST;
636         } else if (sub.startOn > now) {
637             return SubState.BEFORE_START;
638         } else if (sub.onHoldSince > 0) {
639             return SubState.ON_HOLD;
640         } else if (sub.paidUntil >= sub.expireOn) {
641             return now < sub.expireOn
642                 ? SubState.CANCELED
643                 : sub.depositAmount > 0
644                     ? SubState.EXPIRED
645                     : SubState.FINALIZED;
646         } else if (sub.paidUntil <= now) {
647             return SubState.CHARGEABLE;
648         } else {
649             return SubState.PAID;
650         }
651     }
652 
653 
654     ///@notice create a new subscription offer.
655     ///@dev only registered service provider is allowed to create offers.
656     ///@dev subscription uses SAN token for payment, but an exact amount to be paid or deposit is calculated using exchange rate from external xrateProvider (previosly registered on platform).
657     ///    This allows to create a subscription bound to another token or even fiat currency.
658     ///@param _pricePerHour - subscription price per hour in SAN
659     ///@param _xrateProviderId - id of external exchange rate provider from subscription currency to SAN; "0" means subscription is priced in SAN natively.
660     ///@param _chargePeriod - time period to charge; subscription can't be charged more often than this period. Time units are native ethereum time, returning by `now`, i.e. seconds.
661     ///@param _expireOn - offer can't be accepted after this time.
662     ///@param _offerLimit - how many subscription are available to created from this offer; there is no magic number for unlimited offer -- use big number instead.
663     ///@param _depositAmount - upfront deposit required for creating a subscription; this deposit becomes fully returned on subscription is over.
664     ///       currently this deposit is not subject of platform fees and will be refunded in full. Next versions of this module can use deposit in case of outstanding payments.
665     ///@param _startOn - a subscription from this offer can't be created before this time. Time units are native ethereum time, returning by `now`, i.e. seconds.
666     ///@param _descriptor - arbitrary bytes as an offer descriptor. This descriptor is copied into subscription and then service provider becomes it passed in notifications.
667     //
668     function createSubscriptionOffer(uint _pricePerHour, uint16 _xrateProviderId, uint _chargePeriod, uint _expireOn, uint _offerLimit, uint _depositAmount, uint _startOn, bytes _descriptor)
669     public
670     noReentrancy(L01)
671     onlyRegisteredProvider
672     notSuspended
673     returns (uint subId) {
674         assert (_startOn < _expireOn);
675         assert (_chargePeriod <= 10 years); //sanity check
676         var (_xrate_n, _xrate_d) = _xrateProviderId == 0
677                                  ? (1,1)
678                                  : XRateProvider(xrateProviders[_xrateProviderId]).getRate(); // <=== possible reentrancy
679         assert (_xrate_n > 0 && _xrate_d > 0);
680         subscriptions[++subscriptionCounter] = Subscription ({
681             transferFrom    : 0,                  // empty transferFrom field means we have an offer, not a subscription
682             transferTo      : msg.sender,         // service provider is a beneficiary of subscripton payments
683             pricePerHour    : _pricePerHour,      // price per hour in SAN (recalculated from base currency if needed)
684             xrateProviderId : _xrateProviderId,   // id of registered exchange rate provider or zero if an offer is nominated in SAN.
685             initialXrate_n  : _xrate_n,           // fraction nominator of the initial exchange rate
686             initialXrate_d  : _xrate_d,           // fraction denominator of the initial exchange rate
687             paidUntil       : 0,                  // service is considered to be paid until this time; no charge is possible while subscription is paid for now.
688             chargePeriod    : _chargePeriod,      // period in seconds (ethereum block time unit) to charge.
689             depositAmount   : _depositAmount,     // deposit required for subscription accept.
690             startOn         : _startOn,
691             expireOn        : _expireOn,
692             execCounter     : _offerLimit,
693             descriptor      : _descriptor,
694             onHoldSince     : 0                   // offer is not on hold by default.
695         });
696         return subscriptionCounter;               // returns an id of the new offer.
697     }
698 
699 
700     ///@notice updates currently available number of subscription for this offer.
701     ///        Other offer's parameter can't be updated because they are considered to be a public offer reviewed by customers.
702     ///        The service provider should recreate the offer as a new one in case of other changes.
703     //
704     function updateSubscriptionOffer(uint _offerId, uint _offerLimit) public notSuspended {
705         Subscription storage offer = subscriptions[_offerId];
706         assert (_isOffer(offer));
707         assert (offer.transferTo == msg.sender); //only Provider is allowed to update the offer.
708         offer.execCounter = _offerLimit;
709     }
710 
711 
712     ///@notice accept given offer and create a new subscription on the base of it.
713     ///
714     ///@dev the service provider (offer.`transferTo`) becomes notified about new subscription by call `onSubNew(newSubId, _offerId)`.
715     ///     It is provider's responsibility to retrieve and store any necessary information about offer and this new subscription. Some of info is only available at this point.
716     ///     The Service Provider can also reject the new subscription by throwing an exception or returning `false` from `onSubNew(newSubId, _offerId)` event handler.
717     ///@param _offerId   - id of the offer to be accepted
718     ///@param _expireOn  - subscription expiration time; no charges are possible behind this time.
719     ///@param _startOn   - subscription start time; no charges are possible before this time.
720     ///                    If the `_startOn` is in the past or is zero, it means start the subscription ASAP.
721     //
722     function createSubscription(uint _offerId, uint _expireOn, uint _startOn) public notSuspended noReentrancy(L02) returns (uint newSubId) {
723         assert (_startOn < _expireOn);
724         Subscription storage offer = subscriptions[_offerId];
725         assert (_isOffer(offer));
726         assert (offer.startOn == 0     || offer.startOn  <= now);
727         assert (offer.expireOn == 0    || offer.expireOn >= now);
728         assert (offer.onHoldSince == 0);
729         assert (offer.execCounter > 0);
730         --offer.execCounter;
731         newSubId = ++subscriptionCounter;
732         //create a clone of the offer...
733         Subscription storage newSub = subscriptions[newSubId] = offer;
734         //... and adjust some fields specific to subscription
735         newSub.transferFrom = msg.sender;
736         newSub.execCounter = 0;
737         newSub.paidUntil = newSub.startOn = max(_startOn, now);     //no debts before actual creation time!
738         newSub.expireOn = _expireOn;
739         newSub.depositAmount = _applyXchangeRate(newSub.depositAmount, newSub);                    // <=== possible reentrancy
740         //depositAmount is now stored in the sub, so burn the same amount from customer's account.
741         assert (san._burnForDeposit(msg.sender, newSub.depositAmount));
742         assert (ServiceProvider(newSub.transferTo).onSubNew(newSubId, _offerId));                  // <=== possible reentrancy; service provider can still reject the new subscription here
743 
744         NewSubscription(newSub.transferFrom, newSub.transferTo, _offerId, newSubId);
745         return newSubId;
746     }
747 
748 
749     ///@notice cancel an offer given by `offerId`.
750     ///@dev sets offer.`expireOn` to `expireOn`.
751     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
752     //
753     function cancelSubscriptionOffer(uint offerId) public notSuspended returns (bool) {
754         Subscription storage offer = subscriptions[offerId];
755         assert (_isOffer(offer));
756         assert (offer.transferTo == msg.sender || owner == msg.sender); //only service provider or platform owner is allowed to cancel the offer
757         if (offer.expireOn>now){
758             offer.expireOn = now;
759             OfferCanceled(offerId, msg.sender);
760             return true;
761         }
762         if (isContract(msg.sender)) { return false; }
763         else { throw; }
764     }
765 
766 
767     ///@notice cancel an subscription given by `subId` (a graceful version).
768     ///@notice IMPORTANT: a malicious service provider can consume all gas and preventing subscription from cancellation.
769     ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
770     ///         see `cancelSubscription(uint subId, uint gasReserve)` for more documentation.
771     //
772     function cancelSubscription(uint subId) public notSuspended {
773         return cancelSubscription(subId, 0);
774     }
775 
776 
777     ///@notice cancel an subscription given by `subId` (a forced version).
778     ///        Cancellation means no further charges to this subscription are possible. The provided subscription deposit can be withdrawn only `paidUntil` period is over.
779     ///        Depending on nature of the service provided, the service provider can allow an immediate deposit withdrawal by `returnSubscriptionDesposit(uint subId)` call, but its on his own.
780     ///        In some business cases a deposit must remain locked until `paidUntil` period is over even, the subscription is already canceled.
781     ///@notice gasReserve is a gas amount reserved for contract execution AFTER service provider becomes `onSubCanceled(uint256,address)` notification.
782     ///        It guarantees, that cancellation becomes executed even a (malicious) service provider consumes all gas provided.
783     ///        If so, use `cancelSubscription(uint subId, uint gasReserve)` as the forced version.
784     ///        This difference is because the customer must always have a possibility to cancel his contract even the service provider disagree on cancellation.
785     ///@param subId - subscription to be cancelled
786     ///@param gasReserve - gas reserved for call finalization (minimum reservation is 10000 gas)
787     //
788     function cancelSubscription(uint subId, uint gasReserve) public notSuspended noReentrancy(L03) {
789         Subscription storage sub = subscriptions[subId];
790         assert (sub.transferFrom == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to cancel it
791         assert (_isSubscription(sub));
792         var _to = sub.transferTo;
793         sub.expireOn = max(now, sub.paidUntil);
794         if (msg.sender != _to) {
795             //supress re-throwing of exceptions; reserve enough gas to finish this function
796             gasReserve = max(gasReserve,10000);  //reserve minimum 10000 gas
797             assert (msg.gas > gasReserve);       //sanity check
798             if (_to.call.gas(msg.gas-gasReserve)(bytes4(sha3("onSubCanceled(uint256,address)")), subId, msg.sender)) {     // <=== possible reentrancy
799                 //do nothing. it is notification only.
800                 //Later: is it possible to evaluate return value here? If is better to return the subscription deposit here.
801             }
802         }
803         SubCanceled(subId, msg.sender);
804     }
805 
806 
807     ///@notice place an active offer on hold; it means no subscriptions can be created from this offer.
808     ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
809     ///@param offerId - id of the offer to be placed on hold.
810     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
811     //
812     function holdSubscriptionOffer(uint offerId) public notSuspended returns (bool success) {
813         Subscription storage offer = subscriptions[offerId];
814         assert (_isOffer(offer));
815         require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can place the offer on hold.
816         if (offer.onHoldSince == 0) {
817             offer.onHoldSince = now;
818             OfferOnHold(offerId, true, msg.sender);
819             return true;
820         }
821         if (isContract(msg.sender)) { return false; }
822         else { throw; }
823     }
824 
825 
826     ///@notice resume on-hold offer; subscriptions can be created from this offer again (if other conditions are met).
827     ///        Only service provider (or platform owner) is allowed to hold/unhold a subscription offer.
828     ///@param offerId - id of the offer to be resumed.
829     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
830     //
831     function unholdSubscriptionOffer(uint offerId) public notSuspended returns (bool success) {
832         Subscription storage offer = subscriptions[offerId];
833         assert (_isOffer(offer));
834         require (msg.sender == offer.transferTo || msg.sender == owner); //only owner or service provider can reactivate the offer.
835         if (offer.onHoldSince > 0) {
836             offer.onHoldSince = 0;
837             OfferOnHold(offerId, false, msg.sender);
838             return true;
839         }
840         if (isContract(msg.sender)) { return false; }
841         else { throw; }
842     }
843 
844 
845     ///@notice called by customer or service provider to place a subscription on hold.
846     ///        If call is originated by customer the service provider can reject the request.
847     ///        A subscription on hold will not be charged. The service is usually not provided as well.
848     ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
849     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
850     //
851     function holdSubscription(uint subId) public notSuspended noReentrancy(L04) returns (bool success) {
852         Subscription storage sub = subscriptions[subId];
853         assert (_isSubscription(sub));
854         var _to = sub.transferTo;
855         require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
856         if (sub.onHoldSince == 0) {
857             if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, true)) {          // <=== possible reentrancy
858                 sub.onHoldSince = now;
859                 SubOnHold(subId, true, msg.sender);
860                 return true;
861             }
862         }
863         if (isContract(msg.sender)) { return false; }
864         else { throw; }
865     }
866 
867 
868     ///@notice called by customer or service provider to unhold subscription.
869     ///        If call is originated by customer the service provider can reject the request.
870     ///        A subscription on hold will not be charged. The service is usually not provided as well.
871     ///        During hold time a subscription preserve remaining paid time period, which becomes available after unhold.
872     ///@return `true` on success; `false` of failure (if caller is a contract) or throw an exception (if caller is not a contract)
873     //
874     function unholdSubscription(uint subId) public notSuspended noReentrancy(L05) returns (bool success) {
875         Subscription storage sub = subscriptions[subId];
876         assert (_isSubscription(sub));
877         var _to = sub.transferTo;
878         require (msg.sender == _to || msg.sender == sub.transferFrom); //only customer or provider can place the subscription on hold.
879         if (sub.onHoldSince > 0) {
880             if (msg.sender == _to || ServiceProvider(_to).onSubUnHold(subId, msg.sender, false)) {         // <=== possible reentrancy
881                 sub.paidUntil += now - sub.onHoldSince;
882                 sub.onHoldSince = 0;
883                 SubOnHold(subId, false, msg.sender);
884                 return true;
885             }
886         }
887         if (isContract(msg.sender)) { return false; }
888         else { throw; }
889     }
890 
891 
892 
893     // *************************************************
894     // *              deposit handling                 *
895     // *************************************************
896 
897     ///@notice can be called by provider on CANCELED subscription to return a subscription deposit to customer immediately.
898     ///        Customer can anyway collect his deposit after `paidUntil` period is over.
899     ///@param subId - subscription holding the deposit
900     //
901     function returnSubscriptionDesposit(uint subId) public notSuspended {
902         Subscription storage sub = subscriptions[subId];
903         assert (_subscriptionState(sub) == SubState.CANCELED);
904         assert (sub.depositAmount > 0); //sanity check
905         assert (sub.transferTo == msg.sender || owner == msg.sender); //only subscription owner or platform owner is allowed to release deposit.
906         sub.expireOn = now;
907         _returnSubscriptionDesposit(subId, sub);
908     }
909 
910 
911     ///@notice called by customer on EXPIRED subscription (`paidUntil` period is over) to collect a subscription deposit.
912     ///        Customer can anyway collect his deposit after `paidUntil` period is over.
913     ///@param subId - subscription holding the deposit
914     //
915     function claimSubscriptionDeposit(uint subId) public notSuspended {
916         Subscription storage sub = subscriptions[subId];
917         assert (_subscriptionState(sub) == SubState.EXPIRED);
918         assert (sub.transferFrom == msg.sender);
919         assert (sub.depositAmount > 0);
920         _returnSubscriptionDesposit(subId, sub);
921     }
922 
923 
924     //@dev returns subscription deposit to customer
925     function _returnSubscriptionDesposit(uint subId, Subscription storage sub) internal {
926         uint depositAmount = sub.depositAmount;
927         sub.depositAmount = 0;
928         san._mintFromDeposit(sub.transferFrom, depositAmount);
929         SubscriptionDepositReturned(subId, depositAmount, sub.transferFrom, msg.sender);
930     }
931 
932 
933     ///@notice create simple unlocked deposit, required by some services. It can be considered as prove of customer's stake.
934     ///        This desposit can be claimed back by the customer at anytime.
935     ///        The service provider is responsible to check the deposit before providing the service.
936     ///@param _value - non zero deposit amount.
937     ///@param _descriptor - is a uniq key, usually given by service provider to the customer in order to make this deposit unique.
938     ///        Service Provider should reject deposit with unknown descriptor, because most probably it is in use for some another service.
939     ///@return depositId - a handle to claim back the deposit later.
940     //
941     function createDeposit(uint _value, uint _lockTime, bytes _descriptor) public notSuspended returns (uint depositId) {
942         require (_value > 0);
943         assert (san._burnForDeposit(msg.sender,_value));
944         deposits[++depositCounter] = Deposit ({
945             owner : msg.sender,
946             value : _value,
947             createdOn : now,
948             lockTime : _lockTime,
949             descriptor : _descriptor
950         });
951         NewDeposit(depositCounter, _value, _lockTime, msg.sender);
952         return depositCounter;
953     }
954 
955 
956     ///@notice return previously created deposit to the user. User can collect only own deposit.
957     ///        The service provider is responsible to check the deposit before providing the service.
958     ///@param _depositId - an id of the deposit to be collected.
959     //
960     function claimDeposit(uint _depositId) public notSuspended {
961         var deposit = deposits[_depositId];
962         require (deposit.owner == msg.sender);
963         assert (deposit.lockTime == 0 || deposit.createdOn +  deposit.lockTime < now);
964         var value = deposits[_depositId].value;
965         delete deposits[_depositId];
966         san._mintFromDeposit(msg.sender, value);
967         DepositReturned(_depositId, msg.sender);
968     }
969 
970 
971 
972     // *************************************************
973     // *            some internal functions            *
974     // *************************************************
975 
976     function _amountToCharge(Subscription storage sub) internal reentrant returns (uint) {
977         return _applyXchangeRate(sub.pricePerHour * sub.chargePeriod, sub) / 1 hours;       // <==== reentrant function usage
978     }
979 
980     function _applyXchangeRate(uint amount, Subscription storage sub) internal reentrant returns (uint) {  // <== actually called from reentrancy guarded context only (i.e. externally secured)
981         if (sub.xrateProviderId > 0) {
982             // xrate_n: nominator
983             // xrate_d: denominator of the exchange rate fraction.
984             var (xrate_n, xrate_d) = XRateProvider(xrateProviders[sub.xrateProviderId]).getRate();        // <=== possible reentrancy
985             amount = amount * sub.initialXrate_n * xrate_d / sub.initialXrate_d / xrate_n;
986         }
987         return amount;
988     }
989 
990     function _isOffer(Subscription storage sub) internal constant returns (bool){
991         return sub.transferFrom == 0 && sub.transferTo != 0;
992     }
993 
994     function _isSubscription(Subscription storage sub) internal constant returns (bool){
995         return sub.transferFrom != 0 && sub.transferTo != 0;
996     }
997 
998     function _exists(Subscription storage sub) internal constant returns (bool){
999         return sub.transferTo != 0;   //existing subscription or offer has always transferTo set.
1000     }
1001 
1002     modifier onlyRegisteredProvider(){
1003         if (!providerRegistry[msg.sender]) throw;
1004         _;
1005     }
1006 
1007     modifier notSuspended {
1008         if (suspendedUntil > now) throw;
1009         _;
1010     }
1011 
1012 } //SubscriptionModuleImpl