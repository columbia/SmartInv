1 pragma solidity 0.4.25;
2 
3 
4 
5 interface ERC20 {
6     event Transfer(address indexed from, address indexed to, uint256 value);  
7     event Approval(address indexed owner, address indexed spender, uint256 value);
8     function balanceOf(address who) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function transfer(address to, uint256 value) external returns (bool ok);
11     function transferFrom(address from, address to, uint256 value) external returns (bool ok);
12     function approve(address spender, uint256 value) external returns (bool ok);  
13     function totalSupply() external view returns(uint256);
14 }
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 contract Ownable {    
75     address public owner;
76     address public tempOwner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79     event OwnershipTransferRequest(address indexed previousOwner, address indexed newOwner);
80     
81     // Constructor which will assing the admin to the contract deployer.
82     constructor() public {
83         owner = msg.sender;
84     }
85 
86     // Modifier which will make sure only admin can call a particuler function.
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     // This method is used to transfer ownership to a new admin. This is the first of the two stesps.
93     function transferOwnership(address newOwner) onlyOwner public {
94         require(newOwner != address(0));
95         emit OwnershipTransferRequest(owner, newOwner);
96         tempOwner = newOwner;
97     }
98   
99     // This is the second of two steps of ownership transfer, new admin has to call to confirm transfer.
100     function acceptOwnership() public {  
101         require(tempOwner==msg.sender);
102         emit OwnershipTransferred(owner,msg.sender);
103         owner = msg.sender;
104     }
105 }
106 
107 
108 
109 /*
110 * The HITT token contract, it is a standard ERC20 contract with a small updates to accomodate 
111 * our conditions of adding, validating the stakes.
112 * 
113 * Author : Vikas
114 * Auditor : Darryl Morris
115 */
116 contract HITT is ERC20,Ownable {    
117     using SafeMath for uint256;
118     string public constant name = "Health Information Transfer Token";
119     string public constant symbol = "HITT";
120     uint8 public constant decimals = 18;
121     uint256 private constant totalSupply1 = 1000000000 * 10 ** uint256(decimals);
122     address[] public founders = [
123         0x89Aa30ca3572eB725e5CCdcf39d44BAeD5179560, 
124         0x1c61461794df20b0Ed8C8D6424Fd7B312722181f];
125     address[] public advisors = [
126         0xc83eDeC2a4b6A992d8fcC92484A82bC312E885B5, 
127         0x9346e8A0C76825Cd95BC3679ab83882Fd66448Ab, 
128         0x3AA2958c7799faAEEbE446EE5a5D90057fB5552d, 
129         0xF90f4D2B389D499669f62F3a6F5E0701DFC202aF, 
130         0x45fF9053b44914Eedc90432c3B6674acDD400Cf1, 
131         0x663070ab83fEA900CB7DCE7c92fb44bA9E0748DE];
132     mapping (address => uint256)  balances;
133     mapping (address => mapping (address => uint256))  allowed;
134     mapping (address => uint64) lockTimes;
135     
136     /*
137     * 31104000 = 360 Days in seconds. We're not using whole 365 days for `tokenLockTime` 
138     * because we have used multiple of 90 for 3M, 6M, 9M and 12M in the Hodler Smart contract's time calculation as well.
139     * We shall use it to lock the tokens of Advisors and Founders. 
140     */
141     uint64 public constant tokenLockTime = 31104000;
142     
143     /*
144     * Need to update the actual value during deployement. update needed.
145     * This is HODL pool. It shall be distributed for the whole year as a 
146     * HODL bonus among the people who shall not move their ICO tokens for 
147     * 3,6,9 and 12 months respectively. 
148     */
149     uint256 public constant hodlerPoolTokens = 15000000 * 10 ** uint256(decimals) ; 
150     Hodler public hodlerContract;
151 
152     /*
153     * The constructor method which will initialize the token supply.
154     * We've multiple `Transfer` events emitting from the Constructor so that Etherscan can pick 
155     * it as the contributor's address and can show correct informtaion on the site.
156     * We're deliberately choosing the manual transfer of the tokens to the advisors and the founders over the 
157     * internal `_transfer()` because the admin might use the same account for deploying this Contract and as an founder address.
158     * which will have `locktime`.
159     */
160     constructor() public {
161         uint8 i=0 ;
162         balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6] = totalSupply1;
163         emit Transfer(0x0,0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6,totalSupply1);
164         uint256 length = founders.length ;
165         for( ; i < length ; i++ ){
166             /*
167             * These 45 days shall be used to distribute the tokens to the contributors of the ICO.
168             */
169             lockTimes[founders[i]] = uint64(block.timestamp + 365 days + tokenLockTime );
170         }
171         length = advisors.length ;
172         for( i=0 ; i < length ; i++ ){
173             lockTimes[advisors[i]] = uint64(block.timestamp +  365 days + tokenLockTime); 
174             balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6] = balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6].sub(40000 * 10 ** uint256(decimals));
175             balances[advisors[i]] = 40000 * 10 ** uint256(decimals) ;
176             emit Transfer( 0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6, advisors[i], 40000 * 10 ** uint256(decimals) );
177         }
178         balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6] = balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6].sub(130000000 * 10 ** uint256(decimals));
179         balances[founders[0]] = 100000000 * 10 ** uint256(decimals) ;
180         balances[founders[1]] =  30000000 * 10 ** uint256(decimals) ; 
181         emit Transfer( 0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6, founders[0], 100000000 * 10 ** uint256(decimals) );
182         emit Transfer( 0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6, founders[1],  30000000 * 10 ** uint256(decimals) );
183         hodlerContract = new Hodler(hodlerPoolTokens, msg.sender); 
184         balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6] = balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6].sub(hodlerPoolTokens);
185         balances[address(hodlerContract)] = hodlerPoolTokens; // giving the total hodler bonus to the HODLER contract to distribute.        
186         assert(totalSupply1 == balances[0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6].add(hodlerPoolTokens.add((130000000 * 10 ** uint256(decimals)).add(length.mul(40000 * 10 ** uint256(decimals))))));
187         emit Transfer( 0x60Bf75BB47cbD4cD1eeC7Cd48eab1F16Ebe822c6, address(hodlerContract), hodlerPoolTokens );
188     }
189     
190 
191     /*
192     * Constant function to return the total supply of the HITT contract
193     */
194     function totalSupply() public view returns(uint256) {
195         return totalSupply1;
196     }
197 
198     /* 
199     * Transfer amount from one account to another. The code takes care that it doesn't transfer the tokens to contracts. 
200     * This function trigger the action to invalidate the participant's right to get the
201     *  HODL rewards if they make any transaction within the hodl period.
202     * Getting into the HODL club is optional by not moving their tokens after receiving tokens in their wallet for 
203     * pre-defined period like 3,6,9 or 12 months.
204     * More details are here about the HODL T&C : https://medium.com/@Vikas1188/lets-hodl-with-emrify-bc5620a14237
205     */
206     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
207         require(!isContract(_to));
208         require(block.timestamp > lockTimes[_from]);
209         uint256 prevBalTo = balances[_to] ;
210         uint256 prevBalFrom = balances[_from];
211         balances[_from] = balances[_from].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         if(hodlerContract.isValid(_from)) {
214             require(hodlerContract.invalidate(_from));
215         }
216         emit Transfer(_from, _to, _value);
217         assert(_value == balances[_to].sub(prevBalTo));
218         assert(_value == prevBalFrom.sub(balances[_from]));
219         return true;
220     }
221 	
222     /*
223     * Standard token transfer method.
224     */
225     function transfer(address _to, uint256 _value) public returns (bool) {
226         return _transfer(msg.sender, _to, _value);
227     }
228 
229     /*
230     * This method will allow a 3rd person to spend tokens (requires `approval()` 
231     * to be called before with that 3rd person's address)
232     */
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234         require(_value <= allowed[_from][msg.sender]); 
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         return _transfer(_from, _to, _value);
237     }
238 
239     /*
240     * Approve `_spender` to move `_value` tokens from owner's account
241     */
242     function approve(address _spender, uint256 _value) public returns (bool) {
243         require(block.timestamp>lockTimes[msg.sender]);
244         allowed[msg.sender][_spender] = _value; 
245         emit Approval(msg.sender, _spender, _value);
246         return true;
247     }
248 
249     /*
250     * Returns balance
251     */
252     function balanceOf(address _owner) public view returns (uint256) {
253         return balances[_owner];
254     }
255 
256     /*
257     * Returns whether the `_spender` address is allowed to move the coins of the `_owner` 
258     */
259     function allowance(address _owner, address _spender) public view returns (uint256) {
260         return allowed[_owner][_spender];
261     }
262     
263     /*
264     * This method will be used by the admin to allocate tokens to multiple contributors in a single shot.
265     */
266     function saleDistributionMultiAddress(address[] _addresses,uint256[] _values) public onlyOwner returns (bool) {    
267         require( _addresses.length > 0 && _addresses.length == _values.length); 
268         uint256 length = _addresses.length ;
269         for(uint8 i=0 ; i < length ; i++ )
270         {
271             if(_addresses[i] != address(0) && _addresses[i] != owner) {
272                 require(hodlerContract.addHodlerStake(_addresses[i], _values[i]));
273                 _transfer( msg.sender, _addresses[i], _values[i]) ;
274             }
275         }
276         return true;
277     }
278      
279     /*
280     * This method will be used to send tokens to multiple addresses.
281     */
282     function batchTransfer(address[] _addresses,uint256[] _values) public  returns (bool) {    
283         require(_addresses.length > 0 && _addresses.length == _values.length);
284         uint256 length = _addresses.length ;
285         for( uint8 i = 0 ; i < length ; i++ ){
286             
287             if(_addresses[i] != address(0)) {
288                 _transfer(msg.sender, _addresses[i], _values[i]);
289             }
290         }
291         return true;
292     }   
293     
294     /*
295     * This method checks whether the address is a contract or not. 
296     */
297     function isContract(address _addr) private view returns (bool) {
298         uint32 size;
299         assembly {
300             size := extcodesize(_addr)
301         }
302         return (size > 0);
303     }
304     
305 }
306 
307 
308 contract Hodler is Ownable {
309     using SafeMath for uint256;
310     bool istransferringTokens = false;
311     address public admin; // getting updated in constructor
312     
313     /* 
314     * HODLER reward tracker
315     * stake amount per address
316     * Claim flags for 3,6,9 & 12 months respectiviely.
317     * It shall be really useful to get the details whether a particular address got his claims.
318     */
319     struct HODL {
320         uint256 stake;
321         bool claimed3M;
322         bool claimed6M;
323         bool claimed9M;
324         bool claimed12M;
325     }
326 
327     mapping (address => HODL) public hodlerStakes;
328 
329     /* 
330     * Total current staking value & count of hodler addresses.
331     * hodlerTotalValue = ∑ all the valid distributed tokens. 
332     * This shall be the reference in which we shall distribute the HODL bonus.
333     * hodlerTotalCount = count of the different addresses who is still HODLing their intial distributed tokens.
334     */
335     uint256 public hodlerTotalValue;
336     uint256 public hodlerTotalCount;
337 
338     /*
339     * To keep the snapshot of the tokens for 3,6,9 & 12 months after token sale.
340     * Since people shall invalidate their stakes during the HODL period, we shall keep 
341     * decreasing their share from the `hodlerTotalValue`. it shall always have the 
342     * user's ICO contribution who've not invalidated their stakes.
343     */
344     uint256 public hodlerTotalValue3M;
345     uint256 public hodlerTotalValue6M;
346     uint256 public hodlerTotalValue9M;
347     uint256 public hodlerTotalValue12M;
348 
349     /*
350     * This shall be set deterministically to 45 days in the constructor itself 
351     * from the deployment date of the Token Contract. 
352     */
353     uint256 public hodlerTimeStart;
354  
355     /*
356     * Reward HITT token amount for 3,6,9 & 12 months respectively, which shall be 
357     * calculated deterministically in the contructor
358     */
359     uint256 public TOKEN_HODL_3M;
360     uint256 public TOKEN_HODL_6M;
361     uint256 public TOKEN_HODL_9M;
362     uint256 public TOKEN_HODL_12M;
363 
364     /* 
365     * Total amount of tokens claimed so far while the HODL period
366     */
367     uint256 public claimedTokens;
368     
369     event LogHodlSetStake(address indexed _beneficiary, uint256 _value);
370     event LogHodlClaimed(address indexed _beneficiary, uint256 _value);
371 
372     ERC20 public tokenContract;
373     
374     /*
375     * Modifier: before hodl is started
376     */
377     modifier beforeHodlStart() {
378         require(block.timestamp < hodlerTimeStart);
379         _;
380     }
381 
382     /*
383     * Constructor: It shall set values deterministically
384     * It should be created by a token distribution contract
385     * Because we cannot multiply rational with integer, 
386     * we are using 75 instead of 7.5 and dividing with 1000 instaed of 100.
387     */
388     constructor(uint256 _stake, address _admin) public {
389         TOKEN_HODL_3M = (_stake*75)/1000;
390         TOKEN_HODL_6M = (_stake*15)/100;
391         TOKEN_HODL_9M = (_stake*30)/100;
392         TOKEN_HODL_12M = (_stake*475)/1000;
393         tokenContract = ERC20(msg.sender);
394         hodlerTimeStart = block.timestamp.add(365 days) ; // These 45 days shall be used to distribute the tokens to the contributors of the ICO
395         admin = _admin;
396     }
397     
398     /*
399     * This method will only be called by the `saleDistributionMultiAddress()` 
400     * from the Token Contract. 
401     */
402     function addHodlerStake(address _beneficiary, uint256 _stake) public onlyOwner beforeHodlStart returns (bool) {
403         // real change and valid _beneficiary is needed
404         if (_stake == 0 || _beneficiary == address(0))
405             return false;
406         
407         // add stake and maintain count
408         if (hodlerStakes[_beneficiary].stake == 0)
409             hodlerTotalCount = hodlerTotalCount.add(1);
410         hodlerStakes[_beneficiary].stake = hodlerStakes[_beneficiary].stake.add(_stake);
411         hodlerTotalValue = hodlerTotalValue.add(_stake);
412         emit LogHodlSetStake(_beneficiary, hodlerStakes[_beneficiary].stake);
413         return true;
414     }
415    
416     /* 
417     * This method can only be called by HITT token contract.
418     * This will return true: when we successfully invalidate a stake
419     * false: When we try to invalidate the stake of either already
420     * invalidated or not participated stake holder in Pre-ico
421     */ 
422     function invalidate(address _account) public onlyOwner returns (bool) {
423         if (hodlerStakes[_account].stake > 0 ) {
424             hodlerTotalValue = hodlerTotalValue.sub(hodlerStakes[_account].stake); 
425             hodlerTotalCount = hodlerTotalCount.sub(1);
426             updateAndGetHodlTotalValue();
427             delete hodlerStakes[_account];
428             return true;
429         }
430         return false;
431     }
432 
433     /* 
434     * This method will be used whether the particular user has HODL stake or not.   
435     */
436     function isValid(address _account) view public returns (bool) {
437         if (hodlerStakes[_account].stake > 0) {
438             return true;
439         }
440         return false;
441     }
442     
443     /*
444     * Claiming HODL reward for an address.
445     * Ideally it shall be called by Admin. But it can be called by anyone 
446     * by passing the beneficiery address.
447     */
448     function claimHodlRewardFor(address _beneficiary) public returns (bool) {
449         require(block.timestamp.sub(hodlerTimeStart)<= 450 days ); 
450         // only when the address has a valid stake
451         require(hodlerStakes[_beneficiary].stake > 0);
452         updateAndGetHodlTotalValue();
453         uint256 _stake = calculateStake(_beneficiary);
454         if (_stake > 0) {
455             if (istransferringTokens == false) {
456             // increasing claimed tokens
457             claimedTokens = claimedTokens.add(_stake);
458                 istransferringTokens = true;
459             // Transferring tokens
460             require(tokenContract.transfer(_beneficiary, _stake));
461                 istransferringTokens = false ;
462             emit LogHodlClaimed(_beneficiary, _stake);
463             return true;
464             }
465         } 
466         return false;
467     }
468 
469     /* 
470     * This method is to calculate the HODL stake for a particular user at a time.
471     */
472     function calculateStake(address _beneficiary) internal returns (uint256) {
473         uint256 _stake = 0;
474                 
475         HODL memory hodler = hodlerStakes[_beneficiary];
476         
477         if(( hodler.claimed3M == false ) && ( block.timestamp.sub(hodlerTimeStart)) >= 90 days){ 
478             _stake = _stake.add(hodler.stake.mul(TOKEN_HODL_3M).div(hodlerTotalValue3M));
479             hodler.claimed3M = true;
480         }
481         if(( hodler.claimed6M == false ) && ( block.timestamp.sub(hodlerTimeStart)) >= 180 days){ 
482             _stake = _stake.add(hodler.stake.mul(TOKEN_HODL_6M).div(hodlerTotalValue6M));
483             hodler.claimed6M = true;
484         }
485         if(( hodler.claimed9M == false ) && ( block.timestamp.sub(hodlerTimeStart)) >= 270 days ){ 
486             _stake = _stake.add(hodler.stake.mul(TOKEN_HODL_9M).div(hodlerTotalValue9M));
487             hodler.claimed9M = true;
488         }
489         if(( hodler.claimed12M == false ) && ( block.timestamp.sub(hodlerTimeStart)) >= 360 days){ 
490             _stake = _stake.add(hodler.stake.mul(TOKEN_HODL_12M).div(hodlerTotalValue12M));
491             hodler.claimed12M = true;
492         }
493         
494         hodlerStakes[_beneficiary] = hodler;
495         return _stake;
496     }
497     
498     /*
499     * This method is to complete HODL period. Any leftover tokens will 
500     * return to admin and then will be added to the growth pool after 450 days .
501     */
502     function finalizeHodler() public returns (bool) {
503         require(msg.sender == admin);
504         require(block.timestamp >= hodlerTimeStart.add( 450 days ) ); 
505         uint256 amount = tokenContract.balanceOf(this);
506         require(amount > 0);
507         if (istransferringTokens == false) {
508             istransferringTokens = true;
509             require(tokenContract.transfer(admin,amount));
510             istransferringTokens = false;
511             return true;
512         }
513         return false;
514     }
515     
516     
517 
518     /*
519     * `claimHodlRewardsForMultipleAddresses()` for multiple addresses.
520     * Anyone can call this function and distribute hodl rewards.
521     * `_beneficiaries` is the array of addresses for which we want to claim HODL rewards.
522     */
523     function claimHodlRewardsForMultipleAddresses(address[] _beneficiaries) external returns (bool) {
524         require(block.timestamp.sub(hodlerTimeStart) <= 450 days ); 
525         uint8 length = uint8(_beneficiaries.length);
526         for (uint8 i = 0; i < length ; i++) {
527             if(hodlerStakes[_beneficiaries[i]].stake > 0 && (hodlerStakes[_beneficiaries[i]].claimed3M == false || hodlerStakes[_beneficiaries[i]].claimed6M == false || hodlerStakes[_beneficiaries[i]].claimed9M == false || hodlerStakes[_beneficiaries[i]].claimed12M == false)) { 
528                 require(claimHodlRewardFor(_beneficiaries[i]));
529             }
530         }
531         return true;
532     }
533     
534     /* 
535     * This method is used to set the amount of `hodlerTotalValue` remaining.
536     * `hodlerTotalValue` will keep getting lower as the people shall be invalidating their stakes over the period of 12 months.
537     * Setting 3, 6, 9 & 12 months total staked token value.
538     */
539     function updateAndGetHodlTotalValue() public returns (uint) {
540         if (block.timestamp >= hodlerTimeStart+ 90 days && hodlerTotalValue3M == 0) {   
541             hodlerTotalValue3M = hodlerTotalValue;
542         }
543 
544         if (block.timestamp >= hodlerTimeStart+ 180 days && hodlerTotalValue6M == 0) { 
545             hodlerTotalValue6M = hodlerTotalValue;
546         }
547 
548         if (block.timestamp >= hodlerTimeStart+ 270 days && hodlerTotalValue9M == 0) { 
549             hodlerTotalValue9M = hodlerTotalValue;
550         }
551         if (block.timestamp >= hodlerTimeStart+ 360 days && hodlerTotalValue12M == 0) { 
552             hodlerTotalValue12M = hodlerTotalValue;
553         }
554 
555         return hodlerTotalValue;
556     }
557 }