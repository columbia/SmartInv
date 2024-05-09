1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68 
69   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 
100 /**
101  * @title ERC20 interface
102  */
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 /**
112  * @title Basic token
113  * @dev Basic version of StandardToken, with no allowances.
114  */
115 contract BasicToken is ERC20Basic, Ownable {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   uint256 totalSupply_;
121   
122   bool public stopped = false;
123   
124   event Stop(address indexed from);
125   
126   event Start(address indexed from);
127   
128   modifier isRunning {
129     assert (!stopped);
130     _;
131   }
132 
133   /**
134   * @dev total number of tokens in existence
135   */
136   function totalSupply() public view returns (uint256) {
137     return totalSupply_;
138   }
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) isRunning public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 ownerBalance) {
161     return balances[_owner];
162   }
163   
164   function stop() onlyOwner public {
165     stopped = true;
166     emit Stop(msg.sender);
167   }
168 
169   function start() onlyOwner public {
170     stopped = false;
171     emit Start(msg.sender);
172   }
173 
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  */
182 contract StandardToken is ERC20, BasicToken {
183 
184   mapping (address => mapping (address => uint256)) internal allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(address _from, address _to, uint256 _value) isRunning public returns (bool) {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) isRunning public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(address _owner, address _spender) public view returns (uint256) {
224     return allowed[_owner][_spender];
225   }
226 
227   /**
228    * @dev Increase the amount of tokens that an owner allowed to a spender.
229    *
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) isRunning public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * @param _spender The address which will spend the funds.
243    * @param _subtractedValue The amount of tokens to decrease the allowance by.
244    */
245   function decreaseApproval(address _spender, uint _subtractedValue) isRunning public returns (bool) {
246     uint oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue > oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 /**
259  * @title Burnable Token
260  * @dev Token that can be irreversibly burned (destroyed).
261  */
262 contract BurnableToken is BasicToken {
263 
264   event Burn(address indexed burner, uint256 value);
265 
266   /**
267    * @dev Burns a specific amount of tokens.
268    * @param _value The amount of token to be burned.
269    */
270   function burn(uint256 _value) public {
271     _burn(msg.sender, _value);
272   }
273 
274   function _burn(address _who, uint256 _value) internal {
275     require(_value <= balances[_who]);
276     balances[_who] = balances[_who].sub(_value);
277     totalSupply_ = totalSupply_.sub(_value);
278     emit Burn(_who, _value);
279     emit Transfer(_who, address(0), _value);
280   }
281 }
282 
283 
284 /**
285  * @title CappedMintableToken token
286  */
287 contract CappedMintableToken is StandardToken {
288   event Mint(address indexed to, uint256 amount);
289   event MintFinished();
290   event MintingAgentChanged(address addr, bool state);
291 
292   uint256 public cap;
293 
294   bool public mintingFinished = false;
295   mapping (address => bool) public mintAgents;
296 
297   modifier canMint() {
298     require(!mintingFinished);
299     _;
300   }
301   
302   modifier onlyMintAgent() {
303     // crowdsale contracts or owner are allowed to mint new tokens
304     if(!mintAgents[msg.sender] && (msg.sender != owner)) {
305         revert();
306     }
307     _;
308   }
309 
310 
311   constructor(uint256 _cap) public {
312     require(_cap > 0);
313     cap = _cap;
314   }
315 
316 
317   /**
318    * Owner can allow a crowdsale contract to mint new tokens.
319    */
320   function setMintAgent(address addr, bool state) onlyOwner canMint public {
321     mintAgents[addr] = state;
322     emit MintingAgentChanged(addr, state);
323   }
324   
325   /**
326    * @dev Function to mint tokens
327    * @param _to The address that will receive the minted tokens.
328    * @param _amount The amount of tokens to mint.
329    * @return A boolean that indicates if the operation was successful.
330    */
331   function mint(address _to, uint256 _amount) onlyMintAgent canMint isRunning public returns (bool) {
332     require(totalSupply_.add(_amount) <= cap);
333     totalSupply_ = totalSupply_.add(_amount);
334     balances[_to] = balances[_to].add(_amount);
335     emit Mint(_to, _amount);
336     emit Transfer(address(0), _to, _amount);
337     return true;
338   }
339 
340   /**
341    * @dev Function to stop minting new tokens.
342    * @return True if the operation was successful.
343    */
344   function finishMinting() onlyOwner canMint public returns (bool) {
345     mintingFinished = true;
346     emit MintFinished();
347     return true;
348   }
349 }
350 
351 /**
352  * @title Standard Burnable Token
353  * @dev Adds burnFrom method to ERC20 implementations
354  */
355 contract StandardBurnableToken is BurnableToken, StandardToken {
356 
357   /**
358    * @dev Burns a specific amount of tokens from the target address and decrements allowance
359    * @param _from address The address which you want to send tokens from
360    * @param _value uint256 The amount of token to be burned
361    */
362   function burnFrom(address _from, uint256 _value) public {
363     require(_value <= allowed[_from][msg.sender]);
364     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
365     _burn(_from, _value);
366   }
367 }
368 
369 
370 /**
371  * @title ODXToken
372  * @dev Simple ERC20 Token,   
373  * Tokens are mintable and burnable.
374  * No initial token upon creation
375  * Added max token supply
376  */
377 contract ODXToken is CappedMintableToken, StandardBurnableToken {
378 
379   string public name; 
380   string public symbol; 
381   uint8 public decimals; 
382 
383   /**
384    * @dev set totalSupply_ = 0;
385    */
386   constructor(
387       string _name, 
388       string _symbol, 
389       uint8 _decimals, 
390       uint256 _maxTokens
391   ) 
392     public 
393     CappedMintableToken(_maxTokens) 
394   {
395     name = _name;
396     symbol = _symbol;
397     decimals = _decimals;
398     totalSupply_ = 0;
399   }
400   
401   function () payable public {
402       revert();
403   }
404 
405 }
406 
407 
408 /**
409  * @title PrivateSaleRules
410  * @dev Specifically use for private sale with lockup.
411  */
412 contract PrivateSaleRules is Ownable {
413   using SafeMath for uint256;
414 
415   // private sale tracker of contribution
416   uint256 public weiRaisedDuringPrivateSale;
417 
418   mapping(address => uint256[]) public lockedTokens;
419   
420   uint256[] public lockupTimes;
421   mapping(address => uint256) public privateSale;
422   
423   mapping (address => bool) public privateSaleAgents;
424 
425   // The token being sold
426   ERC20 public token;
427 
428   event AddLockedTokens(address indexed beneficiary, uint256 totalContributionAmount, uint256[] tokenAmount);
429   event UpdateLockedTokens(address indexed beneficiary, uint256 totalContributionAmount, uint256 lockedTimeIndex, uint256 tokenAmount);
430   event PrivateSaleAgentChanged(address addr, bool state);
431 
432 
433   modifier onlyPrivateSaleAgent() {
434     // crowdsale contracts or owner are allowed to whitelist address
435     require(privateSaleAgents[msg.sender] || msg.sender == owner);
436     _;
437   }
438   
439 
440   /**
441    * @dev Constructor, sets lockupTimes and token address
442    * @param _lockupTimes arraylist of lockup times
443    * @param _token tokens to be minted
444    */
445   constructor(uint256[] _lockupTimes, ODXToken _token) public {
446     require(_lockupTimes.length > 0);
447     
448     lockupTimes = _lockupTimes;
449     token = _token;
450   }
451 
452   /**
453    * Owner can add an address to the privatesaleagents.
454    */
455   function setPrivateSaleAgent(address addr, bool state) onlyOwner public {
456     privateSaleAgents[addr] = state;
457     emit PrivateSaleAgentChanged(addr, state);
458   }
459   
460   /**
461    * @dev Overrides delivery by minting tokens upon purchase.
462    * @param _beneficiary Token purchaser
463    * @param _tokenAmount Number of tokens to be minted
464    */
465   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
466     require(ODXToken(token).mint(_beneficiary, _tokenAmount));
467   }
468   
469   /**
470    * @dev claim locked tokens only after lockup time.
471    */
472    
473   function claimLockedTokens() public {
474     for (uint i=0; i<lockupTimes.length; i++) {
475         uint256 lockupTime = lockupTimes[i];
476         if (lockupTime < now){
477             uint256 tokens = lockedTokens[msg.sender][i];
478             if (tokens>0){
479                 lockedTokens[msg.sender][i] = 0;
480                 _deliverTokens(msg.sender, tokens);    
481             }
482         }
483     }
484   }
485 
486 
487   /**
488    * @dev release locked tokens only after lockup time.
489    */
490   function releaseLockedTokensByIndex(address _beneficiary, uint256 _lockedTimeIndex) onlyOwner public {
491     require(lockupTimes[_lockedTimeIndex] < now);
492     uint256 tokens = lockedTokens[_beneficiary][_lockedTimeIndex];
493     if (tokens>0){
494         lockedTokens[_beneficiary][_lockedTimeIndex] = 0;
495         _deliverTokens(_beneficiary, tokens);    
496     }
497   }
498   
499   function releaseLockedTokens(address _beneficiary) public {
500     for (uint i=0; i<lockupTimes.length; i++) {
501         uint256 lockupTime = lockupTimes[i];
502         if (lockupTime < now){
503             uint256 tokens = lockedTokens[_beneficiary][i];
504             if (tokens>0){
505                 lockedTokens[_beneficiary][i] = 0;
506                 _deliverTokens(_beneficiary, tokens);    
507             }
508         }
509     }
510     
511   }
512   
513   function tokensReadyForRelease(uint256 releaseBatch) public view returns (bool) {
514       bool forRelease = false;
515       uint256 lockupTime = lockupTimes[releaseBatch];
516       if (lockupTime < now){
517         forRelease = true;
518       }
519       return forRelease;
520   }
521 
522   /**
523    * @dev Returns the locked tokens of a specific user.
524    * @param _beneficiary Address whose locked tokens is to be checked
525    * @return locked tokens for individual user
526    */
527   function getTotalLockedTokensPerUser(address _beneficiary) public view returns (uint256) {
528     uint256 totalTokens = 0;
529     uint256[] memory lTokens = lockedTokens[_beneficiary];
530     for (uint i=0; i<lockupTimes.length; i++) {
531         totalTokens += lTokens[i];
532     }
533     return totalTokens;
534   }
535   
536   function getLockedTokensPerUser(address _beneficiary) public view returns (uint256[]) {
537     return lockedTokens[_beneficiary];
538   }
539 
540   function addPrivateSaleWithMonthlyLockup(address _beneficiary, uint256[] _atokenAmount, uint256 _totalContributionAmount) onlyPrivateSaleAgent public {
541       require(_beneficiary != address(0));
542       require(_totalContributionAmount > 0);
543       require(_atokenAmount.length == lockupTimes.length);
544       
545       uint256 existingContribution = privateSale[_beneficiary];
546       if (existingContribution > 0){
547         revert();
548       }else{
549         lockedTokens[_beneficiary] = _atokenAmount;
550         privateSale[_beneficiary] = _totalContributionAmount;
551           
552         weiRaisedDuringPrivateSale = weiRaisedDuringPrivateSale.add(_totalContributionAmount);
553           
554         emit AddLockedTokens(
555           _beneficiary,
556           _totalContributionAmount,
557           _atokenAmount
558         );
559           
560       }
561       
562   }
563   
564   /*
565   function getTotalTokensPerArray(uint256[] _tokensArray) internal pure returns (uint256) {
566       uint256 totalTokensPerArray = 0;
567       for (uint i=0; i<_tokensArray.length; i++) {
568         totalTokensPerArray += _tokensArray[i];
569       }
570       return totalTokensPerArray;
571   }
572   */
573 
574 
575   /**
576    * @dev update locked tokens per user 
577    * @param _beneficiary Token purchaser
578    * @param _lockedTimeIndex lockupTimes index
579    * @param _atokenAmount Amount of tokens to be minted
580    * @param _totalContributionAmount ETH equivalent of the contribution
581    */
582   function updatePrivateSaleWithMonthlyLockupByIndex(address _beneficiary, uint _lockedTimeIndex, uint256 _atokenAmount, uint256 _totalContributionAmount) onlyPrivateSaleAgent public {
583       require(_beneficiary != address(0));
584       require(_totalContributionAmount > 0);
585       //_lockedTimeIndex must be valid within the lockuptimes length
586       require(_lockedTimeIndex < lockupTimes.length);
587 
588       
589       uint256 oldContributions = privateSale[_beneficiary];
590       //make sure beneficiary has existing contribution otherwise use addPrivateSaleWithMonthlyLockup
591       require(oldContributions > 0);
592 
593       //make sure lockuptime of the index is less than now (tokens were not yet released)
594       require(!tokensReadyForRelease(_lockedTimeIndex));
595       
596       lockedTokens[_beneficiary][_lockedTimeIndex] = _atokenAmount;
597       
598       //subtract old contribution from weiRaisedDuringPrivateSale
599       weiRaisedDuringPrivateSale = weiRaisedDuringPrivateSale.sub(oldContributions);
600       
601       //add new contribution to weiRaisedDuringPrivateSale
602       privateSale[_beneficiary] = _totalContributionAmount;
603       weiRaisedDuringPrivateSale = weiRaisedDuringPrivateSale.add(_totalContributionAmount);
604             
605       emit UpdateLockedTokens(
606       _beneficiary,
607       _totalContributionAmount,
608       _lockedTimeIndex,
609       _atokenAmount
610     );
611   }
612 
613 
614 }
615 
616 /**
617  * @title ODXPrivateSale
618  * @dev This is for the private sale of ODX.  
619  */
620 contract ODXPrivateSale is PrivateSaleRules {
621 
622   uint256[] alockupTimes = [1556035200,1556100000,1556121600,1556186400,1556208000,1556272800,1556294400,1556359200,1556380800,1556445600];
623   
624   constructor(
625     ODXToken _token
626   )
627     public
628     PrivateSaleRules(alockupTimes, _token)
629   {  }
630   
631 }