1 pragma solidity 0.4.15;
2 
3 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
4 // Audit, refactoring and improvements by github.com/Eenae
5 
6 // @authors:
7 // Gav Wood <g@ethdev.com>
8 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
9 // single, or, crucially, each of a number of, designated owners.
10 // usage:
11 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
12 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
13 // interior is executed.
14 
15 
16 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
17 // TODO acceptOwnership
18 contract multiowned {
19 
20 	// TYPES
21 
22     // struct for the status of a pending operation.
23     struct MultiOwnedOperationPendingState {
24         // count of confirmations needed
25         uint yetNeeded;
26 
27         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
28         uint ownersDone;
29 
30         // position of this operation key in m_multiOwnedPendingIndex
31         uint index;
32     }
33 
34 	// EVENTS
35 
36     event Confirmation(address owner, bytes32 operation);
37     event Revoke(address owner, bytes32 operation);
38     event FinalConfirmation(address owner, bytes32 operation);
39 
40     // some others are in the case of an owner changing.
41     event OwnerChanged(address oldOwner, address newOwner);
42     event OwnerAdded(address newOwner);
43     event OwnerRemoved(address oldOwner);
44 
45     // the last one is emitted if the required signatures change
46     event RequirementChanged(uint newRequirement);
47 
48 	// MODIFIERS
49 
50     // simple single-sig function modifier.
51     modifier onlyowner {
52         require(isOwner(msg.sender));
53         _;
54     }
55     // multi-sig function modifier: the operation must have an intrinsic hash in order
56     // that later attempts can be realised as the same underlying operation and
57     // thus count as confirmations.
58     modifier onlymanyowners(bytes32 _operation) {
59         if (confirmAndCheck(_operation)) {
60             _;
61         }
62         // Even if required number of confirmations has't been collected yet,
63         // we can't throw here - because changes to the state have to be preserved.
64         // But, confirmAndCheck itself will throw in case sender is not an owner.
65     }
66 
67     modifier validNumOwners(uint _numOwners) {
68         require(_numOwners > 0 && _numOwners <= c_maxOwners);
69         _;
70     }
71 
72     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
73         require(_required > 0 && _required <= _numOwners);
74         _;
75     }
76 
77     modifier ownerExists(address _address) {
78         require(isOwner(_address));
79         _;
80     }
81 
82     modifier ownerDoesNotExist(address _address) {
83         require(!isOwner(_address));
84         _;
85     }
86 
87     modifier multiOwnedOperationIsActive(bytes32 _operation) {
88         require(isOperationActive(_operation));
89         _;
90     }
91 
92 	// METHODS
93 
94     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
95     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
96     function multiowned(address[] _owners, uint _required)
97         validNumOwners(_owners.length)
98         multiOwnedValidRequirement(_required, _owners.length)
99     {
100         assert(c_maxOwners <= 255);
101 
102         m_numOwners = _owners.length;
103         m_multiOwnedRequired = _required;
104 
105         for (uint i = 0; i < _owners.length; ++i)
106         {
107             address owner = _owners[i];
108             // invalid and duplicate addresses are not allowed
109             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
110 
111             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
112             m_owners[currentOwnerIndex] = owner;
113             m_ownerIndex[owner] = currentOwnerIndex;
114         }
115 
116         assertOwnersAreConsistent();
117     }
118 
119     /// @notice replaces an owner `_from` with another `_to`.
120     /// @param _from address of owner to replace
121     /// @param _to address of new owner
122     // All pending operations will be canceled!
123     function changeOwner(address _from, address _to)
124         external
125         ownerExists(_from)
126         ownerDoesNotExist(_to)
127         onlymanyowners(sha3(msg.data))
128     {
129         assertOwnersAreConsistent();
130 
131         clearPending();
132         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
133         m_owners[ownerIndex] = _to;
134         m_ownerIndex[_from] = 0;
135         m_ownerIndex[_to] = ownerIndex;
136 
137         assertOwnersAreConsistent();
138         OwnerChanged(_from, _to);
139     }
140 
141     /// @notice adds an owner
142     /// @param _owner address of new owner
143     // All pending operations will be canceled!
144     function addOwner(address _owner)
145         external
146         ownerDoesNotExist(_owner)
147         validNumOwners(m_numOwners + 1)
148         onlymanyowners(sha3(msg.data))
149     {
150         assertOwnersAreConsistent();
151 
152         clearPending();
153         m_numOwners++;
154         m_owners[m_numOwners] = _owner;
155         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
156 
157         assertOwnersAreConsistent();
158         OwnerAdded(_owner);
159     }
160 
161     /// @notice removes an owner
162     /// @param _owner address of owner to remove
163     // All pending operations will be canceled!
164     function removeOwner(address _owner)
165         external
166         ownerExists(_owner)
167         validNumOwners(m_numOwners - 1)
168         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
169         onlymanyowners(sha3(msg.data))
170     {
171         assertOwnersAreConsistent();
172 
173         clearPending();
174         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
175         m_owners[ownerIndex] = 0;
176         m_ownerIndex[_owner] = 0;
177         //make sure m_numOwners is equal to the number of owners and always points to the last owner
178         reorganizeOwners();
179 
180         assertOwnersAreConsistent();
181         OwnerRemoved(_owner);
182     }
183 
184     /// @notice changes the required number of owner signatures
185     /// @param _newRequired new number of signatures required
186     // All pending operations will be canceled!
187     function changeRequirement(uint _newRequired)
188         external
189         multiOwnedValidRequirement(_newRequired, m_numOwners)
190         onlymanyowners(sha3(msg.data))
191     {
192         m_multiOwnedRequired = _newRequired;
193         clearPending();
194         RequirementChanged(_newRequired);
195     }
196 
197     /// @notice Gets an owner by 0-indexed position
198     /// @param ownerIndex 0-indexed owner position
199     function getOwner(uint ownerIndex) public constant returns (address) {
200         return m_owners[ownerIndex + 1];
201     }
202 
203     /// @notice Gets owners
204     /// @return memory array of owners
205     function getOwners() public constant returns (address[]) {
206         address[] memory result = new address[](m_numOwners);
207         for (uint i = 0; i < m_numOwners; i++)
208             result[i] = getOwner(i);
209 
210         return result;
211     }
212 
213     /// @notice checks if provided address is an owner address
214     /// @param _addr address to check
215     /// @return true if it's an owner
216     function isOwner(address _addr) public constant returns (bool) {
217         return m_ownerIndex[_addr] > 0;
218     }
219 
220     /// @notice Tests ownership of the current caller.
221     /// @return true if it's an owner
222     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
223     // addOwner/changeOwner and to isOwner.
224     function amIOwner() external constant onlyowner returns (bool) {
225         return true;
226     }
227 
228     /// @notice Revokes a prior confirmation of the given operation
229     /// @param _operation operation value, typically sha3(msg.data)
230     function revoke(bytes32 _operation)
231         external
232         multiOwnedOperationIsActive(_operation)
233         onlyowner
234     {
235         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
236         var pending = m_multiOwnedPending[_operation];
237         require(pending.ownersDone & ownerIndexBit > 0);
238 
239         assertOperationIsConsistent(_operation);
240 
241         pending.yetNeeded++;
242         pending.ownersDone -= ownerIndexBit;
243 
244         assertOperationIsConsistent(_operation);
245         Revoke(msg.sender, _operation);
246     }
247 
248     /// @notice Checks if owner confirmed given operation
249     /// @param _operation operation value, typically sha3(msg.data)
250     /// @param _owner an owner address
251     function hasConfirmed(bytes32 _operation, address _owner)
252         external
253         constant
254         multiOwnedOperationIsActive(_operation)
255         ownerExists(_owner)
256         returns (bool)
257     {
258         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
259     }
260 
261     // INTERNAL METHODS
262 
263     function confirmAndCheck(bytes32 _operation)
264         private
265         onlyowner
266         returns (bool)
267     {
268         if (512 == m_multiOwnedPendingIndex.length)
269             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
270             // we won't be able to do it because of block gas limit.
271             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
272             // TODO use more graceful approach like compact or removal of clearPending completely
273             clearPending();
274 
275         var pending = m_multiOwnedPending[_operation];
276 
277         // if we're not yet working on this operation, switch over and reset the confirmation status.
278         if (! isOperationActive(_operation)) {
279             // reset count of confirmations needed.
280             pending.yetNeeded = m_multiOwnedRequired;
281             // reset which owners have confirmed (none) - set our bitmap to 0.
282             pending.ownersDone = 0;
283             pending.index = m_multiOwnedPendingIndex.length++;
284             m_multiOwnedPendingIndex[pending.index] = _operation;
285             assertOperationIsConsistent(_operation);
286         }
287 
288         // determine the bit to set for this owner.
289         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
290         // make sure we (the message sender) haven't confirmed this operation previously.
291         if (pending.ownersDone & ownerIndexBit == 0) {
292             // ok - check if count is enough to go ahead.
293             assert(pending.yetNeeded > 0);
294             if (pending.yetNeeded == 1) {
295                 // enough confirmations: reset and run interior.
296                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
297                 delete m_multiOwnedPending[_operation];
298                 FinalConfirmation(msg.sender, _operation);
299                 return true;
300             }
301             else
302             {
303                 // not enough: record that this owner in particular confirmed.
304                 pending.yetNeeded--;
305                 pending.ownersDone |= ownerIndexBit;
306                 assertOperationIsConsistent(_operation);
307                 Confirmation(msg.sender, _operation);
308             }
309         }
310     }
311 
312     // Reclaims free slots between valid owners in m_owners.
313     // TODO given that its called after each removal, it could be simplified.
314     function reorganizeOwners() private {
315         uint free = 1;
316         while (free < m_numOwners)
317         {
318             // iterating to the first free slot from the beginning
319             while (free < m_numOwners && m_owners[free] != 0) free++;
320 
321             // iterating to the first occupied slot from the end
322             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
323 
324             // swap, if possible, so free slot is located at the end after the swap
325             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
326             {
327                 // owners between swapped slots should't be renumbered - that saves a lot of gas
328                 m_owners[free] = m_owners[m_numOwners];
329                 m_ownerIndex[m_owners[free]] = free;
330                 m_owners[m_numOwners] = 0;
331             }
332         }
333     }
334 
335     function clearPending() private onlyowner {
336         uint length = m_multiOwnedPendingIndex.length;
337         for (uint i = 0; i < length; ++i) {
338             if (m_multiOwnedPendingIndex[i] != 0)
339                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
340         }
341         delete m_multiOwnedPendingIndex;
342     }
343 
344     function checkOwnerIndex(uint ownerIndex) private constant returns (uint) {
345         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
346         return ownerIndex;
347     }
348 
349     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
350         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
351         return 2 ** ownerIndex;
352     }
353 
354     function isOperationActive(bytes32 _operation) private constant returns (bool) {
355         return 0 != m_multiOwnedPending[_operation].yetNeeded;
356     }
357 
358 
359     function assertOwnersAreConsistent() private constant {
360         assert(m_numOwners > 0);
361         assert(m_numOwners <= c_maxOwners);
362         assert(m_owners[0] == 0);
363         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
364     }
365 
366     function assertOperationIsConsistent(bytes32 _operation) private constant {
367         var pending = m_multiOwnedPending[_operation];
368         assert(0 != pending.yetNeeded);
369         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
370         assert(pending.yetNeeded <= m_multiOwnedRequired);
371     }
372 
373 
374    	// FIELDS
375 
376     uint constant c_maxOwners = 250;
377 
378     // the number of owners that must confirm the same operation before it is run.
379     uint public m_multiOwnedRequired;
380 
381 
382     // pointer used to find a free slot in m_owners
383     uint public m_numOwners;
384 
385     // list of owners (addresses),
386     // slot 0 is unused so there are no owner which index is 0.
387     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
388     address[256] internal m_owners;
389 
390     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
391     mapping(address => uint) internal m_ownerIndex;
392 
393 
394     // the ongoing operations.
395     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
396     bytes32[] internal m_multiOwnedPendingIndex;
397 }
398 
399 
400 /**
401  * @title Basic demonstration of multi-owned entity.
402  */
403 contract SimpleMultiSigWallet is multiowned {
404 
405     event Deposit(address indexed sender, uint value);
406     event EtherSent(address indexed to, uint value);
407 
408     function SimpleMultiSigWallet(address[] _owners, uint _signaturesRequired)
409         multiowned(_owners, _signaturesRequired)
410     {
411     }
412 
413     /// @dev Fallback function allows to deposit ether.
414     function()
415         payable
416     {
417         if (msg.value > 0)
418             Deposit(msg.sender, msg.value);
419     }
420 
421     /// @notice Send `value` of ether to address `to`
422     /// @param to where to send ether
423     /// @param value amount of wei to send
424     function sendEther(address to, uint value)
425         external
426         onlymanyowners(sha3(msg.data))
427     {
428         require(0 != to);
429         require(value > 0 && this.balance >= value);
430         to.transfer(value);
431         EtherSent(to, value);
432     }
433 }