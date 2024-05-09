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
11 contract multiowned {
12 
13 	// TYPES
14 
15     // struct for the status of a pending operation.
16     struct PendingState {
17         uint yetNeeded;
18         uint ownersDone;
19         uint index;
20     }
21 
22 	// EVENTS
23 
24     // this contract only has five types of events: it can accept a confirmation, in which case
25     // we record owner and operation (hash) alongside it.
26     event Confirmation(address owner, bytes32 operation);
27     event Revoke(address owner, bytes32 operation);
28     // some others are in the case of an owner changing.
29     event OwnerChanged(address oldOwner, address newOwner);
30     event OwnerAdded(address newOwner);
31     event OwnerRemoved(address oldOwner);
32     // the last one is emitted if the required signatures change
33     event RequirementChanged(uint newRequirement);
34 
35 	// MODIFIERS
36 
37     // simple single-sig function modifier.
38     modifier onlyowner {
39         if (isOwner(msg.sender))
40             _
41     }
42     // multi-sig function modifier: the operation must have an intrinsic hash in order
43     // that later attempts can be realised as the same underlying operation and
44     // thus count as confirmations.
45     modifier onlymanyowners(bytes32 _operation) {
46         if (confirmAndCheck(_operation))
47             _
48     }
49 
50 	// METHODS
51 
52     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
53     // as well as the selection of addresses capable of confirming them.
54     function multiowned(address[] _owners, uint _required) {
55         m_numOwners = _owners.length + 1;
56         m_owners[1] = uint(msg.sender);
57         m_ownerIndex[uint(msg.sender)] = 1;
58         for (uint i = 0; i < _owners.length; ++i)
59         {
60             m_owners[2 + i] = uint(_owners[i]);
61             m_ownerIndex[uint(_owners[i])] = 2 + i;
62         }
63         m_required = _required;
64     }
65     
66     // Revokes a prior confirmation of the given operation
67     function revoke(bytes32 _operation) external {
68         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
69         // make sure they're an owner
70         if (ownerIndex == 0) return;
71         uint ownerIndexBit = 2**ownerIndex;
72         var pending = m_pending[_operation];
73         if (pending.ownersDone & ownerIndexBit > 0) {
74             pending.yetNeeded++;
75             pending.ownersDone -= ownerIndexBit;
76             Revoke(msg.sender, _operation);
77         }
78     }
79     
80     // Replaces an owner `_from` with another `_to`.
81     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
82         if (isOwner(_to)) return;
83         uint ownerIndex = m_ownerIndex[uint(_from)];
84         if (ownerIndex == 0) return;
85 
86         clearPending();
87         m_owners[ownerIndex] = uint(_to);
88         m_ownerIndex[uint(_from)] = 0;
89         m_ownerIndex[uint(_to)] = ownerIndex;
90         OwnerChanged(_from, _to);
91     }
92     
93     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
94         if (isOwner(_owner)) return;
95 
96         clearPending();
97         if (m_numOwners >= c_maxOwners)
98             reorganizeOwners();
99         if (m_numOwners >= c_maxOwners)
100             return;
101         m_numOwners++;
102         m_owners[m_numOwners] = uint(_owner);
103         m_ownerIndex[uint(_owner)] = m_numOwners;
104         OwnerAdded(_owner);
105     }
106     
107     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
108         uint ownerIndex = m_ownerIndex[uint(_owner)];
109         if (ownerIndex == 0) return;
110         if (m_required > m_numOwners - 1) return;
111 
112         m_owners[ownerIndex] = 0;
113         m_ownerIndex[uint(_owner)] = 0;
114         clearPending();
115         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
116         OwnerRemoved(_owner);
117     }
118     
119     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
120         if (_newRequired > m_numOwners) return;
121         m_required = _newRequired;
122         clearPending();
123         RequirementChanged(_newRequired);
124     }
125     
126     function isOwner(address _addr) returns (bool) {
127         return m_ownerIndex[uint(_addr)] > 0;
128     }
129     
130     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
131         var pending = m_pending[_operation];
132         uint ownerIndex = m_ownerIndex[uint(_owner)];
133 
134         // make sure they're an owner
135         if (ownerIndex == 0) return false;
136 
137         // determine the bit to set for this owner.
138         uint ownerIndexBit = 2**ownerIndex;
139         return !(pending.ownersDone & ownerIndexBit == 0);
140     }
141     
142     // INTERNAL METHODS
143 
144     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
145         // determine what index the present sender is:
146         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
147         // make sure they're an owner
148         if (ownerIndex == 0) return;
149 
150         var pending = m_pending[_operation];
151         // if we're not yet working on this operation, switch over and reset the confirmation status.
152         if (pending.yetNeeded == 0) {
153             // reset count of confirmations needed.
154             pending.yetNeeded = m_required;
155             // reset which owners have confirmed (none) - set our bitmap to 0.
156             pending.ownersDone = 0;
157             pending.index = m_pendingIndex.length++;
158             m_pendingIndex[pending.index] = _operation;
159         }
160         // determine the bit to set for this owner.
161         uint ownerIndexBit = 2**ownerIndex;
162         // make sure we (the message sender) haven't confirmed this operation previously.
163         if (pending.ownersDone & ownerIndexBit == 0) {
164             Confirmation(msg.sender, _operation);
165             // ok - check if count is enough to go ahead.
166             if (pending.yetNeeded <= 1) {
167                 // enough confirmations: reset and run interior.
168                 delete m_pendingIndex[m_pending[_operation].index];
169                 delete m_pending[_operation];
170                 return true;
171             }
172             else
173             {
174                 // not enough: record that this owner in particular confirmed.
175                 pending.yetNeeded--;
176                 pending.ownersDone |= ownerIndexBit;
177             }
178         }
179     }
180 
181     function reorganizeOwners() private {
182         uint free = 1;
183         while (free < m_numOwners)
184         {
185             while (free < m_numOwners && m_owners[free] != 0) free++;
186             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
187             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
188             {
189                 m_owners[free] = m_owners[m_numOwners];
190                 m_ownerIndex[m_owners[free]] = free;
191                 m_owners[m_numOwners] = 0;
192             }
193         }
194     }
195     
196     function clearPending() internal {
197         uint length = m_pendingIndex.length;
198         for (uint i = 0; i < length; ++i)
199             if (m_pendingIndex[i] != 0)
200                 delete m_pending[m_pendingIndex[i]];
201         delete m_pendingIndex;
202     }
203         
204    	// FIELDS
205 
206     // the number of owners that must confirm the same operation before it is run.
207     uint public m_required;
208     // pointer used to find a free slot in m_owners
209     uint public m_numOwners;
210     
211     // list of owners
212     uint[256] m_owners;
213     uint constant c_maxOwners = 250;
214     // index on the list of owners to allow reverse lookup
215     mapping(uint => uint) m_ownerIndex;
216     // the ongoing operations.
217     mapping(bytes32 => PendingState) m_pending;
218     bytes32[] m_pendingIndex;
219 }
220 
221 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
222 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
223 // uses is specified in the modifier.
224 contract daylimit is multiowned {
225 
226 	// MODIFIERS
227 
228     // simple modifier for daily limit.
229     modifier limitedDaily(uint _value) {
230         if (underLimit(_value))
231             _
232     }
233 
234 	// METHODS
235 
236     // constructor - stores initial daily limit and records the present day's index.
237     function daylimit(uint _limit) {
238         m_dailyLimit = _limit;
239         m_lastDay = today();
240     }
241     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
242     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
243         m_dailyLimit = _newLimit;
244     }
245     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
246     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
247         m_spentToday = 0;
248     }
249     
250     // INTERNAL METHODS
251     
252     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
253     // returns true. otherwise just returns false.
254     function underLimit(uint _value) internal onlyowner returns (bool) {
255         // reset the spend limit if we're on a different day to last time.
256         if (today() > m_lastDay) {
257             m_spentToday = 0;
258             m_lastDay = today();
259         }
260         // check to see if there's enough left - if so, subtract and return true.
261         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
262             m_spentToday += _value;
263             return true;
264         }
265         return false;
266     }
267     // determines today's index.
268     function today() private constant returns (uint) { return now / 1 days; }
269 
270 	// FIELDS
271 
272     uint public m_dailyLimit;
273     uint m_spentToday;
274     uint m_lastDay;
275 }
276 
277 // interface contract for multisig proxy contracts; see below for docs.
278 contract multisig {
279 
280 	// EVENTS
281 
282     // logged events:
283     // Funds has arrived into the wallet (record how much).
284     event Deposit(address _from, uint value);
285     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
286     event SingleTransact(address owner, uint value, address to, bytes data);
287     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
288     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
289     // Confirmation still needed for a transaction.
290     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
291     
292     // FUNCTIONS
293     
294     // TODO: document
295     function changeOwner(address _from, address _to) external;
296     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
297     function confirm(bytes32 _h) returns (bool);
298 }
299 
300 // usage:
301 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
302 // Wallet(w).from(anotherOwner).confirm(h);
303 contract Wallet is multisig, multiowned, daylimit {
304 
305 	// TYPES
306 
307     // Transaction structure to remember details of transaction lest it need be saved for a later call.
308     struct Transaction {
309         address to;
310         uint value;
311         bytes data;
312     }
313 
314     // METHODS
315 
316     // constructor - just pass on the owner array to the multiowned and
317     // the limit to daylimit
318     function Wallet(address[] _owners, uint _required, uint _daylimit)
319             multiowned(_owners, _required) daylimit(_daylimit) {
320     }
321     
322     // kills the contract sending everything to `_to`.
323     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
324         suicide(_to);
325     }
326     
327     // gets called when no other function matches
328     function() {
329         // just being sent some cash?
330         if (msg.value > 0)
331             Deposit(msg.sender, msg.value);
332     }
333     
334     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
335     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
336     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
337     // and _data arguments). They still get the option of using them if they want, anyways.
338     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
339         // first, take the opportunity to check that we're under the daily limit.
340         if (underLimit(_value)) {
341             SingleTransact(msg.sender, _value, _to, _data);
342             // yes - just execute the call.
343             _to.call.value(_value)(_data);
344             return 0;
345         }
346         // determine our operation hash.
347         _r = sha3(msg.data, block.number);
348         if (!confirm(_r) && m_txs[_r].to == 0) {
349             m_txs[_r].to = _to;
350             m_txs[_r].value = _value;
351             m_txs[_r].data = _data;
352             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
353         }
354     }
355     
356     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
357     // to determine the body of the transaction from the hash provided.
358     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
359         if (m_txs[_h].to != 0) {
360             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
361             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
362             delete m_txs[_h];
363             return true;
364         }
365     }
366     
367     // INTERNAL METHODS
368     
369     function clearPending() internal {
370         uint length = m_pendingIndex.length;
371         for (uint i = 0; i < length; ++i)
372             delete m_txs[m_pendingIndex[i]];
373         super.clearPending();
374     }
375 
376 	// FIELDS
377 
378     // pending transactions we have at present.
379     mapping (bytes32 => Transaction) m_txs;
380 }