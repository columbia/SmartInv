1 pragma solidity ^0.4.18;
2 
3  
4  /*
5  * NYX Token sale
6  *
7  * Supports ERC20, ERC223 stadards
8  *
9  * The NYX token is mintable during Token Sale. On Token Sale finalization it
10  * will be minted up to the cap and minting will be finished forever
11  */
12 
13 
14 pragma solidity ^0.4.18;
15 
16 
17 /*************************************************************************
18  * import "./include/MintableToken.sol" : start
19  *************************************************************************/
20 
21 /*************************************************************************
22  * import "zeppelin/contracts/token/StandardToken.sol" : start
23  *************************************************************************/
24 
25 
26 /*************************************************************************
27  * import "./BasicToken.sol" : start
28  *************************************************************************/
29 
30 
31 /*************************************************************************
32  * import "./ERC20Basic.sol" : start
33  *************************************************************************/
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) constant returns (uint256);
44   function transfer(address to, uint256 value) returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 /*************************************************************************
48  * import "./ERC20Basic.sol" : end
49  *************************************************************************/
50 /*************************************************************************
51  * import "../math/SafeMath.sol" : start
52  *************************************************************************/
53 
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal constant returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal constant returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 /*************************************************************************
85  * import "../math/SafeMath.sol" : end
86  *************************************************************************/
87 
88 
89 /**
90  * @title Basic token
91  * @dev Basic version of StandardToken, with no allowances. 
92  */
93 contract BasicToken is ERC20Basic {
94   using SafeMath for uint256;
95 
96   mapping(address => uint256) balances;
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) returns (bool) {
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of. 
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) constant returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 /*************************************************************************
121  * import "./BasicToken.sol" : end
122  *************************************************************************/
123 /*************************************************************************
124  * import "./ERC20.sol" : start
125  *************************************************************************/
126 
127 
128 
129 
130 
131 /**
132  * @title ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/20
134  */
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) constant returns (uint256);
137   function transferFrom(address from, address to, uint256 value) returns (bool);
138   function approve(address spender, uint256 value) returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 /*************************************************************************
142  * import "./ERC20.sol" : end
143  *************************************************************************/
144 
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amout of tokens to be transfered
163    */
164   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
165     var _allowance = allowed[_from][msg.sender];
166 
167     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168     // require (_value <= _allowance);
169 
170     balances[_to] = balances[_to].add(_value);
171     balances[_from] = balances[_from].sub(_value);
172     allowed[_from][msg.sender] = _allowance.sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) returns (bool) {
183 
184     // To change the approve amount you first have to reduce the addresses`
185     //  allowance to zero by calling `approve(_spender, 0)` if it is not
186     //  already 0 to mitigate the race condition described here:
187     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
189 
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifing the amount of tokens still avaible for the spender.
200    */
201   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
202     return allowed[_owner][_spender];
203   }
204 
205 }
206 /*************************************************************************
207  * import "zeppelin/contracts/token/StandardToken.sol" : end
208  *************************************************************************/
209 /*************************************************************************
210  * import "zeppelin/contracts/ownership/Ownable.sol" : start
211  *************************************************************************/
212 
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   function Ownable() {
228     owner = msg.sender;
229   }
230 
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240 
241   /**
242    * @dev Allows the current owner to transfer control of the contract to a newOwner.
243    * @param newOwner The address to transfer ownership to.
244    */
245   function transferOwnership(address newOwner) onlyOwner {
246     if (newOwner != address(0)) {
247       owner = newOwner;
248     }
249   }
250 
251 }
252 /*************************************************************************
253  * import "zeppelin/contracts/ownership/Ownable.sol" : end
254  *************************************************************************/
255 
256 /**
257  * Mintable token
258  */
259 
260 contract MintableToken is StandardToken, Ownable {
261     uint public totalSupply = 0;
262     address minter;
263 
264     modifier onlyMinter(){
265         require(minter == msg.sender);
266         _;
267     }
268 
269     function setMinter(address _minter) onlyOwner {
270         minter = _minter;
271     }
272 
273     function mint(address _to, uint _amount) onlyMinter {
274         totalSupply = totalSupply.add(_amount);
275         balances[_to] = balances[_to].add(_amount);
276         Transfer(address(0x0), _to, _amount);
277     }
278 }
279 /*************************************************************************
280  * import "./include/MintableToken.sol" : end
281  *************************************************************************/
282 /*************************************************************************
283  * import "./include/ERC23PayableToken.sol" : start
284  *************************************************************************/
285 
286 
287 
288 /*************************************************************************
289  * import "./ERC23.sol" : start
290  *************************************************************************/
291 
292 
293 
294 
295 /*
296  * ERC23
297  * ERC23 interface
298  * see https://github.com/ethereum/EIPs/issues/223
299  */
300 contract ERC23 is ERC20Basic {
301     function transfer(address to, uint value, bytes data);
302 
303     event TransferData(address indexed from, address indexed to, uint value, bytes data);
304 }
305 /*************************************************************************
306  * import "./ERC23.sol" : end
307  *************************************************************************/
308 /*************************************************************************
309  * import "./ERC23PayableReceiver.sol" : start
310  *************************************************************************/
311 
312 /*
313 * Contract that is working with ERC223 tokens
314 */
315 
316 contract ERC23PayableReceiver {
317     function tokenFallback(address _from, uint _value, bytes _data) payable;
318 }
319 
320 /*************************************************************************
321  * import "./ERC23PayableReceiver.sol" : end
322  *************************************************************************/
323 
324 /**  https://github.com/Dexaran/ERC23-tokens/blob/master/token/ERC223/ERC223BasicToken.sol
325  *
326  */
327 contract ERC23PayableToken is BasicToken, ERC23{
328     // Function that is called when a user or another contract wants to transfer funds .
329     function transfer(address to, uint value, bytes data){
330         transferAndPay(to, value, data);
331     }
332 
333     // Standard function transfer similar to ERC20 transfer with no _data .
334     // Added due to backwards compatibility reasons .
335     function transfer(address to, uint value) returns (bool){
336         bytes memory empty;
337         transfer(to, value, empty);
338         return true;
339     }
340 
341     function transferAndPay(address to, uint value, bytes data) payable {
342 
343         uint codeLength;
344 
345         assembly {
346             // Retrieve the size of the code on target address, this needs assembly .
347             codeLength := extcodesize(to)
348         }
349 
350         balances[msg.sender] = balances[msg.sender].sub(value);
351         balances[to] = balances[to].add(value);
352 
353         if(codeLength>0) {
354             ERC23PayableReceiver receiver = ERC23PayableReceiver(to);
355             receiver.tokenFallback.value(msg.value)(msg.sender, value, data);
356         }else if(msg.value > 0){
357             to.transfer(msg.value);
358         }
359 
360         Transfer(msg.sender, to, value);
361         if(data.length > 0)
362             TransferData(msg.sender, to, value, data);
363     }
364 }
365 /*************************************************************************
366  * import "./include/ERC23PayableToken.sol" : end
367  *************************************************************************/
368 
369 
370 contract NYXToken is MintableToken, ERC23PayableToken {
371     string public constant name = "NYX Token";
372     string public constant symbol = "NYX";
373 
374     bool public transferEnabled = true;
375 
376     //The cap is 15 mln NYX
377     uint private constant CAP = 15*(10**6);
378 
379     function mint(address _to, uint _amount){
380         require(totalSupply.add(_amount) <= CAP);
381         super.mint(_to, _amount);
382     }
383 
384     function NYXToken(address team) {
385         //Transfer ownership on the token to team on creation
386         transferOwnership(team);
387         // minter is the TokenSale contract
388         minter = msg.sender; 
389         /// Preserve 3 000 000 tokens for the team
390         mint(team, 3000000);
391     }
392 
393     /**
394     * Overriding all transfers to check if transfers are enabled
395     */
396     function transferAndPay(address to, uint value, bytes data) payable{
397         require(transferEnabled);
398         super.transferAndPay(to, value, data);
399     }
400 
401     function enableTransfer(bool enabled) onlyOwner{
402         transferEnabled = enabled;
403     }
404 
405 }
406 
407 contract TokenSale is Ownable {
408     using SafeMath for uint;
409 
410     // Constants
411     // =========
412     uint private constant millions = 1e6;
413 
414     uint private constant CAP = 15*millions;
415     uint private constant SALE_CAP = 12*millions;
416     uint private constant SOFT_CAP = 1400000;
417     
418     // Allocated for the team upon contract creation
419     // =========
420     uint private constant TEAM_CAP = 3000000;
421 
422     uint public price = 0.001 ether;
423     
424     // Hold investor's ether amounts to refund
425     address[] contributors;
426     mapping(address => uint) contributions;
427 
428     // Events
429     // ======
430 
431     event AltBuy(address holder, uint tokens, string txHash);
432     event Buy(address holder, uint tokens);
433     event RunSale();
434     event PauseSale();
435     event FinishSale();
436     event PriceSet(uint weiPerNYX);
437 
438     // State variables
439     // ===============
440     bool public presale = true;
441     NYXToken public token;
442     address authority; //An account to control the contract on behalf of the owner
443     address robot; //An account to purchase tokens for altcoins
444     bool public isOpen = true;
445 
446     // Constructor
447     // ===========
448 
449     function TokenSale(){
450         token = new NYXToken(msg.sender);
451 
452         authority = msg.sender;
453         robot = msg.sender;
454         transferOwnership(msg.sender);
455     }
456 
457     // Public functions
458     // ================
459     function togglePresale(bool activate) onlyAuthority {
460         presale = activate;
461     }
462 
463 
464     function getCurrentPrice() constant returns(uint) {
465         if(presale) {
466             return price - (price*20/100);
467         }
468         return price;
469     }
470     /**
471     * Computes number of tokens with bonus for the specified ether. Correctly
472     * adds bonuses if the sum is large enough to belong to several bonus intervals
473     */
474     function getTokensAmount(uint etherVal) constant returns (uint) {
475         uint tokens = 0;
476         tokens += etherVal/getCurrentPrice();
477         return tokens;
478     }
479 
480     function buy(address to) onlyOpen payable{
481         uint amount = msg.value;
482         uint tokens = getTokensAmountUnderCap(amount);
483         
484         // owner.transfer(amount);
485 
486 		token.mint(to, tokens);
487 		
488 		uint alreadyContributed = contributions[to];
489 		if(alreadyContributed == 0) // new contributor
490 		    contributors.push(to);
491 		    
492 		contributions[to] = contributions[to].add(msg.value);
493 
494         Buy(to, tokens);
495     }
496 
497     function () payable{
498         buy(msg.sender);
499     }
500 
501     // Modifiers
502     // =================
503 
504     modifier onlyAuthority() {
505         require(msg.sender == authority || msg.sender == owner);
506         _;
507     }
508 
509     modifier onlyRobot() {
510         require(msg.sender == robot);
511         _;
512     }
513 
514     modifier onlyOpen() {
515         require(isOpen);
516         _;
517     }
518 
519     // Priveleged functions
520     // ====================
521 
522     /**
523     * Used to buy tokens for altcoins.
524     * Robot may call it before TokenSale officially starts to migrate early investors
525     */
526     function buyAlt(address to, uint etherAmount, string _txHash) onlyRobot {
527         uint tokens = getTokensAmountUnderCap(etherAmount);
528         token.mint(to, tokens);
529         AltBuy(to, tokens, _txHash);
530     }
531 
532     function setAuthority(address _authority) onlyOwner {
533         authority = _authority;
534     }
535 
536     function setRobot(address _robot) onlyAuthority {
537         robot = _robot;
538     }
539 
540     function setPrice(uint etherPerNYX) onlyAuthority {
541         price = etherPerNYX;
542         PriceSet(price);
543     }
544 
545     // SALE state management: start / pause / finalize
546     // --------------------------------------------
547     function open(bool opn) onlyAuthority {
548         isOpen = opn;
549         opn ? RunSale() : PauseSale();
550     }
551     
552     function finalizePresale() onlyAuthority {
553         // Check for SOFT_CAP
554         require(token.totalSupply() > SOFT_CAP + TEAM_CAP);
555         // Transfer collected softcap to the team
556         owner.transfer(this.balance);
557     }
558 
559     function finalize() onlyAuthority {
560         // Check for SOFT_CAP
561         if(token.totalSupply() < SOFT_CAP + TEAM_CAP) { // Soft cap is not reached, return all contributions to investors
562             uint x = 0;
563             while(x < contributors.length) {
564                 uint amountToReturn = contributions[contributors[x]];
565                 contributors[x].transfer(amountToReturn);
566                 x++;
567             }
568         }
569         
570         uint diff = CAP.sub(token.totalSupply());
571         if(diff > 0) //The unsold capacity moves to team
572             token.mint(owner, diff);
573         selfdestruct(owner);
574         FinishSale();
575     }
576 
577     // Private functions
578     // =========================
579 
580     /**
581     * Gets tokens for specified ether provided that they are still under the cap
582     */
583     function getTokensAmountUnderCap(uint etherAmount) private constant returns (uint){
584         uint tokens = getTokensAmount(etherAmount);
585         require(tokens > 0);
586         require(tokens.add(token.totalSupply()) <= SALE_CAP);
587         return tokens;
588     }
589 
590 }