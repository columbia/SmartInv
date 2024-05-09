1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4   function sub(uint a, uint b) internal pure returns (uint) {
5     require(b <= a);
6     return a - b;
7   }
8   function add(uint a, uint b) internal pure returns (uint) {
9     uint c = a + b;
10     require(c >= a);
11     return c;
12   }
13   /*function mul(uint a, uint b) internal pure returns (uint) {
14     if (a == 0) {
15       return 0;
16     }
17     uint c = a * b;
18     require(c / a == b);
19     return c;
20   }*/
21 }
22 
23 contract ERC20Basic {
24   uint public totalSupply;
25   address public owner; //owner
26   function balanceOf(address who) public view returns (uint);
27   function transfer(address to, uint value) public;
28   event Transfer(address indexed from, address indexed to, uint value);
29   function commitDividend(address who) public; // pays remaining dividend
30 }
31 
32 contract ERC20 is ERC20Basic {
33   function allowance(address owner, address spender) public view returns (uint);
34   function transferFrom(address from, address to, uint value) public;
35   function approve(address spender, uint value) public;
36   event Approval(address indexed owner, address indexed spender, uint value);
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint;
41   // users
42   struct User {
43     uint120 tokens; // current tokens of user
44     uint120 asks;   // current tokens in asks
45     uint120 votes;  // current voting power
46     uint120 weis;   // current wei balance of user
47     uint32 lastProposalID; // last processed dividend period of user's tokens
48     address owner;  // votes for new owner
49     uint8   voted;  // vote for proposal
50   }
51   mapping (address => User) users;
52 
53   modifier onlyPayloadSize(uint size) {
54     assert(msg.data.length >= size + 4);
55     _;
56   }
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
63     commitDividend(msg.sender);
64     users[msg.sender].tokens = uint120(uint(users[msg.sender].tokens).sub(_value));
65     if(_to == address(this)) {
66       commitDividend(owner);
67       users[owner].tokens = uint120(uint(users[owner].tokens).add(_value));
68       emit Transfer(msg.sender, owner, _value);
69     }
70     else {
71       commitDividend(_to);
72       users[_to].tokens = uint120(uint(users[_to].tokens).add(_value));
73       emit Transfer(msg.sender, _to, _value);
74     }
75   }
76   /**
77   * @dev Gets the amount of tokens
78   * @param _owner The address to query.
79   * @return An uint representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public view returns (uint) {
82     return uint(users[_owner].tokens);
83   }
84   /**
85   * @dev Gets the amount of tokens offered for sale (in asks)
86   * @param _owner The address to query.
87   * @return An uint representing the amount offered by the passed address.
88   */
89   function askOf(address _owner) public view returns (uint) {
90     return uint(users[_owner].asks);
91   }
92   /**
93   * @dev Gets the amount of tokens offered for sale (in asks)
94   * @param _owner The address to query.
95   * @return An uint representing the amount offered by the passed address.
96   */
97   function voteOf(address _owner) public view returns (uint) {
98     return uint(users[_owner].votes);
99   }
100   /**
101   * @dev Gets the amount of wei owned by user and stored in contract
102   * @param _owner The address to query.
103   * @return An uint representing the amount wei stored in contract.
104   */
105   function weiOf(address _owner) public view returns (uint) {
106     return uint(users[_owner].weis);
107   }
108   /**
109   * @dev Gets the id of last proccesed proposal period
110   * @param _owner The address to query.
111   * @return An uint representing the id of last processed proposal period
112   */
113   function lastOf(address _owner) public view returns (uint) {
114     return uint(users[_owner].lastProposalID);
115   }
116   /**
117   * @dev Gets the proposed address of new contract owner / manager
118   * @param _owner The address to query.
119   * @return An address proposed as new contract owner / manager
120   */
121   function ownerOf(address _owner) public view returns (address) {
122     return users[_owner].owner;
123   }
124   /**
125   * @dev Gets the status of voting
126   * @param _owner The address to query.
127   * @return An uint > 0 if user already voted
128   */
129   function votedOf(address _owner) public view returns (uint) {
130     return uint(users[_owner].voted);
131   }
132 }
133 
134 contract StandardToken is BasicToken, ERC20 {
135   mapping (address => mapping (address => uint)) allowed;
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint the amount of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
144     uint _allowance = allowed[_from][msg.sender];
145     commitDividend(_from);
146     commitDividend(_to);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     users[_from].tokens = uint120(uint(users[_from].tokens).sub(_value));
149     users[_to].tokens = uint120(uint(users[_to].tokens).add(_value));
150     emit Transfer(_from, _to, _value);
151   }
152   /**
153    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint _value) public {
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     assert(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162   }
163   /**
164    * @dev Function to check the amount of tokens than an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint specifing the amount of tokens still avaible for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint remaining) {
170     return allowed[_owner][_spender];
171   }
172 }
173 
174 /**
175  * @title PicoStocksAsset contract
176  */
177 contract PicoStocksAsset is StandardToken {
178 
179     // metadata
180     string public constant version = "0.2";
181     string public constant name = "PicoStocks Asset";
182     uint public constant decimals = 0;
183     uint public picoid = 0; // Asset ID on PicoStocks
184     string public symbol = ""; // Asset code on PicoStocks
185     string public www = ""; // Official web page
186 
187     uint public totalWeis = 0; // sum of wei owned by users
188     uint public totalVotes = 0;  // number of alligible votes
189 
190     struct Order {
191         uint64 prev;   // previous order, need this to enable safe/fast order cancel
192         uint64 next;   // next order
193         uint128 price; // offered/requested price of 1 token
194         uint96 amount; // number of offered/requested tokens
195         address who;   // address of owner of tokens or funds
196     }
197     mapping (uint => Order) asks;
198     mapping (uint => Order) bids;
199     uint64 firstask=0; // key of lowest ask
200     uint64 lastask=0;  // key of last inserted ask
201     uint64 firstbid=0; // key of highest bid
202     uint64 lastbid=0;  // key of last inserted bid
203 
204     uint constant weekBlocks = 4*60*24*7; // number of blocks in 1 week
205     uint constant minPrice  = 0xFFFF;                             // min price per token
206     uint constant maxPrice  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // max price per token
207     uint constant maxTokens = 0xFFFFFFFFFFFFFFFFFFFFFFFF;         // max number of tokens
208 
209     address public custodian = 0xd720a4768CACE6d508d8B390471d83BA3aE6dD32;
210 
211     // investment parameters
212     uint public investOwner; // number of tokens assigned to owner if first round successfull
213     uint public investPrice; // price of 1 token
214     uint public investStart; // first block of funding round
215     uint public investEnd;   // last block of funding round
216     uint public investGot;   // funding collected
217     uint public investMin;   // minimum funding
218     uint public investMax;   // maximum funding
219     uint public investKYC = 1;   // KYC requirement
220 
221     //dividends
222     uint[] public dividends; // dividens collected per period, growing array
223 
224     //proposal
225     uint public proposalID = 1;   // proposal number and dividend period
226     uint public proposalVotesYes; // yes-votes collected
227     uint public proposalVotesNo;  // no-votes collected
228     uint public proposalBlock;    // block number proposal published
229     uint public proposalDividendPerShare; // dividend per share
230     uint public proposalBudget;   // budget for the owner for next period
231     uint public proposalTokens;   // number of new tokens for next round
232     uint public proposalPrice;    // price of new token in next round
233     uint public acceptedBudget;   // unspent budget for the owner in current round
234 
235     //change owner
236     mapping (address => uint) owners; // votes for new owners / managers of the contract
237 
238     // events
239     event LogBuy(address indexed who, uint amount, uint price);
240     event LogSell(address indexed who, uint amount, uint price);
241     event LogCancelBuy(address indexed who, uint amount, uint price);
242     event LogCancelSell(address indexed who, uint amount, uint price);
243     event LogTransaction(address indexed from, address indexed to, uint amount, uint price);
244     event LogDeposit(address indexed who,uint amount);
245     event LogWithdraw(address indexed who,uint amount);
246     event LogExec(address indexed who,uint amount);
247     event LogPayment(address indexed who, address from, uint amount);
248     event LogDividend(uint amount);
249     event LogDividend(address indexed who, uint amount, uint period);
250     event LogNextInvestment(uint price,uint amount);
251     event LogNewOwner(address indexed who);
252     event LogNewCustodian(address indexed who);
253     event LogNewWww(string www);
254     event LogProposal(uint dividendpershare,uint budget,uint moretokens,uint minprice);
255     event LogVotes(uint proposalVotesYes,uint proposalVotesNo);
256     event LogBudget(uint proposalBudget);
257     event LogAccepted(uint proposalDividendPerShare,uint proposalBudget,uint proposalTokens,uint proposalPrice);
258     event LogRejected(uint proposalDividendPerShare,uint proposalBudget,uint proposalTokens,uint proposalPrice);
259     
260     modifier onlyOwner() {
261         assert(msg.sender == owner);
262         _;
263     }
264 
265     // constructor
266     /**
267      * @dev Contract constructor
268      */
269     constructor() public {
270         owner = msg.sender;
271     }
272 
273 /* initial investment functions */
274 
275     /**
276      * @dev Set first funding round parameters
277      * @param _tokens number of tokens given to admin
278      * @param _budget initial approved budget
279      * @param _price price of 1 token in first founding round
280      * @param _from block number of start of funding round
281      * @param _length length of the funding round in blocks
282      * @param _min minimum number of tokens to sell
283      * @param _max maximum number of tokens to sell
284      * @param _kyc require KYC during first investment round
285      * @param _picoid asset id on picostocks
286      * @param _symbol asset symmbol on picostocks
287      */
288     function setFirstInvestPeriod(uint _tokens,uint _budget,uint _price,uint _from,uint _length,uint _min,uint _max,uint _kyc,uint _picoid,string memory _symbol) public onlyOwner {
289         require(investEnd == 0 && _price < maxPrice && _length <= weekBlocks * 12 && _min <= _max && _tokens.add(_max) < maxTokens );
290         investOwner = _tokens;
291         acceptedBudget = _budget;
292         users[owner].lastProposalID = uint32(proposalID);
293         users[custodian].lastProposalID = uint32(proposalID);
294         if(_price <= minPrice){
295           _price = minPrice+1;
296         }
297         investPrice = _price;
298         if(_from < block.number){
299           _from = block.number;
300         }
301         investStart = _from;
302         if(_length == 0){
303           _length = weekBlocks * 4;
304         }
305         investEnd = _from + _length;
306         investMin = _min;
307         investMax = _max;
308         investKYC = _kyc;
309         picoid = _picoid;
310         symbol = _symbol;
311         dividends.push(0); // not used
312         dividends.push(0); // current dividend
313         if(investMax == 0){
314           closeInvestPeriod();
315         }
316     }
317 
318     /**
319      * @dev Accept address for first investment
320      * @param _who accepted address (investor)
321      */
322     function acceptKYC(address _who) external onlyOwner {
323         if(users[_who].lastProposalID==0){
324           users[_who].lastProposalID=1;
325         }
326     }
327 
328     /**
329      * @dev Buy tokens
330      */
331     function invest() payable public {
332         commitDividend(msg.sender);
333         require(msg.value > 0 && block.number >= investStart && block.number < investEnd && totalSupply < investMax && investPrice > 0);
334         uint tokens = msg.value / investPrice;
335         if(investMax < totalSupply.add(tokens)){
336             tokens = investMax.sub(totalSupply);
337         }
338         totalSupply += tokens;
339         users[msg.sender].tokens += uint120(tokens);
340         emit Transfer(address(0),msg.sender,tokens);
341         uint _value = msg.value.sub(tokens * investPrice);
342         if(_value > 0){ // send back excess funds immediately
343             emit LogWithdraw(msg.sender,_value);
344             (bool success, /*bytes memory _unused*/) = msg.sender.call.value(_value)("");
345             require(success);
346         }
347         if(totalSupply>=investMax){
348             closeInvestPeriod();
349         }
350     }
351 
352     /**
353      * @dev Buy tokens
354      */
355     function () payable external {
356         invest();
357     }
358 
359     /**
360      * @dev Return wei to token owners if first funding round failes
361      */
362     function disinvest() public {
363         require(investEnd < block.number && totalSupply < investMin && totalSupply>0 && proposalID > 1);
364         payDividend((address(this).balance-totalWeis)/totalSupply); //CHANGED
365         investEnd = block.number + weekBlocks*4; // enable future dividend payment if contract has funds
366     }
367 
368 /* management functions */
369 
370     /**
371      * @dev Propose dividend, budget and optional funding parameters for next round
372      * @param _dividendpershare amount of wei per share to pay out
373      * @param _budget amount of wei to give to owner
374      * @param _tokens amount of new tokens to issue
375      * @param _price price of 1 new token
376      */
377     function propose(uint _dividendpershare,uint _budget,uint _tokens,uint _price) external onlyOwner {
378         require(proposalBlock + weekBlocks*4 < block.number && investEnd < block.number && proposalID > 1); //can not send more than 1 proposal per 28 days
379         if(block.number>investEnd && investStart>0 && investPrice>0 && investMax>0){
380           totalVotes=totalSupply;
381           investStart=0;
382           investMax=0;
383         }
384         proposalVotesYes=0;
385         proposalVotesNo=0;
386         proposalID++;
387         dividends.push(0);
388         proposalBlock=block.number;
389         proposalDividendPerShare=_dividendpershare;
390         proposalBudget=_budget;
391         proposalTokens=_tokens;
392         proposalPrice=_price;
393         emit LogProposal(_dividendpershare,_budget,_tokens,_price);
394     }
395 
396     /**
397      * @dev Execute proposed plan if passed
398      */
399     function executeProposal() public {
400         require(proposalVotesYes > 0 && (proposalBlock + weekBlocks*4 < block.number || proposalVotesYes>totalVotes/2 || proposalVotesNo>totalVotes/2) && proposalID > 1);
401         //old require(proposalVotesYes > 0);
402         emit LogVotes(proposalVotesYes,proposalVotesNo);
403         if(proposalVotesYes >= proposalVotesNo && (proposalTokens==0 || proposalPrice>=investPrice || proposalVotesYes>totalVotes/2)){
404           if(payDividend(proposalDividendPerShare) > 0){
405             emit LogBudget(proposalBudget);
406             acceptedBudget=proposalBudget;}
407           if(proposalTokens>0){
408             emit LogNextInvestment(proposalPrice,proposalTokens);
409             setNextInvestPeriod(proposalPrice,proposalTokens);}
410           emit LogAccepted(proposalDividendPerShare,proposalBudget,proposalTokens,proposalPrice);}
411         else{
412           emit LogRejected(proposalDividendPerShare,proposalBudget,proposalTokens,proposalPrice);}
413         proposalBlock=0;
414         proposalVotesYes=0;
415         proposalVotesNo=0;
416         proposalDividendPerShare=0;
417         proposalBudget=0;
418         proposalTokens=0;
419         proposalPrice=0;
420     }
421 
422     /**
423      * @dev Set next funding round parameters
424      * @param _price price of 1 new token
425      * @param _tokens amount of new tokens to issue
426      */
427     function setNextInvestPeriod(uint _price,uint _tokens) internal {
428         require(totalSupply >= investMin && _price > 0 && _price < maxPrice && totalSupply + _tokens < 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
429         investStart = block.number + weekBlocks*2;
430         investEnd = block.number + weekBlocks*4;
431         investPrice = _price; // too high price will disable future investments
432         investMax = totalSupply + _tokens;
433         investKYC=0;
434     }
435 
436     /**
437      * @dev Finish funding round and update voting power
438      */
439     function closeInvestPeriod() public {
440         require((block.number>investEnd || totalSupply>=investMax) && investStart>0);
441         if(proposalID == 1){
442           totalSupply += investOwner;
443           users[owner].tokens += uint120(investOwner);
444           if(totalSupply == 0){
445             totalSupply = 1;
446             users[owner].tokens = 1;
447           }
448         }
449         proposalID++;
450         dividends.push(0);
451         totalVotes=totalSupply;
452         investStart=0;
453         investMax=0;
454         investKYC=0;
455     }
456 
457     /**
458      * @dev Pay dividend per share 
459      * @param _wei The amount of wei to pay per share
460      */
461     function payDividend(uint _wei) internal returns (uint) {
462         if(_wei == 0){
463           return 1;}
464         //uint newdividend = _wei.mul(totalSupply);
465         uint newdividend = _wei * totalSupply;
466         require(newdividend / _wei == totalSupply);
467         if(address(this).balance < newdividend.add(totalWeis)){
468           emit LogDividend(0); //indicates failure
469           return 0;}
470         totalWeis += newdividend;
471         dividends[proposalID] = _wei;
472         proposalID++;
473         dividends.push(0);
474         totalVotes=totalSupply;
475         emit LogDividend(_wei);
476         return(_wei);
477     }
478 
479     /**
480      * @dev Commit remaining dividends and update votes before transfer of tokens
481      * @param _who User to process
482      */
483     function commitDividend(address _who) public {
484         uint last = users[_who].lastProposalID;
485         require(investKYC==0 || last>0); // only authorized investors during KYC period
486         uint tokens=users[_who].tokens+users[_who].asks;
487         if((tokens==0) || (last==0)){
488             users[_who].lastProposalID=uint32(proposalID);
489             return;
490         }
491         if(last==proposalID) {
492             return;
493         }
494         if(tokens != users[_who].votes){
495             if(users[_who].owner != address(0)){
496                 owners[users[_who].owner] = owners[users[_who].owner].add(tokens).sub(uint(users[_who].votes));
497             }
498             users[_who].votes=uint120(tokens); // store voting power
499         }
500         uint balance = 0;
501         for(; last < proposalID ; last ++) {
502             balance += tokens * dividends[last];
503         }
504         users[_who].weis += uint120(balance);
505         users[_who].lastProposalID = uint32(last);
506         users[_who].voted=0;
507         emit LogDividend(_who,balance,last);
508     }
509 
510 /* administrative functions */
511 
512     /**
513      * @dev Change owner
514      * @param _who The address of new owner
515      */
516     function changeOwner(address _who) external onlyOwner {
517         assert(_who != address(0));
518         owner = _who;
519         emit LogNewOwner(_who);
520     }
521 
522     /**
523      * @dev Change the official www address
524      * @param _www The new www address
525      */
526     function changeWww(string calldata _www) external onlyOwner {
527         www=_www;
528         emit LogNewWww(_www);
529     }
530 
531     /**
532      * @dev Change owner
533      * @param _who The address of new owner
534      */
535     function changeCustodian(address _who) external { //CHANGED
536         assert(msg.sender == custodian);
537         assert(_who != address(0));
538         custodian = _who;
539         emit LogNewCustodian(_who);
540     }
541 
542     /**
543      * @dev Execute a call
544      * @param _to destination address
545      * @param _data The call data
546      */
547     function exec(address _to,bytes calldata _data) payable external onlyOwner {
548         emit LogExec(_to,msg.value);
549         (bool success, /*bytes memory _unused*/) =_to.call.value(msg.value)(_data);
550         require(success);
551     }
552 
553     /**
554      * @dev Withdraw funds from contract by contract owner / manager
555      * @param _amount The amount of wei to withdraw
556      * @param _who The addres to send wei to
557      */
558     function spend(uint _amount,address _who) external onlyOwner {
559         require(_amount > 0 && address(this).balance >= _amount.add(totalWeis) && totalSupply >= investMin);
560         acceptedBudget=acceptedBudget.sub(_amount); //check for excess withdrawal
561         if(_who == address(0)){
562           emit LogWithdraw(msg.sender,_amount);
563           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(_amount)("");
564           require(success);}
565         else{
566           emit LogWithdraw(_who,_amount);
567           (bool success, /*bytes memory _unused*/) = _who.call.value(_amount)("");
568           require(success);}
569     }
570 
571 /* user functions */
572 
573     /**
574      * @dev Vote to change contract owner / manager
575      * @param _who The addres of the proposed new contract owner / manager
576      */
577     function voteOwner(address _who) external {
578         require(_who != users[msg.sender].owner);
579         if(users[msg.sender].owner != address(0)){
580           owners[users[msg.sender].owner] = owners[users[msg.sender].owner].sub(users[msg.sender].votes);
581         }
582         users[msg.sender].owner=_who;
583         if(_who != address(0)){
584           owners[_who] = owners[_who].add(users[msg.sender].votes);
585           if(owners[_who] > totalVotes/2 && _who != owner){
586             owner = _who;
587             emit LogNewOwner(_who);
588           }
589         }
590     }
591 
592     /**
593      * @dev Vote in favor of the current proposal
594      */
595     function voteYes() public {
596         commitDividend(msg.sender);
597         require(users[msg.sender].voted == 0 && proposalBlock + weekBlocks*4 > block.number && proposalBlock > 0);
598         users[msg.sender].voted=1;
599         proposalVotesYes+=users[msg.sender].votes;
600     }
601 
602     /**
603      * @dev Vote against the current proposal
604      */
605     function voteNo() public {
606         commitDividend(msg.sender);
607         require(users[msg.sender].voted == 0 && proposalBlock + weekBlocks*4 > block.number && proposalBlock > 0);
608         users[msg.sender].voted=1;
609         proposalVotesNo+=users[msg.sender].votes;
610     }
611 
612     /**
613      * @dev Vote in favor of the proposal defined by ID
614      * @param _id Proposal ID
615      */
616     function voteYes(uint _id) external {
617         require(proposalID==_id);
618         voteYes();
619     }
620 
621     /**
622      * @dev Vote against the proposal defined by ID
623      * @param _id Proposal ID
624      */
625     function voteNo(uint _id) external {
626         require(proposalID==_id);
627         voteNo();
628     }
629 
630     /**
631      * @dev Store funds in contract
632      */
633     function deposit() payable external {
634         commitDividend(msg.sender); //CHANGED
635         users[msg.sender].weis += uint120(msg.value);
636         totalWeis += msg.value;
637         emit LogDeposit(msg.sender,msg.value);
638     }
639 
640     /**
641      * @dev Withdraw funds from contract
642      * @param _amount Amount of wei to withdraw
643      */
644     function withdraw(uint _amount) external {
645         commitDividend(msg.sender);
646         uint amount=_amount;
647         if(amount > 0){
648            require(users[msg.sender].weis >= amount);
649         }
650         else{
651            require(users[msg.sender].weis > 0);
652            amount=users[msg.sender].weis;
653         }
654         users[msg.sender].weis = uint120(uint(users[msg.sender].weis).sub(amount));
655         totalWeis = totalWeis.sub(amount);
656         //msg.sender.transfer(amount);
657         emit LogWithdraw(msg.sender,amount);
658         (bool success, /*bytes memory _unused*/) = msg.sender.call.value(amount)("");
659         require(success);
660     }
661 
662     /**
663      * @dev Wire funds from one user to another user
664      * @param _amount Amount of wei to wire
665      * @param _who Address of the user to wire to
666      */
667     function wire(uint _amount,address _who) external {
668         users[msg.sender].weis = uint120(uint(users[msg.sender].weis).sub(_amount));
669         users[_who].weis = uint120(uint(users[_who].weis).add(_amount));
670     }
671 
672     /**
673      * @dev Send wei to contract
674      * @param _who Address of the payee
675      */
676     function pay(address _who) payable external {
677         emit LogPayment(_who,msg.sender,msg.value);
678     }
679 
680 /* market view functions */
681 
682     /**
683      * @dev Return ask orders optionally filtered by user
684      * @param _who Optional address of the user
685      * @return An array of uint representing the (filtered) orders, 4 uints per order (id,price,amount,user)
686      */
687     function ordersSell(address _who) external view returns (uint[256] memory) {
688         uint[256] memory ret;
689         uint num=firstask;
690         uint id=0;
691         for(;asks[num].price>0 && id<64;num=uint(asks[num].next)){
692           if(_who!=address(0) && _who!=asks[num].who){
693             continue;
694           }
695           ret[4*id+0]=num;
696           ret[4*id+1]=uint(asks[num].price);
697           ret[4*id+2]=uint(asks[num].amount);
698           ret[4*id+3]=uint(asks[num].who);
699           id++;}
700         return ret;
701     }
702 
703     /**
704      * @dev Return bid orders optionally filtered by user
705      * @param _who Optional address of the user
706      * @return An array of uint representing the (filtered) orders, 4 uints per order (id,price,amount,user)
707      */
708     function ordersBuy(address _who) external view returns (uint[256] memory) {
709         uint[256] memory ret;
710         uint num=firstbid;
711         uint id=0;
712         for(;bids[num].price>0 && id<64;num=uint(bids[num].next)){
713           if(_who!=address(0) && _who!=bids[num].who){
714             continue;
715           }
716           ret[4*id+0]=num;
717           ret[4*id+1]=uint(bids[num].price);
718           ret[4*id+2]=uint(bids[num].amount);
719           ret[4*id+3]=uint(bids[num].who);
720           id++;}
721         return ret;
722     }
723 
724     /**
725      * @dev Find the ask order id for a user
726      * @param _who The address of the user
727      * @param _minprice Optional minimum price
728      * @param _maxprice Optional maximum price
729      * @return The id of the order
730      */
731     function findSell(address _who,uint _minprice,uint _maxprice) external view returns (uint) {
732         uint num=firstask;
733         for(;asks[num].price>0;num=asks[num].next){
734           if(_maxprice > 0 && asks[num].price > _maxprice){
735             return 0;}
736           if(_minprice > 0 && asks[num].price < _minprice){
737             continue;}
738           if(_who == asks[num].who){ //FIXED !!!
739             return num;}}
740     }
741 
742     /**
743      * @dev Find the bid order id for a user
744      * @param _who The address of the user
745      * @param _minprice Optional minimum price
746      * @param _maxprice Optional maximum price
747      * @return The id of the order
748      */
749     function findBuy(address _who,uint _minprice,uint _maxprice) external view returns (uint) {
750         uint num=firstbid;
751         for(;bids[num].price>0;num=bids[num].next){
752           if(_minprice > 0 && bids[num].price < _minprice){
753             return 0;}
754           if(_maxprice > 0 && bids[num].price > _maxprice){
755             continue;}
756           if(_who == bids[num].who){
757             return num;}}
758     }
759 
760     /**
761      * @dev Report the user address of an ask order
762      * @param _id The id of the order
763      * @return The address of the user placing the order
764      */
765     function whoSell(uint _id) external view returns (address) {
766         if(_id>0){
767           return address(asks[_id].who);
768         }
769         return address(asks[firstask].who);
770     }
771 
772     /**
773      * @dev Report the user address of a bid order
774      * @param _id The id of the order
775      * @return The address of the user placing the order
776      */
777     function whoBuy(uint _id) external view returns (address) {
778         if(_id>0){
779           return address(bids[_id].who);
780         }
781         return address(bids[firstbid].who);
782     }
783 
784     /**
785      * @dev Report the amount of tokens of an ask order
786      * @param _id The id of the order
787      * @return The amount of tokens offered
788      */
789     function amountSell(uint _id) external view returns (uint) {
790         if(_id>0){
791           return uint(asks[_id].amount);
792         }
793         return uint(asks[firstask].amount);
794     }
795 
796     /**
797      * @dev Report the amount of tokens of a bid order
798      * @param _id The id of the order
799      * @return The amount of tokens requested
800      */
801     function amountBuy(uint _id) external view returns (uint) {
802         if(_id>0){
803           return uint(bids[_id].amount);
804         }
805         return uint(bids[firstbid].amount);
806     }
807 
808     /**
809      * @dev Report the price of 1 token of an ask order
810      * @param _id The id of the order
811      * @return The requested price for 1 token
812      */
813     function priceSell(uint _id) external view returns (uint) {
814         if(_id>0){
815           return uint(asks[_id].price);
816         }
817         return uint(asks[firstask].price);
818     }
819 
820     /**
821      * @dev Report the price of 1 token of a bid order
822      * @param _id The id of the order
823      * @return The offered price for 1 token
824      */
825     function priceBuy(uint _id) external view returns (uint) {
826         if(_id>0){
827           return uint(bids[_id].price);
828         }
829         return uint(bids[firstbid].price);
830     }
831 
832 /* trade functions */
833 
834     /**
835      * @dev Cancel an ask order
836      * @param _id The id of the order
837      */
838     function cancelSell(uint _id) external {
839         require(asks[_id].price>0 && asks[_id].who==msg.sender);
840         users[msg.sender].tokens=uint120(uint(users[msg.sender].tokens).add(asks[_id].amount));
841         users[msg.sender].asks=uint120(uint(users[msg.sender].asks).sub(asks[_id].amount));
842         if(asks[_id].prev>0){
843           asks[asks[_id].prev].next=asks[_id].next;}
844         else{
845           firstask=asks[_id].next;}
846         if(asks[_id].next>0){
847           asks[asks[_id].next].prev=asks[_id].prev;}
848         emit LogCancelSell(msg.sender,asks[_id].amount,asks[_id].price);
849         delete(asks[_id]);
850     }
851 
852     /**
853      * @dev Cancel a bid order
854      * @param _id The id of the order
855      */
856     function cancelBuy(uint _id) external {
857         require(bids[_id].price>0 && bids[_id].who==msg.sender);
858         uint value=bids[_id].amount*bids[_id].price;
859         users[msg.sender].weis+=uint120(value);
860         if(bids[_id].prev>0){
861           bids[bids[_id].prev].next=bids[_id].next;}
862         else{
863           firstbid=bids[_id].next;}
864         if(bids[_id].next>0){
865           bids[bids[_id].next].prev=bids[_id].prev;}
866         emit LogCancelBuy(msg.sender,bids[_id].amount,bids[_id].price);
867         delete(bids[_id]);
868     }
869 
870     /**
871      * @dev Place and ask order (sell tokens)
872      * @param _amount The amount of tokens to sell
873      * @param _price The minimum price per token in wei
874      */
875     function sell(uint _amount, uint _price) external {
876         require(0 < _price && _price < maxPrice && 0 < _amount && _amount < maxTokens && _amount <= users[msg.sender].tokens);
877         commitDividend(msg.sender);
878         users[msg.sender].tokens-=uint120(_amount); //we will sell that much
879         uint funds=0;
880         uint amount=_amount;
881         for(;bids[firstbid].price>0 && bids[firstbid].price>=_price;){
882           uint value=uint(bids[firstbid].price)*uint(bids[firstbid].amount);
883           uint fee=value >> 9; //0.4% fee
884           if(amount>=bids[firstbid].amount){
885             amount=amount.sub(uint(bids[firstbid].amount));
886             commitDividend(bids[firstbid].who);
887             emit LogTransaction(msg.sender,bids[firstbid].who,bids[firstbid].amount,bids[firstbid].price);
888             //seller
889             //users[msg.sender].tokens-=bids[firstbid].amount;
890             funds=funds.add(value-fee-fee);
891             users[custodian].weis+=uint120(fee);
892             totalWeis=totalWeis.sub(fee);
893             //buyer
894             users[bids[firstbid].who].tokens+=bids[firstbid].amount;
895             //clear
896             uint64 next=bids[firstbid].next;
897             delete bids[firstbid];
898             firstbid=next; // optimize and move outside ?
899             if(amount==0){
900               break;}
901             continue;}
902           value=amount*uint(bids[firstbid].price);
903           fee=value >> 9; //0.4% fee
904           commitDividend(bids[firstbid].who);
905           funds=funds.add(value-fee-fee);
906           emit LogTransaction(msg.sender,bids[firstbid].who,amount,bids[firstbid].price);
907           //seller
908           //users[msg.sender].tokens-=amount;
909           users[custodian].weis+=uint120(fee);
910           totalWeis=totalWeis.sub(fee);
911           bids[firstbid].amount=uint96(uint(bids[firstbid].amount).sub(amount));
912           require(bids[firstbid].amount>0);
913           //buyer
914           users[bids[firstbid].who].tokens+=uint120(amount);
915           bids[firstbid].prev=0;
916           totalWeis=totalWeis.sub(funds);
917           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
918           require(success);
919           return;}
920         if(firstbid>0){
921           bids[firstbid].prev=0;}
922         if(amount>0){
923           uint64 ask=firstask;
924           uint64 last=0;
925           for(;asks[ask].price>0 && asks[ask].price<=_price;ask=asks[ask].next){
926             last=ask;}
927           lastask++;
928           asks[lastask].prev=last;
929           asks[lastask].next=ask;
930           asks[lastask].price=uint128(_price);
931           asks[lastask].amount=uint96(amount);
932           asks[lastask].who=msg.sender;
933           users[msg.sender].asks+=uint120(amount);
934           emit LogSell(msg.sender,amount,_price);
935           if(last>0){
936             asks[last].next=lastask;}
937           else{
938             firstask=lastask;}
939           if(ask>0){
940             asks[ask].prev=lastask;}}
941         if(funds>0){
942           totalWeis=totalWeis.sub(funds);
943           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
944           require(success);}
945     }
946 
947     /**
948      * @dev Place and bid order (buy tokens using Ether of the transaction)
949      * @param _amount The maximum amount of tokens to buy
950      * @param _price The maximum price per token in wei
951      */
952     function buy(uint _amount, uint _price) payable external {
953         require(0 < _price && _price < maxPrice && 0 < _amount && _amount < maxTokens && _price <= msg.value);
954         commitDividend(msg.sender);
955         uint funds=msg.value;
956         uint amount=_amount;
957         uint value;
958         for(;asks[firstask].price>0 && asks[firstask].price<=_price;){
959           value=uint(asks[firstask].price)*uint(asks[firstask].amount);
960           uint fee=value >> 9; //2*0.4% fee
961           if(funds>=value+fee+fee && amount>=asks[firstask].amount){
962             amount=amount.sub(uint(asks[firstask].amount));
963             commitDividend(asks[firstask].who);
964             funds=funds.sub(value+fee+fee);
965             emit LogTransaction(asks[firstask].who,msg.sender,asks[firstask].amount,asks[firstask].price);
966             //seller
967             users[asks[firstask].who].asks-=asks[firstask].amount;
968             users[asks[firstask].who].weis+=uint120(value);
969             users[custodian].weis+=uint120(fee);
970             totalWeis=totalWeis.add(value+fee);
971             //buyer
972             users[msg.sender].tokens+=asks[firstask].amount;
973             //clear
974             uint64 next=asks[firstask].next;
975             delete asks[firstask];
976             firstask=next; // optimize and move outside ?
977             if(funds<asks[firstask].price){
978               break;}
979             continue;}
980           if(amount>asks[firstask].amount){
981             amount=asks[firstask].amount;}
982           if((funds-(funds>>8))<amount*asks[firstask].price){
983             amount=(funds-(funds>>8))/asks[firstask].price;}
984           if(amount>0){
985             value=amount*uint(asks[firstask].price);
986             fee=value >> 9; //2*0.4% fee
987             commitDividend(asks[firstask].who);
988             funds=funds.sub(value+fee+fee);
989             emit LogTransaction(asks[firstask].who,msg.sender,amount,asks[firstask].price);
990             //seller
991             users[asks[firstask].who].asks-=uint120(amount);
992             users[asks[firstask].who].weis+=uint120(value);
993             users[custodian].weis+=uint120(fee);
994             totalWeis=totalWeis.add(value+fee);
995             asks[firstask].amount=uint96(uint(asks[firstask].amount).sub(amount));
996             require(asks[firstask].amount>0);
997             //buyer
998             users[msg.sender].tokens+=uint120(amount);}
999           asks[firstask].prev=0;
1000           if(funds>0){
1001             (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
1002             require(success);}
1003           return;}
1004         if(firstask>0){ //all orders removed
1005           asks[firstask].prev=0;}
1006         if(amount>funds/_price){
1007           amount=funds/_price;}
1008         if(amount>0){
1009           uint64 bid=firstbid;
1010           uint64 last=0;
1011           for(;bids[bid].price>0 && bids[bid].price>=_price;bid=bids[bid].next){
1012             last=bid;}
1013           lastbid++;
1014           bids[lastbid].prev=last;
1015           bids[lastbid].next=bid;
1016           bids[lastbid].price=uint128(_price);
1017           bids[lastbid].amount=uint96(amount);
1018           bids[lastbid].who=msg.sender;
1019           value=amount*_price;
1020           totalWeis=totalWeis.add(value);
1021           funds=funds.sub(value);
1022           emit LogBuy(msg.sender,amount,_price);
1023           if(last>0){
1024             bids[last].next=lastbid;}
1025           else{
1026             firstbid=lastbid;}
1027           if(bid>0){
1028             bids[bid].prev=lastbid;}}
1029         if(funds>0){
1030           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
1031           require(success);}
1032     }
1033 
1034 }