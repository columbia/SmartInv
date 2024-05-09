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
180     string public constant name = "PicoStocks Asset";
181     uint public constant decimals = 0;
182     uint public picoid = 0; // Asset ID on PicoStocks
183     string public symbol = ""; // Asset code on PicoStocks
184     string public www = ""; // Official web page
185 
186     uint public totalWeis = 0; // sum of wei owned by users
187     uint public totalVotes = 0;  // number of alligible votes
188 
189     struct Order {
190         uint64 prev;   // previous order, need this to enable safe/fast order cancel
191         uint64 next;   // next order
192         uint128 price; // offered/requested price of 1 token
193         uint96 amount; // number of offered/requested tokens
194         address who;   // address of owner of tokens or funds
195     }
196     mapping (uint => Order) asks;
197     mapping (uint => Order) bids;
198     uint64 firstask=0; // key of lowest ask
199     uint64 lastask=0;  // key of last inserted ask
200     uint64 firstbid=0; // key of highest bid
201     uint64 lastbid=0;  // key of last inserted bid
202 
203     uint constant weekBlocks = 4*60*24*7; // number of blocks in 1 week
204     uint constant minPrice  = 0xFFFF;                             // min price per token
205     uint constant maxPrice  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF; // max price per token
206     uint constant maxTokens = 0xFFFFFFFFFFFFFFFFFFFFFFFF;         // max number of tokens
207 
208     address public custodian = 0xd720a4768CACE6d508d8B390471d83BA3aE6dD32;
209 
210     // investment parameters
211     uint public investPrice; // price of 1 token
212     uint public investStart; // first block of funding round
213     uint public investEnd;   // last block of funding round
214     uint public investGot;   // funding collected
215     uint public investMin;   // minimum funding
216     uint public investMax;   // maximum funding
217     uint public investKYC = 1;   // KYC requirement
218 
219     //dividends
220     uint[] public dividends; // dividens collected per period, growing array
221 
222     //proposal
223     uint public proposalID = 1;   // proposal number and dividend period
224     uint public proposalVotesYes; // yes-votes collected
225     uint public proposalVotesNo;  // no-votes collected
226     uint public proposalBlock;    // block number proposal published
227     uint public proposalDividendPerShare; // dividend per share
228     uint public proposalBudget;   // budget for the owner for next period
229     uint public proposalTokens;   // number of new tokens for next round
230     uint public proposalPrice;    // price of new token in next round
231     uint public acceptedBudget;   // unspent budget for the owner in current round
232 
233     //change owner
234     mapping (address => uint) owners; // votes for new owners / managers of the contract
235 
236     // events
237     event LogBuy(address indexed who, uint amount, uint price);
238     event LogSell(address indexed who, uint amount, uint price);
239     event LogCancelBuy(address indexed who, uint amount, uint price);
240     event LogCancelSell(address indexed who, uint amount, uint price);
241     event LogTransaction(address indexed from, address indexed to, uint amount, uint price);
242     event LogDeposit(address indexed who,uint amount);
243     event LogWithdraw(address indexed who,uint amount);
244     event LogExec(address indexed who,uint amount);
245     event LogPayment(address indexed who, address from, uint amount);
246     event LogDividend(uint amount);
247     event LogDividend(address indexed who, uint amount, uint period);
248     event LogNextInvestment(uint price,uint amount);
249     event LogNewOwner(address indexed who);
250     event LogNewCustodian(address indexed who);
251     event LogNewWww(string www);
252     event LogProposal(uint dividendpershare,uint budget,uint moretokens,uint minprice);
253     event LogVotes(uint proposalVotesYes,uint proposalVotesNo);
254     event LogBudget(uint proposalBudget);
255     event LogAccepted(uint proposalDividendPerShare,uint proposalBudget,uint proposalTokens,uint proposalPrice);
256     event LogRejected(uint proposalDividendPerShare,uint proposalBudget,uint proposalTokens,uint proposalPrice);
257     
258     modifier onlyOwner() {
259         assert(msg.sender == owner);
260         _;
261     }
262 
263     // constructor
264     /**
265      * @dev Contract constructor
266      */
267     constructor() public {
268         owner = msg.sender;
269     }
270 
271 /* initial investment functions */
272 
273     /**
274      * @dev Set first funding round parameters
275      * @param _tokens number of tokens given to admin
276      * @param _budget initial approved budget
277      * @param _price price of 1 token in first founding round
278      * @param _from block number of start of funding round
279      * @param _to block number of end of funding round
280      * @param _min minimum number of tokens to sell
281      * @param _max maximum number of tokens to sell
282      * @param _kyc require KYC during first investment round
283      * @param _picoid asset id on picostocks
284      * @param _symbol asset symmbol on picostocks
285      */
286     function setFirstInvestPeriod(uint _tokens,uint _budget,uint _price,uint _from,uint _to,uint _min,uint _max,uint _kyc,uint _picoid,string memory _symbol) public onlyOwner {
287         require(investPrice == 0 && block.number < _from && _from < _to && _to < _from + weekBlocks*12 && _price > minPrice && _price < maxPrice && _max > 0 && _max > _min && _max < maxTokens );
288         if(_tokens==0){
289             _tokens=1;
290         }
291         totalSupply = _tokens;
292         acceptedBudget = _budget;
293         users[owner].tokens = uint120(_tokens);
294         users[owner].lastProposalID = uint32(proposalID);
295         users[custodian].lastProposalID = uint32(proposalID);
296         investPrice = _price;
297         investStart = _from;
298         investEnd = _to;
299         investMin = _min;
300         investMax = _max;
301         investKYC = _kyc;
302         picoid = _picoid;
303         symbol = _symbol;
304         dividends.push(0); // not used
305         dividends.push(0); // current dividend
306     }
307 
308     /**
309      * @dev Accept address for first investment
310      * @param _who accepted address (investor)
311      */
312     function acceptKYC(address _who) external onlyOwner {
313         if(users[_who].lastProposalID==0){
314           users[_who].lastProposalID=1;
315         }
316     }
317 
318     /**
319      * @dev Buy tokens
320      */
321     function invest() payable public {
322         commitDividend(msg.sender);
323         require(msg.value > 0 && block.number >= investStart && block.number < investEnd && totalSupply < investMax && investPrice > 0);
324         uint tokens = msg.value / investPrice;
325         if(investMax < totalSupply.add(tokens)){
326             tokens = investMax.sub(totalSupply);
327         }
328         totalSupply += tokens;
329         users[msg.sender].tokens += uint120(tokens);
330         emit Transfer(address(0),msg.sender,tokens);
331         uint _value = msg.value.sub(tokens * investPrice);
332         if(_value > 0){ // send back excess funds immediately
333             emit LogWithdraw(msg.sender,_value);
334             (bool success, /*bytes memory _unused*/) = msg.sender.call.value(_value)("");
335             require(success);
336         }
337         if(totalSupply>=investMax){
338             closeInvestPeriod();
339         }
340     }
341 
342     /**
343      * @dev Buy tokens
344      */
345     function () payable external {
346         invest();
347     }
348 
349     /**
350      * @dev Return wei to token owners if first funding round failes
351      */
352     function disinvest() public {
353         require(0 < investEnd && investEnd < block.number && totalSupply < investMin);
354         payDividend((address(this).balance-totalWeis)/totalSupply); //CHANGED
355         investEnd += weekBlocks*4; // enable future dividend payment if contract has funds
356     }
357 
358 /* management functions */
359 
360     /**
361      * @dev Propose dividend, budget and optional funding parameters for next round
362      * @param _dividendpershare amount of wei per share to pay out
363      * @param _budget amount of wei to give to owner
364      * @param _tokens amount of new tokens to issue
365      * @param _price price of 1 new token
366      */
367     function propose(uint _dividendpershare,uint _budget,uint _tokens,uint _price) external onlyOwner {
368         require(proposalBlock + weekBlocks*4 < block.number && 0 < investEnd && investEnd < block.number); //can not send more than 1 proposal per 28 days
369         if(block.number>investEnd && investStart>0 && investPrice>0 && investMax>0){
370           totalVotes=totalSupply;
371           investStart=0;
372           investMax=0;
373         }
374         proposalVotesYes=0;
375         proposalVotesNo=0;
376         proposalID=proposalID+1;
377         dividends.push(0);
378         proposalBlock=block.number;
379         proposalDividendPerShare=_dividendpershare;
380         proposalBudget=_budget;
381         proposalTokens=_tokens;
382         proposalPrice=_price;
383         emit LogProposal(_dividendpershare,_budget,_tokens,_price);
384     }
385 
386     /**
387      * @dev Execute proposed plan if passed
388      */
389     function executeProposal() public {
390         require(proposalVotesYes > 0 && (proposalBlock + weekBlocks*4 < block.number || proposalVotesYes>totalVotes/2 || proposalVotesNo>totalVotes/2));
391         //old require(proposalVotesYes > 0);
392         emit LogVotes(proposalVotesYes,proposalVotesNo);
393         if(proposalVotesYes >= proposalVotesNo && (proposalTokens==0 || proposalPrice>=investPrice || proposalVotesYes>totalVotes/2)){
394           if(payDividend(proposalDividendPerShare) > 0){
395             emit LogBudget(proposalBudget);
396             acceptedBudget=proposalBudget;}
397           if(proposalTokens>0){
398             emit LogNextInvestment(proposalPrice,proposalTokens);
399             setNextInvestPeriod(proposalPrice,proposalTokens);}
400           emit LogAccepted(proposalDividendPerShare,proposalBudget,proposalTokens,proposalPrice);}
401         else{
402           emit LogRejected(proposalDividendPerShare,proposalBudget,proposalTokens,proposalPrice);}
403         proposalBlock=0;
404         proposalVotesYes=0;
405         proposalVotesNo=0;
406         proposalDividendPerShare=0;
407         proposalBudget=0;
408         proposalTokens=0;
409         proposalPrice=0;
410     }
411 
412     /**
413      * @dev Set next funding round parameters
414      * @param _price price of 1 new token
415      * @param _tokens amount of new tokens to issue
416      */
417     function setNextInvestPeriod(uint _price,uint _tokens) internal {
418         require(totalSupply >= investMin && _price < maxPrice && totalSupply + _tokens < 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
419         investStart = block.number + weekBlocks*2;
420         investEnd = block.number + weekBlocks*4;
421         investPrice = _price; // too high price will disable future investments
422         investMax = totalSupply + _tokens;
423         investKYC=0;
424     }
425 
426     /**
427      * @dev Finish funding round and update voting power
428      */
429     function closeInvestPeriod() public {
430         require((block.number>investEnd || totalSupply>=investMax) && investStart>0 && investPrice>0 && investMax>0);
431         proposalID ++ ;
432         dividends.push(0);
433         totalVotes=totalSupply;
434         investStart=0;
435         investMax=0;
436         investKYC=0;
437     }
438 
439     /**
440      * @dev Pay dividend per share 
441      * @param _wei The amount of wei to pay per share
442      */
443     function payDividend(uint _wei) internal returns (uint) {
444         if(_wei == 0){
445           return 1;}
446         //uint newdividend = _wei.mul(totalSupply);
447         uint newdividend = _wei * totalSupply;
448         require(newdividend / _wei == totalSupply);
449         if(address(this).balance < newdividend.add(totalWeis)){
450           emit LogDividend(0); //indicates failure
451           return 0;}
452         totalWeis += newdividend;
453         dividends[proposalID] = _wei;
454         proposalID ++ ;
455         dividends.push(0);
456         totalVotes=totalSupply;
457         emit LogDividend(_wei);
458         return(_wei);
459     }
460 
461     /**
462      * @dev Commit remaining dividends and update votes before transfer of tokens
463      * @param _who User to process
464      */
465     function commitDividend(address _who) public {
466         uint last = users[_who].lastProposalID;
467         require(investKYC==0 || last>0); // only authorized investors during KYC period
468         uint tokens=users[_who].tokens+users[_who].asks;
469         if((tokens==0) || (last==0)){
470             users[_who].lastProposalID=uint32(proposalID);
471             return;
472         }
473         if(last==proposalID) {
474             return;
475         }
476         if(tokens != users[_who].votes){
477             if(users[_who].owner != address(0)){
478                 owners[users[_who].owner] = owners[users[_who].owner].add(tokens).sub(uint(users[_who].votes));
479             }
480             users[_who].votes=uint120(tokens); // store voting power
481         }
482         uint balance = 0;
483         for(; last < proposalID ; last ++) {
484             balance += tokens * dividends[last];
485         }
486         users[_who].weis += uint120(balance);
487         users[_who].lastProposalID = uint32(last);
488         users[_who].voted=0;
489         emit LogDividend(_who,balance,last);
490     }
491 
492 /* administrative functions */
493 
494     /**
495      * @dev Change owner
496      * @param _who The address of new owner
497      */
498     function changeOwner(address _who) external onlyOwner {
499         assert(_who != address(0));
500         owner = _who;
501         emit LogNewOwner(_who);
502     }
503 
504     /**
505      * @dev Change the official www address
506      * @param _www The new www address
507      */
508     function changeWww(string calldata _www) external onlyOwner {
509         www=_www;
510         emit LogNewWww(_www);
511     }
512 
513     /**
514      * @dev Change owner
515      * @param _who The address of new owner
516      */
517     function changeCustodian(address _who) external { //CHANGED
518         assert(msg.sender == custodian);
519         assert(_who != address(0));
520         custodian = _who;
521         emit LogNewCustodian(_who);
522     }
523 
524     /**
525      * @dev Execute a call
526      * @param _to destination address
527      * @param _data The call data
528      */
529     function exec(address _to,bytes calldata _data) payable external onlyOwner {
530         emit LogExec(_to,msg.value);
531         (bool success, /*bytes memory _unused*/) =_to.call.value(msg.value)(_data);
532         require(success);
533     }
534 
535     /**
536      * @dev Withdraw funds from contract by contract owner / manager
537      * @param _amount The amount of wei to withdraw
538      * @param _who The addres to send wei to
539      */
540     function spend(uint _amount,address _who) external onlyOwner {
541         require(_amount > 0 && address(this).balance >= _amount.add(totalWeis) && totalSupply >= investMin);
542         acceptedBudget=acceptedBudget.sub(_amount); //check for excess withdrawal
543         if(_who == address(0)){
544           emit LogWithdraw(msg.sender,_amount);
545           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(_amount)("");
546           require(success);}
547         else{
548           emit LogWithdraw(_who,_amount);
549           (bool success, /*bytes memory _unused*/) = _who.call.value(_amount)("");
550           require(success);}
551     }
552 
553 /* user functions */
554 
555     /**
556      * @dev Vote to change contract owner / manager
557      * @param _who The addres of the proposed new contract owner / manager
558      */
559     function voteOwner(address _who) external {
560         require(_who != users[msg.sender].owner);
561         if(users[msg.sender].owner != address(0)){
562           owners[users[msg.sender].owner] = owners[users[msg.sender].owner].sub(users[msg.sender].votes);
563         }
564         users[msg.sender].owner=_who;
565         if(_who != address(0)){
566           owners[_who] = owners[_who].add(users[msg.sender].votes);
567           if(owners[_who] > totalVotes/2 && _who != owner){
568             owner = _who;
569             emit LogNewOwner(_who);
570           }
571         }
572     }
573 
574     /**
575      * @dev Vote in favor of the current proposal
576      */
577     function voteYes() public {
578         commitDividend(msg.sender);
579         require(users[msg.sender].voted == 0 && proposalBlock + weekBlocks*4 > block.number && proposalBlock > 0);
580         users[msg.sender].voted=1;
581         proposalVotesYes+=users[msg.sender].votes;
582     }
583 
584     /**
585      * @dev Vote against the current proposal
586      */
587     function voteNo() public {
588         commitDividend(msg.sender);
589         require(users[msg.sender].voted == 0 && proposalBlock + weekBlocks*4 > block.number && proposalBlock > 0);
590         users[msg.sender].voted=1;
591         proposalVotesNo+=users[msg.sender].votes;
592     }
593 
594     /**
595      * @dev Vote in favor of the proposal defined by ID
596      * @param _id Proposal ID
597      */
598     function voteYes(uint _id) external {
599         require(proposalID==_id);
600         voteYes();
601     }
602 
603     /**
604      * @dev Vote against the proposal defined by ID
605      * @param _id Proposal ID
606      */
607     function voteNo(uint _id) external {
608         require(proposalID==_id);
609         voteNo();
610     }
611 
612     /**
613      * @dev Store funds in contract
614      */
615     function deposit() payable external {
616         commitDividend(msg.sender); //CHANGED
617         users[msg.sender].weis += uint120(msg.value);
618         totalWeis += msg.value;
619         emit LogDeposit(msg.sender,msg.value);
620     }
621 
622     /**
623      * @dev Withdraw funds from contract
624      * @param _amount Amount of wei to withdraw
625      */
626     function withdraw(uint _amount) external {
627         commitDividend(msg.sender);
628         uint amount=_amount;
629         if(amount > 0){
630            require(users[msg.sender].weis >= amount);
631         }
632         else{
633            require(users[msg.sender].weis > 0);
634            amount=users[msg.sender].weis;
635         }
636         users[msg.sender].weis = uint120(uint(users[msg.sender].weis).sub(amount));
637         totalWeis = totalWeis.sub(amount);
638         //msg.sender.transfer(amount);
639         emit LogWithdraw(msg.sender,amount);
640         (bool success, /*bytes memory _unused*/) = msg.sender.call.value(amount)("");
641         require(success);
642     }
643 
644     /**
645      * @dev Wire funds from one user to another user
646      * @param _amount Amount of wei to wire
647      * @param _who Address of the user to wire to
648      */
649     function wire(uint _amount,address _who) external {
650         users[msg.sender].weis = uint120(uint(users[msg.sender].weis).sub(_amount));
651         users[_who].weis = uint120(uint(users[_who].weis).add(_amount));
652     }
653 
654     /**
655      * @dev Send wei to contract
656      * @param _who Address of the payee
657      */
658     function pay(address _who) payable external {
659         emit LogPayment(_who,msg.sender,msg.value);
660     }
661 
662 /* market view functions */
663 
664     /**
665      * @dev Return ask orders optionally filtered by user
666      * @param _who Optional address of the user
667      * @return An array of uint representing the (filtered) orders, 4 uints per order (id,price,amount,user)
668      */
669     function ordersSell(address _who) external view returns (uint[256] memory) {
670         uint[256] memory ret;
671         uint num=firstask;
672         uint id=0;
673         for(;asks[num].price>0 && id<64;num=uint(asks[num].next)){
674           if(_who!=address(0) && _who!=asks[num].who){
675             continue;
676           }
677           ret[4*id+0]=num;
678           ret[4*id+1]=uint(asks[num].price);
679           ret[4*id+2]=uint(asks[num].amount);
680           ret[4*id+3]=uint(asks[num].who);
681           id++;}
682         return ret;
683     }
684 
685     /**
686      * @dev Return bid orders optionally filtered by user
687      * @param _who Optional address of the user
688      * @return An array of uint representing the (filtered) orders, 4 uints per order (id,price,amount,user)
689      */
690     function ordersBuy(address _who) external view returns (uint[256] memory) {
691         uint[256] memory ret;
692         uint num=firstbid;
693         uint id=0;
694         for(;bids[num].price>0 && id<64;num=uint(bids[num].next)){
695           if(_who!=address(0) && _who!=bids[num].who){
696             continue;
697           }
698           ret[4*id+0]=num;
699           ret[4*id+1]=uint(bids[num].price);
700           ret[4*id+2]=uint(bids[num].amount);
701           ret[4*id+3]=uint(bids[num].who);
702           id++;}
703         return ret;
704     }
705 
706     /**
707      * @dev Find the ask order id for a user
708      * @param _who The address of the user
709      * @param _minprice Optional minimum price
710      * @param _maxprice Optional maximum price
711      * @return The id of the order
712      */
713     function findSell(address _who,uint _minprice,uint _maxprice) external view returns (uint) {
714         uint num=firstask;
715         for(;asks[num].price>0;num=asks[num].next){
716           if(_maxprice > 0 && asks[num].price > _maxprice){
717             return 0;}
718           if(_minprice > 0 && asks[num].price < _minprice){
719             continue;}
720           if(_who == asks[num].who){ //FIXED !!!
721             return num;}}
722     }
723 
724     /**
725      * @dev Find the bid order id for a user
726      * @param _who The address of the user
727      * @param _minprice Optional minimum price
728      * @param _maxprice Optional maximum price
729      * @return The id of the order
730      */
731     function findBuy(address _who,uint _minprice,uint _maxprice) external view returns (uint) {
732         uint num=firstbid;
733         for(;bids[num].price>0;num=bids[num].next){
734           if(_minprice > 0 && bids[num].price < _minprice){
735             return 0;}
736           if(_maxprice > 0 && bids[num].price > _maxprice){
737             continue;}
738           if(_who == bids[num].who){
739             return num;}}
740     }
741 
742     /**
743      * @dev Report the user address of an ask order
744      * @param _id The id of the order
745      * @return The address of the user placing the order
746      */
747     function whoSell(uint _id) external view returns (address) {
748         if(_id>0){
749           return address(asks[_id].who);
750         }
751         return address(asks[firstask].who);
752     }
753 
754     /**
755      * @dev Report the user address of a bid order
756      * @param _id The id of the order
757      * @return The address of the user placing the order
758      */
759     function whoBuy(uint _id) external view returns (address) {
760         if(_id>0){
761           return address(bids[_id].who);
762         }
763         return address(bids[firstbid].who);
764     }
765 
766     /**
767      * @dev Report the amount of tokens of an ask order
768      * @param _id The id of the order
769      * @return The amount of tokens offered
770      */
771     function amountSell(uint _id) external view returns (uint) {
772         if(_id>0){
773           return uint(asks[_id].amount);
774         }
775         return uint(asks[firstask].amount);
776     }
777 
778     /**
779      * @dev Report the amount of tokens of a bid order
780      * @param _id The id of the order
781      * @return The amount of tokens requested
782      */
783     function amountBuy(uint _id) external view returns (uint) {
784         if(_id>0){
785           return uint(bids[_id].amount);
786         }
787         return uint(bids[firstbid].amount);
788     }
789 
790     /**
791      * @dev Report the price of 1 token of an ask order
792      * @param _id The id of the order
793      * @return The requested price for 1 token
794      */
795     function priceSell(uint _id) external view returns (uint) {
796         if(_id>0){
797           return uint(asks[_id].price);
798         }
799         return uint(asks[firstask].price);
800     }
801 
802     /**
803      * @dev Report the price of 1 token of a bid order
804      * @param _id The id of the order
805      * @return The offered price for 1 token
806      */
807     function priceBuy(uint _id) external view returns (uint) {
808         if(_id>0){
809           return uint(bids[_id].price);
810         }
811         return uint(bids[firstbid].price);
812     }
813 
814 /* trade functions */
815 
816     /**
817      * @dev Cancel an ask order
818      * @param _id The id of the order
819      */
820     function cancelSell(uint _id) external {
821         require(asks[_id].price>0 && asks[_id].who==msg.sender);
822         users[msg.sender].tokens=uint120(uint(users[msg.sender].tokens).add(asks[_id].amount));
823         users[msg.sender].asks=uint120(uint(users[msg.sender].asks).sub(asks[_id].amount));
824         if(asks[_id].prev>0){
825           asks[asks[_id].prev].next=asks[_id].next;}
826         else{
827           firstask=asks[_id].next;}
828         if(asks[_id].next>0){
829           asks[asks[_id].next].prev=asks[_id].prev;}
830         emit LogCancelSell(msg.sender,asks[_id].amount,asks[_id].price);
831         delete(asks[_id]);
832     }
833 
834     /**
835      * @dev Cancel a bid order
836      * @param _id The id of the order
837      */
838     function cancelBuy(uint _id) external {
839         require(bids[_id].price>0 && bids[_id].who==msg.sender);
840         uint value=bids[_id].amount*bids[_id].price;
841         users[msg.sender].weis+=uint120(value);
842         if(bids[_id].prev>0){
843           bids[bids[_id].prev].next=bids[_id].next;}
844         else{
845           firstbid=bids[_id].next;}
846         if(bids[_id].next>0){
847           bids[bids[_id].next].prev=bids[_id].prev;}
848         emit LogCancelBuy(msg.sender,bids[_id].amount,bids[_id].price);
849         delete(bids[_id]);
850     }
851 
852     /**
853      * @dev Place and ask order (sell tokens)
854      * @param _amount The amount of tokens to sell
855      * @param _price The minimum price per token in wei
856      */
857     function sell(uint _amount, uint _price) external {
858         require(0 < _price && _price < maxPrice && 0 < _amount && _amount < maxTokens && _amount <= users[msg.sender].tokens);
859         commitDividend(msg.sender);
860         users[msg.sender].tokens-=uint120(_amount); //we will sell that much
861         uint funds=0;
862         uint amount=_amount;
863         for(;bids[firstbid].price>0 && bids[firstbid].price>=_price;){
864           uint value=uint(bids[firstbid].price)*uint(bids[firstbid].amount);
865           uint fee=value >> 9; //0.4% fee
866           if(amount>=bids[firstbid].amount){
867             amount=amount.sub(uint(bids[firstbid].amount));
868             commitDividend(bids[firstbid].who);
869             emit LogTransaction(msg.sender,bids[firstbid].who,bids[firstbid].amount,bids[firstbid].price);
870             //seller
871             //users[msg.sender].tokens-=bids[firstbid].amount;
872             funds=funds.add(value-fee-fee);
873             users[custodian].weis+=uint120(fee);
874             totalWeis=totalWeis.sub(fee);
875             //buyer
876             users[bids[firstbid].who].tokens+=bids[firstbid].amount;
877             //clear
878             uint64 next=bids[firstbid].next;
879             delete bids[firstbid];
880             firstbid=next; // optimize and move outside ?
881             if(amount==0){
882               break;}
883             continue;}
884           value=amount*uint(bids[firstbid].price);
885           fee=value >> 9; //0.4% fee
886           commitDividend(bids[firstbid].who);
887           funds=funds.add(value-fee-fee);
888           emit LogTransaction(msg.sender,bids[firstbid].who,amount,bids[firstbid].price);
889           //seller
890           //users[msg.sender].tokens-=amount;
891           users[custodian].weis+=uint120(fee);
892           totalWeis=totalWeis.sub(fee);
893           bids[firstbid].amount=uint96(uint(bids[firstbid].amount).sub(amount));
894           require(bids[firstbid].amount>0);
895           //buyer
896           users[bids[firstbid].who].tokens+=uint120(amount);
897           bids[firstbid].prev=0;
898           totalWeis=totalWeis.sub(funds);
899           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
900           require(success);
901           return;}
902         if(firstbid>0){
903           bids[firstbid].prev=0;}
904         if(amount>0){
905           uint64 ask=firstask;
906           uint64 last=0;
907           for(;asks[ask].price>0 && asks[ask].price<=_price;ask=asks[ask].next){
908             last=ask;}
909           lastask++;
910           asks[lastask].prev=last;
911           asks[lastask].next=ask;
912           asks[lastask].price=uint128(_price);
913           asks[lastask].amount=uint96(amount);
914           asks[lastask].who=msg.sender;
915           users[msg.sender].asks+=uint120(amount);
916           emit LogSell(msg.sender,amount,_price);
917           if(last>0){
918             asks[last].next=lastask;}
919           else{
920             firstask=lastask;}
921           if(ask>0){
922             asks[ask].prev=lastask;}}
923         if(funds>0){
924           totalWeis=totalWeis.sub(funds);
925           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
926           require(success);}
927     }
928 
929     /**
930      * @dev Place and bid order (buy tokens using Ether of the transaction)
931      * @param _amount The maximum amount of tokens to buy
932      * @param _price The maximum price per token in wei
933      */
934     function buy(uint _amount, uint _price) payable external {
935         require(0 < _price && _price < maxPrice && 0 < _amount && _amount < maxTokens && _price <= msg.value);
936         commitDividend(msg.sender);
937         uint funds=msg.value;
938         uint amount=_amount;
939         uint value;
940         for(;asks[firstask].price>0 && asks[firstask].price<=_price;){
941           value=uint(asks[firstask].price)*uint(asks[firstask].amount);
942           uint fee=value >> 9; //2*0.4% fee
943           if(funds>=value+fee+fee && amount>=asks[firstask].amount){
944             amount=amount.sub(uint(asks[firstask].amount));
945             commitDividend(asks[firstask].who);
946             funds=funds.sub(value+fee+fee);
947             emit LogTransaction(asks[firstask].who,msg.sender,asks[firstask].amount,asks[firstask].price);
948             //seller
949             users[asks[firstask].who].asks-=asks[firstask].amount;
950             users[asks[firstask].who].weis+=uint120(value);
951             users[custodian].weis+=uint120(fee);
952             totalWeis=totalWeis.add(value+fee);
953             //buyer
954             users[msg.sender].tokens+=asks[firstask].amount;
955             //clear
956             uint64 next=asks[firstask].next;
957             delete asks[firstask];
958             firstask=next; // optimize and move outside ?
959             if(funds<asks[firstask].price){
960               break;}
961             continue;}
962           if(amount>asks[firstask].amount){
963             amount=asks[firstask].amount;}
964           if((funds-(funds>>8))<amount*asks[firstask].price){
965             amount=(funds-(funds>>8))/asks[firstask].price;}
966           if(amount>0){
967             value=amount*uint(asks[firstask].price);
968             fee=value >> 9; //2*0.4% fee
969             commitDividend(asks[firstask].who);
970             funds=funds.sub(value+fee+fee);
971             emit LogTransaction(asks[firstask].who,msg.sender,amount,asks[firstask].price);
972             //seller
973             users[asks[firstask].who].asks-=uint120(amount);
974             users[asks[firstask].who].weis+=uint120(value);
975             users[custodian].weis+=uint120(fee);
976             totalWeis=totalWeis.add(value+fee);
977             asks[firstask].amount=uint96(uint(asks[firstask].amount).sub(amount));
978             require(asks[firstask].amount>0);
979             //buyer
980             users[msg.sender].tokens+=uint120(amount);}
981           asks[firstask].prev=0;
982           if(funds>0){
983             (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
984             require(success);}
985           return;}
986         if(firstask>0){ //all orders removed
987           asks[firstask].prev=0;}
988         if(amount>funds/_price){
989           amount=funds/_price;}
990         if(amount>0){
991           uint64 bid=firstbid;
992           uint64 last=0;
993           for(;bids[bid].price>0 && bids[bid].price>=_price;bid=bids[bid].next){
994             last=bid;}
995           lastbid++;
996           bids[lastbid].prev=last;
997           bids[lastbid].next=bid;
998           bids[lastbid].price=uint128(_price);
999           bids[lastbid].amount=uint96(amount);
1000           bids[lastbid].who=msg.sender;
1001           value=amount*_price;
1002           totalWeis=totalWeis.add(value);
1003           funds=funds.sub(value);
1004           emit LogBuy(msg.sender,amount,_price);
1005           if(last>0){
1006             bids[last].next=lastbid;}
1007           else{
1008             firstbid=lastbid;}
1009           if(bid>0){
1010             bids[bid].prev=lastbid;}}
1011         if(funds>0){
1012           (bool success, /*bytes memory _unused*/) = msg.sender.call.value(funds)("");
1013           require(success);}
1014     }
1015 
1016 }