1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10     uint256 public totalSupply;
11     function balanceOf(address who) public view returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14      function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15 }
16 
17 
18 contract multiowned {
19 
20     // TYPES
21 
22     // struct for the status of a pending operation.
23     struct PendingState {
24         uint yetNeeded;
25         uint ownersDone;
26         uint index;
27     }
28 
29     // EVENTS
30 
31     // this contract only has five types of events: it can accept a confirmation, in which case
32     // we record owner and operation (hash) alongside it.
33     event Confirmation(address owner, bytes32 operation);
34     event Revoke(address owner, bytes32 operation);
35     // some others are in the case of an owner changing.
36     event OwnerChanged(address oldOwner, address newOwner);
37     event OwnerAdded(address newOwner);
38     event OwnerRemoved(address oldOwner);
39     // the last one is emitted if the required signatures change
40     event RequirementChanged(uint newRequirement);
41 
42     // MODIFIERS
43 
44     // simple single-sig function modifier.
45     modifier onlyowner {
46         if (isOwner(msg.sender))
47             _;
48     }
49     // multi-sig function modifier: the operation must have an intrinsic hash in order
50     // that later attempts can be realised as the same underlying operation and
51     // thus count as confirmations.
52     modifier onlymanyowners(bytes32 _operation) {
53         if (confirmAndCheck(_operation))
54             _;
55     }
56 
57     // METHODS
58 
59     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
60     // as well as the selection of addresses capable of confirming them.
61     constructor(address[] _owners, uint _required) public {
62         m_numOwners = _owners.length;// + 1;
63         //m_owners[1] = uint(msg.sender);
64         //m_ownerIndex[uint(msg.sender)] = 1;
65         for (uint i = 0; i < _owners.length; ++i)
66         {
67             m_owners[1 + i] = uint(_owners[i]);
68             m_ownerIndex[uint(_owners[i])] = 1 + i;
69         }
70         m_required = _required;
71     }
72     
73     // Revokes a prior confirmation of the given operation
74     function revoke(bytes32 _operation) external {
75         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
76         // make sure they're an owner
77         if (ownerIndex == 0) return;
78         uint ownerIndexBit = 2**ownerIndex;
79         PendingState storage pending = m_pending[_operation];
80         if (pending.ownersDone & ownerIndexBit > 0) {
81             pending.yetNeeded++;
82             pending.ownersDone -= ownerIndexBit;
83             emit Revoke(msg.sender, _operation);
84         }
85     }
86     
87     // Replaces an owner `_from` with another `_to`.
88     function changeOwner(address _from, address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
89         if (isOwner(_to)) return;
90         uint ownerIndex = m_ownerIndex[uint(_from)];
91         if (ownerIndex == 0) return;
92 
93         clearPending();
94         m_owners[ownerIndex] = uint(_to);
95         m_ownerIndex[uint(_from)] = 0;
96         m_ownerIndex[uint(_to)] = ownerIndex;
97         emit OwnerChanged(_from, _to);
98     }
99     
100     function addOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
101         if (isOwner(_owner)) return;
102 
103         clearPending();
104         if (m_numOwners >= c_maxOwners)
105             reorganizeOwners();
106         if (m_numOwners >= c_maxOwners)
107             return;
108         m_numOwners++;
109         m_owners[m_numOwners] = uint(_owner);
110         m_ownerIndex[uint(_owner)] = m_numOwners;
111         emit OwnerAdded(_owner);
112     }
113     
114     function removeOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
115         uint ownerIndex = m_ownerIndex[uint(_owner)];
116         if (ownerIndex == 0) return;
117         
118         if (m_required > m_numOwners - 1) return;
119 
120         m_owners[ownerIndex] = 0;
121         m_ownerIndex[uint(_owner)] = 0;
122         clearPending();
123         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
124         emit OwnerRemoved(_owner);
125     }
126     
127     function changeRequirement(uint _newRequired) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
128         if (_newRequired > m_numOwners) return;
129         m_required = _newRequired;
130         clearPending();
131         emit RequirementChanged(_newRequired);
132     }
133     
134     function isOwner(address _addr) public view returns (bool) {
135         return m_ownerIndex[uint(_addr)] > 0;
136     }
137     
138     function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
139         PendingState storage pending = m_pending[_operation];
140         uint ownerIndex = m_ownerIndex[uint(_owner)];
141 
142         // make sure they're an owner
143         if (ownerIndex == 0) return false;
144 
145         // determine the bit to set for this owner.
146         uint ownerIndexBit = 2**ownerIndex;
147         if (pending.ownersDone & ownerIndexBit == 0) {
148             return false;
149         } else {
150             return true;
151         }
152     }
153     
154     // INTERNAL METHODS
155 
156     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
157         // determine what index the present sender is:
158         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
159         // make sure they're an owner
160         if (ownerIndex == 0) return;
161 
162         PendingState storage pending = m_pending[_operation];
163         // if we're not yet working on this operation, switch over and reset the confirmation status.
164         if (pending.yetNeeded == 0) {
165             // reset count of confirmations needed.
166             pending.yetNeeded = m_required;
167             // reset which owners have confirmed (none) - set our bitmap to 0.
168             pending.ownersDone = 0;
169             pending.index = m_pendingIndex.length++;
170             m_pendingIndex[pending.index] = _operation;
171         }
172         // determine the bit to set for this owner.
173         uint ownerIndexBit = 2**ownerIndex;
174         // make sure we (the message sender) haven't confirmed this operation previously.
175         if (pending.ownersDone & ownerIndexBit == 0) {
176             emit Confirmation(msg.sender, _operation);
177             // ok - check if count is enough to go ahead.
178             if (pending.yetNeeded <= 1) {
179                 // enough confirmations: reset and run interior.
180                 delete m_pendingIndex[m_pending[_operation].index];
181                 delete m_pending[_operation];
182                 return true;
183             }
184             else
185             {
186                 // not enough: record that this owner in particular confirmed.
187                 pending.yetNeeded--;
188                 pending.ownersDone |= ownerIndexBit;
189             }
190         }
191     }
192 
193     function reorganizeOwners() private returns (bool) {
194         uint free = 1;
195         while (free < m_numOwners)
196         {
197             while (free < m_numOwners && m_owners[free] != 0) free++;
198             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
199             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
200             {
201                 m_owners[free] = m_owners[m_numOwners];
202                 m_ownerIndex[m_owners[free]] = free;
203                 m_owners[m_numOwners] = 0;
204             }
205         }
206     }
207     
208     function clearPending() internal {
209         uint length = m_pendingIndex.length;
210         for (uint i = 0; i < length; ++i) {
211             if (m_pendingIndex[i] != 0) {
212                 delete m_pending[m_pendingIndex[i]];
213             }
214         }
215             
216         delete m_pendingIndex;
217     }
218         
219     // FIELDS
220 
221     // the number of owners that must confirm the same operation before it is run.
222     uint public m_required;
223     // pointer used to find a free slot in m_owners
224     uint public m_numOwners;
225     
226     // list of owners
227     uint[256] m_owners;
228     uint constant c_maxOwners = 250;
229     // index on the list of owners to allow reverse lookup
230     mapping(uint => uint) m_ownerIndex;
231     // the ongoing operations.
232     mapping(bytes32 => PendingState) m_pending;
233     bytes32[] m_pendingIndex;
234 }
235 
236 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
237 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
238 // uses is specified in the modifier.
239 contract daylimit is multiowned {
240 
241     // MODIFIERS
242 
243     // simple modifier for daily limit.
244     modifier limitedDaily(uint _value) {
245         if (underLimit(_value))
246             _;
247     }
248 
249     // METHODS
250 
251     // constructor - stores initial daily limit and records the present day's index.
252     constructor(uint _limit) public {
253         m_dailyLimit = _limit;
254         m_lastDay = today();
255     }
256     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
257     function setDailyLimit(uint _newLimit) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
258         m_dailyLimit = _newLimit;
259     }
260     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
261     function resetSpentToday() onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
262         m_spentToday = 0;
263     }
264     
265     // INTERNAL METHODS
266     
267     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
268     // returns true. otherwise just returns false.
269     function underLimit(uint _value) internal onlyowner returns (bool) {
270         // reset the spend limit if we're on a different day to last time.
271         if (today() > m_lastDay) {
272             m_spentToday = 0;
273             m_lastDay = today();
274         }
275         // check to see if there's enough left - if so, subtract and return true.
276         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
277             m_spentToday += _value;
278             return true;
279         }
280         return false;
281     }
282     // determines today's index.
283     function today() private view returns (uint) { return block.timestamp / 1 days; }
284 
285     // FIELDS
286 
287     uint public m_dailyLimit;
288     uint public m_spentToday;
289     uint public m_lastDay;
290 }
291 
292 // interface contract for multisig proxy contracts; see below for docs.
293 contract multisig {
294 
295     // EVENTS
296 
297     // logged events:
298     // Funds has arrived into the wallet (record how much).
299     event Deposit(address from, uint value);
300     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
301     event SingleTransact(address owner, uint value, address to);
302     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
303     event MultiTransact(address owner, bytes32 operation, uint value, address to);
304     // Confirmation still needed for a transaction.
305     event ConfirmationERC20Needed(bytes32 operation, address initiator, uint value, address to, ERC20Basic token);
306 
307     
308     event ConfirmationETHNeeded(bytes32 operation, address initiator, uint value, address to);
309     
310     // FUNCTIONS
311     
312     // TODO: document
313     function changeOwner(address _from, address _to) external;
314     //function execute(address _to, uint _value, bytes _data) external returns (bytes32);
315     //function confirm(bytes32 _h) public returns (bool);
316 }
317 
318 // usage:
319 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
320 // Wallet(w).from(anotherOwner).confirm(h);
321 contract Wallet is multisig, multiowned, daylimit {
322 
323     uint public version = 4;
324 
325     // TYPES
326 
327     // Transaction structure to remember details of transaction lest it need be saved for a later call.
328     struct Transaction {
329         address to;
330         uint value;
331         address token;
332     }
333 
334     ERC20Basic public erc20;
335 
336     // METHODS
337 
338     // constructor - just pass on the owner array to the multiowned and
339     // the limit to daylimit
340     constructor(address[] _owners, uint _required, uint _daylimit, address _erc20)
341             multiowned(_owners, _required) daylimit(_daylimit) public {
342             erc20 = ERC20Basic(_erc20);
343     }
344 
345     function changeERC20(address _erc20) onlymanyowners(keccak256(abi.encodePacked(msg.data))) public {
346         erc20 = ERC20Basic(_erc20);
347     }
348     
349     // kills the contract sending everything to `_to`.
350     function kill(address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
351         selfdestruct(_to);
352     }
353     
354     // gets called when no other function matches
355     function() public payable {
356         // just being sent some cash?
357         if (msg.value > 0)
358             emit Deposit(msg.sender, msg.value);
359     }
360     
361     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
362     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
363     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
364     // and _data arguments). They still get the option of using them if they want, anyways.
365     function transferETH(address _to, uint _value) external onlyowner returns (bytes32 _r) {
366         // first, take the opportunity to check that we're under the daily limit.
367         if (underLimit(_value)) {
368             emit SingleTransact(msg.sender, _value, _to);
369             // yes - just execute the call.
370             _to.transfer(_value);
371             return 0;
372         }
373         // determine our operation hash.
374         _r = keccak256(abi.encodePacked(msg.data, block.number));
375         if (!confirmETH(_r) && m_txs[_r].to == 0) {
376             m_txs[_r].to = _to;
377             m_txs[_r].value = _value;
378             emit ConfirmationETHNeeded(_r, msg.sender, _value, _to);
379         }
380     }
381 
382     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
383     // to determine the body of the transaction from the hash provided.
384     function confirmETH(bytes32 _h) onlymanyowners(_h) public returns (bool) {
385         if (m_txs[_h].to != 0) {
386             m_txs[_h].to.transfer(m_txs[_h].value);
387             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
388             delete m_txs[_h];
389             return true;
390         }
391     }
392 
393     function transferERC20(address _to, uint _value) external onlyowner returns (bytes32 _r) {
394         // first, take the opportunity to check that we're under the daily limit.
395         if (underLimit(_value)) {
396             emit SingleTransact(msg.sender, _value, _to);
397             // yes - just execute the call.
398 
399             erc20.transfer(_to, _value);
400             return 0;
401         }
402         // determine our operation hash.
403         _r = keccak256(abi.encodePacked(msg.data, block.number));
404         if (!confirmERC20(_r, address(0)) && m_txs[_r].to == 0) {
405             m_txs[_r].to = _to;
406             m_txs[_r].value = _value;
407             m_txs[_r].token = erc20;
408             emit ConfirmationERC20Needed(_r, msg.sender, _value, _to, erc20);
409         }
410     }
411 
412     function confirmERC20(bytes32 _h, address from) onlymanyowners(_h) public returns (bool) {
413         if (m_txs[_h].to != 0) {
414             ERC20Basic token = ERC20Basic(m_txs[_h].token);
415             token.transferFrom(from, m_txs[_h].to, m_txs[_h].value);
416             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
417             delete m_txs[_h];
418             return true;
419         }
420     }
421     
422 
423     
424     // INTERNAL METHODS
425     
426     function clearPending() internal {
427         uint length = m_pendingIndex.length;
428         for (uint i = 0; i < length; ++i)
429             delete m_txs[m_pendingIndex[i]];
430         super.clearPending();
431     }
432 
433     // FIELDS
434 
435     // pending transactions we have at present.
436     mapping (bytes32 => Transaction) m_txs;
437 }