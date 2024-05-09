1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9 	address public owner;
10 
11 	/**
12      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13      * account.
14      */
15 	function Ownable() public {
16 		owner = tx.origin;
17 	}
18 
19 
20 	/**
21      * @dev Throws if called by any account other than the owner.
22      */
23 	modifier onlyOwner() {
24 		require(msg.sender == owner);
25 		_;
26 	}
27 
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      *
32      * @param _newOwner The address to transfer ownership to.
33      */
34 	function transferOwnership(address _newOwner) onlyOwner public {
35 		require(_newOwner != address(0));
36 		owner = _newOwner;
37 	}
38 }
39 
40 
41 
42 
43 
44 
45 
46 
47 /**
48  * @title BasicERC20 token.
49  * @dev Basic version of ERC20 token with allowances.
50  */
51 contract BasicERC20Token is Ownable {
52     using SafeMath for uint256;
53 
54     uint256 public totalSupply;
55     mapping (address => uint256) balances;
56     mapping (address => mapping (address => uint256)) allowed;
57 
58     event Transfer(address indexed from, address indexed to, uint256 amount);
59     event Approval(address indexed owner, address indexed spender, uint256 amount);
60 
61 
62     /**
63      * @dev Function to check the amount of tokens for address.
64      *
65      * @param _owner Address which owns the tokens.
66      * 
67      * @return A uint256 specifing the amount of tokens still available to the owner.
68      */
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73 
74     /**
75      * @dev Function to check the total supply of tokens.
76      *
77      * @return The uint256 specifing the amount of tokens which are held by the contract.
78      */
79     function getTotalSupply() public view returns (uint256) {
80         return totalSupply;
81     }
82 
83 
84     /**
85      * @dev Function to check the amount of tokens that an owner allowed to a spender.
86      *
87      * @param _owner Address which owns the funds.
88      * @param _spender Address which will spend the funds.
89      *
90      * @return The uint256 specifing the amount of tokens still available for the spender.
91      */
92     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
93         return allowed[_owner][_spender];
94     }
95 
96 
97     /**
98      * @dev Internal function to transfer tokens.
99      *
100      * @param _from Address of the sender.
101      * @param _to Address of the recipient.
102      * @param _amount Amount to send.
103      *
104      * @return True if the operation was successful.
105      */
106     function _transfer(address _from, address _to, uint256 _amount) internal returns (bool) {
107         require (_from != 0x0);                               // Prevent transfer to 0x0 address
108         require (_to != 0x0);                               // Prevent transfer to 0x0 address
109         require (balances[_from] >= _amount);          // Check if the sender has enough tokens
110         require (balances[_to] + _amount > balances[_to]);  // Check for overflows
111 
112         uint256 length;
113         assembly {
114             length := extcodesize(_to)
115         }
116         require (length == 0);
117 
118         balances[_from] = balances[_from].sub(_amount);
119         balances[_to] = balances[_to].add(_amount);
120 
121         emit Transfer(_from, _to, _amount);
122         
123         return true;
124     }
125 
126 
127     /**
128      * @dev Function to transfer tokens.
129      *
130      * @param _to Address of the recipient.
131      * @param _amount Amount to send.
132      *
133      * @return True if the operation was successful.
134      */
135     function transfer(address _to, uint256 _amount) public returns (bool) {
136         _transfer(msg.sender, _to, _amount);
137 
138         return true;
139     }
140 
141 
142     /**
143      * @dev Transfer tokens from other address.
144      *
145      * @param _from Address of the sender.
146      * @param _to Address of the recipient.
147      * @param _amount Amount to send.
148      *
149      * @return True if the operation was successful.
150      */
151     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool) {
152         require (allowed[_from][msg.sender] >= _amount);          // Check if the sender has enough
153 
154         _transfer(_from, _to, _amount);
155 
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
157         return true;
158     }
159 
160 
161     /**
162      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
163      * 
164      * @param _spender Address which will spend the funds.
165      * @param _amount Amount of tokens to be spent.
166      *
167      * @return True if the operation was successful.
168      */
169     function approve(address _spender, uint256 _amount) public returns (bool) {
170         require (_spender != 0x0);                       // Prevent transfer to 0x0 address
171         require (_amount >= 0);
172         require (balances[msg.sender] >= _amount);       // Check if the msg.sender has enough to allow 
173 
174         if (_amount == 0) allowed[msg.sender][_spender] = _amount;
175         else allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_amount);
176 
177         emit Approval(msg.sender, _spender, _amount);
178         return true;
179     }
180 }
181 
182 /**
183  * @title PULS token
184  * @dev Extends ERC20 token.
185  */
186 contract PULSToken is BasicERC20Token {
187 	// Public variables of the token
188 	string public constant name = 'PULS Token';
189 	string public constant symbol = 'PULS';
190 	uint256 public constant decimals = 18;
191 	uint256 public constant INITIAL_SUPPLY = 88888888000000000000000000;
192 
193 	address public crowdsaleAddress;
194 
195 	// Public structure to support token reservation.
196 	struct Reserve {
197         uint256 pulsAmount;
198         uint256 collectedEther;
199     }
200 
201 	mapping (address => Reserve) reserved;
202 
203 	// Public structure to record locked tokens for a specific lock.
204 	struct Lock {
205 		uint256 amount;
206 		uint256 startTime;	// in seconds since 01.01.1970
207 		uint256 timeToLock; // in seconds
208 		bytes32 pulseLockHash;
209 	}
210 	
211 	// Public list of locked tokens for a specific address.
212 	struct lockList{
213 		Lock[] lockedTokens;
214 	}
215 	
216 	// Public list of lockLists.
217 	mapping (address => lockList) addressLocks;
218 
219 	/**
220      * @dev Throws if called by any account other than the crowdsale address.
221      */
222 	modifier onlyCrowdsaleAddress() {
223 		require(msg.sender == crowdsaleAddress);
224 		_;
225 	}
226 
227 	event TokenReservation(address indexed beneficiary, uint256 sendEther, uint256 indexed pulsAmount, uint256 reserveTypeId);
228 	event RevertingReservation(address indexed addressToRevert);
229 	event TokenLocking(address indexed addressToLock, uint256 indexed amount, uint256 timeToLock);
230 	event TokenUnlocking(address indexed addressToUnlock, uint256 indexed amount);
231 
232 
233 	/**
234      * @dev The PULS token constructor sets the initial supply of tokens to the crowdsale address
235      * account.
236      */
237 	function PULSToken() public {
238 		totalSupply = INITIAL_SUPPLY;
239 		balances[msg.sender] = INITIAL_SUPPLY;
240 		
241 		crowdsaleAddress = msg.sender;
242 
243 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
244 	}
245 
246 
247 	/**
248      * @dev Payable function.
249      */
250 	function () external payable {
251 	}
252 
253 
254 	/**
255      * @dev Function to check reserved amount of tokens for address.
256      *
257      * @param _owner Address of owner of the tokens.
258      *
259      * @return The uint256 specifing the amount of tokens which are held in reserve for this address.
260      */
261 	function reserveOf(address _owner) public view returns (uint256) {
262 		return reserved[_owner].pulsAmount;
263 	}
264 
265 
266 	/**
267      * @dev Function to check reserved amount of tokens for address.
268      *
269      * @param _buyer Address of buyer of the tokens.
270      *
271      * @return The uint256 specifing the amount of tokens which are held in reserve for this address.
272      */
273 	function collectedEtherFrom(address _buyer) public view returns (uint256) {
274 		return reserved[_buyer].collectedEther;
275 	}
276 
277 
278 	/**
279      * @dev Function to get number of locks for an address.
280      *
281      * @param _address Address who owns locked tokens.
282      *
283      * @return The uint256 length of array.
284      */
285 	function getAddressLockedLength(address _address) public view returns(uint256 length) {
286 	    return addressLocks[_address].lockedTokens.length;
287 	}
288 
289 
290 	/**
291      * @dev Function to get locked tokens amount for specific address for specific lock.
292      *
293      * @param _address Address of owner of locked tokens.
294      * @param _index Index of specific lock.
295      *
296      * @return The uint256 specifing the amount of locked tokens.
297      */
298 	function getLockedStructAmount(address _address, uint256 _index) public view returns(uint256 amount) {
299 	    return addressLocks[_address].lockedTokens[_index].amount;
300 	}
301 
302 
303 	/**
304      * @dev Function to get start time of lock for specific address.
305      *
306      * @param _address Address of owner of locked tokens.
307      * @param _index Index of specific lock.
308      *
309      * @return The uint256 specifing the start time of lock in seconds.
310      */
311 	function getLockedStructStartTime(address _address, uint256 _index) public view returns(uint256 startTime) {
312 	    return addressLocks[_address].lockedTokens[_index].startTime;
313 	}
314 
315 
316 	/**
317      * @dev Function to get duration time of lock for specific address.
318      *
319      * @param _address Address of owner of locked tokens.
320      * @param _index Index of specific lock.
321      *
322      * @return The uint256 specifing the duration time of lock in seconds.
323      */
324 	function getLockedStructTimeToLock(address _address, uint256 _index) public view returns(uint256 timeToLock) {
325 	    return addressLocks[_address].lockedTokens[_index].timeToLock;
326 	}
327 
328 	
329 	/**
330      * @dev Function to get pulse hash for specific address for specific lock.
331      *
332      * @param _address Address of owner of locked tokens.
333      * @param _index Index of specific lock.
334      *
335      * @return The bytes32 specifing the pulse hash.
336      */
337 	function getLockedStructPulseLockHash(address _address, uint256 _index) public view returns(bytes32 pulseLockHash) {
338 	    return addressLocks[_address].lockedTokens[_index].pulseLockHash;
339 	}
340 
341 
342 	/**
343      * @dev Function to send tokens after verifing KYC form.
344      *
345      * @param _beneficiary Address of receiver of tokens.
346      *
347      * @return True if the operation was successful.
348      */
349 	function sendTokens(address _beneficiary) onlyOwner public returns (bool) {
350 		require (reserved[_beneficiary].pulsAmount > 0);		 // Check if reserved tokens for _beneficiary address is greater then 0
351 
352 		_transfer(crowdsaleAddress, _beneficiary, reserved[_beneficiary].pulsAmount);
353 
354 		reserved[_beneficiary].pulsAmount = 0;
355 
356 		return true;
357 	}
358 
359 
360 	/**
361      * @dev Function to reserve tokens for buyer after sending ETH to crowdsale address.
362      *
363      * @param _beneficiary Address of reserver of tokens.
364      * @param _pulsAmount Amount of tokens to reserve.
365      * @param _eth Amount of eth sent in transaction.
366      *
367      * @return True if the operation was successful.
368      */
369 	function reserveTokens(address _beneficiary, uint256 _pulsAmount, uint256 _eth, uint256 _reserveTypeId) onlyCrowdsaleAddress public returns (bool) {
370 		require (_beneficiary != 0x0);					// Prevent transfer to 0x0 address
371 		require (totalSupply >= _pulsAmount);           // Check if such tokens amount left
372 
373 		totalSupply = totalSupply.sub(_pulsAmount);
374 		reserved[_beneficiary].pulsAmount = reserved[_beneficiary].pulsAmount.add(_pulsAmount);
375 		reserved[_beneficiary].collectedEther = reserved[_beneficiary].collectedEther.add(_eth);
376 
377 		emit TokenReservation(_beneficiary, _eth, _pulsAmount, _reserveTypeId);
378 		return true;
379 	}
380 
381 
382 	/**
383      * @dev Function to revert reservation for some address.
384      *
385      * @param _addressToRevert Address to which collected ETH will be returned.
386      *
387      * @return True if the operation was successful.
388      */
389 	function revertReservation(address _addressToRevert) onlyOwner public returns (bool) {
390 		require (reserved[_addressToRevert].pulsAmount > 0);	
391 
392 		totalSupply = totalSupply.add(reserved[_addressToRevert].pulsAmount);
393 		reserved[_addressToRevert].pulsAmount = 0;
394 
395 		_addressToRevert.transfer(reserved[_addressToRevert].collectedEther - (20000000000 * 21000));
396 		reserved[_addressToRevert].collectedEther = 0;
397 
398 		emit RevertingReservation(_addressToRevert);
399 		return true;
400 	}
401 
402 
403 	/**
404      * @dev Function to lock tokens for some period of time.
405      *
406      * @param _amount Amount of locked tokens.
407      * @param _minutesToLock Days tokens will be locked.
408      * @param _pulseLockHash Hash of locked pulse.
409      *
410      * @return True if the operation was successful.
411      */
412 	function lockTokens(uint256 _amount, uint256 _minutesToLock, bytes32 _pulseLockHash) public returns (bool){
413 		require(balances[msg.sender] >= _amount);
414 
415 		Lock memory lockStruct;
416         lockStruct.amount = _amount;
417         lockStruct.startTime = now;
418         lockStruct.timeToLock = _minutesToLock * 1 minutes;
419         lockStruct.pulseLockHash = _pulseLockHash;
420 
421         addressLocks[msg.sender].lockedTokens.push(lockStruct);
422         balances[msg.sender] = balances[msg.sender].sub(_amount);
423 
424         emit TokenLocking(msg.sender, _amount, _minutesToLock);
425         return true;
426 	}
427 
428 
429 	/**
430      * @dev Function to unlock tokens for some period of time.
431      *
432      * @param _addressToUnlock Addrerss of person with locked tokens.
433      *
434      * @return True if the operation was successful.
435      */
436 	function unlockTokens(address _addressToUnlock) public returns (bool){
437 		uint256 i = 0;
438 		while(i < addressLocks[_addressToUnlock].lockedTokens.length) {
439 			if (now > addressLocks[_addressToUnlock].lockedTokens[i].startTime + addressLocks[_addressToUnlock].lockedTokens[i].timeToLock) {
440 
441 				balances[_addressToUnlock] = balances[_addressToUnlock].add(addressLocks[_addressToUnlock].lockedTokens[i].amount);
442 				emit TokenUnlocking(_addressToUnlock, addressLocks[_addressToUnlock].lockedTokens[i].amount);
443 
444 				if (i < addressLocks[_addressToUnlock].lockedTokens.length) {
445 					for (uint256 j = i; j < addressLocks[_addressToUnlock].lockedTokens.length - 1; j++){
446 			            addressLocks[_addressToUnlock].lockedTokens[j] = addressLocks[_addressToUnlock].lockedTokens[j + 1];
447 			        }
448 				}
449 		        delete addressLocks[_addressToUnlock].lockedTokens[addressLocks[_addressToUnlock].lockedTokens.length - 1];
450 				
451 				addressLocks[_addressToUnlock].lockedTokens.length = addressLocks[_addressToUnlock].lockedTokens.length.sub(1);
452 			}
453 			else {
454 				i = i.add(1);
455 			}
456 		}
457 
458         return true;
459 	}
460 }
461 
462 
463 
464 
465 
466 /**
467  * @title SafeMath.
468  * @dev Math operations with safety checks that throw on error.
469  */
470 library SafeMath {
471 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
472 		uint256 c = a * b;
473 		assert(a == 0 || c / a == b);
474 		return c;
475 	}
476 
477 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
478 		// assert(b > 0); // Solidity automatically throws when dividing by 0
479 		uint256 c = a / b;
480 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
481 		return c;
482 	}
483 
484 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485 		assert(b <= a);
486 		return a - b;
487 	}
488 
489 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
490 		uint256 c = a + b;
491 		assert(c >= a);
492 		return c;
493 	}
494 }
495 
496 /**
497  * @title Staged crowdsale.
498  * @dev Functionality of staged crowdsale.
499  */
500 contract StagedCrowdsale is Ownable {
501 
502     using SafeMath for uint256;
503 
504     // Public structure of crowdsale's stages.
505     struct Stage {
506         uint256 hardcap;
507         uint256 price;
508         uint256 minInvestment;
509         uint256 invested;
510         uint256 closed;
511     }
512 
513     Stage[] public stages;
514 
515 
516     /**
517      * @dev Function to get the current stage number.
518      * 
519      * @return A uint256 specifing the current stage number.
520      */
521     function getCurrentStage() public view returns(uint256) {
522         for(uint256 i=0; i < stages.length; i++) {
523             if(stages[i].closed == 0) {
524                 return i;
525             }
526         }
527         revert();
528     }
529 
530 
531     /**
532      * @dev Function to add the stage to the crowdsale.
533      *
534      * @param _hardcap The hardcap of the stage.
535      * @param _price The amount of tokens you will receive per 1 ETH for this stage.
536      */
537     function addStage(uint256 _hardcap, uint256 _price, uint256 _minInvestment, uint _invested) onlyOwner public {
538         require(_hardcap > 0 && _price > 0);
539         Stage memory stage = Stage(_hardcap.mul(1 ether), _price, _minInvestment.mul(1 ether).div(10), _invested.mul(1 ether), 0);
540         stages.push(stage);
541     }
542 
543 
544     /**
545      * @dev Function to close the stage manually.
546      *
547      * @param _stageNumber Stage number to close.
548      */
549     function closeStage(uint256 _stageNumber) onlyOwner public {
550         require(stages[_stageNumber].closed == 0);
551         if (_stageNumber != 0) require(stages[_stageNumber - 1].closed != 0);
552 
553         stages[_stageNumber].closed = now;
554         stages[_stageNumber].invested = stages[_stageNumber].hardcap;
555 
556         if (_stageNumber + 1 <= stages.length - 1) {
557             stages[_stageNumber + 1].invested = stages[_stageNumber].hardcap;
558         }
559     }
560 
561 
562     /**
563      * @dev Function to remove all stages.
564      *
565      * @return True if the operation was successful.
566     */
567     function removeStages() onlyOwner public returns (bool) {
568         require(stages.length > 0);
569 
570         stages.length = 0;
571 
572         return true;
573     }
574 }
575 
576 /**
577  * @title PULS crowdsale
578  * @dev PULS crowdsale functionality.
579  */
580 contract PULSCrowdsale is StagedCrowdsale {
581 	using SafeMath for uint256;
582 
583 	PULSToken public token;
584 
585 	// Public variables of the crowdsale
586 	address public multiSigWallet; 	// address where funds are collected
587 	bool public hasEnded;
588 	bool public isPaused;	
589 
590 
591 	event TokenReservation(address purchaser, address indexed beneficiary, uint256 indexed sendEther, uint256 indexed pulsAmount);
592 	event ForwardingFunds(uint256 indexed value);
593 
594 
595 	/**
596      * @dev Throws if crowdsale has ended.
597      */
598 	modifier notEnded() {
599 		require(!hasEnded);
600 		_;
601 	}
602 
603 
604 	/**
605      * @dev Throws if crowdsale has not ended.
606      */
607 	modifier notPaused() {
608 		require(!isPaused);
609 		_;
610 	}
611 
612 
613 	/**
614      * @dev The Crowdsale constructor sets the multisig wallet for forwanding funds.
615      * Adds stages to the crowdsale. Initialize PULS tokens.
616      */
617 	function PULSCrowdsale() public {
618 		token = createTokenContract();
619 
620 		multiSigWallet = 0x00955149d0f425179000e914F0DFC2eBD96d6f43;
621 		hasEnded = false;
622 		isPaused = false;
623 
624 		addStage(3000, 1600, 1, 0);   //3rd value is actually div 10
625 		addStage(3500, 1550, 1, 0);   //3rd value is actually div 10
626 		addStage(4000, 1500, 1, 0);   //3rd value is actually div 10
627 		addStage(4500, 1450, 1, 0);   //3rd value is actually div 10
628 		addStage(42500, 1400, 1, 0);  //3rd value is actually div 10
629 	}
630 
631 
632 	/**
633      * @dev Function to create PULS tokens contract.
634      *
635      * @return PULSToken The instance of PULS token contract.
636      */
637 	function createTokenContract() internal returns (PULSToken) {
638 		return new PULSToken();
639 	}
640 
641 
642 	/**
643      * @dev Payable function.
644      */
645 	function () external payable {
646 		buyTokens(msg.sender);
647 	}
648 
649 
650 	/**
651      * @dev Function to buy tokens - reserve calculated amount of tokens.
652      *
653      * @param _beneficiary The address of the buyer.
654      */
655 	function buyTokens(address _beneficiary) payable notEnded notPaused public {
656 		require(msg.value >= 0);
657 		
658 		uint256 stageIndex = getCurrentStage();
659 		Stage storage stageCurrent = stages[stageIndex];
660 
661 		require(msg.value >= stageCurrent.minInvestment);
662 
663 		uint256 tokens;
664 
665 		// if puts us in new stage - receives with next stage price
666 		if (stageCurrent.invested.add(msg.value) >= stageCurrent.hardcap){
667 			stageCurrent.closed = now;
668 
669 			if (stageIndex + 1 <= stages.length - 1) {
670 				Stage storage stageNext = stages[stageIndex + 1];
671 
672 				tokens = msg.value.mul(stageCurrent.price);
673 				token.reserveTokens(_beneficiary, tokens, msg.value, 0);
674 
675 				stageNext.invested = stageCurrent.invested.add(msg.value);
676 
677 				stageCurrent.invested = stageCurrent.hardcap;
678 			}
679 			else {
680 				tokens = msg.value.mul(stageCurrent.price);
681 				token.reserveTokens(_beneficiary, tokens, msg.value, 0);
682 
683 				stageCurrent.invested = stageCurrent.invested.add(msg.value);
684 
685 				hasEnded = true;
686 			}
687 		}
688 		else {
689 			tokens = msg.value.mul(stageCurrent.price);
690 			token.reserveTokens(_beneficiary, tokens, msg.value, 0);
691 
692 			stageCurrent.invested = stageCurrent.invested.add(msg.value);
693 		}
694 
695 		emit TokenReservation(msg.sender, _beneficiary, msg.value, tokens);
696 		forwardFunds();
697 	}
698 
699 
700 	/**
701      * @dev Function to buy tokens - reserve calculated amount of tokens.
702      *
703      * @param _beneficiary The address of the buyer.
704      */
705 	function privatePresaleTokenReservation(address _beneficiary, uint256 _amount, uint256 _reserveTypeId) onlyOwner public {
706 		require (_reserveTypeId > 0);
707 		token.reserveTokens(_beneficiary, _amount, 0, _reserveTypeId);
708 		emit TokenReservation(msg.sender, _beneficiary, 0, _amount);
709 	}
710 
711 
712 	/**
713      * @dev Internal function to forward funds to multisig wallet.
714      */
715 	function forwardFunds() internal {
716 		multiSigWallet.transfer(msg.value);
717 		emit ForwardingFunds(msg.value);
718 	}
719 
720 
721 	/**
722      * @dev Function to finish the crowdsale.
723      *
724      * @return True if the operation was successful.
725      */ 
726 	function finishCrowdsale() onlyOwner notEnded public returns (bool) {
727 		hasEnded = true;
728 		return true;
729 	}
730 
731 
732 	/**
733      * @dev Function to pause the crowdsale.
734      *
735      * @return True if the operation was successful.
736      */ 
737 	function pauseCrowdsale() onlyOwner notEnded notPaused public returns (bool) {
738 		isPaused = true;
739 		return true;
740 	}
741 
742 
743 	/**
744      * @dev Function to unpause the crowdsale.
745      *
746      * @return True if the operation was successful.
747      */ 
748 	function unpauseCrowdsale() onlyOwner notEnded public returns (bool) {
749 		isPaused = false;
750 		return true;
751 	}
752 
753 
754 	/**
755      * @dev Function to change multisgwallet.
756      *
757      * @return True if the operation was successful.
758      */ 
759 	function changeMultiSigWallet(address _newMultiSigWallet) onlyOwner public returns (bool) {
760 		multiSigWallet = _newMultiSigWallet;
761 		return true;
762 	}
763 }