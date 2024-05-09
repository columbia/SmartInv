1 pragma solidity ^0.4.0;
2 /*
3 This vSlice token contract is based on the ERC20 token contract. Additional
4 functionality has been integrated:
5 * the contract Lockable, which is used as a parent of the Token contract
6 * the function mintTokens(), which makes use of the currentSwapRate() and safeToAdd() helpers
7 * the function disableTokenSwapLock()
8 */
9 
10 contract Lockable {
11     uint public numOfCurrentEpoch;
12     uint public creationTime;
13     uint public constant UNLOCKED_TIME = 25 days;
14     uint public constant LOCKED_TIME = 5 days;
15     uint public constant EPOCH_LENGTH = 30 days;
16     bool public lock;
17     bool public tokenSwapLock;
18 
19     event Locked();
20     event Unlocked();
21 
22     // This modifier should prevent tokens transfers while the tokenswap
23     // is still ongoing
24     modifier isTokenSwapOn {
25         if (tokenSwapLock) throw;
26         _;
27     }
28 
29     // This modifier checks and, if needed, updates the value of current
30     // token contract epoch, before executing a token transfer of any
31     // kind
32     modifier isNewEpoch {
33         if (numOfCurrentEpoch * EPOCH_LENGTH + creationTime < now ) {
34             numOfCurrentEpoch = (now - creationTime) / EPOCH_LENGTH + 1;
35         }
36         _;
37     }
38 
39     // This modifier check whether the contract should be in a locked
40     // or unlocked state, then acts and updates accordingly if
41     // necessary
42     modifier checkLock {
43         if ((creationTime + numOfCurrentEpoch * UNLOCKED_TIME) +
44         (numOfCurrentEpoch - 1) * LOCKED_TIME < now) {
45             // avoids needless lock state change and event spamming
46             if (lock) throw;
47 
48             lock = true;
49             Locked();
50             return;
51         }
52         else {
53             // only set to false if in a locked state, to avoid
54             // needless state change and event spam
55             if (lock) {
56                 lock = false;
57                 Unlocked();
58             }
59         }
60         _;
61     }
62 
63     function Lockable() {
64         creationTime = now;
65         numOfCurrentEpoch = 1;
66         tokenSwapLock = true;
67     }
68 }
69 
70 
71 contract ERC20 {
72     function totalSupply() constant returns (uint);
73     function balanceOf(address who) constant returns (uint);
74     function allowance(address owner, address spender) constant returns (uint);
75 
76     function transfer(address to, uint value) returns (bool ok);
77     function transferFrom(address from, address to, uint value) returns (bool ok);
78     function approve(address spender, uint value) returns (bool ok);
79 
80     event Transfer(address indexed from, address indexed to, uint value);
81     event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 contract Token is ERC20, Lockable {
85 
86   mapping( address => uint ) _balances;
87   mapping( address => mapping( address => uint ) ) _approvals;
88   uint _supply;
89   address public walletAddress;
90 
91   event TokenMint(address newTokenHolder, uint amountOfTokens);
92   event TokenSwapOver();
93 
94   modifier onlyFromWallet {
95       if (msg.sender != walletAddress) throw;
96       _;
97   }
98 
99   function Token( uint initial_balance, address wallet) {
100     _balances[msg.sender] = initial_balance;
101     _supply = initial_balance;
102     walletAddress = wallet;
103   }
104 
105   function totalSupply() constant returns (uint supply) {
106     return _supply;
107   }
108 
109   function balanceOf( address who ) constant returns (uint value) {
110     return _balances[who];
111   }
112 
113   function allowance(address owner, address spender) constant returns (uint _allowance) {
114     return _approvals[owner][spender];
115   }
116 
117   // A helper to notify if overflow occurs
118   function safeToAdd(uint a, uint b) internal returns (bool) {
119     return (a + b >= a && a + b >= b);
120   }
121 
122   function transfer( address to, uint value)
123     isTokenSwapOn
124     isNewEpoch
125     checkLock
126     returns (bool ok) {
127 
128     if( _balances[msg.sender] < value ) {
129         throw;
130     }
131     if( !safeToAdd(_balances[to], value) ) {
132         throw;
133     }
134 
135     _balances[msg.sender] -= value;
136     _balances[to] += value;
137     Transfer( msg.sender, to, value );
138     return true;
139   }
140 
141   function transferFrom( address from, address to, uint value)
142     isTokenSwapOn
143     isNewEpoch
144     checkLock
145     returns (bool ok) {
146     // if you don't have enough balance, throw
147     if( _balances[from] < value ) {
148         throw;
149     }
150     // if you don't have approval, throw
151     if( _approvals[from][msg.sender] < value ) {
152         throw;
153     }
154     if( !safeToAdd(_balances[to], value) ) {
155         throw;
156     }
157     // transfer and return true
158     _approvals[from][msg.sender] -= value;
159     _balances[from] -= value;
160     _balances[to] += value;
161     Transfer( from, to, value );
162     return true;
163   }
164 
165   function approve(address spender, uint value)
166     isTokenSwapOn
167     isNewEpoch
168     checkLock
169     returns (bool ok) {
170     _approvals[msg.sender][spender] = value;
171     Approval( msg.sender, spender, value );
172     return true;
173   }
174 
175   // The function currentSwapRate() returns the current exchange rate
176   // between vSlice tokens and Ether during the token swap period
177   function currentSwapRate() constant returns(uint) {
178       if (creationTime + 1 weeks > now) {
179           return 130;
180       }
181       else if (creationTime + 2 weeks > now) {
182           return 120;
183       }
184       else if (creationTime + 4 weeks > now) {
185           return 100;
186       }
187       else {
188           return 0;
189       }
190   }
191 
192   // The function mintTokens is only usable by the chosen wallet
193   // contract to mint a number of tokens proportional to the
194   // amount of ether sent to the wallet contract. The function
195   // can only be called during the tokenswap period
196   function mintTokens(address newTokenHolder, uint etherAmount)
197     external
198     onlyFromWallet {
199 
200         uint tokensAmount = currentSwapRate() * etherAmount;
201         if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw;
202         if(!safeToAdd(_supply,tokensAmount)) throw;
203 
204         _balances[newTokenHolder] += tokensAmount;
205         _supply += tokensAmount;
206 
207         TokenMint(newTokenHolder, tokensAmount);
208   }
209 
210   // The function disableTokenSwapLock() is called by the wallet
211   // contract once the token swap has reached its end conditions
212   function disableTokenSwapLock()
213     external
214     onlyFromWallet {
215         tokenSwapLock = false;
216         TokenSwapOver();
217   }
218 }
219 
220 pragma solidity ^0.4.0;
221 
222 /*
223 The standard Wallet contract, retrievable at
224 https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol has been
225 modified to include additional functionality, in particular:
226 * An additional parent of wallet contract called tokenswap, implementing almost
227 all the changes:
228     - Functions for starting and stopping the tokenswap
229     - A set-only-once function for the token contract
230     - buyTokens(), which calls mintTokens() in the token contract
231     - Modifiers for enforcing tokenswap time limits and max ether cap
232 * the wallet fallback function calls the buyTokens function
233 * the wallet contract cannot selfdestruct during the tokenswap
234 */
235 
236 contract multiowned {
237 
238 	// TYPES
239 
240     // struct for the status of a pending operation.
241     struct PendingState {
242         uint yetNeeded;
243         uint ownersDone;
244         uint index;
245     }
246 
247 	// EVENTS
248 
249     // this contract only has six types of events: it can accept a confirmation, in which case
250     // we record owner and operation (hash) alongside it.
251     event Confirmation(address owner, bytes32 operation);
252     event Revoke(address owner, bytes32 operation);
253     // some others are in the case of an owner changing.
254     event OwnerChanged(address oldOwner, address newOwner);
255     event OwnerAdded(address newOwner);
256     event OwnerRemoved(address oldOwner);
257     // the last one is emitted if the required signatures change
258     event RequirementChanged(uint newRequirement);
259 
260 	// MODIFIERS
261 
262     // simple single-sig function modifier.
263     modifier onlyowner {
264         if (isOwner(msg.sender))
265             _;
266     }
267     // multi-sig function modifier: the operation must have an intrinsic hash in order
268     // that later attempts can be realised as the same underlying operation and
269     // thus count as confirmations.
270     modifier onlymanyowners(bytes32 _operation) {
271         if (confirmAndCheck(_operation))
272             _;
273     }
274 
275 	// METHODS
276 
277     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
278     // as well as the selection of addresses capable of confirming them.
279     function multiowned(address[] _owners, uint _required) {
280         m_numOwners = _owners.length + 1;
281         m_owners[1] = uint(msg.sender);
282         m_ownerIndex[uint(msg.sender)] = 1;
283         for (uint i = 0; i < _owners.length; ++i)
284         {
285             m_owners[2 + i] = uint(_owners[i]);
286             m_ownerIndex[uint(_owners[i])] = 2 + i;
287         }
288         m_required = _required;
289     }
290 
291     // Revokes a prior confirmation of the given operation
292     function revoke(bytes32 _operation) external {
293         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
294         // make sure they're an owner
295         if (ownerIndex == 0) return;
296         uint ownerIndexBit = 2**ownerIndex;
297         var pending = m_pending[_operation];
298         if (pending.ownersDone & ownerIndexBit > 0) {
299             pending.yetNeeded++;
300             pending.ownersDone -= ownerIndexBit;
301             Revoke(msg.sender, _operation);
302         }
303     }
304 
305     // Replaces an owner `_from` with another `_to`.
306     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
307         if (isOwner(_to)) return;
308         uint ownerIndex = m_ownerIndex[uint(_from)];
309         if (ownerIndex == 0) return;
310 
311         clearPending();
312         m_owners[ownerIndex] = uint(_to);
313         m_ownerIndex[uint(_from)] = 0;
314         m_ownerIndex[uint(_to)] = ownerIndex;
315         OwnerChanged(_from, _to);
316     }
317 
318     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
319         if (isOwner(_owner)) return;
320 
321         clearPending();
322         if (m_numOwners >= c_maxOwners)
323             reorganizeOwners();
324         if (m_numOwners >= c_maxOwners)
325             return;
326         m_numOwners++;
327         m_owners[m_numOwners] = uint(_owner);
328         m_ownerIndex[uint(_owner)] = m_numOwners;
329         OwnerAdded(_owner);
330     }
331 
332     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
333         uint ownerIndex = m_ownerIndex[uint(_owner)];
334         if (ownerIndex == 0) return;
335         if (m_required > m_numOwners - 1) return;
336 
337         m_owners[ownerIndex] = 0;
338         m_ownerIndex[uint(_owner)] = 0;
339         clearPending();
340         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
341         OwnerRemoved(_owner);
342     }
343 
344     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
345         if (_newRequired > m_numOwners) return;
346         m_required = _newRequired;
347         clearPending();
348         RequirementChanged(_newRequired);
349     }
350 
351     // Gets an owner by 0-indexed position (using numOwners as the count)
352     function getOwner(uint ownerIndex) external constant returns (address) {
353         return address(m_owners[ownerIndex + 1]);
354     }
355 
356     function isOwner(address _addr) returns (bool) {
357         return m_ownerIndex[uint(_addr)] > 0;
358     }
359 
360     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
361         var pending = m_pending[_operation];
362         uint ownerIndex = m_ownerIndex[uint(_owner)];
363 
364         // make sure they're an owner
365         if (ownerIndex == 0) return false;
366 
367         // determine the bit to set for this owner.
368         uint ownerIndexBit = 2**ownerIndex;
369         return !(pending.ownersDone & ownerIndexBit == 0);
370     }
371 
372     // INTERNAL METHODS
373 
374     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
375         // determine what index the present sender is:
376         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
377         // make sure they're an owner
378         if (ownerIndex == 0) return;
379 
380         var pending = m_pending[_operation];
381         // if we're not yet working on this operation, switch over and reset the confirmation status.
382         if (pending.yetNeeded == 0) {
383             // reset count of confirmations needed.
384             pending.yetNeeded = m_required;
385             // reset which owners have confirmed (none) - set our bitmap to 0.
386             pending.ownersDone = 0;
387             pending.index = m_pendingIndex.length++;
388             m_pendingIndex[pending.index] = _operation;
389         }
390         // determine the bit to set for this owner.
391         uint ownerIndexBit = 2**ownerIndex;
392         // make sure we (the message sender) haven't confirmed this operation previously.
393         if (pending.ownersDone & ownerIndexBit == 0) {
394             Confirmation(msg.sender, _operation);
395             // ok - check if count is enough to go ahead.
396             if (pending.yetNeeded <= 1) {
397                 // enough confirmations: reset and run interior.
398                 delete m_pendingIndex[m_pending[_operation].index];
399                 delete m_pending[_operation];
400                 return true;
401             }
402             else
403             {
404                 // not enough: record that this owner in particular confirmed.
405                 pending.yetNeeded--;
406                 pending.ownersDone |= ownerIndexBit;
407             }
408         }
409     }
410 
411     function reorganizeOwners() private {
412         uint free = 1;
413         while (free < m_numOwners)
414         {
415             while (free < m_numOwners && m_owners[free] != 0) free++;
416             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
417             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
418             {
419                 m_owners[free] = m_owners[m_numOwners];
420                 m_ownerIndex[m_owners[free]] = free;
421                 m_owners[m_numOwners] = 0;
422             }
423         }
424     }
425 
426     function clearPending() internal {
427         uint length = m_pendingIndex.length;
428         for (uint i = 0; i < length; ++i)
429             if (m_pendingIndex[i] != 0)
430                 delete m_pending[m_pendingIndex[i]];
431         delete m_pendingIndex;
432     }
433 
434    	// FIELDS
435 
436     // the number of owners that must confirm the same operation before it is run.
437     uint public m_required;
438     // pointer used to find a free slot in m_owners
439     uint public m_numOwners;
440 
441     // list of owners
442     uint[256] m_owners;
443     uint constant c_maxOwners = 250;
444     // index on the list of owners to allow reverse lookup
445     mapping(uint => uint) m_ownerIndex;
446     // the ongoing operations.
447     mapping(bytes32 => PendingState) m_pending;
448     bytes32[] m_pendingIndex;
449 }
450 
451 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
452 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
453 // uses is specified in the modifier.
454 contract daylimit is multiowned {
455 
456 	// MODIFIERS
457 
458     // simple modifier for daily limit.
459     modifier limitedDaily(uint _value) {
460         if (underLimit(_value))
461             _;
462     }
463 
464 	// METHODS
465 
466     // constructor - stores initial daily limit and records the present day's index.
467     function daylimit(uint _limit) {
468         m_dailyLimit = _limit;
469         m_lastDay = today();
470     }
471     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
472     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
473         m_dailyLimit = _newLimit;
474     }
475     // resets the amount already spent today. needs many of the owners to confirm.
476     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
477         m_spentToday = 0;
478     }
479 
480     // INTERNAL METHODS
481 
482     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
483     // returns true. otherwise just returns false.
484     function underLimit(uint _value) internal onlyowner returns (bool) {
485         // reset the spend limit if we're on a different day to last time.
486         if (today() > m_lastDay) {
487             m_spentToday = 0;
488             m_lastDay = today();
489         }
490         // check to see if there's enough left - if so, subtract and return true.
491         // overflow protection                    // dailyLimit check
492         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
493             m_spentToday += _value;
494             return true;
495         }
496         return false;
497     }
498     // determines today's index.
499     function today() private constant returns (uint) { return now / 1 days; }
500 
501 	// FIELDS
502 
503     uint public m_dailyLimit;
504     uint public m_spentToday;
505     uint public m_lastDay;
506 }
507 
508 // interface contract for multisig proxy contracts; see below for docs.
509 contract multisig {
510 
511 	// EVENTS
512 
513     // logged events:
514     // Funds has arrived into the wallet (record how much).
515     event Deposit(address _from, uint value);
516     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
517     event SingleTransact(address owner, uint value, address to, bytes data);
518     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
519     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
520     // Confirmation still needed for a transaction.
521     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
522 
523     // FUNCTIONS
524 
525     // TODO: document
526     function changeOwner(address _from, address _to) external;
527     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
528     function confirm(bytes32 _h) returns (bool);
529 }
530 
531 contract tokenswap is multisig, multiowned {
532     Token public tokenCtr;
533     bool public tokenSwap;
534     uint public constant SWAP_LENGTH = 4  weeks;
535     uint public constant MAX_ETH = 700000 ether;
536     uint public amountRaised;
537 
538     modifier isZeroValue {
539         if (msg.value == 0) throw;
540         _;
541     }
542 
543     modifier isOverCap {
544 	if (amountRaised + msg.value > MAX_ETH) throw;
545         _;
546     }
547 
548     modifier isSwapStopped {
549         if (!tokenSwap) throw;
550         _;
551     }
552 
553     modifier areConditionsSatisfied {
554 	// End token swap if sale period ended
555 	if (tokenCtr.creationTime() + SWAP_LENGTH < now) {
556             tokenCtr.disableTokenSwapLock();
557             tokenSwap = false;
558         }
559         else {
560             _;
561 	        // Check if cap has been reached in this tx
562             if (amountRaised == MAX_ETH) {
563                 tokenCtr.disableTokenSwapLock();
564                 tokenSwap = false;
565             }
566         }
567     }
568 
569     function safeToAdd(uint a, uint b) internal returns (bool) {
570       return (a + b >= a && a + b >= b);
571     }
572 
573     function startTokenSwap() onlyowner {
574         tokenSwap = true;
575     }
576 
577     function stopTokenSwap() onlyowner {
578         tokenSwap = false;
579     }
580 
581     function setTokenContract(address newTokenContractAddr) onlyowner {
582         if (newTokenContractAddr == address(0x0)) throw;
583         // Allow setting only once
584         if (tokenCtr != address(0x0)) throw;
585 
586         tokenCtr = Token(newTokenContractAddr);
587     }
588 
589     function buyTokens(address _beneficiary)
590     payable
591     isZeroValue
592     isOverCap
593     isSwapStopped
594     areConditionsSatisfied {
595         Deposit(msg.sender, msg.value);
596         tokenCtr.mintTokens(_beneficiary, msg.value);
597         if (!safeToAdd(amountRaised, msg.value)) throw;
598         amountRaised += msg.value;
599     }
600 }
601 
602 // usage:
603 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
604 // Wallet(w).from(anotherOwner).confirm(h);
605 contract Wallet is multisig, multiowned, daylimit, tokenswap {
606 
607 	// TYPES
608 
609     // Transaction structure to remember details of transaction lest it need be saved for a later call.
610     struct Transaction {
611         address to;
612         uint value;
613         bytes data;
614     }
615 
616     // METHODS
617 
618     // constructor - just pass on the owner array to the multiowned and
619     // the limit to daylimit
620     function Wallet(address[] _owners, uint _required, uint _daylimit)
621             multiowned(_owners, _required) daylimit(_daylimit) {
622     }
623 
624     // kills the contract sending everything to `_to`.
625     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
626         //ensure owners can't prematurely stop token sale
627         //and then render tokens untradable, as without this
628         //check, the tokenSwapLock would never get disiabled
629         //if this fires
630         if (tokenCtr.tokenSwapLock()) throw;
631 
632         suicide(_to);
633     }
634 
635     // gets called when no other function matches
636     function()
637     payable {
638         buyTokens(msg.sender);
639     }
640 
641     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
642     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
643     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
644     // and _data arguments). They still get the option of using them if they want, anyways.
645     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
646         // Disallow the wallet contract from calling token contract once it's set
647         // so tokens can't be minted arbitrarily once the sale starts.
648         // Tokens can be minted for premine before the sale opens and tokenCtr is set.
649         if (_to == address(tokenCtr)) throw;
650 
651         // first, take the opportunity to check that we're under the daily limit.
652         if (underLimit(_value)) {
653             SingleTransact(msg.sender, _value, _to, _data);
654             // yes - just execute the call.
655             if(!_to.call.value(_value)(_data))
656             return 0;
657         }
658         // determine our operation hash.
659         _r = sha3(msg.data, block.number);
660         if (!confirm(_r) && m_txs[_r].to == 0) {
661             m_txs[_r].to = _to;
662             m_txs[_r].value = _value;
663             m_txs[_r].data = _data;
664             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
665         }
666     }
667 
668     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
669     // to determine the body of the transaction from the hash provided.
670     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
671         if (m_txs[_h].to != 0) {
672             if(!m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data))
673             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
674             delete m_txs[_h];
675             return true;
676         }
677     }
678 
679     // INTERNAL METHODS
680 
681     function clearPending() internal {
682         uint length = m_pendingIndex.length;
683         for (uint i = 0; i < length; ++i)
684             delete m_txs[m_pendingIndex[i]];
685         super.clearPending();
686     }
687 
688 	// FIELDS
689 
690     // pending transactions we have at present.
691     mapping (bytes32 => Transaction) m_txs;
692 }