1 pragma solidity 0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   uint public totalSupply = 0;
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require (msg.sender == owner);
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 
38 }
39 
40 
41 /**
42  * @title Authorizable
43  * @dev Allows to authorize access to certain function calls
44  *
45  * ABI
46  *
47  */
48 contract Authorizable {
49  
50   address[] authorizers;
51   mapping(address => uint256) authorizerIndex;
52  
53   /**
54    * @dev Throws if called by any account that is not authorized.
55    */
56   modifier onlyAuthorized {
57     require(isAuthorized(msg.sender));
58     _;
59   }
60  
61   /**
62    * @dev Contructor that authorizes the msg.sender.
63    */
64   function Authorizable() public {
65     authorizers.length = 2;
66     authorizers[1] = msg.sender;
67     authorizerIndex[msg.sender] = 1;
68   }
69  
70   /**
71    * @dev Function to get a specific authorizer
72    * @param authIndex index of the authorizer to be retrieved.
73    * @return The address of the authorizer.
74    */
75   function getAuthorizer(uint256 authIndex) external constant returns(address) {
76     return address(authorizers[authIndex + 1]);
77   }
78  
79   /**
80    * @dev Function to check if an address is authorized
81    * @param _addr the address to check if it is authorized.
82    * @return boolean flag if address is authorized.
83    */
84   function isAuthorized(address _addr) public constant returns(bool) {
85     return authorizerIndex[_addr] > 0;
86   }
87  
88   /**
89    * @dev Function to add a new authorizer
90    * @param _addr the address to add as a new authorizer.
91    */
92   function addAuthorized(address _addr) external onlyAuthorized {
93     authorizerIndex[_addr] = authorizers.length;
94     authorizers.length++;
95     authorizers[authorizers.length - 1] = _addr;
96   }
97 }
98 
99 
100 /**
101  * Math operations with safety checks
102  */
103 library SafeMath {
104   function mul(uint a, uint b) internal pure returns (uint) {
105     uint c = a * b;
106     assert(a == 0 || c / a == b);
107     return c;
108   }
109 
110   function div(uint a, uint b) internal pure returns (uint) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   function sub(uint a, uint b) internal pure returns (uint) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   function add(uint a, uint b) internal pure returns (uint) {
123     uint c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 
128   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
129     return a >= b ? a : b;
130   }
131 
132   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
133     return a < b ? a : b;
134   }
135 
136   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
137     return a >= b ? a : b;
138   }
139 
140   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
141     return a < b ? a : b;
142   }
143 
144   //function assert(bool _assertion) internal pure {
145   //  require (_assertion);
146   //}
147 }
148 
149 
150 /**
151  * @title ERC20Basic
152  * @dev Simpler version of ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20Basic {
156   function balanceOf(address who) public constant returns (uint);
157   function transfer(address to, uint value) public;
158   event Transfer(address indexed from, address indexed to, uint value);
159 }
160 
161 
162 /**
163  * @title ERC20 interface
164  * @dev see https://github.com/ethereum/EIPs/issues/20
165  */
166 contract ERC20 is ERC20Basic {
167   function allowance(address owner, address spender) public constant returns (uint);
168   function transferFrom(address from, address to, uint value) public;
169   function approve(address spender, uint value) public;
170   event Approval(address indexed owner, address indexed spender, uint value);
171 }
172 
173 
174 /**
175  * @title Basic token
176  * @dev Basic version of StandardToken, with no allowances.
177  */
178 contract BasicToken is ERC20Basic {
179   using SafeMath for uint;
180   mapping(address => uint) public balances;
181 
182   /**
183    * @dev Fix for the ERC20 short address attack.
184    */
185   modifier onlyPayloadSize(uint size) {
186      require(msg.data.length >= size + 4);
187      _;
188   }
189 
190   /**
191   * @dev transfer token for a specified address
192   * @param _to The address to transfer to.
193   * @param _value The amount to be transferred.
194   */
195   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     Transfer(msg.sender, _to, _value);
199   }
200 
201   /**
202   * @dev Gets the balance of the specified address.
203   * @param _owner The address to query the the balance of.
204   * @return An uint representing the amount owned by the passed address.
205   */
206   function balanceOf(address _owner) public constant returns (uint balance) {
207     return balances[_owner];
208   }
209 
210 }
211 
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implemantation of the basic standart token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is BasicToken, ERC20 {
221 
222   mapping (address => mapping (address => uint)) allowed;
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint the amout of tokens to be transfered
229    */
230   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
231     uint _allowance = allowed[_from][msg.sender];
232     balances[_to] = balances[_to].add(_value);
233     balances[_from] = balances[_from].sub(_value);
234     allowed[_from][msg.sender] = _allowance.sub(_value);
235     Transfer(_from, _to, _value);
236   }
237 
238   /**
239    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint _value) public {
244 
245     // To change the approve amount you first have to reduce the addresses`
246     // allowance to zero by calling `approve(_spender, 0)` if it is not
247     // already 0 to mitigate the race condition described here:
248     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249     // if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
250     require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
251 
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens than an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint specifing the amount of tokens still avaible for the spender.
261    */
262   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
263     return allowed[_owner][_spender];
264   }
265 
266 }
267 
268 
269 /**
270  * @title Mintable token
271  * @dev Simple ERC20 Token example, with mintable token creation
272  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
273  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
274  */
275 
276 contract MintableToken is StandardToken, Ownable {
277   event Mint(address indexed to, uint value);
278   event MintFinished();
279 
280   bool public mintingFinished = false;
281 
282   modifier canMint() {
283     require(!mintingFinished);
284     _;
285   }
286 
287   /**
288    * @dev Function to mint tokens
289    * @param _to The address that will recieve the minted tokens.
290    * @param _amount The amount of tokens to mint.
291    * @return A boolean that indicates if the operation was successful.
292    */
293   function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
294     totalSupply = totalSupply.add(_amount);
295     balances[_to] = balances[_to].add(_amount);
296     Mint(_to, _amount);
297     return true;
298   }
299 
300   /**
301    * @dev Function to stop minting new tokens.
302    * @return True if the operation was successful.
303    */
304   function finishMinting() public onlyOwner returns (bool) {
305     mintingFinished = true;
306     MintFinished();
307     return true;
308   }
309 }
310 
311 
312 /**
313  * @title RecToken
314  * @dev The main REC token contract
315  *
316  * ABI
317  *
318  */
319 contract RecToken is MintableToken {
320   string public standard = "Renta.City";
321   string public name = "Renta.City";
322   string public symbol = "REC";
323   uint public decimals = 18;
324   address public saleAgent;
325 
326   bool public tradingStarted = false;
327 
328   /**
329    * @dev modifier that throws if trading has not started yet
330    */
331   modifier hasStartedTrading() {
332     require(tradingStarted);
333     _;
334   }
335 
336   /**
337    * @dev Allows the owner to enable the trading. This can not be undone
338    */
339   function startTrading() public onlyOwner {
340     tradingStarted = true;
341   }
342 
343   /**
344    * @dev Allows anyone to transfer the REC tokens once trading has started
345    * @param _to the recipient address of the tokens.
346    * @param _value number of tokens to be transfered.
347    */
348   function transfer(address _to, uint _value) public hasStartedTrading {
349     super.transfer(_to, _value);
350   }
351 
352    /**
353    * @dev Allows anyone to transfer the REC tokens once trading has started
354    * @param _from address The address which you want to send tokens from
355    * @param _to address The address which you want to transfer to
356    * @param _value uint the amout of tokens to be transfered
357    */
358   function transferFrom(address _from, address _to, uint _value) public hasStartedTrading {
359     super.transferFrom(_from, _to, _value);
360   }
361   
362   function set_saleAgent(address _value) public onlyOwner {
363     saleAgent = _value;
364   }
365 }
366 
367 
368 /**
369  * @title MainSale
370  * @dev The main REC token sale contract
371  *
372  * ABI
373  *
374  */
375 contract MainSale is Ownable, Authorizable {
376   using SafeMath for uint;
377   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
378   event AuthorizedCreate(address recipient, uint pay_amount);
379   event MainSaleClosed();
380 
381   RecToken public token = new RecToken();
382 
383   address public multisigVault;
384   mapping(address => uint) public balances;
385 
386   uint public hardcap = 100000 ether;
387   uint public altDeposits = 0;
388   uint public start = 1519862400; 
389   uint public rate = 1000000000000000000000;
390   bool public isRefund = false;
391 
392   uint public stage_Days = 30 days;
393   uint public stage_Discount = 0;
394 
395   uint public commandPercent = 10;
396   uint public refererPercent = 2;
397   uint public bountyPercent = 2;
398 
399   uint public maxBountyTokens = 0;
400   uint public maxTokensForCommand = 0;
401   uint public issuedBounty = 0;			// <= 2% from total emission
402   uint public issuedTokensForCommand = 0;       // <= 10% from total emission
403 
404   /**
405    * @dev modifier to allow token creation only when the sale IS ON
406    */
407   modifier saleIsOn() {
408     require(now > start && now < start + stage_Days);
409     _;
410   }
411 
412   /**
413    * @dev modifier to allow token creation only when the hardcap has not been reached
414    */
415   modifier isUnderHardCap() {
416     require(multisigVault.balance + altDeposits <= hardcap);
417     _;
418   }
419 
420   /**
421    * Convert bytes to address
422    */
423   function bytesToAddress(bytes source) internal pure returns(address) {
424      uint result;
425      uint mul = 1;
426      for(uint i = 20; i > 0; i--) {
427         result += uint8(source[i-1])*mul;
428         mul = mul*256;
429      }
430      return address(result);
431     }
432 
433   /**
434    * @dev Allows the owner to set the periods of ICO in days(!).
435    */
436   function set_stage_Days(uint _value) public onlyOwner {
437     stage_Days = _value * 1 days;
438   }
439 
440   function set_stage_Discount(uint _value) public onlyOwner {
441     stage_Discount = _value;
442   }
443 
444   function set_commandPercent(uint _value) public onlyOwner {
445     commandPercent = _value;
446   }
447 
448   function set_refererPercent(uint _value) public onlyOwner {
449     refererPercent = _value;
450   }
451 
452   function set_bountyPercent(uint _value) public onlyOwner {
453     bountyPercent = _value;
454   }
455 
456   function set_Rate(uint _value) public onlyOwner {
457     rate = _value * 1 ether;
458   }
459   
460   /**
461    * @dev Allows anyone to create tokens by depositing ether.
462    * @param recipient the recipient to receive tokens.
463    */
464   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
465     require(msg.value >= 0.01 ether);
466     
467     // Calculate discounts
468     uint CurrentDiscount = 0;
469     if (now > start && now < (start + stage_Days)) {CurrentDiscount = stage_Discount;}
470     
471     // Calculate tokens
472     uint tokens = rate.mul(msg.value).div(1 ether);
473     tokens = tokens + tokens.mul(CurrentDiscount).div(100);
474     token.mint(recipient, tokens);
475     balances[msg.sender] = balances[msg.sender].add(msg.value);
476     maxBountyTokens = token.totalSupply().mul(bountyPercent).div(100-bountyPercent).div(1 ether);
477     maxTokensForCommand = token.totalSupply().mul(commandPercent).div(100-commandPercent).div(1 ether);
478     
479     require(multisigVault.send(msg.value));
480     TokenSold(recipient, msg.value, tokens, rate);
481 
482     // Transfer 2% => to Referer
483     address referer = 0x0;
484     if(msg.data.length == 20) {
485         referer = bytesToAddress(bytes(msg.data));
486         require(referer != msg.sender);
487         uint refererTokens = tokens.mul(refererPercent).div(100);
488         if (referer != 0x0 && refererTokens > 0) {
489     	    token.mint(referer, refererTokens);
490     	    maxBountyTokens = token.totalSupply().mul(bountyPercent).div(100-bountyPercent).div(1 ether);
491     	    maxTokensForCommand = token.totalSupply().mul(commandPercent).div(100-commandPercent).div(1 ether);
492     	    TokenSold(referer, 0, refererTokens, rate);
493         }
494     }
495   }
496 
497   /**
498    * @dev Allows the owner to mint tokens for Command (<= 10%)
499    */
500   function mintTokensForCommand(address recipient, uint tokens) public onlyOwner returns (bool){
501     maxTokensForCommand = token.totalSupply().mul(commandPercent).div(100-commandPercent).div(1 ether);
502     if (tokens <= (maxTokensForCommand - issuedTokensForCommand)) {
503         token.mint(recipient, tokens * 1 ether);
504 	issuedTokensForCommand = issuedTokensForCommand + tokens;
505         maxTokensForCommand = token.totalSupply().mul(commandPercent).div(100-commandPercent).div(1 ether);
506         TokenSold(recipient, 0, tokens * 1 ether, rate);
507         return(true);
508     }
509     else {return(false);}
510   }
511 
512   /**
513    * @dev Allows the owner to mint tokens for Bounty (<= 2%)
514    */
515   function mintBounty(address recipient, uint tokens) public onlyOwner returns (bool){
516     maxBountyTokens = token.totalSupply().mul(bountyPercent).div(100-bountyPercent).div(1 ether);
517     if (tokens <= (maxBountyTokens - issuedBounty)) {
518         token.mint(recipient, tokens * 1 ether);
519 	issuedBounty = issuedBounty + tokens;
520         maxBountyTokens = token.totalSupply().mul(bountyPercent).div(100-bountyPercent).div(1 ether);
521         TokenSold(recipient, 0, tokens * 1 ether, rate);
522         return(true);
523     }
524     else {return(false);}
525   }
526 
527   function refund() public {
528       require(isRefund);
529       uint value = balances[msg.sender]; 
530       balances[msg.sender] = 0; 
531       msg.sender.transfer(value); 
532     }
533 
534   function startRefund() public onlyOwner {
535       isRefund = true;
536     }
537 
538   function stopRefund() public onlyOwner {
539       isRefund = false;
540     }
541 
542   /**
543    * @dev Allows to set the total alt deposit measured in ETH to make sure the hardcap includes other deposits
544    * @param totalAltDeposits total amount ETH equivalent
545    */
546   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
547     altDeposits = totalAltDeposits;
548   }
549 
550   /**
551    * @dev Allows the owner to set the hardcap.
552    * @param _hardcap the new hardcap
553    */
554   function setHardCap(uint _hardcap) public onlyOwner {
555     hardcap = _hardcap;
556   }
557 
558   /**
559    * @dev Allows the owner to set the starting time.
560    * @param _start the new _start
561    */
562   function setStart(uint _start) public onlyOwner {
563     start = _start;
564   }
565 
566   /**
567    * @dev Allows the owner to set the multisig contract.
568    * @param _multisigVault the multisig contract address
569    */
570   function setMultisigVault(address _multisigVault) public onlyOwner {
571     if (_multisigVault != address(0)) {
572       multisigVault = _multisigVault;
573     }
574   }
575 
576   /**
577    * @dev Allows the owner to finish the minting. This will create the
578    * restricted tokens and then close the minting.
579    * Then the ownership of the REC token contract is transfered
580    * to this owner.
581    */
582   function finishMinting() public onlyOwner {
583     uint issuedTokenSupply = token.totalSupply();
584     uint restrictedTokens = issuedTokenSupply.mul(commandPercent).div(100-commandPercent);
585     token.mint(multisigVault, restrictedTokens);
586     token.finishMinting();
587     token.transferOwnership(owner);
588     MainSaleClosed();
589   }
590 
591   /**
592    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
593    * @param _token the contract address of the ERC20 contract
594    */
595   function retrieveTokens(address _token) public payable {
596     require(msg.sender == owner);
597     ERC20 erctoken = ERC20(_token);
598     erctoken.transfer(multisigVault, erctoken.balanceOf(this));
599   }
600 
601   /**
602    * @dev Fallback function which receives ether and created the appropriate number of tokens for the
603    * msg.sender.
604    */
605   function() external payable {
606     createTokens(msg.sender);
607   }
608 
609 }