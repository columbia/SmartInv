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
11 pragma solidity ^0.4.6;
12 
13 contract multiowned {
14 
15     // TYPES
16 
17     // struct for the status of a pending operation.
18     struct PendingState {
19         uint yetNeeded;
20         uint ownersDone;
21         uint index;
22     }
23 
24     // EVENTS
25 
26     // this contract only has six types of events: it can accept a confirmation, in which case
27     // we record owner and operation (hash) alongside it.
28     event Confirmation(address owner, bytes32 operation);
29     event Revoke(address owner, bytes32 operation);
30     // some others are in the case of an owner changing.
31     event OwnerChanged(address oldOwner, address newOwner);
32     event OwnerAdded(address newOwner);
33     event OwnerRemoved(address oldOwner);
34     // the last one is emitted if the required signatures change
35     event RequirementChanged(uint newRequirement);
36 
37     // MODIFIERS
38 
39     // simple single-sig function modifier.
40     modifier onlyowner {
41         if (isOwner(msg.sender))
42             _;
43     }
44     // multi-sig function modifier: the operation must have an intrinsic hash in order
45     // that later attempts can be realised as the same underlying operation and
46     // thus count as confirmations.
47     modifier onlymanyowners(bytes32 _operation) {
48         if (confirmAndCheck(_operation))
49             _;
50     }
51 
52     // METHODS
53 
54     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
55     // as well as the selection of addresses capable of confirming them.
56     function multiowned(address[] _owners, uint _required) {
57         m_numOwners = _owners.length + 1;
58         m_owners[1] = uint(msg.sender);
59         m_ownerIndex[uint(msg.sender)] = 1;
60         for (uint i = 0; i < _owners.length; ++i)
61         {
62             m_owners[2 + i] = uint(_owners[i]);
63             m_ownerIndex[uint(_owners[i])] = 2 + i;
64         }
65         m_required = _required;
66     }
67 
68     // Revokes a prior confirmation of the given operation
69     function revoke(bytes32 _operation) external {
70         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
71         // make sure they're an owner
72         if (ownerIndex == 0) return;
73         uint ownerIndexBit = 2**ownerIndex;
74         var pending = m_pending[_operation];
75         if (pending.ownersDone & ownerIndexBit > 0) {
76             pending.yetNeeded++;
77             pending.ownersDone -= ownerIndexBit;
78             Revoke(msg.sender, _operation);
79         }
80     }
81 
82     // Replaces an owner `_from` with another `_to`.
83     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
84         if (isOwner(_to)) return;
85         uint ownerIndex = m_ownerIndex[uint(_from)];
86         if (ownerIndex == 0) return;
87 
88         clearPending();
89         m_owners[ownerIndex] = uint(_to);
90         m_ownerIndex[uint(_from)] = 0;
91         m_ownerIndex[uint(_to)] = ownerIndex;
92         OwnerChanged(_from, _to);
93     }
94 
95     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
96         if (isOwner(_owner)) return;
97 
98         clearPending();
99         if (m_numOwners >= c_maxOwners)
100             reorganizeOwners();
101         if (m_numOwners >= c_maxOwners)
102             return;
103         m_numOwners++;
104         m_owners[m_numOwners] = uint(_owner);
105         m_ownerIndex[uint(_owner)] = m_numOwners;
106         OwnerAdded(_owner);
107     }
108 
109     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
110         uint ownerIndex = m_ownerIndex[uint(_owner)];
111         if (ownerIndex == 0) return;
112         if (m_required > m_numOwners - 1) return;
113 
114         m_owners[ownerIndex] = 0;
115         m_ownerIndex[uint(_owner)] = 0;
116         clearPending();
117         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
118         OwnerRemoved(_owner);
119     }
120 
121     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
122         if (_newRequired > m_numOwners) return;
123         m_required = _newRequired;
124         clearPending();
125         RequirementChanged(_newRequired);
126     }
127 
128     // Gets an owner by 0-indexed position (using numOwners as the count)
129     function getOwner(uint ownerIndex) external constant returns (address) {
130         return address(m_owners[ownerIndex + 1]);
131     }
132 
133     function isOwner(address _addr) returns (bool) {
134         return m_ownerIndex[uint(_addr)] > 0;
135     }
136 
137     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
138         var pending = m_pending[_operation];
139         uint ownerIndex = m_ownerIndex[uint(_owner)];
140 
141         // make sure they're an owner
142         if (ownerIndex == 0) return false;
143 
144         // determine the bit to set for this owner.
145         uint ownerIndexBit = 2**ownerIndex;
146         return !(pending.ownersDone & ownerIndexBit == 0);
147     }
148 
149     // INTERNAL METHODS
150 
151     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
152         // determine what index the present sender is:
153         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
154         // make sure they're an owner
155         if (ownerIndex == 0) return;
156 
157         var pending = m_pending[_operation];
158         // if we're not yet working on this operation, switch over and reset the confirmation status.
159         if (pending.yetNeeded == 0) {
160             // reset count of confirmations needed.
161             pending.yetNeeded = m_required;
162             // reset which owners have confirmed (none) - set our bitmap to 0.
163             pending.ownersDone = 0;
164             pending.index = m_pendingIndex.length++;
165             m_pendingIndex[pending.index] = _operation;
166         }
167         // determine the bit to set for this owner.
168         uint ownerIndexBit = 2**ownerIndex;
169         // make sure we (the message sender) haven't confirmed this operation previously.
170         if (pending.ownersDone & ownerIndexBit == 0) {
171             Confirmation(msg.sender, _operation);
172             // ok - check if count is enough to go ahead.
173             if (pending.yetNeeded <= 1) {
174                 // enough confirmations: reset and run interior.
175                 delete m_pendingIndex[m_pending[_operation].index];
176                 delete m_pending[_operation];
177                 return true;
178             }
179             else
180             {
181                 // not enough: record that this owner in particular confirmed.
182                 pending.yetNeeded--;
183                 pending.ownersDone |= ownerIndexBit;
184             }
185         }
186     }
187 
188     function reorganizeOwners() private {
189         uint free = 1;
190         while (free < m_numOwners)
191         {
192             while (free < m_numOwners && m_owners[free] != 0) free++;
193             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
194             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
195             {
196                 m_owners[free] = m_owners[m_numOwners];
197                 m_ownerIndex[m_owners[free]] = free;
198                 m_owners[m_numOwners] = 0;
199             }
200         }
201     }
202 
203     function clearPending() internal {
204         uint length = m_pendingIndex.length;
205         for (uint i = 0; i < length; ++i)
206             if (m_pendingIndex[i] != 0)
207                 delete m_pending[m_pendingIndex[i]];
208         delete m_pendingIndex;
209     }
210 
211     // FIELDS
212 
213     // the number of owners that must confirm the same operation before it is run.
214     uint public m_required;
215     // pointer used to find a free slot in m_owners
216     uint public m_numOwners;
217 
218     // list of owners
219     uint[256] m_owners;
220     uint constant c_maxOwners = 250;
221     // index on the list of owners to allow reverse lookup
222     mapping(uint => uint) m_ownerIndex;
223     // the ongoing operations.
224     mapping(bytes32 => PendingState) m_pending;
225     bytes32[] m_pendingIndex;
226 }
227 
228 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
229 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
230 // uses is specified in the modifier.
231 contract daylimit is multiowned {
232 
233     // MODIFIERS
234 
235     // simple modifier for daily limit.
236     modifier limitedDaily(uint _value) {
237         if (underLimit(_value))
238             _;
239     }
240 
241     // METHODS
242 
243     // constructor - stores initial daily limit and records the present day's index.
244     function daylimit(uint _limit) {
245         m_dailyLimit = _limit;
246         m_lastDay = today();
247     }
248     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
249     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
250         m_dailyLimit = _newLimit;
251     }
252     // resets the amount already spent today. needs many of the owners to confirm.
253     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
254         m_spentToday = 0;
255     }
256 
257     // INTERNAL METHODS
258 
259     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
260     // returns true. otherwise just returns false.
261     function underLimit(uint _value) internal onlyowner returns (bool) {
262         // reset the spend limit if we're on a different day to last time.
263         if (today() > m_lastDay) {
264             m_spentToday = 0;
265             m_lastDay = today();
266         }
267         // check to see if there's enough left - if so, subtract and return true.
268         // overflow protection                    // dailyLimit check
269         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
270             m_spentToday += _value;
271             return true;
272         }
273         return false;
274     }
275     // determines today's index.
276     function today() private constant returns (uint) { return now / 1 days; }
277 
278     // FIELDS
279 
280     uint public m_dailyLimit;
281     uint public m_spentToday;
282     uint public m_lastDay;
283 }
284 
285 // interface contract for multisig proxy contracts; see below for docs.
286 contract multisig {
287 
288     // EVENTS
289 
290     // logged events:
291     // Funds has arrived into the wallet (record how much).
292     event Deposit(address _from, uint value);
293     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
294     event SingleTransact(address owner, uint value, address to, bytes data);
295     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
296     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
297     // Confirmation still needed for a transaction.
298     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
299 
300     // FUNCTIONS
301 
302     // TODO: document
303     function changeOwner(address _from, address _to) external;
304     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
305     function confirm(bytes32 _h) returns (bool);
306 }
307 
308 // usage:
309 // bytes32 h = Wallet(w).from(oneOwner).execute(to, value, data);
310 // Wallet(w).from(anotherOwner).confirm(h);
311 contract Wallet is multisig, multiowned, daylimit {
312 
313     // TYPES
314 
315     // Transaction structure to remember details of transaction lest it need be saved for a later call.
316     struct Transaction {
317         address to;
318         uint value;
319         bytes data;
320     }
321 
322     // METHODS
323 
324     // constructor - just pass on the owner array to the multiowned and
325     // the limit to daylimit
326     function Wallet(address[] _owners, uint _required, uint _daylimit)
327             multiowned(_owners, _required) daylimit(_daylimit) {
328     }
329 
330     // kills the contract sending everything to `_to`.
331     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
332         suicide(_to);
333     }
334 
335     // gets called when no other function matches
336     function() payable {
337         // just being sent some cash?
338         if (msg.value > 0)
339             Deposit(msg.sender, msg.value);
340     }
341 
342     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
343     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
344     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
345     // and _data arguments). They still get the option of using them if they want, anyways.
346     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
347         // first, take the opportunity to check that we're under the daily limit.
348         if (underLimit(_value)) {
349             SingleTransact(msg.sender, _value, _to, _data);
350             // yes - just execute the call.
351             _to.call.value(_value)(_data);
352             return 0;
353         }
354         // determine our operation hash.
355         _r = sha3(msg.data, block.number);
356         if (!confirm(_r) && m_txs[_r].to == 0) {
357             m_txs[_r].to = _to;
358             m_txs[_r].value = _value;
359             m_txs[_r].data = _data;
360             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
361         }
362     }
363 
364     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
365     // to determine the body of the transaction from the hash provided.
366     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
367         if (m_txs[_h].to != 0) {
368             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
369             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
370             delete m_txs[_h];
371             return true;
372         }
373     }
374 
375     // INTERNAL METHODS
376 
377     function clearPending() internal {
378         uint length = m_pendingIndex.length;
379         for (uint i = 0; i < length; ++i)
380             delete m_txs[m_pendingIndex[i]];
381         super.clearPending();
382     }
383 
384     // FIELDS
385 
386     // pending transactions we have at present.
387     mapping (bytes32 => Transaction) m_txs;
388 }