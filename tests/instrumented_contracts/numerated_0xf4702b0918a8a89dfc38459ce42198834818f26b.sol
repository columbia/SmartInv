1 pragma solidity ^0.4.11;
2 //sol Wallet
3 // Multi-sig, daily-limited account proxy/wallet.
4 // @authors:
5 // Gav Wood <g@ethdev.com>
6 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
7 // single, or, crucially, each of a number of, designated owners.
8 // usage:
9 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
10 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
11 // interior is executed.
12 contract multiowned {
13 
14 	// TYPES
15 
16     // struct for the status of a pending operation.
17     struct PendingState {
18         uint yetNeeded;
19         uint ownersDone;
20         uint index;
21     }
22 
23 	// EVENTS
24 
25     // this contract only has six types of events: it can accept a confirmation, in which case
26     // we record owner and operation (hash) alongside it.
27     event Confirmation(address owner, bytes32 operation);
28     event Revoke(address owner, bytes32 operation);
29     // some others are in the case of an owner changing.
30     event OwnerChanged(address oldOwner, address newOwner);
31     event OwnerAdded(address newOwner);
32     event OwnerRemoved(address oldOwner);
33     // the last one is emitted if the required signatures change
34     event RequirementChanged(uint newRequirement);
35 
36 	// MODIFIERS
37 
38     // simple single-sig function modifier.
39     modifier onlyowner {
40         if (isOwner(msg.sender))
41             _;
42     }
43     // multi-sig function modifier: the operation must have an intrinsic hash in order
44     // that later attempts can be realised as the same underlying operation and
45     // thus count as confirmations.
46     modifier onlymanyowners(bytes32 _operation) {
47         if (confirmAndCheck(_operation))
48             _;
49     }
50 
51 	// METHODS
52 
53     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
54     // as well as the selection of addresses capable of confirming them.
55     function multiowned(address[] _owners, uint _required) {
56         m_numOwners = _owners.length + 1;
57         m_owners[1] = uint(msg.sender);
58         m_ownerIndex[uint(msg.sender)] = 1;
59         for (uint i = 0; i < _owners.length; ++i)
60         {
61             m_owners[2 + i] = uint(_owners[i]);
62             m_ownerIndex[uint(_owners[i])] = 2 + i;
63         }
64         m_required = _required;
65     }
66 
67     // Revokes a prior confirmation of the given operation
68     function revoke(bytes32 _operation) external {
69         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
70         // make sure they're an owner
71         if (ownerIndex == 0) return;
72         uint ownerIndexBit = 2**ownerIndex;
73         var pending = m_pending[_operation];
74         if (pending.ownersDone & ownerIndexBit > 0) {
75             pending.yetNeeded++;
76             pending.ownersDone -= ownerIndexBit;
77             Revoke(msg.sender, _operation);
78         }
79     }
80 
81     // Replaces an owner `_from` with another `_to`.
82     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
83         if (isOwner(_to)) return;
84         uint ownerIndex = m_ownerIndex[uint(_from)];
85         if (ownerIndex == 0) return;
86 
87         clearPending();
88         m_owners[ownerIndex] = uint(_to);
89         m_ownerIndex[uint(_from)] = 0;
90         m_ownerIndex[uint(_to)] = ownerIndex;
91         OwnerChanged(_from, _to);
92     }
93 
94     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
95         if (isOwner(_owner)) return;
96 
97         clearPending();
98         if (m_numOwners >= c_maxOwners)
99             reorganizeOwners();
100         if (m_numOwners >= c_maxOwners)
101             return;
102         m_numOwners++;
103         m_owners[m_numOwners] = uint(_owner);
104         m_ownerIndex[uint(_owner)] = m_numOwners;
105         OwnerAdded(_owner);
106     }
107 
108     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
109         uint ownerIndex = m_ownerIndex[uint(_owner)];
110         if (ownerIndex == 0) return;
111         if (m_required > m_numOwners - 1) return;
112 
113         m_owners[ownerIndex] = 0;
114         m_ownerIndex[uint(_owner)] = 0;
115         clearPending();
116         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
117         OwnerRemoved(_owner);
118     }
119 
120     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
121         if (_newRequired > m_numOwners) return;
122         m_required = _newRequired;
123         clearPending();
124         RequirementChanged(_newRequired);
125     }
126 
127     // Gets an owner by 0-indexed position (using numOwners as the count)
128     function getOwner(uint ownerIndex) external constant returns (address) {
129         return address(m_owners[ownerIndex + 1]);
130     }
131 
132     function isOwner(address _addr) returns (bool) {
133         return m_ownerIndex[uint(_addr)] > 0;
134     }
135 
136     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
137         var pending = m_pending[_operation];
138         uint ownerIndex = m_ownerIndex[uint(_owner)];
139 
140         // make sure they're an owner
141         if (ownerIndex == 0) return false;
142 
143         // determine the bit to set for this owner.
144         uint ownerIndexBit = 2**ownerIndex;
145         return !(pending.ownersDone & ownerIndexBit == 0);
146     }
147 
148     // INTERNAL METHODS
149 
150     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
151         // determine what index the present sender is:
152         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
153         // make sure they're an owner
154         if (ownerIndex == 0) return;
155 
156         var pending = m_pending[_operation];
157         // if we're not yet working on this operation, switch over and reset the confirmation status.
158         if (pending.yetNeeded == 0) {
159             // reset count of confirmations needed.
160             pending.yetNeeded = m_required;
161             // reset which owners have confirmed (none) - set our bitmap to 0.
162             pending.ownersDone = 0;
163             pending.index = m_pendingIndex.length++;
164             m_pendingIndex[pending.index] = _operation;
165         }
166         // determine the bit to set for this owner.
167         uint ownerIndexBit = 2**ownerIndex;
168         // make sure we (the message sender) haven't confirmed this operation previously.
169         if (pending.ownersDone & ownerIndexBit == 0) {
170             Confirmation(msg.sender, _operation);
171             // ok - check if count is enough to go ahead.
172             if (pending.yetNeeded <= 1) {
173                 // enough confirmations: reset and run interior.
174                 delete m_pendingIndex[m_pending[_operation].index];
175                 delete m_pending[_operation];
176                 return true;
177             }
178             else
179             {
180                 // not enough: record that this owner in particular confirmed.
181                 pending.yetNeeded--;
182                 pending.ownersDone |= ownerIndexBit;
183             }
184         }
185     }
186 
187     function reorganizeOwners() private {
188         uint free = 1;
189         while (free < m_numOwners)
190         {
191             while (free < m_numOwners && m_owners[free] != 0) free++;
192             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
193             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
194             {
195                 m_owners[free] = m_owners[m_numOwners];
196                 m_ownerIndex[m_owners[free]] = free;
197                 m_owners[m_numOwners] = 0;
198             }
199         }
200     }
201 
202     function clearPending() internal {
203         uint length = m_pendingIndex.length;
204         for (uint i = 0; i < length; ++i)
205             if (m_pendingIndex[i] != 0)
206                 delete m_pending[m_pendingIndex[i]];
207         delete m_pendingIndex;
208     }
209 
210    	// FIELDS
211 
212     // the number of owners that must confirm the same operation before it is run.
213     uint public m_required;
214     // pointer used to find a free slot in m_owners
215     uint public m_numOwners;
216 
217     // list of owners
218     uint[256] m_owners;
219     uint constant c_maxOwners = 250;
220     // index on the list of owners to allow reverse lookup
221     mapping(uint => uint) m_ownerIndex;
222     // the ongoing operations.
223     mapping(bytes32 => PendingState) m_pending;
224     bytes32[] m_pendingIndex;
225 }
226 
227 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
228 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
229 // uses is specified in the modifier.
230 contract daylimit is multiowned {
231 
232 	// MODIFIERS
233 
234     // simple modifier for daily limit.
235     modifier limitedDaily(uint _value) {
236         if (underLimit(_value))
237             _;
238     }
239 
240 	// METHODS
241 
242     // constructor - stores initial daily limit and records the present day's index.
243     function daylimit(uint _limit) {
244         m_dailyLimit = _limit;
245         m_lastDay = today();
246     }
247     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
248     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
249         m_dailyLimit = _newLimit;
250     }
251     // resets the amount already spent today. needs many of the owners to confirm.
252     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
253         m_spentToday = 0;
254     }
255 
256     // INTERNAL METHODS
257 
258     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
259     // returns true. otherwise just returns false.
260     function underLimit(uint _value) internal onlyowner returns (bool) {
261         // reset the spend limit if we're on a different day to last time.
262         if (today() > m_lastDay) {
263             m_spentToday = 0;
264             m_lastDay = today();
265         }
266         // check to see if there's enough left - if so, subtract and return true.
267         // overflow protection                    // dailyLimit check
268         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
269             m_spentToday += _value;
270             return true;
271         }
272         return false;
273     }
274     // determines today's index.
275     function today() private constant returns (uint) { return now / 1 days; }
276 
277 	// FIELDS
278 
279     uint public m_dailyLimit;
280     uint public m_spentToday;
281     uint public m_lastDay;
282 }
283 
284 // interface contract for multisig proxy contracts; see below for docs.
285 contract multisig {
286 
287 	// EVENTS
288 
289     // logged events:
290     // Funds has arrived into the wallet (record how much).
291     event Deposit(address _from, uint value);
292     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
293     event SingleTransact(address owner, uint value, address to, bytes data);
294     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
295     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
296     // Confirmation still needed for a transaction.
297     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
298 
299     // FUNCTIONS
300 
301     function changeOwner(address _from, address _to) external;
302     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
303     function confirm(bytes32 _h) returns (bool);
304 }
305 
306 // usage:
307 // bytes32 h = Wallet(w).from(oneOwner).execute(to, value, data);
308 // Wallet(w).from(anotherOwner).confirm(h);
309 contract Wallet is multisig, multiowned, daylimit {
310 
311 	// TYPES
312 
313     // Transaction structure to remember details of transaction lest it need be saved for a later call.
314     struct Transaction {
315         address to;
316         uint value;
317         bytes data;
318     }
319 
320     // METHODS
321 
322     // constructor - just pass on the owner array to the multiowned and
323     // the limit to daylimit
324     function Wallet(address[] _owners, uint _required, uint _daylimit)
325             multiowned(_owners, _required) daylimit(_daylimit) {
326     }
327 
328     // kills the contract sending everything to `_to`.
329     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
330         suicide(_to);
331     }
332 
333     // gets called when no other function matches
334     function() payable {
335         // just being sent some cash?
336         if (msg.value > 0)
337             Deposit(msg.sender, msg.value);
338     }
339 
340     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
341     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
342     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
343     // and _data arguments). They still get the option of using them if they want, anyways.
344     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
345         // first, take the opportunity to check that we're under the daily limit.
346         if (underLimit(_value)) {
347             SingleTransact(msg.sender, _value, _to, _data);
348             // yes - just execute the call.
349             _to.call.value(_value)(_data);
350             return 0;
351         }
352         // determine our operation hash.
353         _r = sha3(msg.data, block.number);
354         if (!confirm(_r) && m_txs[_r].to == 0) {
355             m_txs[_r].to = _to;
356             m_txs[_r].value = _value;
357             m_txs[_r].data = _data;
358             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
359         }
360     }
361 
362     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
363     // to determine the body of the transaction from the hash provided.
364     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
365         if (m_txs[_h].to != 0) {
366             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
367             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
368             delete m_txs[_h];
369             return true;
370         }
371     }
372 
373     // INTERNAL METHODS
374 
375     function clearPending() internal {
376         uint length = m_pendingIndex.length;
377         for (uint i = 0; i < length; ++i)
378             delete m_txs[m_pendingIndex[i]];
379         super.clearPending();
380     }
381 
382 	// FIELDS
383 
384     // pending transactions we have at present.
385     mapping (bytes32 => Transaction) m_txs;
386 }