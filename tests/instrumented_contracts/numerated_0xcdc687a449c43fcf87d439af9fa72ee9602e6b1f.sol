1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18     }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25     * @dev Integer division of two numbers, truncating the quotient.
26     */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         // uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return a / b;
32     }
33 
34     /**
35     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36     */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43     * @dev Adds two numbers, throws on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46         c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82     function transferOwnership(address _newOwner) public onlyOwner {
83         _transferOwnership(_newOwner);
84     }
85 
86   /**
87    * @dev Transfers control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90     function _transferOwnership(address _newOwner) internal {
91         require(_newOwner != address(0x0));
92         emit OwnershipTransferred(owner, _newOwner);
93         owner = _newOwner;
94     }
95 }
96 
97 /**
98  * @title ERC20 interface
99  */
100 contract AbstractERC20 {
101     uint256 public totalSupply;
102     function balanceOf(address _owner) public constant returns (uint256 value);
103     function transfer(address _to, uint256 _value) public returns (bool _success);
104     function allowance(address owner, address spender) public constant returns (uint256 _value);
105     function transferFrom(address from, address to, uint256 value) public returns (bool _success);
106     function approve(address spender, uint256 value) public returns (bool _success);
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109 }
110 
111 contract LiquidToken is Ownable, AbstractERC20 {
112     
113     using SafeMath for uint256;
114 
115     string public name;
116     string public symbol;
117     uint8 public decimals;
118     
119     address public teamWallet;
120     address public advisorsWallet;
121     address public founderWallet;
122     address public bountyWallet;
123     
124     mapping (address => uint256) public balances;
125     /// The transfer allowances
126     mapping (address => mapping (address => uint256)) public allowed;
127     
128     mapping(address => bool) public isTeamOrAdvisorsOrFounder;
129 
130     event Burn(address indexed burner, uint256 value);
131     
132     constructor() public {
133     
134         name = "Liquid";
135         symbol = "LIQUID";
136         decimals = 18;
137         totalSupply = 58e6 * 10**18;    // 58 million tokens
138         owner = msg.sender;
139         balances[owner] = totalSupply;
140         emit Transfer(0x0, owner, totalSupply);
141     }
142 
143     /**
144     * @dev Check balance of given account address
145     * @param owner The address account whose balance you want to know
146     * @return balance of the account
147     */
148     function balanceOf(address owner) public view returns (uint256){
149         return balances[owner];
150     }
151 
152     /**
153     * @dev transfer token for a specified address (written due to backward compatibility)
154     * @param to address to which token is transferred
155     * @param value amount of tokens to transfer
156     * return bool true=> transfer is succesful
157     */
158     function transfer(address to, uint256 value) public returns (bool) {
159 
160         require(to != address(0x0));
161         require(value <= balances[msg.sender]);
162         balances[msg.sender] = balances[msg.sender].sub(value);
163         balances[to] = balances[to].add(value);
164         emit Transfer(msg.sender, to, value);
165         return true;
166     }
167 
168     /**
169     * @dev Transfer tokens from one address to another
170     * @param from address from which token is transferred 
171     * @param to address to which token is transferred
172     * @param value amount of tokens to transfer
173     * @return bool true=> transfer is succesful
174     */
175     function transferFrom(address from, address to, uint256 value) public returns (bool) {
176         require(to != address(0x0));
177         require(value <= balances[from]);
178         require(value <= allowed[from][msg.sender]);
179         balances[from] = balances[from].sub(value);
180         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value); 
181         balances[to] = balances[to].add(value);
182         emit Transfer(from, to, value);
183         return true;
184     }
185 
186     /**
187     * @dev Approve function will delegate spender to spent tokens on msg.sender behalf
188     * @param spender ddress which is delegated
189     * @param value tokens amount which are delegated
190     * @return bool true=> approve is succesful
191     */
192     function approve(address spender, uint256 value) public returns (bool) {
193         allowed[msg.sender][spender] = value;
194         emit Approval(msg.sender, spender, value);
195         return true;
196     }
197 
198     /**
199     * @dev it will check amount of token delegated to spender by owner
200     * @param owner the address which allows someone to spend fund on his behalf
201     * @param spender address which is delegated
202     * @return return uint256 amount of tokens left with delegator
203     */
204     function allowance(address owner, address spender) public view returns (uint256) {
205         return allowed[owner][spender];
206     }
207 
208     /**
209     * @dev increment the spender delegated tokens
210     * @param spender address which is delegated
211     * @param valueToAdd tokens amount to increment
212     * @return bool true=> operation is succesful
213     */
214     function increaseApproval(address spender, uint valueToAdd) public returns (bool) {
215         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(valueToAdd);
216         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
217         return true;
218     }
219 
220     /**
221     * @dev deccrement the spender delegated tokens
222     * @param spender address which is delegated
223     * @param valueToSubstract tokens amount to decrement
224     * @return bool true=> operation is succesful
225     */
226     function decreaseApproval(address spender, uint valueToSubstract) public returns (bool) {
227         uint oldValue = allowed[msg.sender][spender];
228         if (valueToSubstract > oldValue) {
229           allowed[msg.sender][spender] = 0;
230         } else {
231           allowed[msg.sender][spender] = oldValue.sub(valueToSubstract);
232         }
233         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
234         return true;
235     }
236 
237     /**
238     * @dev Burns a specific amount of tokens.
239     * @param _value The amount of token to be burned.
240     *
241     */
242     function burn(address _who, uint256 _value) public onlyOwner {
243         // no need to require value <= totalSupply, since that would imply the
244         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
245         balances[_who] = balances[_who].sub(_value);
246         totalSupply = totalSupply.sub(_value);
247         emit Burn(_who, _value);
248         emit Transfer(_who, address(0), _value);
249     }
250     
251         /**
252     * @dev set team wallet, funds of team will be allocated to a account controlled by admin/founder
253     * @param _teamWallet address of bounty wallet.
254     *
255     */
256     function setTeamWallet (address _teamWallet) public onlyOwner returns (bool) {
257         require(_teamWallet   !=  address(0x0));
258         if(teamWallet ==  address(0x0)){  
259             teamWallet    =   _teamWallet;
260             balances[teamWallet]  =   4e6 * 10**18;
261             balances[owner] = balances[owner].sub(balances[teamWallet]);
262         }else{
263             address oldTeamWallet =   teamWallet;
264             teamWallet    =   _teamWallet;
265             balances[teamWallet]  =   balances[oldTeamWallet];
266         }
267         return true;
268     }
269 
270     /**
271     * @dev set AdvisorsWallet, funds of team will be allocated to a account controlled by admin/founder
272     * @param _advisorsWallet address of Advisors wallet.
273     *
274     */
275     function setAdvisorsWallet (address _advisorsWallet) public onlyOwner returns (bool) {
276         require(_advisorsWallet   !=  address(0x0));
277         if(advisorsWallet ==  address(0x0)){  
278             advisorsWallet    =   _advisorsWallet;
279             balances[advisorsWallet]  =   2e6 * 10**18;
280             balances[owner] = balances[owner].sub(balances[teamWallet]);
281         }else{
282             address oldAdvisorsWallet =   advisorsWallet;
283             advisorsWallet    =   _advisorsWallet;
284             balances[advisorsWallet]  =   balances[oldAdvisorsWallet];
285         }
286         return true;
287     }
288 
289     /**
290     * @dev set Founders wallet, funds of team will be allocated to a account controlled by admin/founder
291     * @param _founderWallet address of Founder wallet.
292     *
293     */
294     function setFoundersWallet (address _founderWallet) public onlyOwner returns (bool) {
295         require(_founderWallet   !=  address(0x0));
296         if(founderWallet ==  address(0x0)){  
297             founderWallet    =   _founderWallet;
298             balances[founderWallet]  =  8e6 * 10**18;
299             balances[owner] = balances[owner].sub(balances[founderWallet]);
300         }else{
301             address oldFounderWallet =   founderWallet;
302             founderWallet    =   _founderWallet;
303             balances[founderWallet]  =   balances[oldFounderWallet];
304         }
305         return true;
306     }
307     /**
308     * @dev set bounty wallet
309     * @param _bountyWallet address of bounty wallet.
310     *
311     */
312     function setBountyWallet (address _bountyWallet) public onlyOwner returns (bool) {
313         require(_bountyWallet   !=  address(0x0));
314         if(bountyWallet ==  address(0x0)){  
315             bountyWallet    =   _bountyWallet;
316             balances[bountyWallet]  =   4e6 * 10**18;
317             balances[owner] = balances[owner].sub(balances[bountyWallet]);
318         }else{
319             address oldBountyWallet =   bountyWallet;
320             bountyWallet    =   _bountyWallet;
321             balances[bountyWallet]  =   balances[oldBountyWallet];
322         }
323         return true;
324     }
325 
326     /**
327     * @dev Function to Airdrop tokens from bounty wallet to contributors as long as there are enough balance.
328     * @param dests destination address of bounty beneficiary.
329     * @param values tokesn for beneficiary.
330     * @return number of address airdropped and True if the operation was successful.
331     */
332     function airdrop(address[] dests, uint256[] values) public onlyOwner returns (uint256, bool) {
333         require(dests.length == values.length);
334         uint8 i = 0;
335         while (i < dests.length && balances[bountyWallet] >= values[i]) {
336             balances[bountyWallet]  =   balances[bountyWallet].sub(values[i]);
337             balances[dests[i]]  =   balances[dests[i]].add(values[i]);
338             i += 1;
339         }
340         return (i, true);
341     }
342 
343     /**
344     * @dev Function to transferTokensToTeams tokens from Advisor wallet to contributors as long as there are enough balance.
345     * @param teamMember destination address of team beneficiary.
346     * @param values tokens for beneficiary.
347     * @return True if the operation was successful.
348     */
349     function transferTokensToTeams(address teamMember, uint256 values) public onlyOwner returns (bool) {
350         require(teamMember != address(0));
351         require (values != 0);
352         balances[teamWallet]  =   balances[teamWallet].sub(values);
353         balances[teamMember]  =   balances[teamMember].add(values);
354         isTeamOrAdvisorsOrFounder[teamMember] = true;
355         return true;
356     }
357      
358     /**
359     * @dev Function to transferTokensToFounders tokens from Advisor wallet to contributors as long as there are enough balance.
360     * @param founder destination address of team beneficiary.
361     * @param values tokens for beneficiary.
362     * @return True if the operation was successful.
363     */
364     function transferTokensToFounders(address founder, uint256 values) public onlyOwner returns (bool) {
365         require(founder != address(0));
366         require (values != 0);
367         balances[founderWallet]  =   balances[founderWallet].sub(values);
368         balances[founder]  =   balances[founder].add(values);
369         isTeamOrAdvisorsOrFounder[founder] = true;
370         return true;
371     }
372 
373     /**
374     * @dev Function to transferTokensToAdvisors tokens from Advisor wallet to contributors as long as there are enough balance.
375     * @param advisor destination address of team beneficiary.
376     * @param values tokens for beneficiary.
377     * @return True if the operation was successful.
378     */
379     function transferTokensToAdvisors(address advisor, uint256 values) public onlyOwner returns (bool) {
380         require(advisor != address(0));
381         require (values != 0);
382         balances[advisorsWallet]  =   balances[advisorsWallet].sub(values);
383         balances[advisor]  =   balances[advisor].add(values);
384         isTeamOrAdvisorsOrFounder[advisor] = true;
385         return true;
386     }
387 
388 }
389 
390 contract Crowdsale is LiquidToken {
391     
392     using SafeMath for uint256;
393 
394     address public ETHCollector;
395     uint256 public tokenCost = 140; //140 cents
396     uint256 public ETH_USD; //in cents
397     uint256 public saleStartDate;
398     uint256 public saleEndDate;
399     uint256 public softCap;
400     uint256 public hardCap; 
401     uint256 public minContribution = 28000; //280$ =280,00 cent
402     uint256 public tokensSold;
403     uint256 public weiCollected;
404     //Number of investors who have received refund
405     uint256 public countInvestorsRefunded;
406     uint256 public countTotalInvestors;
407     // Whether the Crowdsale is paused.
408     bool public paused;
409     bool public start;
410     bool public stop;
411     //Set status of refund
412     bool public refundStatus;
413     
414     //Structure to store token sent and wei received by the buyer of tokens
415     struct Investor {
416         uint256 investorID;
417         uint256 weiReceived;
418         uint256 tokenSent;
419     }
420     
421     //investors indexed by their ETH address
422     mapping(address => Investor) public investors;
423     mapping(address => bool) public isinvestor;
424     mapping(address => bool) public whitelist;
425     //investors indexed by their IDs
426     mapping(uint256 => address) public investorList;
427 
428     //event to log token supplied
429     event TokenSupplied(address beneficiary, uint256 tokens, uint256 value);   
430     event RefundedToInvestor(address indexed beneficiary, uint256 weiAmount);
431     event NewSaleEndDate(uint256 endTime);
432     event StateChanged(bool changed);
433 
434     modifier respectTimeFrame() {
435         require (start);
436         require(!paused);
437         require(now >= saleStartDate);
438         require(now <= saleEndDate);
439        _;
440     }
441 
442     constructor(address _ETHCollector) public {
443         ETHCollector = _ETHCollector;    
444         hardCap = 40e6 * 10**18;
445         softCap = 2e6 * 10**18;
446         //Initially no investor has been refunded
447         countInvestorsRefunded = 0;
448         //Refund eligible or not
449         refundStatus = false;
450     }
451     
452     //transfer ownership with token balance
453     function transferOwnership(address _newOwner) public onlyOwner {
454         super.transfer(_newOwner, balances[owner]);
455         _transferOwnership(_newOwner);
456     }
457 
458      //function to start sale
459     function startSale(uint256 _saleStartDate, uint256 _saleEndDate, uint256 _newETH_USD) public onlyOwner{
460        require (_saleStartDate < _saleEndDate);
461        require (now <= _saleStartDate);
462        assert(!start);
463        saleStartDate = _saleStartDate;
464        saleEndDate = _saleEndDate;  
465        start = true; 
466        ETH_USD = _newETH_USD;
467     }
468 
469     //function to finalize sale
470     function finalizeSale() public onlyOwner{
471         assert(start);
472         //end sale only when tokens is not sold and sale time is over OR,
473         //end time is not over and all tokens are sold
474         assert(!(tokensSold < hardCap && now < saleEndDate) || (hardCap.sub(tokensSold) <= 1e18));  
475         if(!softCapReached()){
476             refundStatus = true;
477         }
478         start = false;
479         stop = true;
480     }
481 
482     /**
483     * @dev called by the owner to stopInEmergency , triggers stopped state
484     */
485     function stopInEmergency() onlyOwner public {
486         require(!paused);
487         paused = true;
488         emit StateChanged(true);
489     }
490 
491     /**
492     * @dev after stopping crowdsale, the contract owner can release the crowdsale
493     * 
494     */
495     function release() onlyOwner public {
496         require(paused);
497         paused = false;
498         emit StateChanged(true);
499     }
500 
501     //function to set ETH_USD rate in cent. Eg: 1 ETH = 300 USD so we need to pass 300,00 cents
502     function setETH_USDRate(uint256 _newETH_USD) public onlyOwner {
503         require(_newETH_USD > 0);
504         ETH_USD = _newETH_USD;
505     }
506 
507     //function to change token cost
508     function changeTokenCost(uint256 _tokenCost) public onlyOwner {
509         require(_tokenCost > 0);
510         tokenCost = _tokenCost;
511     }
512 
513     //funcion to change minContribution
514     //_minContribution parameter should be in cent 
515     function changeMinContribution(uint256 _minContribution) public onlyOwner {
516         require(_minContribution > 0);
517         minContribution = _minContribution;
518     }
519 
520     //function to increase time
521     function extendTime(uint256 _newEndSaleDate) onlyOwner public {
522         //current time should always be less than endTime+extendedTime
523         require(saleEndDate < _newEndSaleDate);
524         require(_newEndSaleDate != 0);
525         saleEndDate = _newEndSaleDate;
526         emit NewSaleEndDate(saleEndDate);
527     }
528     
529     
530     // function to add single whitelist
531     function addWhitelistAddress(address addr) public onlyOwner{
532         require (!whitelist[addr]); 
533         require(addr != address(0x0));
534         // owner approves buyers by address when they pass the whitelisting procedure
535         whitelist[addr] = true;
536     }
537     
538     /**
539     * @dev add addresses to the whitelist
540     * @return true if at least one address was added to the whitelist,
541     * false if all addresses were already in the whitelist
542     */
543     function addWhitelistAddresses(address[] _addrs) public onlyOwner{
544         for (uint256 i = 0; i < _addrs.length; i++) {
545             addWhitelistAddress(_addrs[i]);        
546         }
547     }
548 
549     function transfer(address to, uint256 value) public returns (bool){
550         if(isinvestor[msg.sender]){
551             //sale has ended
552             require(stop);
553             super.transfer(to, value);
554         }
555         
556         else if(isTeamOrAdvisorsOrFounder[msg.sender]){
557             //180 days = 6 months
558             require(now > saleEndDate.add(180 days));
559             super.transfer(to, value);
560         }
561         else {
562             super.transfer(to, value);
563         }
564     }
565 
566     function transferFrom(address from, address to, uint256 value) public returns (bool){
567         if(isinvestor[from]){
568             //sale has ended
569             require(stop);
570             super.transferFrom(from, to, value);
571         } 
572          else if(isTeamOrAdvisorsOrFounder[from]){
573             //180 days = 6 months
574             require(now > saleEndDate.add(180 days));
575             super.transferFrom(from,to, value);
576         } 
577         else {
578            super.transferFrom(from, to, value);
579         }
580     }
581     
582     //function to buy tokens
583     function buyTokens (address beneficiary) public payable respectTimeFrame {
584         // only approved buyers can call this function
585         require(whitelist[beneficiary]);
586         // No contributions below the minimum
587         require(msg.value >= getMinContributionInWei());
588 
589         uint256 tokenToTransfer = getTokens(msg.value);
590 
591         // Check if the CrowdSale hard cap will be exceeded
592         require(tokensSold.add(tokenToTransfer) <= hardCap);
593         tokensSold = tokensSold.add(tokenToTransfer);
594 
595         //initializing structure for the address of the beneficiary
596         Investor storage investorStruct = investors[beneficiary];
597 
598         //Update investor's balance
599         investorStruct.tokenSent = investorStruct.tokenSent.add(tokenToTransfer);
600         investorStruct.weiReceived = investorStruct.weiReceived.add(msg.value);
601 
602         //If it is a new investor, then create a new id
603         if(investorStruct.investorID == 0){
604             countTotalInvestors++;
605             investorStruct.investorID = countTotalInvestors;
606             investorList[countTotalInvestors] = beneficiary;
607         }
608 
609         isinvestor[beneficiary] = true;
610         ETHCollector.transfer(msg.value);
611         
612         weiCollected = weiCollected.add(msg.value);
613         
614         balances[owner] = balances[owner].sub(tokenToTransfer);
615         balances[beneficiary] = balances[beneficiary].add(tokenToTransfer);
616 
617         emit TokenSupplied(beneficiary, tokenToTransfer, msg.value);
618     }
619 
620     /**
621     * @dev payable function to accept ether.
622     *
623     */
624     function () external payable  {
625         buyTokens(msg.sender);
626     }
627 
628     /*
629     * Refund the investors in case target of crowdsale not achieved
630     */
631     function refund() public onlyOwner {
632         assert(refundStatus);
633         uint256 batchSize = countInvestorsRefunded.add(50) < countTotalInvestors ? countInvestorsRefunded.add(50): countTotalInvestors;
634         for(uint256 i = countInvestorsRefunded.add(1); i <= batchSize; i++){
635             address investorAddress = investorList[i];
636             Investor storage investorStruct = investors[investorAddress];
637             //return everything
638             investorAddress.transfer(investorStruct.weiReceived);
639             //burn investor tokens and total supply isTeamOrAdvisorsOrFounder
640             burn(investorAddress, investorStruct.tokenSent);
641             //set everything to zero after transfer successful
642             investorStruct.weiReceived = 0;
643             investorStruct.tokenSent = 0;
644         }
645         //Update the number of investors that have recieved refund
646         countInvestorsRefunded = batchSize;
647     }
648 
649     /*
650     * Failsafe drain
651     */
652     function drain() public onlyOwner {
653         ETHCollector.transfer(address(this).balance);
654     }
655 
656     /*
657     * Function to add Ether in the contract 
658     */
659     function fundContractForRefund()public payable{
660     }
661 
662     /**
663     *
664     *getter functions
665     *
666     *
667     */
668     //function to return the number of tokens sent to investor
669     
670     function getTokens(uint256 weiReceived) internal view returns(uint256){
671         uint256 tokens;
672         //Token Sale Stage 1 = Dates Start 10/15/18 End 10/31/18 35% discount
673         if(now >= saleStartDate && now <= saleStartDate.add(10 days)){
674             tokens = getTokensForWeiReceived(weiReceived);
675             tokens = tokens.mul(100 + 60) / 100;
676         //Token Sale Stage 2 = Dates Start 11/1/18 End 11/15/18 20% discount    
677         }else if (now > saleStartDate.add(10 days) && now <= saleStartDate.add(25 days)){
678             tokens = getTokensForWeiReceived(weiReceived);
679             tokens = tokens.mul(100 + 50) / 100;
680         //Token Sale Stage 3 = Dates Start 11/16/18 End 11/30/18 No discount    
681         }else if (now > saleStartDate.add(25 days)  && now <= saleEndDate){
682             tokens = getTokensForWeiReceived(weiReceived);
683             tokens = tokens.mul(100 + 30) / 100;
684         }
685         return tokens;
686     }
687 
688     //function to get tokens number for eth send
689     function getTokensForWeiReceived(uint256 _weiAmount) internal view returns (uint256) {
690         return _weiAmount.mul(ETH_USD).div(tokenCost);
691     }
692 
693     //function to check softcap reached or not
694     function softCapReached() view public returns(bool) {
695         return tokensSold >= softCap;
696     }
697 
698     //getSaleStage will return current sale stage
699     function getSaleStage() view public returns(uint8){
700         if(now >= saleStartDate && now <= saleStartDate.add(10 days)){
701             return 1;
702         }else if(now > saleStartDate.add(10 days) && now <= saleStartDate.add(25 days)){
703             return 2;
704         }else if (now > saleStartDate.add(25 days)  && now <= saleEndDate){
705             return 3;
706         }
707     }
708     
709     //get minimum contribution in wei
710      function getMinContributionInWei() public view returns(uint256){
711         return (minContribution.mul(1e18)).div(ETH_USD);
712     }
713     
714     //is address whitelisted
715     function isAddressWhitelisted(address addr) public view returns(bool){
716         return whitelist[addr];
717     }
718 }