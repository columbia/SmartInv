1 pragma solidity >=0.4.25 <0.5.0;
2 
3 /**
4  * @title NMRSafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library NMRSafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68  /* WARNING: This implementation is outdated and insecure */
69  /// @title Shareable
70  /// @notice Multisig contract to manage access control
71 contract Shareable {
72   // TYPES
73 
74   // struct for the status of a pending operation.
75   struct PendingState {
76     uint yetNeeded;
77     uint ownersDone;
78     uint index;
79   }
80 
81 
82   // FIELDS
83 
84   // the number of owners that must confirm the same operation before it is run.
85   uint public required;
86 
87   // list of owners
88   address[256] owners;
89   uint constant c_maxOwners = 250;
90   // index on the list of owners to allow reverse lookup
91   mapping(address => uint) ownerIndex;
92   // the ongoing operations.
93   mapping(bytes32 => PendingState) pendings;
94   bytes32[] pendingsIndex;
95 
96 
97   // EVENTS
98 
99   // this contract only has six types of events: it can accept a confirmation, in which case
100   // we record owner and operation (hash) alongside it.
101   event Confirmation(address owner, bytes32 operation);
102   event Revoke(address owner, bytes32 operation);
103 
104 
105   // MODIFIERS
106 
107   address thisContract = this;
108 
109   // simple single-sig function modifier.
110   modifier onlyOwner {
111     if (isOwner(msg.sender))
112       _;
113   }
114 
115   // multi-sig function modifier: the operation must have an intrinsic hash in order
116   // that later attempts can be realised as the same underlying operation and
117   // thus count as confirmations.
118   modifier onlyManyOwners(bytes32 _operation) {
119     if (confirmAndCheck(_operation))
120       _;
121   }
122 
123 
124   // CONSTRUCTOR
125 
126   // constructor is given number of sigs required to do protected "onlymanyowners" transactions
127   // as well as the selection of addresses capable of confirming them.
128   function Shareable(address[] _owners, uint _required) {
129     owners[1] = msg.sender;
130     ownerIndex[msg.sender] = 1;
131     for (uint i = 0; i < _owners.length; ++i) {
132       owners[2 + i] = _owners[i];
133       ownerIndex[_owners[i]] = 2 + i;
134     }
135     if (required > owners.length) throw;
136     required = _required;
137   }
138 
139 
140   // new multisig is given number of sigs required to do protected "onlymanyowners" transactions
141   // as well as the selection of addresses capable of confirming them.
142   // take all new owners as an array
143   /*
144   
145    WARNING: This function contains a security vulnerability. 
146    
147    This method does not clear the `owners` array and the `ownerIndex` mapping before updating the owner addresses.
148    If the new array of owner addresses is shorter than the existing array of owner addresses, some of the existing owners will retain ownership.
149    
150    The fix implemented in NumeraireDelegateV2 successfully mitigates this bug by allowing new owners to remove the old owners from the `ownerIndex` mapping using a special transaction.
151    Note that the old owners are not be removed from the `owners` array and that if the special transaction is incorectly crafted, it may result in fatal error to the multisig functionality.
152    
153    */
154   function changeShareable(address[] _owners, uint _required) onlyManyOwners(sha3(msg.data)) {
155     for (uint i = 0; i < _owners.length; ++i) {
156       owners[1 + i] = _owners[i];
157       ownerIndex[_owners[i]] = 1 + i;
158     }
159     if (required > owners.length) throw;
160     required = _required;
161   }
162 
163   // METHODS
164 
165   // Revokes a prior confirmation of the given operation
166   function revoke(bytes32 _operation) external {
167     uint index = ownerIndex[msg.sender];
168     // make sure they're an owner
169     if (index == 0) return;
170     uint ownerIndexBit = 2**index;
171     var pending = pendings[_operation];
172     if (pending.ownersDone & ownerIndexBit > 0) {
173       pending.yetNeeded++;
174       pending.ownersDone -= ownerIndexBit;
175       Revoke(msg.sender, _operation);
176     }
177   }
178 
179   // Gets an owner by 0-indexed position (using numOwners as the count)
180   function getOwner(uint ownerIndex) external constant returns (address) {
181     return address(owners[ownerIndex + 1]);
182   }
183 
184   function isOwner(address _addr) constant returns (bool) {
185     return ownerIndex[_addr] > 0;
186   }
187 
188   function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
189     var pending = pendings[_operation];
190     uint index = ownerIndex[_owner];
191 
192     // make sure they're an owner
193     if (index == 0) return false;
194 
195     // determine the bit to set for this owner.
196     uint ownerIndexBit = 2**index;
197     return !(pending.ownersDone & ownerIndexBit == 0);
198   }
199 
200   // INTERNAL METHODS
201 
202   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
203     // determine what index the present sender is:
204     uint index = ownerIndex[msg.sender];
205     // make sure they're an owner
206     if (index == 0) return;
207 
208     var pending = pendings[_operation];
209     // if we're not yet working on this operation, switch over and reset the confirmation status.
210     if (pending.yetNeeded == 0) {
211       // reset count of confirmations needed.
212       pending.yetNeeded = required;
213       // reset which owners have confirmed (none) - set our bitmap to 0.
214       pending.ownersDone = 0;
215       pending.index = pendingsIndex.length++;
216       pendingsIndex[pending.index] = _operation;
217     }
218     // determine the bit to set for this owner.
219     uint ownerIndexBit = 2**index;
220     // make sure we (the message sender) haven't confirmed this operation previously.
221     if (pending.ownersDone & ownerIndexBit == 0) {
222       Confirmation(msg.sender, _operation);
223       // ok - check if count is enough to go ahead.
224       if (pending.yetNeeded <= 1) {
225         // enough confirmations: reset and run interior.
226         delete pendingsIndex[pendings[_operation].index];
227         delete pendings[_operation];
228         return true;
229       }
230       else
231         {
232           // not enough: record that this owner in particular confirmed.
233           pending.yetNeeded--;
234           pending.ownersDone |= ownerIndexBit;
235         }
236     }
237   }
238 
239   function clearPending() internal {
240     uint length = pendingsIndex.length;
241     for (uint i = 0; i < length; ++i)
242     if (pendingsIndex[i] != 0)
243       delete pendings[pendingsIndex[i]];
244     delete pendingsIndex;
245   }
246 }
247 
248 
249 
250 /// @title Safe
251 /// @notice Utility functions for safe data manipulations
252 contract Safe {
253 
254     /// @dev Add two numbers without overflow
255     /// @param a Uint number
256     /// @param b Uint number
257     /// @return result
258     function safeAdd(uint a, uint b) internal returns (uint) {
259         uint c = a + b;
260         assert(c >= a && c >= b);
261         return c;
262     }
263 
264     /// @dev Substract two numbers without underflow
265     /// @param a Uint number
266     /// @param b Uint number
267     /// @return result
268     function safeSubtract(uint a, uint b) internal returns (uint) {
269         uint c = a - b;
270         assert(b <= a && c <= a);
271         return c;
272     }
273 
274     /// @dev Multiply two numbers without overflow
275     /// @param a Uint number
276     /// @param b Uint number
277     /// @return result
278     function safeMultiply(uint a, uint b) internal returns (uint) {
279         uint c = a * b;
280         assert(a == 0 || (c / a) == b);
281         return c;
282     }
283 
284     /// @dev Convert uint256 to uint128 without concatenating
285     /// @param a Uint number
286     /// @return result
287     function shrink128(uint a) internal returns (uint128) {
288         assert(a < 0x100000000000000000000000000000000);
289         return uint128(a);
290     }
291 
292     /// @dev Prevent short address attack
293     /// @param numWords Uint length of calldata in bytes32 words
294     modifier onlyPayloadSize(uint numWords) {
295         assert(msg.data.length == numWords * 32 + 4);
296         _;
297     }
298 
299     /// @dev Fallback function to allow ETH to be received
300     function () payable { }
301 }
302 
303 
304 
305 /// @title StoppableShareable
306 /// @notice Extend the Shareable multisig with ability to pause desired functions
307 contract StoppableShareable is Shareable {
308   bool public stopped;
309   bool public stoppable = true;
310 
311   modifier stopInEmergency { if (!stopped) _; }
312   modifier onlyInEmergency { if (stopped) _; }
313 
314   function StoppableShareable(address[] _owners, uint _required) Shareable(_owners, _required) {
315   }
316 
317   /// @notice Trigger paused state
318   /// @dev Can only be called by an owner
319   function emergencyStop() external onlyOwner {
320     assert(stoppable);
321     stopped = true;
322   }
323 
324   /// @notice Return to unpaused state
325   /// @dev Can only be called by the multisig
326   function release() external onlyManyOwners(sha3(msg.data)) {
327     assert(stoppable);
328     stopped = false;
329   }
330 
331   /// @notice Disable ability to pause the contract
332   /// @dev Can only be called by the multisig
333   function disableStopping() external onlyManyOwners(sha3(msg.data)) {
334     stoppable = false;
335   }
336 }
337 
338 
339 
340 /// @title NumeraireShared
341 /// @notice Token and tournament storage layout
342 contract NumeraireShared is Safe {
343 
344     address public numerai = this;
345 
346     // Cap the total supply and the weekly supply
347     uint256 public supply_cap = 21000000e18; // 21 million
348     uint256 public weekly_disbursement = 96153846153846153846153;
349 
350     uint256 public initial_disbursement;
351     uint256 public deploy_time;
352 
353     uint256 public total_minted;
354 
355     // ERC20 requires totalSupply, balanceOf, and allowance
356     uint256 public totalSupply;
357     mapping (address => uint256) public balanceOf;
358     mapping (address => mapping (address => uint256)) public allowance;
359 
360     mapping (uint => Tournament) public tournaments;  // tournamentID
361 
362     struct Tournament {
363         uint256 creationTime;
364         uint256[] roundIDs;
365         mapping (uint256 => Round) rounds;  // roundID
366     } 
367 
368     struct Round {
369         uint256 creationTime;
370         uint256 endTime;
371         uint256 resolutionTime;
372         mapping (address => mapping (bytes32 => Stake)) stakes;  // address of staker
373     }
374 
375     // The order is important here because of its packing characteristics.
376     // Particularly, `amount` and `confidence` are in the *same* word, so
377     // Solidity can update both at the same time (if the optimizer can figure
378     // out that you're updating both).  This makes `stake()` cheap.
379     struct Stake {
380         uint128 amount; // Once the stake is resolved, this becomes 0
381         uint128 confidence;
382         bool successful;
383         bool resolved;
384     }
385 
386     // Generates a public event on the blockchain to notify clients
387     event Mint(uint256 value);
388     event Transfer(address indexed from, address indexed to, uint256 value);
389     event Approval(address indexed owner, address indexed spender, uint256 value);
390     event Staked(address indexed staker, bytes32 tag, uint256 totalAmountStaked, uint256 confidence, uint256 indexed tournamentID, uint256 indexed roundID);
391     event RoundCreated(uint256 indexed tournamentID, uint256 indexed roundID, uint256 endTime, uint256 resolutionTime);
392     event TournamentCreated(uint256 indexed tournamentID);
393     event StakeDestroyed(uint256 indexed tournamentID, uint256 indexed roundID, address indexed stakerAddress, bytes32 tag);
394     event StakeReleased(uint256 indexed tournamentID, uint256 indexed roundID, address indexed stakerAddress, bytes32 tag, uint256 etherReward);
395 
396     /// @notice Get the amount of NMR which can be minted
397     /// @return uint256 Amount of NMR in wei
398     function getMintable() constant returns (uint256) {
399         return
400             safeSubtract(
401                 safeAdd(initial_disbursement,
402                     safeMultiply(weekly_disbursement,
403                         safeSubtract(block.timestamp, deploy_time))
404                     / 1 weeks),
405                 total_minted);
406     }
407 }
408 
409 
410 
411 
412 
413 /// @title NumeraireDelegateV3
414 /// @notice Delegate contract version 3 with the following functionality:
415 ///   1) Disabled upgradability
416 ///   2) Repurposed burn functions
417 ///   3) User NMR balance management through the relay contract
418 /// @dev Deployed at address
419 /// @dev Set in tx
420 /// @dev Retired in tx
421 contract NumeraireDelegateV3 is StoppableShareable, NumeraireShared {
422 
423     address public delegateContract;
424     bool public contractUpgradable;
425     address[] public previousDelegates;
426 
427     string public standard;
428 
429     string public name;
430     string public symbol;
431     uint256 public decimals;
432 
433     // set the address of the relay as a constant (stored in runtime code)
434     address private constant _RELAY = address(
435         0xB17dF4a656505570aD994D023F632D48De04eDF2
436     );
437 
438     event DelegateChanged(address oldAddress, address newAddress);
439 
440     using NMRSafeMath for uint256;
441 
442     /* TODO: Can this contructor be removed completely? */
443     /// @dev Constructor called on deployment to initialize the delegate contract multisig
444     /// @param _owners Array of owner address to control multisig
445     /// @param _num_required Uint number of owners required for multisig transaction
446     constructor(address[] _owners, uint256 _num_required) public StoppableShareable(_owners, _num_required) {
447         require(
448             address(this) == address(0x29F709e42C95C604BA76E73316d325077f8eB7b2),
449             "incorrect deployment address - check submitting account & nonce."
450         );
451     }
452 
453     //////////////////////////////
454     // Special Access Functions //
455     //////////////////////////////
456 
457     /// @notice Manage Numerai Tournament user balances
458     /// @dev Can only be called by numerai through the relay contract
459     /// @param _from User address from which to withdraw NMR
460     /// @param _to Address where to deposit NMR
461     /// @param _value Uint amount of NMR in wei to transfer
462     /// @return ok True if the transfer succeeds
463     function withdraw(address _from, address _to, uint256 _value) public returns(bool ok) {
464         require(msg.sender == _RELAY);
465         require(_to != address(0));
466 
467         balanceOf[_from] = balanceOf[_from].sub(_value);
468         balanceOf[_to] = balanceOf[_to].add(_value);
469 
470         emit Transfer(_from, _to, _value);
471         return true;
472     }
473 
474     /// @notice Repurposed function to allow the relay contract to disable token upgradability.
475     /// @dev Can only be called by numerai through the relay contract
476     /// @return ok True if the call is successful
477     function createRound(uint256, uint256, uint256, uint256) public returns (bool ok) {
478         require(msg.sender == _RELAY);
479         require(contractUpgradable);
480         contractUpgradable = false;
481 
482         return true;
483     }
484 
485     /// @notice Repurposed function to allow the relay contract to upgrade the token.
486     /// @dev Can only be called by numerai through the relay contract
487     /// @param _newDelegate Address of the new delegate contract
488     /// @return ok True if the call is successful
489     function createTournament(uint256 _newDelegate) public returns (bool ok) {
490         require(msg.sender == _RELAY);
491         require(contractUpgradable);
492 
493         address newDelegate = address(_newDelegate);
494 
495         previousDelegates.push(delegateContract);
496         emit DelegateChanged(delegateContract, newDelegate);
497         delegateContract = newDelegate;
498 
499         return true;
500     }
501 
502     //////////////////////////
503     // Repurposed Functions //
504     //////////////////////////
505 
506     /// @notice Repurposed function to implement token burn from the calling account
507     /// @param _value Uint amount of NMR in wei to burn
508     /// @return ok True if the burn succeeds
509     function mint(uint256 _value) public returns (bool ok) {
510         _burn(msg.sender, _value);
511         return true;
512     }
513 
514     /// @notice Repurposed function to implement token burn on behalf of an approved account
515     /// @param _to Address from which to burn tokens
516     /// @param _value Uint amount of NMR in wei to burn
517     /// @return ok True if the burn succeeds
518     function numeraiTransfer(address _to, uint256 _value) public returns (bool ok) {
519         _burnFrom(_to, _value);
520         return true;
521     }
522 
523     ////////////////////////
524     // Internal Functions //
525     ////////////////////////
526 
527     /// @dev Internal function that burns an amount of the token of a given account.
528     /// @param _account The account whose tokens will be burnt.
529     /// @param _value The amount that will be burnt.
530     function _burn(address _account, uint256 _value) internal {
531         require(_account != address(0));
532 
533         totalSupply = totalSupply.sub(_value);
534         balanceOf[_account] = balanceOf[_account].sub(_value);
535         emit Transfer(_account, address(0), _value);
536     }
537 
538     /// @dev Internal function that burns an amount of the token of a given
539     /// account, deducting from the sender's allowance for said account. Uses the
540     /// internal burn function.
541     /// Emits an Approval event (reflecting the reduced allowance).
542     /// @param _account The account whose tokens will be burnt.
543     /// @param _value The amount that will be burnt.
544     function _burnFrom(address _account, uint256 _value) internal {
545         allowance[_account][msg.sender] = allowance[_account][msg.sender].sub(_value);
546         _burn(_account, _value);
547         emit Approval(_account, msg.sender, allowance[_account][msg.sender]);
548     }
549 
550     ///////////////////////
551     // Trashed Functions //
552     ///////////////////////
553 
554     /// @dev Disabled function no longer used
555     function releaseStake(address, bytes32, uint256, uint256, uint256, bool) public pure returns (bool) {
556         revert();
557     }
558 
559     /// @dev Disabled function no longer used
560     function destroyStake(address, bytes32, uint256, uint256) public pure returns (bool) {
561         revert();
562     }
563 
564     /// @dev Disabled function no longer used
565     function stake(uint256, bytes32, uint256, uint256, uint256) public pure returns (bool) {
566         revert();
567     }
568 
569     /// @dev Disabled function no longer used
570     function stakeOnBehalf(address, uint256, bytes32, uint256, uint256, uint256) public pure returns (bool) {
571         revert();
572     }
573 }