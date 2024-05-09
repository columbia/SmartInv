1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
57 
58 pragma solidity ^0.4.24;
59 
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipRenounced(address indexed previousOwner);
71   event OwnershipTransferred(
72     address indexed previousOwner,
73     address indexed newOwner
74   );
75 
76 
77   /**
78    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79    * account.
80    */
81   constructor() public {
82     owner = msg.sender;
83   }
84 
85   /**
86    * @dev Throws if called by any account other than the owner.
87    */
88   modifier onlyOwner() {
89     require(msg.sender == owner);
90     _;
91   }
92 
93   /**
94    * @dev Allows the current owner to relinquish control of the contract.
95    * @notice Renouncing to ownership will leave the contract without an owner.
96    * It will not be possible to call the functions with the `onlyOwner`
97    * modifier anymore.
98    */
99   function renounceOwnership() public onlyOwner {
100     emit OwnershipRenounced(owner);
101     owner = address(0);
102   }
103 
104   /**
105    * @dev Allows the current owner to transfer control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function transferOwnership(address _newOwner) public onlyOwner {
109     _transferOwnership(_newOwner);
110   }
111 
112   /**
113    * @dev Transfers control of the contract to a newOwner.
114    * @param _newOwner The address to transfer ownership to.
115    */
116   function _transferOwnership(address _newOwner) internal {
117     require(_newOwner != address(0));
118     emit OwnershipTransferred(owner, _newOwner);
119     owner = _newOwner;
120   }
121 }
122 
123 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
124 
125 pragma solidity ^0.4.24;
126 
127 
128 
129 /**
130  * @title Pausable
131  * @dev Base contract which allows children to implement an emergency stop mechanism.
132  */
133 contract Pausable is Ownable {
134   event Pause();
135   event Unpause();
136 
137   bool public paused = false;
138 
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is not paused.
142    */
143   modifier whenNotPaused() {
144     require(!paused);
145     _;
146   }
147 
148   /**
149    * @dev Modifier to make a function callable only when the contract is paused.
150    */
151   modifier whenPaused() {
152     require(paused);
153     _;
154   }
155 
156   /**
157    * @dev called by the owner to pause, triggers stopped state
158    */
159   function pause() public onlyOwner whenNotPaused {
160     paused = true;
161     emit Pause();
162   }
163 
164   /**
165    * @dev called by the owner to unpause, returns to normal state
166    */
167   function unpause() public onlyOwner whenPaused {
168     paused = false;
169     emit Unpause();
170   }
171 }
172 
173 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
174 
175 pragma solidity ^0.4.24;
176 
177 
178 /**
179  * @title ERC20Basic
180  * @dev Simpler version of ERC20 interface
181  * See https://github.com/ethereum/EIPs/issues/179
182  */
183 contract ERC20Basic {
184   function totalSupply() public view returns (uint256);
185   function balanceOf(address _who) public view returns (uint256);
186   function transfer(address _to, uint256 _value) public returns (bool);
187   event Transfer(address indexed from, address indexed to, uint256 value);
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.4.24;
193 
194 
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address _owner, address _spender)
202     public view returns (uint256);
203 
204   function transferFrom(address _from, address _to, uint256 _value)
205     public returns (bool);
206 
207   function approve(address _spender, uint256 _value) public returns (bool);
208   event Approval(
209     address indexed owner,
210     address indexed spender,
211     uint256 value
212   );
213 }
214 
215 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
216 
217 pragma solidity ^0.4.24;
218 
219 
220 
221 
222 /**
223  * @title SafeERC20
224  * @dev Wrappers around ERC20 operations that throw on failure.
225  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
226  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
227  */
228 library SafeERC20 {
229   function safeTransfer(
230     ERC20Basic _token,
231     address _to,
232     uint256 _value
233   )
234     internal
235   {
236     require(_token.transfer(_to, _value));
237   }
238 
239   function safeTransferFrom(
240     ERC20 _token,
241     address _from,
242     address _to,
243     uint256 _value
244   )
245     internal
246   {
247     require(_token.transferFrom(_from, _to, _value));
248   }
249 
250   function safeApprove(
251     ERC20 _token,
252     address _spender,
253     uint256 _value
254   )
255     internal
256   {
257     require(_token.approve(_spender, _value));
258   }
259 }
260 
261 // File: monetha-utility-contracts/contracts/Restricted.sol
262 
263 pragma solidity ^0.4.18;
264 
265 
266 
267 /** @title Restricted
268  *  Exposes onlyMonetha modifier
269  */
270 contract Restricted is Ownable {
271 
272     //MonethaAddress set event
273     event MonethaAddressSet(
274         address _address,
275         bool _isMonethaAddress
276     );
277 
278     mapping (address => bool) public isMonethaAddress;
279 
280     /**
281      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
282      */
283     modifier onlyMonetha() {
284         require(isMonethaAddress[msg.sender]);
285         _;
286     }
287 
288     /**
289      *  Allows owner to set new monetha address
290      */
291     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
292         isMonethaAddress[_address] = _isMonethaAddress;
293 
294         emit MonethaAddressSet(_address, _isMonethaAddress);
295     }
296 }
297 
298 // File: monetha-utility-contracts/contracts/ownership/CanReclaimEther.sol
299 
300 pragma solidity ^0.4.24;
301 
302 
303 contract CanReclaimEther is Ownable {
304     event ReclaimEther(address indexed to, uint256 amount);
305 
306     /**
307      * @dev Transfer all Ether held by the contract to the owner.
308      */
309     function reclaimEther() external onlyOwner {
310         uint256 value = address(this).balance;
311         owner.transfer(value);
312 
313         emit ReclaimEther(owner, value);
314     }
315 
316     /**
317      * @dev Transfer specified amount of Ether held by the contract to the address.
318      * @param _to The address which will receive the Ether
319      * @param _value The amount of Ether to transfer
320      */
321     function reclaimEtherTo(address _to, uint256 _value) external onlyOwner {
322         require(_to != address(0), "zero address is not allowed");
323         _to.transfer(_value);
324 
325         emit ReclaimEther(_to, _value);
326     }
327 }
328 
329 // File: monetha-utility-contracts/contracts/ownership/CanReclaimTokens.sol
330 
331 pragma solidity ^0.4.24;
332 
333 
334 
335 
336 contract CanReclaimTokens is Ownable {
337     using SafeERC20 for ERC20Basic;
338 
339     event ReclaimTokens(address indexed to, uint256 amount);
340 
341     /**
342      * @dev Reclaim all ERC20Basic compatible tokens
343      * @param _token ERC20Basic The address of the token contract
344      */
345     function reclaimToken(ERC20Basic _token) external onlyOwner {
346         uint256 balance = _token.balanceOf(this);
347         _token.safeTransfer(owner, balance);
348 
349         emit ReclaimTokens(owner, balance);
350     }
351 
352     /**
353      * @dev Reclaim specified amount of ERC20Basic compatible tokens
354      * @param _token ERC20Basic The address of the token contract
355      * @param _to The address which will receive the tokens
356      * @param _value The amount of tokens to transfer
357      */
358     function reclaimTokenTo(ERC20Basic _token, address _to, uint256 _value) external onlyOwner {
359         require(_to != address(0), "zero address is not allowed");
360         _token.safeTransfer(_to, _value);
361 
362         emit ReclaimTokens(_to, _value);
363     }
364 }
365 
366 // File: contracts/MonethaClaimHandler.sol
367 
368 pragma solidity ^0.4.24;
369 
370 
371 
372 
373 
374 
375 
376 
377 
378 /**
379  *  @title MonethaClaimHandler
380  *
381  *  MonethaClaimHandler handles claim creation, acceptance, resolution and confirmation.
382  */
383 contract MonethaClaimHandler is Restricted, Pausable, CanReclaimEther, CanReclaimTokens {
384     using SafeMath for uint256;
385     using SafeERC20 for ERC20;
386     using SafeERC20 for ERC20Basic;
387 
388     event MinStakeUpdated(uint256 previousMinStake, uint256 newMinStake);
389 
390     event ClaimCreated(uint256 indexed dealId, uint256 indexed claimIdx);
391     event ClaimAccepted(uint256 indexed dealId, uint256 indexed claimIdx);
392     event ClaimResolved(uint256 indexed dealId, uint256 indexed claimIdx);
393     event ClaimClosedAfterAcceptanceExpired(uint256 indexed dealId, uint256 indexed claimIdx);
394     event ClaimClosedAfterResolutionExpired(uint256 indexed dealId, uint256 indexed claimIdx);
395     event ClaimClosedAfterConfirmationExpired(uint256 indexed dealId, uint256 indexed claimIdx);
396     event ClaimClosed(uint256 indexed dealId, uint256 indexed claimIdx);
397 
398     ERC20 public token;      // token contract address
399     uint256 public minStake; // minimum amount of token units to create and accept claim
400 
401     // State of claim
402     enum State {
403         Null,
404         AwaitingAcceptance,
405         AwaitingResolution,
406         AwaitingConfirmation,
407         ClosedAfterAcceptanceExpired,
408         ClosedAfterResolutionExpired,
409         ClosedAfterConfirmationExpired,
410         Closed
411     }
412 
413     struct Claim {
414         State state;
415         uint256 modified;
416         uint256 dealId; // immutable after AwaitingAcceptance
417         bytes32 dealHash; // immutable after AwaitingAcceptance
418         string reasonNote; // immutable after AwaitingAcceptance
419         bytes32 requesterId; // immutable after AwaitingAcceptance
420         address requesterAddress; // immutable after AwaitingAcceptance
421         uint256 requesterStaked; // immutable after AwaitingAcceptance
422         bytes32 respondentId; // immutable after AwaitingAcceptance
423         address respondentAddress; // immutable after Accepted
424         uint256 respondentStaked; // immutable after Accepted
425         string resolutionNote; // immutable after Resolved
426     }
427 
428     Claim[] public claims;
429 
430     constructor(ERC20 _token, uint256 _minStake) public {
431         require(_token != address(0), "must be valid token address");
432 
433         token = _token;
434         _setMinStake(_minStake);
435     }
436 
437     /**
438      * @dev sets the minimum amount of tokens units to stake when creating or accepting the claim.
439      * Only Monetha account allowed to call this method.
440      */
441     function setMinStake(uint256 _newMinStake) external whenNotPaused onlyMonetha {
442         _setMinStake(_newMinStake);
443     }
444 
445     /**
446      * @dev returns the number of claims created.
447      */
448     function getClaimsCount() public constant returns (uint256 count) {
449         return claims.length;
450     }
451 
452     /**
453     * @dev creates new claim using provided parameters. Before calling this method, requester should approve
454     * this contract to transfer min. amount of token units in their behalf, by calling
455     * `approve(address _spender, uint _value)` method of token contract.
456     * Respondent should accept the claim by calling accept() method.
457     * claimIdx should be extracted from ClaimCreated event.
458     *
459     * Claim state after call 🡒 AwaitingAcceptance
460     */
461     function create(
462         uint256 _dealId,
463         bytes32 _dealHash,
464         string _reasonNote,
465         bytes32 _requesterId,
466         bytes32 _respondentId,
467         uint256 _amountToStake
468     ) external whenNotPaused {
469         require(bytes(_reasonNote).length > 0, "reason note must not be empty");
470         require(_dealHash != bytes32(0), "deal hash must be non-zero");
471         require(_requesterId != bytes32(0), "requester ID must be non-zero");
472         require(_respondentId != bytes32(0), "respondent ID must be non-zero");
473         require(keccak256(abi.encodePacked(_requesterId)) != keccak256(abi.encodePacked(_respondentId)),
474             "requester and respondent must be different");
475         require(_amountToStake >= minStake, "amount to stake must be greater or equal to min.stake");
476 
477         uint256 requesterAllowance = token.allowance(msg.sender, address(this));
478         require(requesterAllowance >= _amountToStake, "allowance too small");
479         token.safeTransferFrom(msg.sender, address(this), _amountToStake);
480 
481         Claim memory claim = Claim({
482             state : State.AwaitingAcceptance,
483             modified : now,
484             dealId : _dealId,
485             dealHash : _dealHash,
486             reasonNote : _reasonNote,
487             requesterId : _requesterId,
488             requesterAddress : msg.sender,
489             requesterStaked : _amountToStake,
490             respondentId : _respondentId,
491             respondentAddress : address(0),
492             respondentStaked : 0,
493             resolutionNote : ""
494             });
495         claims.push(claim);
496 
497         emit ClaimCreated(_dealId, claims.length - 1);
498     }
499 
500     /**
501      * @dev accepts the claim by respondent. Before calling this method, respondent should approve
502      * this contract to transfer min. amount of token units in their behalf, by calling
503      * `approve(address _spender, uint _value)` method of token contract. Respondent must stake the same amount
504      * of tokens as requester.
505      *
506      * Claim state after call 🡒 AwaitingResolution (if was AwaitingAcceptance)
507      */
508     function accept(uint256 _claimIdx) external whenNotPaused {
509         require(_claimIdx < claims.length, "invalid claim index");
510         Claim storage claim = claims[_claimIdx];
511         require(State.AwaitingAcceptance == claim.state, "State.AwaitingAcceptance required");
512         require(msg.sender != claim.requesterAddress, "requester and respondent addresses must be different");
513 
514         uint256 requesterStaked = claim.requesterStaked;
515         token.safeTransferFrom(msg.sender, address(this), requesterStaked);
516 
517         claim.state = State.AwaitingResolution;
518         claim.modified = now;
519         claim.respondentAddress = msg.sender;
520         claim.respondentStaked = requesterStaked;
521 
522         emit ClaimAccepted(claim.dealId, _claimIdx);
523     }
524 
525     /**
526      * @dev resolves the claim by respondent. Respondent will get staked amount of tokens back.
527      *
528      * Claim state after call 🡒 AwaitingConfirmation (if was AwaitingResolution)
529      */
530     function resolve(uint256 _claimIdx, string _resolutionNote) external whenNotPaused {
531         require(_claimIdx < claims.length, "invalid claim index");
532         require(bytes(_resolutionNote).length > 0, "resolution note must not be empty");
533         Claim storage claim = claims[_claimIdx];
534         require(State.AwaitingResolution == claim.state, "State.AwaitingResolution required");
535         require(msg.sender == claim.respondentAddress, "awaiting respondent");
536 
537         uint256 respStakedBefore = claim.respondentStaked;
538 
539         claim.state = State.AwaitingConfirmation;
540         claim.modified = now;
541         claim.respondentStaked = 0;
542         claim.resolutionNote = _resolutionNote;
543 
544         token.safeTransfer(msg.sender, respStakedBefore);
545 
546         emit ClaimResolved(claim.dealId, _claimIdx);
547     }
548 
549     /**
550      * @dev closes the claim by requester.
551      * Requester allowed to call this method 72 hours after call to create() or accept(), and immediately after resolve().
552      * Requester will get staked amount of tokens back. Requester will also get the respondent’s tokens if
553      * the respondent did not call the resolve() method within 72 hours.
554      *
555      * Claim state after call 🡒 Closed                         (if was AwaitingConfirmation, and less than 24 hours passed)
556      *                        🡒 ClosedAfterConfirmationExpired (if was AwaitingConfirmation, after 24 hours)
557      *                        🡒 ClosedAfterAcceptanceExpired   (if was AwaitingAcceptance, after 72 hours)
558      *                        🡒 ClosedAfterResolutionExpired   (if was AwaitingResolution, after 72 hours)
559      */
560     function close(uint256 _claimIdx) external whenNotPaused {
561         require(_claimIdx < claims.length, "invalid claim index");
562         State state = claims[_claimIdx].state;
563 
564         if (State.AwaitingAcceptance == state) {
565             return _closeAfterAwaitingAcceptance(_claimIdx);
566         } else if (State.AwaitingResolution == state) {
567             return _closeAfterAwaitingResolution(_claimIdx);
568         } else if (State.AwaitingConfirmation == state) {
569             return _closeAfterAwaitingConfirmation(_claimIdx);
570         }
571 
572         revert("claim.State");
573     }
574 
575     function _closeAfterAwaitingAcceptance(uint256 _claimIdx) internal {
576         Claim storage claim = claims[_claimIdx];
577         require(msg.sender == claim.requesterAddress, "awaiting requester");
578         require(State.AwaitingAcceptance == claim.state, "State.AwaitingAcceptance required");
579         require(_hoursPassed(claim.modified, 72), "expiration required");
580 
581         uint256 stakedBefore = claim.requesterStaked;
582 
583         claim.state = State.ClosedAfterAcceptanceExpired;
584         claim.modified = now;
585         claim.requesterStaked = 0;
586 
587         token.safeTransfer(msg.sender, stakedBefore);
588 
589         emit ClaimClosedAfterAcceptanceExpired(claim.dealId, _claimIdx);
590     }
591 
592     function _closeAfterAwaitingResolution(uint256 _claimIdx) internal {
593         Claim storage claim = claims[_claimIdx];
594         require(State.AwaitingResolution == claim.state, "State.AwaitingResolution required");
595         require(_hoursPassed(claim.modified, 72), "expiration required");
596         require(msg.sender == claim.requesterAddress, "awaiting requester");
597 
598         uint256 totalStaked = claim.requesterStaked.add(claim.respondentStaked);
599 
600         claim.state = State.ClosedAfterResolutionExpired;
601         claim.modified = now;
602         claim.requesterStaked = 0;
603         claim.respondentStaked = 0;
604 
605         token.safeTransfer(msg.sender, totalStaked);
606 
607         emit ClaimClosedAfterResolutionExpired(claim.dealId, _claimIdx);
608     }
609 
610     function _closeAfterAwaitingConfirmation(uint256 _claimIdx) internal {
611         Claim storage claim = claims[_claimIdx];
612         require(msg.sender == claim.requesterAddress, "awaiting requester");
613         require(State.AwaitingConfirmation == claim.state, "State.AwaitingConfirmation required");
614 
615         bool expired = _hoursPassed(claim.modified, 24);
616         if (expired) {
617             claim.state = State.ClosedAfterConfirmationExpired;
618         } else {
619             claim.state = State.Closed;
620         }
621         claim.modified = now;
622 
623         uint256 stakedBefore = claim.requesterStaked;
624         claim.requesterStaked = 0;
625 
626         token.safeTransfer(msg.sender, stakedBefore);
627 
628         if (expired) {
629             emit ClaimClosedAfterConfirmationExpired(claim.dealId, _claimIdx);
630         } else {
631             emit ClaimClosed(claim.dealId, _claimIdx);
632         }
633     }
634 
635     function _hoursPassed(uint256 start, uint256 hoursAfter) internal view returns (bool) {
636         return now >= start + hoursAfter * 1 hours;
637     }
638 
639     function _setMinStake(uint256 _newMinStake) internal {
640         uint256 previousMinStake = minStake;
641         if (previousMinStake != _newMinStake) {
642             emit MinStakeUpdated(previousMinStake, _newMinStake);
643             minStake = _newMinStake;
644         }
645     }
646 }