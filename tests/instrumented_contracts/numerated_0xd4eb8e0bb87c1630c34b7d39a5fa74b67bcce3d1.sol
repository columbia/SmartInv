1 /**
2  * This is a multisig wallet based on Gav's original implementation, daily withdraw limits removed.
3  *
4  *
5  * For other multisig wallet implementations, see https://blog.gnosis.pm/release-of-new-multisig-wallet-59b6811f7edc
6  */
7 
8 // Multi-sig, daily-limited account proxy/wallet.
9 // @authors:
10 // Gav Wood <g@ethdev.com>
11 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
12 // single, or, crucially, each of a number of, designated owners.
13 // usage:
14 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
15 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
16 // interior is executed.
17 contract multiowned {
18 
19 	// TYPES
20 
21     // struct for the status of a pending operation.
22     struct PendingState {
23         uint yetNeeded;
24         uint ownersDone;
25         uint index;
26     }
27 
28 	// EVENTS
29 
30     // this contract only has six types of events: it can accept a confirmation, in which case
31     // we record owner and operation (hash) alongside it.
32     event Confirmation(address owner, bytes32 operation);
33     event Revoke(address owner, bytes32 operation);
34     // some others are in the case of an owner changing.
35     event OwnerChanged(address oldOwner, address newOwner);
36     event OwnerAdded(address newOwner);
37     event OwnerRemoved(address oldOwner);
38     // the last one is emitted if the required signatures change
39     event RequirementChanged(uint newRequirement);
40 
41 	// MODIFIERS
42 
43     // simple single-sig function modifier.
44     modifier onlyowner {
45         if (isOwner(msg.sender))
46             _;
47     }
48     // multi-sig function modifier: the operation must have an intrinsic hash in order
49     // that later attempts can be realised as the same underlying operation and
50     // thus count as confirmations.
51     modifier onlymanyowners(bytes32 _operation) {
52         if (confirmAndCheck(_operation))
53             _;
54     }
55 
56 	// METHODS
57 
58     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
59     // as well as the selection of addresses capable of confirming them.
60     function multiowned(address[] _owners, uint _required) {
61         m_numOwners = _owners.length + 1;
62         m_owners[1] = uint(msg.sender);
63         m_ownerIndex[uint(msg.sender)] = 1;
64         for (uint i = 0; i < _owners.length; ++i)
65         {
66             m_owners[2 + i] = uint(_owners[i]);
67             m_ownerIndex[uint(_owners[i])] = 2 + i;
68         }
69         m_required = _required;
70     }
71 
72     // Revokes a prior confirmation of the given operation
73     function revoke(bytes32 _operation) external {
74         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
75         // make sure they're an owner
76         if (ownerIndex == 0) return;
77         uint ownerIndexBit = 2**ownerIndex;
78         var pending = m_pending[_operation];
79         if (pending.ownersDone & ownerIndexBit > 0) {
80             pending.yetNeeded++;
81             pending.ownersDone -= ownerIndexBit;
82             Revoke(msg.sender, _operation);
83         }
84     }
85 
86     // Replaces an owner `_from` with another `_to`.
87     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
88         if (isOwner(_to)) return;
89         uint ownerIndex = m_ownerIndex[uint(_from)];
90         if (ownerIndex == 0) return;
91 
92         clearPending();
93         m_owners[ownerIndex] = uint(_to);
94         m_ownerIndex[uint(_from)] = 0;
95         m_ownerIndex[uint(_to)] = ownerIndex;
96         OwnerChanged(_from, _to);
97     }
98 
99     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
100         if (isOwner(_owner)) return;
101 
102         clearPending();
103         if (m_numOwners >= c_maxOwners)
104             reorganizeOwners();
105         if (m_numOwners >= c_maxOwners)
106             return;
107         m_numOwners++;
108         m_owners[m_numOwners] = uint(_owner);
109         m_ownerIndex[uint(_owner)] = m_numOwners;
110         OwnerAdded(_owner);
111     }
112 
113     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
114         uint ownerIndex = m_ownerIndex[uint(_owner)];
115         if (ownerIndex == 0) return;
116         if (m_required > m_numOwners - 1) return;
117 
118         m_owners[ownerIndex] = 0;
119         m_ownerIndex[uint(_owner)] = 0;
120         clearPending();
121         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
122         OwnerRemoved(_owner);
123     }
124 
125     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
126         if (_newRequired > m_numOwners) return;
127         m_required = _newRequired;
128         clearPending();
129         RequirementChanged(_newRequired);
130     }
131 
132     // Gets an owner by 0-indexed position (using numOwners as the count)
133     function getOwner(uint ownerIndex) external constant returns (address) {
134         return address(m_owners[ownerIndex + 1]);
135     }
136 
137     function isOwner(address _addr) returns (bool) {
138         return m_ownerIndex[uint(_addr)] > 0;
139     }
140 
141     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
142         var pending = m_pending[_operation];
143         uint ownerIndex = m_ownerIndex[uint(_owner)];
144 
145         // make sure they're an owner
146         if (ownerIndex == 0) return false;
147 
148         // determine the bit to set for this owner.
149         uint ownerIndexBit = 2**ownerIndex;
150         return !(pending.ownersDone & ownerIndexBit == 0);
151     }
152 
153     // INTERNAL METHODS
154 
155     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
156         // determine what index the present sender is:
157         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
158         // make sure they're an owner
159         if (ownerIndex == 0) return;
160 
161         var pending = m_pending[_operation];
162         // if we're not yet working on this operation, switch over and reset the confirmation status.
163         if (pending.yetNeeded == 0) {
164             // reset count of confirmations needed.
165             pending.yetNeeded = m_required;
166             // reset which owners have confirmed (none) - set our bitmap to 0.
167             pending.ownersDone = 0;
168             pending.index = m_pendingIndex.length++;
169             m_pendingIndex[pending.index] = _operation;
170         }
171         // determine the bit to set for this owner.
172         uint ownerIndexBit = 2**ownerIndex;
173         // make sure we (the message sender) haven't confirmed this operation previously.
174         if (pending.ownersDone & ownerIndexBit == 0) {
175             Confirmation(msg.sender, _operation);
176             // ok - check if count is enough to go ahead.
177             if (pending.yetNeeded <= 1) {
178                 // enough confirmations: reset and run interior.
179                 delete m_pendingIndex[m_pending[_operation].index];
180                 delete m_pending[_operation];
181                 return true;
182             }
183             else
184             {
185                 // not enough: record that this owner in particular confirmed.
186                 pending.yetNeeded--;
187                 pending.ownersDone |= ownerIndexBit;
188             }
189         }
190     }
191 
192     function reorganizeOwners() private {
193         uint free = 1;
194         while (free < m_numOwners)
195         {
196             while (free < m_numOwners && m_owners[free] != 0) free++;
197             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
198             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
199             {
200                 m_owners[free] = m_owners[m_numOwners];
201                 m_ownerIndex[m_owners[free]] = free;
202                 m_owners[m_numOwners] = 0;
203             }
204         }
205     }
206 
207     function clearPending() internal {
208         uint length = m_pendingIndex.length;
209         for (uint i = 0; i < length; ++i)
210             if (m_pendingIndex[i] != 0)
211                 delete m_pending[m_pendingIndex[i]];
212         delete m_pendingIndex;
213     }
214 
215    	// FIELDS
216 
217     // the number of owners that must confirm the same operation before it is run.
218     uint public m_required;
219     // pointer used to find a free slot in m_owners
220     uint public m_numOwners;
221 
222     // list of owners
223     uint[256] m_owners;
224     uint constant c_maxOwners = 250;
225     // index on the list of owners to allow reverse lookup
226     mapping(uint => uint) m_ownerIndex;
227     // the ongoing operations.
228     mapping(bytes32 => PendingState) m_pending;
229     bytes32[] m_pendingIndex;
230 }
231 
232 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
233 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
234 // uses is specified in the modifier.
235 contract daylimit is multiowned {
236 
237 	// MODIFIERS
238 
239     // simple modifier for daily limit.
240     modifier limitedDaily(uint _value) {
241         if (underLimit(_value))
242             _;
243     }
244 
245 	// METHODS
246 
247     // constructor - stores initial daily limit and records the present day's index.
248     function daylimit(uint _limit) {
249         m_dailyLimit = _limit;
250         m_lastDay = today();
251     }
252     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
253     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) external {
254         m_dailyLimit = _newLimit;
255     }
256     // resets the amount already spent today. needs many of the owners to confirm.
257     function resetSpentToday() onlymanyowners(sha3(msg.data)) external {
258         m_spentToday = 0;
259     }
260 
261     // INTERNAL METHODS
262 
263     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
264     // returns true. otherwise just returns false.
265     function underLimit(uint _value) internal onlyowner returns (bool) {
266         // reset the spend limit if we're on a different day to last time.
267         /*if (today() > m_lastDay) {
268             m_spentToday = 0;
269             m_lastDay = today();
270         }
271         // check to see if there's enough left - if so, subtract and return true.
272         // overflow protection                    // dailyLimit check
273         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
274             m_spentToday += _value;
275             return true;
276         }
277         return false;*/
278         return true; //Villetest
279     }
280     // determines today's index.
281     function today() private constant returns (uint) { return now / 1 days; }
282 
283 	// FIELDS
284 
285     uint public m_dailyLimit;
286     uint public m_spentToday;
287     uint public m_lastDay;
288 }
289 
290 // interface contract for multisig proxy contracts; see below for docs.
291 contract multisig {
292 
293 	// EVENTS
294 
295     // logged events:
296     // Funds has arrived into the wallet (record how much).
297     event Deposit(address _from, uint value);
298     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
299     event SingleTransact(address owner, uint value, address to, bytes data);
300     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
301     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
302     // Confirmation still needed for a transaction.
303     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
304 
305     // FUNCTIONS
306 
307     // TODO: document
308     function changeOwner(address _from, address _to) external;
309     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
310     function confirm(bytes32 _h) returns (bool);
311 }
312 
313 // usage:
314 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
315 // Wallet(w).from(anotherOwner).confirm(h);
316 contract Wallet is multisig, multiowned, daylimit {
317 
318 	// TYPES
319 
320     // Transaction structure to remember details of transaction lest it need be saved for a later call.
321     struct Transaction {
322         address to;
323         uint value;
324         bytes data;
325     }
326 
327     // METHODS
328 
329     // constructor - just pass on the owner array to the multiowned and
330     // the limit to daylimit
331     function Wallet(address[] _owners, uint _required, uint _daylimit)
332             multiowned(_owners, _required) daylimit(_daylimit) {
333     }
334 
335     // kills the contract sending everything to `_to`.
336     function kill(address _to) onlymanyowners(sha3(msg.data)) external {
337         suicide(_to);
338     }
339 
340     // gets called when no other function matches
341     function() payable {
342         // just being sent some cash?
343         if (msg.value > 0)
344             Deposit(msg.sender, msg.value);
345     }
346 
347     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
348     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
349     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
350     // and _data arguments). They still get the option of using them if they want, anyways.
351     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
352         // first, take the opportunity to check that we're under the daily limit.
353         if (underLimit(_value)) {
354             SingleTransact(msg.sender, _value, _to, _data);
355             // yes - just execute the call.
356             _to.call.value(_value)(_data);
357             return 0;
358         }
359         // determine our operation hash.
360         _r = sha3(msg.data, block.number);
361         if (!confirm(_r) && m_txs[_r].to == 0) {
362             m_txs[_r].to = _to;
363             m_txs[_r].value = _value;
364             m_txs[_r].data = _data;
365             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
366         }
367     }
368 
369     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
370     // to determine the body of the transaction from the hash provided.
371     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
372         if (m_txs[_h].to != 0) {
373             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
374             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
375             delete m_txs[_h];
376             return true;
377         }
378     }
379 
380     // INTERNAL METHODS
381 
382     function clearPending() internal {
383         uint length = m_pendingIndex.length;
384         for (uint i = 0; i < length; ++i)
385             delete m_txs[m_pendingIndex[i]];
386         super.clearPending();
387     }
388 
389 	// FIELDS
390 
391     // pending transactions we have at present.
392     mapping (bytes32 => Transaction) m_txs;
393 }