1 pragma solidity ^0.4.8;
2 
3 /**
4  * This is a multisig wallet based on Gav's original implementation, daily withdraw limits removed.
5  *
6  *
7  * For other multisig wallet implementations, see https://blog.gnosis.pm/release-of-new-multisig-wallet-59b6811f7edc
8  */
9 
10 // Multi-sig, daily-limited account proxy/wallet.
11 // @authors:
12 // Gav Wood <g@ethdev.com>
13 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
14 // single, or, crucially, each of a number of, designated owners.
15 // usage:
16 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
17 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
18 // interior is executed.
19 contract multiowned {
20 
21 	// TYPES
22 
23     // struct for the status of a pending operation.
24     struct PendingState {
25         uint yetNeeded;
26         uint ownersDone;
27         uint index;
28     }
29 
30 	// EVENTS
31 
32     // this contract only has six types of events: it can accept a confirmation, in which case
33     // we record owner and operation (hash) alongside it.
34     event Confirmation(address owner, bytes32 operation);
35     event Revoke(address owner, bytes32 operation);
36     // some others are in the case of an owner changing.
37     event OwnerChanged(address oldOwner, address newOwner);
38     event OwnerAdded(address newOwner);
39     event OwnerRemoved(address oldOwner);
40     // the last one is emitted if the required signatures change
41     event RequirementChanged(uint newRequirement);
42 
43 	// MODIFIERS
44 
45     // simple single-sig function modifier.
46     modifier onlyowner {
47         if (isOwner(msg.sender))
48             _;
49     }
50     // multi-sig function modifier: the operation must have an intrinsic hash in order
51     // that later attempts can be realised as the same underlying operation and
52     // thus count as confirmations.
53     modifier onlymanyowners(bytes32 _operation) {
54         if (confirmAndCheck(_operation))
55             _;
56     }
57 
58 	// METHODS
59 
60     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
61     // as well as the selection of addresses capable of confirming them.
62     function multiowned(address[] _owners, uint _required) {
63         m_numOwners = _owners.length + 1;
64         m_owners[1] = uint(msg.sender);
65         m_ownerIndex[uint(msg.sender)] = 1;
66         for (uint i = 0; i < _owners.length; ++i)
67         {
68             m_owners[2 + i] = uint(_owners[i]);
69             m_ownerIndex[uint(_owners[i])] = 2 + i;
70         }
71         m_required = _required;
72     }
73 
74     // Revokes a prior confirmation of the given operation
75     function revoke(bytes32 _operation) external {
76         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
77         // make sure they're an owner
78         if (ownerIndex == 0) return;
79         uint ownerIndexBit = 2**ownerIndex;
80         var pending = m_pending[_operation];
81         if (pending.ownersDone & ownerIndexBit > 0) {
82             pending.yetNeeded++;
83             pending.ownersDone -= ownerIndexBit;
84             Revoke(msg.sender, _operation);
85         }
86     }
87 
88     // Replaces an owner `_from` with another `_to`.
89     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
90         if (isOwner(_to)) return;
91         uint ownerIndex = m_ownerIndex[uint(_from)];
92         if (ownerIndex == 0) return;
93 
94         clearPending();
95         m_owners[ownerIndex] = uint(_to);
96         m_ownerIndex[uint(_from)] = 0;
97         m_ownerIndex[uint(_to)] = ownerIndex;
98         OwnerChanged(_from, _to);
99     }
100 
101     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
102         if (isOwner(_owner)) return;
103 
104         clearPending();
105         if (m_numOwners >= c_maxOwners)
106             reorganizeOwners();
107         if (m_numOwners >= c_maxOwners)
108             return;
109         m_numOwners++;
110         m_owners[m_numOwners] = uint(_owner);
111         m_ownerIndex[uint(_owner)] = m_numOwners;
112         OwnerAdded(_owner);
113     }
114 
115     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
116         uint ownerIndex = m_ownerIndex[uint(_owner)];
117         if (ownerIndex == 0) return;
118         if (m_required > m_numOwners - 1) return;
119 
120         m_owners[ownerIndex] = 0;
121         m_ownerIndex[uint(_owner)] = 0;
122         clearPending();
123         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
124         OwnerRemoved(_owner);
125     }
126 
127     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
128         if (_newRequired > m_numOwners) return;
129         m_required = _newRequired;
130         clearPending();
131         RequirementChanged(_newRequired);
132     }
133 
134     // Gets an owner by 0-indexed position (using numOwners as the count)
135     function getOwner(uint ownerIndex) external constant returns (address) {
136         return address(m_owners[ownerIndex + 1]);
137     }
138 
139     function isOwner(address _addr) returns (bool) {
140         return m_ownerIndex[uint(_addr)] > 0;
141     }
142 
143     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
144         var pending = m_pending[_operation];
145         uint ownerIndex = m_ownerIndex[uint(_owner)];
146 
147         // make sure they're an owner
148         if (ownerIndex == 0) return false;
149 
150         // determine the bit to set for this owner.
151         uint ownerIndexBit = 2**ownerIndex;
152         return !(pending.ownersDone & ownerIndexBit == 0);
153     }
154 
155     // INTERNAL METHODS
156 
157     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
158         // determine what index the present sender is:
159         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
160         // make sure they're an owner
161         if (ownerIndex == 0) return;
162 
163         var pending = m_pending[_operation];
164         // if we're not yet working on this operation, switch over and reset the confirmation status.
165         if (pending.yetNeeded == 0) {
166             // reset count of confirmations needed.
167             pending.yetNeeded = m_required;
168             // reset which owners have confirmed (none) - set our bitmap to 0.
169             pending.ownersDone = 0;
170             pending.index = m_pendingIndex.length++;
171             m_pendingIndex[pending.index] = _operation;
172         }
173         // determine the bit to set for this owner.
174         uint ownerIndexBit = 2**ownerIndex;
175         // make sure we (the message sender) haven't confirmed this operation previously.
176         if (pending.ownersDone & ownerIndexBit == 0) {
177             Confirmation(msg.sender, _operation);
178             // ok - check if count is enough to go ahead.
179             if (pending.yetNeeded <= 1) {
180                 // enough confirmations: reset and run interior.
181                 delete m_pendingIndex[m_pending[_operation].index];
182                 delete m_pending[_operation];
183                 return true;
184             }
185             else
186             {
187                 // not enough: record that this owner in particular confirmed.
188                 pending.yetNeeded--;
189                 pending.ownersDone |= ownerIndexBit;
190             }
191         }
192     }
193 
194     function reorganizeOwners() private {
195         uint free = 1;
196         while (free < m_numOwners)
197         {
198             while (free < m_numOwners && m_owners[free] != 0) free++;
199             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
200             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
201             {
202                 m_owners[free] = m_owners[m_numOwners];
203                 m_ownerIndex[m_owners[free]] = free;
204                 m_owners[m_numOwners] = 0;
205             }
206         }
207     }
208 
209     function clearPending() internal {
210         uint length = m_pendingIndex.length;
211         for (uint i = 0; i < length; ++i)
212             if (m_pendingIndex[i] != 0)
213                 delete m_pending[m_pendingIndex[i]];
214         delete m_pendingIndex;
215     }
216 
217    	// FIELDS
218 
219     // the number of owners that must confirm the same operation before it is run.
220     uint public m_required;
221     // pointer used to find a free slot in m_owners
222     uint public m_numOwners;
223 
224     // list of owners
225     uint[256] m_owners;
226     uint constant c_maxOwners = 250;
227     // index on the list of owners to allow reverse lookup
228     mapping(uint => uint) m_ownerIndex;
229     // the ongoing operations.
230     mapping(bytes32 => PendingState) m_pending;
231     bytes32[] m_pendingIndex;
232 }
233 
234 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
235 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
236 // uses is specified in the modifier.
237 contract daylimit is multiowned {
238 
239 	// MODIFIERS
240 
241     // simple modifier for daily limit.
242     modifier limitedDaily(uint _value) {
243         if (underLimit(_value))
244             _;
245     }
246 
247 	// METHODS
248 
249     // constructor - stores initial daily limit and records the present day's index.
250     function daylimit(uint _limit) {
251         m_dailyLimit = _limit;
252         m_lastDay = today();
253     }
254     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
255     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
256         m_dailyLimit = _newLimit;
257     }
258     // resets the amount already spent today. needs many of the owners to confirm.
259     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
260         m_spentToday = 0;
261     }
262 
263     // INTERNAL METHODS
264 
265     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
266     // returns true. otherwise just returns false.
267     function underLimit(uint _value) internal onlyowner returns (bool) {
268         // reset the spend limit if we're on a different day to last time.
269         /*if (today() > m_lastDay) {
270             m_spentToday = 0;
271             m_lastDay = today();
272         }
273         // check to see if there's enough left - if so, subtract and return true.
274         // overflow protection                    // dailyLimit check
275         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
276             m_spentToday += _value;
277             return true;
278         }
279         return false;*/
280         return false;
281     }
282     // determines today's index.
283     function today() private constant returns (uint) { return now / 1 days; }
284 
285 	// FIELDS
286 
287     uint public m_dailyLimit;
288     uint public m_spentToday;
289     uint public m_lastDay;
290 }
291 
292 // interface contract for multisig proxy contracts; see below for docs.
293 contract multisig {
294 
295 	// EVENTS
296 
297     // logged events:
298     // Funds has arrived into the wallet (record how much).
299     event Deposit(address _from, uint value);
300     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
301     event SingleTransact(address owner, uint value, address to, bytes data);
302     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
303     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
304     // Confirmation still needed for a transaction.
305     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
306 
307     // FUNCTIONS
308 
309     // TODO: document
310     function changeOwner(address _from, address _to) external;
311     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
312     function confirm(bytes32 _h) returns (bool);
313 }
314 
315 // usage:
316 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
317 // Wallet(w).from(anotherOwner).confirm(h);
318 contract Wallet is multisig, multiowned, daylimit {
319 
320 	// TYPES
321 
322     // Transaction structure to remember details of transaction lest it need be saved for a later call.
323     struct Transaction {
324         address to;
325         uint value;
326         bytes data;
327     }
328 
329     // METHODS
330 
331     // constructor - just pass on the owner array to the multiowned and
332     // the limit to daylimit
333     function Wallet(address[] _owners, uint _required, uint _daylimit)
334             multiowned(_owners, _required) daylimit(_daylimit) {
335     }
336 
337     // kills the contract sending everything to `_to`.
338     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
339         suicide(_to);
340     }
341 
342     // gets called when no other function matches
343     function() payable {
344         // just being sent some cash?
345         if (msg.value > 0)
346             Deposit(msg.sender, msg.value);
347     }
348 
349     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
350     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
351     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
352     // and _data arguments). They still get the option of using them if they want, anyways.
353     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
354         // first, take the opportunity to check that we're under the daily limit.
355         if (underLimit(_value)) {
356             SingleTransact(msg.sender, _value, _to, _data);
357             // yes - just execute the call.
358             _to.call.value(_value)(_data);
359             return 0;
360         }
361         // determine our operation hash.
362         _r = sha3(msg.data, block.number);
363         if (!confirm(_r) && m_txs[_r].to == 0) {
364             m_txs[_r].to = _to;
365             m_txs[_r].value = _value;
366             m_txs[_r].data = _data;
367             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
368         }
369     }
370 
371     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
372     // to determine the body of the transaction from the hash provided.
373     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
374         if (m_txs[_h].to != 0) {
375             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
376             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
377             delete m_txs[_h];
378             return true;
379         }
380     }
381 
382     // INTERNAL METHODS
383 
384     function clearPending() internal {
385         uint length = m_pendingIndex.length;
386         for (uint i = 0; i < length; ++i)
387             delete m_txs[m_pendingIndex[i]];
388         super.clearPending();
389     }
390 
391 	// FIELDS
392 
393     // pending transactions we have at present.
394     mapping (bytes32 => Transaction) m_txs;
395 }