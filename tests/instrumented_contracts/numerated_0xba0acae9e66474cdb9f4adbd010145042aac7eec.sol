1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24     modifier onlyOwner(){
25         require(msg.sender == owner);
26         _;
27     }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33     function transferOwnership(address newOwner) onlyOwner public {
34         if (newOwner != address(0)) {
35             owner = newOwner;
36         }
37     }
38 }
39 
40 
41 /**
42  * @title Pausable
43  * @dev Base contract which allows children to implement an emergency stop mechanism.
44  */
45 contract Pausable is Ownable {
46     event Pause();
47     event Unpause();
48 
49     bool public paused = false;
50 
51 
52   /**
53    * @dev modifier to allow actions only when the contract IS paused
54    */
55     modifier whenNotPaused() {
56         require (!paused);
57         _;
58     }
59 
60   /**
61    * @dev modifier to allow actions only when the contract IS NOT paused
62    */
63     modifier whenPaused {
64         require (paused);
65         _;
66     }
67 
68   /**
69    * @dev called by the owner to pause, triggers stopped state
70    */
71     function pause() onlyOwner whenNotPaused  public returns (bool) {
72         paused = true;
73         Pause();
74         return true;
75     }
76 
77   /**
78    * @dev called by the owner to unpause, returns to normal state
79    */
80     function unpause() onlyOwner whenPaused public returns (bool) {
81         paused = false;
82         Unpause();
83         return true;
84     }
85 }
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92     uint256 public totalSupply;
93     function balanceOf(address who) public constant returns (uint256);
94     function transfer(address to, uint256 value) public returns (bool);
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public constant returns (uint256);
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105     function approve(address spender, uint256 value) public returns (bool);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a * b;
116         assert(a == 0 || c / a == b);
117         return c;
118     }
119 
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // assert(b > 0); // Solidity automatically throws when dividing by 0
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124         return c;
125     }
126 
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         assert(b <= a);
129         return a - b;
130     }
131 
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         assert(c >= a);
135         return c;
136     }
137 }
138 
139 /**
140  * @title Basic token
141  * @dev Basic version of StandardToken, with no allowances.
142  */
143 contract BasicToken is ERC20Basic {
144     using SafeMath for uint256;
145     mapping(address => uint256) balances;
146 
147   /**
148   * @dev transfer token for a specified address
149   * @param _to The address to transfer to.
150     * @param _value The amount to be transferred.
151    */
152     function transfer(address _to, uint256 _value) public returns (bool){
153         balances[msg.sender] = balances[msg.sender].sub(_value);
154         balances[_to] = balances[_to].add(_value);
155         Transfer(msg.sender, _to, _value);
156         return true;
157     }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163    */
164     function balanceOf(address _owner) public constant returns (uint256 balance) {
165         return balances[_owner];
166     }
167 }
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179     mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182    /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
189         require(_to != address(0));
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192 
193         balances[_from] = balances[_from].sub(_value);
194         balances[_to] = balances[_to].add(_value);
195         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196         Transfer(_from, _to, _value);
197         return true;
198     }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210     function approve(address _spender, uint256 _value) public returns (bool) {
211         allowed[msg.sender][_spender] = _value;
212         Approval(msg.sender, _spender, _value);
213         return true;
214     }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222     function allowance(address _owner, address _spender) public view returns (uint256) {
223         return allowed[_owner][_spender];
224     }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
237         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239         return true;
240     }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
253         uint oldValue = allowed[msg.sender][_spender];
254         if (_subtractedValue > oldValue) {
255             allowed[msg.sender][_spender] = 0;
256     } else {
257             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260         return true;
261     }
262 
263 }
264 
265 
266 /**
267  * @title Mintable token
268  * @dev Simple ERC20 Token example, with mintable token creation
269  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
270  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
271  */
272 
273 contract MintableToken is StandardToken, Ownable {
274     event Mint(address indexed to, uint256 amount);
275     event MintFinished();
276 
277     bool public mintingFinished = false;
278 
279     modifier canMint() {
280         require(!mintingFinished);
281         _;
282     }
283 
284   /**
285   * @dev Function to mint tokens
286   * @param _to The address that will recieve the minted tokens.
287     * @param _amount The amount of tokens to mint.
288     * @return A boolean that indicates if the operation was successful.
289    */
290     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291         totalSupply = totalSupply.add(_amount);
292         balances[_to] = balances[_to].add(_amount);
293         Transfer(0X0, _to, _amount);
294         return true;
295     }
296 
297   /**
298   * @dev Function to stop minting new tokens.
299   * @return True if the operation was successful.
300    */
301     function finishMinting() onlyOwner public returns (bool) {
302         mintingFinished = true;
303         MintFinished();
304         return true;
305     }
306 }
307 
308 contract ReporterToken is MintableToken, Pausable{
309     string public name = "Reporter Token";
310     string public symbol = "NEWS";
311     uint256 public decimals = 18;
312 
313     bool public tradingStarted = false;
314 
315   /**
316   * @dev modifier that throws if trading has not started yet
317    */
318     modifier hasStartedTrading() {
319         require(tradingStarted);
320         _;
321     }
322 
323   /**
324   * @dev Allows the owner to enable the trading. This can not be undone
325   */
326     function startTrading() public onlyOwner {
327         tradingStarted = true;
328     }
329 
330   /**
331    * @dev Allows anyone to transfer the Reporter tokens once trading has started
332    * @param _to the recipient address of the tokens.
333    * @param _value number of tokens to be transfered.
334    */
335     function transfer(address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
336         return super.transfer(_to, _value);
337     }
338 
339   /**
340   * @dev Allows anyone to transfer the Reporter tokens once trading has started
341   * @param _from address The address which you want to send tokens from
342   * @param _to address The address which you want to transfer to
343   * @param _value uint the amout of tokens to be transfered
344    */
345     function transferFrom(address _from, address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
346         return super.transferFrom(_from, _to, _value);
347     }
348 
349     function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
350         oddToken.transfer(owner, amount);
351     }
352 }
353 
354 contract ReporterTokenSale is Ownable, Pausable{
355     using SafeMath for uint256;
356 
357   // The token being sold
358     ReporterToken public token;
359 
360     uint256 public decimals;  
361     uint256 public oneCoin;
362 
363   // start and end block where investments are allowed (both inclusive)
364     uint256 public startTimestamp;
365     uint256 public endTimestamp;
366 
367   // address where funds are collected
368     address public multiSig;
369 
370     function setWallet(address _newWallet) public onlyOwner {
371         multiSig = _newWallet;
372     }
373 
374   // These will be set by setTier()
375     uint256 public rate; // how many token units a buyer gets per wei
376     uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
377     uint256 public maxContribution = 1000 ether;  // default limit to tokens that the users can buy
378 
379   // ***************************
380 
381   // amount of raised money in wei
382     uint256 public weiRaised;
383 
384   // amount of raised tokens 
385     uint256 public tokenRaised;
386 
387   // maximum amount of tokens being created
388     uint256 public maxTokens;
389 
390   // maximum amount of tokens for sale
391     uint256 public tokensForSale;  // 36 Million Tokens for SALE
392 
393   // number of participants in presale
394     uint256 public numberOfPurchasers = 0;
395 
396   //  for whitelist
397     address public cs;
398 
399  //  for rate
400     uint public r;
401 
402 
403   // switch on/off the authorisation , default: false
404     bool  public freeForAll = false;
405 
406     mapping (address => bool) public authorised; // just to annoy the heck out of americans
407     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
408     event SaleClosed();
409 
410     function ReporterTokenSale() public {
411         startTimestamp = 1508684400; // 22 Oct. 2017. 15:00 UTC
412         endTimestamp = 1529074800;   // (GMT): 2018. June 15., Friday 15:00:00
413         multiSig = 0xD00d085F125EAFEA9e8c5D3f4bc25e6D0c93Af0e;
414 
415         token = new ReporterToken();
416         decimals = token.decimals();
417         oneCoin = 10 ** decimals;
418         maxTokens = 60 * (10**6) * oneCoin;
419         tokensForSale = 36 * (10**6) * oneCoin;
420         rate = 3000;
421     }
422 
423     function currentTime() public constant returns (uint256) {
424         return now;
425     }
426   /**
427   * @dev Calculates the amount of bonus coins the buyer gets
428   */
429     function setTier(uint newR) internal {
430     // first 9M tokens get extra 42% of tokens, next half get 17%
431         if (tokenRaised <= 9000000 * oneCoin) {
432             rate = newR * 142/100;
433       //minContribution = 100 ether;
434       //maxContribution = 1000000 ether;
435     } else if (tokenRaised <= 18000000 * oneCoin) {
436         rate = newR * 117/100;
437       //minContribution = 5 ether;
438       //maxContribution = 1000000 ether;
439     } else {
440         rate = newR * 1;
441       //minContribution = 0.01 ether;
442       //maxContribution = 100 ether;
443     }
444     }
445 
446   // @return true if crowdsale event has ended
447     function hasEnded() public constant returns (bool) {
448         if (currentTime() > endTimestamp)
449       return true;
450         if (tokenRaised >= tokensForSale)
451       return true; // if we reach the tokensForSale
452         return false;
453     }
454 
455   /**
456   * @dev throws if person sending is not contract owner or cs role
457    */
458     modifier onlyCSorOwner() {
459         require((msg.sender == owner) || (msg.sender==cs));
460         _;
461     }
462     modifier onlyCS() {
463         require(msg.sender == cs);
464         _;
465     }
466 
467   /**
468   * @dev throws if person sending is not authorised or sends nothing
469   */
470     modifier onlyAuthorised() {
471         require (authorised[msg.sender] || freeForAll);
472         require (currentTime() >= startTimestamp);
473         require (!hasEnded());
474         require (multiSig != 0x0);
475         require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
476         _;
477     }
478 
479   /**
480   * @dev authorise an account to participate
481   */
482     function authoriseAccount(address whom) onlyCSorOwner public {
483         authorised[whom] = true;
484     }
485 
486   /**
487   * @dev authorise a lot of accounts in one go
488   */
489     function authoriseManyAccounts(address[] many) onlyCSorOwner public {
490         for (uint256 i = 0; i < many.length; i++) {
491             authorised[many[i]] = true;
492         }
493     }
494 
495   /**
496   * @dev ban an account from participation (default)
497   */
498     function blockAccount(address whom) onlyCSorOwner public {
499         authorised[whom] = false;
500     }  
501     
502   /**
503   * @dev set a new CS representative
504   */
505     function setCS(address newCS) onlyOwner public {
506         cs = newCS;
507     }
508 
509    /**
510   * @dev set a newRate if have a big different in ether/dollar rate 
511   */
512     function setRate(uint newRate) onlyCS public {
513         require(0 < newRate && newRate <= 8000); 
514         r = newRate;
515     }
516 
517 
518     function placeTokens(address beneficiary, uint256 _tokens) onlyCS public {
519     //check minimum and maximum amount
520         require(_tokens != 0);
521         require(!hasEnded());
522         uint256 amount = 0;
523         if (token.balanceOf(beneficiary) == 0) {
524             numberOfPurchasers++;
525         }
526         tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
527         token.mint(beneficiary, _tokens);
528         TokenPurchase(beneficiary, amount, _tokens);
529     }
530 
531   // low level token purchase function
532     function buyTokens(address beneficiary, uint256 amount) onlyAuthorised whenNotPaused internal {
533 
534         setTier(r);
535 
536     //check minimum and maximum amount
537         require(amount >= minContribution);
538         require(amount <= maxContribution);
539 
540     // calculate token amount to be created
541         uint256 tokens = amount.mul(rate);
542 
543     // update state
544         weiRaised = weiRaised.add(amount);
545         if (token.balanceOf(beneficiary) == 0) {
546             numberOfPurchasers++;
547       }
548         tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
549         token.mint(beneficiary, tokens);
550         TokenPurchase(beneficiary, amount, tokens);
551         multiSig.transfer(this.balance); // better in case any other ether ends up here
552     }
553 
554   // transfer ownership of the token to the owner of the presale contract
555     function finishSale() public onlyOwner {
556         require(hasEnded());
557 
558     // assign the rest of the 60M tokens to the reserve
559         uint unassigned;
560         if(maxTokens > tokenRaised) {
561             unassigned = maxTokens.sub(tokenRaised);
562             token.mint(multiSig,unassigned);
563     }
564         token.finishMinting();
565         token.transferOwnership(owner);
566         SaleClosed();
567     }
568 
569   // fallback function can be used to buy tokens
570     function () public payable {
571         buyTokens(msg.sender, msg.value);
572     }
573 
574     function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
575         oddToken.transfer(owner, amount);
576     }
577 }