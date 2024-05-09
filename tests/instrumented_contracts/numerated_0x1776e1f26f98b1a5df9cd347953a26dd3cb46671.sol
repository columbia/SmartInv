1 pragma solidity ^0.4.11;
2 
3 contract Safe {
4     // Check if it is safe to add two numbers
5     function safeAdd(uint a, uint b) internal returns (uint) {
6         uint c = a + b;
7         assert(c >= a && c >= b);
8         return c;
9     }
10 
11     // Check if it is safe to subtract two numbers
12     function safeSubtract(uint a, uint b) internal returns (uint) {
13         uint c = a - b;
14         assert(b <= a && c <= a);
15         return c;
16     }
17 
18     function safeMultiply(uint a, uint b) internal returns (uint) {
19         uint c = a * b;
20         assert(a == 0 || (c / a) == b);
21         return c;
22     }
23 
24     function shrink128(uint a) internal returns (uint128) {
25         assert(a < 0x100000000000000000000000000000000);
26         return uint128(a);
27     }
28 
29     // mitigate short address attack
30     modifier onlyPayloadSize(uint numWords) {
31         assert(msg.data.length == numWords * 32 + 4);
32         _;
33     }
34 
35     // allow ether to be received
36     function () payable { }
37 }
38 
39 // Class variables used both in NumeraireBackend and NumeraireDelegate
40 
41 contract NumeraireShared is Safe {
42 
43     address public numerai = this;
44 
45     // Cap the total supply and the weekly supply
46     uint256 public supply_cap = 21000000e18; // 21 million
47     uint256 public weekly_disbursement = 96153846153846153846153;
48 
49     uint256 public initial_disbursement;
50     uint256 public deploy_time;
51 
52     uint256 public total_minted;
53 
54     // ERC20 requires totalSupply, balanceOf, and allowance
55     uint256 public totalSupply;
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     mapping (uint => Tournament) public tournaments;  // tournamentID
60 
61     struct Tournament {
62         uint256 creationTime;
63         uint256[] roundIDs;
64         mapping (uint256 => Round) rounds;  // roundID
65     } 
66 
67     struct Round {
68         uint256 creationTime;
69         uint256 endTime;
70         uint256 resolutionTime;
71         mapping (address => mapping (bytes32 => Stake)) stakes;  // address of staker
72     }
73 
74     // The order is important here because of its packing characteristics.
75     // Particularly, `amount` and `confidence` are in the *same* word, so
76     // Solidity can update both at the same time (if the optimizer can figure
77     // out that you're updating both).  This makes `stake()` cheap.
78     struct Stake {
79         uint128 amount; // Once the stake is resolved, this becomes 0
80         uint128 confidence;
81         bool successful;
82         bool resolved;
83     }
84 
85     // Generates a public event on the blockchain to notify clients
86     event Mint(uint256 value);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     event Staked(address indexed staker, bytes32 tag, uint256 totalAmountStaked, uint256 confidence, uint256 indexed tournamentID, uint256 indexed roundID);
90     event RoundCreated(uint256 indexed tournamentID, uint256 indexed roundID, uint256 endTime, uint256 resolutionTime);
91     event TournamentCreated(uint256 indexed tournamentID);
92     event StakeDestroyed(uint256 indexed tournamentID, uint256 indexed roundID, address indexed stakerAddress, bytes32 tag);
93     event StakeReleased(uint256 indexed tournamentID, uint256 indexed roundID, address indexed stakerAddress, bytes32 tag, uint256 etherReward);
94 
95     // Calculate allowable disbursement
96     function getMintable() constant returns (uint256) {
97         return
98             safeSubtract(
99                 safeAdd(initial_disbursement,
100                     safeMultiply(weekly_disbursement,
101                         safeSubtract(block.timestamp, deploy_time))
102                     / 1 weeks),
103                 total_minted);
104     }
105 }
106 
107 // From OpenZepplin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/ownership/Shareable.sol
108 /*
109  * Shareable
110  * 
111  * Effectively our multisig contract
112  *
113  * Based on https://github.com/ethereum/dapp-bin/blob/master/wallet/wallet.sol
114  *
115  * inheritable "property" contract that enables methods to be protected by requiring the acquiescence of either a single, or, crucially, each of a number of, designated owners.
116  *
117  * usage:
118  * use modifiers onlyowner (just own owned) or onlymanyowners(hash), whereby the same hash must be provided by some number (specified in constructor) of the set of owners (specified in the constructor) before the interior is executed.
119  */
120 contract Shareable {
121   // TYPES
122 
123   // struct for the status of a pending operation.
124   struct PendingState {
125     uint yetNeeded;
126     uint ownersDone;
127     uint index;
128   }
129 
130 
131   // FIELDS
132 
133   // the number of owners that must confirm the same operation before it is run.
134   uint public required;
135 
136   // list of owners
137   address[256] owners;
138   uint constant c_maxOwners = 250;
139   // index on the list of owners to allow reverse lookup
140   mapping(address => uint) ownerIndex;
141   // the ongoing operations.
142   mapping(bytes32 => PendingState) pendings;
143   bytes32[] pendingsIndex;
144 
145 
146   // EVENTS
147 
148   // this contract only has six types of events: it can accept a confirmation, in which case
149   // we record owner and operation (hash) alongside it.
150   event Confirmation(address owner, bytes32 operation);
151   event Revoke(address owner, bytes32 operation);
152 
153 
154   // MODIFIERS
155 
156   address thisContract = this;
157 
158   // simple single-sig function modifier.
159   modifier onlyOwner {
160     if (isOwner(msg.sender))
161       _;
162   }
163 
164   // multi-sig function modifier: the operation must have an intrinsic hash in order
165   // that later attempts can be realised as the same underlying operation and
166   // thus count as confirmations.
167   modifier onlyManyOwners(bytes32 _operation) {
168     if (confirmAndCheck(_operation))
169       _;
170   }
171 
172 
173   // CONSTRUCTOR
174 
175   // constructor is given number of sigs required to do protected "onlymanyowners" transactions
176   // as well as the selection of addresses capable of confirming them.
177   function Shareable(address[] _owners, uint _required) {
178     owners[1] = msg.sender;
179     ownerIndex[msg.sender] = 1;
180     for (uint i = 0; i < _owners.length; ++i) {
181       owners[2 + i] = _owners[i];
182       ownerIndex[_owners[i]] = 2 + i;
183     }
184     if (required > owners.length) throw;
185     required = _required;
186   }
187 
188 
189   // new multisig is given number of sigs required to do protected "onlymanyowners" transactions
190   // as well as the selection of addresses capable of confirming them.
191   // take all new owners as an array
192   function changeShareable(address[] _owners, uint _required) onlyManyOwners(sha3(msg.data)) {
193     for (uint i = 0; i < _owners.length; ++i) {
194       owners[1 + i] = _owners[i];
195       ownerIndex[_owners[i]] = 1 + i;
196     }
197     if (required > owners.length) throw;
198     required = _required;
199   }
200 
201   // METHODS
202 
203   // Revokes a prior confirmation of the given operation
204   function revoke(bytes32 _operation) external {
205     uint index = ownerIndex[msg.sender];
206     // make sure they're an owner
207     if (index == 0) return;
208     uint ownerIndexBit = 2**index;
209     var pending = pendings[_operation];
210     if (pending.ownersDone & ownerIndexBit > 0) {
211       pending.yetNeeded++;
212       pending.ownersDone -= ownerIndexBit;
213       Revoke(msg.sender, _operation);
214     }
215   }
216 
217   // Gets an owner by 0-indexed position (using numOwners as the count)
218   function getOwner(uint ownerIndex) external constant returns (address) {
219     return address(owners[ownerIndex + 1]);
220   }
221 
222   function isOwner(address _addr) constant returns (bool) {
223     return ownerIndex[_addr] > 0;
224   }
225 
226   function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
227     var pending = pendings[_operation];
228     uint index = ownerIndex[_owner];
229 
230     // make sure they're an owner
231     if (index == 0) return false;
232 
233     // determine the bit to set for this owner.
234     uint ownerIndexBit = 2**index;
235     return !(pending.ownersDone & ownerIndexBit == 0);
236   }
237 
238   // INTERNAL METHODS
239 
240   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
241     // determine what index the present sender is:
242     uint index = ownerIndex[msg.sender];
243     // make sure they're an owner
244     if (index == 0) return;
245 
246     var pending = pendings[_operation];
247     // if we're not yet working on this operation, switch over and reset the confirmation status.
248     if (pending.yetNeeded == 0) {
249       // reset count of confirmations needed.
250       pending.yetNeeded = required;
251       // reset which owners have confirmed (none) - set our bitmap to 0.
252       pending.ownersDone = 0;
253       pending.index = pendingsIndex.length++;
254       pendingsIndex[pending.index] = _operation;
255     }
256     // determine the bit to set for this owner.
257     uint ownerIndexBit = 2**index;
258     // make sure we (the message sender) haven't confirmed this operation previously.
259     if (pending.ownersDone & ownerIndexBit == 0) {
260       Confirmation(msg.sender, _operation);
261       // ok - check if count is enough to go ahead.
262       if (pending.yetNeeded <= 1) {
263         // enough confirmations: reset and run interior.
264         delete pendingsIndex[pendings[_operation].index];
265         delete pendings[_operation];
266         return true;
267       }
268       else
269         {
270           // not enough: record that this owner in particular confirmed.
271           pending.yetNeeded--;
272           pending.ownersDone |= ownerIndexBit;
273         }
274     }
275   }
276 
277   function clearPending() internal {
278     uint length = pendingsIndex.length;
279     for (uint i = 0; i < length; ++i)
280     if (pendingsIndex[i] != 0)
281       delete pendings[pendingsIndex[i]];
282     delete pendingsIndex;
283   }
284 }
285 
286 // From OpenZepplin: https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/lifecycle/Pausable.sol
287 /*
288  * Stoppable
289  * Abstract contract that allows children to implement an
290  * emergency stop mechanism.
291  */
292 contract StoppableShareable is Shareable {
293   bool public stopped;
294   bool public stoppable = true;
295 
296   modifier stopInEmergency { if (!stopped) _; }
297   modifier onlyInEmergency { if (stopped) _; }
298 
299   function StoppableShareable(address[] _owners, uint _required) Shareable(_owners, _required) {
300   }
301 
302   // called by the owner on emergency, triggers stopped state
303   function emergencyStop() external onlyOwner {
304     assert(stoppable);
305     stopped = true;
306   }
307 
308   // called by the owners on end of emergency, returns to normal state
309   function release() external onlyManyOwners(sha3(msg.data)) {
310     assert(stoppable);
311     stopped = false;
312   }
313 
314   // called by the owners to disable ability to begin or end an emergency stop
315   function disableStopping() external onlyManyOwners(sha3(msg.data)) {
316     stoppable = false;
317   }
318 }
319 
320 // This is the contract that will be unchangeable once deployed.  It will call delegate functions in another contract to change state.  The delegate contract is upgradable.
321 
322 contract NumeraireBackend is StoppableShareable, NumeraireShared {
323 
324     address public delegateContract;
325     bool public contractUpgradable = true;
326     address[] public previousDelegates;
327 
328     string public standard = "ERC20";
329 
330     // ERC20 requires name, symbol, and decimals
331     string public name = "Numeraire";
332     string public symbol = "NMR";
333     uint256 public decimals = 18;
334 
335     event DelegateChanged(address oldAddress, address newAddress);
336 
337     function NumeraireBackend(address[] _owners, uint256 _num_required, uint256 _initial_disbursement) StoppableShareable(_owners, _num_required) {
338         totalSupply = 0;
339         total_minted = 0;
340 
341         initial_disbursement = _initial_disbursement;
342         deploy_time = block.timestamp;
343     }
344 
345     function disableContractUpgradability() onlyManyOwners(sha3(msg.data)) returns (bool) {
346         assert(contractUpgradable);
347         contractUpgradable = false;
348     }
349 
350     function changeDelegate(address _newDelegate) onlyManyOwners(sha3(msg.data)) returns (bool) {
351         assert(contractUpgradable);
352 
353         if (_newDelegate != delegateContract) {
354             previousDelegates.push(delegateContract);
355             var oldDelegate = delegateContract;
356             delegateContract = _newDelegate;
357             DelegateChanged(oldDelegate, _newDelegate);
358             return true;
359         }
360 
361         return false;
362     }
363 
364     function claimTokens(address _token) onlyOwner {
365         assert(_token != numerai);
366         if (_token == 0x0) {
367             msg.sender.transfer(this.balance);
368             return;
369         }
370 
371         NumeraireBackend token = NumeraireBackend(_token);
372         uint256 balance = token.balanceOf(this);
373         token.transfer(msg.sender, balance);
374     }
375 
376     function mint(uint256 _value) stopInEmergency returns (bool ok) {
377         return delegateContract.delegatecall(bytes4(sha3("mint(uint256)")), _value);
378     }
379 
380     function stake(uint256 _value, bytes32 _tag, uint256 _tournamentID, uint256 _roundID, uint256 _confidence) stopInEmergency returns (bool ok) {
381         return delegateContract.delegatecall(bytes4(sha3("stake(uint256,bytes32,uint256,uint256,uint256)")), _value, _tag, _tournamentID, _roundID, _confidence);
382     }
383 
384     function stakeOnBehalf(address _staker, uint256 _value, bytes32 _tag, uint256 _tournamentID, uint256 _roundID, uint256 _confidence) stopInEmergency onlyPayloadSize(6) returns (bool ok) {
385         return delegateContract.delegatecall(bytes4(sha3("stakeOnBehalf(address,uint256,bytes32,uint256,uint256,uint256)")), _staker, _value, _tag, _tournamentID, _roundID, _confidence);
386     }
387 
388     function releaseStake(address _staker, bytes32 _tag, uint256 _etherValue, uint256 _tournamentID, uint256 _roundID, bool _successful) stopInEmergency onlyPayloadSize(6) returns (bool ok) {
389         return delegateContract.delegatecall(bytes4(sha3("releaseStake(address,bytes32,uint256,uint256,uint256,bool)")), _staker, _tag, _etherValue, _tournamentID, _roundID, _successful);
390     }
391 
392     function destroyStake(address _staker, bytes32 _tag, uint256 _tournamentID, uint256 _roundID) stopInEmergency onlyPayloadSize(4) returns (bool ok) {
393         return delegateContract.delegatecall(bytes4(sha3("destroyStake(address,bytes32,uint256,uint256)")), _staker, _tag, _tournamentID, _roundID);
394     }
395 
396     function numeraiTransfer(address _to, uint256 _value) onlyPayloadSize(2) returns(bool ok) {
397         return delegateContract.delegatecall(bytes4(sha3("numeraiTransfer(address,uint256)")), _to, _value);
398     }
399 
400     function withdraw(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns(bool ok) {
401         return delegateContract.delegatecall(bytes4(sha3("withdraw(address,address,uint256)")), _from, _to, _value);
402     }
403 
404     function createTournament(uint256 _tournamentID) returns (bool ok) {
405         return delegateContract.delegatecall(bytes4(sha3("createTournament(uint256)")), _tournamentID);
406     }
407 
408     function createRound(uint256 _tournamentID, uint256 _roundID, uint256 _endTime, uint256 _resolutionTime) returns (bool ok) {
409         return delegateContract.delegatecall(bytes4(sha3("createRound(uint256,uint256,uint256,uint256)")), _tournamentID, _roundID, _endTime, _resolutionTime);
410     }
411 
412     function getTournament(uint256 _tournamentID) constant returns (uint256, uint256[]) {
413         var tournament = tournaments[_tournamentID];
414         return (tournament.creationTime, tournament.roundIDs);
415     }
416 
417     function getRound(uint256 _tournamentID, uint256 _roundID) constant returns (uint256, uint256, uint256) {
418         var round = tournaments[_tournamentID].rounds[_roundID];
419         return (round.creationTime, round.endTime, round.resolutionTime);
420     }
421 
422     function getStake(uint256 _tournamentID, uint256 _roundID, address _staker, bytes32 _tag) constant returns (uint256, uint256, bool, bool) {
423         var stake = tournaments[_tournamentID].rounds[_roundID].stakes[_staker][_tag];
424         return (stake.confidence, stake.amount, stake.successful, stake.resolved);
425     }
426 
427     // ERC20: Send from a contract
428     function transferFrom(address _from, address _to, uint256 _value) stopInEmergency onlyPayloadSize(3) returns (bool ok) {
429         require(!isOwner(_from) && _from != numerai); // Transfering from Numerai can only be done with the numeraiTransfer function
430 
431         // Check for sufficient funds.
432         require(balanceOf[_from] >= _value);
433         // Check for authorization to spend.
434         require(allowance[_from][msg.sender] >= _value);
435 
436         balanceOf[_from] = safeSubtract(balanceOf[_from], _value);
437         allowance[_from][msg.sender] = safeSubtract(allowance[_from][msg.sender], _value);
438         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
439 
440         // Notify anyone listening.
441         Transfer(_from, _to, _value);
442 
443         return true;
444     }
445 
446     // ERC20: Anyone with NMR can transfer NMR
447     function transfer(address _to, uint256 _value) stopInEmergency onlyPayloadSize(2) returns (bool ok) {
448         // Check for sufficient funds.
449         require(balanceOf[msg.sender] >= _value);
450 
451         balanceOf[msg.sender] = safeSubtract(balanceOf[msg.sender], _value);
452         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
453 
454         // Notify anyone listening.
455         Transfer(msg.sender, _to, _value);
456 
457         return true;
458     }
459 
460     // ERC20: Allow other contracts to spend on sender's behalf
461     function approve(address _spender, uint256 _value) stopInEmergency onlyPayloadSize(2) returns (bool ok) {
462         require((_value == 0) || (allowance[msg.sender][_spender] == 0));
463         allowance[msg.sender][_spender] = _value;
464         Approval(msg.sender, _spender, _value);
465         return true;
466     }
467 
468     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) stopInEmergency onlyPayloadSize(3) returns (bool ok) {
469         require(allowance[msg.sender][_spender] == _oldValue);
470         allowance[msg.sender][_spender] = _newValue;
471         Approval(msg.sender, _spender, _newValue);
472         return true;
473     }
474 }