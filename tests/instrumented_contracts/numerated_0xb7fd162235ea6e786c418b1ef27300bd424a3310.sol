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
107   function initMultiowned(address[] _owners, uint _required)  {
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
201   function initDaylimit(uint _limit)  {
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
215 
216   // constructor - just pass on the owner array to the multiowned and
217   // the limit to daylimit
218   function initWallet(address[] _owners, uint _required, uint _daylimit)  {
219     initDaylimit(_daylimit);
220     initMultiowned(_owners, _required);
221   }
222 
223   // kills the contract sending everything to `_to`.
224   function kill(address _to) onlymanyowners(sha3(msg.data)) external {
225     suicide(_to);
226   }
227 
228   // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
229   // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
230   // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
231   // and _data arguments). They still get the option of using them if they want, anyways.
232   function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 o_hash) {
233     // first, take the opportunity to check that we're under the daily limit.
234     if ((_data.length == 0 && underLimit(_value)) || m_required == 1) {
235       // yes - just execute the call.
236       address created;
237       if (_to == 0) {
238         created = create(_value, _data);
239       } else {
240         if (!_to.call.value(_value)(_data))
241           throw;
242       }
243       SingleTransact(msg.sender, _value, _to, _data, created);
244     } else {
245       // determine our operation hash.
246       o_hash = sha3(msg.data, block.number);
247       // store if it's new
248       if (m_txs[o_hash].to == 0 && m_txs[o_hash].value == 0 && m_txs[o_hash].data.length == 0) {
249         m_txs[o_hash].to = _to;
250         m_txs[o_hash].value = _value;
251         m_txs[o_hash].data = _data;
252       }
253       if (!confirm(o_hash)) {
254         ConfirmationNeeded(o_hash, msg.sender, _value, _to, _data);
255       }
256     }
257   }
258 
259   function create(uint _value, bytes _code) internal returns (address o_addr) {
260     assembly {
261       o_addr := create(_value, add(_code, 0x20), mload(_code))
262       jumpi(invalidJumpLabel, iszero(extcodesize(o_addr)))
263     }
264   }
265 
266   // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
267   // to determine the body of the transaction from the hash provided.
268   function confirm(bytes32 _h) onlymanyowners(_h) returns (bool o_success) {
269     if (m_txs[_h].to != 0 || m_txs[_h].value != 0 || m_txs[_h].data.length != 0) {
270       address created;
271       if (m_txs[_h].to == 0) {
272         created = create(m_txs[_h].value, m_txs[_h].data);
273       } else {
274         if (!m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data))
275           throw;
276       }
277 
278       MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data, created);
279       delete m_txs[_h];
280       return true;
281     }
282   }
283 
284   // INTERNAL METHODS
285 
286   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
287     // determine what index the present sender is:
288     uint ownerIndex = m_ownerIndex[uint(msg.sender)];
289     // make sure they're an owner
290     if (ownerIndex == 0) return;
291 
292     var pending = m_pending[_operation];
293     // if we're not yet working on this operation, switch over and reset the confirmation status.
294     if (pending.yetNeeded == 0) {
295       // reset count of confirmations needed.
296       pending.yetNeeded = m_required;
297       // reset which owners have confirmed (none) - set our bitmap to 0.
298       pending.ownersDone = 0;
299       pending.index = m_pendingIndex.length++;
300       m_pendingIndex[pending.index] = _operation;
301     }
302     // determine the bit to set for this owner.
303     uint ownerIndexBit = 2**ownerIndex;
304     // make sure we (the message sender) haven't confirmed this operation previously.
305     if (pending.ownersDone & ownerIndexBit == 0) {
306       Confirmation(msg.sender, _operation);
307       // ok - check if count is enough to go ahead.
308       if (pending.yetNeeded <= 1) {
309         // enough confirmations: reset and run interior.
310         delete m_pendingIndex[m_pending[_operation].index];
311         delete m_pending[_operation];
312         return true;
313       }
314       else
315       {
316         // not enough: record that this owner in particular confirmed.
317         pending.yetNeeded--;
318         pending.ownersDone |= ownerIndexBit;
319       }
320     }
321   }
322 
323   function reorganizeOwners() private {
324     uint free = 1;
325     while (free < m_numOwners)
326     {
327       while (free < m_numOwners && m_owners[free] != 0) free++;
328       while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
329       if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
330       {
331         m_owners[free] = m_owners[m_numOwners];
332         m_ownerIndex[m_owners[free]] = free;
333         m_owners[m_numOwners] = 0;
334       }
335     }
336   }
337 
338   // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
339   // returns true. otherwise just returns false.
340   function underLimit(uint _value) internal onlyowner returns (bool) {
341     // reset the spend limit if we're on a different day to last time.
342     if (today() > m_lastDay) {
343       m_spentToday = 0;
344       m_lastDay = today();
345     }
346     // check to see if there's enough left - if so, subtract and return true.
347     // overflow protection                    // dailyLimit check
348     if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
349       m_spentToday += _value;
350       return true;
351     }
352     return false;
353   }
354 
355   // determines today's index.
356   function today() private constant returns (uint) { return now / 1 days; }
357 
358   function clearPending() internal {
359     uint length = m_pendingIndex.length;
360 
361     for (uint i = 0; i < length; ++i) {
362       delete m_txs[m_pendingIndex[i]];
363 
364       if (m_pendingIndex[i] != 0)
365         delete m_pending[m_pendingIndex[i]];
366     }
367 
368     delete m_pendingIndex;
369   }
370 
371   // FIELDS
372 
373   // the number of owners that must confirm the same operation before it is run.
374   uint public m_required;
375   // pointer used to find a free slot in m_owners
376   uint public m_numOwners;
377 
378   uint public m_dailyLimit;
379   uint public m_spentToday;
380   uint public m_lastDay;
381 
382   // list of owners
383   uint[256] m_owners;
384 
385   uint constant c_maxOwners = 250;
386   // index on the list of owners to allow reverse lookup
387   mapping(uint => uint) m_ownerIndex;
388   // the ongoing operations.
389   mapping(bytes32 => PendingState) m_pending;
390   bytes32[] m_pendingIndex;
391 
392   // pending transactions we have at present.
393   mapping (bytes32 => Transaction) m_txs;
394 }
395 
396 contract Wallet is WalletEvents {
397 
398   // WALLET CONSTRUCTOR
399   //   calls the `initWallet` method of the Library in this context
400   function Wallet(address[] _owners, uint _required, uint _daylimit) {
401     // Signature of the Wallet Library's init function
402     bytes4 sig = bytes4(sha3("initWallet(address[],uint256,uint256)"));
403     address target = _walletLibrary;
404 
405     // Compute the size of the call data : arrays has 2
406     // 32bytes for offset and length, plus 32bytes per element ;
407     // plus 2 32bytes for each uint
408     uint argarraysize = (2 + _owners.length);
409     uint argsize = (2 + argarraysize) * 32;
410 
411     assembly {
412       // Add the signature first to memory
413       mstore(0x0, sig)
414       // Add the call data, which is at the end of the
415       // code
416       codecopy(0x4,  sub(codesize, argsize), argsize)
417       // Delegate call to the library
418       delegatecall(sub(gas, 10000), target, 0x0, add(argsize, 0x4), 0x0, 0x0)
419     }
420   }
421 
422   // METHODS
423 
424   // gets called when no other function matches
425   function() payable {
426     // just being sent some cash?
427     if (msg.value > 0)
428       Deposit(msg.sender, msg.value);
429     else if (msg.data.length > 0)
430       _walletLibrary.delegatecall(msg.data);
431   }
432 
433   // Gets an owner by 0-indexed position (using numOwners as the count)
434   function getOwner(uint ownerIndex) constant returns (address) {
435     return address(m_owners[ownerIndex + 1]);
436   }
437 
438   // As return statement unavailable in fallback, explicit the method here
439 
440   function hasConfirmed(bytes32 _operation, address _owner) external constant returns (bool) {
441     return _walletLibrary.delegatecall(msg.data);
442   }
443 
444   function isOwner(address _addr) constant returns (bool) {
445     return _walletLibrary.delegatecall(msg.data);
446   }
447 
448   // FIELDS
449   address constant _walletLibrary = 0x863df6bfa4469f3ead0be8f9f2aae51c91a907b4;
450 
451   // the number of owners that must confirm the same operation before it is run.
452   uint public m_required;
453   // pointer used to find a free slot in m_owners
454   uint public m_numOwners;
455 
456   uint public m_dailyLimit;
457   uint public m_spentToday;
458   uint public m_lastDay;
459 
460   // list of owners
461   uint[256] m_owners;
462 }