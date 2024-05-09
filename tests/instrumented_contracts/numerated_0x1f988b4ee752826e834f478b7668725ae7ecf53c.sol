1 // Implementation of the U42 Token Specification -- see "U42 Token Specification.md"
2 //
3 // Standard ERC-20 methods and the SafeMath library are adapated from OpenZeppelin's standard contract types
4 // as at https://github.com/OpenZeppelin/openzeppelin-solidity/commit/5daaf60d11ee2075260d0f3adfb22b1c536db983
5 // note that uint256 is used explicitly in place of uint
6 
7 pragma solidity ^0.4.24;
8 
9 //safemath extensions added to uint256
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (a == 0) {
24       return 0;
25     }
26 
27     c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     // uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return a / b;
40   }
41 
42   /**
43   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
54     c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract U42 {
61 	//use OZ SafeMath to avoid uint256 overflows
62 	using SafeMath for uint256;
63 
64 	string public constant name = "U42";
65 	string public constant symbol = "U42";
66 	uint8 public constant decimals = 18;
67 	uint256 public constant initialSupply = 525000000 * (10 ** uint256(decimals));
68 	uint256 internal totalSupply_ = initialSupply;
69 	address public contractOwner;
70 
71 	//token balances
72 	mapping(address => uint256) balances;
73 
74 	//for each balance address, map allowed addresses to amount allowed
75 	mapping (address => mapping (address => uint256)) internal allowed;
76 
77 	//each service is represented by a Service struct 
78 	struct Service {
79 		address applicationAddress;
80 		uint32 serviceId;
81 		bool isSimple;
82 		string serviceDescription;
83 		uint256 tokensPerCredit;
84 		uint256 maxCreditsPerProvision;
85 		address updateAddress;
86 		address receiptAddress;
87 		bool isRemoved;
88 		uint256 provisionHead;
89 	}
90 
91 	struct Provision {
92 		uint256 tokensPerCredit;
93 		uint256 creditsRemaining;
94 		uint256 applicationReference;
95 		address userAddress;
96 		uint256 creditsProvisioned;
97 	}
98 
99 	//mapping of application addresses to service structs
100 	mapping (address => mapping (uint32 => Service)) services;
101 
102 	//mapping of application addresses to service structs to provisions
103 	mapping (address => mapping (uint32 => mapping (uint256 => Provision))) provisions;
104 
105 	//mapping of application addresses to lists of services
106 	mapping (address => uint32[]) servicesLists;
107 
108 	//mapping of application addresses to lists of removed services
109 	mapping (address => uint32[]) servicesRemovedLists;
110 
111 	//methods emit the following events
112 	event Transfer (
113 		address indexed from, 
114 		address indexed to, 
115 		uint256 value );
116 
117 	event TokensBurned (
118 		address indexed burner, 
119 		uint256 value );
120 
121 	event Approval (
122 		address indexed owner,
123 		address indexed spender,
124 		uint256 value );
125 
126 	event NewService (
127 		address indexed applicationAddress,
128 		uint32 serviceId );
129 
130 	event ServiceChanged (
131 		address indexed applicationAddress,
132 		uint32 serviceId );
133 
134 	event ServiceRemoved (
135 		address indexed applicationAddress,
136 		uint32 serviceId );
137 
138 	event CompleteSimpleProvision (
139 		address indexed applicationAddress,
140 		uint32 indexed serviceId,
141 		address indexed userAddress,
142 		uint256 multiple,
143 		uint256 applicationReference );
144 
145 	event ReferenceConfirmed (
146 		address indexed applicationAddress,
147 		uint256 indexed applicationReference, 
148 		address indexed confirmedBy, 
149 		uint256 confirmerTokensMinimum );
150 
151 	event StartProvision (
152 	    address indexed applicationAddress, 
153 	    uint32 indexed serviceId, 
154 	    address indexed userAddress,
155 	    uint256 provisionId,
156 	    uint256 serviceCredits,
157 	    uint256 tokensPerCredit, 
158 	    uint256 applicationReference );
159 
160 	event UpdateProvision (
161 	    address indexed applicationAddress,
162 	    uint32 indexed serviceId,
163 	    uint256 indexed provisionId,
164 	    uint256 creditsRemaining );
165 
166 	event CompleteProvision (
167 	    address indexed applicationAddress,
168 	    uint32 indexed serviceId,
169 	    uint256 indexed provisionId,
170 	    uint256 creditsOutstanding );
171 
172 	event SignalProvisionRefund (
173 	    address indexed applicationAddress,
174 	    uint32 indexed serviceId,
175 	    uint256 indexed provisionId,
176 	    uint256 tokenValue );
177 
178 	event TransferBecauseOf (
179 		address indexed applicationAddress,
180 	    uint32 indexed serviceId,
181 	    uint256 indexed provisionId,
182 	    address from,
183 	    address to,
184 	    uint256 value );
185 
186 	event TransferBecauseOfAggregate (
187 		address indexed applicationAddress,
188 	    uint32 indexed serviceId,
189 	    uint256[] provisionIds,
190 	    uint256[] tokenAmounts,
191 	    address from,
192 	    address to,
193 	    uint256 value );
194 
195 
196 	constructor() public {
197 		//contract creator holds all tokens at creation
198 		balances[msg.sender] = totalSupply_;
199 
200 		//record contract owner for later reference (e.g. in ownerBurn)
201 		contractOwner=msg.sender;
202 
203 		//indicate all tokens were sent to contract address
204 		emit Transfer(address(0), msg.sender, totalSupply_);
205 	}
206 
207 	function listSimpleService ( 
208 			uint32 _serviceId, 
209 			string _serviceDescription,
210 			uint256 _tokensRequired,
211 			address _updateAddress,
212 			address _receiptAddress	) 
213 		public returns (
214 			bool success ) {
215 
216 		//check service id is not 0
217 		require(_serviceId != 0);
218 
219 		//check service doesn't already exist for this application id
220 		require(services[msg.sender][_serviceId].applicationAddress == 0);
221 
222 		//check cost of the service is >0 
223 		require(_tokensRequired != 0);
224 
225 		//check receiptAddress is not address(0)
226 		require(_receiptAddress != address(0));
227 
228 		//update address should be address(0) or a non-sender address
229 		require(_updateAddress != msg.sender);
230 
231 		//add service to services mapping
232 		services[msg.sender][_serviceId] = Service(
233 				msg.sender,
234 				_serviceId,
235 				true,
236 				_serviceDescription,
237 				_tokensRequired,
238 				1,
239 				_updateAddress,
240 				_receiptAddress,
241 				false,
242 				0
243 			);
244 
245 		//add service to servicesLists for application
246 		servicesLists[msg.sender].push(_serviceId);
247 
248 		//emit NewService
249 		emit NewService(msg.sender, _serviceId);
250 
251 		return true;
252 	}
253 
254 	function listService ( 
255 			uint32 _serviceId, 
256 			string _serviceDescription,
257 			uint256 _tokensPerCredit,
258 			uint256 _maxCreditsPerProvision,
259 			address _updateAddress,
260 			address _receiptAddress	) 
261 		public returns (
262 			bool success ) {
263 
264 		//check service id is not 0
265 		require(_serviceId != 0);
266 
267 		//check service doesn't already exist for this application id
268 		require(services[msg.sender][_serviceId].applicationAddress == 0);
269 
270 		//check cost of the service is >0 
271 		require(_tokensPerCredit != 0);
272 
273 		//check receiptAddress is not address(0)
274 		require(_receiptAddress != address(0));
275 
276 		//update address should be address(0) or a non-sender address
277 		require(_updateAddress != msg.sender);
278 
279 		//add service to services mapping
280 		services[msg.sender][_serviceId] = Service(
281 				msg.sender,
282 				_serviceId,
283 				false,
284 				_serviceDescription,
285 				_tokensPerCredit,
286 				_maxCreditsPerProvision,
287 				_updateAddress,
288 				_receiptAddress,
289 				false,
290 				0
291 			);
292 
293 		//add service to servicesLists for application
294 		servicesLists[msg.sender].push(_serviceId);
295 
296 		//emit NewService
297 		emit NewService(msg.sender, _serviceId);
298 
299 		return true;
300 	}
301 
302 	function getServicesForApplication ( 
303 			address _applicationAddress ) 
304 		public view returns (
305 			uint32[] serviceIds ) {
306 
307 		return servicesLists[_applicationAddress];
308 	}
309 
310 	function getRemovedServicesForApplication (
311 			address _applicationAddress ) 
312 		public view returns (
313 			uint32[] serviceIds ) {
314 
315 		return servicesRemovedLists[_applicationAddress];
316 	}
317 
318 	function isServiceRemoved (
319 			address _applicationAddress,
320 			uint32 _serviceId )
321 		public view returns (
322 			bool ) {
323 
324 		//returns true if service has been removed
325 		return services[_applicationAddress][_serviceId].isRemoved;
326 	}
327 
328 	function getServiceInformation ( 
329 			address _applicationAddress, 
330 			uint32 _serviceId )
331 		public view returns (
332 			bool exists,
333 			bool isSimple,
334 			string serviceDescription,
335 			uint256 tokensPerCredit,
336 			uint256 maxCreditsPerProvision,
337 			address receiptAddress,
338 			bool isRemoved,
339 			uint256 provisionHead ) {
340 
341 		Service storage s=services[_applicationAddress][_serviceId];
342 
343 		//services with unset application address indicates an empty/unset struct in the mapping
344 		if(s.applicationAddress == 0) {
345 			//first return parameter indicates whether the service exists
346 			exists=false;
347 			return;
348 
349 		} else {
350 			exists=true;
351 			isSimple=s.isSimple;
352 			//note that the returned service description can't be read in solidity funtion call
353 			serviceDescription=s.serviceDescription;
354 			tokensPerCredit=s.tokensPerCredit;
355 			maxCreditsPerProvision=s.maxCreditsPerProvision;
356 			receiptAddress=s.receiptAddress;
357 			isRemoved=s.isRemoved;
358 			provisionHead=s.provisionHead;
359 
360 			return;
361 		}
362 	}
363 
364 	function getServiceUpdateAddress (
365 			address _applicationAddress, 
366 			uint32 _serviceId ) 
367 		public view returns (
368 			address updateAddress ) {
369 
370 		Service storage s=services[_applicationAddress][_serviceId];
371 
372 		return s.updateAddress;
373 	}
374 
375 	function updateServiceDescription (
376 			address _targetApplicationAddress, 
377 			uint32 _serviceId, 
378 			string _serviceDescription ) 
379 		public returns (
380 			bool success ) {
381 
382 		//get the referenced service
383 		Service storage s=services[_targetApplicationAddress][_serviceId];
384 
385 		//check that service exists
386 		require(s.applicationAddress != 0);
387 
388 		//update must be by the application address or, if specified, update address
389 		require(msg.sender == _targetApplicationAddress || 
390 			( s.updateAddress != address(0) && msg.sender == s.updateAddress ));
391 
392 		//check that service is not removed
393 		require(s.isRemoved == false);
394 
395 		services[_targetApplicationAddress][_serviceId].serviceDescription=_serviceDescription;
396 		
397 		emit ServiceChanged(_targetApplicationAddress, _serviceId);
398 
399 		return true;
400 	}
401 
402 	function updateServiceTokensPerCredit (
403 			address _targetApplicationAddress, 
404 			uint32 _serviceId, 
405 			uint256 _tokensPerCredit ) 
406 		public returns (
407 			bool success ) {
408 
409 		//get the referenced service
410 		Service storage s=services[_targetApplicationAddress][_serviceId];
411 
412 		//check that service exists
413 		require(s.applicationAddress != 0);
414 
415 		//update must be by the application address or, if specified, update address
416 		require(msg.sender == _targetApplicationAddress || 
417 			( s.updateAddress != address(0) && msg.sender == s.updateAddress ));
418 
419 		//check that service is not removed
420 		require(s.isRemoved == false);
421 
422 		//check changed cost of the service is >0 
423 		require(_tokensPerCredit != 0);
424 
425 		services[_targetApplicationAddress][_serviceId].tokensPerCredit=_tokensPerCredit;
426 		
427 		emit ServiceChanged(_targetApplicationAddress, _serviceId);
428 
429 		return true;		
430 	}
431 
432 	function updateServiceMaxCreditsPerProvision (
433 			address _targetApplicationAddress,
434 			uint32 _serviceId,
435 			uint256 _maxCreditsPerProvision )
436 		public returns (
437 			bool sucess ) {
438 
439 		//get the referenced service
440 		Service storage s=services[_targetApplicationAddress][_serviceId];
441 
442 		//check that service exists
443 		require(s.applicationAddress != 0);
444 
445 		//update must be by the application address or, if specified, update address
446 		require(msg.sender == _targetApplicationAddress || 
447 			( s.updateAddress != address(0) && msg.sender == s.updateAddress ));
448 
449 		//check that service is not removed
450 		require(s.isRemoved == false);
451 
452 		//note that credits per provision can be == 0 (no limit)
453 
454 		//change max credits per provision for this service
455 		services[_targetApplicationAddress][_serviceId].maxCreditsPerProvision=_maxCreditsPerProvision;
456 
457 		emit ServiceChanged(_targetApplicationAddress, _serviceId);
458 	
459 		return true;		
460 	}
461 
462 	function changeServiceReceiptAddress(
463 			uint32 _serviceId, 
464 			address _receiptAddress ) 
465 		public returns (
466 			bool success ) {
467 
468 		//receipt address can only be changed by application address
469 
470 		//check that service exists
471 		require(services[msg.sender][_serviceId].applicationAddress != 0);
472 
473 		//check that service is not removed
474 		require(services[msg.sender][_serviceId].isRemoved == false);
475 
476 		//check changed receiptAddress is not address(0)
477 		require(_receiptAddress != address(0));
478 
479 		services[msg.sender][_serviceId].receiptAddress=_receiptAddress;
480 		
481 		emit ServiceChanged(msg.sender, _serviceId);
482 
483 		return true;		
484 	}
485 
486 	function changeServiceUpdateAddress (
487 			uint32 _serviceId,
488 			address _updateAddress )
489 		public returns (
490 			bool success ) {
491 
492 		//update address can only be changed by application address
493 
494 		//check that service exists
495 		require(services[msg.sender][_serviceId].applicationAddress != 0);
496 
497 		//check that service is not removed
498 		require(services[msg.sender][_serviceId].isRemoved == false);
499 
500 		//note: update address can be address(0)
501 		//change the update address
502 		services[msg.sender][_serviceId].updateAddress=_updateAddress;
503 
504 		emit ServiceChanged(msg.sender, _serviceId);
505 
506 		return true;
507 	}
508 
509 	function removeService (
510 			address _targetApplicationAddress, 
511 			uint32 _serviceId ) 
512 		public returns (
513 			bool success ) {
514 
515 		//check that service exists
516 		require(services[_targetApplicationAddress][_serviceId].applicationAddress != 0);
517 
518 		//update must be by the application address or, if specified, update address
519 		require(msg.sender == _targetApplicationAddress || 
520 			( services[_targetApplicationAddress][_serviceId].updateAddress != address(0) 
521 			   && msg.sender == services[_targetApplicationAddress][_serviceId].updateAddress 
522 			  ));
523 
524 		//check that service is not already removed
525 		require(services[_targetApplicationAddress][_serviceId].isRemoved == false);
526 
527 		//add to removed array
528 		servicesRemovedLists[_targetApplicationAddress].push(_serviceId);
529 
530 		//change value of isRemoved to true
531 		services[_targetApplicationAddress][_serviceId].isRemoved = true;
532 
533 		emit ServiceRemoved(_targetApplicationAddress, _serviceId);
534 
535 		return true;
536 	}
537 
538 	function transferToSimpleService (
539 			address _applicationAddress, 
540 			uint32 _serviceId, 
541 			uint256 _tokenValue, 
542 			uint256 _applicationReference, 
543 			uint256 _multiple ) 
544 		public returns (
545 			bool success ) {
546 
547 		//requested multiple must be >= 1
548 		require(_multiple > 0);
549 
550 		//get the referenced service
551 		Service storage s=services[_applicationAddress][_serviceId];
552 
553 		//service must exist
554 		require(s.applicationAddress != 0);
555 
556 		//check that service is not removed
557 		require(services[_applicationAddress][_serviceId].isRemoved == false);
558 
559 		//check that service is a simple service
560 		require(s.isSimple == true);
561 
562 		//expected value is the token cost of the service multiplied by the requested multiple
563 		uint256 expectedValue=s.tokensPerCredit.mul(_multiple);
564 
565 		//supplied token value must equal expected value
566 		require(expectedValue == _tokenValue);
567 
568 		//transfer the tokens -- this verifies the sender owns the tokens
569 		transfer(s.receiptAddress, _tokenValue);
570 
571 		//this starts and ends a simple provision at a single point in time 
572 		emit CompleteSimpleProvision(_applicationAddress, _serviceId, msg.sender, _multiple, _applicationReference);
573 
574 		return true;
575 	}
576 
577 
578 	function transferToService (
579 			address _applicationAddress, 
580 			uint32 _serviceId, 
581 			uint256 _tokenValue, 
582 			uint256 _credits,
583 			uint256 _applicationReference ) 
584 		public returns (
585 			uint256 provisionId ) {
586 
587 		//get the referenced service
588 		Service storage s=services[_applicationAddress][_serviceId];
589 
590 		//service must exist
591 		require(s.applicationAddress != 0);
592 
593 		//check that service is not removed
594 		require(services[_applicationAddress][_serviceId].isRemoved == false);
595 
596 		//check that service is not a simple service
597 		require(s.isSimple == false);
598 
599 		//verify: value == credits * tokens per credit
600 		require(_tokenValue == (_credits.mul(s.tokensPerCredit)));
601 
602 		//verify: max credits == 0 OR (value/tokens per credit) <= max credits per provision
603 		require( s.maxCreditsPerProvision == 0 ||
604 			_credits <= s.maxCreditsPerProvision);
605 
606 		//increment provision head and use as provision id
607 		s.provisionHead++;
608 		uint256 pid = s.provisionHead;
609 
610 		//create provision in mapping
611 		provisions[_applicationAddress][_serviceId][pid] = Provision (
612 				s.tokensPerCredit,
613 				_credits,
614 				_applicationReference,
615 				msg.sender,
616 				_credits		
617 			);
618 
619 		//transfer the tokens
620 		transfer(s.receiptAddress, _tokenValue);
621 
622 		//emits a start provision 
623 		emit StartProvision(_applicationAddress, _serviceId, msg.sender, pid, _credits, s.tokensPerCredit, _applicationReference);
624 
625 		//return provision id
626 		return pid;
627 	}
628 
629 	function getProvisionCreditsRemaining (
630 			address _applicationAddress,
631 			uint32 _serviceId,
632 		    uint256 _provisionId )
633 		public view returns (
634 			uint256 credits) {
635 
636 		//get the referenced service
637 		Service storage s=services[_applicationAddress][_serviceId];
638 
639 		//service must exist
640 		require(s.applicationAddress != 0);
641 
642 		//check that service is not removed
643 		require(services[_applicationAddress][_serviceId].isRemoved == false);		
644 
645 		//get & check that the provision exists (address at userAddress)
646 		Provision storage p=provisions[_applicationAddress][_serviceId][_provisionId];
647 		require(p.userAddress != 0);
648 
649 		//return the credits remaining for this provision
650 		return p.creditsRemaining;
651 	}
652 
653 	function updateProvision (
654 		    address _applicationAddress,
655 		    uint32 _serviceId,
656 		    uint256 _provisionId,
657 		    uint256 _creditsRemaining )
658 		public returns (
659 			bool success ) {
660 
661 		//credits remaining must be >0, complete provision should be used to set to 0
662 		require(_creditsRemaining > 0);
663 
664 		//get the referenced service
665 		Service storage s=services[_applicationAddress][_serviceId];
666 
667 		//check that service exists
668 		require(s.applicationAddress != 0);
669 
670 		//update must be by the application address or, if specified, update address
671 		require(msg.sender == _applicationAddress || 
672 			( s.updateAddress != address(0) && msg.sender == s.updateAddress ));
673 
674 		//check that service is not removed
675 		require(s.isRemoved == false);
676 
677 		//get & check that the provision exists (address at userAddress)
678 		Provision storage p=provisions[_applicationAddress][_serviceId][_provisionId];
679 		require(p.userAddress != 0);
680 
681 		//update the credits remaining
682 		p.creditsRemaining=_creditsRemaining;
683 	
684 		//fires UpdateProvision
685 		emit UpdateProvision(_applicationAddress, _serviceId, _provisionId, _creditsRemaining);
686 
687 		return true;		
688 	}
689 
690 	function completeProvision (
691 		    address _applicationAddress,
692 		    uint32 _serviceId,
693 		    uint256 _provisionId,
694 		    uint256 _creditsOutstanding )
695 		public returns (
696 			bool success ) {
697 
698 		//get the referenced service
699 		Service storage s=services[_applicationAddress][_serviceId];
700 
701 		//check that service exists
702 		require(s.applicationAddress != 0);
703 
704 		//update must be by the application address or, if specified, update address
705 		require(msg.sender == _applicationAddress || 
706 			( s.updateAddress != address(0) && msg.sender == s.updateAddress ));
707 
708 		//check that service is not removed
709 		require(s.isRemoved == false);
710 
711 		//get & check that the provision exists (address at userAddress)
712 		Provision storage p=provisions[_applicationAddress][_serviceId][_provisionId];
713 		require(p.userAddress != 0);
714 
715 		if(_creditsOutstanding > 0) {
716 			//can only signal refund total of credits originally provisioned
717 			require(_creditsOutstanding <= p.creditsProvisioned);
718 
719 			emit SignalProvisionRefund(_applicationAddress, _serviceId, _provisionId, _creditsOutstanding.mul(p.tokensPerCredit));
720 		}
721 
722 		//credits remaining on service is set to 0
723 		p.creditsRemaining=0;
724 
725 		//fires CompleteProvision
726 		emit CompleteProvision(_applicationAddress, _serviceId, _provisionId, _creditsOutstanding);
727 
728 		return true;
729 	}
730 
731 
732 	function confirmReference (
733 			address _applicationAddress,
734 			uint256 _applicationReference,
735 			uint256 _senderTokensMinimum )
736 		public returns (
737 			bool success ) {
738 
739 		//sender must have some tokens - if 0 is passed to _senderTokensMinimum
740 		//then it is assumed that the method is checking that the sender has any amount
741 		//of tokens (>0)
742 		require(balances[msg.sender] > 0);
743 
744 		//sender must have min tokens if specified
745 		require(_senderTokensMinimum == 0 
746 			|| balances[msg.sender] >= _senderTokensMinimum);
747 
748 		emit ReferenceConfirmed(_applicationAddress, _applicationReference, msg.sender, _senderTokensMinimum);
749 
750 		return true;
751 	}
752 
753 
754 	function transferBecauseOf (
755 		    address _to,
756 		    uint256 _value,
757 		    address _applicationAddress,
758 		    uint32 _serviceId,
759 		    uint256 _provisionId )
760 		public returns (
761 			bool success ) {
762 
763 		//get the referenced service
764 		Service storage s=services[_applicationAddress][_serviceId];
765 
766 		//check that service exists
767 		require(s.applicationAddress != 0);
768 
769 		//check that service is not removed
770 		require(s.isRemoved == false);
771 
772 		//provision ID can be optional, but if it's supplied it must exist
773 		if(_provisionId != 0) {
774 			//get & check that the provision exists (address at userAddress)
775 			Provision storage p=provisions[_applicationAddress][_serviceId][_provisionId];
776 			require(p.userAddress != 0);
777 		}
778 
779 		//do the transfer
780 		transfer(_to, _value);
781 
782 		emit TransferBecauseOf(_applicationAddress, _serviceId, _provisionId, msg.sender, _to, _value);
783 
784 		return true;
785 	}
786 
787 
788 	function transferBecauseOfAggregate (
789 		    address _to,
790 		    uint256 _value,
791 		    address _applicationAddress,
792 		    uint32 _serviceId,
793 		    uint256[] _provisionIds,
794 		    uint256[] _tokenAmounts )
795 		public returns (
796 			bool success ) {
797 
798 		//get the referenced service
799 		Service storage s=services[_applicationAddress][_serviceId];
800 
801 		//check that service exists
802 		require(s.applicationAddress != 0);
803 
804 		//check that service is not removed
805 		require(s.isRemoved == false);
806 
807 		//do the transfer
808 		transfer(_to, _value);
809 
810 		emit TransferBecauseOfAggregate(_applicationAddress, _serviceId, _provisionIds, _tokenAmounts, msg.sender, _to, _value);
811 
812 		return true;
813 	}
814 
815 	function ownerBurn ( 
816 			uint256 _value )
817 		public returns (
818 			bool success) {
819 
820 		//only the contract owner can burn tokens
821 		require(msg.sender == contractOwner);
822 
823 		//can only burn tokens held by the owner
824 		require(_value <= balances[contractOwner]);
825 
826 		//total supply of tokens is decremented when burned
827 		totalSupply_ = totalSupply_.sub(_value);
828 
829 		//balance of the contract owner is reduced (the contract owner's tokens are burned)
830 		balances[contractOwner] = balances[contractOwner].sub(_value);
831 
832 		//burning tokens emits a transfer to 0, as well as TokensBurned
833 		emit Transfer(contractOwner, address(0), _value);
834 		emit TokensBurned(contractOwner, _value);
835 
836 		return true;
837 
838 	}
839 	
840 	
841 	function totalSupply ( ) public view returns (
842 		uint256 ) {
843 
844 		return totalSupply_;
845 	}
846 
847 	function balanceOf (
848 			address _owner ) 
849 		public view returns (
850 			uint256 ) {
851 
852 		return balances[_owner];
853 	}
854 
855 	function transfer (
856 			address _to, 
857 			uint256 _value ) 
858 		public returns (
859 			bool ) {
860 
861 		require(_to != address(0));
862 		require(_value <= balances[msg.sender]);
863 
864 		balances[msg.sender] = balances[msg.sender].sub(_value);
865 		balances[_to] = balances[_to].add(_value);
866 
867 		emit Transfer(msg.sender, _to, _value);
868 		return true;
869 	}
870 
871    	//changing approval with this method has the same underlying issue as https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
872    	//in that transaction order can be modified in a block to spend, change approval, spend again
873    	//the method is kept for ERC-20 compatibility, but a set to zero, set again or use of the below increase/decrease should be used instead
874 	function approve (
875 			address _spender, 
876 			uint256 _value ) 
877 		public returns (
878 			bool ) {
879 
880 		allowed[msg.sender][_spender] = _value;
881 
882 		emit Approval(msg.sender, _spender, _value);
883 		return true;
884 	}
885 
886 	function increaseApproval (
887 			address _spender, 
888 			uint256 _addedValue ) 
889 		public returns (
890 			bool ) {
891 
892 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
893 
894 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
895 		return true;
896 	}
897 
898 	function decreaseApproval (
899 			address _spender,
900 			uint256 _subtractedValue ) 
901 		public returns (
902 			bool ) {
903 
904 		uint256 oldValue = allowed[msg.sender][_spender];
905 
906 		if (_subtractedValue > oldValue) {
907 			allowed[msg.sender][_spender] = 0;
908 		} else {
909 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
910 		}
911 
912 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
913 		return true;
914 	}
915 
916 	function allowance (
917 			address _owner, 
918 			address _spender ) 
919 		public view returns (
920 			uint256 remaining ) {
921 
922 		return allowed[_owner][_spender];
923 	}
924 
925 	function transferFrom (
926 			address _from, 
927 			address _to, 
928 			uint256 _value ) 
929 		public returns (
930 			bool ) {
931 
932 		require(_to != address(0));
933 		require(_value <= balances[_from]);
934 		require(_value <= allowed[_from][msg.sender]);
935 
936 		balances[_from] = balances[_from].sub(_value);
937 		balances[_to] = balances[_to].add(_value);
938 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
939 		emit Transfer(_from, _to, _value);
940 		return true;
941 	}
942 
943 }