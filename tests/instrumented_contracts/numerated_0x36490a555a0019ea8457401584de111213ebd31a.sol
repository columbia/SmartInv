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
89     event Transfer(address indexed _from, address indexed _to, uint _value, bytes comment);
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
117     address ethCollector;
118     //to save total number of ethers received
119     uint256 totalWeiReceived;
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
156     //by default any new account will show false for registered mapping
157     mapping(address => bool) registered;
158 
159     address[] listOfAddresses;
160 
161     //events
162     event StateChanged(bool);
163 
164     function CTV() public{
165         totalSupply = 0;
166         startTime = 0;
167         endTime = 0;
168         saleRunning = false;
169         locked = true;
170         setEthCollector(0xAf3BBf663769De9eEb6C2b235262Cf704eD4EA4b);
171     }
172     //To handle ERC20 short address attack
173     modifier onlyPayloadSize(uint size) {
174         require(msg.data.length >= size + 4);
175         _;
176     }
177 
178     modifier onlyUnlocked() { 
179         require (!locked); 
180         _; 
181     }
182 
183     modifier validTimeframe(){
184         require(saleRunning && now >=startTime && now < endTime);
185         _;
186     }
187     
188     function setEthCollector(address _ethCollector) public onlyOwner{
189         require(_ethCollector != address(0));
190         ethCollector = _ethCollector;
191     }
192     
193     function startSale() public onlyOwner{
194         require(startTime == 0);
195         startTime = now;
196         endTime = startTime.Add(7 weeks);
197         saleRunning = true;
198     }
199 
200     //To enable transfer of tokens
201     function unlockTransfer() external onlyOwner{
202         locked = false;
203     }
204 
205     /**
206     * @dev Check if the address being passed belongs to a contract
207     *
208     * @param _address The address which you want to verify
209     * @return A bool specifying if the address is that of contract or not
210     */
211     function isContract(address _address) private view returns(bool _isContract){
212         assert(_address != address(0) );
213         uint length;
214         //inline assembly code to check the length of address
215         assembly{
216             length := extcodesize(_address)
217         }
218         if(length > 0){
219             return true;
220         }
221         else{
222             return false;
223         }
224     }
225 
226     /**
227     * @dev Check balance of given account address
228     *
229     * @param _owner The address account whose balance you want to know
230     * @return balance of the account
231     */
232     function balanceOf(address _owner) public view returns (uint256 _value){
233         return balances[_owner];
234     }
235 
236     /**
237     * @dev Transfer sender's token to a given address
238     *
239     * @param _to The address which you want to transfer to
240     * @param _value the amount of tokens to be transferred
241     * @return A bool if the transfer was a success or not
242     */
243     function transfer(address _to, uint _value) onlyUnlocked onlyPayloadSize(2 * 32) public returns(bool _success) {
244         require( _to != address(0) );
245         bytes memory _empty;
246         if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){
247             balances[msg.sender] = balances[msg.sender].Sub(_value);
248             balances[_to] = balances[_to].Add(_value);
249             if(isContract(_to)){
250                 ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
251                 receiver.tokenFallback(msg.sender, _value, _empty);
252             }
253             Transfer(msg.sender, _to, _value, _empty);
254             return true;
255         }
256         else{
257             return false;
258         }
259     }
260 
261     /**
262     * @dev Transfer tokens to an address given by sender. To make ERC223 compliant
263     *
264     * @param _to The address which you want to transfer to
265     * @param _value the amount of tokens to be transferred
266     * @param _data additional information of account from where to transfer from
267     * @return A bool if the transfer was a success or not
268     */
269     function transfer(address _to, uint _value, bytes _data) onlyUnlocked onlyPayloadSize(3 * 32) public returns(bool _success) {
270         if((balances[msg.sender] > _value) && _value > 0 && _to != address(0)){
271             balances[msg.sender] = balances[msg.sender].Sub(_value);
272             balances[_to] = balances[_to].Add(_value);
273             if(isContract(_to)){
274                 ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
275                 receiver.tokenFallback(msg.sender, _value, _data);
276             }
277             Transfer(msg.sender, _to, _value, _data);
278             return true;
279         }
280         else{
281             return false;
282         }
283     }
284 
285     /**
286     * @dev Transfer tokens from one address to another, for ERC20.
287     *
288     * @param _from The address which you want to send tokens from
289     * @param _to The address which you want to transfer to
290     * @param _value the amount of tokens to be transferred
291     * @return A bool if the transfer was a success or not 
292     */
293     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3*32) public onlyUnlocked returns (bool){
294         bytes memory _empty;
295         if((_value > 0)
296            && (_to != address(0))
297        && (_from != address(0))
298        && (allowed[_from][msg.sender] > _value )){
299            balances[_from] = balances[_from].Sub(_value);
300            balances[_to] = balances[_to].Add(_value);
301            allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);
302            if(isContract(_to)){
303                ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
304                receiver.tokenFallback(msg.sender, _value, _empty);
305            }
306            Transfer(_from, _to, _value, _empty);
307            return true;
308        }
309        else{
310            return false;
311        }
312     }
313 
314     /**
315     * @dev Function to check the amount of tokens that an owner has allowed a spender to recieve from owner.
316     *
317     * @param _owner address The address which owns the funds.
318     * @param _spender address The address which will spend the funds.
319     * @return A uint256 specifying the amount of tokens still available for the spender to spend.
320     */
321     function allowance(address _owner, address _spender) public view returns (uint256){
322         return allowed[_owner][_spender];
323     }
324 
325     /**
326     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
327     *
328     * @param _spender The address which will spend the funds.
329     * @param _value The amount of tokens to be spent.
330     */
331     function approve(address _spender, uint256 _value) public returns (bool){
332         if( (_value > 0) && (_spender != address(0)) && (balances[msg.sender] >= _value)){
333             allowed[msg.sender][_spender] = _value;
334             Approval(msg.sender, _spender, _value);
335             return true;
336         }
337         else{
338             return false;
339         }
340     }
341 
342     /**
343     * @dev Calculate number of tokens that will be received in one ether
344     * 
345     */
346     function getPrice() public view returns(uint256) {
347         uint256 price;
348         if(totalSupply <= 1e6*1e18)
349             price = 13330;
350         else if(totalSupply <= 5e6*1e18)
351             price = 12500;
352         else if(totalSupply <= 9e6*1e18)
353             price = 11760;
354         else if(totalSupply <= 13e6*1e18)
355             price = 11110;
356         else if(totalSupply <= 17e6*1e18)
357             price = 10520;
358         else if(totalSupply <= 21e6*1e18)
359             price = 10000;
360         else{
361             //zero indicates that no tokens will be allocated when total supply
362             //of 21 million tokens is reached
363             price = 0;
364         }
365         return price;
366     }
367     
368     function mintAndTransfer(address beneficiary, uint256 numberOfTokensWithoutDecimal, bytes comment) public onlyOwner {
369         uint256 tokensToBeTransferred = numberOfTokensWithoutDecimal*1e18;
370         require(totalSupply.Add(tokensToBeTransferred) <= MAXCAP);
371         totalSupply = totalSupply.Add(tokensToBeTransferred);
372         balances[beneficiary] = balances[beneficiary].Add(tokensToBeTransferred);
373         Transfer(owner, beneficiary ,tokensToBeTransferred, comment);
374     }
375 
376     /**
377     * @dev to enable pause sale for break in ICO and Pre-ICO
378     *
379     */
380     function pauseSale() public onlyOwner{
381         assert(saleRunning && startTime > 0 && now <= endTime);
382         saleRunning = false;
383     }
384 
385     /**
386     * @dev to resume paused sale
387     *
388     */
389     function resumeSale() public onlyOwner{
390         assert(!saleRunning && startTime > 0 && now <= endTime);
391         saleRunning = true;
392     }
393 
394     function buyTokens(address beneficiary) internal validTimeframe {
395         uint256 tokensBought = msg.value.Mul(getPrice());
396         balances[beneficiary] = balances[beneficiary].Add(tokensBought);
397         totalSupply = totalSupply.Add(tokensBought);
398 
399         //Make entry in Investor indexed with address
400         Investor storage investorStruct = investors[beneficiary];
401         //If it is a new investor, then create a new id
402         if(investorStruct.investorID == 0){
403             countTotalInvestors++;
404             investorStruct.investorID = countTotalInvestors;
405             investorList[countTotalInvestors] = beneficiary;
406         }
407         else{
408             investorStruct.weiReceived = investorStruct.weiReceived.Add(msg.value);
409             investorStruct.tokensPurchased = investorStruct.tokensPurchased.Add(tokensBought);
410         }
411         
412         //Award referral tokens
413         if(referredBy[msg.sender] != address(0)){
414             //give some referral tokens
415             balances[referredBy[msg.sender]] = balances[referredBy[msg.sender]].Add(tokensBought/10);
416             tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/10);
417             totalSupply = totalSupply.Add(tokensBought/10);
418         }
419         //if referrer was also referred by someone
420         if(referredBy[referredBy[msg.sender]] != address(0)){
421             //give 1% tokens to 2nd generation referrer
422             balances[referredBy[referredBy[msg.sender]]] = balances[referredBy[referredBy[msg.sender]]].Add(tokensBought/100);
423             if(tokensSuppliedFromReferral.Add(tokensBought/100) < MAX_REFERRAL_TOKENS)
424                 tokensSuppliedFromReferral = tokensSuppliedFromReferral.Add(tokensBought/100);
425             totalSupply = totalSupply.Add(tokensBought/100);
426         }
427         
428         assert(totalSupply <= MAXCAP);
429         totalWeiReceived = totalWeiReceived.Add(msg.value);
430         ethCollector.transfer(msg.value);
431     }
432 
433     /**
434      * @dev This function is used to register a referral.
435      * Whoever calls this function, is telling contract,
436      * that "I was referred by referredByAddress"
437      * Whenever I am going to buy tokens, 10% will be awarded to referredByAddress
438      * 
439      * @param referredByAddress The address of person who referred the person calling this function
440      */
441     function registerReferral (address referredByAddress) public {
442         require(msg.sender != referredByAddress && referredByAddress != address(0));
443         referredBy[msg.sender] = referredByAddress;
444     }
445     
446     /**
447      * @dev Owner is allowed to manually register who was referred by whom
448      * @param heWasReferred The address of person who was referred
449      * @param I_referred_this_person The person who referred the above address
450      */
451     function referralRegistration(address heWasReferred, address I_referred_this_person) public onlyOwner {
452         require(heWasReferred != address(0) && I_referred_this_person != address(0));
453         referredBy[heWasReferred] = I_referred_this_person;
454     }
455 
456     /**
457     * Finalize the crowdsale
458     */
459     function finalize() public onlyOwner {
460         //Make sure Sale is running
461         assert(saleRunning);
462         if(MAXCAP.Sub(totalSupply) <= 1 ether || now > endTime){
463             //now sale can be finished
464             saleRunning = false;
465         }
466 
467         //Refund eligible or not
468         // 0: sale not started yet, refunding invalid
469         // 1: refund not required
470         // 2: softcap not reached, refund required
471         // 3: Refund in progress
472         // 4: Everyone refunded
473 
474         //Checks if the fundraising goal is reached in crowdsale or not
475         if (totalWeiReceived < SOFTCAP)
476             refundStatus = 2;
477         else
478             refundStatus = 1;
479 
480         //crowdsale is ended
481         saleRunning = false;
482         //enable transferring of tokens among token holders
483         locked = false;
484         //Emit event when crowdsale state changes
485         StateChanged(true);
486     }
487 
488     /**
489     * Refund the investors in case target of crowdsale not achieved
490     */
491     function refund() public onlyOwner {
492         assert(refundStatus == 2 || refundStatus == 3);
493         uint batchSize = countInvestorsRefunded.Add(30) < countTotalInvestors ? countInvestorsRefunded.Add(30): countTotalInvestors;
494         for(uint i=countInvestorsRefunded.Add(1); i <= batchSize; i++){
495             address investorAddress = investorList[i];
496             Investor storage investorStruct = investors[investorAddress];
497             //If purchase has been made during CrowdSale
498             if(investorStruct.tokensPurchased > 0 && investorStruct.tokensPurchased <= balances[investorAddress]){
499                 //return everything
500                 investorAddress.transfer(investorStruct.weiReceived);
501                 //Reduce totalWeiReceived
502                 totalWeiReceived = totalWeiReceived.Sub(investorStruct.weiReceived);
503                 //Update totalSupply
504                 totalSupply = totalSupply.Sub(investorStruct.tokensPurchased);
505                 // reduce balances
506                 balances[investorAddress] = balances[investorAddress].Sub(investorStruct.tokensPurchased);
507                 //set everything to zero after transfer successful
508                 investorStruct.weiReceived = 0;
509                 investorStruct.tokensPurchased = 0;
510                 investorStruct.refunded = true;
511             }
512         }
513         //Update the number of investors that have recieved refund
514         countInvestorsRefunded = batchSize;
515         if(countInvestorsRefunded == countTotalInvestors){
516             refundStatus = 4;
517         }
518         StateChanged(true);
519     }
520     
521     function extendSale(uint56 numberOfDays) public onlyOwner{
522         saleRunning = true;
523         endTime = now.Add(numberOfDays*86400);
524         StateChanged(true);
525     }
526 
527     /**
528     * @dev This will receive ether from owner so that the contract has balance while refunding
529     *
530     */
531     function prepareForRefund() public payable {}
532 
533     function () public payable {
534         buyTokens(msg.sender);
535     }
536 
537     /**
538     * Failsafe drain
539     */
540     function drain() public onlyOwner {
541         owner.transfer(this.balance);
542     }
543 }