1 //sol Wallet
2 // Multi-sig, daily-limited account proxy/wallet.
3 // @authors:
4 // Gav Wood <g@ethdev.com>
5 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
6 // single, or, crucially, each of a number of, designated owners.
7 // usage:
8 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
9 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
10 // interior is executed.
11 
12 pragma solidity ^0.4.9;
13 
14 contract WalletEvents {
15   // EVENTS
16 
17   // this contract only has six types of events: it can accept a confirmation, in which case
18   // we record owner and operation (hash) alongside it.
19   event Confirmation(address owner, bytes32 operation);
20   event Revoke(address owner, bytes32 operation);
21 
22   // some others are in the case of an owner changing.
23   event OwnerChanged(address oldOwner, address newOwner);
24   event OwnerAdded(address newOwner);
25   event OwnerRemoved(address oldOwner);
26 
27   // the last one is emitted if the required signatures change
28   event RequirementChanged(uint newRequirement);
29 
30   // Funds has arrived into the wallet (record how much).
31   event Deposit(address _from, uint value);
32   // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
33   event SingleTransact(address owner, uint value, address to, bytes data, address created);
34   // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
35   event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data, address created);
36   // Confirmation still needed for a transaction.
37   event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
38 }
39 
40 contract WalletAbi {
41   // Revokes a prior confirmation of the given operation
42   function revoke(bytes32 _operation) external;
43 
44   // Replaces an owner `_from` with another `_to`.
45   function changeOwner(address _from, address _to) external;
46 
47   function addOwner(address _owner) external;
48 
49   function removeOwner(address _owner) external;
50 
51   function changeRequirement(uint _newRequired) external;
52 
53   function isOwner(address _addr) constant returns (bool);
54 
55   function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool);
56 
57   // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
58   function setDailyLimit(uint _newLimit) external;
59 
60   function execute(address _to, uint _value, bytes _data) external returns (bytes32 o_hash);
61   function confirm(bytes32 _h) returns (bool o_success);
62 }
63 
64 contract WalletLibrary is WalletEvents {
65   // TYPES
66 
67   // struct for the status of a pending operation.
68   struct PendingState {
69     uint yetNeeded;
70     uint ownersDone;
71     uint index;
72   }
73 
74   // Transaction structure to remember details of transaction lest it need be saved for a later call.
75   struct Transaction {
76     address to;
77     uint value;
78     bytes data;
79   }
80 
81   // MODIFIERS
82 
83   // simple single-sig function modifier.
84   modifier onlyowner {
85     if (isOwner(msg.sender))
86       _;
87   }
88   // multi-sig function modifier: the operation must have an intrinsic hash in order
89   // that later attempts can be realised as the same underlying operation and
90   // thus count as confirmations.
91   modifier onlymanyowners(bytes32 _operation) {
92     if (confirmAndCheck(_operation))
93       _;
94   }
95 
96   // METHODS
97 
98   // gets called when no other function matches
99   function() payable {
100     // just being sent some cash?
101     if (msg.value > 0)
102       Deposit(msg.sender, msg.value);
103   }
104 
105   // constructor is given number of sigs required to do protected "onlymanyowners" transactions
106   // as well as the selection of addresses capable of confirming them.
107   function initMultiowned(address[] _owners, uint _required) only_uninitialized {
108     m_numOwners = _owners.length + 1;
109     m_owners[1] = uint(msg.sender);
110     m_ownerIndex[uint(msg.sender)] = 1;
111     for (uint i = 0; i < _owners.length; ++i)
112     {
113       m_owners[2 + i] = uint(_owners[i]);
114       m_ownerIndex[uint(_owners[i])] = 2 + i;
115     }
116     m_required = _required;
117   }
118 
119   // Revokes a prior confirmation of the given operation
120   function revoke(bytes32 _operation) external {
121     uint ownerIndex = m_ownerIndex[uint(msg.sender)];
122     // make sure they're an owner
123     if (ownerIndex == 0) return;
124     uint ownerIndexBit = 2**ownerIndex;
125     var pending = m_pending[_operation];
126     if (pending.ownersDone & ownerIndexBit > 0) {
127       pending.yetNeeded++;
128       pending.ownersDone -= ownerIndexBit;
129       Revoke(msg.sender, _operation);
130     }
131   }
132 
133   // Replaces an owner `_from` with another `_to`.
134   function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
135     if (isOwner(_to)) return;
136     uint ownerIndex = m_ownerIndex[uint(_from)];
137     if (ownerIndex == 0) return;
138 
139     clearPending();
140     m_owners[ownerIndex] = uint(_to);
141     m_ownerIndex[uint(_from)] = 0;
142     m_ownerIndex[uint(_to)] = ownerIndex;
143     OwnerChanged(_from, _to);
144   }
145 
146   function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
147     if (isOwner(_owner)) return;
148 
149     clearPending();
150     if (m_numOwners >= c_maxOwners)
151       reorganizeOwners();
152     if (m_numOwners >= c_maxOwners)
153       return;
154     m_numOwners++;
155     m_owners[m_numOwners] = uint(_owner);
156     m_ownerIndex[uint(_owner)] = m_numOwners;
157     OwnerAdded(_owner);
158   }
159 
160   function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
161     uint ownerIndex = m_ownerIndex[uint(_owner)];
162     if (ownerIndex == 0) return;
163     if (m_required > m_numOwners - 1) return;
164 
165     m_owners[ownerIndex] = 0;
166     m_ownerIndex[uint(_owner)] = 0;
167     clearPending();
168     reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
169     OwnerRemoved(_owner);
170   }
171 
172   function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
173     if (_newRequired > m_numOwners) return;
174     m_required = _newRequired;
175     clearPending();
176     RequirementChanged(_newRequired);
177   }
178 
179   // Gets an owner by 0-indexed position (using numOwners as the count)
180   function getOwner(uint ownerIndex) external constant returns (address) {
181     return address(m_owners[ownerIndex + 1]);
182   }
183 
184   function isOwner(address _addr) constant returns (bool) {
185     return m_ownerIndex[uint(_addr)] > 0;
186   }
187 
188   function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool) {
189     var pending = m_pending[_operation];
190     uint ownerIndex = m_ownerIndex[uint(_owner)];
191 
192     // make sure they're an owner
193     if (ownerIndex == 0) return false;
194 
195     // determine the bit to set for this owner.
196     uint ownerIndexBit = 2**ownerIndex;
197     return !(pending.ownersDone & ownerIndexBit == 0);
198   }
199 
200   // constructor - stores initial daily limit and records the present day's index.
201   function initDaylimit(uint _limit) only_uninitialized {
202     m_dailyLimit = _limit;
203     m_lastDay = today();
204   }
205   // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
206   function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
207     m_dailyLimit = _newLimit;
208   }
209   // resets the amount already spent today. needs many of the owners to confirm.
210   function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
211     m_spentToday = 0;
212   }
213 
214   // throw unless the contract is not yet initialized.
215   modifier only_uninitialized { if (m_numOwners > 0) throw; _; }
216 
217   // constructor - just pass on the owner array to the multiowned and
218   // the limit to daylimit
219   function initWallet(address[] _owners, uint _required, uint _daylimit) only_uninitialized {
220     initDaylimit(_daylimit);
221     initMultiowned(_owners, _required);
222   }
223 
224   // kills the contract sending everything to `_to`.
225   function kill(address _to) onlymanyowners(sha3(msg.data)) external {
226     suicide(_to);
227   }
228 
229   // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
230   // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
231   // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
232   // and _data arguments). They still get the option of using them if they want, anyways.
233   function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 o_hash) {
234     // first, take the opportunity to check that we're under the daily limit.
235     if ((_data.length == 0 && underLimit(_value)) || m_required == 1) {
236       // yes - just execute the call.
237       address created;
238       if (_to == 0) {
239         created = create(_value, _data);
240       } else {
241         if (!_to.call.value(_value)(_data))
242           throw;
243       }
244       SingleTransact(msg.sender, _value, _to, _data, created);
245     } else {
246       // determine our operation hash.
247       o_hash = sha3(msg.data, block.number);
248       // store if it's new
249       if (m_txs[o_hash].to == 0 && m_txs[o_hash].value == 0 && m_txs[o_hash].data.length == 0) {
250         m_txs[o_hash].to = _to;
251         m_txs[o_hash].value = _value;
252         m_txs[o_hash].data = _data;
253       }
254       if (!confirm(o_hash)) {
255         ConfirmationNeeded(o_hash, msg.sender, _value, _to, _data);
256       }
257     }
258   }
259 
260   function create(uint _value, bytes _code) internal returns (address o_addr) {
261     assembly {
262       o_addr := create(_value, add(_code, 0x20), mload(_code))
263       jumpi(invalidJumpLabel, iszero(extcodesize(o_addr)))
264     }
265   }
266 
267   // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
268   // to determine the body of the transaction from the hash provided.
269   function confirm(bytes32 _h) onlymanyowners(_h) returns (bool o_success) {
270     if (m_txs[_h].to != 0 || m_txs[_h].value != 0 || m_txs[_h].data.length != 0) {
271       address created;
272       if (m_txs[_h].to == 0) {
273         created = create(m_txs[_h].value, m_txs[_h].data);
274       } else {
275         if (!m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data))
276           throw;
277       }
278 
279       MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data, created);
280       delete m_txs[_h];
281       return true;
282     }
283   }
284 
285   // INTERNAL METHODS
286 
287   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
288     // determine what index the present sender is:
289     uint ownerIndex = m_ownerIndex[uint(msg.sender)];
290     // make sure they're an owner
291     if (ownerIndex == 0) return;
292 
293     var pending = m_pending[_operation];
294     // if we're not yet working on this operation, switch over and reset the confirmation status.
295     if (pending.yetNeeded == 0) {
296       // reset count of confirmations needed.
297       pending.yetNeeded = m_required;
298       // reset which owners have confirmed (none) - set our bitmap to 0.
299       pending.ownersDone = 0;
300       pending.index = m_pendingIndex.length++;
301       m_pendingIndex[pending.index] = _operation;
302     }
303     // determine the bit to set for this owner.
304     uint ownerIndexBit = 2**ownerIndex;
305     // make sure we (the message sender) haven't confirmed this operation previously.
306     if (pending.ownersDone & ownerIndexBit == 0) {
307       Confirmation(msg.sender, _operation);
308       // ok - check if count is enough to go ahead.
309       if (pending.yetNeeded <= 1) {
310         // enough confirmations: reset and run interior.
311         delete m_pendingIndex[m_pending[_operation].index];
312         delete m_pending[_operation];
313         return true;
314       }
315       else
316       {
317         // not enough: record that this owner in particular confirmed.
318         pending.yetNeeded--;
319         pending.ownersDone |= ownerIndexBit;
320       }
321     }
322   }
323 
324   function reorganizeOwners() private {
325     uint free = 1;
326     while (free < m_numOwners)
327     {
328       while (free < m_numOwners && m_owners[free] != 0) free++;
329       while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
330       if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
331       {
332         m_owners[free] = m_owners[m_numOwners];
333         m_ownerIndex[m_owners[free]] = free;
334         m_owners[m_numOwners] = 0;
335       }
336     }
337   }
338 
339   // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
340   // returns true. otherwise just returns false.
341   function underLimit(uint _value) internal onlyowner returns (bool) {
342     // reset the spend limit if we're on a different day to last time.
343     if (today() > m_lastDay) {
344       m_spentToday = 0;
345       m_lastDay = today();
346     }
347     // check to see if there's enough left - if so, subtract and return true.
348     // overflow protection                    // dailyLimit check
349     if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
350       m_spentToday += _value;
351       return true;
352     }
353     return false;
354   }
355 
356   // determines today's index.
357   function today() private constant returns (uint) { return now / 1 days; }
358 
359   function clearPending() internal {
360     uint length = m_pendingIndex.length;
361 
362     for (uint i = 0; i < length; ++i) {
363       delete m_txs[m_pendingIndex[i]];
364 
365       if (m_pendingIndex[i] != 0)
366         delete m_pending[m_pendingIndex[i]];
367     }
368 
369     delete m_pendingIndex;
370   }
371 
372   // FIELDS
373   address constant _walletLibrary = 0xcafecafecafecafecafecafecafecafecafecafe;
374 
375   // the number of owners that must confirm the same operation before it is run.
376   uint public m_required;
377   // pointer used to find a free slot in m_owners
378   uint public m_numOwners;
379 
380   uint public m_dailyLimit;
381   uint public m_spentToday;
382   uint public m_lastDay;
383 
384   // list of owners
385   uint[256] m_owners;
386 
387   uint constant c_maxOwners = 250;
388   // index on the list of owners to allow reverse lookup
389   mapping(uint => uint) m_ownerIndex;
390   // the ongoing operations.
391   mapping(bytes32 => PendingState) m_pending;
392   bytes32[] m_pendingIndex;
393 
394   // pending transactions we have at present.
395   mapping (bytes32 => Transaction) m_txs;
396 }
397 
398 contract Wallet is WalletEvents {
399 
400   // WALLET CONSTRUCTOR
401   //   calls the `initWallet` method of the Library in this context
402   function Wallet(address[] _owners, uint _required, uint _daylimit) {
403     // Signature of the Wallet Library's init function
404     bytes4 sig = bytes4(sha3("initWallet(address[],uint256,uint256)"));
405     address target = _walletLibrary;
406 
407     // Compute the size of the call data : arrays has 2
408     // 32bytes for offset and length, plus 32bytes per element ;
409     // plus 2 32bytes for each uint
410     uint argarraysize = (2 + _owners.length);
411     uint argsize = (2 + argarraysize) * 32;
412 
413     assembly {
414       // Add the signature first to memory
415       mstore(0x0, sig)
416       // Add the call data, which is at the end of the
417       // code
418       codecopy(0x4,  sub(codesize, argsize), argsize)
419       // Delegate call to the library
420       delegatecall(sub(gas, 10000), target, 0x0, add(argsize, 0x4), 0x0, 0x0)
421     }
422   }
423 
424   // METHODS
425 
426   // gets called when no other function matches
427   function() payable {
428     // just being sent some cash?
429     if (msg.value > 0)
430       Deposit(msg.sender, msg.value);
431     else if (msg.data.length > 0)
432       _walletLibrary.delegatecall(msg.data);
433   }
434 
435   // Gets an owner by 0-indexed position (using numOwners as the count)
436   function getOwner(uint ownerIndex) constant returns (address) {
437     return address(m_owners[ownerIndex + 1]);
438   }
439 
440   // As return statement unavailable in fallback, explicit the method here
441 
442   function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool) {
443     return _walletLibrary.delegatecall(msg.data);
444   }
445 
446   function isOwner(address _addr) constant returns (bool) {
447     return _walletLibrary.delegatecall(msg.data);
448   }
449 
450   // FIELDS
451   address constant _walletLibrary = 0x863df6bfa4469f3ead0be8f9f2aae51c91a907b4;
452 
453   // the number of owners that must confirm the same operation before it is run.
454   uint public m_required;
455   // pointer used to find a free slot in m_owners
456   uint public m_numOwners;
457 
458   uint public m_dailyLimit;
459   uint public m_spentToday;
460   uint public m_lastDay;
461 
462   // list of owners
463   uint[256] m_owners;
464 }