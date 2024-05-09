1 // File: ../3rdparty/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: ../3rdparty/openzeppelin-solidity/contracts/ownership/Ownable.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor () internal {
46         _owner = msg.sender;
47         emit OwnershipTransferred(address(0), _owner);
48     }
49 
50     /**
51      * @return the address of the owner.
52      */
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(isOwner(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @return true if `msg.sender` is the owner of the contract.
67      */
68     function isOwner() public view returns (bool) {
69         return msg.sender == _owner;
70     }
71 
72     /**
73      * @dev Allows the current owner to relinquish control of the contract.
74      * It will not be possible to call the functions with the `onlyOwner`
75      * modifier anymore.
76      * @notice Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Allows the current owner to transfer control of the contract to a newOwner.
86      * @param newOwner The address to transfer ownership to.
87      */
88     function transferOwnership(address newOwner) public onlyOwner {
89         _transferOwnership(newOwner);
90     }
91 
92     /**
93      * @dev Transfers control of the contract to a newOwner.
94      * @param newOwner The address to transfer ownership to.
95      */
96     function _transferOwnership(address newOwner) internal {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 
103 // File: ../3rdparty/openzeppelin-solidity/contracts/math/SafeMath.sol
104 
105 pragma solidity ^0.5.0;
106 
107 /**
108  * @title SafeMath
109  * @dev Unsigned math operations with safety checks that revert on error.
110  */
111 library SafeMath {
112     /**
113      * @dev Multiplies two unsigned integers, reverts on overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Solidity only automatically asserts when dividing by 0
134         require(b > 0, "SafeMath: division by zero");
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 
141     /**
142      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b <= a, "SafeMath: subtraction overflow");
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Adds two unsigned integers, reverts on overflow.
153      */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a, "SafeMath: addition overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
163      * reverts when dividing by zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         require(b != 0, "SafeMath: modulo by zero");
167         return a % b;
168     }
169 }
170 
171 // File: contracts/Whitelist.sol
172 
173 pragma solidity >=0.4.25 <0.6.0;
174 
175 
176 contract Whitelist is Ownable{
177     mapping (uint256 => uint8) private _partners;
178     mapping (address => uint256) private _partner_ids;
179     mapping (uint256 => address) private _partner_address;
180     uint256 public partners_counter=1;
181     mapping (address => uint8) private _whitelist;
182     mapping (address => uint256) private _referrals;
183     mapping (uint256 => mapping(uint256=>address)) private _partners_referrals;
184     mapping (uint256 => uint256) _partners_referrals_counter;
185 
186     uint8 public constant STATE_NEW = 0;
187     uint8 public constant STATE_WHITELISTED = 1;
188     uint8 public constant STATE_BLACKLISTED = 2;
189     uint8 public constant STATE_ONHOLD = 3;
190 
191     event Whitelisted(address indexed partner, address indexed subscriber);
192     event AddPartner(address indexed partner, uint256 partner_id);
193 
194     function _add_partner(address partner) private returns (bool){
195         _partner_ids[partner] = partners_counter;
196         _partner_address[partners_counter] = partner;
197         _partners[partners_counter] = STATE_WHITELISTED;
198         _whitelist[partner] = STATE_WHITELISTED;
199         emit AddPartner(partner, partners_counter);
200         partners_counter++;
201     }
202     
203     constructor () public {
204         _add_partner(msg.sender);
205     }
206 
207     function getPartnerId(address partner) public view returns (uint256){
208         return _partner_ids[partner];
209     }
210 
211     modifier onlyWhiteisted(){
212         require(_whitelist[msg.sender] == STATE_WHITELISTED, "Ownable: caller is not whitelisted");
213         _;
214     }
215 
216     function isPartner() public view returns (bool){
217         return _partners[_partner_ids[msg.sender]] == STATE_WHITELISTED;
218     }
219 
220     function partnerStatus(address partner) public view returns (uint8){
221         return _partners[_partner_ids[partner]];
222     }
223 
224 
225     modifier onlyPartnerOrOwner(){
226         require(isOwner() || isPartner(), "Ownable: caller is not the owner or partner");
227         _;
228     }
229 
230     function setPartnerState(address partner, uint8 state) public onlyOwner returns(bool){
231         uint256 partner_id = getPartnerId(partner);
232         if( partner_id == 0 && state == STATE_WHITELISTED){
233             _add_partner(partner);
234         }else{
235             _partners[partner_id] = state;
236         }
237         return true;
238     }
239 
240 
241     function addPartner(address partner) public onlyOwner returns(bool){
242         _add_partner(partner);
243         return true;
244     }
245 
246     function whitelist(address referral) public onlyPartnerOrOwner returns (bool){
247         require(_whitelist[referral] == STATE_NEW, "Referral is already whitelisted");
248         uint256 partner_id = getPartnerId(msg.sender);
249         require(partner_id != 0, "Partner not found");
250         _whitelist[referral] = STATE_WHITELISTED;
251         _referrals[referral] = partner_id;
252         _partners_referrals[partner_id][_partners_referrals_counter[partner_id]] = referral;
253         _partners_referrals_counter[partner_id] ++;
254         emit Whitelisted(msg.sender, referral);
255 
256     }
257 
258     function setWhitelistState(address referral, uint8 state) public onlyOwner returns (bool){
259         require(_whitelist[referral] != STATE_NEW, "Referral is not in list");
260         _whitelist[referral] = state;
261     }
262 
263     function getWhitelistState(address referral) public view returns (uint8){
264         return _whitelist[referral];
265     }
266 
267     function getPartner(address referral) public view returns (address){
268         return _partner_address[_referrals[referral]];
269     }
270 
271     function setPartnersAddress(uint256 partner_id, address new_partner) public onlyOwner returns (bool){
272         _partner_address[partner_id] = new_partner;
273         _partner_ids[new_partner] = partner_id;
274         return true;
275     }
276 
277     function bulkWhitelist(address[] memory address_list) public returns(bool){
278         for(uint256 i = 0; i < address_list.length; i++){
279             whitelist(address_list[i]);
280         }
281         return true;
282     }
283 
284 }
285 
286 // File: contracts/Periods.sol
287 
288 pragma solidity >=0.4.25 <0.6.0;
289 
290 
291 contract Periods is Ownable{
292     uint16 private _current_period;
293     uint16 private _total_periods;
294     mapping (uint16=>uint256) _periods;
295     bool _adjustable;
296 
297     constructor() public{
298         _adjustable = true;
299     }
300 
301     function getPeriodsCounter() public view returns(uint16){
302         return _total_periods;
303     }
304 
305     function getCurrentPeriod() public view returns(uint16){
306         return _checkCurrentPeriod();
307     }
308 
309     function getCurrentTime() public view returns(uint256){
310         return now;
311     }
312 
313 
314     function getCurrentPeriodTimestamp() public view returns(uint256){
315         return _periods[_current_period];
316     }
317 
318     function getPeriodTimestamp(uint16 period) public view returns(uint256){
319         return _periods[period];
320     }
321 
322     
323     function setCurrentPeriod(uint16 period) public onlyOwner returns (bool){
324         require(period < _total_periods, "Do not have timestamp for that period");
325         _current_period = period;
326         return true;
327     }
328 
329 
330     function addPeriodTimestamp(uint256 timestamp) public onlyOwner returns (bool){
331 //        require(_total_periods - _current_period < 50, "Cannot add more that 50 periods from now");
332 //        require((_current_period == 0) || (timestamp - _periods[_total_periods-1] > 28 days && (timestamp - _periods[_total_periods-1] < 32 days )), "Incorrect period)");
333         _periods[_total_periods] = timestamp;
334         _total_periods++;
335         return true;
336     }
337 
338     function _checkCurrentPeriod() private view returns (uint16){
339         uint16 current_period = _current_period;
340         while( current_period < _total_periods-1){
341             if( now < _periods[current_period] ){
342                 break;
343             }
344             current_period ++;
345         }
346         return current_period;
347     }
348 
349     function adjustCurrentPeriod( ) public returns (uint16){
350         if(!_adjustable){
351             return _current_period;
352         }
353         require(_total_periods > 1, "Periods are not set");
354         require(_current_period < _total_periods, "Last period reached");
355         //require(_total_periods - _current_period < 50, "Adjust more that 50 periods from now");
356         uint16 current_period = _checkCurrentPeriod();
357         if(current_period > _current_period){
358             _current_period = current_period;
359         }
360         return current_period;
361     }
362 
363     function addPeriodTimestamps(uint256[] memory timestamps) public onlyOwner returns(bool){
364         //require(timestamps.length < 50, "Cannot set more than 50 periods");
365         for(uint16 current_timestamp = 0; current_timestamp < timestamps.length; current_timestamp ++){
366             addPeriodTimestamp(timestamps[current_timestamp]);
367         }
368         return true;
369     }
370 
371     function setLastPeriod(uint16 period) public onlyOwner returns(bool){
372         require(period < _total_periods-1, "Incorrect period");
373         require(period > _current_period, "Cannot change passed periods");
374         _total_periods = period;
375         return true;
376     }
377 
378 
379 }
380 
381 // File: contracts/Subscriptions.sol
382 
383 pragma solidity >=0.4.25 <0.6.0;
384 
385 
386 
387 
388 contract Subscriptions is Ownable, Periods {
389     using SafeMath for uint256;
390 
391     uint8 STATE_MISSING = 0;
392     uint8 STATE_ACTIVE = 1;
393     uint8 STATE_WITHDRAWN = 2;
394     uint8 STATE_PAID = 3;
395 
396     uint256 ROUNDING = 1000;
397 
398     struct Subscription{
399         uint256 subscriber_id;
400         uint256 subscription;
401         uint256 certificates;
402         uint256 certificate_rate;
403         uint256 certificate_partners_rate;
404         uint16 period;
405         uint16 lockout_period;
406         uint16 total_periods;
407         uint256 certificates_redeemed;
408         uint256 redemption;
409         uint256 payout;
410         uint256 deposit;
411         uint256 commission;
412         uint256 paid_to_partner;
413         uint256 redeem_requested;
414         uint256 redeem_delivered;
415     }
416 
417     mapping (address=>uint256) private _subscribers;
418     mapping (uint256=>address) private _subscribers_id;
419     uint256 private _subscribers_counter=1;
420 
421     mapping (uint256=>Subscription) private _subscriptions;
422     mapping (uint256=>mapping(uint256=>uint256)) private _subscribers_subscriptions;
423     mapping (uint256=>mapping(uint16=>uint256)) private _subscribers_subscriptions_by_period;
424     mapping (uint256=>uint16) private _subscribers_subscriptions_recent;
425     uint256 private _subscriptions_counter=1;
426     mapping (uint256=>uint256) private _subscribers_subscriptions_counter;
427 
428     uint256 private _commission;
429 
430     uint256 private _total_subscription=0;
431     uint16 private _lockout_period;
432     uint16 private _max_period;
433 
434     event Subscribe(address subscriber, uint256 subscription, uint256 certs );
435     event Topup(address indexed subscriber, uint256 subscription_id, uint256 amount);
436     event Payout(address indexed subscriber, uint256 subscription_id, uint256 amount);
437     event Redemption(address indexed subscriber, uint256 subscription_id, uint256 amount);
438     event RedemptionPartner(address indexed partner, address indexed subscriber, uint256 subscription_id, uint256 amount);
439     event AmountCertNickelWireReceived(address indexed subscriber, uint256 subscription_id, uint256 amount);
440 
441     constructor() public{
442         _lockout_period = 3;
443         _max_period = 24;
444         _commission = 1000;
445     }
446 
447     function floor(uint a, uint m) internal pure returns (uint256 ) {
448         return ((a ) / m) * m;
449     }
450 
451     function ceil(uint a, uint m) internal pure returns (uint256 ) {
452         return ((a + m + 1) / m) * m;
453     }
454 
455 
456     function get_subscriber_id(address subscriber_address) public view returns (uint256){
457         return _subscribers[subscriber_address];
458     }
459 
460     function get_subscriber_address(uint256 subscriber_id) public view returns (address){
461         return _subscribers_id[subscriber_id];
462     }
463 
464     function lockoutPeriod() public view returns(uint16){
465         return _lockout_period;
466     }
467 
468     function setLockoutPeriod(uint16 period) public returns (bool){
469         _lockout_period = period;
470         return true;
471     }
472 
473     function maxPeriod() public view returns(uint16){
474         return _max_period;
475     }
476 
477     function setMaxPeriod(uint16 period) public onlyOwner returns(bool){
478         _max_period = period;
479         return true;
480     }
481 
482     function commission() public view returns(uint256){
483         return _commission;
484     }
485 
486     function setCommission(uint256 value) public onlyOwner returns(bool){
487         _commission = value;
488         return true;
489     }
490 
491 
492     function _new_subscription(uint256 subscriber_id, uint16 period, uint256 amount, uint256 units, uint256 unit_rate, uint256 partners_rate) private returns(bool){
493             Subscription memory subscription = Subscription(
494                 subscriber_id,
495                 amount, // subscription
496                 units, // certificates
497                 unit_rate, // certificate_rate
498                 partners_rate, // certificate_partners_rate
499                 period, // period
500                 _lockout_period, // lockout_period
501                 _max_period, // total_periods
502                 0, // certificates_redeemed
503                 0, // redemption
504                 0, // redemption
505                 0, // deposit
506                 0, // commission
507                 0,  // paidtopartner
508                 0, // redemptiuon requested
509                 0 // redeemption delivered
510                 );
511 
512             uint256 subscription_id = _subscriptions_counter;
513             _subscriptions[subscription_id] = subscription;
514             uint256 subscribers_subscriptions_counter = _subscribers_subscriptions_counter[subscriber_id];
515             _subscribers_subscriptions[subscriber_id][subscribers_subscriptions_counter] = subscription_id;
516             _subscribers_subscriptions_by_period[subscriber_id][period] = subscription_id;
517             if(_subscribers_subscriptions_recent[subscriber_id] < period){
518                 _subscribers_subscriptions_recent[subscriber_id] = period;
519             }
520             _subscribers_subscriptions_counter[subscriber_id]++;
521             _subscriptions_counter++;
522     }
523 
524 
525     function _subscribe(address subscriber, uint256 amount, uint256 units, uint256 unit_rate, uint256 partners_rate ) private returns(bool){
526         uint256 subscriber_id = get_subscriber_id(subscriber);
527         uint16 current_period = getCurrentPeriod();
528         if( subscriber_id == 0 ){
529             subscriber_id = _subscribers_counter;
530             _subscribers[subscriber] = subscriber_id;
531             _subscribers_id[subscriber_id] = subscriber;
532             _subscribers_counter ++;
533         }
534 
535         if(_subscribers_subscriptions_counter[subscriber_id] == 0){
536             _new_subscription(subscriber_id, current_period, amount, units, unit_rate, partners_rate);
537         }else{
538             Subscription storage subscription = _subscriptions[_subscribers_subscriptions_by_period[subscriber_id][_subscribers_subscriptions_recent[subscriber_id]]];
539             if( subscription.period == current_period){
540                 subscription.subscription = subscription.subscription.add(amount);
541                 if(units != 0){
542                     subscription.certificate_rate = subscription.certificate_rate.mul(subscription.certificates).add(units.mul(unit_rate)).div(subscription.certificates.add(units));
543                     subscription.certificate_partners_rate = subscription.certificate_partners_rate.mul(subscription.certificates).add(units.mul(partners_rate)).div(subscription.certificates.add(units));
544                     subscription.certificates = subscription.certificates.add(units);
545                 }
546             }else{
547                 _new_subscription(subscriber_id, current_period, amount, units, unit_rate, partners_rate);
548             }
549         }
550         emit Subscribe(subscriber, amount, units);
551         return true;
552     }
553 
554     function _payout(address subscriber, uint256 subscription_id, uint256 amount ) private returns(bool){
555         uint subscriber_id = get_subscriber_id(subscriber);
556         require(subscriber_id != 0, "No subscriber id found");
557 
558         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
559         uint256 total_payout = subscription.payout.add(amount);
560         require (subscription.subscription >= total_payout, "Payout exceeds subscription");
561         subscription.payout = total_payout;
562         return true;
563     }
564 
565     function _return_payout(address subscriber, uint256 subscription_id, uint256 amount ) private returns(bool){
566         uint subscriber_id = get_subscriber_id(subscriber);
567         require(subscriber_id != 0, "No subscriber id found");
568         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
569         uint256 total_payout = subscription.payout.sub(amount);
570         require(total_payout <= subscription.subscription, "Cannot return more than initial subscription");
571         subscription.payout = total_payout;
572         return true;
573     }
574 
575 
576     function _redeem(uint256 subscriber_id, uint256 subscription_id, uint256 amount ) private returns(bool){
577         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
578         require( subscription.certificates.sub(subscription.certificates_redeemed) >= amount, "Not enough certificates");
579 
580         uint256 pay_to_partner_rate = 0;
581         if( getCurrentPeriod() >= subscription.period + subscription.lockout_period ){
582              pay_to_partner_rate = subscription.certificate_partners_rate.mul( getCurrentPeriod() - subscription.period - subscription.lockout_period).div(subscription.total_periods-subscription.lockout_period);
583         }
584 
585         uint256 subscription_required = floor(amount.mul(subscription.certificate_rate.add(pay_to_partner_rate).add(commission())), ROUNDING);
586 
587         uint256 subscription_debit = subscription.subscription.add(subscription.deposit);
588         uint256 subscription_credit = subscription.redemption.add(subscription.payout).add(subscription.commission).add(subscription.paid_to_partner);
589 
590         require(subscription_debit > subscription_credit, "Too much credited");
591         require(subscription_required <= subscription_debit.sub(subscription_credit), "Not enough funds");
592 
593         uint256 redemption_total = floor(amount.mul(subscription.certificate_rate), ROUNDING);
594 
595         subscription.certificates_redeemed = subscription.certificates_redeemed.add(amount);
596         subscription.redemption = subscription.redemption.add( redemption_total);
597         subscription.paid_to_partner = subscription.paid_to_partner.add( _get_partners_payout(subscriber_id, subscription_id, amount) );
598         subscription.commission = floor(subscription.commission.add( amount.mul(commission())), ROUNDING);
599         return true;
600     }
601 
602     function _partners_redeem(uint256 partners_subscriber_id, uint256 subscriber_id, uint256 subscription_id, uint256 amount ) private returns(bool){
603 
604         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
605         Subscription storage partners_subscription = _subscriptions[_subscribers_subscriptions_by_period[partners_subscriber_id][subscription.period]]; 
606 
607         uint256 redemption_total = amount.mul(subscription.certificate_partners_rate);
608         partners_subscription.redemption = partners_subscription.redemption.add( redemption_total);
609         partners_subscription.deposit = partners_subscription.deposit.add( _get_partners_payout(subscriber_id, subscription_id, amount ));
610         return true;
611     }
612 
613     function _get_subscriptions_count(uint256 subscriber_id) private view returns(uint256){
614         return _subscribers_subscriptions_counter[subscriber_id];
615     }
616 
617 
618     function getSubscriptionsCountAll() public view returns(uint256) {
619         return _subscriptions_counter;
620     }
621 
622     function getSubscriptionsCount(address subscriber) public view returns (uint256){
623         uint256 subscriber_id = get_subscriber_id(subscriber);
624         require(subscriber_id != 0, "No subscriber id found");
625         return _get_subscriptions_count(subscriber_id);
626     }
627 
628     function _getSubscription(uint256 subscriber_id, uint256 subscription_id) private view returns (uint256){
629         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
630         return subscription.subscription;
631 
632     }
633 
634     function _getPayout(uint256 subscriber_id, uint256 subscription_id) private view returns (uint256){
635         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
636         return subscription.payout;
637 
638     }
639 
640 
641     function _getCertificates(uint256 subscriber_id, uint256 subscription_id) private view returns (uint256){
642         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
643         return subscription.certificates;
644 
645     }
646 
647  
648 
649 
650     function subscribe(address subscriber, uint256 amount, uint256 units, uint256 unit_rate, uint256 partner_rate) internal returns(bool){
651         _subscribe(subscriber, amount, units, unit_rate, partner_rate);
652         return true;
653     }
654 
655     function _getCertificatesAvailable(uint256 subscriber_id, uint256 subscription_id) private view returns (uint256){
656         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
657         uint256 subscription_debit = subscription.subscription.add(subscription.deposit);
658         uint256 subscription_credit = subscription.redemption.add(subscription.payout).add(subscription.commission).add(subscription.paid_to_partner);
659         if( subscription_credit >= subscription_debit){
660             return 0;
661         }
662         uint256 pay_to_partner_rate = 0;
663         if( getCurrentPeriod() >= subscription.period + subscription.lockout_period ){
664              pay_to_partner_rate = subscription.certificate_partners_rate.mul( getCurrentPeriod() - subscription.period - subscription.lockout_period).div(subscription.total_periods-subscription.lockout_period);
665         }
666         uint256 cert_rate = subscription.certificate_rate.add(pay_to_partner_rate).add(commission());
667         return ( subscription_debit.sub(subscription_credit).div( floor(cert_rate, ROUNDING)) );
668     }    
669 
670     function _getTopupAmount(uint256 subscriber_id, uint256 subscription_id, uint256 amount) private view returns (uint256){
671         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
672         require( amount <= subscription.certificates - subscription.certificates_redeemed, "Cannot calculate for amount greater than available");
673         uint256 calc_amount = amount;
674         if( amount == 0){
675             calc_amount = subscription.certificates - subscription.certificates_redeemed;
676         }
677         uint256 subscription_debit = subscription.subscription.add(subscription.deposit);
678         uint256 subscription_credit = subscription.redemption.add(subscription.payout).add(subscription.commission).add(subscription.paid_to_partner);
679 
680         uint256 pay_to_partner_rate = 0;
681         if( getCurrentPeriod() >= subscription.period + subscription.lockout_period ){
682              pay_to_partner_rate = floor(subscription.certificate_partners_rate.
683                                     mul( getCurrentPeriod() - subscription.period - subscription.lockout_period).
684                                     div(subscription.total_periods-subscription.lockout_period), ROUNDING);
685         }
686         uint256 cert_rate = subscription.certificate_rate.add(pay_to_partner_rate).add(commission());
687         uint256 required_amount = cert_rate.mul(calc_amount);
688 
689         if( required_amount <= subscription_debit.sub(subscription_credit) ) return 0;
690 
691         return ( ceil(required_amount.sub(subscription_debit.sub(subscription_credit)), 1000));
692     }
693 
694 
695     function _get_available_payout(uint256 subscriber_id, uint256 subscription_id) private view returns (uint256){
696         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
697         uint16 periods_passed = getCurrentPeriod() - subscription.period;
698         if( periods_passed <= subscription.lockout_period) {
699             return 0;
700         }
701         if( periods_passed > subscription.total_periods) {
702             return subscription.subscription.add(subscription.deposit).sub(subscription.payout).
703                 sub(subscription.redemption).sub(subscription.commission).sub(subscription.paid_to_partner);
704         }
705         uint256 debit = subscription.subscription.sub(subscription.redemption).
706             div(subscription.total_periods - subscription.lockout_period).mul(periods_passed - subscription.lockout_period).add(subscription.deposit);
707         uint256 credit = subscription.paid_to_partner.add(subscription.payout).add(subscription.commission);
708         //if (credit >= debit) return 0;
709         return floor(debit.sub(credit), 1000);
710     }
711 
712     function get_available(address subscriber, uint256 subscription_id) private view returns (uint256){
713         uint256 subscriber_id = get_subscriber_id(subscriber);
714         require(subscriber_id != 0, "No subscriber id found");
715         return(_get_available_payout(subscriber_id, subscription_id));
716     }
717 
718     function get_available_certs(address subscriber, uint256 subscription_id) private view returns (uint256){
719         uint256 subscriber_id = get_subscriber_id(subscriber);
720         require(subscriber_id != 0, "No subscriber id found");
721         return(_get_available_payout(subscriber_id, subscription_id));
722     }
723     function _get_partners_payout(uint256 subscriber_id, uint256 subscription_id, uint256 amount) private view returns (uint256){
724         Subscription memory subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
725         uint16 periods_passed = getCurrentPeriod() - subscription.period;
726         if( periods_passed <= subscription.lockout_period) {
727             return 0;
728         }
729         if( periods_passed > subscription.total_periods) {
730             return floor(amount.mul(subscription.certificate_partners_rate), ROUNDING);
731         }
732         uint256 partners_payout = floor(amount.mul(subscription.certificate_partners_rate).
733                                         div(subscription.total_periods - subscription.lockout_period).
734                                         mul(periods_passed - subscription.lockout_period), ROUNDING);
735         return partners_payout;
736     }
737 
738     function get_partners_payout(address subscriber, uint256 subscription_id, uint256 amount) private view returns (uint256){
739         uint256 subscriber_id = get_subscriber_id(subscriber);
740         require(subscriber_id != 0, "No subscriber id found");
741         return(_get_partners_payout(subscriber_id, subscription_id, amount));
742     }
743 
744     function payout(address subscriber, uint256 subscription_id, uint256 amount) internal returns(bool){
745         uint256 available = get_available(subscriber, subscription_id);
746         require(available >= amount, "Not enough funds for withdrawal");
747         _payout(subscriber, subscription_id, amount);
748         emit Payout(subscriber, subscription_id, amount);
749         return true;
750     }
751 
752     function redeem(address subscriber, uint256 subscription_id, uint256 amount) internal returns(bool){
753         uint256 subscriber_id = get_subscriber_id(subscriber);
754         _redeem(subscriber_id, subscription_id, amount);
755         emit Redemption(subscriber, subscription_id, amount);
756 
757     }
758 
759     function partners_redeem(address partner, address subscriber, uint256 subscription_id, uint256 amount) internal returns(bool){
760         uint256 subscriber_id = get_subscriber_id(subscriber);
761         require(subscriber_id != 0, "No subscriber id found");
762         uint256 partners_subscriber_id = get_subscriber_id(partner);
763         require(partners_subscriber_id != 0, "No subscriber id found");
764         _partners_redeem(partners_subscriber_id, subscriber_id, subscription_id, amount);
765         emit RedemptionPartner(partner, subscriber, subscription_id, amount);
766     }
767 
768     function return_payout(address subscriber, uint256 subscription_id, uint256 amount) internal returns(bool){
769         _return_payout(subscriber, subscription_id, amount);
770         return true;
771     }
772 
773     function getAvailable(address subscriber, uint256 subscription_id) public view returns(uint256){
774         return get_available(subscriber, subscription_id);
775     }
776 
777     function _changeSubscriptionOwner(address old_subscriber_address, address new_subscriber_address) internal returns (bool){
778         uint256 subscriber_id = get_subscriber_id(old_subscriber_address);
779         require(getSubscriptionsCount(new_subscriber_address) == 0, "New subscriber has subscriptions");
780         _subscribers[new_subscriber_address] = subscriber_id;
781         _subscribers_id[subscriber_id] = new_subscriber_address;
782         return true;
783     }
784 
785     function _get_subscription(uint256 subscriber_id, uint256 subscription_id) private view returns(Subscription memory){
786         return  _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
787     }
788 
789 
790 
791     function get_subscription(address subscriber, uint256 subscription_id) internal view returns(Subscription memory){
792         uint256 subscriber_id = get_subscriber_id(subscriber);
793         require(subscriber_id != 0, "No subscriber id found");
794         return  _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
795     }
796 
797     function get_global_subscription(uint256 subscription_id) internal view returns(Subscription memory){
798         return  _subscriptions[subscription_id];
799     }
800 
801 
802     function _top(uint256 subscriber_id, uint256 subscription_id, uint256 amount) private returns(bool){
803         Subscription storage subscription =  _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
804         subscription.deposit = subscription.deposit.add(amount);
805         return true;
806     }
807 
808 
809     function top(address subscriber, uint256 subscription_id, uint256 amount) internal returns(bool){
810         uint256 subscriber_id = get_subscriber_id(subscriber);
811         //require(_getTopupAmount(subscriber_id, subscription_id, 0) >= amount, "Cannot topup more that available");
812         _top(subscriber_id, subscription_id, amount);
813         emit Topup(subscriber,subscription_id,amount);
814     }
815 
816 
817     function getCertSubscriptionStartDate(address subscriber, uint256 subscription_id) public view returns(uint256){
818         Subscription memory subscription = get_subscription(subscriber, subscription_id);
819         return getPeriodTimestamp(subscription.period);
820     }
821 
822     function getNWXgrantedToInvestor(address subscriber, uint256 subscription_id) public view returns(uint256){
823         Subscription memory subscription = get_subscription(subscriber, subscription_id);
824         return subscription.subscription;
825     }
826 
827     function getNWXgrantedToPartner(address subscriber, uint256 subscription_id) public view returns(uint256){
828         uint256 subscriber_id = get_subscriber_id(subscriber);
829         Subscription memory subscription = get_subscription(subscriber, subscription_id);
830         return _get_partners_payout(subscriber_id, subscription_id, subscription.certificates.sub(subscription.certificates_redeemed) ).add(subscription.paid_to_partner);
831     }
832 
833     function getNWXpayedToInvestor(address subscriber, uint256 subscription_id) public view returns(uint256){
834         Subscription memory subscription = get_subscription(subscriber, subscription_id);
835         return subscription.payout;
836     }
837 
838     function getNWXpayedToPartner(address subscriber, uint256 subscription_id) public view returns(uint256){
839         Subscription memory subscription = get_subscription(subscriber, subscription_id);
840         return subscription.paid_to_partner;
841     }
842 
843 
844     function  getAmountCertRedemptionRequested(address subscriber, uint256 subscription_id) public view returns(uint256){
845         Subscription memory subscription = get_subscription(subscriber, subscription_id);
846         return subscription.certificates_redeemed;
847     }
848 
849     function  getAmountCertNickelWireReceived(address subscriber, uint256 subscription_id) public view returns(uint256){
850         Subscription memory subscription = get_subscription(subscriber, subscription_id);
851         return subscription.redeem_delivered;
852     }
853 
854     function  setAmountCertNickelWireReceived(address subscriber, uint256 subscription_id, uint256 amount ) public onlyOwner returns(bool){
855         uint256 subscriber_id = get_subscriber_id(subscriber);
856         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
857         require(subscription.certificates_redeemed>=amount, "Not enough redeemed certs");
858         subscription.redeem_delivered = amount;
859         emit AmountCertNickelWireReceived(subscriber, subscription_id, amount);
860         return true;
861     }
862     /*
863     function  setAmountCertRedemptionRequested(address subscriber, uint256 subscription_id, uint256 amount ) public onlyOwner returns(bool){
864         uint256 subscriber_id = get_subscriber_id(subscriber);
865         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
866         require(subscription.certificates_redeemed>=amount, "Not enough redeemed certs");
867         subscription.redeem_requested = amount;
868         return true;
869     }
870     */
871     /*
872     function  requestRedemption(uint256 subscription_id, uint256 amount ) public returns(bool){
873         uint256 subscriber_id = get_subscriber_id(msg.sender);
874         Subscription storage subscription = _subscriptions[_subscribers_subscriptions[subscriber_id][subscription_id]];
875         require(subscription.certificates_redeemed>=subscription.redeem_requested.add(amount), "Not enough redeemed certs");
876         subscription.redeem_requested = subscription.redeem_requested.add(amount);
877         return true;
878     }
879     */
880 
881    function getTopupAmount(address subscriber, uint256 subscription_id, uint256 amount) public view returns (uint256){
882         uint256 subscriber_id = get_subscriber_id(subscriber);
883         require(subscriber_id != 0, "No subscriber id found");
884         return _getTopupAmount(subscriber_id, subscription_id, amount);
885     }
886 
887 
888     function getSubscription(address subscriber, uint256 subscription_id) public view returns (uint256){
889         uint256 subscriber_id = get_subscriber_id(subscriber);
890         require(subscriber_id != 0, "No subscriber id found");
891         return _getSubscription(subscriber_id, subscription_id);
892     }
893 
894     function getPayout(address subscriber, uint256 subscription_id) public view returns (uint256){
895         uint256 subscriber_id = get_subscriber_id(subscriber);
896         require(subscriber_id != 0, "No subscriber id found");
897         return _getPayout(subscriber_id, subscription_id);
898     }
899 
900 
901     function getSubscriptionAll(address subscriber) public view returns (uint256){
902         uint256 subscriber_id = get_subscriber_id(subscriber);
903         require(subscriber_id != 0, "No subscriber id found");
904         uint256 total_subscription = 0;
905         for( uint256 subscription_id = 0; subscription_id < _subscribers_subscriptions_counter[subscriber_id]; subscription_id++){
906             total_subscription = total_subscription.add(_getSubscription(subscriber_id, subscription_id));
907         }
908         return total_subscription;
909     }
910 
911 
912     function getCertificatesRedeemedQty(address subscriber, uint256 subscription_id) public view returns (uint256){
913         Subscription memory subscription = get_subscription(subscriber, subscription_id);
914         return subscription.certificates_redeemed;
915     }
916 
917 
918     function getCertificatesQty(address subscriber, uint256 subscription_id) public view returns (uint256){
919         uint256 subscriber_id = get_subscriber_id(subscriber);
920         require(subscriber_id != 0, "No subscriber id found");
921         return _getCertificates(subscriber_id, subscription_id);
922     }
923 
924 
925     function getCertificatesQtyAll(address subscriber) public view returns (uint256){
926         uint256 subscriber_id = get_subscriber_id(subscriber);
927         require(subscriber_id != 0, "No subscriber id found");
928         uint256 total_certificates = 0;
929         for( uint256 subscription_id = 0; subscription_id < _subscribers_subscriptions_counter[subscriber_id]; subscription_id++){
930             total_certificates = total_certificates.add(_getCertificates(subscriber_id, subscription_id));
931         }
932         return total_certificates;
933     }
934 
935 
936 
937     function getCertificatesQtyAvailable(address subscriber, uint256 subscription_id) public view returns (uint256){
938         uint256 subscriber_id = get_subscriber_id(subscriber);
939         require(subscriber_id != 0, "No subscriber id found");
940         return _getCertificatesAvailable(subscriber_id, subscription_id);
941     }
942 
943     function getCertificatesQtyAvailableAll(address subscriber) public view returns (uint256){
944         uint256 subscriber_id = get_subscriber_id(subscriber);
945         require(subscriber_id != 0, "No subscriber id found");
946         uint256 total_certificates = 0;
947         for( uint256 subscription_id = 0; subscription_id < _subscribers_subscriptions_counter[subscriber_id]; subscription_id++){
948             total_certificates = total_certificates.add(_getCertificatesAvailable(subscriber_id, subscription_id));
949         }
950         return total_certificates;
951     }
952 
953 
954 }
955 
956 // File: contracts/INIWIX.sol
957 
958 pragma solidity >=0.4.25 <0.6.0;
959 
960 
961 interface INIWIX {
962     function tokenFallback( address from, uint256 value ) external returns(bool);
963 }
964 
965 // File: contracts/Cert.sol
966 
967 pragma solidity >=0.4.25 <0.6.0;
968 pragma experimental ABIEncoderV2;
969 
970 
971 
972 
973 
974 
975 
976 
977 contract Cert is Ownable, Whitelist, Subscriptions{
978     using SafeMath for uint256;
979 
980     string private _name;
981 
982     IERC20 _niwix;
983     IERC20 _euron;
984 
985     uint256 private _deposit_niwix_rate;
986     uint256 private _subscription_niwix_rate;
987     uint256 private _subscription_partner_rate;
988     uint256 private _subscription_unit_rate;
989 
990     uint public n;
991     address public sender;
992 
993     event TokenFallbackCert(address indexed where, address indexed sender, address indexed from, uint256 value);
994     event DepositTo(address indexed where, address indexed sender, address indexed to, uint256 value);
995     event Redemption(address indexed subscriber, uint256 subscription_id, uint256 amount);
996     event ChangeSubscriber(address indexed from, address indexed to);
997     event Withdraw(address indexed subscriber, uint256 subscription_id, uint256 amount);
998     event Deposit(address indexed subscriber, uint256 amount);
999     event SetNIWIXRate(uint256 rate);
1000     event SetUnitPrice(uint256 rate);
1001     event SetSubscriptionPartnerRate(uint256 rate);
1002 
1003     mapping (uint256=>uint256) paper_certificate;
1004 
1005     function tokenFallback( address from, uint256 value ) public returns(bool){
1006         if( msg.sender == address(_euron)){
1007             if( from != address(_niwix) )
1008             {
1009                 _euron.transfer(address(_niwix), value);
1010                 INIWIX(address(_niwix)).tokenFallback(from, value);
1011             }
1012         }
1013         return true;
1014     }
1015 
1016 
1017     constructor() public {
1018         _name = "NiwixCert";
1019         _deposit_niwix_rate = 1000 * 10 ** 8;
1020         _subscription_niwix_rate = 10000 * 10 ** 8;
1021         _subscription_unit_rate = 100 * 10 ** 8;
1022     }
1023 
1024     function name() public view returns(string memory){
1025         return _name;
1026     }
1027 
1028     function setNiwix(address contract_address) public onlyOwner returns(bool){
1029         _niwix = IERC20(contract_address);
1030         return true;
1031     }
1032 
1033     function setEURON(address contract_address) public onlyOwner returns(bool){
1034         _euron = IERC20(contract_address);
1035         return true;
1036     }
1037 
1038     function depositNiwixRate() public view returns(uint256){
1039         return _deposit_niwix_rate;
1040     }
1041 
1042     function setDepositNiwixRate(uint256 value) public onlyOwner returns(uint256){
1043         _deposit_niwix_rate = value;
1044     }
1045 
1046     function setSubscriptionUnitRate(uint256 value) public onlyOwner returns(uint256){
1047         _subscription_unit_rate = value;
1048     }
1049 
1050     function setSubscriptionNiwixRate(uint256 value) public onlyOwner returns(uint256){
1051         _subscription_niwix_rate = value;
1052     }
1053 
1054     function getSubscriptionUnitRate() public view returns(uint256){
1055         return(_subscription_unit_rate);
1056     }
1057 
1058 
1059     function getDepositNiwixValue(uint256 euron_amount) public view returns(uint256){
1060         return euron_amount.div(_subscription_unit_rate).mul(depositNiwixRate());
1061     }
1062 
1063 
1064     function setSubscriptionParnerRate(uint256 value) public onlyOwner returns(uint256){
1065         _subscription_partner_rate = value;
1066     }
1067 
1068     function subscriptionPartnerRate() public view returns(uint256){
1069         return _subscription_partner_rate;
1070     }
1071 
1072     function _get_subscription_units(uint256 value) public view returns (uint256){
1073         return value.div(_subscription_unit_rate);
1074     }
1075 
1076     function _get_subscription_change(uint256 value) public view returns (uint256){
1077         uint256 units = value.div(_subscription_unit_rate);
1078         uint256 subscription = units.mul(_subscription_unit_rate);
1079         return value.sub(subscription);
1080     }
1081 
1082     function get_subscription_value(uint256 value) public view returns (uint256, uint256, uint256){
1083         uint256 units = _get_subscription_units(value);
1084         uint256 subscription = units.mul(_subscription_unit_rate);
1085         return (units, subscription, value.sub(subscription));
1086     }
1087 
1088 
1089     function _deposit(address euron_address, uint256 euron_amount, address niwix_address ) private returns (uint256 subscription_value){
1090         _euron.transferFrom(euron_address, address(this), euron_amount);
1091         uint256 subscription_change;
1092         uint256 subscription_units;
1093         (subscription_units, subscription_value, subscription_change) = get_subscription_value(euron_amount);
1094         uint256 niwix_amount = getDepositNiwixValue(euron_amount);
1095 
1096         if(niwix_amount>0){
1097             _niwix.transferFrom(niwix_address, address(this), niwix_amount);
1098         }
1099         if(subscription_change > 0 ){
1100             _euron.transfer(niwix_address, subscription_change);
1101         }
1102         address partner = getPartner(niwix_address);
1103         if (partner != address(0)){
1104             subscribe(partner, subscription_units.mul(_subscription_partner_rate), 0, 0, 0);
1105         }
1106 
1107         subscribe(niwix_address, subscription_units.mul(_subscription_niwix_rate), subscription_units, _subscription_niwix_rate, _subscription_partner_rate );
1108     }
1109 
1110     function depositTo(address address_to, uint256 value) public returns (bool){
1111         require(getWhitelistState(address_to) == Whitelist.STATE_WHITELISTED, "Address needs to be whitelisted");
1112         require(partnerStatus(address_to) == Whitelist.STATE_NEW, "Cannot deposit to partner");
1113         emit DepositTo(address(this), msg.sender, address_to, value);
1114         _deposit(msg.sender, value, address_to);
1115         emit Deposit(address_to, value);
1116         return true;
1117     }
1118 
1119     function deposit(uint256 value) public returns (bool){
1120         require(getWhitelistState(msg.sender) == Whitelist.STATE_WHITELISTED, "You need to be whitelisted");
1121         require(partnerStatus(msg.sender) == Whitelist.STATE_NEW, "Partner cannot deposit");
1122         uint256 amount = value;
1123         if(value == 0){
1124             amount = _euron.allowance(msg.sender, address(this));
1125         }
1126         _deposit(msg.sender, amount, msg.sender);
1127         emit Deposit(msg.sender, amount);
1128     }
1129 
1130     function withdraw(uint256 subscription_id, uint256 value) public returns (bool){
1131         uint256 amount = value;
1132         if(value == 0){
1133             amount = getAvailable(msg.sender, subscription_id);
1134         }
1135         require(amount > 0, "Wrong value or no funds availabe for withdrawal");
1136 
1137         payout(msg.sender, subscription_id, amount);
1138         _niwix.transfer(msg.sender, amount);
1139         emit Withdraw(msg.sender, subscription_id, amount);
1140         return true;
1141     }
1142     /*
1143     function return_withdrawal(uint256 subscription_id, uint256 value ) public returns (bool){
1144         _niwix.transferFrom(msg.sender, address(this), value);
1145         return_payout(msg.sender, subscription_id, value);
1146         emit ReturnRedemption(msg.sender, subscription_id, value);
1147         return true;
1148     }
1149     */
1150     function change_subscribers_address(address from, address to) public onlyOwner returns (bool){
1151         require(getWhitelistState(to) == Whitelist.STATE_WHITELISTED, "To address must be whitelisted");
1152 
1153         _changeSubscriptionOwner(from, to);
1154         emit ChangeSubscriber(from, to);
1155         return true;
1156     }
1157 
1158     function change_address( address to) public returns (bool){
1159         require(getWhitelistState(to) == Whitelist.STATE_WHITELISTED, "To address must be whitelisted");
1160         _changeSubscriptionOwner(msg.sender, to);
1161         emit ChangeSubscriber(msg.sender, to);
1162         return true;
1163     }
1164 
1165 
1166     function redemption(uint256 subscription_id, uint256 amount) public  returns (bool){
1167         address partner = getPartner(msg.sender);
1168         if (partner != address(0)){
1169            partners_redeem(partner, msg.sender, subscription_id, amount);
1170         }
1171 
1172         redeem(msg.sender, subscription_id, amount);
1173         return true;
1174     }
1175 
1176     function topup(uint256 subscription_id, uint256 amount) public  returns (bool){
1177         _niwix.transferFrom(msg.sender, address(this), amount);
1178         top(msg.sender, subscription_id, amount);
1179         return true;
1180     }
1181 
1182     function topupOwner(address to, uint256 subscription_id, uint256 amount) public onlyOwner  returns (bool){
1183         top(to, subscription_id, amount);
1184         return true;
1185     }
1186 
1187 
1188     function transfer(address to, uint256 subscription_id, uint256 amount) public returns (bool)
1189     {
1190 //        Subscription memory subscription = get_subscription(msg.sender, subscription_id);
1191 //        uint256 subscription_certificates = subscription.certificates;
1192         redemption(subscription_id, amount);
1193         subscribe(to, amount.mul(_subscription_niwix_rate), amount, _subscription_niwix_rate, _subscription_partner_rate );
1194         address partner = getPartner(to);
1195         if (partner != address(0)){
1196             subscribe(partner, amount.mul(_subscription_partner_rate), 0, 0, 0);
1197         }
1198 
1199     }
1200 
1201     function viewSubscription(address subscriber, uint256 subscription_id) public view returns(Subscription memory){
1202         if( subscriber == address(0) )
1203         {
1204             return get_global_subscription( subscription_id );
1205         }
1206         return get_subscription(subscriber, subscription_id);
1207     }
1208 
1209 
1210     function reclaimEther(address payable _to) external onlyOwner {
1211         _to.transfer(address(this).balance);
1212     }
1213 
1214     function reclaimToken(IERC20 token, address _to) external onlyOwner {
1215         uint256 balance = token.balanceOf(address(this));
1216         token.transfer(_to, balance);
1217     }
1218 
1219 }