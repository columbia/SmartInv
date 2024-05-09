1 // Copyright (C) 2017  MixBytes, LLC
2 
3 // Licensed under the Apache License, Version 2.0 (the "License").
4 // You may not use this file except in compliance with the License.
5 
6 // Unless required by applicable law or agreed to in writing, software
7 // distributed under the License is distributed on an "AS IS" BASIS,
8 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
9 
10 // Code taken from https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
11 // Audit, refactoring and improvements by github.com/Eenae
12 
13 // @authors:
14 // Gav Wood <g@ethdev.com>
15 // inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a
16 // single, or, crucially, each of a number of, designated owners.
17 // usage:
18 // use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by
19 // some number (specified in constructor) of the set of owners (specified in the constructor, modifiable) before the
20 // interior is executed.
21 
22 pragma solidity ^0.4.15;
23 
24 
25 /// note: during any ownership changes all pending operations (waiting for more signatures) are cancelled
26 // TODO acceptOwnership
27 contract multiowned {
28 
29 	// TYPES
30 
31     // struct for the status of a pending operation.
32     struct MultiOwnedOperationPendingState {
33         // count of confirmations needed
34         uint yetNeeded;
35 
36         // bitmap of confirmations where owner #ownerIndex's decision corresponds to 2**ownerIndex bit
37         uint ownersDone;
38 
39         // position of this operation key in m_multiOwnedPendingIndex
40         uint index;
41     }
42 
43 	// EVENTS
44 
45     event Confirmation(address owner, bytes32 operation);
46     event Revoke(address owner, bytes32 operation);
47     event FinalConfirmation(address owner, bytes32 operation);
48 
49     // some others are in the case of an owner changing.
50     event OwnerChanged(address oldOwner, address newOwner);
51     event OwnerAdded(address newOwner);
52     event OwnerRemoved(address oldOwner);
53 
54     // the last one is emitted if the required signatures change
55     event RequirementChanged(uint newRequirement);
56 
57 	// MODIFIERS
58 
59     // simple single-sig function modifier.
60     modifier onlyowner {
61         require(isOwner(msg.sender));
62         _;
63     }
64     // multi-sig function modifier: the operation must have an intrinsic hash in order
65     // that later attempts can be realised as the same underlying operation and
66     // thus count as confirmations.
67     modifier onlymanyowners(bytes32 _operation) {
68         if (confirmAndCheck(_operation)) {
69             _;
70         }
71         // Even if required number of confirmations has't been collected yet,
72         // we can't throw here - because changes to the state have to be preserved.
73         // But, confirmAndCheck itself will throw in case sender is not an owner.
74     }
75 
76     modifier validNumOwners(uint _numOwners) {
77         require(_numOwners > 0 && _numOwners <= c_maxOwners);
78         _;
79     }
80 
81     modifier multiOwnedValidRequirement(uint _required, uint _numOwners) {
82         require(_required > 0 && _required <= _numOwners);
83         _;
84     }
85 
86     modifier ownerExists(address _address) {
87         require(isOwner(_address));
88         _;
89     }
90 
91     modifier ownerDoesNotExist(address _address) {
92         require(!isOwner(_address));
93         _;
94     }
95 
96     modifier multiOwnedOperationIsActive(bytes32 _operation) {
97         require(isOperationActive(_operation));
98         _;
99     }
100 
101 	// METHODS
102 
103     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
104     // as well as the selection of addresses capable of confirming them (msg.sender is not added to the owners!).
105     address[] _owners;
106     function multiowned() public
107     {
108         uint _required = 2;
109 
110         _owners.push(address(0xdA8f27f49bd46B7a16FEfbC504e79F16b7113200));
111 _owners.push(address(0x338bf5A8Bb77c3fF6E112cb1287B87f92D154b36));
112 _owners.push(address(0x5A68063ea1980D80Cb89eB89161a2240Df592133));
113 
114         require(_owners.length > 0 && _owners.length <= c_maxOwners);
115         require(_required > 0 && _required <= _owners.length);
116 
117         assert(c_maxOwners <= 255);
118 
119         m_numOwners = _owners.length;
120         m_multiOwnedRequired = _required;
121 
122         for (uint i = 0; i < _owners.length; ++i)
123         {
124             address owner = _owners[i];
125             // invalid and duplicate addresses are not allowed
126             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
127 
128             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
129             m_owners[currentOwnerIndex] = owner;
130             m_ownerIndex[owner] = currentOwnerIndex;
131         }
132 
133         assertOwnersAreConsistent();
134     }
135 
136     /// @notice replaces an owner `_from` with another `_to`.
137     /// @param _from address of owner to replace
138     /// @param _to address of new owner
139     // All pending operations will be canceled!
140     function changeOwner(address _from, address _to)
141         external
142         ownerExists(_from)
143         ownerDoesNotExist(_to)
144         onlymanyowners(keccak256(msg.data))
145     {
146         assertOwnersAreConsistent();
147 
148         clearPending();
149         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
150         m_owners[ownerIndex] = _to;
151         m_ownerIndex[_from] = 0;
152         m_ownerIndex[_to] = ownerIndex;
153 
154         assertOwnersAreConsistent();
155         OwnerChanged(_from, _to);
156     }
157 
158     /// @notice adds an owner
159     /// @param _owner address of new owner
160     // All pending operations will be canceled!
161     function addOwner(address _owner)
162         external
163         ownerDoesNotExist(_owner)
164         validNumOwners(m_numOwners + 1)
165         onlymanyowners(keccak256(msg.data))
166     {
167         assertOwnersAreConsistent();
168 
169         clearPending();
170         m_numOwners++;
171         m_owners[m_numOwners] = _owner;
172         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
173 
174         assertOwnersAreConsistent();
175         OwnerAdded(_owner);
176     }
177 
178     /// @notice removes an owner
179     /// @param _owner address of owner to remove
180     // All pending operations will be canceled!
181     function removeOwner(address _owner)
182         external
183         ownerExists(_owner)
184         validNumOwners(m_numOwners - 1)
185         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
186         onlymanyowners(keccak256(msg.data))
187     {
188         assertOwnersAreConsistent();
189 
190         clearPending();
191         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
192         m_owners[ownerIndex] = 0;
193         m_ownerIndex[_owner] = 0;
194         //make sure m_numOwners is equal to the number of owners and always points to the last owner
195         reorganizeOwners();
196 
197         assertOwnersAreConsistent();
198         OwnerRemoved(_owner);
199     }
200 
201     /// @notice changes the required number of owner signatures
202     /// @param _newRequired new number of signatures required
203     // All pending operations will be canceled!
204     function changeRequirement(uint _newRequired)
205         external
206         multiOwnedValidRequirement(_newRequired, m_numOwners)
207         onlymanyowners(keccak256(msg.data))
208     {
209         m_multiOwnedRequired = _newRequired;
210         clearPending();
211         RequirementChanged(_newRequired);
212     }
213 
214     /// @notice Gets an owner by 0-indexed position
215     /// @param ownerIndex 0-indexed owner position
216     function getOwner(uint ownerIndex) public constant returns (address) {
217         return m_owners[ownerIndex + 1];
218     }
219 
220     /// @notice Gets owners
221     /// @return memory array of owners
222     function getOwners() public constant returns (address[]) {
223         address[] memory result = new address[](m_numOwners);
224         for (uint i = 0; i < m_numOwners; i++)
225             result[i] = getOwner(i);
226 
227         return result;
228     }
229 
230     /// @notice checks if provided address is an owner address
231     /// @param _addr address to check
232     /// @return true if it's an owner
233     function isOwner(address _addr) public constant returns (bool) {
234         return m_ownerIndex[_addr] > 0;
235     }
236 
237     /// @notice Tests ownership of the current caller.
238     /// @return true if it's an owner
239     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
240     // addOwner/changeOwner and to isOwner.
241     function amIOwner() external constant onlyowner returns (bool) {
242         return true;
243     }
244 
245     /// @notice Revokes a prior confirmation of the given operation
246     /// @param _operation operation value, typically keccak256(msg.data)
247     function revoke(bytes32 _operation)
248         external
249         multiOwnedOperationIsActive(_operation)
250         onlyowner
251     {
252         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
253         var pending = m_multiOwnedPending[_operation];
254         require(pending.ownersDone & ownerIndexBit > 0);
255 
256         assertOperationIsConsistent(_operation);
257 
258         pending.yetNeeded++;
259         pending.ownersDone -= ownerIndexBit;
260 
261         assertOperationIsConsistent(_operation);
262         Revoke(msg.sender, _operation);
263     }
264 
265     /// @notice Checks if owner confirmed given operation
266     /// @param _operation operation value, typically keccak256(msg.data)
267     /// @param _owner an owner address
268     function hasConfirmed(bytes32 _operation, address _owner)
269         external
270         constant
271         multiOwnedOperationIsActive(_operation)
272         ownerExists(_owner)
273         returns (bool)
274     {
275         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
276     }
277 
278     // INTERNAL METHODS
279 
280     function confirmAndCheck(bytes32 _operation)
281         private
282         onlyowner
283         returns (bool)
284     {
285         if (512 == m_multiOwnedPendingIndex.length)
286             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
287             // we won't be able to do it because of block gas limit.
288             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
289             // TODO use more graceful approach like compact or removal of clearPending completely
290             clearPending();
291 
292         var pending = m_multiOwnedPending[_operation];
293 
294         // if we're not yet working on this operation, switch over and reset the confirmation status.
295         if (! isOperationActive(_operation)) {
296             // reset count of confirmations needed.
297             pending.yetNeeded = m_multiOwnedRequired;
298             // reset which owners have confirmed (none) - set our bitmap to 0.
299             pending.ownersDone = 0;
300             pending.index = m_multiOwnedPendingIndex.length++;
301             m_multiOwnedPendingIndex[pending.index] = _operation;
302             assertOperationIsConsistent(_operation);
303         }
304 
305         // determine the bit to set for this owner.
306         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
307         // make sure we (the message sender) haven't confirmed this operation previously.
308         if (pending.ownersDone & ownerIndexBit == 0) {
309             // ok - check if count is enough to go ahead.
310             assert(pending.yetNeeded > 0);
311             if (pending.yetNeeded == 1) {
312                 // enough confirmations: reset and run interior.
313                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
314                 delete m_multiOwnedPending[_operation];
315                 FinalConfirmation(msg.sender, _operation);
316                 return true;
317             }
318             else
319             {
320                 // not enough: record that this owner in particular confirmed.
321                 pending.yetNeeded--;
322                 pending.ownersDone |= ownerIndexBit;
323                 assertOperationIsConsistent(_operation);
324                 Confirmation(msg.sender, _operation);
325             }
326         }
327     }
328 
329     // Reclaims free slots between valid owners in m_owners.
330     // TODO given that its called after each removal, it could be simplified.
331     function reorganizeOwners() private {
332         uint free = 1;
333         while (free < m_numOwners)
334         {
335             // iterating to the first free slot from the beginning
336             while (free < m_numOwners && m_owners[free] != 0) free++;
337 
338             // iterating to the first occupied slot from the end
339             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
340 
341             // swap, if possible, so free slot is located at the end after the swap
342             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
343             {
344                 // owners between swapped slots should't be renumbered - that saves a lot of gas
345                 m_owners[free] = m_owners[m_numOwners];
346                 m_ownerIndex[m_owners[free]] = free;
347                 m_owners[m_numOwners] = 0;
348             }
349         }
350     }
351 
352     function clearPending() private onlyowner {
353         uint length = m_multiOwnedPendingIndex.length;
354         // TODO block gas limit
355         for (uint i = 0; i < length; ++i) {
356             if (m_multiOwnedPendingIndex[i] != 0)
357                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
358         }
359         delete m_multiOwnedPendingIndex;
360     }
361 
362     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
363         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
364         return ownerIndex;
365     }
366 
367     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
368         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
369         return 2 ** ownerIndex;
370     }
371 
372     function isOperationActive(bytes32 _operation) private constant returns (bool) {
373         return 0 != m_multiOwnedPending[_operation].yetNeeded;
374     }
375 
376 
377     function assertOwnersAreConsistent() private constant {
378         assert(m_numOwners > 0);
379         assert(m_numOwners <= c_maxOwners);
380         assert(m_owners[0] == 0);
381         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
382     }
383 
384     function assertOperationIsConsistent(bytes32 _operation) private constant {
385         var pending = m_multiOwnedPending[_operation];
386         assert(0 != pending.yetNeeded);
387         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
388         assert(pending.yetNeeded <= m_multiOwnedRequired);
389     }
390 
391 
392    	// FIELDS
393 
394     uint constant c_maxOwners = 250;
395 
396     // the number of owners that must confirm the same operation before it is run.
397     uint public m_multiOwnedRequired;
398 
399 
400     // pointer used to find a free slot in m_owners
401     uint public m_numOwners;
402 
403     // list of owners (addresses),
404     // slot 0 is unused so there are no owner which index is 0.
405     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
406     address[256] internal m_owners;
407 
408     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
409     mapping(address => uint) internal m_ownerIndex;
410 
411 
412     // the ongoing operations.
413     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
414     bytes32[] internal m_multiOwnedPendingIndex;
415 }
416 
417 /**
418  * @title ERC20Basic
419  * @dev Simpler version of ERC20 interface
420  * @dev see https://github.com/ethereum/EIPs/issues/179
421  */
422 contract ERC20Basic {
423   function totalSupply() public view returns (uint256);
424   function balanceOf(address who) public view returns (uint256);
425   function transfer(address to, uint256 value) public returns (bool);
426   event Transfer(address indexed from, address indexed to, uint256 value);
427 }
428 
429 /**
430  * @title Basic demonstration of multi-owned entity.
431  */
432 contract SimpleMultiSigWallet is multiowned {
433 
434     event Deposit(address indexed sender, uint value);
435     event EtherSent(address indexed to, uint value);
436     event TokensSent(address token, address indexed to, uint value);
437 
438     function SimpleMultiSigWallet()
439         multiowned()
440         public
441         payable
442     {
443         
444     }
445 
446     /// @dev Fallback function allows to deposit ether.
447     function()
448         payable
449         public
450     {
451         if (msg.value > 0)
452             Deposit(msg.sender, msg.value);
453     }
454 
455     /// @notice Send `value` of ether to address `to`
456     /// @param to where to send ether
457     /// @param value amount of wei to send
458     function sendEther(address to, uint value)
459         external
460         onlymanyowners(keccak256(msg.data))
461     {
462         require(address(0) != to);
463         require(value > 0 && this.balance >= value);
464         to.transfer(value);
465         EtherSent(to, value);
466     }
467     
468     function sendTokens(address token, address to, uint value)
469         external
470         onlymanyowners(keccak256(msg.data))
471         returns (bool)
472     {
473         require(address(0) != to);
474         
475         if (ERC20Basic(token).transfer(to, value)) {
476             TokensSent(token, to, value);
477             return true;
478         }
479         
480         return false;
481     }
482     
483     function tokenBalance(address token) external view returns (uint256) {
484         return ERC20Basic(token).balanceOf(this);
485     }
486 }