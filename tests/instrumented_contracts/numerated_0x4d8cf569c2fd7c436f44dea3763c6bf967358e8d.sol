1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ReentrancyGuard {
46 
47   /**
48    * @dev We use a single lock for the whole contract.
49    */
50   bool private reentrancy_lock = false;
51 
52   /**
53    * @dev Prevents a contract from calling itself, directly or indirectly.
54    * @notice If you mark a function `nonReentrant`, you should also
55    * mark it `external`. Calling one nonReentrant function from
56    * another is not supported. Instead, you can implement a
57    * `private` function doing the actual work, and a `external`
58    * wrapper marked as `nonReentrant`.
59    */
60   modifier nonReentrant() {
61     require(!reentrancy_lock);
62     reentrancy_lock = true;
63     _;
64     reentrancy_lock = false;
65   }
66 
67 }
68 
69 contract Multiowned {
70 
71     // TYPES
72 
73     // struct for the status of a pending operation.
74     struct PendingState {
75         uint yetNeeded;
76         uint ownersDone;
77         uint index;
78     }
79 
80     // EVENTS
81 
82     // this contract only has five types of events: it can accept a confirmation, in which case
83     // we record owner and operation (hash) alongside it.
84     event Confirmation(address owner, bytes32 operation);
85     event Revoke(address owner, bytes32 operation);
86     // some others are in the case of an owner changing.
87     event OwnerChanged(address oldOwner, address newOwner);
88     event OwnerAdded(address newOwner);
89     event OwnerRemoved(address oldOwner);
90     // the last one is emitted if the required signatures change
91     event RequirementChanged(uint newRequirement);
92 
93     // MODIFIERS
94 
95     // simple single-sig function modifier.
96     modifier onlyowner {
97         if (isOwner(msg.sender))
98             _;
99     }
100 
101     // multi-sig function modifier: the operation must have an intrinsic hash in order
102     // that later attempts can be realised as the same underlying operation and
103     // thus count as confirmations.
104     modifier onlymanyowners(bytes32 _operation) {
105         if (confirmAndCheck(_operation))
106             _;
107     }
108 
109     // METHODS
110 
111     // constructor is given number of sigs required to do protected "onlymanyowners" transactions
112     // as well as the selection of addresses capable of confirming them.
113     function Multiowned(address[] _owners, uint _required) public {
114         m_numOwners = _owners.length;
115         m_chiefOwnerIndexBit = 2**1;
116         for (uint i = 0; i < m_numOwners; i++) {
117             m_owners[1 + i] = _owners[i];
118             m_ownerIndex[uint(_owners[i])] = 1 + i;
119         }
120         m_required = _required;
121     }
122     
123     // Revokes a prior confirmation of the given operation
124     function revoke(bytes32 _operation) external {
125         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
126         // make sure they're an owner
127         if (ownerIndex == 0) {
128             return;
129         }
130         uint ownerIndexBit = 2**ownerIndex;
131         var pending = m_pending[_operation];
132         if (pending.ownersDone & ownerIndexBit > 0) {
133             pending.yetNeeded++;
134             pending.ownersDone -= ownerIndexBit;
135             Revoke(msg.sender, _operation);
136         }
137     }
138     
139     // Replaces an owner `_from` with another `_to`.
140     function changeOwner(address _from, address _to) onlymanyowners(sha3(msg.data)) external {
141         uint ownerIndex = m_ownerIndex[uint(_from)];
142         if (isOwner(_to) || ownerIndex == 0) {
143             return;
144         }
145 
146         clearPending();
147         m_owners[ownerIndex] = _to;
148         m_ownerIndex[uint(_from)] = 0;
149         m_ownerIndex[uint(_to)] = ownerIndex;
150         OwnerChanged(_from, _to);
151     }
152     
153     function addOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
154         if (isOwner(_owner)) {
155             return;
156         }
157 
158         if (m_numOwners >= c_maxOwners) {
159             clearPending();
160             reorganizeOwners();
161         }
162         require(m_numOwners < c_maxOwners);
163         m_numOwners++;
164         m_owners[m_numOwners] = _owner;
165         m_ownerIndex[uint(_owner)] = m_numOwners;
166         OwnerAdded(_owner);
167     }
168     
169     function removeOwner(address _owner) onlymanyowners(sha3(msg.data)) external {
170         uint ownerIndex = m_ownerIndex[uint(_owner)];
171         if (ownerIndex == 0 || m_required > m_numOwners - 1) {
172             return;
173         }
174 
175         m_owners[ownerIndex] = 0;
176         m_ownerIndex[uint(_owner)] = 0;
177         clearPending();
178         reorganizeOwners(); //make sure m_numOwner is equal to the number of owners and always points to the optimal free slot
179         OwnerRemoved(_owner);
180     }
181     
182     function changeRequirement(uint _newRequired) onlymanyowners(sha3(msg.data)) external {
183         if (_newRequired > m_numOwners) {
184             return;
185         }
186         m_required = _newRequired;
187         clearPending();
188         RequirementChanged(_newRequired);
189     }
190     
191     function isOwner(address _addr) internal view returns (bool) {
192         return m_ownerIndex[uint(_addr)] > 0;
193     }
194     
195     function hasConfirmed(bytes32 _operation, address _owner) public view returns (bool) {
196         var pending = m_pending[_operation];
197         uint ownerIndex = m_ownerIndex[uint(_owner)];
198 
199         // make sure they're an owner
200         if (ownerIndex == 0) {
201             return false;
202         }
203 
204         // determine the bit to set for this owner.
205         uint ownerIndexBit = 2**ownerIndex;
206         if (pending.ownersDone & ownerIndexBit == 0) {
207             return false;
208         } else {
209             return true;
210         }
211     }
212     
213     // INTERNAL METHODS
214 
215     function confirmAndCheck(bytes32 _operation) internal returns (bool) {
216         // determine what index the present sender is:
217         uint ownerIndex = m_ownerIndex[uint(msg.sender)];
218         // make sure they're an owner
219         require(ownerIndex != 0);
220 
221         var pending = m_pending[_operation];
222         // if we're not yet working on this operation, switch over and reset the confirmation status.
223         if (pending.yetNeeded == 0) {
224             // reset count of confirmations needed.
225             pending.yetNeeded = c_maxOwners + m_required;
226             // reset which owners have confirmed (none) - set our bitmap to 0.
227             pending.ownersDone = 0;
228             pending.index = m_pendingIndex.length++;
229             m_pendingIndex[pending.index] = _operation;
230         }
231         // determine the bit to set for this owner.
232         uint ownerIndexBit = 2**ownerIndex;
233         // make sure we (the message sender) haven't confirmed this operation previously.
234         if (pending.ownersDone & ownerIndexBit == 0) {
235             Confirmation(msg.sender, _operation);
236             // ok - check if count is enough to go ahead and chief owner confirmed operation.
237             if ((pending.yetNeeded <= c_maxOwners + 1) && ((pending.ownersDone & m_chiefOwnerIndexBit != 0) || (ownerIndexBit == m_chiefOwnerIndexBit))) {
238                 // enough confirmations: reset and run interior.
239                 delete m_pendingIndex[m_pending[_operation].index];
240                 delete m_pending[_operation];
241                 return true;
242             } else {
243                 // not enough: record that this owner in particular confirmed.
244                 pending.yetNeeded--;
245                 pending.ownersDone |= ownerIndexBit;
246             }
247         }
248     }
249 
250     function reorganizeOwners() private returns (bool) {
251         uint free = 1;
252         while (free < m_numOwners) {
253             while (free < m_numOwners && m_owners[free] != 0) {
254                 free++;
255             }
256             while (m_numOwners > 1 && m_owners[m_numOwners] == 0) {
257                 m_numOwners--;
258             }
259             if (free < m_numOwners && m_owners[m_numOwners] != 0 && m_owners[free] == 0) {
260                 m_owners[free] = m_owners[m_numOwners];
261                 m_ownerIndex[uint(m_owners[free])] = free;
262                 m_owners[m_numOwners] = 0;
263             }
264         }
265     }
266     
267     function clearPending() internal {
268         uint length = m_pendingIndex.length;
269         for (uint i = 0; i < length; ++i) {
270             if (m_pendingIndex[i] != 0) {
271                 delete m_pending[m_pendingIndex[i]];
272             }
273         }
274         delete m_pendingIndex;
275     }
276         
277     // FIELDS
278 
279     // the number of owners that must confirm the same operation before it is run.
280     uint public m_required;
281     // pointer used to find a free slot in m_owners
282     uint public m_numOwners;
283     
284     // list of owners
285     address[8] public m_owners;
286     uint public m_chiefOwnerIndexBit;
287     uint constant c_maxOwners = 7;
288     // index on the list of owners to allow reverse lookup
289     mapping(uint => uint) public m_ownerIndex;
290     // the ongoing operations.
291     mapping(bytes32 => PendingState) public m_pending;
292     bytes32[] public m_pendingIndex;
293 }
294 
295 contract AlphaMarketICO is Multiowned, ReentrancyGuard {
296     using SafeMath for uint256;
297     enum State { DEFINED, IN_PROGRESS_TOKEN_FREEZE, IN_PROGRESS, FAILED, SUCCEEDED }
298 
299     event EtherTransfered(address indexed to, uint value);
300     event StateUpdated(State state);
301     event InvestmentProcessed(address from, uint value);
302 
303     function AlphaMarketICO(address[] _owners) Multiowned(_owners, _owners.length - 1) public {}
304 
305     function setToken(address _token) external onlyowner {
306         require(address(token) == 0x0);
307         require(address(_token) != 0x0);
308         token = AlphaMarketCoin(_token);
309         tokensToSold = token.totalSupply().mul(60).div(100);
310     }
311 
312     function setExchanger(address _exchanger) external onlyowner {
313         require(_exchanger != 0x0 && exchanger == 0x0);
314         exchanger = _exchanger;
315     }
316 
317     function sendTokensToBountyWallet(address _bountyWallet) external onlyowner {
318         require(!isBountySent && _bountyWallet != 0x0);
319 
320         token.addEarlyAccessAddress(_bountyWallet);
321         uint256 tokensForBounty = token.totalSupply().mul(20).div(100);
322         token.transfer(_bountyWallet, tokensForBounty);
323         isBountySent = true;
324     }
325     
326 
327     modifier processState {
328         updateState();
329         _;
330     }
331 
332     modifier icoInProgress {
333         require((icoState == State.IN_PROGRESS || icoState == State.IN_PROGRESS_TOKEN_FREEZE) && currentTime() < endTime);
334         _;
335     }
336 
337     function updateState() public {
338         uint currTime = currentTime();
339         
340         if (icoState == State.IN_PROGRESS_TOKEN_FREEZE || icoState == State.IN_PROGRESS) {
341             if (icoState == State.IN_PROGRESS_TOKEN_FREEZE) {
342                 if (currTime >= tokenUnfreezeTime) {
343                     token.enableTransfering();
344                     icoState = State.IN_PROGRESS;
345                     emit StateUpdated(icoState);
346                 }
347             }
348             if (currTime >= endTime || totalInvestment >= hardCap || totalSold >= tokensToSold) {
349                 token.transfer(exchanger, token.balanceOf(this));
350                 icoState = State.SUCCEEDED;
351                 emit StateUpdated(icoState);
352             }
353         } else if (icoState == State.DEFINED) {
354             if (currTime >= startTime) {
355                 icoState = State.IN_PROGRESS_TOKEN_FREEZE;
356                 emit StateUpdated(icoState);
357             }
358         }
359     }
360 
361     function rewardContributors(address[] _contributors, uint256[] _tokenAmounts) external onlymanyowners(sha3(msg.data)) {
362         if(isContributorsRewarded || _contributors.length != _tokenAmounts.length) {
363             return;
364         }
365 
366         uint256 sum = 0;
367         for (uint64 i = 0; i < _contributors.length; i++) {
368             require(_contributors[i] != 0x0);
369             sum = sum.add(_tokenAmounts[i]);
370             token.transfer(_contributors[i], _tokenAmounts[i]);
371         }
372         require(sum == token.totalSupply().mul(20).div(100));
373         isContributorsRewarded = true;
374     }
375 
376     function getTokensCountPerEther() internal view returns (uint256) {
377         uint currTime = currentTime();
378         require(currTime >= startTime);
379 
380         if (currTime < startTime + 1 weeks) {return  27778;}
381         if (currTime < startTime + 2 weeks) {return  25000;}
382         if (currTime < startTime + 3 weeks) {return  22727;}
383         if (currTime < startTime + 4 weeks) {return  20833;}
384         if (currTime < startTime + 5 weeks) {return  19230;}
385         if (currTime < startTime + 6 weeks) {return  17857;}
386         if (currTime < startTime + 7 weeks) {return  16667;}
387         if (currTime < startTime + 8 weeks) {return  15625;}
388         if (currTime < startTime + 9 weeks) {return  14706;}
389         if (currTime < startTime + 10 weeks) {return 13889;}
390         if (currTime < startTime + 11 weeks) {return 13158;}
391         if (currTime < startTime + 12 weeks) {return 12500;}
392         if (currTime < endTime) {return              12500;}
393     }
394 
395     function getBonus() internal view returns (uint) {
396         uint currTime = currentTime();
397         require(currTime >= startTime);
398 
399         if (currTime < startTime + 1 weeks) {return  20;}
400         if (currTime < startTime + 2 weeks) {return  18;}
401         if (currTime < startTime + 3 weeks) {return  16;}
402         if (currTime < startTime + 4 weeks) {return  14;}
403         if (currTime < startTime + 5 weeks) {return  12;}
404         if (currTime < startTime + 6 weeks) {return  10;}
405         if (currTime < startTime + 7 weeks) {return  8;}
406         if (currTime < startTime + 8 weeks) {return  6;}
407         if (currTime < startTime + 9 weeks) {return  4;}
408         if (currTime < startTime + 10 weeks) {return 3;}
409         if (currTime < startTime + 11 weeks) {return 2;}
410         if (currTime < startTime + 12 weeks) {return 1;}
411         if (currTime < endTime) {return              0;}
412     }
413 
414     function processInvestment(address investor, uint256 value, address referrer) internal processState icoInProgress {
415         require(value >= minInvestment && value <= maxInvestment);
416         uint256 tokensCount = uint256(value).mul(getTokensCountPerEther());
417 
418         // Add bonus tokens
419         uint256 tokensSold = tokensCount.add(tokensCount.mul(getBonus()).div(100));
420         token.transfer(investor, tokensSold);
421 
422         if (referrer != 0x0) {
423             require(referrer != investor);
424             uint256 tokensForReferrer = tokensCount.mul(5).div(100);
425             token.transfer(referrer, tokensForReferrer);
426             tokensSold = tokensSold.add(tokensForReferrer);
427         }
428 
429         investments[investor] = investments[investor].add(value);
430         totalInvestment = totalInvestment.add(value);
431         totalSold = totalSold.add(tokensSold);
432         emit InvestmentProcessed(investor, value);
433     }
434 
435     function buyTokensWithRef(address referrer) public payable {
436         processInvestment(msg.sender, msg.value, referrer);
437     }
438 
439     function buyTokens() public payable {
440         processInvestment(msg.sender, msg.value, 0x0);
441     }
442     
443     function() external payable {
444         require(0 == msg.data.length);
445         buyTokens();
446     }
447 
448     function transferEther(address to, uint value) external nonReentrant onlymanyowners(sha3(msg.data)) {
449         if(value == 0 || this.balance < value || to == 0x0){
450             return;
451         }
452         to.transfer(value);
453         EtherTransfered(to, value);
454     }
455 
456     function failICO() external onlymanyowners(sha3(msg.data)) {
457         icoState = State.FAILED;
458         emit StateUpdated(icoState);
459     }
460 
461     function withdrawRefund() external nonReentrant {
462         require(icoState == State.FAILED);
463 
464         uint256 investment = investments[msg.sender];
465         require(investment > 0 && this.balance >= investment);
466 
467         totalInvestment = totalInvestment.sub(investment);
468         investments[msg.sender] = 0;
469         msg.sender.transfer(investment);
470     }
471 
472     function currentTime() internal view returns (uint) {
473         return now;
474     }
475 
476     uint public startTime = 1523880000; // Unix epoch timestamp. Wednesday, April 16, 2018 12:00:00 PM
477     uint public tokenUnfreezeTime = startTime + 12 weeks;
478     uint public endTime = startTime + 24 weeks; 
479     uint public hardCap = 48000 ether;
480     uint public minInvestment = 10 finney;
481     uint public maxInvestment = hardCap;
482     uint public tokensToSold;
483     State public icoState = State.DEFINED;
484 
485     mapping(address => uint256) public investments;
486     uint256 public totalInvestment = 0;
487     uint256 public totalSold = 0;
488 
489     bool public isContributorsRewarded = false;
490     bool public isBountySent = false;
491     AlphaMarketCoin public token;
492     address public exchanger;
493 }
494 
495 contract ERC20Basic {
496   function totalSupply() public view returns (uint256);
497   function balanceOf(address who) public view returns (uint256);
498   function transfer(address to, uint256 value) public returns (bool);
499   event Transfer(address indexed from, address indexed to, uint256 value);
500 }
501 
502 contract BasicToken is ERC20Basic {
503   using SafeMath for uint256;
504 
505   mapping(address => uint256) balances;
506 
507   uint256 totalSupply_;
508 
509   /**
510   * @dev total number of tokens in existence
511   */
512   function totalSupply() public view returns (uint256) {
513     return totalSupply_;
514   }
515 
516   /**
517   * @dev transfer token for a specified address
518   * @param _to The address to transfer to.
519   * @param _value The amount to be transferred.
520   */
521   function transfer(address _to, uint256 _value) public returns (bool) {
522     require(_to != address(0));
523     require(_value <= balances[msg.sender]);
524 
525     // SafeMath.sub will throw if there is not enough balance.
526     balances[msg.sender] = balances[msg.sender].sub(_value);
527     balances[_to] = balances[_to].add(_value);
528     Transfer(msg.sender, _to, _value);
529     return true;
530   }
531 
532   /**
533   * @dev Gets the balance of the specified address.
534   * @param _owner The address to query the the balance of.
535   * @return An uint256 representing the amount owned by the passed address.
536   */
537   function balanceOf(address _owner) public view returns (uint256 balance) {
538     return balances[_owner];
539   }
540 
541 }
542 
543 contract ERC20 is ERC20Basic {
544   function allowance(address owner, address spender) public view returns (uint256);
545   function transferFrom(address from, address to, uint256 value) public returns (bool);
546   function approve(address spender, uint256 value) public returns (bool);
547   event Approval(address indexed owner, address indexed spender, uint256 value);
548 }
549 
550 contract StandardToken is ERC20, BasicToken {
551 
552   mapping (address => mapping (address => uint256)) internal allowed;
553 
554 
555   /**
556    * @dev Transfer tokens from one address to another
557    * @param _from address The address which you want to send tokens from
558    * @param _to address The address which you want to transfer to
559    * @param _value uint256 the amount of tokens to be transferred
560    */
561   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
562     require(_to != address(0));
563     require(_value <= balances[_from]);
564     require(_value <= allowed[_from][msg.sender]);
565 
566     balances[_from] = balances[_from].sub(_value);
567     balances[_to] = balances[_to].add(_value);
568     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
569     Transfer(_from, _to, _value);
570     return true;
571   }
572 
573   /**
574    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
575    *
576    * Beware that changing an allowance with this method brings the risk that someone may use both the old
577    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
578    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
579    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
580    * @param _spender The address which will spend the funds.
581    * @param _value The amount of tokens to be spent.
582    */
583   function approve(address _spender, uint256 _value) public returns (bool) {
584     allowed[msg.sender][_spender] = _value;
585     Approval(msg.sender, _spender, _value);
586     return true;
587   }
588 
589   /**
590    * @dev Function to check the amount of tokens that an owner allowed to a spender.
591    * @param _owner address The address which owns the funds.
592    * @param _spender address The address which will spend the funds.
593    * @return A uint256 specifying the amount of tokens still available for the spender.
594    */
595   function allowance(address _owner, address _spender) public view returns (uint256) {
596     return allowed[_owner][_spender];
597   }
598 
599   /**
600    * @dev Increase the amount of tokens that an owner allowed to a spender.
601    *
602    * approve should be called when allowed[_spender] == 0. To increment
603    * allowed value is better to use this function to avoid 2 calls (and wait until
604    * the first transaction is mined)
605    * From MonolithDAO Token.sol
606    * @param _spender The address which will spend the funds.
607    * @param _addedValue The amount of tokens to increase the allowance by.
608    */
609   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
610     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
611     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
612     return true;
613   }
614 
615   /**
616    * @dev Decrease the amount of tokens that an owner allowed to a spender.
617    *
618    * approve should be called when allowed[_spender] == 0. To decrement
619    * allowed value is better to use this function to avoid 2 calls (and wait until
620    * the first transaction is mined)
621    * From MonolithDAO Token.sol
622    * @param _spender The address which will spend the funds.
623    * @param _subtractedValue The amount of tokens to decrease the allowance by.
624    */
625   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
626     uint oldValue = allowed[msg.sender][_spender];
627     if (_subtractedValue > oldValue) {
628       allowed[msg.sender][_spender] = 0;
629     } else {
630       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
631     }
632     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
633     return true;
634   }
635 
636 }
637 
638 contract AlphaMarketCoin is StandardToken {
639 
640     function AlphaMarketCoin(address _controller) public {
641         controller = _controller;
642         earlyAccess[_controller] = true;
643         totalSupply_ = 999999999 * 10 ** uint256(decimals);
644         balances[_controller] = totalSupply_;
645     }
646 
647     modifier onlyController {
648         require(msg.sender == controller);
649         _;
650     }
651 
652     // Transfering should be enabled by ICO contract only when half of ICO is passed
653     event TransferEnabled();
654 
655     function addEarlyAccessAddress(address _address) external onlyController {
656         require(_address != 0x0);
657         earlyAccess[_address] = true;
658     }
659 
660     function transfer(address _to, uint256 _value) public returns (bool) {
661         require(isTransferEnabled || earlyAccess[msg.sender]);
662         return super.transfer(_to, _value);
663     }
664 
665     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
666         require(isTransferEnabled);
667         return super.transferFrom(_from, _to, _value);
668     }
669 
670     function approve(address _spender, uint256 _value) public returns (bool) {
671         require(isTransferEnabled);
672         return super.approve(_spender, _value);
673     }
674     
675     function enableTransfering() public onlyController {
676         require(!isTransferEnabled);
677 
678         isTransferEnabled = true;
679         emit TransferEnabled();
680     }
681 
682     // Prevent sending ether to this address
683     function () public payable {
684         revert();
685     }
686 
687     bool public isTransferEnabled = false;
688     address public controller;
689     mapping(address => bool) public earlyAccess;
690 
691     uint8 public constant decimals = 18;
692     string public constant name = 'AlphaMarket Coin';
693     string public constant symbol = 'AMC';
694 }