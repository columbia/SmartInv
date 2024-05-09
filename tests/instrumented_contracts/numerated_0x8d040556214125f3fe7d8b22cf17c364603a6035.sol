1 pragma solidity ^0.4.18;
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
14     function Ownable() public {
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
45     bool public paused = false;
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
67         Pause();
68         return true;
69     }
70 
71     /**
72      * @dev called by the owner to unpause, returns to normal state
73      */
74     function unpause() public onlyOwner whenPaused returns (bool) {
75         paused = false;
76         Unpause();
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
147         Transfer(msg.sender, _to, _value);
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
175         var _allowance = allowed[_from][msg.sender];
176 
177         balances[_to] = balances[_to].add(_value);
178         balances[_from] = balances[_from].sub(_value);
179         allowed[_from][msg.sender] = _allowance.sub(_value);
180         Transfer(_from, _to, _value);
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
198         Approval(msg.sender, _spender, _value);
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
240         Transfer(0X0, _to, _amount);
241         return true;
242     }
243 
244     /**
245      * @dev Function to stop minting new tokens.
246      * @return True if the operation was successful.
247      */
248     function finishMinting() public onlyOwner returns (bool) {
249         mintingFinished = true;
250         MintFinished();
251         return true;
252     }
253 }
254 
255 contract StrikeCoin is MintableToken, Pausable{
256     string public name = "StrikeCoin Token";
257     string public symbol = "STC";
258     uint256 public decimals = 18;
259 
260     event Ev(string message, address whom, uint256 val);
261 
262     struct XRec {
263         bool inList;
264         address next;
265         address prev;
266         uint256 val;
267     }
268 
269     struct QueueRecord {
270         address whom;
271         uint256 val;
272     }
273 
274     address first = 0x0;
275     address last = 0x0;
276 
277     mapping (address => XRec) public theList;
278 
279     QueueRecord[]  theQueue;
280 
281     // add a record to the END of the list
282     function add(address whom, uint256 value) internal {
283         theList[whom] = XRec(true,0x0,last,value);
284         if (last != 0x0) {
285             theList[last].next = whom;
286         } else {
287             first = whom;
288         }
289         last = whom;
290         Ev("add",whom,value);
291     }
292 
293     function remove(address whom) internal {
294         if (first == whom) {
295             first = theList[whom].next;
296             theList[whom] = XRec(false,0x0,0x0,0);
297             return;
298         }
299         address next = theList[whom].next;
300         address prev = theList[whom].prev;
301         if (prev != 0x0) {
302             theList[prev].next = next;
303         }
304         if (next != 0x0) {
305             theList[next].prev = prev;
306         }
307         theList[whom] =XRec(false,0x0,0x0,0);
308         Ev("remove",whom,0);
309     }
310 
311     function update(address whom, uint256 value) internal {
312         if (value != 0) {
313             if (!theList[whom].inList) {
314                 add(whom,value);
315             } else {
316                 theList[whom].val = value;
317                 Ev("update",whom,value);
318             }
319             return;
320         }
321         if (theList[whom].inList) {
322             remove(whom);
323         }
324     }
325 
326     /**
327      * @dev Allows anyone to transfer the Strike tokens once trading has started
328      * @param _to the recipient address of the tokens.
329      * @param _value number of tokens to be transfered.
330      */
331     function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
332         bool result = super.transfer(_to, _value);
333         update(msg.sender,balances[msg.sender]);
334         update(_to,balances[_to]);
335         return result;
336     }
337 
338     /**
339      * @dev Allows anyone to transfer the Strike tokens once trading has started
340      * @param _from address The address which you want to send tokens from
341      * @param _to address The address which you want to transfer to
342      * @param _value uint the amout of tokens to be transfered
343      */
344     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
345         bool result = super.transferFrom(_from, _to, _value);
346         update(_from,balances[_from]);
347         update(_to,balances[_to]);
348         return result;
349     }
350 
351     /**
352      * @dev Function to mint tokens
353      * @param _to The address that will recieve the minted tokens.
354      * @param _amount The amount of tokens to mint.
355      * @return A boolean that indicates if the operation was successful.
356      */
357 
358     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
359         bool result = super.mint(_to,_amount);
360         update(_to,balances[_to]);
361         return result;
362     }
363 
364     function StrikeCoin()  public{
365         owner = msg.sender;
366     }
367 
368     function changeOwner(address newOwner) public onlyOwner {
369         owner = newOwner;
370     }
371 }
372 
373 contract StrikeCoinCrowdsale is Ownable, Pausable {
374     using SafeMath for uint256;
375 
376     StrikeCoin public token = new StrikeCoin();
377 
378     // start and end times
379     uint256 public startTimestamp = 1516773600;
380     uint256 public endTimestamp = 1519452000;
381     uint256 etherToWei = 10**18;
382 
383     // address where funds are collected and tokens distributed
384     address public hardwareWallet = 0xb0c7fc7fFe80867A5Bd2e31e43d4D494085321B3;
385     address public restrictedWallet = 0xD36AA5Eaf6B1D6eC896E4A110501a872773a0125;
386     address public bonusWallet = 0xb9325bd27e91D793470F84e9B3550596d34Bbe26;
387 
388     mapping (address => uint256) public deposits;
389     uint256 public numberOfPurchasers;
390 
391     // how many bonus tokens given in ICO
392     uint[] private bonus = [8,8,4,4,2,2,0,0,0,0];
393     uint256 public rate = 2400; // 2400 STC is one Ether
394 
395     // amount of raised money in wei
396     uint256 public weiRaised;
397     uint256 public tokensSold;
398     uint256 public tokensGranted = 0;
399 
400     uint256 public minContribution = 1 finney;
401     uint256 public hardCapEther = 50000;
402     uint256 hardcap = hardCapEther * etherToWei;
403     uint256 maxBonusRate = 20;  // Percent;
404 
405     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
406     event MainSaleClosed();
407 
408     uint256 public weiRaisedInPresale  = 0 ether;
409     uint256 public grantedTokensHardCap ;
410 
411 
412     function setWallet(address _wallet) public onlyOwner {
413         require(_wallet != 0x0);
414         hardwareWallet = _wallet;
415     }
416 
417     function setRestrictedWallet(address _restrictedWallet) public onlyOwner {
418         require(_restrictedWallet != 0x0);
419         restrictedWallet = _restrictedWallet;
420     }
421 
422     function setHardCapEther(uint256 newEtherAmt) public onlyOwner{
423         require(newEtherAmt > 0);
424         hardCapEther = newEtherAmt;
425         hardcap = hardCapEther * etherToWei;
426         grantedTokensHardCap = etherToWei * hardCapEther*rate*40/60*(maxBonusRate+100)/100;
427     }
428 
429     function StrikeCoinCrowdsale() public  {
430 
431         grantedTokensHardCap = etherToWei * hardCapEther*rate*40/60*(maxBonusRate+100)/100;
432         require(startTimestamp >= now);
433         require(endTimestamp >= startTimestamp);
434     }
435 
436     // check if valid purchase
437     modifier validPurchase {
438         require(now >= startTimestamp);
439         require(now < endTimestamp);
440         require(msg.value >= minContribution);
441         _;
442     }
443 
444     // @return true if crowdsale event has ended
445     function hasEnded() public constant returns (bool) {
446         if (now > endTimestamp)
447             return true;
448         return false;
449     }
450 
451     // low level token purchase function
452     function buyTokens(address beneficiary) public payable   validPurchase {
453         require(beneficiary != 0x0);
454 
455         uint256 weiAmount = msg.value;
456 
457         if (deposits[msg.sender] == 0) {
458             numberOfPurchasers++;
459         }
460         deposits[msg.sender] = weiAmount.add(deposits[msg.sender]);
461 
462         uint256 daysInSale = (now - startTimestamp) / (1 days);
463         uint256 thisBonus = 0;
464         if(daysInSale < 7 ){
465             thisBonus = bonus[daysInSale];
466         }
467 
468         // calculate token amount to be created
469         uint256 tokens = weiAmount.mul(rate);
470         uint256 extraBonus = tokens.mul(thisBonus);
471         extraBonus = extraBonus.div(100);
472         uint256 finalTokenCount ;
473         tokens = tokens.add(extraBonus);
474         finalTokenCount = tokens.add(tokensSold);
475         uint256 weiRaisedSoFar = weiRaised.add(weiAmount);
476         require(weiRaisedSoFar + weiRaisedInPresale <= hardcap);
477 
478         weiRaised = weiRaisedSoFar;
479         tokensSold = finalTokenCount;
480 
481         token.mint(beneficiary, tokens);
482         hardwareWallet.transfer(msg.value);
483         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
484     }
485 
486     function grantTokens(address beneficiary,uint256 stcTokenCount) public onlyOwner{
487         stcTokenCount = stcTokenCount * etherToWei;
488         uint256 finalGrantedTokenCount = tokensGranted.add(stcTokenCount);
489         require(finalGrantedTokenCount<grantedTokensHardCap);
490         tokensGranted = finalGrantedTokenCount;
491         token.mint(beneficiary,stcTokenCount);
492     }
493     // finish mining coins and transfer ownership of Change coin to owner
494     function finishMinting() public onlyOwner returns(bool){
495         require(hasEnded());
496 
497         // Create the bonus tokens (20% * 2400 * ETH collected) - extra tokens made from the 5%, 4%
498         uint256 deltaBonusTokens = tokensSold-weiRaised*rate;
499         uint256 bonusTokens = weiRaised*maxBonusRate*rate/100-deltaBonusTokens;
500 
501         // tokensSold  and weiRaised
502         token.mint(bonusWallet,bonusTokens);
503 
504         // Create the preico tokens (3000 * ETH collected)
505         uint256 preICOTokens = weiRaisedInPresale*3000;
506         token.mint(bonusWallet,preICOTokens);
507 
508         uint issuedTokenSupply = token.totalSupply();
509 
510         uint restrictedTokens = (issuedTokenSupply-tokensGranted)*40/60-tokensGranted; // 40% are for advisors
511 
512         if(restrictedTokens>0){
513             token.mint(restrictedWallet, restrictedTokens);
514             tokensGranted = tokensGranted + restrictedTokens;
515         }
516         token.finishMinting();
517         token.transferOwnership(owner);
518         MainSaleClosed();
519         return true;
520     }
521 
522     // fallback function can be used to buy tokens
523     function () payable public {
524         buyTokens(msg.sender);
525     }
526 
527     function setWeiRaisedInPresale(uint256 amount) onlyOwner public {
528         require(amount>=0);
529         weiRaisedInPresale = amount;
530     }
531     function setEndTimeStamp(uint256 end) onlyOwner public {
532         require(end>now);
533         endTimestamp = end;
534     }
535     function setStartTimeStamp(uint256 start) onlyOwner public {
536         startTimestamp = start;
537     }
538     function setBonusAddress(address _bonusWallet) onlyOwner public {
539         require(_bonusWallet != 0x0);
540         bonusWallet = _bonusWallet;
541     }
542     function pauseTrading() onlyOwner public{
543         token.pause();
544     }
545     function startTrading() onlyOwner public{
546         token.unpause();
547     }
548 
549     function changeTokenOwner(address newOwner) public onlyOwner {
550         require(hasEnded());
551         token.changeOwner(newOwner);
552     }
553 }