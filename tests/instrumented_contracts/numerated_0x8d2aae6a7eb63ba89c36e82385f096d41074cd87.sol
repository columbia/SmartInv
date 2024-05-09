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
12 pragma solidity ^0.4.10;
13 
14 contract multiowned {
15 
16 	// TYPES
17 
18     // struct for the status of a pending operation.
19     struct PendingState {
20         uint yetNeeded;
21         uint ownersDone;
22         uint index;
23     }
24 
25 	// EVENTS
26 
27     // this contract only has six types of events: it can accept a confirmation, in which case
28     // we record owner and operation (hash) alongside it.
29     event Confirmation(address owner, bytes32 operation);
30     event Revoke(address owner, bytes32 operation);
31     // some others are in the case of an owner changing.
32     event OwnerChanged(address oldOwner, address newOwner);
33     event OwnerAdded(address newOwner);
34     event OwnerRemoved(address oldOwner);
35     // the last one is emitted if the required signatures change
36     event RequirementChanged(uint newRequirement);
37 
38 	// MODIFIERS
39 
40     // simple single-sig function modifier.
41     modifier onlyowner {
42         require(isOwner(msg.sender));
43         _;
44     }
45     // multi-sig function modifier: the operation must have an intrinsic hash in order
46     // that later attempts can be realised as the same underlying operation and
47     // thus count as confirmations.
48     modifier onlymanyowners(bytes32 _operation) {
49         require(confirmAndCheck(_operation));
50         _;
51     }
52 
53 	// METHODS
54 
55     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
56     // as well as the selection of addresses capable of confirming them.
57     function multiowned(address[] _owners, uint _required) {
58         m_numOwners = _owners.length + 1;
59         m_owners[1] = uint(msg.sender);
60         m_ownerIndex[uint(msg.sender)] = 1;
61         for (uint i = 0; i < _owners.length; ++i)
62         {
63             m_owners[2 + i] = uint(_owners[i]);
64             m_ownerIndex[uint(_owners[i])] = 2 + i;
65         }
66         m_required = _required;
67     }
68     
69     // Revokes a prior confirmation of the given operation
70     function revoke(bytes32 _operation) external {
71         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
72         // make sure they're an owner
73         if (ownerIndex == 0) return;
74         uint ownerIndexBit = 2**ownerIndex;
75         var pending = m_pending[_operation];
76         if (pending.ownersDone & ownerIndexBit > 0) {
77             pending.yetNeeded++;
78             pending.ownersDone -= ownerIndexBit;
79             Revoke(msg.sender, _operation);
80         }
81     }
82     
83     // Replaces an owner `_from` with another `_to`.
84     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
85         if (isOwner(_to)) return;
86         uint ownerIndex = m_ownerIndex[uint(_from)];
87         if (ownerIndex == 0) return;
88 
89         clearPending();
90         m_owners[ownerIndex] = uint(_to);
91         m_ownerIndex[uint(_from)] = 0;
92         m_ownerIndex[uint(_to)] = ownerIndex;
93         OwnerChanged(_from, _to);
94     }
95     
96     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
97         if (isOwner(_owner)) return;
98 
99         clearPending();
100         if (m_numOwners >= c_maxOwners)
101             reorganizeOwners();
102         if (m_numOwners >= c_maxOwners)
103             return;
104         m_numOwners++;
105         m_owners[m_numOwners] = uint(_owner);
106         m_ownerIndex[uint(_owner)] = m_numOwners;
107         OwnerAdded(_owner);
108     }
109     
110     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
111         uint ownerIndex = m_ownerIndex[uint(_owner)];
112         if (ownerIndex == 0) return;
113         if (m_required > m_numOwners - 1) return;
114 
115         m_owners[ownerIndex] = 0;
116         m_ownerIndex[uint(_owner)] = 0;
117         clearPending();
118         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
119         OwnerRemoved(_owner);
120     }
121     
122     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
123         if (_newRequired > m_numOwners) return;
124         m_required = _newRequired;
125         clearPending();
126         RequirementChanged(_newRequired);
127     }
128 
129     // Gets an owner by 0-indexed position (using numOwners as the count)
130     function getOwner(uint ownerIndex) external constant returns (address) {
131         return address(m_owners[ownerIndex + 1]);
132     }
133 
134     function isOwner(address _addr) returns (bool) {
135         return m_ownerIndex[uint(_addr)] > 0;
136     }
137     
138     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
139         var pending = m_pending[_operation];
140         uint ownerIndex = m_ownerIndex[uint(_owner)];
141 
142         // make sure they're an owner
143         if (ownerIndex == 0) return false;
144 
145         // determine the bit to set for this owner.
146         uint ownerIndexBit = 2**ownerIndex;
147         return !(pending.ownersDone & ownerIndexBit == 0);
148     }
149     
150     // INTERNAL METHODS
151 
152     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
153         // determine what index the present sender is:
154         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
155         // make sure they're an owner
156         if (ownerIndex == 0) return;
157 
158         var pending = m_pending[_operation];
159         // if we're not yet working on this operation, switch over and reset the confirmation status.
160         if (pending.yetNeeded == 0) {
161             // reset count of confirmations needed.
162             pending.yetNeeded = m_required;
163             // reset which owners have confirmed (none) - set our bitmap to 0.
164             pending.ownersDone = 0;
165             pending.index = m_pendingIndex.length++;
166             m_pendingIndex[pending.index] = _operation;
167         }
168         // determine the bit to set for this owner.
169         uint ownerIndexBit = 2**ownerIndex;
170         // make sure we (the message sender) haven't confirmed this operation previously.
171         if (pending.ownersDone & ownerIndexBit == 0) {
172             Confirmation(msg.sender, _operation);
173             // ok - check if count is enough to go ahead.
174             if (pending.yetNeeded <= 1) {
175                 // enough confirmations: reset and run interior.
176                 delete m_pendingIndex[m_pending[_operation].index];
177                 delete m_pending[_operation];
178                 return true;
179             }
180             else
181             {
182                 // not enough: record that this owner in particular confirmed.
183                 pending.yetNeeded--;
184                 pending.ownersDone |= ownerIndexBit;
185             }
186         }
187     }
188 
189     function reorganizeOwners() private {
190         uint free = 1;
191         while (free < m_numOwners)
192         {
193             while (free < m_numOwners && m_owners[free] != 0) free++;
194             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
195             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
196             {
197                 m_owners[free] = m_owners[m_numOwners];
198                 m_ownerIndex[m_owners[free]] = free;
199                 m_owners[m_numOwners] = 0;
200             }
201         }
202     }
203     
204     function clearPending() internal {
205         uint length = m_pendingIndex.length;
206         for (uint i = 0; i < length; ++i)
207             if (m_pendingIndex[i] != 0)
208                 delete m_pending[m_pendingIndex[i]];
209         delete m_pendingIndex;
210     }
211         
212    	// FIELDS
213 
214     // the number of owners that must confirm the same operation before it is run.
215     uint public m_required;
216     // pointer used to find a free slot in m_owners
217     uint public m_numOwners;
218     
219     // list of owners
220     uint[256] m_owners;
221     uint constant c_maxOwners = 250;
222     // index on the list of owners to allow reverse lookup
223     mapping(uint => uint) m_ownerIndex;
224     // the ongoing operations.
225     mapping(bytes32 => PendingState) m_pending;
226     bytes32[] m_pendingIndex;
227 }
228 
229 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
230 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
231 // uses is specified in the modifier.
232 contract daylimit is multiowned {
233 
234 	// MODIFIERS
235 
236     // simple modifier for daily limit.
237     modifier limitedDaily(uint _value) {
238         require(underLimit(_value));
239         _;
240     }
241 
242 	// METHODS
243 
244     // constructor - stores initial daily limit and records the present day's index.
245     function daylimit(uint _limit) {
246         m_dailyLimit = _limit;
247         m_lastDay = today();
248     }
249     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
250     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
251         m_dailyLimit = _newLimit;
252     }
253     // resets the amount already spent today. needs many of the owners to confirm. 
254     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
255         m_spentToday = 0;
256     }
257     
258     // INTERNAL METHODS
259     
260     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
261     // returns true. otherwise just returns false.
262     function underLimit(uint _value) internal onlyowner returns (bool) {
263         // reset the spend limit if we're on a different day to last time.
264         if (today() > m_lastDay) {
265             m_spentToday = 0;
266             m_lastDay = today();
267         }
268         // check to see if there's enough left - if so, subtract and return true.
269         // overflow protection                    // dailyLimit check  
270         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
271             m_spentToday += _value;
272             return true;
273         }
274         return false;
275     }
276     // determines today's index.
277     function today() private constant returns (uint) { return now / 1 days; }
278 
279 	// FIELDS
280 
281     uint public m_dailyLimit;
282     uint public m_spentToday;
283     uint public m_lastDay;
284 }
285 
286 // interface contract for multisig proxy contracts; see below for docs.
287 contract multisig {
288 
289 	// EVENTS
290 
291     // logged events:
292     // Funds has arrived into the wallet (record how much).
293     event Deposit(address _from, uint value);
294     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
295     event SingleTransact(address owner, uint value, address to, bytes data);
296     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
297     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
298     // Confirmation still needed for a transaction.
299     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
300     
301     // FUNCTIONS
302     
303     // TODO: document
304     function changeOwner(address _from, address _to) external;
305     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
306     function confirm(bytes32 _h) returns (bool);
307 }
308 
309 // usage:
310 // bytes32 h = Wallet(w).from(oneOwner).execute(to, value, data);
311 // Wallet(w).from(anotherOwner).confirm(h);
312 contract Wallet is multisig, multiowned, daylimit {
313 
314 	// TYPES
315 
316     // Transaction structure to remember details of transaction lest it need be saved for a later call.
317     struct Transaction {
318         address to;
319         uint value;
320         bytes data;
321     }
322 
323     // METHODS
324 
325     // constructor - just pass on the owner array to the multiowned and
326     // the limit to daylimit
327     function Wallet(address[] _owners, uint _required, uint _daylimit)
328             multiowned(_owners, _required) daylimit(_daylimit) {
329     }
330     
331     // kills the contract sending everything to `_to`.
332     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
333         selfdestruct(_to);
334     }
335     
336     // gets called when no other function matches
337     function() payable {
338         // just being sent some cash?
339         if (msg.value > 0)
340             Deposit(msg.sender, msg.value);
341     }
342     
343     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
344     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
345     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
346     // and _data arguments). They still get the option of using them if they want, anyways.
347     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
348         // first, take the opportunity to check that we're under the daily limit.
349         if (underLimit(_value)) {
350             SingleTransact(msg.sender, _value, _to, _data);
351             // yes - just execute the call.
352             require(_to.call.value(_value)(_data));
353             return 0;
354         }
355         // determine our operation hash.
356         _r = sha3(msg.data, block.number);
357         if (!confirm(_r) && m_txs[_r].to == 0) {
358             m_txs[_r].to = _to;
359             m_txs[_r].value = _value;
360             m_txs[_r].data = _data;
361             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
362         }
363     }
364     
365     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
366     // to determine the body of the transaction from the hash provided.
367     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
368         if (m_txs[_h].to != 0) {
369             require(m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data));
370             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
371             delete m_txs[_h];
372             return true;
373         }
374     }
375     
376     // INTERNAL METHODS
377     
378     function clearPending() internal {
379         uint length = m_pendingIndex.length;
380         for (uint i = 0; i < length; ++i)
381             delete m_txs[m_pendingIndex[i]];
382         super.clearPending();
383     }
384 
385 	// FIELDS
386 
387     // pending transactions we have at present.
388     mapping (bytes32 => Transaction) m_txs;
389 }