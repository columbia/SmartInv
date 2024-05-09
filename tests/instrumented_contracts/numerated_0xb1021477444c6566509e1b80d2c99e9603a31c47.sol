1 pragma solidity ^0.4.11;
2 /*
3 This FYN token contract is derived from the vSlice ICO contract, based on the ERC20 token contract. 
4 Additional functionality has been integrated:
5 * the function mintTokens() only callable from wallet, which makes use of the currentSwapRate() and safeToAdd() helpers
6 * the function mintReserve() only callable from wallet, which at the end of the crowdsale will allow the owners to claim the unsold tokens
7 * the function stopToken() only callable from wallet, which in an emergency, will trigger a complete and irrecoverable shutdown of the token
8 * Contract tokens are locked when created, and no tokens including pre-mine can be moved until the crowdsale is over.
9 */
10 
11 
12 // ERC20 Token Standard Interface
13 // https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15     function totalSupply() constant returns (uint);
16     function balanceOf(address who) constant returns (uint);
17     function allowance(address owner, address spender) constant returns (uint);
18 
19     function transfer(address to, uint value) returns (bool ok);
20     function transferFrom(address from, address to, uint value) returns (bool ok);
21     function approve(address spender, uint value) returns (bool ok);
22 
23     event Transfer(address indexed from, address indexed to, uint value);
24     event Approval(address indexed owner, address indexed spender, uint value);
25 }
26 
27 contract Token is ERC20 {
28 
29   string public constant name = "FundYourselfNow Token";
30   string public constant symbol = "FYN";
31   uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
32   uint256 public tokenCap = 12500000e18; // 12.5 million FYN cap 
33 
34   address public walletAddress;
35   uint256 public creationTime;
36   bool public transferStop;
37  
38   mapping( address => uint ) _balances;
39   mapping( address => mapping( address => uint ) ) _approvals;
40   uint _supply;
41 
42   event TokenMint(address newTokenHolder, uint amountOfTokens);
43   event TokenSwapOver();
44   event EmergencyStopActivated();
45 
46   modifier onlyFromWallet {
47       if (msg.sender != walletAddress) throw;
48       _;
49   }
50 
51   // Check if transfer should stop
52   modifier checkTransferStop {
53       if (transferStop == true) throw;
54       _;
55   }
56  
57 
58   /**
59    *
60    * Fix for the ERC20 short address attack
61    *
62    * http://vessenes.com/the-erc20-short-address-attack-explained/
63    */
64 
65   modifier onlyPayloadSize(uint size) {
66      if (!(msg.data.length == size + 4)) throw;
67      _;
68    } 
69  
70   function Token( uint initial_balance, address wallet, uint256 crowdsaleTime) {
71     _balances[msg.sender] = initial_balance;
72     _supply = initial_balance;
73     walletAddress = wallet;
74     creationTime = crowdsaleTime;
75     transferStop = true;
76   }
77 
78   function totalSupply() constant returns (uint supply) {
79     return _supply;
80   }
81 
82   function balanceOf( address who ) constant returns (uint value) {
83     return _balances[who];
84   }
85 
86   function allowance(address owner, address spender) constant returns (uint _allowance) {
87     return _approvals[owner][spender];
88   }
89 
90   // A helper to notify if overflow occurs
91   function safeToAdd(uint a, uint b) private constant returns (bool) {
92     return (a + b >= a && a + b >= b);
93   }
94   
95   // A helper to notify if overflow occurs for multiplication
96   function safeToMultiply(uint _a, uint _b) private constant returns (bool) {
97     return (_b == 0 || ((_a * _b) / _b) == _a);
98   }
99 
100   // A helper to notify if underflow occurs for subtraction
101   function safeToSub(uint a, uint b) private constant returns (bool) {
102     return (a >= b);
103   }
104 
105 
106   function transfer( address to, uint value)
107     checkTransferStop
108     onlyPayloadSize(2 * 32)
109     returns (bool ok) {
110 
111     if (to == walletAddress) throw; // Reject transfers to wallet (wallet cannot interact with token contract)
112     if( _balances[msg.sender] < value ) {
113         throw;
114     }
115     if( !safeToAdd(_balances[to], value) ) {
116         throw;
117     }
118 
119     _balances[msg.sender] -= value;
120     _balances[to] += value;
121     Transfer( msg.sender, to, value );
122     return true;
123   }
124 
125   function transferFrom( address from, address to, uint value)
126     checkTransferStop
127     returns (bool ok) {
128 
129     if (to == walletAddress) throw; // Reject transfers to wallet (wallet cannot interact with token contract)
130 
131     // if you don't have enough balance, throw
132     if( _balances[from] < value ) {
133         throw;
134     }
135     // if you don't have approval, throw
136     if( _approvals[from][msg.sender] < value ) {
137         throw;
138     }
139     if( !safeToAdd(_balances[to], value) ) {
140         throw;
141     }
142     // transfer and return true
143     _approvals[from][msg.sender] -= value;
144     _balances[from] -= value;
145     _balances[to] += value;
146     Transfer( from, to, value );
147     return true;
148   }
149 
150   function approve(address spender, uint value)
151     checkTransferStop
152     returns (bool ok) {
153 
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender,0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     //
159     // Note that this doesn't prevent attacks; the user will have to personally
160     //  check to ensure that the token count has not changed, before issuing
161     //  a new approval. Increment/decrement is not commonly spec-ed, and 
162     //  changing to a check-my-approvals-before-changing would require user
163     //  to find out his current approval for spender and change expected
164     //  behaviour for ERC20.
165 
166 
167     if ((value!=0) && (_approvals[msg.sender][spender] !=0)) throw;
168 
169     _approvals[msg.sender][spender] = value;
170     Approval( msg.sender, spender, value );
171     return true;
172   }
173 
174   // The function currentSwapRate() returns the current exchange rate
175   // between FYN tokens and Ether during the token swap period
176   function currentSwapRate() constant returns(uint) {
177       uint presalePeriod = 3 days;
178       uint presaleTransitionWindow = 3 hours;
179       if (creationTime + presalePeriod > now) {  // 2017-06-10 11am GMT+8
180           return 140; // Presale Window is triggered by both time and "Start Token Swap / End Token Swap". Restricted to announement range and basic testing.
181       } 
182       else if (creationTime + presalePeriod + 3 weeks > now) { // 2017-06-13 11am GMT+8, but we will only Start Token Swap at 2pm
183           return 120;
184       }
185       else if (creationTime + presalePeriod + 6 weeks + 6 days + 3 hours + presaleTransitionWindow + 1 days > now) { // 2017-07-31 5pm GMT+8 (+1 day window  )
186           // 1 day buffer to allow one final transaction from anyone to close everything
187           // otherwise wallet will receive ether but send 0 tokens
188           // we cannot throw as we will lose the state change to start swappability of tokens 
189           // This is actually just a price guide, actual closing is done at the Wallet level
190           return 100;
191       }
192       else {
193           return 0;
194       }
195   }
196 
197   // The function mintTokens is only usable by the chosen wallet
198   // contract to mint a number of tokens proportional to the
199   // amount of ether sent to the wallet contract. The function
200   // can only be called during the tokenswap period
201   function mintTokens(address newTokenHolder, uint etherAmount)
202     external
203     onlyFromWallet {
204         if (!safeToMultiply(currentSwapRate(), etherAmount)) throw;
205         uint tokensAmount = currentSwapRate() * etherAmount;
206 
207         if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw;
208         if(!safeToAdd(_supply,tokensAmount)) throw;
209 
210         if ((_supply + tokensAmount) > tokenCap) throw;
211 
212         _balances[newTokenHolder] += tokensAmount;
213         _supply += tokensAmount;
214 
215         TokenMint(newTokenHolder, tokensAmount);
216   }
217 
218   function mintReserve(address beneficiary) 
219     external
220     onlyFromWallet {
221         if (tokenCap <= _supply) throw;
222         if(!safeToSub(tokenCap,_supply)) throw;
223         uint tokensAmount = tokenCap - _supply;
224 
225         if(!safeToAdd(_balances[beneficiary], tokensAmount )) throw;
226         if(!safeToAdd(_supply,tokensAmount)) throw;
227 
228         _balances[beneficiary] += tokensAmount;
229         _supply += tokensAmount;
230         
231         TokenMint(beneficiary, tokensAmount);
232   }
233 
234   // The function disableTokenSwapLock() is called by the wallet
235   // contract once the token swap has reached its end conditions
236   function disableTokenSwapLock()
237     external
238     onlyFromWallet {
239         transferStop = false;
240         TokenSwapOver();
241   }
242 
243   // Once activated, a new token contract will need to be created, mirroring the current token holdings. 
244   function stopToken() onlyFromWallet {
245     transferStop = true;
246     EmergencyStopActivated();
247   }
248 }
249 
250 
251 /*
252 The standard Wallet contract, retrievable at
253 https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol has been
254 modified to include additional functionality, in particular:
255 * An additional parent of wallet contract called tokenswap, implementing almost
256 all the changes:
257     - Functions for starting and stopping the tokenswap
258     - A set-only-once function for the token contract
259     - buyTokens(), which calls mintTokens() in the token contract
260     - Modifiers for enforcing tokenswap time limits, max ether cap, and max token cap
261     - withdrawEther(), for withdrawing unsold tokens after time cap
262 * the wallet fallback function calls the buyTokens function
263 * the wallet contract cannot selfdestruct during the tokenswap
264 */
265 
266 contract multiowned {
267 
268 	// TYPES
269 
270     // struct for the status of a pending operation.
271     struct PendingState {
272         uint yetNeeded;
273         uint ownersDone;
274         uint index;
275     }
276 
277 	// EVENTS
278 
279     // this contract only has six types of events: it can accept a confirmation, in which case
280     // we record owner and operation (hash) alongside it.
281     event Confirmation(address owner, bytes32 operation);
282     event Revoke(address owner, bytes32 operation);
283     // some others are in the case of an owner changing.
284     event OwnerChanged(address oldOwner, address newOwner);
285     event OwnerAdded(address newOwner);
286     event OwnerRemoved(address oldOwner);
287     // the last one is emitted if the required signatures change
288     event RequirementChanged(uint newRequirement);
289 
290 	// MODIFIERS
291 
292     // simple single-sig function modifier.
293     modifier onlyowner {
294         if (isOwner(msg.sender))
295             _;
296     }
297     // multi-sig function modifier: the operation must have an intrinsic hash in order
298     // that later attempts can be realised as the same underlying operation and
299     // thus count as confirmations.
300     modifier onlymanyowners(bytes32 _operation) {
301         if (confirmAndCheck(_operation))
302             _;
303     }
304 
305 	// METHODS
306 
307     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
308     // as well as the selection of addresses capable of confirming them.
309     function multiowned(address[] _owners, uint _required) {
310         m_numOwners = _owners.length + 1;
311         m_owners[1] = uint(msg.sender);
312         m_ownerIndex[uint(msg.sender)] = 1;
313         for (uint i = 0; i < _owners.length; ++i)
314         {
315             m_owners[2 + i] = uint(_owners[i]);
316             m_ownerIndex[uint(_owners[i])] = 2 + i;
317         }
318         m_required = _required;
319     }
320 
321     // Revokes a prior confirmation of the given operation
322     function revoke(bytes32 _operation) external {
323         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
324         // make sure they're an owner
325         if (ownerIndex == 0) return;
326         uint ownerIndexBit = 2**ownerIndex;
327         var pending = m_pending[_operation];
328         if (pending.ownersDone & ownerIndexBit > 0) {
329             pending.yetNeeded++;
330             pending.ownersDone -= ownerIndexBit;
331             Revoke(msg.sender, _operation);
332         }
333     }
334 
335     // Replaces an owner `_from` with another `_to`.
336     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
337         if (isOwner(_to)) return;
338         uint ownerIndex = m_ownerIndex[uint(_from)];
339         if (ownerIndex == 0) return;
340 
341         clearPending();
342         m_owners[ownerIndex] = uint(_to);
343         m_ownerIndex[uint(_from)] = 0;
344         m_ownerIndex[uint(_to)] = ownerIndex;
345         OwnerChanged(_from, _to);
346     }
347 
348     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
349         if (isOwner(_owner)) return;
350 
351         clearPending();
352         if (m_numOwners >= c_maxOwners)
353             reorganizeOwners();
354         if (m_numOwners >= c_maxOwners)
355             return;
356         m_numOwners++;
357         m_owners[m_numOwners] = uint(_owner);
358         m_ownerIndex[uint(_owner)] = m_numOwners;
359         OwnerAdded(_owner);
360     }
361 
362     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
363         uint ownerIndex = m_ownerIndex[uint(_owner)];
364         if (ownerIndex == 0) return;
365         if (m_required > m_numOwners - 1) return;
366 
367         m_owners[ownerIndex] = 0;
368         m_ownerIndex[uint(_owner)] = 0;
369         clearPending();
370         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
371         OwnerRemoved(_owner);
372     }
373 
374     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
375         if (_newRequired > m_numOwners) return;
376         m_required = _newRequired;
377         clearPending();
378         RequirementChanged(_newRequired);
379     }
380 
381     // Gets an owner by 0-indexed position (using numOwners as the count)
382     function getOwner(uint ownerIndex) external constant returns (address) {
383         return address(m_owners[ownerIndex + 1]);
384     }
385 
386     function isOwner(address _addr) returns (bool) {
387         return m_ownerIndex[uint(_addr)] > 0;
388     }
389 
390     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
391         var pending = m_pending[_operation];
392         uint ownerIndex = m_ownerIndex[uint(_owner)];
393 
394         // make sure they're an owner
395         if (ownerIndex == 0) return false;
396 
397         // determine the bit to set for this owner.
398         uint ownerIndexBit = 2**ownerIndex;
399         return !(pending.ownersDone & ownerIndexBit == 0);
400     }
401 
402     // INTERNAL METHODS
403 
404     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
405         // determine what index the present sender is:
406         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
407         // make sure they're an owner
408         if (ownerIndex == 0) return;
409 
410         var pending = m_pending[_operation];
411         // if we're not yet working on this operation, switch over and reset the confirmation status.
412         if (pending.yetNeeded == 0) {
413             // reset count of confirmations needed.
414             pending.yetNeeded = m_required;
415             // reset which owners have confirmed (none) - set our bitmap to 0.
416             pending.ownersDone = 0;
417             pending.index = m_pendingIndex.length++;
418             m_pendingIndex[pending.index] = _operation;
419         }
420         // determine the bit to set for this owner.
421         uint ownerIndexBit = 2**ownerIndex;
422         // make sure we (the message sender) haven't confirmed this operation previously.
423         if (pending.ownersDone & ownerIndexBit == 0) {
424             Confirmation(msg.sender, _operation);
425             // ok - check if count is enough to go ahead.
426             if (pending.yetNeeded <= 1) {
427                 // enough confirmations: reset and run interior.
428                 delete m_pendingIndex[m_pending[_operation].index];
429                 delete m_pending[_operation];
430                 return true;
431             }
432             else
433             {
434                 // not enough: record that this owner in particular confirmed.
435                 pending.yetNeeded--;
436                 pending.ownersDone |= ownerIndexBit;
437             }
438         }
439     }
440 
441     function reorganizeOwners() private {
442         uint free = 1;
443         while (free < m_numOwners)
444         {
445             while (free < m_numOwners && m_owners[free] != 0) free++;
446             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
447             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
448             {
449                 m_owners[free] = m_owners[m_numOwners];
450                 m_ownerIndex[m_owners[free]] = free;
451                 m_owners[m_numOwners] = 0;
452             }
453         }
454     }
455 
456     function clearPending() internal {
457         uint length = m_pendingIndex.length;
458         for (uint i = 0; i < length; ++i)
459             if (m_pendingIndex[i] != 0)
460                 delete m_pending[m_pendingIndex[i]];
461         delete m_pendingIndex;
462     }
463 
464    	// FIELDS
465 
466     // the number of owners that must confirm the same operation before it is run.
467     uint public m_required;
468     // pointer used to find a free slot in m_owners
469     uint public m_numOwners;
470 
471     // list of owners
472     uint[256] m_owners;
473     uint constant c_maxOwners = 250;
474     // index on the list of owners to allow reverse lookup
475     mapping(uint => uint) m_ownerIndex;
476     // the ongoing operations.
477     mapping(bytes32 => PendingState) m_pending;
478     bytes32[] m_pendingIndex;
479 }
480 
481 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
482 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
483 // uses is specified in the modifier.
484 contract daylimit is multiowned {
485 
486 	// MODIFIERS
487 
488     // simple modifier for daily limit.
489     modifier limitedDaily(uint _value) {
490         if (underLimit(_value))
491             _;
492     }
493 
494 	// METHODS
495 
496     // constructor - stores initial daily limit and records the present day's index.
497     function daylimit(uint _limit) {
498         m_dailyLimit = _limit;
499         m_lastDay = today();
500     }
501     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
502     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
503         m_dailyLimit = _newLimit;
504     }
505     // resets the amount already spent today. needs many of the owners to confirm.
506     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
507         m_spentToday = 0;
508     }
509 
510     // INTERNAL METHODS
511 
512     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
513     // returns true. otherwise just returns false.
514     function underLimit(uint _value) internal onlyowner returns (bool) {
515         // reset the spend limit if we're on a different day to last time.
516         if (today() > m_lastDay) {
517             m_spentToday = 0;
518             m_lastDay = today();
519         }
520         // check if it's sending nothing (with or without data). This needs Multitransact
521         if (_value == 0) return false;
522 
523         // check to see if there's enough left - if so, subtract and return true.
524         // overflow protection                    // dailyLimit check
525         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
526             m_spentToday += _value;
527             return true;
528         }
529         return false;
530     }
531     // determines today's index.
532     function today() private constant returns (uint) { return now / 1 days; }
533 
534 	// FIELDS
535 
536     uint public m_dailyLimit;
537     uint public m_spentToday;
538     uint public m_lastDay;
539 }
540 
541 // interface contract for multisig proxy contracts; see below for docs.
542 contract multisig {
543 
544 	// EVENTS
545 
546     // logged events:
547     // Funds has arrived into the wallet (record how much).
548     event Deposit(address _from, uint value);
549     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
550     event SingleTransact(address owner, uint value, address to, bytes data);
551     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
552     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
553     // Confirmation still needed for a transaction.
554     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
555 
556     // FUNCTIONS
557 
558     // TODO: document
559     function changeOwner(address _from, address _to) external;
560     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
561     function confirm(bytes32 _h) returns (bool);
562 }
563 
564 contract tokenswap is multisig, multiowned {
565     Token public tokenCtr;
566     bool public tokenSwap;
567     uint public constant PRESALE_LENGTH = 3 days;
568     uint public constant TRANSITION_WINDOW = 3 hours; // We will turn on tokenSwap in this period and it will 120 FYN / ETH
569     uint public constant SWAP_LENGTH = PRESALE_LENGTH + TRANSITION_WINDOW + 6 weeks + 6 days + 3 hours;
570     uint public constant MAX_ETH = 75000 ether; // Hard cap, capped otherwise by total tokens sold (max 7.5M FYN)
571     uint public amountRaised;
572 
573     modifier isUnderPresaleMinimum {
574         if (tokenCtr.creationTime() + PRESALE_LENGTH > now) {
575             if (msg.value < 20 ether) throw;
576         }
577         _;
578     }
579 
580     modifier isZeroValue {
581         if (msg.value == 0) throw;
582         _;
583     }
584 
585     modifier isOverCap {
586     	if (amountRaised + msg.value > MAX_ETH) throw;
587         _;
588     }
589 
590     modifier isOverTokenCap {
591         if (!safeToMultiply(tokenCtr.currentSwapRate(), msg.value)) throw;
592         uint tokensAmount = tokenCtr.currentSwapRate() * msg.value;
593         if(!safeToAdd(tokenCtr.totalSupply(),tokensAmount)) throw;
594         if (tokenCtr.totalSupply() + tokensAmount > tokenCtr.tokenCap()) throw;
595         _;
596 
597     }
598 
599     modifier isSwapStopped {
600         if (!tokenSwap) throw;
601         _;
602     }
603 
604     modifier areConditionsSatisfied {
605         _;
606         // End token swap if sale period ended
607         // We can't throw to reverse the amount sent in or we will lose state
608         // , so we will accept it even though if it is after crowdsale
609         if (tokenCtr.creationTime() + SWAP_LENGTH < now) {
610             tokenCtr.disableTokenSwapLock();
611             tokenSwap = false;
612         }
613         // Check if cap has been reached in this tx
614         if (amountRaised == MAX_ETH) {
615             tokenCtr.disableTokenSwapLock();
616             tokenSwap = false;
617         }
618 
619         // Check if token cap has been reach in this tx
620         if (tokenCtr.totalSupply() == tokenCtr.tokenCap()) {
621             tokenCtr.disableTokenSwapLock();
622             tokenSwap = false;
623         }
624     }
625 
626     // A helper to notify if overflow occurs for addition
627     function safeToAdd(uint a, uint b) private constant returns (bool) {
628       return (a + b >= a && a + b >= b);
629     }
630   
631     // A helper to notify if overflow occurs for multiplication
632     function safeToMultiply(uint _a, uint _b) private constant returns (bool) {
633       return (_b == 0 || ((_a * _b) / _b) == _a);
634     }
635 
636 
637     function startTokenSwap() onlyowner {
638         tokenSwap = true;
639     }
640 
641     function stopTokenSwap() onlyowner {
642         tokenSwap = false;
643     }
644 
645     function setTokenContract(address newTokenContractAddr) onlyowner {
646         if (newTokenContractAddr == address(0x0)) throw;
647         // Allow setting only once
648         if (tokenCtr != address(0x0)) throw;
649 
650         tokenCtr = Token(newTokenContractAddr);
651     }
652 
653     function buyTokens(address _beneficiary)
654     payable
655     isUnderPresaleMinimum
656     isZeroValue
657     isOverCap
658     isOverTokenCap
659     isSwapStopped
660     areConditionsSatisfied {
661         Deposit(msg.sender, msg.value);
662         tokenCtr.mintTokens(_beneficiary, msg.value);
663         if (!safeToAdd(amountRaised, msg.value)) throw;
664         amountRaised += msg.value;
665     }
666 
667     function withdrawReserve(address _beneficiary) onlyowner {
668 	    if (tokenCtr.creationTime() + SWAP_LENGTH < now) {
669             tokenCtr.mintReserve(_beneficiary);
670         }
671     } 
672 }
673 
674 // usage:
675 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
676 // Wallet(w).from(anotherOwner).confirm(h);
677 contract Wallet is multisig, multiowned, daylimit, tokenswap {
678 
679 	// TYPES
680 
681     // Transaction structure to remember details of transaction lest it need be saved for a later call.
682     struct Transaction {
683         address to;
684         uint value;
685         bytes data;
686     }
687 
688     // METHODS
689 
690     // constructor - just pass on the owner array to the multiowned and
691     // the limit to daylimit
692     function Wallet(address[] _owners, uint _required, uint _daylimit)
693             multiowned(_owners, _required) daylimit(_daylimit) {
694     }
695 
696     // kills the contract sending everything to `_to`.
697     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
698         // ensure owners can't prematurely stop token sale
699         if (tokenSwap) throw;
700         // ensure owners can't kill wallet without stopping token
701         //  otherwise token can never be stopped
702         if (tokenCtr.transferStop() == false) throw;
703         suicide(_to);
704     }
705 
706     // Activates Emergency Stop for Token
707     function stopToken() onlymanyowners(sha3(msg.data)) external {
708        tokenCtr.stopToken();
709     }
710 
711     // gets called when no other function matches
712     function()
713     payable {
714         buyTokens(msg.sender);
715     }
716 
717     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
718     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
719     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
720     // and _data arguments). They still get the option of using them if they want, anyways.
721     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
722         // Disallow the wallet contract from calling token contract once it's set
723         // so tokens can't be minted arbitrarily once the sale starts.
724         // Tokens can be minted for premine before the sale opens and tokenCtr is set.
725         if (_to == address(tokenCtr)) throw;
726 
727         // first, take the opportunity to check that we're under the daily limit.
728         if (underLimit(_value)) {
729             SingleTransact(msg.sender, _value, _to, _data);
730             // yes - just execute the call.
731             if(!_to.call.value(_value)(_data))
732             return 0;
733         }
734 
735         // determine our operation hash.
736         _r = sha3(msg.data, block.number);
737         if (!confirm(_r) && m_txs[_r].to == 0) {
738             m_txs[_r].to = _to;
739             m_txs[_r].value = _value;
740             m_txs[_r].data = _data;
741             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
742         }
743     }
744 
745     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
746     // to determine the body of the transaction from the hash provided.
747     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
748         if (m_txs[_h].to != 0) {
749             if (!m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data))   // Bugfix: If successful, MultiTransact event should fire; if unsuccessful, we should throw
750                 throw;
751             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
752             delete m_txs[_h];
753             return true;
754         }
755     }
756 
757     // INTERNAL METHODS
758 
759     function clearPending() internal {
760         uint length = m_pendingIndex.length;
761         for (uint i = 0; i < length; ++i)
762             delete m_txs[m_pendingIndex[i]];
763         super.clearPending();
764     }
765 
766 	// FIELDS
767 
768     // pending transactions we have at present.
769     mapping (bytes32 => Transaction) m_txs;
770 }