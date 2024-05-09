1 pragma solidity ^0.4.25;
2 
3 /*  
4      ==================================================================
5     ||  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  ||
6     ||  + Digital Multi Level Marketing in Ethereum smart-contract +  ||
7     ||  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  ||
8      ==================================================================
9      
10     https://ethmlm.com
11     https://t.me/ethmlm
12     
13     
14          ``..................``  ``....................``  ``..``             ``.``          
15         `..,,,,,,,,,,,,,,,,,,.` ``.,,,,,,,,,,,,,,,,,,,,.`  `.,,.`            `..,.``         
16         `.:::::,,,,,,,,,,,,,,.```.,,,,,,,:::::::,,,,,,,.`  `,::,.            `.,:,.`         
17         `,:;:,,...............`  `.......,,:;::,,.......`  .,::,.`           `.:;,.`         
18         `,:;:,.```````````````   ````````.,:::,.````````   .,::,.`           `.:;,.`         
19      ++++++++++++++++++++    ++++++++++++++++++++++,   ,+++.,::,.`        ++++.:;,.`         
20      ####################    ######################:   ,###.,::,.`        ####.:;,.`         
21      ###';'';;:::::::::::````:::::::::+###;;'';::::.   ,###.,::,.`````````####,:;,.`         
22      ###;,:;:,,.............``        +###.,::,`       ,###.,:;:,,........####::;,.`         
23      ###;,:;:::,,,,,,,,,,,,,.`        +###.,::,`       ,###.,:;::,,,,,,,,,####::;,.`         
24      ###;,:;::,,,,,,,,,,,,,,.`        +###.,::,`       ,###.,:;::,,,,,,,,,####::;,.`         
25      ###;,:;:,..............``        +###.,::,`       ,###.,:::,.````````####,:;,.`         
26      ###;,:;:.``````````````          +###.,::,`       ,###.,::,.`        ####,:;,.`         
27      ###################              +###.,::,`       ,######################.:;,.`         
28      ###################              +###.,::,`       ,######################.:;,.`         
29      ###;,:;:.````````````````        +###.,::,`       ,###.,::,.`        ####.:;,.`         
30      ###;,:;:,................``      +###.,::,`       ,###.,::,.`        ####.:;,.`         
31      ###;,:;:::,,,,,,,,,,,,,,,.`      +###.,::,`       ,###.,::,.`        ####.:;,.`         
32      ###:.,,,,,,,,,,,,,,,,,,,,.`      +###`.,,.`       ,###`.,,.`         ####.,,,.`         
33      ###:`....................``      +###``..``       ,###``..``         ####`...`          
34      ###: `````````````````````       +### ````        ,### ````          #### ```           
35      #####################            +###             ,###               ####               
36      #####################            +###             ,###               ####               
37      ,,,,,,,,,,,,,,,,,,,,,     `````` .,,,`````        `,,,     ```````   ,,,,        `````` 
38         `..,,,.``             `..,,.``   ``.,.`                `..,,,.``             `..,,.``
39         `.::::,.`            `.,:::,.`   `.,:,.`               `.,:::,.`            `.,:::,.`
40         .,:;;;:,.`           .,:;;;:.`   `,:;,.`               .,:;;;:,.`           .,:;;;:,`
41         .,:;::::,`          `.,:;;;:.`   `,:;,.`               .,:;::::,`          `.,:::;:,`
42         .,::::::,.`        `.,::::;:.`   `,:;,.`               .,:;::::,.`        `.,::::;:,`
43     .#####+::,,::,`       ######::;:.,###`,:;,.`            ######::::::,`       +#####::;:,`
44     .######:,,,::,.`      ######,:;:.,###`,:;,.`            ######:,,,::,.`      ######,,;:,`
45     .######+,..,::,`     #######,:;:.,###`,:;,.`            ###'###,..,::,`     #######.,;:,`
46     .###.###,.`.,:,.`   .##+####.:;:.,###`,:;,.`            ###.###,.`.,:,.`    #######.,;:,`
47     .###.+###.``,::,`   ###:####.:;:.,###`,:;,.`            ###.'###.`.,::,`   ###:####.,;:,`
48     .###.,###. `.,:,.` :##':####.:;:.,###`,:;,.`            ###.,###,``.,:,.` `##+:####.,;:,`
49     .###.,+###  `,::,.`###:,####.:;:.,###`,:;,.`            ###.,'###` `,::,. ###:,####.,;:,`
50     .###.,:###` `.,::.'##;:,####.:;:.,###`,:;,.`            ###.,:###, `.,::.,##':,####.,;:,`
51     .###.,:'###  `,::,###:,.####.:;:.,###`,:;,.`            ###.,:;###  `,::,###:,.####.,;:,`
52     .###.,::###` `.,:+##::,`####.:;:.,###`,:;,.`            ###.,::###: `.,:'##;:,`####.,;:,`
53     .###.,::;###  `,:###:,.`####.:;:.,###`,:;:,............`###.,::,###  `,:###:,.`####.,;:,`
54     .###.,::,###. `.###::,` ####.:;:.,###`,:;::,,,,,,,,,,,,.###.,::,###; `.+##;:,` ####.,;:,`
55     .###`.::.,###  `##+:,.` ####.,:,.,###`.,:::,,,,,,,,,,,,.###`.,:,.###  `###:,.` ####.,:,.`
56     .###`....`###, ###,..`  ####`.,.`,###``.,,,,,,,,,,,,,,..###`....`###' +##,..`  ####`.,.``
57     .### ```` `###`##'```   ####`````,### ``````````````````### ````  ### ##+```   ####````` 
58     .###       ######       ####     .###                   ###       +#####       ####      
59     .###        ####,       ####     .#################     ###        ####'       ####      
60     .###        ####        ####     .#################     ###        '###        ####     
61     
62 
63 */
64 
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71   address private _owner;
72 
73   event OwnershipTransferred(
74     address indexed previousOwner,
75     address indexed newOwner
76   );
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   constructor() internal {
83     _owner = msg.sender;
84     emit OwnershipTransferred(address(0), _owner);
85   }
86 
87   /**
88    * @return the address of the owner.
89    */
90   function owner() public view returns(address) {
91     return _owner;
92   }
93 
94   /**
95    * @dev Throws if called by any account other than the owner.
96    */
97   modifier onlyOwner() {
98     require(isOwner());
99     _;
100   }
101 
102   /**
103    * @return true if `msg.sender` is the owner of the contract.
104    */
105   function isOwner() public view returns(bool) {
106     return msg.sender == _owner;
107   }
108 
109   /**
110    * @dev Allows the current owner to relinquish control of the contract.
111    * @notice Renouncing to ownership will leave the contract without an owner.
112    * It will not be possible to call the functions with the `onlyOwner`
113    * modifier anymore.
114    */
115   function renounceOwnership() public onlyOwner {
116     emit OwnershipTransferred(_owner, address(0));
117     _owner = address(0);
118   }
119 
120   /**
121    * @dev Allows the current owner to transfer control of the contract to a newOwner.
122    * @param newOwner The address to transfer ownership to.
123    */
124   function transferOwnership(address newOwner) public onlyOwner {
125     _transferOwnership(newOwner);
126   }
127 
128   /**
129    * @dev Transfers control of the contract to a newOwner.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function _transferOwnership(address newOwner) internal {
133     require(newOwner != address(0));
134     emit OwnershipTransferred(_owner, newOwner);
135     _owner = newOwner;
136   }
137 }
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that revert on error
141  */
142 library SafeMath {
143 
144   /**
145   * @dev Multiplies two numbers, reverts on overflow.
146   */
147   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
151     if (a == 0) {
152       return 0;
153     }
154 
155     uint256 c = a * b;
156     require(c / a == b);
157 
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
163   */
164   function div(uint256 a, uint256 b) internal pure returns (uint256) {
165     require(b > 0); // Solidity only automatically asserts when dividing by 0
166     uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168 
169     return c;
170   }
171 
172   /**
173   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
174   */
175   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176     require(b <= a);
177     uint256 c = a - b;
178 
179     return c;
180   }
181 
182   /**
183   * @dev Adds two numbers, reverts on overflow.
184   */
185   function add(uint256 a, uint256 b) internal pure returns (uint256) {
186     uint256 c = a + b;
187     require(c >= a);
188 
189     return c;
190   }
191 
192   /**
193   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
194   * reverts when dividing by zero.
195   */
196   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
197     require(b != 0);
198     return a % b;
199   }
200 }
201 /**
202  * Utility library of inline functions on addresses
203  */
204 library Address {
205 
206   /**
207    * Returns whether the target address is a contract
208    * @dev This function will return false if invoked during the constructor of a contract,
209    * as the code is not actually created until after the constructor finishes.
210    * @param account address of the account to check
211    * @return whether the target address is a contract
212    */
213   function isContract(address account) internal view returns (bool) {
214     uint256 size;
215     // XXX Currently there is no better way to check if there is a contract in an address
216     // than to check the size of the code at that address.
217     // See https://ethereum.stackexchange.com/a/14016/36603
218     // for more details about how this works.
219     // TODO Check this again before the Serenity release, because all addresses will be
220     // contracts then.
221     // solium-disable-next-line security/no-inline-assembly
222     assembly { size := extcodesize(account) }
223     return size > 0;
224   }
225 
226 }
227 /**
228  * @title Helps contracts guard against reentrancy attacks.
229  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
230  * @dev If you mark a function `nonReentrant`, you should also
231  * mark it `external`.
232  */
233 contract ReentrancyGuard {
234 
235   /// @dev counter to allow mutex lock with only one SSTORE operation
236   uint256 private _guardCounter;
237 
238   constructor() internal {
239     // The counter starts at one to prevent changing it from zero to a non-zero
240     // value, which is a more expensive operation.
241     _guardCounter = 1;
242   }
243 
244   /**
245    * @dev Prevents a contract from calling itself, directly or indirectly.
246    * Calling a `nonReentrant` function from another `nonReentrant`
247    * function is not supported. It is possible to prevent this from happening
248    * by making the `nonReentrant` function external, and make it call a
249    * `private` function that does the actual work.
250    */
251   modifier nonReentrant() {
252     _guardCounter += 1;
253     uint256 localCounter = _guardCounter;
254     _;
255     require(localCounter == _guardCounter);
256   }
257 
258 }
259 
260 
261 
262 contract MLM_FOMO_BANK is Ownable {
263     using SafeMath for uint256;
264     
265     //  time to win FOMO bank
266     uint public fomo_period = 3600;     // 1 hour
267     
268     //  FOMO bank balance
269     uint public balance;
270     //  next winner address
271     address public winner;
272     //  win time
273     uint public finish_time;
274     
275     //  MLM contract
276     address _mlm;
277     
278     //  only MLM contract can call method
279     modifier onlyMLM() {
280         require(msg.sender == _mlm);
281         _;
282     }
283 
284     
285     event Win(address indexed user, uint amount);
286     
287     
288     function SetMLM(address mlm) public onlyOwner {
289         _mlm = mlm;
290     }
291     
292     //  fill the bank
293     function AddToBank(address user) public payable onlyMLM {
294         //  check for winner
295         CheckWinner();
296         
297         // save last payment info
298         balance = balance.add(msg.value);
299         winner = user;
300         finish_time = now + fomo_period;
301     }
302     
303     // check winner
304     function CheckWinner() internal {
305         if(now > finish_time && winner != address(0)){
306             emit Win(winner, balance);
307             
308             //  it should not be reentrancy, but just in case
309             uint prev_balance = balance;
310             balance = 0;
311             //  send ethers to winner
312             winner.transfer(prev_balance);
313             winner = address(0);
314         }
315     }
316     
317     //  get cuurent FOMO info {balance, finish_time, winner }
318     function GetInfo() public view returns (uint, uint, address) {
319         return (
320             balance,
321             finish_time,
322             winner
323         );
324     }
325 }
326 
327 contract MLM is Ownable, ReentrancyGuard {
328     using SafeMath for uint256;
329     using Address for address;
330     
331     // FOMO bank contract
332     MLM_FOMO_BANK _fomo;
333     
334     struct userStruct {
335         address[] referrers;    //  array with 3 level referrers
336         address[] referrals;    //  array with referrals
337         uint next_payment;      //  time to next payments, seconds
338         bool isRegitered;       //  is user registered
339         bytes32 ref_link;       //  referral link
340     }
341     
342     // mapping with users
343     mapping(address=>userStruct) users;
344     //  mapping with referral links
345     mapping(bytes32=>address) ref_to_users;
346     
347     uint public min_paymnet = 100 finney;               //  minimum payment amount 0,1ETH
348     uint public min_time_to_add = 604800;               //  Time need to add after miimum payment, seconds | 1 week
349     uint[] public reward_parts = [35, 25, 15, 15, 10];  //  how much need to send to referrers, %
350 
351     event RegisterEvent(address indexed user, address indexed referrer);
352     event PayEvent(address indexed payer, uint amount, bool[3] levels);
353     
354     
355     constructor(MLM_FOMO_BANK fomo) public {
356         //  set FOMO contract
357         _fomo = fomo;
358     }
359     
360 
361 
362     function() public payable {
363         //  sender should not be a contract
364         require(!address(msg.sender).isContract());
365         //  user should be registered
366         require(users[msg.sender].isRegitered);
367         //  referrer address is 0x00 because user is already registered and referrer is stored on the first payment
368         Pay(0x00);
369     }
370     
371     
372     /*
373     Make a payment
374     --------------
375     [bytes32 referrer_addr] - referrer's address. it is used only on first payment to save sender as a referral
376     */
377     function Pay(bytes32 referrer_addr) public payable nonReentrant {
378         //  sender should not be a contract
379         require(!address(msg.sender).isContract());
380         //  check minimum amount
381         require(msg.value >= min_paymnet);
382         
383         //  if it is a first payment need to register sender
384         if(!users[msg.sender].isRegitered){
385             _register(referrer_addr);
386         }
387         
388         uint amount = msg.value;
389         //  what referrer levels will received a payments, need on UI
390         bool[3] memory levels = [false,false,false];
391         //  iterate of sender's referrers
392         for(uint i = 0; i < users[msg.sender].referrers.length; i++){
393             //  referrer address at level i
394             address ref = users[msg.sender].referrers[i];
395             //  if referrer is active need to pay him
396             if(users[ref].next_payment > now){
397                 //  calculate reward part, i.e. 0.1 * 35 / 100  = 0.035
398                 uint reward = amount.mul(reward_parts[i]).div(100);
399                 //  send reward to referrer
400                 ref.transfer(reward);
401                 //  set referrer's level ad payment
402                 levels[i] = true;
403             }
404         }
405         
406         //  what address will be saved to FOMO bank, referrer or current sender
407         address fomo_user = msg.sender;
408         if(users[msg.sender].referrers.length>0 && users[users[msg.sender].referrers[0]].next_payment > now)
409             fomo_user = users[msg.sender].referrers[0];
410             
411         //  send 15% to FOMO bank and store selceted user
412         _fomo.AddToBank.value(amount.mul(reward_parts[3]).div(100)).gas(gasleft())(fomo_user);
413         
414         // prolong referral link life
415         if(now > users[msg.sender].next_payment)
416             users[msg.sender].next_payment = now.add(amount.mul(min_time_to_add).div(min_paymnet));
417         else 
418             users[msg.sender].next_payment = users[msg.sender].next_payment.add(amount.mul(min_time_to_add).div(min_paymnet));
419         
420         emit PayEvent(msg.sender, amount, levels);
421     }
422     
423     
424     
425     function _register(bytes32 referrer_addr) internal {
426         // sender should not be registered
427         require(!users[msg.sender].isRegitered);
428         
429         // get referrer address
430         address referrer = ref_to_users[referrer_addr];
431         // users could not be a referrer
432         require(referrer!=msg.sender);
433         
434         //  if there is referrer
435         if(referrer != address(0)){
436             //  set refferers for currnet user
437             _setReferrers(referrer, 0);
438         }
439         //  mark user as registered
440         users[msg.sender].isRegitered = true;
441         //  calculate referral link
442         _getReferralLink(referrer);
443         
444 
445         emit RegisterEvent(msg.sender, referrer);
446     }
447     
448     //  generate a referral link
449     function _getReferralLink(address referrer) internal {
450         do{
451             users[msg.sender].ref_link = keccak256(abi.encodePacked(uint(msg.sender) ^  uint(referrer) ^ now));
452         } while(ref_to_users[users[msg.sender].ref_link] != address(0));
453         ref_to_users[users[msg.sender].ref_link] = msg.sender;
454     }
455     
456     // set referrers
457     function _setReferrers(address referrer, uint level) internal {
458         //  set referrer only for active user other case use his referrer
459         if(users[referrer].next_payment > now){
460             users[msg.sender].referrers.push(referrer);
461             if(level == 0){
462                 //  add current user to referrer's referrals list
463                 users[referrer].referrals.push(msg.sender);
464             }
465             level++;
466         }
467         //  set referrers for 3 levels
468         if(level<3 && users[referrer].referrers.length>0)
469             _setReferrers(users[referrer].referrers[0], level);
470     }
471     
472     /*  Get user info
473     
474         uint next_payment
475         bool isRegitered
476         bytes32 ref_link
477     */
478     function GetUser() public view returns(uint, bool, bytes32) {
479         return (
480             users[msg.sender].next_payment,
481             users[msg.sender].isRegitered,
482             users[msg.sender].ref_link
483         );
484     }
485     
486     // Get sender's referrers
487     function GetReferrers() public view returns(address[] memory) {
488         return users[msg.sender].referrers;
489     }
490     
491     //  Get sender's referrals
492     function GetReferrals() public view returns(address[] memory) {
493         return users[msg.sender].referrals;
494     }
495     
496     //  Project's owner can widthdraw contract's balance
497     function widthdraw(address to, uint amount) public onlyOwner {
498         to.transfer(amount);
499     }
500 }