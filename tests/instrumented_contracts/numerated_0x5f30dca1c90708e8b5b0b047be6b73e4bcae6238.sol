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
14 }
15 
16 
17 contract multiowned {
18 
19     // TYPES
20 
21     // struct for the status of a pending operation.
22     struct PendingState {
23         uint yetNeeded;
24         uint ownersDone;
25         uint index;
26     }
27 
28     // EVENTS
29 
30     // this contract only has five types of events: it can accept a confirmation, in which case
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
41     // MODIFIERS
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
56     // METHODS
57 
58     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
59     // as well as the selection of addresses capable of confirming them.
60     constructor(address[] _owners, uint _required) public {
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
78         PendingState storage pending = m_pending[_operation];
79         if (pending.ownersDone & ownerIndexBit > 0) {
80             pending.yetNeeded++;
81             pending.ownersDone -= ownerIndexBit;
82             emit Revoke(msg.sender, _operation);
83         }
84     }
85     
86     // Replaces an owner `_from` with another `_to`.
87     function changeOwner(address _from, address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
88         if (isOwner(_to)) return;
89         uint ownerIndex = m_ownerIndex[uint(_from)];
90         if (ownerIndex == 0) return;
91 
92         clearPending();
93         m_owners[ownerIndex] = uint(_to);
94         m_ownerIndex[uint(_from)] = 0;
95         m_ownerIndex[uint(_to)] = ownerIndex;
96         emit OwnerChanged(_from, _to);
97     }
98     
99     function addOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
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
110         emit OwnerAdded(_owner);
111     }
112     
113     function removeOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
114         uint ownerIndex = m_ownerIndex[uint(_owner)];
115         if (ownerIndex == 0) return;
116         if (m_required > m_numOwners - 1) return;
117 
118         m_owners[ownerIndex] = 0;
119         m_ownerIndex[uint(_owner)] = 0;
120         clearPending();
121         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
122         emit OwnerRemoved(_owner);
123     }
124     
125     function changeRequirement(uint _newRequired) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
126         if (_newRequired > m_numOwners) return;
127         m_required = _newRequired;
128         clearPending();
129         emit RequirementChanged(_newRequired);
130     }
131     
132     function isOwner(address _addr) public view returns (bool) {
133         return m_ownerIndex[uint(_addr)] > 0;
134     }
135     
136     function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
137         PendingState storage pending = m_pending[_operation];
138         uint ownerIndex = m_ownerIndex[uint(_owner)];
139 
140         // make sure they're an owner
141         if (ownerIndex == 0) return false;
142 
143         // determine the bit to set for this owner.
144         uint ownerIndexBit = 2**ownerIndex;
145         if (pending.ownersDone & ownerIndexBit == 0) {
146             return false;
147         } else {
148             return true;
149         }
150     }
151     
152     // INTERNAL METHODS
153 
154     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
155         // determine what index the present sender is:
156         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
157         // make sure they're an owner
158         if (ownerIndex == 0) return;
159 
160         PendingState storage pending = m_pending[_operation];
161         // if we're not yet working on this operation, switch over and reset the confirmation status.
162         if (pending.yetNeeded == 0) {
163             // reset count of confirmations needed.
164             pending.yetNeeded = m_required;
165             // reset which owners have confirmed (none) - set our bitmap to 0.
166             pending.ownersDone = 0;
167             pending.index = m_pendingIndex.length++;
168             m_pendingIndex[pending.index] = _operation;
169         }
170         // determine the bit to set for this owner.
171         uint ownerIndexBit = 2**ownerIndex;
172         // make sure we (the message sender) haven't confirmed this operation previously.
173         if (pending.ownersDone & ownerIndexBit == 0) {
174             emit Confirmation(msg.sender, _operation);
175             // ok - check if count is enough to go ahead.
176             if (pending.yetNeeded <= 1) {
177                 // enough confirmations: reset and run interior.
178                 delete m_pendingIndex[m_pending[_operation].index];
179                 delete m_pending[_operation];
180                 return true;
181             }
182             else
183             {
184                 // not enough: record that this owner in particular confirmed.
185                 pending.yetNeeded--;
186                 pending.ownersDone |= ownerIndexBit;
187             }
188         }
189     }
190 
191     function reorganizeOwners() private returns (bool) {
192         uint free = 1;
193         while (free < m_numOwners)
194         {
195             while (free < m_numOwners && m_owners[free] != 0) free++;
196             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) m_numOwners--;
197             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0)
198             {
199                 m_owners[free] = m_owners[m_numOwners];
200                 m_ownerIndex[m_owners[free]] = free;
201                 m_owners[m_numOwners] = 0;
202             }
203         }
204     }
205     
206     function clearPending() internal {
207         uint length = m_pendingIndex.length;
208         for (uint i = 0; i < length; ++i) {
209             if (m_pendingIndex[i] != 0) {
210                 delete m_pending[m_pendingIndex[i]];
211             }
212         }
213             
214         delete m_pendingIndex;
215     }
216         
217     // FIELDS
218 
219     // the number of owners that must confirm the same operation before it is run.
220     uint public m_required;
221     // pointer used to find a free slot in m_owners
222     uint public m_numOwners;
223     
224     // list of owners
225     uint[256] m_owners;
226     uint constant c_maxOwners = 250;
227     // index on the list of owners to allow reverse lookup
228     mapping(uint => uint) m_ownerIndex;
229     // the ongoing operations.
230     mapping(bytes32 => PendingState) m_pending;
231     bytes32[] m_pendingIndex;
232 }
233 
234 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
235 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
236 // uses is specified in the modifier.
237 contract daylimit is multiowned {
238 
239     // MODIFIERS
240 
241     // simple modifier for daily limit.
242     modifier limitedDaily(uint _value) {
243         if (underLimit(_value))
244             _;
245     }
246 
247     // METHODS
248 
249     // constructor - stores initial daily limit and records the present day's index.
250     constructor(uint _limit) public {
251         m_dailyLimit = _limit;
252         m_lastDay = today();
253     }
254     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
255     function setDailyLimit(uint _newLimit) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
256         m_dailyLimit = _newLimit;
257     }
258     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
259     function resetSpentToday() onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
260         m_spentToday = 0;
261     }
262     
263     // INTERNAL METHODS
264     
265     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
266     // returns true. otherwise just returns false.
267     function underLimit(uint _value) internal onlyowner returns (bool) {
268         // reset the spend limit if we're on a different day to last time.
269         if (today() > m_lastDay) {
270             m_spentToday = 0;
271             m_lastDay = today();
272         }
273         // check to see if there's enough left - if so, subtract and return true.
274         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
275             m_spentToday += _value;
276             return true;
277         }
278         return false;
279     }
280     // determines today's index.
281     function today() private view returns (uint) { return block.timestamp / 1 days; }
282 
283     // FIELDS
284 
285     uint public m_dailyLimit;
286     uint public m_spentToday;
287     uint public m_lastDay;
288 }
289 
290 // interface contract for multisig proxy contracts; see below for docs.
291 contract multisig {
292 
293     // EVENTS
294 
295     // logged events:
296     // Funds has arrived into the wallet (record how much).
297     event Deposit(address from, uint value);
298     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
299     event SingleTransact(address owner, uint value, address to);
300     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
301     event MultiTransact(address owner, bytes32 operation, uint value, address to);
302     // Confirmation still needed for a transaction.
303     event ConfirmationERC20Needed(bytes32 operation, address initiator, uint value, address to, ERC20Basic token);
304 
305     
306     event ConfirmationETHNeeded(bytes32 operation, address initiator, uint value, address to);
307     
308     // FUNCTIONS
309     
310     // TODO: document
311     function changeOwner(address _from, address _to) external;
312     //function execute(address _to, uint _value, bytes _data) external returns (bytes32);
313     //function confirm(bytes32 _h) public returns (bool);
314 }
315 
316 // usage:
317 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
318 // Wallet(w).from(anotherOwner).confirm(h);
319 contract Wallet is multisig, multiowned, daylimit {
320 
321     uint public version = 3;
322 
323     // TYPES
324 
325     // Transaction structure to remember details of transaction lest it need be saved for a later call.
326     struct Transaction {
327         address to;
328         uint value;
329         address token;
330     }
331 
332     // METHODS
333 
334     // constructor - just pass on the owner array to the multiowned and
335     // the limit to daylimit
336     constructor(address[] _owners, uint _required, uint _daylimit)
337             multiowned(_owners, _required) daylimit(_daylimit) public {
338     }
339     
340     // kills the contract sending everything to `_to`.
341     function kill(address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data, block.number))) external {
342         selfdestruct(_to);
343     }
344     
345     // gets called when no other function matches
346     function() public payable {
347         // just being sent some cash?
348         if (msg.value > 0)
349             emit Deposit(msg.sender, msg.value);
350     }
351     
352     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
353     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
354     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
355     // and _data arguments). They still get the option of using them if they want, anyways.
356     function transferETH(address _to, uint _value) external onlyowner returns (bytes32 _r) {
357         // first, take the opportunity to check that we're under the daily limit.
358         if (underLimit(_value)) {
359             emit SingleTransact(msg.sender, _value, _to);
360             // yes - just execute the call.
361             _to.transfer(_value);
362             return 0;
363         }
364         // determine our operation hash.
365         _r = keccak256(abi.encodePacked(msg.data, block.number));
366         if (!confirmETH(_r) && m_txs[_r].to == 0) {
367             m_txs[_r].to = _to;
368             m_txs[_r].value = _value;
369             emit ConfirmationETHNeeded(_r, msg.sender, _value, _to);
370         }
371     }
372 
373     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
374     // to determine the body of the transaction from the hash provided.
375     function confirmETH(bytes32 _h) onlymanyowners(_h) public returns (bool) {
376         if (m_txs[_h].to != 0) {
377             m_txs[_h].to.transfer(m_txs[_h].value);
378             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
379             delete m_txs[_h];
380             return true;
381         }
382     }
383 
384     function transferERC20(address _to, uint _value, address _token) external onlyowner returns (bytes32 _r) {
385         // first, take the opportunity to check that we're under the daily limit.
386         if (underLimit(_value)) {
387             emit SingleTransact(msg.sender, _value, _to);
388             // yes - just execute the call.
389 
390             ERC20Basic token = ERC20Basic(_token);
391             token.transfer(_to, _value);
392             return 0;
393         }
394         // determine our operation hash.
395         _r = keccak256(abi.encodePacked(msg.data, block.number));
396         if (!confirmERC20(_r) && m_txs[_r].to == 0) {
397             m_txs[_r].to = _to;
398             m_txs[_r].value = _value;
399             m_txs[_r].token = _token;
400             emit ConfirmationERC20Needed(_r, msg.sender, _value, _to, token);
401         }
402     }
403 
404     function confirmERC20(bytes32 _h) onlymanyowners(_h) public returns (bool) {
405         if (m_txs[_h].to != 0) {
406             ERC20Basic token = ERC20Basic(m_txs[_h].token);
407             token.transfer(m_txs[_h].to, m_txs[_h].value);
408             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
409             delete m_txs[_h];
410             return true;
411         }
412     }
413     
414 
415     
416     // INTERNAL METHODS
417     
418     function clearPending() internal {
419         uint length = m_pendingIndex.length;
420         for (uint i = 0; i < length; ++i)
421             delete m_txs[m_pendingIndex[i]];
422         super.clearPending();
423     }
424 
425     // FIELDS
426 
427     // pending transactions we have at present.
428     mapping (bytes32 => Transaction) m_txs;
429 }