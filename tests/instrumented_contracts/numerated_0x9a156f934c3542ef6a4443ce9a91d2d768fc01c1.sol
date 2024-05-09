1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8 
9     /**
10     * @dev Subtracts two numbers, reverts on overflow.
11     */
12     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
13         assert(y <= x);
14         uint256 z = x - y;
15         return z;
16     }
17 
18     /**
19     * @dev Adds two numbers, reverts on overflow.
20     */
21     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
22         uint256 z = x + y;
23         assert(z >= x);
24         return z;
25     }
26 	
27 	/**
28     * @dev Integer division of two numbers, reverts on division by zero.
29     */
30     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
31         uint256 z = x / y;
32         return z;
33     }
34     
35     /**
36     * @dev Multiplies two numbers, reverts on overflow.
37     */	
38     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {    
39         if (x == 0) {
40             return 0;
41         }
42     
43         uint256 z = x * y;
44         assert(z / x == y);
45         return z;
46     }
47 
48     /**
49     * @dev Returns the integer percentage of the number.
50     */
51     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
52         if (x == 0) {
53             return 0;
54         }
55         
56         uint256 z = x * y;
57         assert(z / x == y);    
58         z = z / 10000; // percent to hundredths
59         return z;
60     }
61 
62     /**
63     * @dev Returns the minimum value of two numbers.
64     */	
65     function min(uint256 x, uint256 y) internal pure returns (uint256) {
66         uint256 z = x <= y ? x : y;
67         return z;
68     }
69 
70     /**
71     * @dev Returns the maximum value of two numbers.
72     */
73     function max(uint256 x, uint256 y) internal pure returns (uint256) {
74         uint256 z = x >= y ? x : y;
75         return z;
76     }
77 }
78 
79 
80 /**
81  * @title DAppDEXI - Interface 
82  */
83 interface DAppDEXI {
84 
85     function updateAgent(address _agent, bool _status) external;
86 
87     function setAccountType(address user_, uint256 type_) external;
88     function getAccountType(address user_) external view returns(uint256);
89     function setFeeType(uint256 type_ , uint256 feeMake_, uint256 feeTake_) external;
90     function getFeeMake(uint256 type_ ) external view returns(uint256);
91     function getFeeTake(uint256 type_ ) external view returns(uint256);
92     function changeFeeAccount(address feeAccount_) external;
93     
94     function setWhitelistTokens(address token) external;
95     function setWhitelistTokens(address token, bool active, uint256 timestamp, bytes32 typeERC) external;
96     function depositToken(address token, uint amount) external;
97     function tokenFallback(address owner, uint256 amount, bytes data) external returns (bool success);
98 
99     function withdraw(uint amount) external;
100     function withdrawToken(address token, uint amount) external;
101 
102     function balanceOf(address token, address user) external view returns (uint);
103 
104     function order(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce) external;
105     function trade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) external;    
106     function cancelOrder(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) external;
107     function testTrade(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) external view returns(bool);
108     function availableVolume(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) external view returns(uint);
109     function amountFilled(address tokenBuy, uint amountBuy, address tokenSell, uint amountSell, uint expires, uint nonce, address user) external view returns(uint);
110 }
111 
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 interface ERC20I {
118 
119   function balanceOf(address _owner) external view returns (uint256);
120 
121   function totalSupply() external view returns (uint256);
122   function transfer(address _to, uint256 _value) external returns (bool success);
123   
124   function allowance(address _owner, address _spender) external view returns (uint256);
125   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
126   function approve(address _spender, uint256 _value) external returns (bool success);
127   
128   event Transfer(address indexed from, address indexed to, uint256 value);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * @title Ownable contract - base contract with an owner
135  */
136 contract Ownable {
137   
138   address public owner;
139   address public newOwner;
140 
141   event OwnershipTransferred(address indexed _from, address indexed _to);
142   
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   constructor() public {
148     owner = msg.sender;
149   }
150 
151   /**
152    * @dev Throws if called by any account other than the owner.
153    */
154   modifier onlyOwner() {
155     assert(msg.sender == owner);
156     _;
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param _newOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address _newOwner) public onlyOwner {
164     assert(_newOwner != address(0));      
165     newOwner = _newOwner;
166   }
167 
168   /**
169    * @dev Accept transferOwnership.
170    */
171   function acceptOwnership() public {
172     if (msg.sender == newOwner) {
173       emit OwnershipTransferred(owner, newOwner);
174       owner = newOwner;
175     }
176   }
177 }
178 
179 
180 /**
181  * @title SDADI - Interface
182  */
183 interface SDADI  {	
184   function AddToken(address token) external;
185   function DelToken(address token) external;
186 }
187 
188 
189 /**
190  * @title Standard ERC20 token + balance on date
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20 
193  */
194 contract ERC20Base is ERC20I, SafeMath {
195 	
196   uint256 totalSupply_;
197   mapping (address => uint256) balances;
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200   uint256 public start = 0;               // Must be equal to the date of issue tokens
201   uint256 public period = 30 days;        // By default, the dividend accrual period is 30 days
202   mapping (address => mapping (uint256 => int256)) public ChangeOverPeriod;
203 
204   address[] public owners;
205   mapping (address => bool) public ownersIndex;
206 
207   struct _Prop {
208     uint propID;          // proposal ID in DAO    
209     uint endTime;         // end time of voting
210   }
211   
212   _Prop[] public ActiveProposals;  // contains active proposals
213 
214   // contains voted Tokens on proposals
215   mapping (uint => mapping (address => uint)) public voted;
216 
217   /** 
218    * @dev Total Supply
219    * @return totalSupply_ 
220    */  
221   function totalSupply() public view returns (uint256) {
222     return totalSupply_;
223   }
224   
225   /** 
226    * @dev Tokens balance
227    * @param _owner holder address
228    * @return balance amount 
229    */
230   function balanceOf(address _owner) public view returns (uint256) {
231     return balances[_owner];
232   }
233 
234   /** 
235    * @dev Balance of tokens on date
236    * @param _owner holder address
237    * @return balance amount 
238    */
239   function balanceOf(address _owner, uint _date) public view returns (uint256) {
240     require(_date >= start);
241     uint256 N1 = (_date - start) / period + 1;    
242 
243     uint256 N2 = 1;
244     if (block.timestamp > start) {
245       N2 = (block.timestamp - start) / period + 1;
246     }
247 
248     require(N2 >= N1);
249 
250     int256 B = int256(balances[_owner]);
251 
252     while (N2 > N1) {
253       B = B - ChangeOverPeriod[_owner][N2];
254       N2--;
255     }
256 
257     require(B >= 0);
258     return uint256(B);
259   }
260 
261   /** 
262    * @dev Tranfer tokens to address
263    * @param _to dest address
264    * @param _value tokens amount
265    * @return transfer result
266    */
267   function transfer(address _to, uint256 _value) public returns (bool success) {
268     require(_to != address(0));
269 
270     uint lock = 0;
271     for (uint k = 0; k < ActiveProposals.length; k++) {
272       if (ActiveProposals[k].endTime > now) {
273         if (lock < voted[ActiveProposals[k].propID][msg.sender]) {
274           lock = voted[ActiveProposals[k].propID][msg.sender];
275         }
276       }
277     }
278 
279     require(safeSub(balances[msg.sender], lock) >= _value);
280 
281     if (ownersIndex[_to] == false && _value > 0) {
282       ownersIndex[_to] = true;
283       owners.push(_to);
284     }
285     
286     balances[msg.sender] = safeSub(balances[msg.sender], _value);
287     balances[_to] = safeAdd(balances[_to], _value);
288 
289     uint256 N = 1;
290     if (block.timestamp > start) {
291       N = (block.timestamp - start) / period + 1;
292     }
293 
294     ChangeOverPeriod[msg.sender][N] = ChangeOverPeriod[msg.sender][N] - int256(_value);
295     ChangeOverPeriod[_to][N] = ChangeOverPeriod[_to][N] + int256(_value);
296    
297     emit Transfer(msg.sender, _to, _value);
298     return true;
299   }
300 
301   /** 
302    * @dev Token allowance
303    * @param _owner holder address
304    * @param _spender spender address
305    * @return remain amount
306    */
307   function allowance(address _owner, address _spender) public view returns (uint256) {
308     return allowed[_owner][_spender];
309   }
310 
311   /**    
312    * @dev Transfer tokens from one address to another
313    * @param _from source address
314    * @param _to dest address
315    * @param _value tokens amount
316    * @return transfer result
317    */
318   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
319     require(_to != address(0));
320 
321     uint lock = 0;
322     for (uint k = 0; k < ActiveProposals.length; k++) {
323       if (ActiveProposals[k].endTime > now) {
324         if (lock < voted[ActiveProposals[k].propID][_from]) {
325           lock = voted[ActiveProposals[k].propID][_from];
326         }
327       }
328     }
329     
330     require(safeSub(balances[_from], lock) >= _value);
331     
332     require(allowed[_from][msg.sender] >= _value);
333 
334     if (ownersIndex[_to] == false && _value > 0) {
335       ownersIndex[_to] = true;
336       owners.push(_to);
337     }
338     
339     balances[_from] = safeSub(balances[_from], _value);
340     balances[_to] = safeAdd(balances[_to], _value);
341     allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
342     
343     uint256 N = 1;
344     if (block.timestamp > start) {
345       N = (block.timestamp - start) / period + 1;
346     }
347 
348     ChangeOverPeriod[_from][N] = ChangeOverPeriod[_from][N] - int256(_value);
349     ChangeOverPeriod[_to][N] = ChangeOverPeriod[_to][N] + int256(_value);
350 
351     emit Transfer(_from, _to, _value);
352     return true;
353   }
354   
355   /** 
356    * @dev Approve transfer
357    * @param _spender holder address
358    * @param _value tokens amount
359    * @return result  
360    */
361   function approve(address _spender, uint256 _value) public returns (bool success) {
362     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
363     allowed[msg.sender][_spender] = _value;
364     
365     emit Approval(msg.sender, _spender, _value);
366     return true;
367   }
368 
369   /** 
370    * @dev Trim owners with zero balance
371    */
372   function trim(uint offset, uint limit) external returns (bool) { 
373     uint k = offset;
374     uint ln = limit;
375     while (k < ln) {
376       if (balances[owners[k]] == 0) {
377         ownersIndex[owners[k]] =  false;
378         owners[k] = owners[owners.length-1];
379         owners.length = owners.length-1;
380         ln--;
381       } else {
382         k++;
383       }
384     }
385     return true;
386   }
387 
388   // current number of shareholders (owners)
389   function getOwnersCount() external view returns (uint256 count) {
390     return owners.length;
391   }
392 
393   // current period
394   function getCurrentPeriod() external view returns (uint256 N) {
395     if (block.timestamp > start) {
396       return (block.timestamp - start) / period;
397     } else {
398       return 0;
399     }
400   }
401 
402   function addProposal(uint _propID, uint _endTime) internal {
403     ActiveProposals.push(_Prop({
404       propID: _propID,
405       endTime: _endTime
406     }));
407   }
408 
409   function delProposal(uint _propID) internal {
410     uint k = 0;
411     while (k < ActiveProposals.length){
412       if (ActiveProposals[k].propID == _propID) {
413         require(ActiveProposals[k].endTime < now);
414         ActiveProposals[k] = ActiveProposals[ActiveProposals.length-1];
415         ActiveProposals.length = ActiveProposals.length-1;   
416       } else {
417         k++;
418       }
419     }    
420   }
421 
422   function getVoted(uint _propID, address _voter) external view returns (uint) {
423     return voted[_propID][_voter];
424   }
425 }
426 
427 
428 /**
429  * @title Dividend Distribution Contract for DAO
430  */
431 contract Dividends is ERC20Base, Ownable {
432 
433   DAppDEXI public DEX;
434 
435   address[] public tokens;
436   mapping (address => uint) public tokensIndex;
437   
438   mapping (uint => mapping (address => uint)) public dividends;
439   mapping (address => mapping (address => uint)) public ownersbal;  
440   mapping (uint => mapping (address => mapping (address => bool))) public AlreadyReceived;
441 
442   uint public multiplier = 100000; // precision to ten thousandth percent (0.001%)
443 
444   event Payment(address indexed sender, uint amount);
445   event setDEXContractEvent(address dex);
446    
447   function AddToken(address token) public {
448     require(msg.sender == address(DEX));
449     tokens.push(token);
450     tokensIndex[token] = tokens.length-1;
451   }
452 
453   function DelToken(address token) public {
454     require(msg.sender == address(DEX));
455     require(tokens[tokensIndex[token]] != 0);    
456     tokens[tokensIndex[token]] = tokens[tokens.length-1];
457     tokens.length = tokens.length-1;
458   }
459 
460   // Take profit for dividends from DEX contract
461   function TakeProfit(uint offset, uint limit) external {
462     require (limit <= tokens.length);
463     require (offset < limit);
464 
465     uint N = (block.timestamp - start) / period;
466     
467     require (N > 0);
468     
469     for (uint k = offset; k < limit; k++) {
470       if(dividends[N][tokens[k]] == 0 ) {
471           uint amount = DEX.balanceOf(tokens[k], address(this));
472           if (k == 0) {
473             DEX.withdraw(amount);
474             dividends[N][tokens[k]] = amount;
475           } else {
476             DEX.withdrawToken(tokens[k], amount);
477             dividends[N][tokens[k]] = amount;
478           }
479       }
480     }
481   }
482 
483   function () public payable {
484       emit Payment(msg.sender, msg.value);
485   }
486   
487   // PayDividends to owners
488   function PayDividends(address token, uint offset, uint limit) external {
489     //require (address(this).balance > 0);
490     require (limit <= owners.length);
491     require (offset < limit);
492 
493     uint N = (block.timestamp - start) / period; // current - 1
494     uint date = start + N * period - 1;
495     
496     require(dividends[N][token] > 0);
497 
498     uint share = 0;
499     uint k = 0;
500     for (k = offset; k < limit; k++) {
501       if (!AlreadyReceived[N][token][owners[k]]) {
502         share = safeMul(balanceOf(owners[k], date), multiplier);
503         share = safeDiv(safeMul(share, 100), totalSupply_); // calc the percentage of the totalSupply_ (from 100%)
504 
505         share = safePerc(dividends[N][token], share);
506         share = safeDiv(share, safeDiv(multiplier, 100));  // safeDiv(multiplier, 100) - convert to hundredths
507         
508         ownersbal[owners[k]][token] = safeAdd(ownersbal[owners[k]][token], share);
509         AlreadyReceived[N][token][owners[k]] = true;
510       }
511     }
512   }
513 
514   // PayDividends individuals to msg.sender
515   function PayDividends(address token) external {
516     //require (address(this).balance > 0);
517 
518     uint N = (block.timestamp - start) / period; // current - 1
519     uint date = start + N * period - 1;
520 
521     require(dividends[N][token] > 0);
522     
523     if (!AlreadyReceived[N][token][msg.sender]) {      
524       uint share = safeMul(balanceOf(msg.sender, date), multiplier);
525       share = safeDiv(safeMul(share, 100), totalSupply_); // calc the percentage of the totalSupply_ (from 100%)
526 
527       share = safePerc(dividends[N][token], share);
528       share = safeDiv(share, safeDiv(multiplier, 100));  // safeDiv(multiplier, 100) - convert to hundredths
529         
530       ownersbal[msg.sender][token] = safeAdd(ownersbal[msg.sender][token], share);
531       AlreadyReceived[N][token][msg.sender] = true;
532     }
533   }
534 
535   // withdraw dividends
536   function withdraw(address token, uint _value) external {    
537     require(ownersbal[msg.sender][token] >= _value);
538     ownersbal[msg.sender][token] = safeSub(ownersbal[msg.sender][token], _value);
539     if (token == address(0)) {
540       msg.sender.transfer(_value);
541     } else {
542       ERC20I(token).transfer(msg.sender, _value);
543     }
544   }
545   
546   // withdraw dividends to address
547   function withdraw(address token, uint _value, address _receiver) external {    
548     require(ownersbal[msg.sender][token] >= _value);
549     ownersbal[msg.sender][token] = safeSub(ownersbal[msg.sender][token], _value);
550     if (token == address(0)) {
551       _receiver.transfer(_value);
552     } else {
553       ERC20I(token).transfer(_receiver, _value);
554     }    
555   }
556 
557   function setMultiplier(uint _value) external onlyOwner {
558     require(_value > 0);
559     multiplier = _value;
560   }
561   
562   function getMultiplier() external view returns (uint ) {
563     return multiplier;
564   }  
565 
566   // link to DEX contract
567   function setDEXContract(address _contract) external onlyOwner {
568     DEX = DAppDEXI(_contract);
569     emit setDEXContractEvent(_contract);
570   }
571 }
572 
573 
574 /**
575  * @title External interface for DAO
576  */
577 interface CommonI {
578     function transferOwnership(address _newOwner) external;
579     function acceptOwnership() external;
580     function updateAgent(address _agent, bool _state) external;    
581 }
582 
583 
584 /**
585  * @title Decentralized Autonomous Organization
586  */
587 contract DAO is Dividends {
588 
589     //minimum balance for adding proposal - default 10000 tokens
590     uint minBalance = 1000000000000; 
591     // minimum quorum - number of votes must be more than minimum quorum
592     uint public minimumQuorum;
593     // debating period duration
594     uint public debatingPeriodDuration;
595     // requisite majority of votes (by the system a simple majority)
596     uint public requisiteMajority;
597 
598     struct _Proposal {
599         // proposal may execute only after voting ended
600         uint endTimeOfVoting;
601         // if executed = true
602         bool executed;
603         // if passed = true
604         bool proposalPassed;
605         // number of votes already voted
606         uint numberOfVotes;
607         // in support of votes
608         uint votesSupport;
609         // against votes
610         uint votesAgainst;
611         
612         // the address where the `amount` will go to if the proposal is accepted
613         address recipient;
614         // the amount to transfer to `recipient` if the proposal is accepted.
615         uint amount;
616         // keccak256(abi.encodePacked(recipient, amount, transactionByteCode));
617         bytes32 transactionHash;
618 
619         // a plain text description of the proposal
620         string desc;
621         // a hash of full description data of the proposal (optional)
622         string fullDescHash;
623     }
624 
625     _Proposal[] public Proposals;
626 
627     event ProposalAdded(uint proposalID, address recipient, uint amount, string description, string fullDescHash);
628     event Voted(uint proposalID, bool position, address voter, string justification);
629     event ProposalTallied(uint proposalID, uint votesSupport, uint votesAgainst, uint quorum, bool active);    
630     event ChangeOfRules(uint newMinimumQuorum, uint newdebatingPeriodDuration, uint newRequisiteMajority);
631     event Payment(address indexed sender, uint amount);
632 
633     // Modifier that allows only owners of tokens to vote and create new proposals
634     modifier onlyMembers {
635         require(balances[msg.sender] > 0);
636         _;
637     }
638 
639     /**
640      * Change voting rules
641      *
642      * Make so that Proposals need to be discussed for at least `_debatingPeriodDuration/60` hours,
643      * have at least `_minimumQuorum` votes, and have 50% + `_requisiteMajority` votes to be executed
644      *
645      * @param _minimumQuorum how many members must vote on a proposal for it to be executed
646      * @param _debatingPeriodDuration the minimum amount of delay between when a proposal is made and when it can be executed
647      * @param _requisiteMajority the proposal needs to have 50% plus this number
648      */
649     function changeVotingRules(
650         uint _minimumQuorum,
651         uint _debatingPeriodDuration,
652         uint _requisiteMajority
653     ) onlyOwner public {
654         minimumQuorum = _minimumQuorum;
655         debatingPeriodDuration = _debatingPeriodDuration;
656         requisiteMajority = _requisiteMajority;
657 
658         emit ChangeOfRules(minimumQuorum, debatingPeriodDuration, requisiteMajority);
659     }
660 
661     /**
662      * Add Proposal
663      *
664      * Propose to send `_amount / 1e18` ether to `_recipient` for `_desc`. `_transactionByteCode ? Contains : Does not contain` code.
665      *
666      * @param _recipient who to send the ether to
667      * @param _amount amount of ether to send, in wei
668      * @param _desc Description of job
669      * @param _fullDescHash Hash of full description of job
670      * @param _transactionByteCode bytecode of transaction
671      */
672     function addProposal(address _recipient, uint _amount, string _desc, string _fullDescHash, bytes _transactionByteCode, uint _debatingPeriodDuration) onlyMembers public returns (uint) {
673         require(balances[msg.sender] > minBalance);
674 
675         if (_debatingPeriodDuration == 0) {
676             _debatingPeriodDuration = debatingPeriodDuration;
677         }
678 
679         Proposals.push(_Proposal({      
680             endTimeOfVoting: now + _debatingPeriodDuration * 1 minutes,
681             executed: false,
682             proposalPassed: false,
683             numberOfVotes: 0,
684             votesSupport: 0,
685             votesAgainst: 0,
686             recipient: _recipient,
687             amount: _amount,
688             transactionHash: keccak256(abi.encodePacked(_recipient, _amount, _transactionByteCode)),
689             desc: _desc,
690             fullDescHash: _fullDescHash
691         }));
692         
693         // add proposal in ERC20 base contract for block transfer
694         super.addProposal(Proposals.length-1, Proposals[Proposals.length-1].endTimeOfVoting);
695 
696         emit ProposalAdded(Proposals.length-1, _recipient, _amount, _desc, _fullDescHash);
697 
698         return Proposals.length-1;
699     }
700 
701     /**
702      * Check if a proposal code matches
703      *
704      * @param _proposalID number of the proposal to query
705      * @param _recipient who to send the ether to
706      * @param _amount amount of ether to send
707      * @param _transactionByteCode bytecode of transaction
708      */
709     function checkProposalCode(uint _proposalID, address _recipient, uint _amount, bytes _transactionByteCode) view public returns (bool) {
710         require(Proposals[_proposalID].recipient == _recipient);
711         require(Proposals[_proposalID].amount == _amount);
712         // compare ByteCode        
713         return Proposals[_proposalID].transactionHash == keccak256(abi.encodePacked(_recipient, _amount, _transactionByteCode));
714     }
715 
716     /**
717      * Log a vote for a proposal
718      *
719      * Vote `supportsProposal? in support of : against` proposal #`proposalID`
720      *
721      * @param _proposalID number of proposal
722      * @param _supportsProposal either in favor or against it
723      * @param _justificationText optional justification text
724      */
725     function vote(uint _proposalID, bool _supportsProposal, string _justificationText) onlyMembers public returns (uint) {
726         // Get the proposal
727         _Proposal storage p = Proposals[_proposalID]; 
728         require(now <= p.endTimeOfVoting);
729 
730         // get numbers of votes for msg.sender
731         uint votes = safeSub(balances[msg.sender], voted[_proposalID][msg.sender]);
732         require(votes > 0);
733 
734         voted[_proposalID][msg.sender] = safeAdd(voted[_proposalID][msg.sender], votes);
735 
736         // Increase the number of votes
737         p.numberOfVotes = p.numberOfVotes + votes;
738         
739         if (_supportsProposal) {
740             p.votesSupport = p.votesSupport + votes;
741         } else {
742             p.votesAgainst = p.votesAgainst + votes;
743         }
744         
745         emit Voted(_proposalID, _supportsProposal, msg.sender, _justificationText);
746         return p.numberOfVotes;
747     }
748 
749     /**
750      * Finish vote
751      *
752      * Count the votes proposal #`_proposalID` and execute it if approved
753      *
754      * @param _proposalID proposal number
755      * @param _transactionByteCode optional: if the transaction contained a bytecode, you need to send it
756      */
757     function executeProposal(uint _proposalID, bytes _transactionByteCode) public {
758         // Get the proposal
759         _Proposal storage p = Proposals[_proposalID];
760 
761         require(now > p.endTimeOfVoting                                                                       // If it is past the voting deadline
762             && !p.executed                                                                                    // and it has not already been executed
763             && p.transactionHash == keccak256(abi.encodePacked(p.recipient, p.amount, _transactionByteCode))  // and the supplied code matches the proposal
764             && p.numberOfVotes >= minimumQuorum);                                                             // and a minimum quorum has been reached
765         // then execute result
766         if (p.votesSupport > requisiteMajority) {
767             // Proposal passed; execute the transaction
768             require(p.recipient.call.value(p.amount)(_transactionByteCode));
769             p.proposalPassed = true;
770         } else {
771             // Proposal failed
772             p.proposalPassed = false;
773         }
774         p.executed = true;
775 
776         // delete proposal from active list
777         super.delProposal(_proposalID);
778        
779         // Fire Events
780         emit ProposalTallied(_proposalID, p.votesSupport, p.votesAgainst, p.numberOfVotes, p.proposalPassed);
781     }
782 
783     // function is needed if execution transactionByteCode in Proposal failed
784     function delActiveProposal(uint _proposalID) public onlyOwner {
785         // delete proposal from active list
786         super.delProposal(_proposalID);   
787     }
788 
789     /**
790     * @dev Allows the DAO to transfer control of the _contract to a _newOwner.
791     * @param _newOwner The address to transfer ownership to.
792     */
793     function transferOwnership(address _contract, address _newOwner) public onlyOwner {
794         CommonI(_contract).transferOwnership(_newOwner);
795     }
796 
797     /**
798      * @dev Accept transferOwnership on a this (DAO) contract
799      */
800     function acceptOwnership(address _contract) public onlyOwner {
801         CommonI(_contract).acceptOwnership();        
802     }
803 
804     function updateAgent(address _contract, address _agent, bool _state) public onlyOwner {
805         CommonI(_contract).updateAgent(_agent, _state);        
806     }
807 
808     /**
809      * Set minimum balance for adding proposal
810      */
811     function setMinBalance(uint _minBalance) public onlyOwner {
812         assert(_minBalance > 0);
813         minBalance = _minBalance;
814     }
815 }
816 
817 
818 /**
819  * @title Agent contract - base contract with an agent
820  */
821 contract Agent is Ownable {
822 
823   address public defAgent;
824 
825   mapping(address => bool) public Agents;
826   
827   constructor() public {    
828     Agents[msg.sender] = true;
829   }
830   
831   modifier onlyAgent() {
832     assert(Agents[msg.sender]);
833     _;
834   }
835   
836   function updateAgent(address _agent, bool _status) public onlyOwner {
837     assert(_agent != address(0));
838     Agents[_agent] = _status;
839   }  
840 }
841 
842 
843 /**
844  * @title SDAD - ERC20 Token based on ERC20Base, DAO, Dividends smart contracts
845  */
846 contract SDAD is SDADI, DAO {
847 	
848   uint public initialSupply = 10 * 10**6; // 10 million tokens
849   uint public decimals = 8;
850 
851   string public name;
852   string public symbol;
853 
854   /** Name and symbol were updated. */
855   event UpdatedTokenInformation(string _name, string _symbol);
856 
857   /** Period were updated. */
858   event UpdatedPeriod(uint _period);
859 
860   constructor(string _name, string _symbol, uint _start, uint _period, address _dexowner) public {
861     name = _name;
862     symbol = _symbol;
863     start = _start;
864     period = _period;
865 
866     totalSupply_ = initialSupply*10**decimals;
867 
868     // creating initial tokens
869     balances[_dexowner] = totalSupply_;    
870     emit Transfer(0x0, _dexowner, balances[_dexowner]);
871 
872     ownersIndex[_dexowner] = true;
873     owners.push(_dexowner);
874 
875     ChangeOverPeriod[_dexowner][1] = int256(balances[_dexowner]);
876 
877     // set voting rules
878     // _minimumQuorum = 50%
879     // _requisiteMajority = 25%
880     // _debatingPeriodDuration = 1 day
881     changeVotingRules(safePerc(totalSupply_, 5000), 1440, safePerc(totalSupply_, 2500));
882 
883     // add ETH
884     tokens.push(address(0));
885     tokensIndex[address(0)] = tokens.length-1;
886   } 
887 
888   /**
889   * Owner can update token information here.
890   *
891   * It is often useful to conceal the actual token association, until
892   * the token operations, like central issuance or reissuance have been completed.
893   *
894   * This function allows the token owner to rename the token after the operations
895   * have been completed and then point the audience to use the token contract.
896   */
897   function setTokenInformation(string _name, string _symbol) public onlyOwner {
898     name = _name;
899     symbol = _symbol;
900     emit UpdatedTokenInformation(_name, _symbol);
901   }
902 
903   /**
904   * Owner can change period
905   *
906   */
907   function setPeriod(uint _period) public onlyOwner {
908     period = _period;
909     emit UpdatedPeriod(_period);    
910   }
911 
912   /**
913   * set owner to self
914   *
915   */
916   function setOwnerToSelf() public onlyOwner {
917     owner = address(this);
918     emit OwnershipTransferred(msg.sender, address(this));
919   }
920 }