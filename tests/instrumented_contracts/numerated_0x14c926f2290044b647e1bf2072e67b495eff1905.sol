1 /*
2 --------------------------------------------------------------------------------
3 The Bethereum [BETHER] Token Smart Contract
4 
5 Credit:
6 Bethereum Limited
7 
8 ERC20: https://github.com/ethereum/EIPs/issues/20
9 ERC223: https://github.com/ethereum/EIPs/issues/223
10 
11 MIT Licence
12 --------------------------------------------------------------------------------
13 */
14 
15 /*
16 * Contract that is working with ERC223 tokens
17 */
18 
19 contract ContractReceiver {
20     function tokenFallback(address _from, uint _value, bytes _data) {
21         /* Fix for Mist warning */
22         _from;
23         _value;
24         _data;
25     }
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34         uint256 c = a * b;
35         assert(a == 0 || c / a == b);
36         return c;
37     }
38 
39     function div(uint256 a, uint256 b) internal constant returns (uint256) {
40         // assert(b > 0); // Solidity automatically throws when dividing by 0
41         uint256 c = a / b;
42         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47         assert(b <= a);
48         return a - b;
49     }
50 
51     function add(uint256 a, uint256 b) internal constant returns (uint256) {
52         uint256 c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64     address public owner;
65 
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     function Ownable() {
75         owner = msg.sender;
76     }
77 
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(msg.sender == owner);
84         _;
85     }
86 
87 
88     /**
89      * @dev Allows the current owner to transfer control of the contract to a newOwner.
90      * @param newOwner The address to transfer ownership to.
91      */
92     function transferOwnership(address newOwner) onlyOwner public {
93         require(newOwner != address(0));
94         OwnershipTransferred(owner, newOwner);
95         owner = newOwner;
96     }
97 
98 }
99 
100 contract ERC223Interface {
101     uint public totalSupply;
102     function balanceOf(address who) constant returns (uint);
103     event Transfer(address indexed from, address indexed to, uint value, bytes data);
104 }
105 
106 
107 contract BethereumERC223 is ERC223Interface {
108     using SafeMath for uint256;
109 
110     /* Contract Constants */
111     string public constant _name = "Bethereum";
112     string public constant _symbol = "BETHER";
113     uint8 public constant _decimals = 18;
114 
115     /* Contract Variables */
116     address public owner;
117     mapping(address => uint256) public balances;
118     mapping(address => mapping (address => uint256)) public allowed;
119 
120     /* Constructor initializes the owner's balance and the supply  */
121     function BethereumERC223() {
122         owner = msg.sender;
123     }
124 
125     /* ERC20 Events */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     event Approval(address indexed from, address indexed to, uint256 value);
128 
129     /* ERC223 Events */
130     event Transfer(address indexed from, address indexed to, uint value, bytes data);
131 
132     /* Returns the balance of a particular account */
133     function balanceOf(address _address) constant returns (uint256 balance) {
134         return balances[_address];
135     }
136 
137     /* Transfer the balance from the sender's address to the address _to */
138     function transfer(address _to, uint _value) returns (bool success) {
139         if (balances[msg.sender] >= _value
140         && _value > 0
141         && balances[_to] + _value > balances[_to]) {
142             bytes memory empty;
143             if(isContract(_to)) {
144                 return transferToContract(_to, _value, empty);
145             } else {
146                 return transferToAddress(_to, _value, empty);
147             }
148         } else {
149             return false;
150         }
151     }
152 
153     /* Withdraws to address _to form the address _from up to the amount _value */
154     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
155         if (balances[_from] >= _value
156         && allowed[_from][msg.sender] >= _value
157         && _value > 0
158         && balances[_to] + _value > balances[_to]) {
159             balances[_from] -= _value;
160             allowed[_from][msg.sender] -= _value;
161             balances[_to] += _value;
162             Transfer(_from, _to, _value);
163             return true;
164         } else {
165             return false;
166         }
167     }
168 
169     /* Allows _spender to withdraw the _allowance amount form sender */
170     function approve(address _spender, uint256 _allowance) returns (bool success) {
171         allowed[msg.sender][_spender] = _allowance;
172         Approval(msg.sender, _spender, _allowance);
173         return true;
174     }
175 
176     /* Checks how much _spender can withdraw from _owner */
177     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
178         return allowed[_owner][_spender];
179     }
180 
181     /* ERC223 Functions */
182     /* Get the contract constant _name */
183     function name() constant returns (string name) {
184         return _name;
185     }
186 
187     /* Get the contract constant _symbol */
188     function symbol() constant returns (string symbol) {
189         return _symbol;
190     }
191 
192     /* Get the contract constant _decimals */
193     function decimals() constant returns (uint8 decimals) {
194         return _decimals;
195     }
196 
197     /* Transfer the balance from the sender's address to the address _to with data _data */
198     function transfer(address _to, uint _value, bytes _data) returns (bool success) {
199         if (balances[msg.sender] >= _value
200         && _value > 0
201         && balances[_to] + _value > balances[_to]) {
202             if(isContract(_to)) {
203                 return transferToContract(_to, _value, _data);
204             } else {
205                 return transferToAddress(_to, _value, _data);
206             }
207         } else {
208             return false;
209         }
210     }
211 
212     /* Transfer function when _to represents a regular address */
213     function transferToAddress(address _to, uint _value, bytes _data) internal returns (bool success) {
214         balances[msg.sender] -= _value;
215         balances[_to] += _value;
216         Transfer(msg.sender, _to, _value);
217         Transfer(msg.sender, _to, _value, _data);
218         return true;
219     }
220 
221     /* Transfer function when _to represents a contract address, with the caveat
222     that the contract needs to implement the tokenFallback function in order to receive tokens */
223     function transferToContract(address _to, uint _value, bytes _data) internal returns (bool success) {
224         balances[msg.sender] -= _value;
225         balances[_to] += _value;
226         ContractReceiver receiver = ContractReceiver(_to);
227         receiver.tokenFallback(msg.sender, _value, _data);
228         Transfer(msg.sender, _to, _value);
229         Transfer(msg.sender, _to, _value, _data);
230         return true;
231     }
232 
233     /* Infers if whether _address is a contract based on the presence of bytecode */
234     function isContract(address _address) internal returns (bool is_contract) {
235         uint length;
236         if (_address == 0) return false;
237         assembly {
238         length := extcodesize(_address)
239         }
240         if(length > 0) {
241             return true;
242         } else {
243             return false;
244         }
245     }
246 
247     /* Stops any attempt to send Ether to this contract */
248     function () {
249         throw;
250     }
251 }
252 
253 /**
254  * @title Pausable
255  * @dev Base contract which allows children to implement an emergency stop mechanism.
256  */
257 contract Pausable is Ownable {
258     event Pause();
259     event Unpause();
260 
261     bool public paused = false;
262 
263 
264     /**
265      * @dev Modifier to make a function callable only when the contract is not paused.
266      */
267     modifier whenNotPaused() {
268         require(!paused);
269         _;
270     }
271 
272     /**
273      * @dev Modifier to make a function callable only when the contract is paused.
274      */
275     modifier whenPaused() {
276         require(paused);
277         _;
278     }
279 
280     /**
281      * @dev called by the owner to pause, triggers stopped state
282      */
283     function pause() onlyOwner whenNotPaused public {
284         paused = true;
285         Pause();
286     }
287 
288     /**
289      * @dev called by the owner to unpause, returns to normal state
290      */
291     function unpause() onlyOwner whenPaused public {
292         paused = false;
293         Unpause();
294     }
295 }
296 
297 /**
298 * @title Pausable token
299 *
300 * @dev StandardToken modified with pausable transfers.
301 **/
302 contract PausableToken is BethereumERC223, Pausable {
303 
304     function transfer(address _to, uint256 _value, bytes _data) public whenNotPaused returns (bool) {
305         return super.transfer(_to, _value, _data);
306     }
307 
308     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
309         return super.transferFrom(_from, _to, _value);
310     }
311 
312     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
313         return super.approve(_spender, _value);
314     }
315 
316 }
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 contract MintableToken is BethereumERC223, Ownable {
325     event Mint(address indexed to, uint256 amount);
326     event MintFinished();
327 
328     bool public mintingFinished = false;
329 
330 
331     modifier canMint() {
332         require(!mintingFinished);
333         _;
334     }
335 
336     /**
337      * @dev Function to mint tokens
338      * @param _to The address that will receive the minted tokens.
339      * @param _amount The amount of tokens to mint.
340      * @return A boolean that indicates if the operation was successful.
341      */
342     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
343         totalSupply = totalSupply.add(_amount);
344         balances[_to] = balances[_to].add(_amount);
345         Mint(_to, _amount);
346         Transfer(address(0), _to, _amount);
347         return true;
348     }
349 
350     /**
351      * @dev Function to stop minting new tokens.
352      * @return True if the operation was successful.
353      */
354     function finishMinting() onlyOwner canMint public returns (bool) {
355         mintingFinished = true;
356         MintFinished();
357         return true;
358     }
359 }
360 
361 contract BethereumToken is MintableToken, PausableToken {
362 
363     function BethereumToken(){
364         pause();
365     }
366 
367 }
368 
369 /**
370  * @title Crowdsale
371  * @dev Crowdsale is a base contract for managing a token crowdsale.
372  * Crowdsales have a start and end timestamps, where investors can make
373  * token purchases and the crowdsale will assign them tokens based
374  * on a token per ETH rate. Funds collected are forwarded to a wallet
375  * as they arrive.
376  */
377 contract Crowdsale {
378     using SafeMath for uint256;
379 
380     // The token being sold
381     MintableToken public token;
382 
383     // start and end timestamps where investments are allowed (both inclusive)
384     uint256 public startTime;
385     uint256 public endTime;
386 
387     // address where funds are collected
388     address public wallet;
389 
390     // amount of raised money in wei
391     uint256 public weiRaised;
392 
393     /**
394      * event for token purchase logging
395      * @param purchaser who paid for the tokens
396      * @param beneficiary who got the tokens
397      * @param value weis paid for purchase
398      * @param amount amount of tokens purchased
399      */
400     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
401 
402 
403     function Crowdsale(uint256 _endTime, address _wallet) {
404 
405         require(_endTime >= now);
406         require(_wallet != 0x0);
407 
408         token = createTokenContract();
409         endTime = _endTime;
410         wallet = _wallet;
411     }
412 
413     // creates the token to be sold.
414     // override this method to have crowdsale of a specific mintable token.
415     function createTokenContract() internal returns (BethereumToken) {
416         return new BethereumToken();
417     }
418 
419 
420     // fallback function can be used to buy tokens
421     function () payable {
422         buyTokens(msg.sender);
423     }
424 
425     // low level token purchase function
426     function buyTokens(address beneficiary) public payable {  }
427 
428     // send ether to the fund collection wallet
429     // override to create custom fund forwarding mechanisms
430     function forwardFunds() internal {
431         wallet.transfer(msg.value);
432     }
433 
434     // @return true if the transaction can buy tokens
435     function validPurchase() internal constant returns (bool) {
436         bool withinPeriod = now >= startTime && now <= endTime;
437         bool nonZeroPurchase = msg.value != 0;
438         return withinPeriod && nonZeroPurchase;
439     }
440 
441     // @return true if crowdsale event has ended
442     function hasEnded() public constant returns (bool) {
443         return now > endTime;
444     }
445 }
446 
447 /**
448  * @title FinalizableCrowdsale
449  * @dev Extension of Crowdsale where an owner can do extra work
450  * after finishing.
451  */
452 contract FinalizableCrowdsale is Crowdsale, Ownable {
453     using SafeMath for uint256;
454 
455     bool public isFinalized = false;
456 
457     bool public weiCapReached = false;
458 
459     event Finalized();
460 
461     /**
462      * @dev Must be called after crowdsale ends, to do some extra finalization
463      * work. Calls the contract's finalization function.
464      */
465     function finalize() onlyOwner public {
466         require(!isFinalized);
467 
468         finalization();
469         Finalized();
470 
471         isFinalized = true;
472     }
473 
474     /**
475      * @dev Can be overridden to add finalization logic. The overriding function
476      * should call super.finalization() to ensure the chain of finalization is
477      * executed entirely.
478      */
479     function finalization() internal {
480     }
481 }
482 
483 contract BETHERTokenSale is FinalizableCrowdsale {
484     using SafeMath for uint256;
485 
486     // Define sale
487     uint public constant RATE = 17500;
488     uint public constant TOKEN_SALE_LIMIT = 25000 * 1000000000000000000;
489 
490     uint256 public constant TOKENS_FOR_OPERATIONS = 400000000*(10**18);
491     uint256 public constant TOKENS_FOR_SALE = 600000000*(10**18);
492 
493     uint public constant TOKENS_FOR_PRESALE = 315000000*(1 ether / 1 wei);
494 
495     uint public BONUS_PERCENTAGE;
496 
497     enum Phase {
498     Created,
499     CrowdsaleRunning,
500     Paused
501     }
502 
503     Phase public currentPhase = Phase.Created;
504 
505     event LogPhaseSwitch(Phase phase);
506 
507     // Constructor
508     function BETHERTokenSale(
509     uint256 _end,
510     address _wallet
511     )
512     FinalizableCrowdsale()
513     Crowdsale(_end, _wallet) {
514     }
515 
516     function setNewBonusScheme(uint _bonusPercentage) {
517         BONUS_PERCENTAGE = _bonusPercentage;
518     }
519 
520     function mintRawTokens(address _buyer, uint256 _newTokens) public onlyOwner {
521         token.mint(_buyer, _newTokens);
522     }
523 
524     /// @dev Lets buy you some tokens.
525     function buyTokens(address _buyer) public payable {
526         // Available only if presale or crowdsale is running.
527         require(currentPhase == Phase.CrowdsaleRunning);
528         require(_buyer != address(0));
529         require(msg.value > 0);
530         require(validPurchase());
531 
532         uint tokensWouldAddTo = 0;
533         uint weiWouldAddTo = 0;
534 
535         uint256 weiAmount = msg.value;
536 
537         uint newTokens = msg.value.mul(RATE);
538 
539         weiWouldAddTo = weiRaised.add(weiAmount);
540 
541         require(weiWouldAddTo <= TOKEN_SALE_LIMIT);
542 
543         newTokens = addBonusTokens(token.totalSupply(), newTokens);
544 
545         tokensWouldAddTo = newTokens.add(token.totalSupply());
546         require(tokensWouldAddTo <= TOKENS_FOR_SALE);
547 
548         token.mint(_buyer, newTokens);
549         TokenPurchase(msg.sender, _buyer, weiAmount, newTokens);
550 
551         weiRaised = weiWouldAddTo;
552         forwardFunds();
553         if (weiRaised == TOKENS_FOR_SALE){
554             weiCapReached = true;
555         }
556     }
557 
558     // @dev Adds bonus tokens by token supply bought by user
559     // @param _totalSupply total supply of token bought during pre-sale/crowdsale
560     // @param _newTokens tokens currently bought by user
561     function addBonusTokens(uint256 _totalSupply, uint256 _newTokens) internal view returns (uint256) {
562         uint returnTokens;
563         uint tokens = _newTokens;
564         returnTokens = tokens.add(tokens.mul(BONUS_PERCENTAGE).div(100));
565 
566         return returnTokens;
567     }
568 
569     function setSalePhase(Phase _nextPhase) public onlyOwner {
570         currentPhase = _nextPhase;
571         LogPhaseSwitch(_nextPhase);
572     }
573 
574     function transferTokenOwnership(address _newOwner) {
575         token.transferOwnership(_newOwner);
576     }
577 
578     // Finalize
579     function finalization() internal {
580         uint256 toMint = TOKENS_FOR_OPERATIONS;
581         token.mint(wallet, toMint);
582         token.finishMinting();
583         token.transferOwnership(wallet);
584     }
585 }