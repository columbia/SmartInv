1 //sol Wallet
2 // Multi-sig account proxy/wallet.
3 // @authors:
4 // Gav Wood <g@ethdev.com>
5 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
6 // single, or, crucially, each of a number of, designated owners.
7 // usage:
8 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
9 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
10 // interior is executed.
11 // 
12 // Token/no-daylimit modifications: Dmitry Khovratovich <khovratovich@gmail.com> based on https://github.com/ethereum/dapp-bin/blob/dd5c485359074d49f571693ae064ce78970f3d6d/wallet/wallet.sol
13 
14 pragma solidity ^0.4.15;
15 contract multiowned {
16 
17 	// TYPES
18 
19     // struct for the status of a pending operation.
20     struct PendingState {
21         uint yetNeeded;
22         uint ownersDone;
23         uint index;
24     }
25 
26 	// EVENTS
27 
28     // this contract only has six types of events: it can accept a confirmation, in which case
29     // we record owner and operation (hash) alongside it.
30     event Confirmation(address owner, bytes32 operation);
31     event Revoke(address owner, bytes32 operation);
32     // some others are in the case of an owner changing.
33     event OwnerChanged(address oldOwner, address newOwner);
34     event OwnerAdded(address newOwner);
35     event OwnerRemoved(address oldOwner);
36     // the last one is emitted if the required signatures change
37     event RequirementChanged(uint newRequirement);
38 
39 	// MODIFIERS
40 
41     // simple single-sig function modifier.
42     modifier onlyowner {
43         if (isOwner(msg.sender))
44 
45             _;
46     }
47     // multi-sig function modifier: the operation must have an intrinsic hash in order
48     // that later attempts can be realised as the same underlying operation and
49     // thus count as confirmations.
50     modifier onlymanyowners(bytes32 _operation) {
51         if (confirmAndCheck(_operation))
52 
53             _;
54     }
55 
56 	// METHODS
57 
58     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
59     // as well as the selection of addresses capable of confirming them.
60     function multiowned(address[] _owners, uint _required) {
61         m_numOwners = _owners.length;
62         for (uint i = 0; i < _owners.length; ++i)
63         {
64             m_owners[1 + i] = uint(_owners[i]);
65             m_ownerIndex[uint(_owners[i])] = 1 + i;
66         }
67         m_required = _required;
68     }
69     
70     // Revokes a prior confirmation of the given operation
71     function revoke(bytes32 _operation) external {
72         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
73         // make sure they're an owner
74         if (ownerIndex == 0) return;
75         uint ownerIndexBit = 2**ownerIndex;
76         var pending = m_pending[_operation];
77         if (pending.ownersDone & ownerIndexBit > 0) {
78             pending.yetNeeded++;
79             pending.ownersDone -= ownerIndexBit;
80             Revoke(msg.sender, _operation);
81         }
82     }
83     
84     // Replaces an owner `_from` with another `_to`.
85     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
86         if (isOwner(_to)) return;
87         uint ownerIndex = m_ownerIndex[uint(_from)];
88         if (ownerIndex == 0) return;
89 
90         clearPending();
91         m_owners[ownerIndex] = uint(_to);
92         m_ownerIndex[uint(_from)] = 0;
93         m_ownerIndex[uint(_to)] = ownerIndex;
94         OwnerChanged(_from, _to);
95     }
96     
97     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
98         if (isOwner(_owner)) return;
99 
100         clearPending();
101         if (m_numOwners >= c_maxOwners)
102             reorganizeOwners();
103         if (m_numOwners >= c_maxOwners)
104             return;
105         m_numOwners++;
106         m_owners[m_numOwners] = uint(_owner);
107         m_ownerIndex[uint(_owner)] = m_numOwners;
108         OwnerAdded(_owner);
109     }
110     
111     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
112         uint ownerIndex = m_ownerIndex[uint(_owner)];
113         if (ownerIndex == 0) return;
114         if (m_required > m_numOwners - 1) return;
115 
116         m_owners[ownerIndex] = 0;
117         m_ownerIndex[uint(_owner)] = 0;
118         clearPending();
119         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
120         OwnerRemoved(_owner);
121     }
122     
123     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
124         if (_newRequired > m_numOwners) return;
125         m_required = _newRequired;
126         clearPending();
127         RequirementChanged(_newRequired);
128     }
129 
130 
131     // Gets an owner by 0-indexed position (using numOwners as the count)
132     function getOwner(uint ownerIndex) external constant returns (address) {
133         return address(m_owners[ownerIndex + 1]);
134     }
135 
136     function isOwner(address _addr) constant returns (bool) {
137         return m_ownerIndex[uint(_addr)] > 0;
138     }
139     
140     function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
141         var pending = m_pending[_operation];
142         uint ownerIndex = m_ownerIndex[uint(_owner)];
143 
144         // make sure they're an owner
145         if (ownerIndex == 0) return false;
146 
147         // determine the bit to set for this owner.
148         uint ownerIndexBit = 2**ownerIndex;
149         return !(pending.ownersDone & ownerIndexBit == 0);
150 
151 
152 
153 
154     }
155     
156     // INTERNAL METHODS
157 
158     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
159         // determine what index the present sender is:
160         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
161         // make sure they're an owner
162         if (ownerIndex == 0) return;
163 
164         var pending = m_pending[_operation];
165         // if we're not yet working on this operation, switch over and reset the confirmation status.
166         if (pending.yetNeeded == 0) {
167             // reset count of confirmations needed.
168             pending.yetNeeded = m_required;
169             // reset which owners have confirmed (none) - set our bitmap to 0.
170             pending.ownersDone = 0;
171             pending.index = m_pendingIndex.length++;
172             m_pendingIndex[pending.index] = _operation;
173         }
174         // determine the bit to set for this owner.
175         uint ownerIndexBit = 2**ownerIndex;
176         // make sure we (the message sender) haven't confirmed this operation previously.
177         if (pending.ownersDone & ownerIndexBit == 0) {
178             Confirmation(msg.sender, _operation);
179             // ok - check if count is enough to go ahead.
180             if (pending.yetNeeded <= 1) {
181                 // enough confirmations: reset and run interior.
182                 delete m_pendingIndex[m_pending[_operation].index];
183                 delete m_pending[_operation];
184                 return true;
185             }
186             else
187             {
188                 // not enough: record that this owner in particular confirmed.
189                 pending.yetNeeded--;
190                 pending.ownersDone |= ownerIndexBit;
191             }
192         }
193     }
194 
195     function reorganizeOwners() private {
196         uint free = 1;
197         while (free < m_numOwners)
198         {
199             while (free < m_numOwners && m_owners[free] != 0) free++;
200             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
201             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
202             {
203                 m_owners[free] = m_owners[m_numOwners];
204                 m_ownerIndex[m_owners[free]] = free;
205                 m_owners[m_numOwners] = 0;
206             }
207         }
208     }
209     
210     function clearPending() internal {
211         uint length = m_pendingIndex.length;
212         for (uint i = 0; i < length; ++i)
213             if (m_pendingIndex[i] != 0)
214                 delete m_pending[m_pendingIndex[i]];
215         delete m_pendingIndex;
216     }
217         
218    	// FIELDS
219 
220     // the number of owners that must confirm the same operation before it is run.
221     uint public m_required;
222     // pointer used to find a free slot in m_owners
223     uint public m_numOwners;
224     
225     // list of owners
226     uint[256] m_owners;
227     uint constant c_maxOwners = 250;
228     // index on the list of owners to allow reverse lookup
229     mapping(uint => uint) m_ownerIndex;
230     // the ongoing operations.
231     mapping(bytes32 => PendingState) m_pending;
232     bytes32[] m_pendingIndex;
233 }
234 
235 
236 
237 // interface contract for multisig proxy contracts; see below for docs.
238 contract multisig {
239 
240 	// EVENTS
241 
242     // logged events:
243     // Funds has arrived into the wallet (record how much).
244     event Deposit(address _from, uint value);
245     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
246     event SingleTransact(address owner, uint value, address to, bytes data);
247     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
248     event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
249     // Confirmation still needed for a transaction.
250     event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
251     
252     // FUNCTIONS
253     
254     // TODO: document
255     function changeOwner(address _from, address _to) external;
256     function execute(address _to, uint _value, bytes _data) external returns (bytes32);
257     function confirm(bytes32 _h) returns (bool);
258 }
259 
260 // usage:
261 // bytes32 h = Wallet(w).from(oneOwner).execute(to, value, data);
262 // Wallet(w).from(anotherOwner).confirm(h);
263 contract Wallet is multisig, multiowned {
264 
265 
266 
267 	// TYPES
268 
269     // Transaction structure to remember details of transaction lest it need be saved for a later call.
270     struct Transaction {
271         address to;
272         uint value;
273         bytes data;
274     }
275 
276     // METHODS
277 
278     // constructor - just pass on the owner array to the multiowned 
279     function Wallet(address[] _owners, uint _required)
280             multiowned(_owners, _required)  {
281     }
282     
283     
284     // gets called when no other function matches
285     function() payable{
286         // just being sent some cash?
287         if (msg.value > 0)
288             Deposit(msg.sender, msg.value);
289     }
290     
291     // Outside-visible transact entry point. Executes transaction immediately if below daily spend limit.
292     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
293     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
294     // and _data arguments). They still get the option of using them if they want, anyways.
295     function execute(address _to, uint _value, bytes _data) external onlyowner returns (bytes32 _r) {
296         // determine our operation hash.
297         _r = sha3(msg.data, block.number);
298         if (!confirm(_r) && m_txs[_r].to == 0) {
299             m_txs[_r].to = _to;
300             m_txs[_r].value = _value;
301             m_txs[_r].data = _data;
302             ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
303         }
304     }
305     
306     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
307     // to determine the body of the transaction from the hash provided.
308     function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
309         if (m_txs[_h].to != 0) {
310             var x= m_txs[_h].to.call.value(m_txs[_h].value)(m_txs[_h].data);
311             MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to, m_txs[_h].data);
312             delete m_txs[_h];
313             return true;
314         }
315     }
316     
317     // INTERNAL METHODS
318     
319     function clearPending() internal {
320         uint length = m_pendingIndex.length;
321         for (uint i = 0; i < length; ++i)
322             delete m_txs[m_pendingIndex[i]];
323         super.clearPending();
324     }
325 
326 	// FIELDS
327 
328     // pending transactions we have at present.
329     mapping (bytes32 => Transaction) m_txs;
330 }