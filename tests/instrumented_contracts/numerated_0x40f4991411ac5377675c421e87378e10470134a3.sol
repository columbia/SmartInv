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
178       if (creationTime + presalePeriod > now) {
179           return 140;
180       }
181       else if (creationTime + presalePeriod + 3 weeks > now) {
182           return 120;
183       }
184       else if (creationTime + presalePeriod + 6 weeks + 6 days + 3 hours + 1 days > now) { 
185           // 1 day buffer to allow one final transaction from anyone to close everything
186           // otherwise wallet will receive ether but send 0 tokens
187           // we cannot throw as we will lose the state change to start swappability of tokens 
188           return 100;
189       }
190       else {
191           return 0;
192       }
193   }
194 
195   // The function mintTokens is only usable by the chosen wallet
196   // contract to mint a number of tokens proportional to the
197   // amount of ether sent to the wallet contract. The function
198   // can only be called during the tokenswap period
199   function mintTokens(address newTokenHolder, uint etherAmount)
200     external
201     onlyFromWallet {
202         if (!safeToMultiply(currentSwapRate(), etherAmount)) throw;
203         uint tokensAmount = currentSwapRate() * etherAmount;
204 
205         if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw;
206         if(!safeToAdd(_supply,tokensAmount)) throw;
207 
208         if ((_supply + tokensAmount) > tokenCap) throw;
209 
210         _balances[newTokenHolder] += tokensAmount;
211         _supply += tokensAmount;
212 
213         TokenMint(newTokenHolder, tokensAmount);
214   }
215 
216   function mintReserve(address beneficiary) 
217     external
218     onlyFromWallet {
219         if (tokenCap <= _supply) throw;
220         if(!safeToSub(tokenCap,_supply)) throw;
221         uint tokensAmount = tokenCap - _supply;
222 
223         if(!safeToAdd(_balances[beneficiary], tokensAmount )) throw;
224         if(!safeToAdd(_supply,tokensAmount)) throw;
225 
226         _balances[beneficiary] += tokensAmount;
227         _supply += tokensAmount;
228         
229         TokenMint(beneficiary, tokensAmount);
230   }
231 
232   // The function disableTokenSwapLock() is called by the wallet
233   // contract once the token swap has reached its end conditions
234   function disableTokenSwapLock()
235     external
236     onlyFromWallet {
237         transferStop = false;
238         TokenSwapOver();
239   }
240 
241   // Once activated, a new token contract will need to be created, mirroring the current token holdings. 
242   function stopToken() onlyFromWallet {
243     transferStop = true;
244     EmergencyStopActivated();
245   }
246 }
247 
248 
249 /*
250 The standard Wallet contract, retrievable at
251 https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol has been
252 modified to include additional functionality, in particular:
253 * An additional parent of wallet contract called tokenswap, implementing almost
254 all the changes:
255     - Functions for starting and stopping the tokenswap
256     - A set-only-once function for the token contract
257     - buyTokens(), which calls mintTokens() in the token contract
258     - Modifiers for enforcing tokenswap time limits, max ether cap, and max token cap
259     - withdrawEther(), for withdrawing unsold tokens after time cap
260 * the wallet fallback function calls the buyTokens function
261 * the wallet contract cannot selfdestruct during the tokenswap
262 */
263 
264 contract multiowned {
265 
266 	// TYPES
267 
268     // struct for the status of a pending operation.
269     struct PendingState {
270         uint yetNeeded;
271         uint ownersDone;
272         uint index;
273     }
274 
275 	// EVENTS
276 
277     // this contract only has six types of events: it can accept a confirmation, in which case
278     // we record owner and operation (hash) alongside it.
279     event Confirmation(address owner, bytes32 operation);
280     event Revoke(address owner, bytes32 operation);
281     // some others are in the case of an owner changing.
282     event OwnerChanged(address oldOwner, address newOwner);
283     event OwnerAdded(address newOwner);
284     event OwnerRemoved(address oldOwner);
285     // the last one is emitted if the required signatures change
286     event RequirementChanged(uint newRequirement);
287 
288 	// MODIFIERS
289 
290     // simple single-sig function modifier.
291     modifier onlyowner {
292         if (isOwner(msg.sender))
293             _;
294     }
295     // multi-sig function modifier: the operation must have an intrinsic hash in order
296     // that later attempts can be realised as the same underlying operation and
297     // thus count as confirmations.
298     modifier onlymanyowners(bytes32 _operation) {
299         if (confirmAndCheck(_operation))
300             _;
301     }
302 
303 	// METHODS
304 
305     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
306     // as well as the selection of addresses capable of confirming them.
307     function multiowned(address[] _owners, uint _required) {
308         m_numOwners = _owners.length + 1;
309         m_owners[1] = uint(msg.sender);
310         m_ownerIndex[uint(msg.sender)] = 1;
311         for (uint i = 0; i < _owners.length; ++i)
312         {
313             m_owners[2 + i] = uint(_owners[i]);
314             m_ownerIndex[uint(_owners[i])] = 2 + i;
315         }
316         m_required = _required;
317     }
318 
319     // Revokes a prior confirmation of the given operation
320     function revoke(bytes32 _operation) external {
321         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
322         // make sure they're an owner
323         if (ownerIndex == 0) return;
324         uint ownerIndexBit = 2**ownerIndex;
325         var pending = m_pending[_operation];
326         if (pending.ownersDone & ownerIndexBit > 0) {
327             pending.yetNeeded++;
328             pending.ownersDone -= ownerIndexBit;
329             Revoke(msg.sender, _operation);
330         }
331     }
332 
333     // Replaces an owner `_from` with another `_to`.
334     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
335         if (isOwner(_to)) return;
336         uint ownerIndex = m_ownerIndex[uint(_from)];
337         if (ownerIndex == 0) return;
338 
339         clearPending();
340         m_owners[ownerIndex] = uint(_to);
341         m_ownerIndex[uint(_from)] = 0;
342         m_ownerIndex[uint(_to)] = ownerIndex;
343         OwnerChanged(_from, _to);
344     }
345 
346     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
347         if (isOwner(_owner)) return;
348 
349         clearPending();
350         if (m_numOwners >= c_maxOwners)
351             reorganizeOwners();
352         if (m_numOwners >= c_maxOwners)
353             return;
354         m_numOwners++;
355         m_owners[m_numOwners] = uint(_owner);
356         m_ownerIndex[uint(_owner)] = m_numOwners;
357         OwnerAdded(_owner);
358     }
359 
360     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
361         uint ownerIndex = m_ownerIndex[uint(_owner)];
362         if (ownerIndex == 0) return;
363         if (m_required > m_numOwners - 1) return;
364 
365         m_owners[ownerIndex] = 0;
366         m_ownerIndex[uint(_owner)] = 0;
367         clearPending();
368         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
369         OwnerRemoved(_owner);
370     }
371 
372     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
373         if (_newRequired > m_numOwners) return;
374         m_required = _newRequired;
375         clearPending();
376         RequirementChanged(_newRequired);
377     }
378 
379     // Gets an owner by 0-indexed position (using numOwners as the count)
380     function getOwner(uint ownerIndex) external constant returns (address) {
381         return address(m_owners[ownerIndex + 1]);
382     }
383 
384     function isOwner(address _addr) returns (bool) {
385         return m_ownerIndex[uint(_addr)] > 0;
386     }
387 
388     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
389         var pending = m_pending[_operation];
390         uint ownerIndex = m_ownerIndex[uint(_owner)];
391 
392         // make sure they're an owner
393         if (ownerIndex == 0) return false;
394 
395         // determine the bit to set for this owner.
396         uint ownerIndexBit = 2**ownerIndex;
397         return !(pending.ownersDone & ownerIndexBit == 0);
398     }
399 
400     // INTERNAL METHODS
401 
402     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
403         // determine what index the present sender is:
404         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
405         // make sure they're an owner
406         if (ownerIndex == 0) return;
407 
408         var pending = m_pending[_operation];
409         // if we're not yet working on this operation, switch over and reset the confirmation status.
410         if (pending.yetNeeded == 0) {
411             // reset count of confirmations needed.
412             pending.yetNeeded = m_required;
413             // reset which owners have confirmed (none) - set our bitmap to 0.
414             pending.ownersDone = 0;
415             pending.index = m_pendingIndex.length++;
416             m_pendingIndex[pending.index] = _operation;
417         }
418         // determine the bit to set for this owner.
419         uint ownerIndexBit = 2**ownerIndex;
420         // make sure we (the message sender) haven't confirmed this operation previously.
421         if (pending.ownersDone & ownerIndexBit == 0) {
422             Confirmation(msg.sender, _operation);
423             // ok - check if count is enough to go ahead.
424             if (pending.yetNeeded <= 1) {
425                 // enough confirmations: reset and run interior.
426                 delete m_pendingIndex[m_pending[_operation].index];
427                 delete m_pending[_operation];
428                 return true;
429             }
430             else
431             {
432                 // not enough: record that this owner in particular confirmed.
433                 pending.yetNeeded--;
434                 pending.ownersDone |= ownerIndexBit;
435             }
436         }
437     }
438 
439     function reorganizeOwners() private {
440         uint free = 1;
441         while (free < m_numOwners)
442         {
443             while (free < m_numOwners && m_owners[free] != 0) free++;
444             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
445             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
446             {
447                 m_owners[free] = m_owners[m_numOwners];
448                 m_ownerIndex[m_owners[free]] = free;
449                 m_owners[m_numOwners] = 0;
450             }
451         }
452     }
453 
454     function clearPending() internal {
455         uint length = m_pendingIndex.length;
456         for (uint i = 0; i < length; ++i)
457             if (m_pendingIndex[i] != 0)
458                 delete m_pending[m_pendingIndex[i]];
459         delete m_pendingIndex;
460     }
461 
462    	// FIELDS
463 
464     // the number of owners that must confirm the same operation before it is run.
465     uint public m_required;
466     // pointer used to find a free slot in m_owners
467     uint public m_numOwners;
468 
469     // list of owners
470     uint[256] m_owners;
471     uint constant c_maxOwners = 250;
472     // index on the list of owners to allow reverse lookup
473     mapping(uint => uint) m_ownerIndex;
474     // the ongoing operations.
475     mapping(bytes32 => PendingState) m_pending;
476     bytes32[] m_pendingIndex;
477 }
478 
479 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
480 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
481 // uses is specified in the modifier.
482 contract daylimit is multiowned {
483 
484 	// MODIFIERS
485 
486     // simple modifier for daily limit.
487     modifier limitedDaily(uint _value) {
488         if (underLimit(_value))
489             _;
490     }
491 
492 	// METHODS
493 
494     // constructor - stores initial daily limit and records the present day's index.
495     function daylimit(uint _limit) {
496         m_dailyLimit = _limit;
497         m_lastDay = today();
498     }
499     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
500     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
501         m_dailyLimit = _newLimit;
502     }
503     // resets the amount already spent today. needs many of the owners to confirm.
504     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
505         m_spentToday = 0;
506     }
507 
508     // INTERNAL METHODS
509 
510     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
511     // returns true. otherwise just returns false.
512     function underLimit(uint _value) internal onlyowner returns (bool) {
513         // reset the spend limit if we're on a different day to last time.
514         if (today() > m_lastDay) {
515             m_spentToday = 0;
516             m_lastDay = today();
517         }
518         // check if it's sending nothing (with or without data). This needs Multitransact
519         if (_value == 0) return false;
520 
521         // check to see if there's enough left - if so, subtract and return true.
522         // overflow protection                    // dailyLimit check
523         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
524             m_spentToday += _value;
525             return true;
526         }
527         return false;
528     }
529     // determines today's index.
530     function today() private constant returns (uint) { return now / 1 days; }
531 
532 	// FIELDS
533 
534     uint public m_dailyLimit;
535     uint public m_spentToday;
536     uint public m_lastDay;
537 }
538 
539 // interface contract for multisig proxy contracts; see below for docs.
540 contract multisig {
541 
542 	// EVENTS
543 
544     // logged events:
545     // Funds has arrived into the wallet (record how much).
546     event Deposit(address _from, uint value);
547     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
548     event SingleTransact(address owner, uint value, address to, bytes data);
549     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
550     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
551     // Confirmation still needed for a transaction.
552     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
553 
554     // FUNCTIONS
555 
556     // TODO: document
557     function changeOwner(address _from, address _to) external;
558     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
559     function confirm(bytes32 _h) returns (bool);
560 }
561 
562 contract tokenswap is multisig, multiowned {
563     Token public tokenCtr;
564     bool public tokenSwap;
565     uint public constant PRESALE_LENGTH = 3 days;
566     uint public constant SWAP_LENGTH = PRESALE_LENGTH + 6 weeks + 6 days + 3 hours;
567     uint public constant MAX_ETH = 75000 ether; // Hard cap, capped otherwise by total tokens sold (max 7.5M FYN)
568     uint public amountRaised;
569 
570     modifier isUnderPresaleMinimum {
571         if (tokenCtr.creationTime() + PRESALE_LENGTH > now) {
572             if (msg.value < 20 ether) throw;
573         }
574         _;
575     }
576 
577     modifier isZeroValue {
578         if (msg.value == 0) throw;
579         _;
580     }
581 
582     modifier isOverCap {
583     	if (amountRaised + msg.value > MAX_ETH) throw;
584         _;
585     }
586 
587     modifier isOverTokenCap {
588         if (!safeToMultiply(tokenCtr.currentSwapRate(), msg.value)) throw;
589         uint tokensAmount = tokenCtr.currentSwapRate() * msg.value;
590         if(!safeToAdd(tokenCtr.totalSupply(),tokensAmount)) throw;
591         if (tokenCtr.totalSupply() + tokensAmount > tokenCtr.tokenCap()) throw;
592         _;
593 
594     }
595 
596     modifier isSwapStopped {
597         if (!tokenSwap) throw;
598         _;
599     }
600 
601     modifier areConditionsSatisfied {
602         _;
603         // End token swap if sale period ended
604         // We can't throw to reverse the amount sent in or we will lose state
605         // , so we will accept it even though if it is after crowdsale
606         if (tokenCtr.creationTime() + SWAP_LENGTH < now) {
607             tokenCtr.disableTokenSwapLock();
608             tokenSwap = false;
609         }
610         // Check if cap has been reached in this tx
611         if (amountRaised == MAX_ETH) {
612             tokenCtr.disableTokenSwapLock();
613             tokenSwap = false;
614         }
615 
616         // Check if token cap has been reach in this tx
617         if (tokenCtr.totalSupply() == tokenCtr.tokenCap()) {
618             tokenCtr.disableTokenSwapLock();
619             tokenSwap = false;
620         }
621     }
622 
623     // A helper to notify if overflow occurs for addition
624     function safeToAdd(uint a, uint b) private constant returns (bool) {
625       return (a + b >= a && a + b >= b);
626     }
627   
628     // A helper to notify if overflow occurs for multiplication
629     function safeToMultiply(uint _a, uint _b) private constant returns (bool) {
630       return (_b == 0 || ((_a * _b) / _b) == _a);
631     }
632 
633 
634     function startTokenSwap() onlyowner {
635         tokenSwap = true;
636     }
637 
638     function stopTokenSwap() onlyowner {
639         tokenSwap = false;
640     }
641 
642     function setTokenContract(address newTokenContractAddr) onlyowner {
643         if (newTokenContractAddr == address(0x0)) throw;
644         // Allow setting only once
645         if (tokenCtr != address(0x0)) throw;
646 
647         tokenCtr = Token(newTokenContractAddr);
648     }
649 
650     function buyTokens(address _beneficiary)
651     payable
652     isUnderPresaleMinimum
653     isZeroValue
654     isOverCap
655     isOverTokenCap
656     isSwapStopped
657     areConditionsSatisfied {
658         Deposit(msg.sender, msg.value);
659         tokenCtr.mintTokens(_beneficiary, msg.value);
660         if (!safeToAdd(amountRaised, msg.value)) throw;
661         amountRaised += msg.value;
662     }
663 
664     function withdrawReserve(address _beneficiary) onlyowner {
665 	    if (tokenCtr.creationTime() + SWAP_LENGTH < now) {
666             tokenCtr.mintReserve(_beneficiary);
667         }
668     } 
669 }
670 
671 // usage:
672 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
673 // Wallet(w).from(anotherOwner).confirm(h);
674 contract Wallet is multisig, multiowned, daylimit, tokenswap {
675 
676 	// TYPES
677 
678     // Transaction structure to remember details of transaction lest it need be saved for a later call.
679     struct Transaction {
680         address to;
681         uint value;
682         bytes data;
683     }
684 
685     // METHODS
686 
687     // constructor - just pass on the owner array to the multiowned and
688     // the limit to daylimit
689     function Wallet(address[] _owners, uint _required, uint _daylimit)
690             multiowned(_owners, _required) daylimit(_daylimit) {
691     }
692 
693     // kills the contract sending everything to `_to`.
694     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
695         // ensure owners can't prematurely stop token sale
696         if (tokenSwap) throw;
697         // ensure owners can't kill wallet without stopping token
698         //  otherwise token can never be stopped
699         if (tokenCtr.transferStop() == false) throw;
700         suicide(_to);
701     }
702 
703     // Activates Emergency Stop for Token
704     function stopToken() onlymanyowners(sha3(msg.data)) external {
705        tokenCtr.stopToken();
706     }
707 
708     // gets called when no other function matches
709     function()
710     payable {
711         buyTokens(msg.sender);
712     }
713 
714     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
715     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
716     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
717     // and _data arguments). They still get the option of using them if they want, anyways.
718     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
719         // Disallow the wallet contract from calling token contract once it's set
720         // so tokens can't be minted arbitrarily once the sale starts.
721         // Tokens can be minted for premine before the sale opens and tokenCtr is set.
722         if (_to == address(tokenCtr)) throw;
723 
724         // first, take the opportunity to check that we're under the daily limit.
725         if (underLimit(_value)) {
726             SingleTransact(msg.sender, _value, _to, _data);
727             // yes - just execute the call.
728             if(!_to.call.value(_value)(_data))
729             return 0;
730         }
731 
732         // determine our operation hash.
733         _r = sha3(msg.data, block.number);
734         if (!confirm(_r) && m_txs[_r].to == 0) {
735             m_txs[_r].to = _to;
736             m_txs[_r].value = _value;
737             m_txs[_r].data = _data;
738             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
739         }
740     }
741 
742     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
743     // to determine the body of the transaction from the hash provided.
744     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
745         if (m_txs[_h].to != 0) {
746             if (!m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data))   // Bugfix: If successful, MultiTransact event should fire; if unsuccessful, we should throw
747                 throw;
748             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
749             delete m_txs[_h];
750             return true;
751         }
752     }
753 
754     // INTERNAL METHODS
755 
756     function clearPending() internal {
757         uint length = m_pendingIndex.length;
758         for (uint i = 0; i < length; ++i)
759             delete m_txs[m_pendingIndex[i]];
760         super.clearPending();
761     }
762 
763 	// FIELDS
764 
765     // pending transactions we have at present.
766     mapping (bytes32 => Transaction) m_txs;
767 }