1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30 
31     //Variables
32     address public owner;
33 
34     address public newOwner;
35 
36     //    Modifiers
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() public {
50         owner = msg.sender;
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param _newOwner The address to transfer ownership to.
56      */
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         require(_newOwner != address(0));
60         newOwner = _newOwner;
61     }
62 
63     function acceptOwnership() public {
64         if (msg.sender == newOwner) {
65             owner = newOwner;
66         }
67     }
68 }
69 
70 contract ERC20Basic {
71   uint256 public totalSupply;
72   function balanceOf(address who) public constant returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   event Transfer(address indexed from, address indexed to, uint256 value);
75 }
76 
77 contract BasicToken is ERC20Basic {
78     using SafeMath for uint256;
79 
80     mapping(address => uint256) balances;
81 
82     /**
83     * @dev transfer token for a specified address
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90 
91         // SafeMath.sub will throw if there is not enough balance.
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public constant returns (uint256 balance) {
104         return balances[_owner];
105     }
106 }
107 
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public constant returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * approve should be called when allowed[_spender] == 0. To increment
166    * allowed value is better to use this function to avoid 2 calls (and wait until
167    * the first transaction is mined)
168    * From MonolithDAO Token.sol
169    */
170   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
177     uint oldValue = allowed[msg.sender][_spender];
178     if (_subtractedValue > oldValue) {
179       allowed[msg.sender][_spender] = 0;
180     } else {
181       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
182     }
183     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 }
187 
188 contract MintableToken is StandardToken, Ownable {
189   event Mint(address indexed to, uint256 amount);
190   event MintFinished();
191 
192   bool public mintingFinished = false;
193 
194   modifier canMint() {
195     require(!mintingFinished);
196     _;
197   }
198 
199   /**
200    * @dev Function to mint tokens
201    * @param _to The address that will receive the minted tokens.
202    * @param _amount The amount of tokens to mint.
203    * @return A boolean that indicates if the operation was successful.
204    */
205   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
206     totalSupply = totalSupply.add(_amount);
207     balances[_to] = balances[_to].add(_amount);
208     Mint(_to, _amount);
209     Transfer(0x0, _to, _amount);
210     return true;
211   }
212 
213   /**
214    * @dev Function to stop minting new tokens.
215    * @return True if the operation was successful.
216    */
217   function finishMinting() onlyOwner public returns (bool) {
218     mintingFinished = true;
219     MintFinished();
220     return true;
221   }
222 }
223 
224 contract Crowdsale {
225   using SafeMath for uint256;
226 
227   // The token being sold
228   MintableToken public token;
229 
230   // start and end timestamps where investments are allowed (both inclusive)
231   uint256 public startTime;
232   uint256 public endTime;
233 
234   // address where funds are collected
235   address public wallet;
236 
237   // how many token units a buyer gets per wei
238   uint256 public rate;
239 
240   // amount of raised money in wei
241   uint256 public weiRaised;
242 
243   /**
244    * event for token purchase logging
245    * @param purchaser who paid for the tokens
246    * @param beneficiary who got the tokens
247    * @param value weis paid for purchase
248    * @param amount amount of tokens purchased
249    */
250   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
251 
252 
253   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
254     //require(_startTime >= now);
255     require(_endTime >= _startTime);
256     require(_rate > 0);
257     //require(_wallet != 0x0);
258 
259     token = createTokenContract();
260     startTime = _startTime;
261     endTime = _endTime;
262     rate = _rate;
263     wallet = _wallet;
264   }
265 
266   // creates the token to be sold.
267   // override this method to have crowdsale of a specific mintable token.
268   function createTokenContract() internal returns (MintableToken) {
269     return new MintableToken();
270   }
271 
272 
273   // fallback function can be used to buy tokens
274   function () payable {
275     buyTokens(msg.sender);
276   }
277 
278   // low level token purchase function
279   function buyTokens(address beneficiary) public payable {
280     require(beneficiary != 0x0);
281     require(validPurchase());
282 
283     uint256 weiAmount = msg.value;
284 
285     // calculate token amount to be created
286     uint256 tokens = weiAmount.mul(rate);
287 
288     // update state
289     weiRaised = weiRaised.add(weiAmount);
290 
291     token.mint(beneficiary, tokens);
292     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
293 
294     forwardFunds();
295   }
296 
297   // send ether to the fund collection wallet
298   // override to create custom fund forwarding mechanisms
299   function forwardFunds() internal {
300     wallet.transfer(msg.value);
301   }
302 
303   // @return true if the transaction can buy tokens
304   function validPurchase() internal constant returns (bool) {
305     bool withinPeriod = now >= startTime && now <= endTime;
306     bool nonZeroPurchase = msg.value != 0;
307     return withinPeriod && nonZeroPurchase;
308   }
309 
310   // @return true if crowdsale event has ended
311   function hasEnded() public constant returns (bool) {
312     return now > endTime;
313   }
314 }
315 
316 contract CappedCrowdsale is Crowdsale {
317   using SafeMath for uint256;
318 
319   uint256 public cap;
320 
321   function CappedCrowdsale(uint256 _cap) {
322     require(_cap > 0);
323     cap = _cap;
324   }
325 
326   // overriding Crowdsale#validPurchase to add extra cap logic
327   // @return true if investors can buy at the moment
328   function validPurchase() internal constant returns (bool) {
329     bool withinCap = weiRaised.add(msg.value) <= cap;
330     return super.validPurchase() && withinCap;
331   }
332 
333   // overriding Crowdsale#hasEnded to add cap logic
334   // @return true if crowdsale event has ended
335   function hasEnded() public constant returns (bool) {
336     bool capReached = weiRaised >= cap;
337     return super.hasEnded() || capReached;
338   }
339 
340 }
341 
342 contract LamdenTau is MintableToken {
343     string public constant name = "Lamden Tau";
344     string public constant symbol = "TAU";
345     uint8 public constant decimals = 18;
346 }
347 
348 contract Presale is CappedCrowdsale, Ownable {
349     using SafeMath for uint256;
350 
351     mapping (address => bool) public whitelist;
352 
353     bool public isFinalized = false;
354     event Finalized();
355     
356     address public team = 0xabc;
357     uint256 public teamShare = 150000000 * (10 ** 18);
358     
359     address public seed = 0xdef;
360     uint256 public seedShare = 1000000 * (10 ** 18);
361 
362     bool public hasAllocated = false;
363 
364     address public mediator = 0x0;
365     
366     function Presale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _tokenAddress) 
367     Crowdsale(_startTime, _endTime, _rate, _wallet)
368     CappedCrowdsale(_cap)
369     {
370         token = LamdenTau(_tokenAddress);
371     }
372     
373     // Crowdsale overrides
374     function createTokenContract() internal returns (MintableToken) {
375         return LamdenTau(0x0);
376     }
377 
378     function validPurchase() internal constant returns (bool) {
379         bool withinCap = weiRaised.add(msg.value) <= cap;
380         bool valid = super.validPurchase() && withinCap && whitelist[msg.sender];
381         return valid;
382     }
383     // * * *
384     
385     // Finalizer functions. Redefined from FinalizableCrowdsale to prevent diamond inheritence complexities
386     
387     function finalize() onlyOwner public {
388       require(mediator != 0x0);
389       require(!isFinalized);
390       require(hasEnded());
391       
392       finalization();
393       Finalized();
394 
395       isFinalized = true;
396     }
397     
398     function finalization() internal {
399         // set the ownership to the mediator so it can pass it onto the sale contract
400         // at the time that the sale contract is deployed
401         token.transferOwnership(mediator);
402         Mediator m = Mediator(mediator);
403         m.acceptToken();
404     }
405     // * * * 
406 
407     // Contract Specific functions
408     function assignMediator(address _m) public onlyOwner returns(bool) {
409         mediator = _m;
410         return true;
411     }
412     
413     function whitelistUser(address _a) public onlyOwner returns(bool){
414         whitelist[_a] = true;
415         return whitelist[_a];
416     }
417 
418     function whitelistUsers(address[] users) external onlyOwner {
419         for (uint i = 0; i < users.length; i++) {
420             whitelist[users[i]] = true;
421         }
422     }
423 
424     function unWhitelistUser(address _a) public onlyOwner returns(bool){
425         whitelist[_a] = false;
426         return whitelist[_a];
427     }
428 
429     function unWhitelistUsers(address[] users) external onlyOwner {
430         for (uint i = 0; i < users.length; i++) {
431             whitelist[users[i]] = false;
432         }
433     }
434     
435     function allocateTokens() public onlyOwner returns(bool) {
436         require(hasAllocated == false);
437         token.mint(team, teamShare);
438         token.mint(seed, seedShare);
439         hasAllocated = true;
440         return hasAllocated;
441     }
442     
443     function acceptToken() public onlyOwner returns(bool) {
444         token.acceptOwnership();
445         return true;
446     }
447 
448     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
449         require(_e > startTime);
450         endTime = _e;
451         return endTime;
452     }
453 
454     function mintTokens(uint256 tokenAmount) public onlyOwner {
455        require(!isFinalized);
456        token.mint(wallet, tokenAmount);
457     }
458     
459     // * * *
460 }
461 
462 contract Mediator is Ownable {
463     address public presale;
464     LamdenTau public tau;
465     address public sale;
466     
467     function setPresale(address p) public onlyOwner { presale = p; }
468     function setTau(address t) public onlyOwner { tau = LamdenTau(t); }
469     function setSale(address s) public onlyOwner { sale = s; }
470     
471     modifier onlyPresale {
472         require(msg.sender == presale);
473         _;
474     }
475     
476     modifier onlySale {
477         require(msg.sender == sale);
478         _;
479     }
480     
481     function acceptToken() public onlyPresale { tau.acceptOwnership(); }
482     function passOff() public onlySale { tau.transferOwnership(sale); }
483 }
484 
485 contract Sale is CappedCrowdsale, Ownable {
486     using SafeMath for uint256;
487 
488     // Initialization Variables
489     uint256 public amountPerDay; // 30 eth
490     //uint256 public constant UNIX_DAY = 86400;
491 
492     bool public isFinalized = false;
493     event Finalized();
494 
495     //mapping (address => bool) public whitelist;
496     // * * *
497 
498     // Constructor
499     function Sale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _tokenAddress)
500     Crowdsale(_startTime, _endTime, _rate, _wallet)
501     CappedCrowdsale(_cap)
502     {
503         //amountPerDay = _amountPerDay;
504         token = LamdenTau(_tokenAddress);
505     }
506     // * * *
507     
508     // Crowdsale overrides
509     function createTokenContract() internal returns (MintableToken) {
510         return LamdenTau(0x0);
511     }
512     
513     function validPurchase() internal constant returns (bool) {
514         bool withinCap = weiRaised.add(msg.value) <= cap;
515         bool valid = super.validPurchase() && withinCap;
516         return valid;
517     }
518 
519     function buyTokens(address beneficiary) public payable {
520         super.buyTokens(beneficiary);
521     }
522     // * * *
523 
524     // Finalizer functions
525     function finalize() onlyOwner public {
526       require(!isFinalized);
527       require(hasEnded());
528 
529       finalization();
530       Finalized();
531 
532       isFinalized = true;
533     }
534     
535     function finalization() internal {
536         token.finishMinting();
537     }
538     
539     function claimToken(address _m) public onlyOwner returns(bool) {
540         Mediator m = Mediator(_m);
541         m.passOff();
542         token.acceptOwnership();
543         return true;
544     }
545 
546     function changeEndTime(uint256 _e) public onlyOwner returns(uint256) {
547         require(_e > startTime);
548         endTime = _e;
549         return endTime;
550     }
551 
552     function mintTokens(uint256 tokenAmount) public onlyOwner {
553        require(!isFinalized);
554        token.mint(wallet, tokenAmount);
555     }
556     // * * *
557 }