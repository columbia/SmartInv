1 /**
2  *  Crowdfunding.sol v1.0.0
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Notary Platform
6  */
7 
8 pragma solidity ^0.4.16;
9 
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16     
17     function div(uint256 a, uint256 b) internal constant returns (uint256) {
18         uint256 c = a / b;
19         return c;
20     }
21     
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 contract Ownable {
34      /*
35       @title Ownable
36       @dev The Ownable contract has an owner address, and provides basic authorization control
37       functions, this simplifies the implementation of "user permissions".
38     */
39 
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable(address _owner){
49     owner = _owner;
50   }
51 
52   /**
53    * @dev Allows the current owner to transfer control of the contract to a newOwner.
54    * @param newOwner The address to transfer ownership to.
55    */
56   function transferOwnership(address newOwner) onlyOwner public {
57     require(newOwner != address(0));
58     OwnershipTransferred(owner, newOwner);
59     owner = newOwner;
60   }
61   
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 }
71 contract ReentrancyGuard {
72 
73   /**
74    * @dev We use a single lock for the whole contract.
75    */
76   bool private rentrancy_lock = false;
77 
78   /**
79    * @dev Prevents a contract from calling itself, directly or indirectly.
80    * @notice If you mark a function `nonReentrant`, you should also
81    * mark it `external`. Calling one nonReentrant function from
82    * another is not supported. Instead, you can implement a
83    * `private` function doing the actual work, and a `external`
84    * wrapper marked as `nonReentrant`.
85    */
86   modifier nonReentrant() {
87     require(!rentrancy_lock);
88     rentrancy_lock = true;
89     _;
90     rentrancy_lock = false;
91   }
92 
93 }
94 contract Pausable is Ownable {
95   
96   event Pause(bool indexed state);
97 
98   bool private paused = false;
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev return the current state of contract
118    */
119   function Paused() external constant returns(bool){ return paused; }
120 
121   /**
122    * @dev called by the owner to pause or unpause, triggers stopped state
123    * on first call and returns to normal state on second call
124    */
125   function tweakState() external onlyOwner {
126     paused = !paused;
127     Pause(paused);
128   }
129 
130 }
131 
132 contract Crowdfunding is Pausable, ReentrancyGuard {
133 
134       using SafeMath for uint256;
135     
136       /* the starting time of the crowdsale */
137       uint256 private startsAt;
138     
139       /* the ending time of the crowdsale */
140       uint256 private endsAt;
141     
142       /* how many token units a buyer gets per wei */
143       uint256 private rate;
144     
145       /* How many wei of funding we have received so far */
146       uint256 private weiRaised = 0;
147     
148       /* How many distinct addresses have invested */
149       uint256 private investorCount = 0;
150       
151       /* How many total investments have been made */
152       uint256 private totalInvestments = 0;
153       
154       /* Address of multiSig contract*/
155       address private multiSig;
156       
157       /* Address of tokenStore*/
158       address private tokenStore;
159       
160       /* Address of pre-ico contract*/
161       NotaryPlatformToken private token;
162      
163     
164       /** How much ETH each address has invested to this crowdsale */
165       mapping (address => uint256) private investedAmountOf;
166     
167       /** Whitelisted addresses */
168       mapping (address => bool) private whiteListed;
169       
170       /** State machine
171        *
172        * - Prefunding: We have not passed start time yet
173        * - Funding: Active crowdsale
174        * - Closed: Funding is closed.
175        */
176       enum State{PreFunding, Funding, Closed}
177     
178       /**
179        * event for token purchase logging
180        * @param purchaser who paid for the tokens
181        * @param beneficiary who got the tokens
182        * @param value weis paid for purchase
183        * @param amount amount of tokens purchased
184        */
185       event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
186       // Funds transfer to other address
187       event Transfer(address indexed receiver, uint256 weiAmount);
188     
189       // Crowdsale end time has been changed
190       event EndsAtChanged(uint256 endTimestamp);
191     
192       event NewExchangeRate(uint256 indexed _rate);
193       event TokenContractAddress(address indexed oldAddress,address indexed newAddress);
194       event TokenStoreUpdated(address indexed oldAddress,address indexed newAddress);
195       event WalletAddressUpdated(address indexed oldAddress,address indexed newAddress);
196       event WhiteListUpdated(address indexed investor, bool status);
197       event BonusesUpdated(address indexed investor, bool status);
198 
199       function Crowdfunding() 
200       Ownable(0x0587e235a5906ed8143d026dE530D77AD82F8A92)
201       {
202         require(earlyBirds());       // load bonuses
203         
204         multiSig = 0x1D1739F37a103f0D7a5f5736fEd2E77DE9863450;
205         tokenStore = 0x244092a2FECFC48259cf810b63BA3B3c0B811DCe;
206         
207         token = NotaryPlatformToken(0xbA5787e07a0636A756f4B4d517b595dbA24239EF);
208         require(token.isTokenContract());
209     
210         startsAt = now + 2 minutes;
211         endsAt = now + 31 minutes;
212         rate = 2730;
213       }
214     
215       /**
216        * Allow investor to just send in money
217        */
218       function() nonZero payable{
219         buy(msg.sender);
220       }
221     
222       /**
223        * Make an investment.
224        *
225        * Crowdsale must be running for one to invest.
226        * We must have not pressed the emergency brake.
227        *
228        * @param receiver The Ethereum address who will receive tokens
229        *
230        */
231       function buy(address receiver) public whenNotPaused nonReentrant inState(State.Funding) nonZero payable returns(bool){
232         require(receiver != 0x00);
233         require(whiteListed[receiver] || isEarlyBird(receiver));
234 
235         if(investedAmountOf[msg.sender] == 0) {
236           // A new investor
237           investorCount++;
238         }
239     
240         // count all investments
241         totalInvestments++;
242     
243         // Update investor
244         investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);
245         
246         // Up total accumulated fudns
247         weiRaised = weiRaised.add(msg.value);
248         
249         uint256 value = getBonus(receiver,msg.value);
250         
251         // calculate token amount to be transfered
252         uint256 tokens = value.mul(rate);
253         
254         // Transfer NTRY tokens to receiver address
255         if(!token.transferFrom(tokenStore,receiver,tokens)){
256             revert();
257         }
258         
259         // Tell us purchase was success
260         TokenPurchase(msg.sender, receiver, msg.value, tokens);
261         
262         // Pocket the money
263         forwardFunds();
264         
265         return true;
266       }
267       
268       
269       // send ether to the fund collection wallet
270       function forwardFunds() internal {
271         multiSig.transfer(msg.value);
272       }
273     
274     
275      // getters, constant functions
276     
277       /**
278        * @return address of multisignature wallet 
279        */
280       function multiSigAddress() external constant returns(address){
281           return multiSig;
282       }
283       
284       /**
285        * @return address of Notary Platform token
286        */
287       function tokenContractAddress() external constant returns(address){
288           return token;
289       }
290       
291       /**
292        * @return address of NTRY tokens owner
293        */
294       function tokenStoreAddress() external constant returns(address){
295           return tokenStore;
296       }
297       
298       /**
299        * @return startDate Crowdsale opening date
300        */
301       function fundingStartAt() external constant returns(uint256 ){
302           return startsAt;
303       }
304       
305       /**
306        * @return endDate Crowdsale closing date
307        */
308       function fundingEndsAt() external constant returns(uint256){
309           return endsAt;
310       }
311       
312       /**
313        * @return investors Total of distinct investors
314        */
315       function distinctInvestors() external constant returns(uint256){
316           return investorCount;
317       }
318       
319       /**
320        * @return investments Crowdsale closing date
321        */
322       function investments() external constant returns(uint256){
323           return totalInvestments;
324       }
325       
326       /**
327        * @param _addr Address of investor
328        * @return Number of ethers invested by investor 
329        */
330       function investedAmoun(address _addr) external constant returns(uint256){
331           require(_addr != 0x00);
332           return investedAmountOf[_addr];
333       }
334       
335        /**
336        * @return total of amount of wie collected by the contract 
337        */
338       function fundingRaised() external constant returns (uint256){
339         return weiRaised;
340       }
341 
342       /**
343        * @return exchage rate of ethers to NTRY tokens 
344        */
345       function exchnageRate() external constant returns (uint256){
346         return rate;
347       }
348 
349       /**
350        * @return the status of the contract if it is allowed to participate. 
351        */
352       function isWhiteListed(address _address) external constant returns(bool){
353         require(_address != 0x00);
354         return whiteListed[_address];
355       }
356       
357       /**
358        * Crowdfund state machine management.
359        *
360        * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
361        */
362       function getState() public constant returns (State) {
363         if (now < startsAt) return State.PreFunding;
364         else if (now <= endsAt) return State.Funding;
365         else if (now > endsAt) return State.Closed;
366       }
367       
368       // Setters, onlyOwner functions
369       
370        /**
371        * @param _newAddress is address of multisignature wallet
372        * @return true for case of success
373        */
374       function updateMultiSig(address _newAddress) external onlyOwner returns(bool){
375           require(_newAddress != 0x00);
376           WalletAddressUpdated(multiSig,_newAddress);
377           multiSig = _newAddress;
378           return true;
379       }
380       
381        /**
382        * @param _newAddress is address of NTRY token contract
383        * @return true for case of success
384        */
385       function updateTokenContractAddr(address _newAddress) external onlyOwner returns(bool){
386           require(_newAddress != 0x00);
387           TokenContractAddress(token,_newAddress);
388           token = NotaryPlatformToken(_newAddress);
389           return true;
390       }
391       
392        /**
393        * @param _newAddress is address of NTRY tokens owner
394        * @return true for case of success
395        */
396       function updateTokenStore(address _newAddress) external onlyOwner returns(bool){
397           require(_newAddress != 0x00);
398           TokenStoreUpdated(tokenStore,_newAddress);
399           tokenStore = _newAddress;
400           return true;
401       }
402       
403       /**
404        * Allow crowdsale owner to close early or extend the crowdsale.
405        *
406        * This is useful e.g. for a manual soft cap implementation:
407        * - after X amount is reached determine manual closing
408        *
409        * This may put the crowdsale to an invalid state,
410        * but we trust owners know what they are doing.
411        *
412        */
413       function updateEndsAt(uint256 _endsAt) external  onlyOwner {
414         
415         // Don't change past
416         require(_endsAt > now);
417     
418         endsAt = _endsAt;
419         EndsAtChanged(_endsAt);
420       }
421 
422       /**
423        * Allow crowdsale owner to change exchange rate.
424        */
425       function updateExchangeRate(uint256 _newRate) external onlyOwner {
426         
427         // Don't change past
428         require(_newRate > 0);
429     
430         rate = _newRate;
431         NewExchangeRate(_newRate);
432       }
433 
434       function updateWhiteList(address _address,bool _status) external onlyOwner returns(bool){
435         require(_address != 0x00);
436         whiteListed[_address] = _status;
437         WhiteListUpdated(_address, _status);
438         return true;
439       }
440     
441     
442       /** Interface marker. */
443       function isCrowdsale() external constant returns (bool) {
444         return true;
445       }
446     
447       //
448       // Modifiers
449       //
450       /** Modifier allowing execution only if the crowdsale is currently running.  */
451       modifier inState(State state) {
452         require(getState() == state);
453         _;
454       }
455     
456       /** Modifier allowing execution only if received value is greater than zero */
457       modifier nonZero(){
458         require(msg.value >= 75000000000000000);
459         _;
460       }
461 
462 
463       //////////////////////////////////// Bonuses ////////////////////////////////
464 
465       mapping (address => bool) private bonuses;
466 
467       function earlyBirds() private returns(bool){
468         bonuses[0x017ABCC1012A7FfA811bBe4a26804f9DDac1Af4D] = true;
469         bonuses[0x1156ABCBA63ACC64162b0bbf67726a3E5eA1E157] = true;
470         bonuses[0xEAC8483261078517528DE64956dBD405f631265c] = true;
471         bonuses[0xB0b0D639b612937D50dd26eA6dc668e7AE51642A] = true;
472         bonuses[0x417535DEF791d7BBFBC97b0f743a4Da67fD9eC3B] = true;
473         bonuses[0x6723f81CDc9a5D5ef2Fe1bFbEdb4f83Bd017D3dC] = true;
474         bonuses[0xb9Bd4f154Bb5F2BE5E7Db0357C54720c7f35405d] = true;
475         bonuses[0x21CA5617f0cd02f13075C7c22f7231D061F09189] = true;
476         bonuses[0x0a6Cd7e558c69baF7388bb0B3432E29Ecc29ac55] = true;
477         bonuses[0x6a7f63709422A986A953904c64F10D945c8AfBA1] = true;
478         bonuses[0x7E046CB5cE19De94b2D0966B04bD8EF90cDC35d3] = true;
479         bonuses[0x1C3118b84988f42007c548e62DFF47A12c955886] = true;
480         bonuses[0x7736154662ba56C57B2Be628Fe0e44A609d33Dfb] = true;
481         bonuses[0xCcC8d4410a825F3644D3a5BBC0E9dF4ac6B491B3] = true;
482         bonuses[0x9Eff6628545E1475C73dF7B72978C2dF90eDFeeD] = true;
483         bonuses[0x235377dFB1Da49e39692Ac2635ef091c1b1cF63A] = true;
484         bonuses[0x6a8d793026BeBaef1a57e3802DD4bB6B1C844755] = true;
485         bonuses[0x26c32811447c8D0878b2daE7F4538AE32de82d57] = true;
486         bonuses[0x9CEdb0e60B3C2C1cd9A2ee2E18FD3f68870AF230] = true;
487         bonuses[0x28E102d747dF8Ae2cBBD0266911eFB609986515d] = true;
488         bonuses[0x5b35061Cc9891c3616Ea05d1423e4CbCfdDF1829] = true;
489         bonuses[0x47f2404fa0da21Af5b49F8E011DF851B69C24Aa4] = true;
490         bonuses[0x046ec2a3a16e76d5dFb0CFD0BF75C7CA6EB8A4A2] = true;
491         bonuses[0x01eD3975993c8BebfF2fb6a7472679C6F7b408Fb] = true;
492         bonuses[0x011afc4522663a310AF1b72C5853258CCb2C8f80] = true;
493         bonuses[0x3A167819Fd49F3021b91D840a03f4205413e316B] = true;
494         bonuses[0xd895E6E5E0a13EC2A16e7bdDD6C1151B01128488] = true;
495         bonuses[0xE5d4AaFC54CF15051BBE0bA11f65dE4f4Ccedbc0] = true;
496         bonuses[0x21C4ff1738940B3A4216D686f2e63C8dbcb7DC44] = true;
497         bonuses[0x196a484dB36D2F2049559551c182209143Db4606] = true;
498         bonuses[0x001E0d294383d5b4136476648aCc8D04a6461Ae3] = true;
499         bonuses[0x2052004ee9C9a923393a0062748223C1c76a7b59] = true;
500         bonuses[0x80844Fb6785c1EaB7671584E73b0a2363599CB2F] = true;
501         bonuses[0x526127775D489Af1d7e24bF4e7A8161088Fb90ff] = true;
502         bonuses[0xD4340FeF5D32F2754A67bF42a44f4CEc14540606] = true;
503         bonuses[0x51A51933721E4ADA68F8C0C36Ca6E37914A8c609] = true;
504         bonuses[0xD0780AB2AA7309E139A1513c49fB2127DdC30D3d] = true;
505         bonuses[0xE4AFF5ECB1c686F56C16f7dbd5d6a8Da9E200ab7] = true;
506         bonuses[0x04bC746A174F53A3e1b5776d5A28f3421A8aE4d0] = true;
507         bonuses[0x0D5f69C67DAE06ce606246A8bd88B552d1DdE140] = true;
508         bonuses[0x8854f86F4fBd88C4F16c4F3d5A5500de6d082AdC] = true;
509         bonuses[0x73c8711F2653749DdEFd7d14Ab84b0c4419B91A5] = true;
510         bonuses[0xb8B0eb45463d0CBc85423120bCf57B3283D68D42] = true;
511         bonuses[0x7924c67c07376cf7C4473D27BeE92FE82DFD26c5] = true;
512         bonuses[0xa6A14A81eC752e0ed5391A22818F44aA240FFBB1] = true;
513         bonuses[0xdF88295a162671EFC14f3276A467d31a5AFb63AC] = true;
514         bonuses[0xC1c113c60ebf7d92A3D78ff7122435A1e307cE05] = true;
515         bonuses[0x1EAaD141CaBA0C85EB28E0172a30dd8561dde030] = true;
516         bonuses[0xDE3270049C833fF2A52F18C7718227eb36a92323] = true;
517         bonuses[0x2348f7A9313B33Db329182f4FA78Bc0f94d2F040] = true;
518         bonuses[0x07c9CC6C24aBDdaB4a7aD82c813b059DD04a7F07] = true;
519         bonuses[0xd45BF2dEBD1C4196158DcB177D1Ae910949DC00A] = true;
520         bonuses[0xD1F3A1A16F4ab35e5e795Ce3f49Ee2DfF2dD683B] = true;
521         bonuses[0x6D567fa2031D42905c40a7E9CFF6c30b8DA4abf6] = true;
522         bonuses[0x4aF3b3947D4b4323C241c99eB7FD3ddcAbaef0d7] = true;
523         bonuses[0x386167E3c00AAfd9f83a89c05E0fB7e1c2720095] = true;
524         bonuses[0x916F356Ccf821be928201505c59a44891168DC08] = true;
525         bonuses[0x47cb69881e03213D1EC6e80FCD375bD167336621] = true;
526         bonuses[0x36cFB5A6be6b130CfcEb934d3Ca72c1D72c3A7D8] = true;
527         bonuses[0x1b29291cF6a57EE008b45f529210d6D5c5f19D91] = true;
528         bonuses[0xe6D0Bb9FBb78F10a111bc345058a9a90265622F3] = true;
529         bonuses[0x3e83Fc87256142dD2FDEeDc49980f4F9Be9BB1FB] = true;
530         bonuses[0xf360b24a530d29C96a26C2E34C0DAbCAB12639F4] = true;
531         bonuses[0xF49C6e7e36A714Bbc162E31cA23a04E44DcaF567] = true;
532         bonuses[0xa2Ac3516A33e990C8A3ce7845749BaB7C63128C0] = true;
533         bonuses[0xdC5984a2673c46B68036076026810FfDfFB695B8] = true;
534         bonuses[0xfFfdFaeF43029d6C749CEFf04f65187Bd50A5311] = true;
535         bonuses[0xe752737DD519715ab0FA9538949D7F9249c7c168] = true;
536         bonuses[0x580d0572DBD9F27C75d5FcC88a6075cE32924C2B] = true;
537         bonuses[0x6ee541808C463116A82D76649dA0502935fA8D08] = true;
538         bonuses[0xA68B4208E0b7aACef5e7cF8d6691d5B973bAd119] = true;
539         bonuses[0x737069E6f9F02062F4D651C5C8C03D50F6Fc99C6] = true;
540         bonuses[0x00550191FAc279632f5Ff23d06Cb317139543840] = true;
541         bonuses[0x9e6EB194E26649B1F17e5BafBcAbE26B5db433E2] = true;
542         bonuses[0x186a813b9fB34d727fE1ED2DFd40D87d1c8431a6] = true;
543         bonuses[0x7De8D937a3b2b254199F5D3B38F14c0D0f009Ff8] = true;
544         bonuses[0x8f066F3D9f75789d9f126Fdd7cFBcC38a768985D] = true;
545         bonuses[0x7D1826Fa8C84608a6C2d5a61Ed5A433D020AA543] = true;
546         return true;
547       }
548 
549       function updateBonuses(address _address,bool _status) external onlyOwner returns(bool){
550         require(_address != 0x00);
551         bonuses[_address] = _status;
552         BonusesUpdated(_address,_status);
553         return true;
554       }
555 
556       function getBonus(address _address,uint256 _value) private returns(uint256){
557         if(bonuses[_address]){
558            // 10% bonus
559            if(_value > 166 ether){
560             return (_value*11)/10;
561            }
562            // 7.5% bonus
563            if(_value > 33 ether){
564             return (_value*43)/40;
565            }
566            return (_value*21)/20;
567         }
568         return _value;
569       }
570 
571       function isEarlyBird(address _address) constant returns(bool){
572         require(_address != 0x00);
573         return bonuses[_address];
574       }
575 }
576 
577 contract NotaryPlatformToken{
578     function isTokenContract() returns (bool);
579     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
580 }