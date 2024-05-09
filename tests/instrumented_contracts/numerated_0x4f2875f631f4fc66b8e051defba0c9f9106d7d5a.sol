1 // This multisignature wallet is based on the wallet contract by Gav Wood.
2 // Only one single change was made: The contract creator is not automatically one of the wallet owners.
3 
4 //sol Wallet
5 // Multi-sig, daily-limited account proxy/wallet.
6 // @authors:
7 // Gav Wood <g@ethdev.com>
8 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
9 // single, or, crucially, each of a number of, designated owners.
10 // usage:
11 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
12 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
13 // interior is executed.
14 pragma solidity ^0.4.6;
15 
16 contract multisig {
17     // EVENTS
18 
19     // this contract can accept a confirmation, in which case
20     // we record owner and operation (hash) alongside it.
21     event Confirmation(address owner, bytes32 operation);
22     event Revoke(address owner, bytes32 operation);
23 
24     // some others are in the case of an owner changing.
25     event OwnerChanged(address oldOwner, address newOwner);
26     event OwnerAdded(address newOwner);
27     event OwnerRemoved(address oldOwner);
28 
29     // the last one is emitted if the required signatures change
30     event RequirementChanged(uint newRequirement);
31 
32     // Funds has arrived into the wallet (record how much).
33     event Deposit(address _from, uint value);
34     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
35     event SingleTransact(address owner, uint value, address to, bytes data);
36     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
37     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
38     // Confirmation still needed for a transaction.
39     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
40 }
41 
42 contract multisigAbi is multisig {
43     function isOwner(address _addr) returns (bool);
44 
45     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool);
46 
47     function confirm(bytes32 _h) returns(bool);
48 
49     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
50     function setDailyLimit(uint _newLimit);
51 
52     function addOwner(address _owner);
53 
54     function removeOwner(address _owner);
55 
56     function changeRequirement(uint _newRequired);
57 
58     // Revokes a prior confirmation of the given operation
59     function revoke(bytes32 _operation);
60 
61     function changeOwner(address _from, address _to);
62 
63     function execute(address _to, uint _value, bytes _data) returns(bool);
64 }
65 
66 contract WalletLibrary is multisig {
67     // TYPES
68 
69     // struct for the status of a pending operation.
70     struct PendingState {
71         uint yetNeeded;
72         uint ownersDone;
73         uint index;
74     }
75 
76     // Transaction structure to remember details of transaction lest it need be saved for a later call.
77     struct Transaction {
78         address to;
79         uint value;
80         bytes data;
81     }
82 
83     /******************************
84      ***** MULTI OWNED SECTION ****
85      ******************************/
86 
87     // MODIFIERS
88 
89     // simple single-sig function modifier.
90     modifier onlyowner {
91         if (isOwner(msg.sender))
92             _;
93     }
94     // multi-sig function modifier: the operation must have an intrinsic hash in order
95     // that later attempts can be realised as the same underlying operation and
96     // thus count as confirmations.
97     modifier onlymanyowners(bytes32 _operation) {
98         if (confirmAndCheck(_operation))
99             _;
100     }
101 
102     // METHODS
103 
104     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
105     // as well as the selection of addresses capable of confirming them.
106     // change from original: msg.sender is not automatically owner
107     function initMultiowned(address[] _owners, uint _required) {
108         m_numOwners = _owners.length ;
109         m_required = _required;
110 
111         for (uint i = 0; i < _owners.length; ++i)
112         {
113             m_owners[1 + i] = uint(_owners[i]);
114             m_ownerIndex[uint(_owners[i])] = 1 + i;
115         }
116     }
117 
118     // Revokes a prior confirmation of the given operation
119     function revoke(bytes32 _operation) {
120         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
121         // make sure they're an owner
122         if (ownerIndex == 0) return;
123         uint ownerIndexBit = 2**ownerIndex;
124         var pending = m_pending[_operation];
125         if (pending.ownersDone & ownerIndexBit > 0) {
126             pending.yetNeeded++;
127             pending.ownersDone -= ownerIndexBit;
128             Revoke(msg.sender, _operation);
129         }
130     }
131 
132     // Replaces an owner `_from` with another `_to`.
133     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) {
134         if (isOwner(_to)) return;
135         uint ownerIndex = m_ownerIndex[uint(_from)];
136         if (ownerIndex == 0) return;
137 
138         clearPending();
139         m_owners[ownerIndex] = uint(_to);
140         m_ownerIndex[uint(_from)] = 0;
141         m_ownerIndex[uint(_to)] = ownerIndex;
142         OwnerChanged(_from, _to);
143     }
144 
145     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) {
146         if (isOwner(_owner)) return;
147 
148         clearPending();
149         if (m_numOwners >= c_maxOwners)
150             reorganizeOwners();
151         if (m_numOwners >= c_maxOwners)
152             return;
153         m_numOwners++;
154         m_owners[m_numOwners] = uint(_owner);
155         m_ownerIndex[uint(_owner)] = m_numOwners;
156         OwnerAdded(_owner);
157     }
158 
159     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) {
160         uint ownerIndex = m_ownerIndex[uint(_owner)];
161         if (ownerIndex == 0) return;
162         if (m_required > m_numOwners - 1) return;
163 
164         m_owners[ownerIndex] = 0;
165         m_ownerIndex[uint(_owner)] = 0;
166         clearPending();
167         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
168         OwnerRemoved(_owner);
169     }
170 
171     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) {
172         if (_newRequired > m_numOwners) return;
173         m_required = _newRequired;
174         clearPending();
175         RequirementChanged(_newRequired);
176     }
177 
178     function isOwner(address _addr) returns (bool) {
179         return m_ownerIndex[uint(_addr)] > 0;
180     }
181 
182 
183     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
184         var pending = m_pending[_operation];
185         uint ownerIndex = m_ownerIndex[uint(_owner)];
186 
187         // make sure they're an owner
188         if (ownerIndex == 0) return false;
189 
190         // determine the bit to set for this owner.
191         uint ownerIndexBit = 2**ownerIndex;
192         return !(pending.ownersDone & ownerIndexBit == 0);
193     }
194 
195     // INTERNAL METHODS
196 
197     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
198         // determine what index the present sender is:
199         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
200         // make sure they're an owner
201         if (ownerIndex == 0) return;
202 
203         var pending = m_pending[_operation];
204         // if we're not yet working on this operation, switch over and reset the confirmation status.
205         if (pending.yetNeeded == 0) {
206             // reset count of confirmations needed.
207             pending.yetNeeded = m_required;
208             // reset which owners have confirmed (none) - set our bitmap to 0.
209             pending.ownersDone = 0;
210             pending.index = m_pendingIndex.length++;
211             m_pendingIndex[pending.index] = _operation;
212         }
213         // determine the bit to set for this owner.
214         uint ownerIndexBit = 2**ownerIndex;
215         // make sure we (the message sender) haven't confirmed this operation previously.
216         if (pending.ownersDone & ownerIndexBit == 0) {
217             Confirmation(msg.sender, _operation);
218             // ok - check if count is enough to go ahead.
219             if (pending.yetNeeded <= 1) {
220                 // enough confirmations: reset and run interior.
221                 delete m_pendingIndex[m_pending[_operation].index];
222                 delete m_pending[_operation];
223                 return true;
224             }
225             else
226             {
227                 // not enough: record that this owner in particular confirmed.
228                 pending.yetNeeded--;
229                 pending.ownersDone |= ownerIndexBit;
230             }
231         }
232     }
233 
234     function reorganizeOwners() private {
235         uint free = 1;
236         while (free < m_numOwners)
237         {
238             while (free < m_numOwners && m_owners[free] != 0) free++;
239             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
240             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
241             {
242                 m_owners[free] = m_owners[m_numOwners];
243                 m_ownerIndex[m_owners[free]] = free;
244                 m_owners[m_numOwners] = 0;
245             }
246         }
247     }
248 
249     function clearPending() internal {
250         uint length = m_pendingIndex.length;
251         for (uint i = 0; i < length; ++i)
252             if (m_pendingIndex[i] != 0)
253                 delete m_pending[m_pendingIndex[i]];
254         delete m_pendingIndex;
255     }
256 
257 
258     /******************************
259      ****** DAY LIMIT SECTION *****
260      ******************************/
261 
262     // MODIFIERS
263 
264     // simple modifier for daily limit.
265     modifier limitedDaily(uint _value) {
266         if (underLimit(_value))
267             _;
268     }
269 
270     // METHODS
271 
272     // constructor - stores initial daily limit and records the present day's index.
273     function initDaylimit(uint _limit) {
274         m_dailyLimit = _limit;
275         m_lastDay = today();
276     }
277     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
278     function setDailyLimit(uint _newLimit) onlymanyowners(sha3(msg.data)) {
279         m_dailyLimit = _newLimit;
280     }
281     // resets the amount already spent today. needs many of the owners to confirm.
282     function resetSpentToday() onlymanyowners(sha3(msg.data)) {
283         m_spentToday = 0;
284     }
285 
286     // INTERNAL METHODS
287 
288     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
289     // returns true. otherwise just returns false.
290     function underLimit(uint _value) internal onlyowner returns (bool) {
291         // reset the spend limit if we're on a different day to last time.
292         if (today() > m_lastDay) {
293             m_spentToday = 0;
294             m_lastDay = today();
295         }
296         // check to see if there's enough left - if so, subtract and return true.
297         // overflow protection                    // dailyLimit check
298         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
299             m_spentToday += _value;
300             return true;
301         }
302         return false;
303     }
304 
305     // determines today's index.
306     function today() private constant returns (uint) { return now / 1 days; }
307 
308 
309     /******************************
310      ********* WALLET SECTION *****
311      ******************************/
312 
313     // METHODS
314 
315     // constructor - just pass on the owner array to the multiowned and
316     // the limit to daylimit
317     function initWallet(address[] _owners, uint _required, uint _daylimit) {
318         initMultiowned(_owners, _required);
319         initDaylimit(_daylimit) ;
320     }
321 
322     // kills the contract sending everything to `_to`.
323     function kill(address _to) onlymanyowners(sha3(msg.data)) {
324         suicide(_to);
325     }
326 
327     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
328     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
329     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
330     // and _data arguments). They still get the option of using them if they want, anyways.
331     function execute(address _to, uint _value, bytes _data) onlyowner returns(bool _callValue) {
332         // first, take the opportunity to check that we're under the daily limit.
333         if (underLimit(_value)) {
334             SingleTransact(msg.sender, _value, _to, _data);
335             // yes - just execute the call.
336             _callValue =_to.call.value(_value)(_data);
337         } else {
338             // determine our operation hash.
339             bytes32 _r = sha3(msg.data, block.number);
340             if (!confirm(_r) && m_txs[_r].to == 0) {
341                 m_txs[_r].to = _to;
342                 m_txs[_r].value = _value;
343                 m_txs[_r].data = _data;
344                 ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
345             }
346         }
347     }
348 
349     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
350     // to determine the body of the transaction from the hash provided.
351     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
352         if (m_txs[_h].to != 0) {
353             m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
354             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
355             delete m_txs[_h];
356             return true;
357         }
358     }
359 
360     // INTERNAL METHODS
361 
362     function clearWalletPending() internal {
363         uint length = m_pendingIndex.length;
364         for (uint i = 0; i < length; ++i)
365             delete m_txs[m_pendingIndex[i]];
366         clearPending();
367     }
368 
369     // FIELDS
370     address constant _walletLibrary = 0x4f2875f631f4fc66b8e051defba0c9f9106d7d5a;
371 
372     // the number of owners that must confirm the same operation before it is run.
373     uint m_required;
374     // pointer used to find a free slot in m_owners
375     uint m_numOwners;
376 
377     uint public m_dailyLimit;
378     uint public m_spentToday;
379     uint public m_lastDay;
380 
381     // list of owners
382     uint[256] m_owners;
383     uint constant c_maxOwners = 250;
384 
385     // index on the list of owners to allow reverse lookup
386     mapping(uint => uint) m_ownerIndex;
387     // the ongoing operations.
388     mapping(bytes32 => PendingState) m_pending;
389     bytes32[] m_pendingIndex;
390 
391     // pending transactions we have at present.
392     mapping (bytes32 => Transaction) m_txs;
393 }