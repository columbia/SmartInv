1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath for performing valid mathematics.
5  */
6 library SafeMath {
7  
8   function Mul(uint a, uint b) internal pure returns (uint) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function Div(uint a, uint b) internal pure returns (uint) {
15     //assert(b > 0); // Solidity automatically throws when Dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function Sub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   } 
25 
26   function Add(uint a, uint b) internal pure returns (uint) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   } 
31 }
32 
33 /**
34 * @title Contract that will work with ERC223 tokens.
35 */
36 contract ERC223ReceivingContract { 
37     /**
38      * @dev Standard ERC223 function that will handle incoming token transfers.
39      *
40      * @param _from  Token sender address.
41      * @param _value Amount of tokens.
42      * @param _data  Transaction metadata.
43      */
44     function tokenFallback(address _from, uint _value, bytes _data) public;
45 }
46 
47 /**
48  * Contract "Ownable"
49  * Purpose: Defines Owner for contract and provide functionality to transfer ownership to another account
50  */
51 contract Ownable {
52 
53   //owner variable to store contract owner account
54   address public owner;
55   //add another owner to transfer ownership
56   address oldOwner;
57 
58   //Constructor for the contract to store owner's account on deployement
59   function Ownable() public {
60     owner = msg.sender;
61     oldOwner = msg.sender;
62   }
63 
64   //modifier to check transaction initiator is only owner
65   modifier onlyOwner() {
66     require (msg.sender == owner || msg.sender == oldOwner);
67       _;
68   }
69 
70   //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
71   function transferOwnership(address newOwner) public onlyOwner {
72     require (newOwner != address(0));
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20 interface
80  */
81 contract ERC20 is Ownable {
82     uint256 public totalSupply;
83     function balanceOf(address _owner) public view returns (uint256 value);
84     function transfer(address _to, uint256 _value) public returns (bool _success);
85     function allowance(address owner, address spender) public view returns (uint256 _value);
86     function transferFrom(address from, address to, uint256 value) public returns (bool _success);
87     function approve(address spender, uint256 value) public returns (bool _success);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     event Transfer(address indexed _from, address indexed _to, uint _value);
90 }
91 
92 contract CTV is ERC20 {
93 
94     using SafeMath for uint256;
95     //The name of the  token
96     string public constant name = "Coin TV";
97     //The token symbol
98     string public constant symbol = "CTV";
99     //To denote the locking on transfer of tokens among token holders
100     bool public locked;
101     //The precision used in the calculations in contract
102     uint8 public constant decimals = 18;
103     //maximum number of tokens
104     uint256 constant MAXCAP = 29999990e18;
105     // maximum number of tokens that can be supplied by referrals
106     uint public constant MAX_REFERRAL_TOKENS = 2999999e18;
107     //set the softcap of ether received
108     uint256 constant SOFTCAP = 70 ether;
109     //Refund eligible or not
110     // 0: sale not started yet, refunding invalid
111     // 1: refund not required
112     // 2: softcap not reached, refund required
113     // 3: Refund in progress
114     // 4: Everyone refunded
115     uint256 public refundStatus = 0;
116     //the account which will receive all balance
117     address public ethCollector;
118     //to save total number of ethers received
119     uint256 public totalWeiReceived;
120     //count tokens earned by referrals
121     uint256 public tokensSuppliedFromReferral = 0;
122 
123     //Mapping to relate owner and spender to the tokens allowed to transfer from owner
124     mapping(address => mapping(address => uint256)) allowed;
125     //to manage referrals
126     mapping(address => address) public referredBy;
127     //Mapping to relate number of  token to the account
128     mapping(address => uint256) balances;
129 
130     //Structure for investors; holds received wei amount and Token sent
131     struct Investor {
132         //wei received during PreSale
133         uint weiReceived;
134         //Tokens sent during CrowdSale
135         uint tokensPurchased;
136         //user has been refunded or not
137         bool refunded;
138         //Uniquely identify an investor(used for iterating)
139         uint investorID;
140     }
141 
142     //time when the sale starts
143     uint256 public startTime;
144     //time when the presale ends
145     uint256 public endTime;
146     //to check the sale status
147     bool public saleRunning;
148     //investors indexed by their ETH address
149     mapping(address => Investor) public investors;
150     //investors indexed by their IDs
151     mapping (uint256 => address) public investorList;
152     //count number of investors
153     uint256 public countTotalInvestors;
154     //to keep track of how many investors have been refunded
155     uint256 countInvestorsRefunded;
156 
157     //events
158     event StateChanged(bool);
159 
160     function CTV() public{
161         totalSupply = 0;
162         startTime = 0;
163         endTime = 0;
164         saleRunning = false;
165         locked = true;
166         setEthCollector(0xAf3BBf663769De9eEb6C2b235262Cf704eD4EA4b);
167         mintAlreadyBoughtTokens(0x19566f85835e52e78edcfba440aea5e28783050b,66650000000000000000);
168         mintAlreadyBoughtTokens(0xcb969c937e724f1d36ea2fb576148d8286399806,666500000000000000000);
169         mintAlreadyBoughtTokens(0x43feda65c918642faf6186c8575fdbb582f4ecd5,2932600000000000000000);
170         mintAlreadyBoughtTokens(0x0c94e8579ab97dc2dd805bed3fa72af9cbe8e37c,1466300000000000000000);
171         mintAlreadyBoughtTokens(0xaddc8429aa246fedc40005ae4c7f340d94cbb05b,733150000000000000000);
172         
173         mintAlreadyBoughtTokens(0x99ea6d3bd3f4dd4447d0083d906d64cbeadba33a,733150000000000000000);
174         mintAlreadyBoughtTokens(0x99f9493b162ac63d2c61514739a701731ac72398,3665750000000000000000);
175         mintAlreadyBoughtTokens(0xa7e919d4d655d86382f76eb5e8151e99ecb4a0da,3470694090746885970870);
176         mintAlreadyBoughtTokens(0x1aa18bf38d97a1a68a0119d2287041909b4e6680,1626260000000000000000);
177         mintAlreadyBoughtTokens(0x90702a5432f97d01770365d52c312f96dc108e90,1466300000000000000000);
178         
179         mintAlreadyBoughtTokens(0x562ebcdfe25cfb1985f94836cdc23d3a1d32d8b5,733150000000000000000);
180         mintAlreadyBoughtTokens(0x437b405657f4ec00a34ce8b212e52b8a78a14b31,2932600000000000000000);
181         mintAlreadyBoughtTokens(0x23c36686b733acdd5266e429b5b132d3da607394,733150000000000000000);
182         mintAlreadyBoughtTokens(0xaf933e90e7cf328edeece1f043faed2c5856745e,733150000000000000000);
183         mintAlreadyBoughtTokens(0x1d3c7bb8a95ad08740fe2726dd183aa85ffc42f8,1466300000000000000000);
184         
185         mintAlreadyBoughtTokens(0xd01362b2d59276f8d5d353d180a8f30e2282a23e,733150000000000000);
186     }
187     //To handle ERC20 short address attack
188     modifier onlyPayloadSize(uint size) {
189         require(msg.data.length >= size + 4);
190         _;
191     }
192 
193     modifier onlyUnlocked() { 
194         require (!locked); 
195         _; 
196     }
197 
198     modifier validTimeframe(){
199         require(saleRunning && now >=startTime && now < endTime);
200         _;
201     }
202     
203     function setEthCollector(address _ethCollector) public onlyOwner{
204         require(_ethCollector != address(0));
205         ethCollector = _ethCollector;
206     }
207     
208     function startSale() public onlyOwner{
209         require(startTime == 0);
210         startTime = now;
211         endTime = startTime.Add(7 weeks);
212         saleRunning = true;
213     }
214 
215     //To enable transfer of tokens
216     function unlockTransfer() external onlyOwner{
217         locked = false;
218     }
219 
220     /**
221     * @dev Check if the address being passed belongs to a contract
222     *
223     * @param _address The address which you want to verify
224     * @return A bool specifying if the address is that of contract or not
225     */
226     function isContract(address _address) private view returns(bool _isContract){
227         assert(_address != address(0) );
228         uint length;
229         //inline assembly code to check the length of address
230         assembly{
231             length := extcodesize(_address)
232         }
233         if(length > 0){
234             return true;
235         }
236         else{
237             return false;
238         }
239     }
240 
241     /**
242     * @dev Check balance of given account address
243     *
244     * @param _owner The address account whose balance you want to know
245     * @return balance of the account
246     */
247     function balanceOf(address _owner) public view returns (uint256 _value){
248         return balances[_owner];
249     }
250 
251     /**
252     * @dev Transfer sender's token to a given address
253     *
254     * @param _to The address which you want to transfer to
255     * @param _value the amount of tokens to be transferred
256     * @return A bool if the transfer was a success or not
257     */
258     function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {
259         require( _to != address(0) );
260         bytes memory _empty;
261         if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){
262             balances[msg.sender] = balances[msg.sender].Sub(_value);
263             balances[_to] = balances[_to].Add(_value);
264             if(isContract(_to)){
265                 ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
266                 receiver.tokenFallback(msg.sender, _value, _empty);
267             }
268             Transfer(msg.sender, _to, _value);
269             return true;
270         }
271         else{
272             return false;
273         }
274     }
275 
276     /**
277     * @dev Transfer tokens to an address given by sender. To make ERC223 compliant
278     *
279     * @param _to The address which you want to transfer to
280     * @param _value the amount of tokens to be transferred
281     * @param _data additional information of account from where to transfer from
282     * @return A bool if the transfer was a success or not
283     */
284     function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {
285         if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){
286             balances[msg.sender] = balances[msg.sender].Sub(_value);
287             balances[_to] = balances[_to].Add(_value);
288             if(isContract(_to)){
289                 ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
290                 receiver.tokenFallback(msg.sender, _value, _data);
291             }
292             Transfer(msg.sender, _to, _value);
293             return true;
294         }
295         else{
296             return false;
297         }
298     }
299 
300     /**
301     * @dev Transfer tokens from one address to another, for ERC20.
302     *
303     * @param _from The address which you want to send tokens from
304     * @param _to The address which you want to transfer to
305     * @param _value the amount of tokens to be transferred
306     * @return A bool if the transfer was a success or not 
307     */
308     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){
309         bytes memory _empty;
310         if((_value > 0)
311            && (_to != address(0))
312        && (_from != address(0))
313        && (allowed[_from][msg.sender] > _value )){
314            balances[_from] = balances[_from].Sub(_value);
315            balances[_to] = balances[_to].Add(_value);
316            allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);
317            if(isContract(_to)){
318                ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
319                receiver.tokenFallback(msg.sender, _value, _empty);
320            }
321            Transfer(_from, _to, _value);
322            return true;
323        }
324        else{
325            return false;
326        }
327     }
328 
329     /**
330     * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.
331     *
332     * @param _owner address The address which owns the funds.
333     * @param _spender address The address which will spend the funds.
334     * @return A uint256 specifying the amount of tokens still available for the spender to spend.
335     */
336     function allowance(address _owner, address _spender) public view returns (uint256){
337         return allowed[_owner][_spender];
338     }
339 
340     /**
341     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
342     *
343     * @param _spender The address which will spend the funds.
344     * @param _value The amount of tokens to be spent.
345     */
346     function approve(address _spender, uint256 _value) public returns (bool){
347         if( (_value > 0) && (_spender != address(0)) && (balances[msg.sender] >= _value)){
348             allowed[msg.sender][_spender] = _value;
349             Approval(msg.sender, _spender, _value);
350             return true;
351         }
352         else{
353             return false;
354         }
355     }
356 
357     /**
358     * @dev Calculate number of tokens that will be received in one ether
359     * 
360     */
361     function getPrice() public view returns(uint256) {
362         uint256 price;
363         if(totalSupply <= 1e6*1e18)
364             price = 13330;
365         else if(totalSupply <= 5e6*1e18)
366             price = 12500;
367         else if(totalSupply <= 9e6*1e18)
368             price = 11760;
369         else if(totalSupply <= 13e6*1e18)
370             price = 11110;
371         else if(totalSupply <= 17e6*1e18)
372             price = 10520;
373         else if(totalSupply <= 21e6*1e18)
374             price = 10000;
375         else{
376             //zero indicates that no tokens will be allocated when total supply
377             //of 21 million tokens is reached
378             price = 0;
379         }
380         return price;
381     }
382     
383     function mintAndTransfer(address beneficiary, uint256 numberOfTokensWithoutDecimal, bytes comment) public onlyOwner {
384         uint256 tokensToBeTransferred = numberOfTokensWithoutDecimal*1e18;
385         require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);
386         totalSupply = totalSupply.Add(tokensToBeTransferred);
387         Transfer(0x0, beneficiary ,tokensToBeTransferred);
388     }
389     
390     function mintAlreadyBoughtTokens(address beneficiary, uint256 tokensBought)internal{
391         //Make entry in Investor indexed with address
392         Investor storage investorStruct = investors[beneficiary];
393         //If it is a new investor, then create a new id
394         if(investorStruct.investorID == 0){
395             countTotalInvestors++;
396             investorStruct.investorID = countTotalInvestors;
397             investorList[countTotalInvestors] = beneficiary;
398         }
399         investorStruct.weiReceived = investorStruct.weiReceived + tokensBought/13330;
400         investorStruct.tokensPurchased = investorStruct.tokensPurchased + tokensBought;
401         balances[beneficiary] = balances[beneficiary] + tokensBought;
402         totalWeiReceived = totalWeiReceived + tokensBought/13330;
403         totalSupply = totalSupply + tokensBought;
404         
405         Transfer(0x0, beneficiary ,tokensBought);
406     }
407 
408     /**
409     * @dev to enable pause sale for break in ICO and Pre-ICO
410     *
411     */
412     function pauseSale() public onlyOwner{
413         assert(saleRunning && startTime > 0 && now <= endTime);
414         saleRunning = false;
415     }
416 
417     /**
418     * @dev to resume paused sale
419     *
420     */
421     function resumeSale() public onlyOwner{
422         assert(!saleRunning && startTime > 0 && now <= endTime);
423         saleRunning = true;
424     }
425 
426     function buyTokens(address beneficiary) internal validTimeframe {
427         uint256 tokensBought = msg.value.Mul(getPrice());
428         balances[beneficiary] = balances[beneficiary].Add(tokensBought);
429         Transfer(0x0, beneficiary ,tokensBought);
430         totalSupply = totalSupply.Add(tokensBought);
431 
432         //Make entry in Investor indexed with address
433         Investor storage investorStruct = investors[beneficiary];
434         //If it is a new investor, then create a new id
435         if(investorStruct.investorID == 0){
436             countTotalInvestors++;
437             investorStruct.investorID = countTotalInvestors;
438             investorList[countTotalInvestors] = beneficiary;
439         }
440         investorStruct.weiReceived = investorStruct.weiReceived.Add(msg.value);
441         investorStruct.tokensPurchased = investorStruct.tokensPurchased.Add(tokensBought);
442     
443         
444         //Award referral tokens
445         if(referredBy[msg.sender] != address(0) && tokensSuppliedFromReferral.Add(tokensBought/10) < MAX_REFERRAL_TOKENS){
446             //give 10% referral tokens
447             balances[referredBy[msg.sender]] = balances[referredBy[msg.sender]].Add(tokensBought/10);
448             tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/10);
449             totalSupply = totalSupply.Add(tokensBought/10);
450             Transfer(0x0, referredBy[msg.sender] ,tokensBought);
451         }
452         //if referrer was also referred by someone
453         if(referredBy[referredBy[msg.sender]] != address(0) && tokensSuppliedFromReferral.Add(tokensBought/100) < MAX_REFERRAL_TOKENS){
454             tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/100);
455             //give 1% tokens to 2nd generation referrer
456             balances[referredBy[referredBy[msg.sender]]] = balances[referredBy[referredBy[msg.sender]]].Add(tokensBought/100);
457             totalSupply = totalSupply.Add(tokensBought/100);
458             Transfer(0x0, referredBy[referredBy[msg.sender]] ,tokensBought);
459         }
460         
461         assert(totalSupply <= MAXCAP);
462         totalWeiReceived = totalWeiReceived.Add(msg.value);
463         ethCollector.transfer(msg.value);
464     }
465 
466     /**
467      * @dev This function is used to register a referral.
468      * Whoever calls this function, is telling contract,
469      * that "I was referred by referredByAddress"
470      * Whenever I am going to buy tokens, 10% will be awarded to referredByAddress
471      * 
472      * @param referredByAddress The address of person who referred the person calling this function
473      */
474     function registerReferral (address referredByAddress) public {
475         require(msg.sender != referredByAddress && referredByAddress != address(0));
476         referredBy[msg.sender] = referredByAddress;
477     }
478     
479     /**
480      * @dev Owner is allowed to manually register who was referred by whom
481      * @param heWasReferred The address of person who was referred
482      * @param I_referred_this_person The person who referred the above address
483      */
484     function referralRegistration(address heWasReferred, address I_referred_this_person) public onlyOwner {
485         require(heWasReferred != address(0) && I_referred_this_person != address(0));
486         referredBy[heWasReferred] = I_referred_this_person;
487     }
488 
489     /**
490     * Finalize the crowdsale
491     */
492     function finalize() public onlyOwner {
493         //Make sure Sale is running
494         assert(saleRunning);
495         if(MAXCAP.Sub(totalSupply) <= 1 ether || now > endTime){
496             //now sale can be finished
497             saleRunning = false;
498         }
499 
500         //Refund eligible or not
501         // 0: sale not started yet, refunding invalid
502         // 1: refund not required
503         // 2: softcap not reached, refund required
504         // 3: Refund in progress
505         // 4: Everyone refunded
506 
507         //Checks if the fundraising goal is reached in crowdsale or not
508         if (totalWeiReceived < SOFTCAP)
509             refundStatus = 2;
510         else
511             refundStatus = 1;
512 
513         //crowdsale is ended
514         saleRunning = false;
515         //enable transferring of tokens among token holders
516         locked = false;
517         //Emit event when crowdsale state changes
518         StateChanged(true);
519     }
520 
521     /**
522     * Refund the investors in case target of crowdsale not achieved
523     */
524     function refund() public onlyOwner {
525         assert(refundStatus == 2 || refundStatus == 3);
526         uint batchSize = countInvestorsRefunded.Add(30) < countTotalInvestors ? countInvestorsRefunded.Add(30): countTotalInvestors;
527         for(uint i=countInvestorsRefunded.Add(1); i <= batchSize; i++){
528             address investorAddress = investorList[i];
529             Investor storage investorStruct = investors[investorAddress];
530             //If purchase has been made during CrowdSale
531             if(investorStruct.tokensPurchased > 0 && investorStruct.tokensPurchased <= balances[investorAddress]){
532                 //return everything
533                 investorAddress.transfer(investorStruct.weiReceived);
534                 //Reduce totalWeiReceived
535                 totalWeiReceived = totalWeiReceived.Sub(investorStruct.weiReceived);
536                 //Update totalSupply
537                 totalSupply = totalSupply.Sub(investorStruct.tokensPurchased);
538                 // reduce balances
539                 balances[investorAddress] = balances[investorAddress].Sub(investorStruct.tokensPurchased);
540                 //set everything to zero after transfer successful
541                 investorStruct.weiReceived = 0;
542                 investorStruct.tokensPurchased = 0;
543                 investorStruct.refunded = true;
544             }
545         }
546         //Update the number of investors that have recieved refund
547         countInvestorsRefunded = batchSize;
548         if(countInvestorsRefunded == countTotalInvestors){
549             refundStatus = 4;
550         }
551         StateChanged(true);
552     }
553     
554     function extendSale(uint56 numberOfDays) public onlyOwner{
555         saleRunning = true;
556         endTime = now.Add(numberOfDays*86400);
557         StateChanged(true);
558     }
559 
560     /**
561     * @dev This will receive ether from owner so that the contract has balance while refunding
562     *
563     */
564     function prepareForRefund() public payable {}
565 
566     function () public payable {
567         buyTokens(msg.sender);
568     }
569 
570     /**
571     * Failsafe drain
572     */
573     function drain() public onlyOwner {
574         owner.transfer(this.balance);
575     }
576 }