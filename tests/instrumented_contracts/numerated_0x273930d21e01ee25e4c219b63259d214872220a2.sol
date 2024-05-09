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
13     // TYPES
14 
15     // struct for the status of a pending operation.
16     struct PendingState {
17         uint yetNeeded;
18         uint ownersDone;
19         uint index;
20     }
21 
22     // EVENTS
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
35     // MODIFIERS
36 
37     // simple single-sig function modifier.
38     modifier onlyowner {
39         if (isOwner(tx.origin))
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
50     // METHODS
51 
52     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
53     // as well as the selection of addresses capable of confirming them.
54     function multiowned(address[] _owners, uint _required) {
55         m_numOwners = _owners.length + 1;
56         m_owners[1] = uint(tx.origin);
57         m_ownerIndex[uint(tx.origin)] = 1;
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
68         uint ownerIndex = m_ownerIndex[uint(tx.origin)];
69         // make sure they're an owner
70         if (ownerIndex == 0) return;
71         uint ownerIndexBit = 2**ownerIndex;
72         var pending = m_pending[_operation];
73         if (pending.ownersDone & ownerIndexBit > 0) {
74             pending.yetNeeded++;
75             pending.ownersDone -= ownerIndexBit;
76             Revoke(tx.origin, _operation);
77         }
78     }
79     
80     // Replaces an owner `_from` with another `_to`.
81     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data, block.number)) external {
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
93     function addOwner(address _owner) onlymanyowners(sha3(msg.data, block.number)) external {
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
107     function removeOwner(address _owner) onlymanyowners(sha3(msg.data, block.number)) external {
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
119     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data, block.number)) external {
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
139         if (pending.ownersDone & ownerIndexBit == 0) {
140             return false;
141         } else {
142             return true;
143         }
144     }
145     
146     // INTERNAL METHODS
147 
148     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
149         // determine what index the present sender is:
150         uint ownerIndex = m_ownerIndex[uint(tx.origin)];
151         // make sure they're an owner
152         if (ownerIndex == 0) return;
153 
154         var pending = m_pending[_operation];
155         // if we're not yet working on this operation, switch over and reset the confirmation status.
156         if (pending.yetNeeded == 0) {
157             // reset count of confirmations needed.
158             pending.yetNeeded = m_required;
159             // reset which owners have confirmed (none) - set our bitmap to 0.
160             pending.ownersDone = 0;
161             pending.index = m_pendingIndex.length++;
162             m_pendingIndex[pending.index] = _operation;
163         }
164         // determine the bit to set for this owner.
165         uint ownerIndexBit = 2**ownerIndex;
166         // make sure we (the message sender) haven't confirmed this operation previously.
167         if (pending.ownersDone & ownerIndexBit == 0) {
168             Confirmation(tx.origin, _operation);
169             // ok - check if count is enough to go ahead.
170             if (pending.yetNeeded <= 1) {
171                 // enough confirmations: reset and run interior.
172                 delete m_pendingIndex[m_pending[_operation].index];
173                 delete m_pending[_operation];
174                 return true;
175             }
176             else
177             {
178                 // not enough: record that this owner in particular confirmed.
179                 pending.yetNeeded--;
180                 pending.ownersDone |= ownerIndexBit;
181             }
182         }
183     }
184 
185     function reorganizeOwners() private returns (bool) {
186         uint free = 1;
187         while (free < m_numOwners)
188         {
189             while (free < m_numOwners && m_owners[free] != 0) free++;
190             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
191             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
192             {
193                 m_owners[free] = m_owners[m_numOwners];
194                 m_ownerIndex[m_owners[free]] = free;
195                 m_owners[m_numOwners] = 0;
196             }
197         }
198     }
199     
200     function clearPending() internal {
201         uint length = m_pendingIndex.length;
202         for (uint i = 0; i < length; ++i)
203             if (m_pendingIndex[i] != 0)
204                 delete m_pending[m_pendingIndex[i]];
205         delete m_pendingIndex;
206     }
207         
208     // FIELDS
209 
210     // the number of owners that must confirm the same operation before it is run.
211     uint public m_required;
212     // pointer used to find a free slot in m_owners
213     uint public m_numOwners;
214     
215     // list of owners
216     uint[256] m_owners;
217     uint constant c_maxOwners = 250;
218     // index on the list of owners to allow reverse lookup
219     mapping(uint => uint) m_ownerIndex;
220     // the ongoing operations.
221     mapping(bytes32 => PendingState) m_pending;
222     bytes32[] m_pendingIndex;
223 }
224 
225 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
226 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
227 // uses is specified in the modifier.
228 contract daylimit is multiowned {
229 
230     // MODIFIERS
231 
232     // simple modifier for daily limit.
233     modifier limitedDaily(uint _value) {
234         if (underLimit(_value))
235             _
236     }
237 
238     // METHODS
239 
240     // constructor - stores initial daily limit and records the present day's index.
241     function daylimit(uint _limit) {
242         m_dailyLimit = _limit;
243         m_lastDay = today();
244     }
245     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
246     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data, block.number)) external {
247         m_dailyLimit = _newLimit;
248     }
249     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
250     function resetSpentToday() onlymanyowners(sha3(msg.data, block.number)) external {
251         m_spentToday = 0;
252     }
253     
254     // INTERNAL METHODS
255     
256     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
257     // returns true. otherwise just returns false.
258     function underLimit(uint _value) internal onlyowner returns (bool) {
259         // reset the spend limit if we're on a different day to last time.
260         if (today() > m_lastDay) {
261             m_spentToday = 0;
262             m_lastDay = today();
263         }
264         // check to see if there's enough left - if so, subtract and return true.
265         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
266             m_spentToday += _value;
267             return true;
268         }
269         return false;
270     }
271     // determines today's index.
272     function today() private constant returns (uint) { return now / 1 days; }
273 
274     // FIELDS
275 
276     uint public m_dailyLimit;
277     uint public m_spentToday;
278     uint public m_lastDay;
279 }
280 
281 // interface contract for multisig proxy contracts; see below for docs.
282 contract multisig {
283 
284     // EVENTS
285 
286     // logged events:
287     // Funds has arrived into the wallet (record how much).
288     event Deposit(address from, uint value);
289     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
290     event SingleTransact(address owner, uint value, address to, bytes data);
291     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
292     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
293     // Confirmation still needed for a transaction.
294     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
295     
296     // FUNCTIONS
297     
298     // TODO: document
299     function changeOwner(address _from, address _to) external;
300     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
301     function confirm(bytes32 _h) returns (bool);
302 }
303 
304 // usage:
305 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
306 // Wallet(w).from(anotherOwner).confirm(h);
307 contract Wallet is multisig, multiowned, daylimit {
308 
309     uint public version = 2;
310 
311     // TYPES
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
329     function kill(address _to) onlymanyowners(sha3(msg.data, block.number)) external {
330         suicide(_to);
331     }
332     
333     // gets called when no other function matches
334     function() {
335         // just being sent some cash?
336         if (msg.value > 0)
337             Deposit(tx.origin, msg.value);
338     }
339     
340     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
341     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
342     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
343     // and _data arguments). They still get the option of using them if they want, anyways.
344     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
345         // first, take the opportunity to check that we're under the daily limit.
346         if (underLimit(_value)) {
347             SingleTransact(tx.origin, _value, _to, _data);
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
358             ConfirmationNeeded(_r, tx.origin, _value, _to, _data);
359         }
360     }
361     
362     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
363     // to determine the body of the transaction from the hash provided.
364     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
365         if (m_txs[_h].to != 0) {
366             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
367             MultiTransact(tx.origin, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
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
382     // FIELDS
383 
384     // pending transactions we have at present.
385     mapping (bytes32 => Transaction) m_txs;
386 }