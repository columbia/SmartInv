1 pragma solidity ^0.4.18;
2 
3 contract ArgumentsChecker {
4 
5     /// @dev check which prevents short address attack
6     modifier payloadSizeIs(uint size) {
7        require(msg.data.length == size + 4 /* function selector */);
8        _;
9     }
10 
11     /// @dev check that address is valid
12     modifier validAddress(address addr) {
13         require(addr != address(0));
14         _;
15     }
16 }
17 
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
97         public
98         validNumOwners(_owners.length)
99         multiOwnedValidRequirement(_required, _owners.length)
100     {
101         assert(c_maxOwners <= 255);
102 
103         m_numOwners = _owners.length;
104         m_multiOwnedRequired = _required;
105 
106         for (uint i = 0; i < _owners.length; ++i)
107         {
108             address owner = _owners[i];
109             // invalid and duplicate addresses are not allowed
110             require(0 != owner && !isOwner(owner) /* not isOwner yet! */);
111 
112             uint currentOwnerIndex = checkOwnerIndex(i + 1 /* first slot is unused */);
113             m_owners[currentOwnerIndex] = owner;
114             m_ownerIndex[owner] = currentOwnerIndex;
115         }
116 
117         assertOwnersAreConsistent();
118     }
119 
120     /// @notice replaces an owner `_from` with another `_to`.
121     /// @param _from address of owner to replace
122     /// @param _to address of new owner
123     // All pending operations will be canceled!
124     function changeOwner(address _from, address _to)
125         external
126         ownerExists(_from)
127         ownerDoesNotExist(_to)
128         onlymanyowners(keccak256(msg.data))
129     {
130         assertOwnersAreConsistent();
131 
132         clearPending();
133         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_from]);
134         m_owners[ownerIndex] = _to;
135         m_ownerIndex[_from] = 0;
136         m_ownerIndex[_to] = ownerIndex;
137 
138         assertOwnersAreConsistent();
139         OwnerChanged(_from, _to);
140     }
141 
142     /// @notice adds an owner
143     /// @param _owner address of new owner
144     // All pending operations will be canceled!
145     function addOwner(address _owner)
146         external
147         ownerDoesNotExist(_owner)
148         validNumOwners(m_numOwners + 1)
149         onlymanyowners(keccak256(msg.data))
150     {
151         assertOwnersAreConsistent();
152 
153         clearPending();
154         m_numOwners++;
155         m_owners[m_numOwners] = _owner;
156         m_ownerIndex[_owner] = checkOwnerIndex(m_numOwners);
157 
158         assertOwnersAreConsistent();
159         OwnerAdded(_owner);
160     }
161 
162     /// @notice removes an owner
163     /// @param _owner address of owner to remove
164     // All pending operations will be canceled!
165     function removeOwner(address _owner)
166         external
167         ownerExists(_owner)
168         validNumOwners(m_numOwners - 1)
169         multiOwnedValidRequirement(m_multiOwnedRequired, m_numOwners - 1)
170         onlymanyowners(keccak256(msg.data))
171     {
172         assertOwnersAreConsistent();
173 
174         clearPending();
175         uint ownerIndex = checkOwnerIndex(m_ownerIndex[_owner]);
176         m_owners[ownerIndex] = 0;
177         m_ownerIndex[_owner] = 0;
178         //make sure m_numOwners is equal to the number of owners and always points to the last owner
179         reorganizeOwners();
180 
181         assertOwnersAreConsistent();
182         OwnerRemoved(_owner);
183     }
184 
185     /// @notice changes the required number of owner signatures
186     /// @param _newRequired new number of signatures required
187     // All pending operations will be canceled!
188     function changeRequirement(uint _newRequired)
189         external
190         multiOwnedValidRequirement(_newRequired, m_numOwners)
191         onlymanyowners(keccak256(msg.data))
192     {
193         m_multiOwnedRequired = _newRequired;
194         clearPending();
195         RequirementChanged(_newRequired);
196     }
197 
198     /// @notice Gets an owner by 0-indexed position
199     /// @param ownerIndex 0-indexed owner position
200     function getOwner(uint ownerIndex) public constant returns (address) {
201         return m_owners[ownerIndex + 1];
202     }
203 
204     /// @notice Gets owners
205     /// @return memory array of owners
206     function getOwners() public constant returns (address[]) {
207         address[] memory result = new address[](m_numOwners);
208         for (uint i = 0; i < m_numOwners; i++)
209             result[i] = getOwner(i);
210 
211         return result;
212     }
213 
214     /// @notice checks if provided address is an owner address
215     /// @param _addr address to check
216     /// @return true if it's an owner
217     function isOwner(address _addr) public constant returns (bool) {
218         return m_ownerIndex[_addr] > 0;
219     }
220 
221     /// @notice Tests ownership of the current caller.
222     /// @return true if it's an owner
223     // It's advisable to call it by new owner to make sure that the same erroneous address is not copy-pasted to
224     // addOwner/changeOwner and to isOwner.
225     function amIOwner() external constant onlyowner returns (bool) {
226         return true;
227     }
228 
229     /// @notice Revokes a prior confirmation of the given operation
230     /// @param _operation operation value, typically keccak256(msg.data)
231     function revoke(bytes32 _operation)
232         external
233         multiOwnedOperationIsActive(_operation)
234         onlyowner
235     {
236         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
237         var pending = m_multiOwnedPending[_operation];
238         require(pending.ownersDone & ownerIndexBit > 0);
239 
240         assertOperationIsConsistent(_operation);
241 
242         pending.yetNeeded++;
243         pending.ownersDone -= ownerIndexBit;
244 
245         assertOperationIsConsistent(_operation);
246         Revoke(msg.sender, _operation);
247     }
248 
249     /// @notice Checks if owner confirmed given operation
250     /// @param _operation operation value, typically keccak256(msg.data)
251     /// @param _owner an owner address
252     function hasConfirmed(bytes32 _operation, address _owner)
253         external
254         constant
255         multiOwnedOperationIsActive(_operation)
256         ownerExists(_owner)
257         returns (bool)
258     {
259         return !(m_multiOwnedPending[_operation].ownersDone & makeOwnerBitmapBit(_owner) == 0);
260     }
261 
262     // INTERNAL METHODS
263 
264     function confirmAndCheck(bytes32 _operation)
265         private
266         onlyowner
267         returns (bool)
268     {
269         if (512 == m_multiOwnedPendingIndex.length)
270             // In case m_multiOwnedPendingIndex grows too much we have to shrink it: otherwise at some point
271             // we won't be able to do it because of block gas limit.
272             // Yes, pending confirmations will be lost. Dont see any security or stability implications.
273             // TODO use more graceful approach like compact or removal of clearPending completely
274             clearPending();
275 
276         var pending = m_multiOwnedPending[_operation];
277 
278         // if we're not yet working on this operation, switch over and reset the confirmation status.
279         if (! isOperationActive(_operation)) {
280             // reset count of confirmations needed.
281             pending.yetNeeded = m_multiOwnedRequired;
282             // reset which owners have confirmed (none) - set our bitmap to 0.
283             pending.ownersDone = 0;
284             pending.index = m_multiOwnedPendingIndex.length++;
285             m_multiOwnedPendingIndex[pending.index] = _operation;
286             assertOperationIsConsistent(_operation);
287         }
288 
289         // determine the bit to set for this owner.
290         uint ownerIndexBit = makeOwnerBitmapBit(msg.sender);
291         // make sure we (the message sender) haven't confirmed this operation previously.
292         if (pending.ownersDone & ownerIndexBit == 0) {
293             // ok - check if count is enough to go ahead.
294             assert(pending.yetNeeded > 0);
295             if (pending.yetNeeded == 1) {
296                 // enough confirmations: reset and run interior.
297                 delete m_multiOwnedPendingIndex[m_multiOwnedPending[_operation].index];
298                 delete m_multiOwnedPending[_operation];
299                 FinalConfirmation(msg.sender, _operation);
300                 return true;
301             }
302             else
303             {
304                 // not enough: record that this owner in particular confirmed.
305                 pending.yetNeeded--;
306                 pending.ownersDone |= ownerIndexBit;
307                 assertOperationIsConsistent(_operation);
308                 Confirmation(msg.sender, _operation);
309             }
310         }
311     }
312 
313     // Reclaims free slots between valid owners in m_owners.
314     // TODO given that its called after each removal, it could be simplified.
315     function reorganizeOwners() private {
316         uint free = 1;
317         while (free < m_numOwners)
318         {
319             // iterating to the first free slot from the beginning
320             while (free < m_numOwners && m_owners[free] != 0) free++;
321 
322             // iterating to the first occupied slot from the end
323             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
324 
325             // swap, if possible, so free slot is located at the end after the swap
326             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
327             {
328                 // owners between swapped slots should't be renumbered - that saves a lot of gas
329                 m_owners[free] = m_owners[m_numOwners];
330                 m_ownerIndex[m_owners[free]] = free;
331                 m_owners[m_numOwners] = 0;
332             }
333         }
334     }
335 
336     function clearPending() private onlyowner {
337         uint length = m_multiOwnedPendingIndex.length;
338         // TODO block gas limit
339         for (uint i = 0; i < length; ++i) {
340             if (m_multiOwnedPendingIndex[i] != 0)
341                 delete m_multiOwnedPending[m_multiOwnedPendingIndex[i]];
342         }
343         delete m_multiOwnedPendingIndex;
344     }
345 
346     function checkOwnerIndex(uint ownerIndex) private pure returns (uint) {
347         assert(0 != ownerIndex && ownerIndex <= c_maxOwners);
348         return ownerIndex;
349     }
350 
351     function makeOwnerBitmapBit(address owner) private constant returns (uint) {
352         uint ownerIndex = checkOwnerIndex(m_ownerIndex[owner]);
353         return 2 ** ownerIndex;
354     }
355 
356     function isOperationActive(bytes32 _operation) private constant returns (bool) {
357         return 0 != m_multiOwnedPending[_operation].yetNeeded;
358     }
359 
360 
361     function assertOwnersAreConsistent() private constant {
362         assert(m_numOwners > 0);
363         assert(m_numOwners <= c_maxOwners);
364         assert(m_owners[0] == 0);
365         assert(0 != m_multiOwnedRequired && m_multiOwnedRequired <= m_numOwners);
366     }
367 
368     function assertOperationIsConsistent(bytes32 _operation) private constant {
369         var pending = m_multiOwnedPending[_operation];
370         assert(0 != pending.yetNeeded);
371         assert(m_multiOwnedPendingIndex[pending.index] == _operation);
372         assert(pending.yetNeeded <= m_multiOwnedRequired);
373     }
374 
375 
376    	// FIELDS
377 
378     uint constant c_maxOwners = 250;
379 
380     // the number of owners that must confirm the same operation before it is run.
381     uint public m_multiOwnedRequired;
382 
383 
384     // pointer used to find a free slot in m_owners
385     uint public m_numOwners;
386 
387     // list of owners (addresses),
388     // slot 0 is unused so there are no owner which index is 0.
389     // TODO could we save space at the end of the array for the common case of <10 owners? and should we?
390     address[256] internal m_owners;
391 
392     // index on the list of owners to allow reverse lookup: owner address => index in m_owners
393     mapping(address => uint) internal m_ownerIndex;
394 
395 
396     // the ongoing operations.
397     mapping(bytes32 => MultiOwnedOperationPendingState) internal m_multiOwnedPending;
398     bytes32[] internal m_multiOwnedPendingIndex;
399 }
400 
401 contract ERC20Basic {
402   uint256 public totalSupply;
403   function balanceOf(address who) public view returns (uint256);
404   function transfer(address to, uint256 value) public returns (bool);
405   event Transfer(address indexed from, address indexed to, uint256 value);
406 }
407 
408 contract ERC20 is ERC20Basic {
409   function allowance(address owner, address spender) public view returns (uint256);
410   function transferFrom(address from, address to, uint256 value) public returns (bool);
411   function approve(address spender, uint256 value) public returns (bool);
412   event Approval(address indexed owner, address indexed spender, uint256 value);
413 }
414 
415 interface ISmartzToken {
416     // multiowned
417     function changeOwner(address _from, address _to) external;
418     function addOwner(address _owner) external;
419     function removeOwner(address _owner) external;
420     function changeRequirement(uint _newRequired) external;
421     function getOwner(uint ownerIndex) public view returns (address);
422     function getOwners() public view returns (address[]);
423     function isOwner(address _addr) public view returns (bool);
424     function amIOwner() external view returns (bool);
425     function revoke(bytes32 _operation) external;
426     function hasConfirmed(bytes32 _operation, address _owner) external view returns (bool);
427 
428     // ERC20Basic
429     function totalSupply() public view returns (uint256);
430     function balanceOf(address who) public view returns (uint256);
431     function transfer(address to, uint256 value) public returns (bool);
432 
433     // ERC20
434     function allowance(address owner, address spender) public view returns (uint256);
435     function transferFrom(address from, address to, uint256 value) public returns (bool);
436     function approve(address spender, uint256 value) public returns (bool);
437 
438     function name() public view returns (string);
439     function symbol() public view returns (string);
440     function decimals() public view returns (uint8);
441 
442     // BurnableToken
443     function burn(uint256 _amount) public returns (bool);
444 
445     // TokenWithApproveAndCallMethod
446     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public;
447 
448     // SmartzToken
449     function setKYCProvider(address KYCProvider) external;
450     function setSale(address account, bool isSale) external;
451     function disablePrivileged() external;
452 
453     function availableBalanceOf(address _owner) public view returns (uint256);
454     function frozenCellCount(address owner) public view returns (uint);
455     function frozenCell(address owner, uint index) public view returns (uint amount, uint thawTS, bool isKYCRequired);
456 
457     function frozenTransfer(address _to, uint256 _value, uint thawTS, bool isKYCRequired) external returns (bool);
458     function frozenTransferFrom(address _from, address _to, uint256 _value, uint thawTS, bool isKYCRequired) external returns (bool);
459 }
460 
461 contract SMRDistributionVault is ArgumentsChecker, multiowned, ERC20 {
462 
463 
464     // PUBLIC FUNCTIONS
465 
466     function SMRDistributionVault()
467         public
468         payable
469         multiowned(getInitialOwners(), 1)
470     {
471         m_SMR = ISmartzToken(address(0x40ae4acd08e65714b093bf2495fd7941aedfa231));
472         m_thawTS = 1551398400;
473 
474         totalSupply = m_SMR.totalSupply();
475 
476         
477     }
478 
479     function getInitialOwners() private pure returns (address[]) {
480         address[] memory result = new address[](2);
481 result[0] = address(0x4ff9a68a832398c6b013633bb5682595ebb7b92e);
482 result[1] = address(0xe4074bb7bd4828baed9d2bece1e386408428dfb7);
483         return result;
484     }
485 
486 
487     /// @notice Balance of tokens.
488     /// @dev Owners are considered to possess all the tokens of this vault.
489     function balanceOf(address who) public view returns (uint256) {
490         return isOwner(who) ? m_SMR.balanceOf(this) : 0;
491     }
492 
493     /// @notice Looks like transfer of this token, but actually frozenTransfers SMR.
494     function transfer(address to, uint256 value)
495         public
496         payloadSizeIs(2 * 32)
497         onlyowner
498         returns (bool)
499     {
500         return m_SMR.frozenTransfer(to, value, m_thawTS, false);
501     }
502 
503     /// @notice Transfers using plain transfer remaining tokens.
504     function withdrawRemaining(address to)
505         external
506         payloadSizeIs(1 * 32)
507         onlyowner
508         returns (bool)
509     {
510         return m_SMR.transfer(to, m_SMR.balanceOf(this));
511     }
512 
513 
514     /// @dev There is no need to support this function.
515     function allowance(address , address ) public view returns (uint256) {
516         revert();
517     }
518 
519     /// @dev There is no need to support this function.
520     function transferFrom(address , address , uint256 ) public returns (bool) {
521         revert();
522     }
523 
524     /// @dev There is no need to support this function.
525     function approve(address , uint256 ) public returns (bool) {
526         revert();
527     }
528 
529     function decimals() public view returns (uint8) {
530         return m_SMR.decimals();
531     }
532 
533 
534     // FIELDS
535 
536     /// @notice link to the SMR
537     ISmartzToken public m_SMR;
538 
539     /// @notice Thaw timestamp of frozenTransfers issued by this vault
540     uint public m_thawTS;
541 
542 
543     // CONSTANTS
544 
545     string public constant name = "SMR Community Fund Vault 1";
546     string public constant symbol = "SMRDV";
547 }