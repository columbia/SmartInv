1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner()  {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     /**
27      * @dev Allows the current owner to transfer control of the contract to a newOwner.
28      * @param newOwner The address to transfer ownership to.
29      */
30     function transferOwnership(address newOwner) public onlyOwner {
31         if (newOwner != address(0)) {
32             owner = newOwner;
33         }
34     }
35 }
36 
37 /**
38  * @title Pausable
39  * @dev Base contract which allows children to implement an emergency stop mechanism.
40  */
41 contract Pausable is Ownable {
42     event Pause();
43     event Unpause();
44 
45     bool public paused = true;
46     /**
47      * @dev modifier to allow actions only when the contract IS paused
48      */
49     modifier whenNotPaused() {
50         require(!paused);
51         _;
52     }
53 
54     /**
55      * @dev modifier to allow actions only when the contract IS NOT paused
56      */
57     modifier whenPaused {
58         require(paused);
59         _;
60     }
61 
62     /**
63      * @dev called by the owner to pause, triggers stopped state
64      */
65     function pause() public onlyOwner whenNotPaused returns (bool) {
66         paused = true;
67         emit Pause();
68         return true;
69     }
70 
71     /**
72      * @dev called by the owner to unpause, returns to normal state
73      */
74     function unpause() public onlyOwner whenPaused returns (bool) {
75         paused = false;
76         emit Unpause();
77         return true;
78     }
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         uint256 c = a * b;
88         assert(a == 0 || c / a == b);
89         return c;
90     }
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // assert(b > 0); // Solidity automatically throws when dividing by 0
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95         return c;
96     }
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         assert(c >= a);
104         return c;
105     }
106 }
107 
108 /**
109  * @title ERC20Basic
110  * @dev Simpler version of ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/179
112  */
113 contract ERC20Basic {
114     uint256 public totalSupply;
115     function balanceOf(address who) public constant returns (uint256);
116     function transfer(address to, uint256 value) public returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) public constant returns (uint256);
126   function transferFrom(address from, address to, uint256 value) public returns (bool);
127   function approve(address spender, uint256 value) public returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136     using SafeMath for uint256;
137     mapping(address => uint256) balances;
138 
139     /**
140      * @dev transfer token for a specified address
141      * @param _to The address to transfer to.
142      * @param _value The amount to be transferred.
143      */
144     function transfer(address _to, uint256 _value) public returns (bool) {
145         balances[msg.sender] = balances[msg.sender].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         emit Transfer(msg.sender, _to, _value);
148         return true;
149     }
150     /**
151      * @dev Gets the balance of the specified address.
152      * @param _owner The address to query the the balance of.
153      * @return An uint256 representing the amount owned by the passed address.
154      */
155     function balanceOf(address _owner) public constant returns (uint256 balance) {
156         return balances[_owner];
157     }
158 }
159 
160 /**
161  * @title Standard ERC20 token
162  * @dev Implementation of the basic standard token.
163  * @dev https://github.com/ethereum/EIPs/issues/20
164  */
165 contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) allowed;
168     /**
169      * @dev Transfer tokens from one address to another
170      * @param _from address The address which you want to send tokens from
171      * @param _to address The address which you want to transfer to
172      * @param _value uint256 the amout of tokens to be transfered
173      */
174     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
175         uint256 _allowance = allowed[_from][msg.sender];
176 
177         balances[_to] = balances[_to].add(_value);
178         balances[_from] = balances[_from].sub(_value);
179         allowed[_from][msg.sender] = _allowance.sub(_value);
180         emit Transfer(_from, _to, _value);
181         return true;
182     }
183 
184     /**
185        * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
186        * @param _spender The address which will spend the funds.
187        * @param _value The amount of tokens to be spent.
188        */
189       function approve(address _spender, uint256 _value) public returns (bool) {
190 
191         // To change the approve amount you first have to reduce the addresses`
192         //  allowance to zero by calling `approve(_spender, 0)` if it is not
193         //  already 0 to mitigate the race condition described here:
194         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
196 
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200       }
201 
202       /**
203        * @dev Function to check the amount of tokens that an owner allowed to a spender.
204        * @param _owner address The address which owns the funds.
205        * @param _spender address The address which will spend the funds.
206        * @return A uint256 specifing the amount of tokens still avaible for the spender.
207        */
208       function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210       }
211 
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222     event Mint(address indexed to, uint256 amount);
223     event MintFinished();
224     bool public mintingFinished = false;
225 
226     modifier canMint() {
227         require(!mintingFinished);
228         _;
229     }
230 
231     /**
232      * @dev Function to mint tokens
233      * @param _to The address that will recieve the minted tokens.
234      * @param _amount The amount of tokens to mint.
235      * @return A boolean that indicates if the operation was successful.
236      */
237     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
238         totalSupply = totalSupply.add(_amount);
239         balances[_to] = balances[_to].add(_amount);
240         emit Transfer(0X0, _to, _amount);
241         return true;
242     }
243 
244     /**
245      * @dev Function to stop minting new tokens.
246      * @return True if the operation was successful.
247      */
248     function finishMinting() public onlyOwner returns (bool) {
249         mintingFinished = true;
250         emit MintFinished();
251         return true;
252     }
253 }
254 
255 contract BlockableToken is Ownable{
256     event Blocked(address blockedAddress);
257     event UnBlocked(address unBlockedAddress);
258     //keep mapping of blocked addresses
259     mapping (address => bool) public blockedAddresses;
260     modifier whenNotBlocked(){
261       require(!blockedAddresses[msg.sender]);
262       _;
263     }
264 
265     function blockAddress(address toBeBlocked) onlyOwner public {
266       blockedAddresses[toBeBlocked] = true;
267       emit Blocked(toBeBlocked);
268     }
269     function unBlockAddress(address toBeUnblocked) onlyOwner public {
270       blockedAddresses[toBeUnblocked] = false;
271       emit UnBlocked(toBeUnblocked);
272     }
273 }
274 
275 
276 contract StrikeToken is MintableToken, Pausable, BlockableToken{
277     string public name = "Dimensions Strike Token";
278     string public symbol = "DST";
279     uint256 public decimals = 18;
280 
281     event Ev(string message, address whom, uint256 val);
282 
283     struct XRec {
284         bool inList;
285         address next;
286         address prev;
287         uint256 val;
288     }
289 
290     struct QueueRecord {
291         address whom;
292         uint256 val;
293     }
294 
295     address first = 0x0;
296     address last = 0x0;
297 
298     mapping (address => XRec) public theList;
299 
300     QueueRecord[]  theQueue;
301 
302     // add a record to the END of the list
303     function add(address whom, uint256 value) internal {
304         theList[whom] = XRec(true,0x0,last,value);
305         if (last != 0x0) {
306             theList[last].next = whom;
307         } else {
308             first = whom;
309         }
310         last = whom;
311         emit Ev("add",whom,value);
312     }
313 
314     function remove(address whom) internal {
315         if (first == whom) {
316             first = theList[whom].next;
317             theList[whom] = XRec(false,0x0,0x0,0);
318             return;
319         }
320         address next = theList[whom].next;
321         address prev = theList[whom].prev;
322         if (prev != 0x0) {
323             theList[prev].next = next;
324         }
325         if (next != 0x0) {
326             theList[next].prev = prev;
327         }
328         theList[whom] =XRec(false,0x0,0x0,0);
329         emit Ev("remove",whom,0);
330     }
331 
332     function update(address whom, uint256 value) internal {
333         if (value != 0) {
334             if (!theList[whom].inList) {
335                 add(whom,value);
336             } else {
337                 theList[whom].val = value;
338                 emit Ev("update",whom,value);
339             }
340             return;
341         }
342         if (theList[whom].inList) {
343             remove(whom);
344         }
345     }
346 
347     /**
348      * @dev Allows anyone to transfer the Strike tokens once trading has started
349      * @param _to the recipient address of the tokens.
350      * @param _value number of tokens to be transfered.
351      */
352     function transfer(address _to, uint _value) public whenNotPaused whenNotBlocked returns (bool) {
353         bool result = super.transfer(_to, _value);
354         update(msg.sender,balances[msg.sender]);
355         update(_to,balances[_to]);
356         return result;
357     }
358 
359     /**
360      * @dev Allows anyone to transfer the Strike tokens once trading has started
361      * @param _from address The address which you want to send tokens from
362      * @param _to address The address which you want to transfer to
363      * @param _value uint the amout of tokens to be transfered
364      */
365     function transferFrom(address _from, address _to, uint _value) public whenNotPaused whenNotBlocked returns (bool) {
366         bool result = super.transferFrom(_from, _to, _value);
367         update(_from,balances[_from]);
368         update(_to,balances[_to]);
369         return result;
370     }
371 
372     /**
373      * @dev Function to mint tokens
374      * @param _to The address that will recieve the minted tokens.
375      * @param _amount The amount of tokens to mint.
376      * @return A boolean that indicates if the operation was successful.
377      */
378 
379     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
380         bool result = super.mint(_to,_amount);
381         update(_to,balances[_to]);
382         return result;
383     }
384 
385     constructor()  public{
386         owner = msg.sender;
387     }
388 
389     function changeOwner(address newOwner) public onlyOwner {
390         owner = newOwner;
391     }
392 }
393 
394 contract StrikeTokenCrowdsale is Ownable, Pausable {
395     using SafeMath for uint256;
396 
397     StrikeToken public token = new StrikeToken();
398 
399     // start and end times
400     uint256 public startTimestamp = 1575158400;
401     uint256 public endTimestamp = 1577750400;
402     uint256 etherToWei = 10**18;
403 
404     // address where funds are collected and tokens distributed
405     address public hardwareWallet = 0xDe3A91E42E9F6955ce1a9eDb23Be4aBf8d2eb08B;
406     address public restrictedWallet = 0xDe3A91E42E9F6955ce1a9eDb23Be4aBf8d2eb08B;
407     address public additionalTokensFromCommonPoolWallet = 0xDe3A91E42E9F6955ce1a9eDb23Be4aBf8d2eb08B;
408 
409     mapping (address => uint256) public deposits;
410     uint256 public numberOfPurchasers;
411 
412     // Percentage bonus tokens given in Token Sale, on a daily basis
413     uint256[] public bonus = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
414     uint256 public rate = 4800; // 4800 DST is one Ether
415 
416     // amount of raised money in wei
417     uint256 public weiRaised = 0;
418     uint256 public tokensSold = 0;
419     uint256 public advisorTokensGranted = 0;
420     uint256 public commonPoolTokensGranted = 0;
421 
422     uint256 public minContribution = 100 * 1 finney;
423     uint256 public hardCapEther = 30000;
424     uint256 hardcap = hardCapEther * etherToWei;
425 
426     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
427     event MainSaleClosed();
428 
429     uint256 public weiRaisedInPresale  = 0 ether;
430 
431     bool private frozen = false;
432 
433     function freeze() public onlyOwner{
434       frozen = true;
435     }
436     function unfreeze() public onlyOwner{
437       frozen = false;
438     }
439 
440     modifier whenNotFrozen() {
441         require(!frozen);
442         _;
443     }
444     modifier whenFrozen() {
445         require(frozen);
446         _;
447     }
448 
449     function setHardwareWallet(address _wallet) public onlyOwner {
450         require(_wallet != 0x0);
451         hardwareWallet = _wallet;
452     }
453 
454     function setRestrictedWallet(address _restrictedWallet) public onlyOwner {
455         require(_restrictedWallet != 0x0);
456         restrictedWallet = _restrictedWallet;
457     }
458 
459     function setAdditionalTokensFromCommonPoolWallet(address _wallet) public onlyOwner {
460         require(_wallet != 0x0);
461         additionalTokensFromCommonPoolWallet = _wallet;
462     }
463 
464     function setHardCapEther(uint256 newEtherAmt) public onlyOwner{
465         require(newEtherAmt > 0);
466         hardCapEther = newEtherAmt;
467         hardcap = hardCapEther * etherToWei;
468     }
469 
470     constructor() public  {
471         require(startTimestamp >= now);
472         require(endTimestamp >= startTimestamp);
473     }
474 
475     // check if valid purchase
476     modifier validPurchase {
477         require(now >= startTimestamp);
478         require(now < endTimestamp);
479         require(msg.value >= minContribution);
480         require(frozen == false);
481         _;
482     }
483 
484     // @return true if crowdsale event has ended
485     function hasEnded() public constant returns (bool) {
486         if (now > endTimestamp)
487             return true;
488         return false;
489     }
490 
491     // low level token purchase function
492     function buyTokens(address beneficiary) public payable validPurchase {
493         require(beneficiary != 0x0);
494 
495         uint256 weiAmount = msg.value;
496 
497         // Check if the hardcap has been exceeded
498         uint256 weiRaisedSoFar = weiRaised.add(weiAmount);
499         require(weiRaisedSoFar + weiRaisedInPresale <= hardcap);
500 
501         if (deposits[msg.sender] == 0) {
502             numberOfPurchasers++;
503         }
504         deposits[msg.sender] = weiAmount.add(deposits[msg.sender]);
505 
506         uint256 daysInSale = (now - startTimestamp) / (1 days);
507         uint256 thisBonus = 0;
508         if(daysInSale < 29 ){
509             thisBonus = bonus[daysInSale];
510         }
511 
512         // Calculate token amount to be created
513         uint256 tokens = weiAmount.mul(rate);
514         uint256 extraBonus = tokens.mul(thisBonus);
515         extraBonus = extraBonus.div(100);
516         tokens = tokens.add(extraBonus);
517 
518         // Update the global token sale variables
519         uint256 finalTokenCount;
520         finalTokenCount = tokens.add(tokensSold);
521         weiRaised = weiRaisedSoFar;
522         tokensSold = finalTokenCount;
523 
524         token.mint(beneficiary, tokens);
525         hardwareWallet.transfer(msg.value);
526         emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
527     }
528 
529     function grantTokensAdvisors(address beneficiary,uint256 dstTokenCount) public onlyOwner{
530         dstTokenCount = dstTokenCount * etherToWei;
531         advisorTokensGranted = advisorTokensGranted.add(dstTokenCount);
532         token.mint(beneficiary,dstTokenCount);
533     }
534 
535     function grantTokensCommonPool(address beneficiary,uint256 dstTokenCount) public onlyOwner{
536         dstTokenCount = dstTokenCount * etherToWei;
537         commonPoolTokensGranted = commonPoolTokensGranted.add(dstTokenCount);
538         token.mint(beneficiary,dstTokenCount);
539     }
540 
541     // finish mining coins and transfer ownership of Change coin to owner
542     function finishMinting() public onlyOwner returns(bool){
543         require(hasEnded());
544 
545         uint issuedTokenSupply = token.totalSupply();
546         uint publicTokens = issuedTokenSupply-advisorTokensGranted;
547         if(publicTokens>60*advisorTokensGranted/40 ){
548           uint restrictedTokens=(publicTokens)*40/60-advisorTokensGranted;
549           token.mint(restrictedWallet, restrictedTokens);
550           advisorTokensGranted=advisorTokensGranted+restrictedTokens;
551         }
552         else if(publicTokens<60*advisorTokensGranted/40){
553           uint256 deltaCommonPool=advisorTokensGranted*60/40-publicTokens;
554           token.mint(additionalTokensFromCommonPoolWallet,deltaCommonPool);
555         }
556 
557         token.finishMinting();
558         token.transferOwnership(owner);
559         emit MainSaleClosed();
560         return true;
561     }
562 
563     // fallback function can be used to buy tokens
564     function () payable public {
565         buyTokens(msg.sender);
566     }
567     function setRate(uint256 amount) onlyOwner public {
568         require(amount>=0);
569         rate = amount;
570     }
571     function setBonus(uint256 [] amounts) onlyOwner public {
572       require( amounts.length > 30 );
573         bonus = amounts;
574     }
575     function setWeiRaisedInPresale(uint256 amount) onlyOwner public {
576         require(amount>=0);
577         weiRaisedInPresale = amount;
578     }
579     function setEndTimeStamp(uint256 end) onlyOwner public {
580         require(end>now);
581         endTimestamp = end;
582     }
583     function setStartTimeStamp(uint256 start) onlyOwner public {
584         startTimestamp = start;
585     }
586     function pauseTrading() onlyOwner public{
587         token.pause();
588     }
589     function startTrading() onlyOwner public{
590         token.unpause();
591     }
592     function smartBlockAddress(address toBeBlocked) onlyOwner public{
593         token.blockAddress(toBeBlocked);
594     }
595     function smartUnBlockAddress(address toBeUnblocked) onlyOwner public{
596         token.unBlockAddress(toBeUnblocked);
597     }
598     function changeTokenOwner(address newOwner) public onlyOwner {
599         require(hasEnded());
600         token.changeOwner(newOwner);
601     }
602     function bulkGrantTokenAdvisors(address [] beneficiaries,uint256 [] granttokencounts) public onlyOwner{
603       require( beneficiaries.length == granttokencounts.length);
604       for (uint256 i=0; i<beneficiaries.length; i++) {
605         grantTokensAdvisors(beneficiaries[i],granttokencounts[i]);
606       }
607     }
608     function bulkGrantTokenCommonPool(address [] beneficiaries,uint256 [] granttokencounts) public onlyOwner{
609       require( beneficiaries.length == granttokencounts.length);
610       for (uint256 i=0; i<beneficiaries.length; i++) {
611         grantTokensCommonPool(beneficiaries[i],granttokencounts[i]);
612       }
613     }
614 
615 }