1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) constant returns (uint256);
83   function transfer(address to, uint256 value) returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) returns (bool);
97   function approve(address spender, uint256 value) returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 contract Drainable is Ownable {
103 	function withdrawToken(address tokenaddr) 
104 		onlyOwner 
105 	{
106 		ERC20 token = ERC20(tokenaddr);
107 		uint bal = token.balanceOf(address(this));
108 		token.transfer(msg.sender, bal);
109 	}
110 
111 	function withdrawEther() 
112 		onlyOwner
113 	{
114 	    require(msg.sender.send(this.balance));
115 	}
116 }
117 
118 
119 contract ADXRegistry is Ownable, Drainable {
120 	string public name = "AdEx Registry";
121 
122 	// Structure:
123 	// AdUnit (advertiser) - a unit of a single advertisement
124 	// AdSlot (publisher) - a particular property (slot) that can display an ad unit
125 	// Campaign (advertiser) - group of ad units ; not vital
126 	// Channel (publisher) - group of properties ; not vital
127 	// Each Account is linked to all the items they own through the Account struct
128 
129 	mapping (address => Account) public accounts;
130 
131 	// XXX: mostly unused, because solidity does not allow mapping with enum as primary type.. :( we just use uint
132 	enum ItemType { AdUnit, AdSlot, Campaign, Channel }
133 
134 	// uint here corresponds to the ItemType
135 	mapping (uint => uint) public counts;
136 	mapping (uint => mapping (uint => Item)) public items;
137 
138 	// Publisher or Advertiser (could be both)
139 	struct Account {		
140 		address addr;
141 		address wallet;
142 
143 		bytes32 ipfs; // ipfs addr for additional (larger) meta
144 		bytes32 name; // name
145 		bytes32 meta; // metadata, can be JSON, can be other format, depends on the high-level implementation
146 
147 		bytes32 signature; // signature in the off-blockchain state channel
148 		
149 		// Items, by type, then in an array of numeric IDs	
150 		mapping (uint => uint[]) items;
151 	}
152 
153 	// Sub-item, such as AdUnit, AdSlot, Campaign, Channel
154 	struct Item {
155 		uint id;
156 		address owner;
157 
158 		ItemType itemType;
159 
160 		bytes32 ipfs; // ipfs addr for additional (larger) meta
161 		bytes32 name; // name
162 		bytes32 meta; // metadata, can be JSON, can be other format, depends on the high-level implementation
163 	}
164 
165 	modifier onlyRegistered() {
166 		var acc = accounts[msg.sender];
167 		require(acc.addr != 0);
168 		_;
169 	}
170 
171 	// can be called over and over to update the data
172 	// XXX consider entrance barrier, such as locking in some ADX
173 	function register(bytes32 _name, address _wallet, bytes32 _ipfs, bytes32 _sig, bytes32 _meta)
174 		external
175 	{
176 		require(_wallet != 0);
177 		// XXX should we ensure _sig is not 0? if so, also add test
178 		
179 		require(_name != 0);
180 
181 		var isNew = accounts[msg.sender].addr == 0;
182 
183 		var acc = accounts[msg.sender];
184 
185 		if (!isNew) require(acc.signature == _sig);
186 		else acc.signature = _sig;
187 
188 		acc.addr = msg.sender;
189 		acc.wallet = _wallet;
190 		acc.ipfs = _ipfs;
191 		acc.name = _name;
192 		acc.meta = _meta;
193 
194 		if (isNew) LogAccountRegistered(acc.addr, acc.wallet, acc.ipfs, acc.name, acc.meta, acc.signature);
195 		else LogAccountModified(acc.addr, acc.wallet, acc.ipfs, acc.name, acc.meta, acc.signature);
196 	}
197 
198 	// use _id = 0 to create a new item, otherwise modify existing
199 	function registerItem(uint _type, uint _id, bytes32 _ipfs, bytes32 _name, bytes32 _meta)
200 		onlyRegistered
201 	{
202 		// XXX _type sanity check?
203 		var item = items[_type][_id];
204 
205 		if (_id != 0)
206 			require(item.owner == msg.sender);
207 		else {
208 			// XXX: what about overflow here?
209 			var newId = ++counts[_type];
210 
211 			item = items[_type][newId];
212 			item.id = newId;
213 			item.itemType = ItemType(_type);
214 			item.owner = msg.sender;
215 
216 			accounts[msg.sender].items[_type].push(item.id);
217 		}
218 
219 		item.name = _name;
220 		item.meta = _meta;
221 		item.ipfs = _ipfs;
222 
223 		if (_id == 0) LogItemRegistered(
224 			item.owner, uint(item.itemType), item.id, item.ipfs, item.name, item.meta
225 		);
226 		else LogItemModified(
227 			item.owner, uint(item.itemType), item.id, item.ipfs, item.name, item.meta
228 		);
229 	}
230 
231 	// NOTE
232 	// There's no real point of un-registering items
233 	// Campaigns need to be kept anyway, as well as ad units
234 	// END NOTE
235 
236 	//
237 	// Constant functions
238 	//
239 	function isRegistered(address who)
240 		public 
241 		constant
242 		returns (bool)
243 	{
244 		var acc = accounts[who];
245 		return acc.addr != 0;
246 	}
247 
248 	// Functions exposed for web3 interface
249 	// NOTE: this is sticking to the policy of keeping static-sized values at the left side of tuples
250 	function getAccount(address _acc)
251 		constant
252 		public
253 		returns (address, bytes32, bytes32, bytes32)
254 	{
255 		var acc = accounts[_acc];
256 		require(acc.addr != 0);
257 		return (acc.wallet, acc.ipfs, acc.name, acc.meta);
258 	}
259 
260 	function getAccountItems(address _acc, uint _type)
261 		constant
262 		public
263 		returns (uint[])
264 	{
265 		var acc = accounts[_acc];
266 		require(acc.addr != 0);
267 		return acc.items[_type];
268 	}
269 
270 	function getItem(uint _type, uint _id) 
271 		constant
272 		public
273 		returns (address, bytes32, bytes32, bytes32)
274 	{
275 		var item = items[_type][_id];
276 		require(item.id != 0);
277 		return (item.owner, item.ipfs, item.name, item.meta);
278 	}
279 
280 	function hasItem(uint _type, uint _id)
281 		constant
282 		public
283 		returns (bool)
284 	{
285 		var item = items[_type][_id];
286 		return item.id != 0;
287 	}
288 
289 	// Events
290 	event LogAccountRegistered(address addr, address wallet, bytes32 ipfs, bytes32 accountName, bytes32 meta, bytes32 signature);
291 	event LogAccountModified(address addr, address wallet, bytes32 ipfs, bytes32 accountName, bytes32 meta, bytes32 signature);
292 	
293 	event LogItemRegistered(address owner, uint itemType, uint id, bytes32 ipfs, bytes32 itemName, bytes32 meta);
294 	event LogItemModified(address owner, uint itemType, uint id, bytes32 ipfs, bytes32 itemName, bytes32 meta);
295 }
296 
297 
298 contract ADXExchange is Ownable, Drainable {
299 	string public name = "AdEx Exchange";
300 
301 	ERC20 public token;
302 	ADXRegistry public registry;
303 
304 	uint public bidsCount;
305 
306 	mapping (uint => Bid) bidsById;
307 	mapping (uint => uint[]) bidsByAdunit; // bids set out by ad unit
308 	mapping (uint => uint[]) bidsByAdslot; // accepted by publisher, by ad slot
309 
310 	// TODO: some properties in the bid structure - achievedPoints/peers for example - are not used atm
311 	
312 	// CONSIDER: the bid having a adunitType so that this can be filtered out
313 	// WHY IT'S NOT IMPORTANT: you can get bids by ad units / ad slots, which is filter enough already considering we know their types
314 
315 	// CONSIDER: locking ad units / ad slots or certain properties from them so that bids cannot be ruined by editing them
316 	// WHY IT'S NOT IMPORTANT: from a game theoretical point of view there's no incentive to do that
317 
318 	// corresponds to enum types in ADXRegistry
319 	uint constant ADUNIT = 0;
320 	uint constant ADSLOT = 1;
321 
322 	enum BidState { 
323 		Open, 
324 		Accepted, // in progress
325 
326 		// the following states MUST unlock the ADX amount (return to advertiser)
327 		// fail states
328 		Canceled,
329 		Expired,
330 
331 		// success states
332 		Completed,
333 		Claimed
334 	}
335 
336 	struct Bid {
337 		uint id;
338 		BidState state;
339 
340 		// ADX reward amount
341 		uint amount;
342 
343 		// Links on advertiser side
344 		address advertiser;
345 		address advertiserWallet;
346 		uint adUnit;
347 		bytes32 adUnitIpfs;
348 		bytes32 advertiserPeer;
349 
350 		// Links on publisher side
351 		address publisher;
352 		address publisherWallet;
353 		uint adSlot;
354 		bytes32 adSlotIpfs;
355 		bytes32 publisherPeer;
356 
357 		uint acceptedTime; // when was it accepted by a publisher
358 
359 		// Requirements
360 
361 		//RequirementType type;
362 		uint requiredPoints; // how many impressions/clicks/conversions have to be done
363 		uint requiredExecTime; // essentially a timeout
364 
365 		// Results
366 		bool confirmedByPublisher;
367 		bool confirmedByAdvertiser;
368 
369 		// IPFS links to result reports 
370 		bytes32 publisherReportIpfs;
371 		bytes32 advertiserReportIpfs;
372 	}
373 
374 	//
375 	// MODIFIERS
376 	//
377 	modifier onlyRegisteredAcc() {
378 		require(registry.isRegistered(msg.sender));
379 		_;
380 	}
381 
382 	modifier onlyBidOwner(uint _bidId) {
383 		require(msg.sender == bidsById[_bidId].advertiser);
384 		_;
385 	}
386 
387 	modifier onlyBidAceptee(uint _bidId) {
388 		require(msg.sender == bidsById[_bidId].publisher);
389 		_;
390 	}
391 
392 	modifier onlyBidState(uint _bidId, BidState _state) {
393 		require(bidsById[_bidId].id != 0);
394 		require(bidsById[_bidId].state == _state);
395 		_;
396 	}
397 
398 	modifier onlyExistingBid(uint _bidId) {
399 		require(bidsById[_bidId].id != 0);
400 		_;
401 	}
402 
403 	// Functions
404 
405 	function ADXExchange(address _token, address _registry)
406 	{
407 		token = ERC20(_token);
408 		registry = ADXRegistry(_registry);
409 	}
410 
411 	//
412 	// Bid actions
413 	// 
414 
415 	// the bid is placed by the advertiser
416 	function placeBid(uint _adunitId, uint _target, uint _rewardAmount, uint _timeout, bytes32 _peer)
417 		onlyRegisteredAcc
418 	{
419 		bytes32 adIpfs;
420 		address advertiser;
421 		address advertiserWallet;
422 
423 		// NOTE: those will throw if the ad or respectively the account do not exist
424 		(advertiser,adIpfs,,) = registry.getItem(ADUNIT, _adunitId);
425 		(advertiserWallet,,,) = registry.getAccount(advertiser);
426 
427 		// XXX: maybe it could be a feature to allow advertisers bidding on other advertisers' ad units, but it will complicate things...
428 		require(advertiser == msg.sender);
429 
430 		Bid memory bid;
431 
432 		bid.id = ++bidsCount; // start from 1, so that 0 is not a valid ID
433 		bid.state = BidState.Open; // XXX redundant, but done for code clarity
434 
435 		bid.amount = _rewardAmount;
436 
437 		bid.advertiser = advertiser;
438 		bid.advertiserWallet = advertiserWallet;
439 
440 		bid.adUnit = _adunitId;
441 		bid.adUnitIpfs = adIpfs;
442 
443 		bid.requiredPoints = _target;
444 		bid.requiredExecTime = _timeout;
445 
446 		bid.advertiserPeer = _peer;
447 
448 		bidsById[bid.id] = bid;
449 		bidsByAdunit[_adunitId].push(bid.id);
450 
451 		require(token.transferFrom(advertiserWallet, address(this), _rewardAmount));
452 
453 		LogBidOpened(bid.id, advertiser, _adunitId, adIpfs, _target, _rewardAmount, _timeout, _peer);
454 	}
455 
456 	// the bid is canceled by the advertiser
457 	function cancelBid(uint _bidId)
458 		onlyRegisteredAcc
459 		onlyExistingBid(_bidId)
460 		onlyBidOwner(_bidId)
461 		onlyBidState(_bidId, BidState.Open)
462 	{
463 		Bid storage bid = bidsById[_bidId];
464 		bid.state = BidState.Canceled;
465 		require(token.transfer(bid.advertiserWallet, bid.amount));
466 
467 		LogBidCanceled(bid.id);
468 	}
469 
470 	// a bid is accepted by a publisher for a given ad slot
471 	function acceptBid(uint _bidId, uint _slotId, bytes32 _peer) 
472 		onlyRegisteredAcc 
473 		onlyExistingBid(_bidId) 
474 		onlyBidState(_bidId, BidState.Open)
475 	{
476 		address publisher;
477 		address publisherWallet;
478 		bytes32 adSlotIpfs;
479 
480 		// NOTE: those will throw if the ad slot or respectively the account do not exist
481 		(publisher,adSlotIpfs,,) = registry.getItem(ADSLOT, _slotId);
482 		(publisherWallet,,,) = registry.getAccount(publisher);
483 
484 		require(publisher == msg.sender);
485 
486 		Bid storage bid = bidsById[_bidId];
487 
488 		// should not happen when bid.state is BidState.Open, but just in case
489 		require(bid.publisher == 0);
490 
491 		bid.state = BidState.Accepted;
492 		
493 		bid.publisher = publisher;
494 		bid.publisherWallet = publisherWallet;
495 
496 		bid.adSlot = _slotId;
497 		bid.adSlotIpfs = adSlotIpfs;
498 
499 		bid.publisherPeer = _peer;
500 
501 		bid.acceptedTime = now;
502 
503 		bidsByAdslot[_slotId].push(_bidId);
504 
505 		LogBidAccepted(bid.id, publisher, _slotId, adSlotIpfs, bid.acceptedTime, bid.publisherPeer);
506 	}
507 
508 	// the bid is given up by the publisher, therefore canceling it and returning the funds to the advertiser
509 	// same logic as cancelBid(), but different permissions
510 	function giveupBid(uint _bidId)
511 		onlyRegisteredAcc
512 		onlyExistingBid(_bidId)
513 		onlyBidAceptee(_bidId)
514 		onlyBidState(_bidId, BidState.Accepted)
515 	{
516 		var bid = bidsById[_bidId];
517 		bid.state = BidState.Canceled;
518 		require(token.transfer(bid.advertiserWallet, bid.amount));
519 
520 		LogBidCanceled(bid.id);
521 	}
522 
523 	// both publisher and advertiser have to call this for a bid to be considered verified
524 	function verifyBid(uint _bidId, bytes32 _report)
525 		onlyRegisteredAcc
526 		onlyExistingBid(_bidId)
527 		onlyBidState(_bidId, BidState.Accepted)
528 	{
529 		Bid storage bid = bidsById[_bidId];
530 
531 		require(bid.publisher == msg.sender || bid.advertiser == msg.sender);
532 
533 		if (bid.publisher == msg.sender) {
534 			bid.confirmedByPublisher = true;
535 			bid.publisherReportIpfs = _report;
536 		}
537 
538 		if (bid.advertiser == msg.sender) {
539 			bid.confirmedByAdvertiser = true;
540 			bid.advertiserReportIpfs = _report;
541 		}
542 
543 		if (bid.confirmedByAdvertiser && bid.confirmedByPublisher) {
544 			bid.state = BidState.Completed;
545 			LogBidCompleted(bid.id, bid.advertiserReportIpfs, bid.publisherReportIpfs);
546 		}
547 	}
548 
549 	// now, claim the reward; callable by the publisher;
550 	// claimBidReward is a separate function so as to define clearly who pays the gas for transfering the reward 
551 	function claimBidReward(uint _bidId)
552 		onlyRegisteredAcc
553 		onlyExistingBid(_bidId)
554 		onlyBidAceptee(_bidId)
555 		onlyBidState(_bidId, BidState.Completed)
556 	{
557 		Bid storage bid = bidsById[_bidId];
558 		
559 		bid.state = BidState.Claimed;
560 
561 		require(token.transfer(bid.publisherWallet, bid.amount));
562 
563 		LogBidRewardClaimed(bid.id, bid.publisherWallet, bid.amount);
564 	}
565 
566 	// This can be done if a bid is accepted, but expired
567 	// This is essentially the protection from never settling on verification, or from publisher not executing the bid within a reasonable time
568 	function refundBid(uint _bidId)
569 		onlyRegisteredAcc
570 		onlyExistingBid(_bidId)
571 		onlyBidOwner(_bidId)
572 		onlyBidState(_bidId, BidState.Accepted)
573 	{
574 		Bid storage bid = bidsById[_bidId];
575 		require(bid.requiredExecTime > 0); // you can't refund if you haven't set a timeout
576 		require(SafeMath.add(bid.acceptedTime, bid.requiredExecTime) < now);
577 
578 		bid.state = BidState.Expired;
579 		require(token.transfer(bid.advertiserWallet, bid.amount));
580 
581 		LogBidExpired(bid.id);
582 	}
583 
584 	//
585 	// Public constant functions
586 	//
587 
588 	function getBidsFromArr(uint[] arr, uint _state) 
589 		internal
590 		returns (uint[] _all)
591 	{
592 		BidState state = BidState(_state);
593 
594 		// separate array is needed because of solidity stupidity (pun intended ))) )
595 		uint[] memory all = new uint[](arr.length);
596 
597 		uint count = 0;
598 		uint i;
599 
600 		for (i = 0; i < arr.length; i++) {
601 			var id = arr[i];
602 			var bid = bidsById[id];
603 			if (bid.state == state) {
604 				all[count] = id;
605 				count += 1;
606 			}
607 		}
608 
609 		_all = new uint[](count);
610 		for (i = 0; i < count; i++) _all[i] = all[i];
611 	}
612 
613 	function getAllBidsByAdunit(uint _adunitId) 
614 		constant 
615 		external
616 		returns (uint[])
617 	{
618 		return bidsByAdunit[_adunitId];
619 	}
620 
621 	function getBidsByAdunit(uint _adunitId, uint _state)
622 		constant
623 		external
624 		returns (uint[])
625 	{
626 		return getBidsFromArr(bidsByAdunit[_adunitId], _state);
627 	}
628 
629 	function getAllBidsByAdslot(uint _adslotId) 
630 		constant 
631 		external
632 		returns (uint[])
633 	{
634 		return bidsByAdslot[_adslotId];
635 	}
636 
637 	function getBidsByAdslot(uint _adslotId, uint _state)
638 		constant
639 		external
640 		returns (uint[])
641 	{
642 		return getBidsFromArr(bidsByAdslot[_adslotId], _state);
643 	}
644 
645 	function getBid(uint _bidId) 
646 		onlyExistingBid(_bidId)
647 		constant
648 		external
649 		returns (
650 			uint, uint, uint, uint, uint, 
651 			// advertiser (ad unit, ipfs, peer)
652 			uint, bytes32, bytes32,
653 			// publisher (ad slot, ipfs, peer)
654 			uint, bytes32, bytes32
655 		)
656 	{
657 		var bid = bidsById[_bidId];
658 		return (
659 			uint(bid.state), bid.requiredPoints, bid.requiredExecTime, bid.amount, bid.acceptedTime,
660 			bid.adUnit, bid.adUnitIpfs, bid.advertiserPeer,
661 			bid.adSlot, bid.adSlotIpfs, bid.publisherPeer
662 		);
663 	}
664 
665 	function getBidReports(uint _bidId)
666 		onlyExistingBid(_bidId)
667 		constant
668 		external
669 		returns (
670 			bytes32, // advertiser report
671 			bytes32 // publisher report
672 		)
673 	{
674 		var bid = bidsById[_bidId];
675 		return (bid.advertiserReportIpfs, bid.publisherReportIpfs);
676 	}
677 
678 	//
679 	// Events
680 	//
681 	event LogBidOpened(uint bidId, address advertiser, uint adunitId, bytes32 adunitIpfs, uint target, uint rewardAmount, uint timeout, bytes32 advertiserPeer);
682 	event LogBidAccepted(uint bidId, address publisher, uint adslotId, bytes32 adslotIpfs, uint acceptedTime, bytes32 publisherPeer);
683 	event LogBidCanceled(uint bidId);
684 	event LogBidExpired(uint bidId);
685 	event LogBidCompleted(uint bidId, bytes32 advReport, bytes32 pubReport);
686 	event LogBidRewardClaimed(uint _bidId, address _wallet, uint _amount);
687 }