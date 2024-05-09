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
61         m_numOwners = _owners.length;// + 1;
62         //m_owners[1] = uint(msg.sender);
63         //m_ownerIndex[uint(msg.sender)] = 1;
64         for (uint i = 0; i < _owners.length; ++i)
65         {
66             m_owners[1 + i] = uint(_owners[i]);
67             m_ownerIndex[uint(_owners[i])] = 1 + i;
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
87     function changeOwner(address _from, address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
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
99     function addOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
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
113     function removeOwner(address _owner) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
114         uint ownerIndex = m_ownerIndex[uint(_owner)];
115         if (ownerIndex == 0) return;
116         
117         if (m_required > m_numOwners - 1) return;
118 
119         m_owners[ownerIndex] = 0;
120         m_ownerIndex[uint(_owner)] = 0;
121         clearPending();
122         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
123         emit OwnerRemoved(_owner);
124     }
125     
126     function changeRequirement(uint _newRequired) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
127         if (_newRequired > m_numOwners) return;
128         m_required = _newRequired;
129         clearPending();
130         emit RequirementChanged(_newRequired);
131     }
132     
133     function isOwner(address _addr) public view returns (bool) {
134         return m_ownerIndex[uint(_addr)] > 0;
135     }
136     
137     function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
138         PendingState storage pending = m_pending[_operation];
139         uint ownerIndex = m_ownerIndex[uint(_owner)];
140 
141         // make sure they're an owner
142         if (ownerIndex == 0) return false;
143 
144         // determine the bit to set for this owner.
145         uint ownerIndexBit = 2**ownerIndex;
146         if (pending.ownersDone & ownerIndexBit == 0) {
147             return false;
148         } else {
149             return true;
150         }
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
161         PendingState storage pending = m_pending[_operation];
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
175             emit Confirmation(msg.sender, _operation);
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
192     function reorganizeOwners() private returns (bool) {
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
209         for (uint i = 0; i < length; ++i) {
210             if (m_pendingIndex[i] != 0) {
211                 delete m_pending[m_pendingIndex[i]];
212             }
213         }
214             
215         delete m_pendingIndex;
216     }
217         
218     // FIELDS
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
235 // inheritable "property" contract that enables methods to be protected by placing a linear limit (specifiable)
236 // on a particular resource per calendar day. is multiowned to allow the limit to be altered. resource that method
237 // uses is specified in the modifier.
238 contract daylimit is multiowned {
239 
240     // MODIFIERS
241 
242     // simple modifier for daily limit.
243     modifier limitedDaily(uint _value) {
244         if (underLimit(_value))
245             _;
246     }
247 
248     // METHODS
249 
250     // constructor - stores initial daily limit and records the present day's index.
251     constructor(uint _limit) public {
252         m_dailyLimit = _limit;
253         m_lastDay = today();
254     }
255     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
256     function setDailyLimit(uint _newLimit) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
257         m_dailyLimit = _newLimit;
258     }
259     // (re)sets the daily limit. needs many of the owners to confirm. doesn't alter the amount already spent today.
260     function resetSpentToday() onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
261         m_spentToday = 0;
262     }
263     
264     // INTERNAL METHODS
265     
266     // checks to see if there is at least `_value` left from the daily limit today. if there is, subtracts it and
267     // returns true. otherwise just returns false.
268     function underLimit(uint _value) internal onlyowner returns (bool) {
269         // reset the spend limit if we're on a different day to last time.
270         if (today() > m_lastDay) {
271             m_spentToday = 0;
272             m_lastDay = today();
273         }
274         // check to see if there's enough left - if so, subtract and return true.
275         if (m_spentToday + _value >= m_spentToday && m_spentToday + _value <= m_dailyLimit) {
276             m_spentToday += _value;
277             return true;
278         }
279         return false;
280     }
281     // determines today's index.
282     function today() private view returns (uint) { return block.timestamp / 1 days; }
283 
284     // FIELDS
285 
286     uint public m_dailyLimit;
287     uint public m_spentToday;
288     uint public m_lastDay;
289 }
290 
291 // interface contract for multisig proxy contracts; see below for docs.
292 contract multisig {
293 
294     // EVENTS
295 
296     // logged events:
297     // Funds has arrived into the wallet (record how much).
298     event Deposit(address from, uint value);
299     // Single transaction going out of the wallet (record who signed for it, how much, and to whom it's going).
300     event SingleTransact(address owner, uint value, address to);
301     // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
302     event MultiTransact(address owner, bytes32 operation, uint value, address to);
303     // Confirmation still needed for a transaction.
304     event ConfirmationERC20Needed(bytes32 operation, address initiator, uint value, address to, ERC20Basic token);
305 
306     
307     event ConfirmationETHNeeded(bytes32 operation, address initiator, uint value, address to);
308     
309     // FUNCTIONS
310     
311     // TODO: document
312     function changeOwner(address _from, address _to) external;
313     //function execute(address _to, uint _value, bytes _data) external returns (bytes32);
314     //function confirm(bytes32 _h) public returns (bool);
315 }
316 
317 // usage:
318 // bytes32 h = Wallet(w).from(oneOwner).transact(to, value, data);
319 // Wallet(w).from(anotherOwner).confirm(h);
320 contract Wallet is multisig, multiowned, daylimit {
321 
322     uint public version = 3;
323 
324     // TYPES
325 
326     // Transaction structure to remember details of transaction lest it need be saved for a later call.
327     struct Transaction {
328         address to;
329         uint value;
330         address token;
331     }
332 
333     // METHODS
334 
335     // constructor - just pass on the owner array to the multiowned and
336     // the limit to daylimit
337     constructor(address[] _owners, uint _required, uint _daylimit)
338             multiowned(_owners, _required) daylimit(_daylimit) public {
339     }
340     
341     // kills the contract sending everything to `_to`.
342     function kill(address _to) onlymanyowners(keccak256(abi.encodePacked(msg.data))) external {
343         selfdestruct(_to);
344     }
345     
346     // gets called when no other function matches
347     function() public payable {
348         // just being sent some cash?
349         if (msg.value > 0)
350             emit Deposit(msg.sender, msg.value);
351     }
352     
353     // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
354     // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
355     // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
356     // and _data arguments). They still get the option of using them if they want, anyways.
357     function transferETH(address _to, uint _value) external onlyowner returns (bytes32 _r) {
358         // first, take the opportunity to check that we're under the daily limit.
359         if (underLimit(_value)) {
360             emit SingleTransact(msg.sender, _value, _to);
361             // yes - just execute the call.
362             _to.transfer(_value);
363             return 0;
364         }
365         // determine our operation hash.
366         _r = keccak256(abi.encodePacked(msg.data, block.number));
367         if (!confirmETH(_r) && m_txs[_r].to == 0) {
368             m_txs[_r].to = _to;
369             m_txs[_r].value = _value;
370             emit ConfirmationETHNeeded(_r, msg.sender, _value, _to);
371         }
372     }
373 
374     // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
375     // to determine the body of the transaction from the hash provided.
376     function confirmETH(bytes32 _h) onlymanyowners(_h) public returns (bool) {
377         if (m_txs[_h].to != 0) {
378             m_txs[_h].to.transfer(m_txs[_h].value);
379             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
380             delete m_txs[_h];
381             return true;
382         }
383     }
384 
385     function transferERC20(address _to, uint _value, address _token) external onlyowner returns (bytes32 _r) {
386         // first, take the opportunity to check that we're under the daily limit.
387         if (underLimit(_value)) {
388             emit SingleTransact(msg.sender, _value, _to);
389             // yes - just execute the call.
390 
391             ERC20Basic token = ERC20Basic(_token);
392             token.transfer(_to, _value);
393             return 0;
394         }
395         // determine our operation hash.
396         _r = keccak256(abi.encodePacked(msg.data, block.number));
397         if (!confirmERC20(_r) && m_txs[_r].to == 0) {
398             m_txs[_r].to = _to;
399             m_txs[_r].value = _value;
400             m_txs[_r].token = _token;
401             emit ConfirmationERC20Needed(_r, msg.sender, _value, _to, token);
402         }
403     }
404 
405     function confirmERC20(bytes32 _h) onlymanyowners(_h) public returns (bool) {
406         if (m_txs[_h].to != 0) {
407             ERC20Basic token = ERC20Basic(m_txs[_h].token);
408             token.transfer(m_txs[_h].to, m_txs[_h].value);
409             emit MultiTransact(msg.sender, _h, m_txs[_h].value, m_txs[_h].to);
410             delete m_txs[_h];
411             return true;
412         }
413     }
414     
415 
416     
417     // INTERNAL METHODS
418     
419     function clearPending() internal {
420         uint length = m_pendingIndex.length;
421         for (uint i = 0; i < length; ++i)
422             delete m_txs[m_pendingIndex[i]];
423         super.clearPending();
424     }
425 
426     // FIELDS
427 
428     // pending transactions we have at present.
429     mapping (bytes32 => Transaction) m_txs;
430 }