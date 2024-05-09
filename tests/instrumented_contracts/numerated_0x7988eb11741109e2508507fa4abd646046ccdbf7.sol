1 pragma solidity ^0.5.0;
2 
3 interface Token {
4   /// @return total amount of tokens
5   function totalSupply() external view returns (uint256 supply);
6 
7   /// @param _owner The address from which the balance will be retrieved
8   /// @return The balance
9   function balanceOf(address _owner) external view returns (uint256 balance);
10 
11   /// @notice send `_value` token to `_to` from `msg.sender`
12   /// @param _to The address of the recipient
13   /// @param _value The amount of token to be transferred
14   /// @return Whether the transfer was successful or not
15   function transfer(address _to, uint256 _value) external returns (bool success);
16 
17   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
18   /// @param _from The address of the sender
19   /// @param _to The address of the recipient
20   /// @param _value The amount of token to be transferred
21   /// @return Whether the transfer was successful or not
22   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
23 
24   /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
25   /// @param _spender The address of the account able to transfer the tokens
26   /// @param _value The amount of wei to be approved for transfer
27   /// @return Whether the approval was successful or not
28   function approve(address _spender, uint256 _value) external returns (bool success);
29 
30   /// @param _owner The address of the account owning tokens
31   /// @param _spender The address of the account able to transfer the tokens
32   /// @return Amount of remaining tokens allowed to spent
33   function allowance(address _owner, address _spender) external view returns (uint256 remaining);
34 
35   event Transfer(address indexed _from, address indexed _to, uint256 _value);
36   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 library SafeMath {
40     function safeMul(uint a, uint b) internal pure returns (uint) {
41         uint c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45 
46     function safeSub(uint a, uint b) internal pure returns (uint) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     function safeAdd(uint a, uint b) internal pure returns (uint) {
52         uint c = a + b;
53         assert(c>=a && c>=b);
54         return c;
55     }
56 
57     function safeDiv(uint a, uint b) internal pure returns (uint) {
58         assert(b > 0);
59         uint c = a / b;
60         assert(a == b * c + a % b);
61         return c;
62     }
63 }
64 
65 contract ERC20 is Token {
66     using SafeMath for uint256;
67     
68     mapping (address => uint256) public balance;
69 
70     mapping (address => mapping (address => uint256)) public allowed;
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     event TransferFrom(address indexed spender, address indexed from, address indexed to, uint256 _value);
75 
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 
78     uint256 constant private MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
79 
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         require(_to != address(0), "Can't send to null");
82 
83         balance[msg.sender] = balance[msg.sender].safeSub(_value);
84         balance[_to] = balance[_to].safeAdd(_value);
85         emit Transfer(msg.sender, _to, _value);
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         require(_to != address(0), "Can't send to null");
91         require(_to != address(this), "Can't send to contract");
92         
93         uint256 allowance = allowed[_from][msg.sender];
94         require(_value <= allowance || _from == msg.sender, "Not allowed to send that much");
95 
96         balance[_to] = balance[_to].safeAdd(_value);
97         balance[_from] = balance[_from].safeSub(_value);
98 
99         if (allowed[_from][msg.sender] != MAX_UINT256 && _from != msg.sender) {
100             allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
101         }
102         emit Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
108     *
109     * @param _spender The address of the account able to transfer the tokens
110     * @param _value The amount of tokens to be approved for transfer
111     * @return Whether the approval was successful or not
112     */
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         require(_spender != address(0), "spender can't be null");
115 
116         allowed[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
122         remaining = allowed[_owner][_spender];
123     } 
124 
125     function totalSupply() public view returns (uint256 supply) {
126         return 0;
127     }
128 
129     function balanceOf(address _owner) public view returns (uint256 ownerBalance) {
130         return balance[_owner];
131     }
132 }
133 
134 contract Ownable {
135     address payable public admin;
136 
137   /**
138    * @dev The Ownable constructor sets the original `admin` of the contract to the sender
139    * account.
140    */
141     constructor() public {
142         admin = msg.sender;
143     }
144 
145   /**
146    * @dev Throws if called by any account other than the admin.
147    */
148     modifier onlyAdmin() {
149         require(msg.sender == admin, "Function reserved to admin");
150         _;
151     }
152 
153   /**
154    * @dev Allows the current admin to transfer control of the contract to a new admin.
155    * @param _newAdmin The address to transfer ownership to.
156    */
157 
158     function transferOwnership(address payable _newAdmin) public onlyAdmin {
159         require(_newAdmin != address(0), "New admin can't be null");      
160         admin = _newAdmin;
161     }
162 
163     function destroy() onlyAdmin public {
164         selfdestruct(admin);
165     }
166 
167     function destroyAndSend(address payable _recipient) public onlyAdmin {
168         selfdestruct(_recipient);
169     }
170 }
171 
172 contract NotTransferable is ERC20, Ownable {
173     /// @notice Enables token holders to transfer their tokens freely if true
174    /// @param _enabledTransfer True if transfers are allowed in the clone
175     bool public enabledTransfer = false;
176 
177     function enableTransfers(bool _enabledTransfer) public onlyAdmin {
178         enabledTransfer = _enabledTransfer;
179     }
180 
181     function transferFromContract(address _to, uint256 _value) public onlyAdmin returns (bool success) {
182         return super.transfer(_to, _value);
183     }
184 
185     function transfer(address _to, uint256 _value) public returns (bool success) {
186         require(enabledTransfer, "Transfers are not allowed yet");
187         return super.transfer(_to, _value);
188     }
189 
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
191         require(enabledTransfer, "Transfers are not allowed yet");
192         return super.transferFrom(_from, _to, _value);
193     }
194 
195     function approve(address _spender, uint256 _value) public returns (bool) {
196         require(enabledTransfer, "Transfers are not allowed yet");
197         return super.approve(_spender, _value);
198     }
199 }
200 
201 contract MOCoinstantine is NotTransferable {
202 
203     string constant public NAME = "MOCoinstantine";
204 
205     string constant public SYMBOL = "MOC";
206 
207     uint8 constant public DECIMALS = 0;
208 
209     uint256 public TOTALSUPPLY = 0;
210 
211     constructor(uint256 totalSupply) public {
212         TOTALSUPPLY = totalSupply;
213         balance[msg.sender] = totalSupply;
214     }
215 
216     function totalSupply() public view returns (uint256 supply) {
217         return TOTALSUPPLY;
218     }
219 }
220 
221 library Maps {
222     using SafeMath for uint256;
223 
224     struct Participant {
225         address Address;
226         uint256 Participation;
227         uint256 Tokens;
228         uint256 Timestamp;
229     }
230 
231     struct Map {
232         mapping(uint => Participant) data;
233         uint count;
234         uint lastIndex;
235         mapping(address => bool) addresses;
236         mapping(address => uint) indexes;
237     }
238 
239     function insertOrUpdate(Map storage self, Participant memory value) internal {
240         if(!self.addresses[value.Address]) {
241             uint newIndex = ++self.lastIndex;
242             self.count++;
243             self.indexes[value.Address] = newIndex;
244             self.addresses[value.Address] = true;
245             self.data[newIndex] = value;
246         }
247         else {
248             uint existingIndex = self.indexes[value.Address];
249             self.data[existingIndex] = value;
250         }
251     }
252 
253     function remove(Map storage self, Participant storage value) internal returns (bool success) {
254         if(!self.addresses[value.Address]) {
255             return false;
256         }
257         uint index = self.indexes[value.Address];
258         self.addresses[value.Address] = false;
259         self.indexes[value.Address] = 0;
260         delete self.data[index];
261         self.count--;
262         return true;
263     }
264 
265     function destroy(Map storage self) internal {
266         for (uint i; i <= self.lastIndex; i++) {
267             if(self.data[i].Address != address(0x0)) {
268                 delete self.addresses[self.data[i].Address];
269                 delete self.indexes[self.data[i].Address];
270                 delete self.data[i];
271             }
272         }
273         self.count = 0;
274         self.lastIndex = 0;
275         return ;
276     }
277     
278     function contains(Map storage self, Participant memory participant) internal view returns (bool exists) {
279         return self.indexes[participant.Address] > 0;
280     }
281 
282     function length(Map memory self) internal pure returns (uint) {
283         return self.count;
284     }
285 
286     function get(Map storage self, uint index) internal view returns (Participant storage) {
287         return self.data[index];
288     }
289 
290     function getIndexOf(Map storage self, address _address) internal view returns (uint256) {
291         return self.indexes[_address];
292     }
293 
294     function getByAddress(Map storage self, address _address) internal view returns (Participant storage) {
295         uint index = self.indexes[_address];
296         return self.data[index];
297     }
298 
299     function containsAddress(Map storage self, address _address) internal view returns (bool exists) {
300         return self.indexes[_address] > 0;
301     }
302 }
303 
304 contract CsnCrowdConfigurableSale is Ownable {
305     using SafeMath for uint256;
306 
307     // start and end date where investments are allowed (both inclusive)
308     uint256 public startDate; 
309     uint256 public endDate;
310 
311     // Minimum amount to participate
312     uint256 public minimumParticipationAmount;
313 
314     uint256 public minimumToRaise;
315 
316     // address where funds are collected
317     address payable public wallet ;
318 
319     // how many token units a buyer gets per ether
320     uint256 public baseRate;
321     //cap for the sale
322     uint256 public cap; 
323 
324     uint256 capBonus1; 
325     uint256 capBonus2;
326     uint256 capBonus3;
327 
328     uint256 bonus1;
329     uint256 bonus2;
330     uint256 bonus3;
331     // amount of raised money in wei
332     uint256 public weiRaised;
333 
334     //flag for final of crowdsale
335     bool public isFinalized = false;
336     bool public isCanceled = false;
337 
338     
339     function getRate() public view returns (uint256) {
340         uint256 bonus = 0;
341         if(weiRaised >= capBonus3)
342         {
343             // 5% bonus
344             bonus = bonus3;
345         }
346         else if (weiRaised >= capBonus2)
347         {
348             // 15% bonus
349             bonus = bonus2;
350         }
351         else if (weiRaised >= capBonus1)
352         {
353             // 30 % bonus
354             bonus = bonus1;
355         }
356         return baseRate.safeAdd(bonus);
357     }
358     
359     function isStarted() public view returns (bool) {
360         return startDate <= block.timestamp;
361     }
362 
363     function changeStartDate(uint256 _startDate) public onlyAdmin {
364         startDate = _startDate;
365     }
366 
367     function changeEndDate(uint256 _endDate) public onlyAdmin {
368         endDate = _endDate;
369     }
370 }
371 
372 contract CsnCrowdSaleBase is CsnCrowdConfigurableSale {
373     using SafeMath for uint256;
374     using Maps for Maps.Map;
375     // The token being sold
376     MOCoinstantine public token;
377     mapping(address => uint256) public participations;
378     Maps.Map public participants;
379 
380     event Finalized();
381 
382     /**
383     * event for token purchase logging
384     * @param purchaser who paid for the tokens
385     * @param value weis paid for purchase
386     * @param amount amount of tokens purchased
387     */ 
388     event BuyTokens(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
389 
390     event ClaimBack(address indexed purchaser, uint256 amount);
391 
392     constructor() public {
393         wallet = 0xd21662630913Eb962c186c4A4B5834409226B65a;
394     }
395 
396     function setWallet(address payable _wallet) public onlyAdmin  {
397         wallet = _wallet;
398     }
399 
400     function () external payable {
401         if(msg.sender != wallet && msg.sender != address(0x0) && !isCanceled) {
402             buyTokens(msg.value);
403         }
404     }
405 
406     function buyTokens(uint256 _weiAmount) private {
407         require(validPurchase(), "Requirements to buy are not met");
408         uint256 rate = getRate();
409         // calculate token amount to be created
410         uint256 gas = 0;
411         uint256 amountIncl = 0;
412         uint256 amount = 0;
413         uint256 tokens = 0;
414         uint256 newBalance = 0;
415        
416         participations[msg.sender] = participations[msg.sender].safeAdd(_weiAmount);
417         if(participants.containsAddress(msg.sender))
418         {
419             gas = tx.gasprice * 83000;
420             amountIncl = _weiAmount.safeAdd(gas);
421             amount = amountIncl.safeMul(rate);
422             tokens = amount.safeDiv(1000000000000000000);
423             Maps.Participant memory existingParticipant = participants.getByAddress(msg.sender);
424             newBalance = tokens.safeAdd(existingParticipant.Tokens);
425         }
426         else {
427             gas = tx.gasprice * 280000;
428             amountIncl = _weiAmount.safeAdd(gas);
429             amount = amountIncl.safeMul(rate);
430             tokens = amount.safeDiv(1000000000000000000);
431             newBalance = tokens;
432         } 
433         participants.insertOrUpdate(Maps.Participant(msg.sender, participations[msg.sender], newBalance, block.timestamp));
434 
435         //forward funds to wallet
436         forwardFunds();
437 
438          // update state
439         weiRaised = weiRaised.safeAdd(_weiAmount);
440          //purchase tokens and transfer to buyer
441         token.transferFromContract(msg.sender, tokens);
442          //Token purchase event
443         emit BuyTokens(msg.sender, msg.sender, _weiAmount, tokens);
444     }
445 
446     function GetNumberOfParticipants() public view  returns (uint) {
447         return participants.count;
448     }
449 
450     function GetMaxIndex() public view  returns (uint) {
451         return participants.lastIndex;
452     }
453 
454     function GetParticipant(uint index) public view  returns (address Address, uint256 Participation, uint256 Tokens, uint256 Timestamp ) {
455         Maps.Participant memory participant = participants.get(index);
456         Address = participant.Address;
457         Participation = participant.Participation;
458         Tokens = participant.Tokens;
459         Timestamp = participant.Timestamp;
460     }
461     
462     function Contains(address _address) public view returns (bool) {
463         return participants.contains(Maps.Participant(_address, 0, 0, block.timestamp));
464     }
465     
466     function Destroy() private returns (bool) {
467         participants.destroy();
468     }
469 
470     function buyTokens() public payable {
471         require(msg.sender != address(0x0), "Can't by from null");
472         buyTokens(msg.value);
473     }
474 
475     //send tokens to the given address used for investors with other conditions, only contract admin can call this
476     function transferTokensManual(address beneficiary, uint256 amount) public onlyAdmin {
477         require(beneficiary != address(0x0), "address can't be null");
478         require(amount > 0, "amount should greater than 0");
479 
480         //transfer tokens
481         token.transferFromContract(beneficiary, amount);
482 
483         //Token purchase event
484         emit BuyTokens(wallet, beneficiary, 0, amount);
485 
486     }
487 
488     /// @notice Enables token holders to transfer their tokens freely if true
489     /// @param _transfersEnabled True if transfers are allowed in the clone
490     function enableTransfers(bool _transfersEnabled) public onlyAdmin {
491         token.enableTransfers(_transfersEnabled);
492     }
493 
494     // send ether to the fund collection wallet
495     function forwardFunds() internal {
496         wallet.transfer(msg.value);
497     }
498 
499     // should be called after crowdsale ends or to emergency stop the sale
500     function finalize() public onlyAdmin {
501         require(!isFinalized, "Is already finalised");
502         emit Finalized();
503         isFinalized = true;
504     }
505 
506     // @return true if the transaction can buy tokens
507     // check for valid time period, min amount and within cap
508     function validPurchase() internal view returns (bool) {
509         bool withinPeriod = startDate <= block.timestamp && endDate >= block.timestamp;
510         bool nonZeroPurchase = msg.value != 0;
511         bool minAmount = msg.value >= minimumParticipationAmount;
512         bool withinCap = weiRaised.safeAdd(msg.value) <= cap;
513 
514         return withinPeriod && nonZeroPurchase && minAmount && !isFinalized && withinCap;
515     }
516 
517     // @return true if the goal is reached
518     function capReached() public view returns (bool) {
519         return weiRaised >= cap;
520     }
521 
522     function minimumCapReached() public view returns (bool) {
523         return weiRaised >= minimumToRaise;
524     }
525 
526     function claimBack() public {
527         require(isCanceled, "The presale is not canceled, claiming back is not possible");
528         require(participations[msg.sender] > 0, "The sender didn't participate to the presale");
529         uint256 participation = participations[msg.sender];
530         participations[msg.sender] = 0;
531         msg.sender.transfer(participation);
532         emit ClaimBack(msg.sender, participation);
533     }
534 
535     function cancelSaleIfCapNotReached() public onlyAdmin {
536         require(weiRaised < minimumToRaise, "The amount raised must not exceed the minimum cap");
537         require(!isCanceled, "The presale must not be canceled");
538         require(endDate > block.timestamp, "The presale must not have ended");
539         isCanceled = true;
540     }
541 }
542 
543 contract CsnCrowdPreSale is CsnCrowdSaleBase {
544     using SafeMath for uint256;
545 
546     constructor() public {
547         token = new MOCoinstantine(6000000);
548         startDate = 1561968000; //Mon, 1 Jul 2019 08:00:00 +00:00
549         endDate = 1565827199; //Wed, 14 Aug 2019 23:59:59 +00:00
550         minimumParticipationAmount = 100000000000000000 wei; //0.1 Ether
551         minimumToRaise = 400000000000000000000; // 400 Ether
552         baseRate = 1000;
553         cap = 4000000000000000000000 wei; //4000 ether
554         capBonus1 = 0; // 0 ether
555         capBonus2 = 1000000000000000000000; // 1000 ether
556         capBonus3 = 3000000000000000000000; // 3000 ether
557         bonus1 = 300;
558         bonus2 = 150;
559         bonus3 = 50;
560     }
561 }
562 
563 contract CsnCrowdSale is CsnCrowdSaleBase {
564     using SafeMath for uint256;
565 
566     constructor() public {
567         token = new MOCoinstantine(50000000);
568         startDate = 1569916800; //Tue, 1 Oct 2019 08:00:00 +00:00
569         endDate = 1575158399; //Sun, 30 Nov 2019 23:59:59 +00:00
570         minimumParticipationAmount = 100000000000000000 wei; // 0.1 Ether
571         minimumToRaise = 4000000000000000000000; // 4.000 Ether
572         baseRate = 500;
573         cap = 100000000000000000000000 wei; //100.000 ether
574         // No bonus
575         capBonus1 = 0; // 0 ether
576         capBonus2 = 0; // 0 ether
577         capBonus3 = 0; // 0 ether
578         bonus1 = 0;
579         bonus2 = 0;
580         bonus3 = 0;
581     }
582 }
583 
584 contract TestCrowdSaleEnded is CsnCrowdSaleBase {
585     using SafeMath for uint256;
586 
587     constructor() public {
588         token = new MOCoinstantine(100000);
589         startDate = 1525940887; // 10 May 2018
590         endDate = 1539160087; // 10 Oct 2018
591         minimumParticipationAmount = 100000000000000000 wei; //0.1 Ether
592         minimumToRaise = 400000000000000000000; // 400 Ether
593         baseRate = 1000;
594         cap = 4000000000000000000000 wei; //4000 ether
595         capBonus1 = 0; // 0 ether
596         capBonus2 = 1000000000000000000000; // 1000 ether
597         capBonus3 = 3000000000000000000000; // 3000 ether
598         bonus1 = 300;
599         bonus2 = 150;
600         bonus3 = 50;
601     }
602 }
603 
604 contract TestCrowdSaleStarted is CsnCrowdSaleBase {
605     using SafeMath for uint256;
606 
607     constructor() public {
608         token = new MOCoinstantine(100000);
609         startDate = 1557377510; // 9 May 2019
610         endDate = 1575158399; // 10 Oct 2019
611         minimumParticipationAmount = 100000000000000000 wei; //0.1 Ether
612         minimumToRaise = 400000000000000000000; // 400 Ether
613         baseRate = 1000;
614         cap = 4000000000000000000000 wei; //4000 ether
615         capBonus1 = 0; // 0 ether
616         capBonus2 = 1000000000000000000000; // 1000 ether
617         capBonus3 = 3000000000000000000000; // 3000 ether
618         bonus1 = 300;
619         bonus2 = 150;
620         bonus3 = 50;
621     }
622 }
623 
624 contract TestCrowdSale is CsnCrowdSaleBase {
625     using SafeMath for uint256;
626 
627     constructor() public {
628         token = new MOCoinstantine(2600);
629         startDate = 1557377510; // 9 May 2019
630         endDate = 1575158399; // 10 Oct 2019
631         minimumParticipationAmount = 100000000000000000 wei; //0.1 Ether
632         minimumToRaise = 1000000000000000000; // 1 Ether
633         baseRate = 1000;
634         cap = 2000000000000000000 wei; //2 ether
635         capBonus1 = 0; // 0 ether
636         capBonus2 = 1000000000000000000; // 1 ether
637         capBonus3 = 1500000000000000000; // 1.5 ether
638         bonus1 = 300;
639         bonus2 = 150;
640         bonus3 = 50;
641     }
642 }
643 
644 contract TestCrowdSaleAboveSupply is CsnCrowdSaleBase {
645     using SafeMath for uint256;
646 
647     constructor() public {
648         token = new MOCoinstantine(500);
649         startDate = 1557377510; // 9 May 2019
650         endDate = 1575158399; // 10 Oct 2019
651         minimumParticipationAmount = 100000000000000000 wei; //0.1 Ether
652         minimumToRaise = 1000000000000000000; // 1 Ether
653         baseRate = 1000;
654         cap = 2000000000000000000 wei; //2 ether
655         capBonus1 = 0; // 0 ether
656         capBonus2 = 1000000000000000000; // 1 ether
657         capBonus3 = 1500000000000000000; // 1.5 ether
658         bonus1 = 300;
659         bonus2 = 150;
660         bonus3 = 50;
661     }
662 }