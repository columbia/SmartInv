1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     require (msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to. 
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     require(newOwner != address(0));
37     owner = newOwner;
38   }
39 }
40 
41 
42 
43 /**
44  * @title Authorizable
45  * @dev Allows to authorize access to certain function calls
46  * 
47  * ABI
48  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
49  */
50 contract Authorizable {
51 
52   address[] authorizers;
53   mapping(address => uint) authorizerIndex;
54 
55   /**
56    * @dev Throws if called by any account tat is not authorized. 
57    */
58   modifier onlyAuthorized {
59     require(isAuthorized(msg.sender));
60     _;
61   }
62 
63   /**
64    * @dev Contructor that authorizes the msg.sender. 
65    */
66   function Authorizable() public {
67     authorizers.length = 2;
68     authorizers[1] = msg.sender;
69     authorizerIndex[msg.sender] = 1;
70   }
71 
72   /**
73    * @dev Function to get a specific authorizer
74    * @param authorizerIndex index of the authorizer to be retrieved.
75    * @return The address of the authorizer.
76    */
77   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
78     return address(authorizers[authorizerIndex + 1]);
79   }
80 
81   /**
82    * @dev Function to check if an address is authorized
83    * @param _addr the address to check if it is authorized.
84    * @return boolean flag if address is authorized.
85    */
86   function isAuthorized(address _addr) public constant returns(bool) {
87     return authorizerIndex[_addr] > 0;
88   }
89 
90   /**
91    * @dev Function to add a new authorizer
92    * @param _addr the address to add as a new authorizer.
93    */
94   function addAuthorized(address _addr) external onlyAuthorized {
95     authorizerIndex[_addr] = authorizers.length;
96     authorizers.length++;
97     authorizers[authorizers.length - 1] = _addr;
98   }
99 
100 }
101 
102 /**
103  * @title ExchangeRate
104  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
105  *
106  * ABI
107  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
108  */
109 contract ExchangeRate is Ownable {
110  
111   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
112 
113   mapping(bytes32 => uint) public rates;
114 
115   /**
116    * @dev Allows the current owner to update a single rate.
117    * @param _symbol The symbol to be updated. 
118    * @param _rate the rate for the symbol. 
119    */
120   function updateRate(string _symbol, uint _rate) public onlyOwner {
121     rates[keccak256(_symbol)] = _rate;
122     RateUpdated(now, keccak256(_symbol), _rate);
123   }
124 
125   /**
126    * @dev Allows the current owner to update multiple rates.
127    * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate . 
128    */
129   function updateRates(uint[] data) public onlyOwner {
130     require (data.length % 2 <= 0);
131     uint i = 0;
132     while (i < data.length / 2) {
133       bytes32 symbol = bytes32(data[i * 2]);
134       uint rate = data[i * 2 + 1];
135       rates[symbol] = rate;
136       RateUpdated(now, symbol, rate);
137       i++;
138     }
139   }
140 
141   /**
142    * @dev Allows the anyone to read the current rate.
143    * @param _symbol the symbol to be retrieved. 
144    */
145   function getRate(string _symbol) public constant returns(uint) {
146     return rates[keccak256(_symbol)];
147   }
148 
149 }
150 
151 /**
152  * Math operations with safety checks
153  */
154 library SafeMath {
155   function mul(uint a, uint b) internal returns (uint) {
156     uint c = a * b;
157     assert(a == 0 || c / a == b);
158     return c;
159   }
160 
161   function div(uint a, uint b) internal returns (uint) {
162     // assert(b > 0); // Solidity automatically throws when dividing by 0
163     uint c = a / b;
164     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165     return c;
166   }
167 
168   function sub(uint a, uint b) internal returns (uint) {
169     assert(b <= a);
170     return a - b;
171   }
172 
173   function add(uint a, uint b) internal returns (uint) {
174     uint c = a + b;
175     assert(c >= a);
176     return c;
177   }
178 
179   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
180     return a >= b ? a : b;
181   }
182 
183   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
184     return a < b ? a : b;
185   }
186 
187   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
188     return a >= b ? a : b;
189   }
190 
191   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
192     return a < b ? a : b;
193   }
194 
195   function assert(bool assertion) internal {
196     require(assertion);
197   }
198 }
199 
200 
201 /**
202  * @title ERC20Basic
203  * @dev Simpler version of ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/20
205  */
206 contract ERC20Basic {
207   uint public totalSupply;
208   function balanceOf(address who) public constant returns (uint);
209   function transfer(address to, uint value) public;
210   event Transfer(address indexed from, address indexed to, uint value);
211 }
212 
213 
214 
215 
216 /**
217  * @title ERC20 interface
218  * @dev see https://github.com/ethereum/EIPs/issues/20
219  */
220 contract ERC20 is ERC20Basic {
221   function allowance(address owner, address spender) constant returns (uint);
222   function transferFrom(address from, address to, uint value);
223   function approve(address spender, uint value);
224   event Approval(address indexed owner, address indexed spender, uint value);
225 } 
226 
227 
228 
229 
230 /**
231  * @title Basic token
232  * @dev Basic version of StandardToken, with no allowances. 
233  */
234 contract BasicToken is ERC20Basic {
235   using SafeMath for uint;
236 
237   mapping(address => uint) balances;
238 
239   /**
240    * @dev Fix for the ERC20 short address attack.
241    */
242   modifier onlyPayloadSize(uint size) {
243      require (size + 4 <= msg.data.length);
244      _;
245   }
246 
247   /**
248   * @dev transfer token for a specified address
249   * @param _to The address to transfer to.
250   * @param _value The amount to be transferred.
251   */
252   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
253     balances[msg.sender] = balances[msg.sender].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     Transfer(msg.sender, _to, _value);
256   }
257 
258   /**
259   * @dev Gets the balance of the specified address.
260   * @param _owner The address to query the the balance of. 
261   * @return An uint representing the amount owned by the passed address.
262   */
263   function balanceOf(address _owner) constant returns (uint balance) {
264     return balances[_owner];
265   }
266 
267 }
268 
269 
270 
271 
272 /**
273  * @title Standard ERC20 token
274  *
275  * @dev Implemantation of the basic standart token.
276  * @dev https://github.com/ethereum/EIPs/issues/20
277  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
278  */
279 contract StandardToken is BasicToken, ERC20 {
280 
281   mapping (address => mapping (address => uint)) allowed;
282 
283 
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint the amout of tokens to be transfered
289    */
290   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
291     var _allowance = allowed[_from][msg.sender];
292 
293     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
294     // if (_value > _allowance) throw;
295 
296     balances[_to] = balances[_to].add(_value);
297     balances[_from] = balances[_from].sub(_value);
298     allowed[_from][msg.sender] = _allowance.sub(_value);
299     Transfer(_from, _to, _value);
300   }
301 
302   /**
303    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
304    * @param _spender The address which will spend the funds.
305    * @param _value The amount of tokens to be spent.
306    */
307   function approve(address _spender, uint _value) {
308 
309     // To change the approve amount you first have to reduce the addresses`
310     //  allowance to zero by calling `approve(_spender, 0)` if it is not
311     //  already 0 to mitigate the race condition described here:
312     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
314 
315     allowed[msg.sender][_spender] = _value;
316     Approval(msg.sender, _spender, _value);
317   }
318 
319   /**
320    * @dev Function to check the amount of tokens than an owner allowed to a spender.
321    * @param _owner address The address which owns the funds.
322    * @param _spender address The address which will spend the funds.
323    * @return A uint specifing the amount of tokens still avaible for the spender.
324    */
325   function allowance(address _owner, address _spender) constant returns (uint remaining) {
326     return allowed[_owner][_spender];
327   }
328 
329 }
330 
331 
332 /**
333  * @title Mintable token
334  * @dev Simple ERC20 Token example, with mintable token creation
335  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
336  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
337  */
338 
339 contract MintableToken is StandardToken, Ownable {
340   event Mint(address indexed to, uint value);
341   event MintFinished();
342   event Burn(address indexed burner, uint256 value);
343 
344   bool public mintingFinished = false;
345   uint public totalSupply = 0;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will recieve the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
360     totalSupply = totalSupply.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     Mint(_to, _amount);
363     return true;
364   }
365 
366   /**
367    * @dev Function to stop minting new tokens.
368    * @return True if the operation was successful.
369    */
370   function finishMinting() onlyOwner returns (bool) {
371     mintingFinished = true;
372     MintFinished();
373     return true;
374   }
375    
376   
377   /**
378    * @dev Burns a specific amount of tokens.
379    * @param _value The amount of token to be burned.
380    */
381   function burn(address _who, uint256 _value) onlyOwner public {
382     _burn(_who, _value);
383   }
384 
385   function _burn(address _who, uint256 _value) internal {
386     require(_value <= balances[_who]);
387     // no need to require value <= totalSupply, since that would imply the
388     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
389 
390     balances[_who] = balances[_who].sub(_value);
391     totalSupply = totalSupply.sub(_value);
392     Burn(_who, _value);
393     Transfer(_who, address(0), _value);
394   }
395 }
396 
397 
398 /**
399  * @title CBCToken
400  * @dev The main CBC token contract
401  * 
402  * ABI 
403  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
404  */
405 contract CBCToken is MintableToken {
406 
407   string public name = "Crypto Boss Coin";
408   string public symbol = "CBC";
409   uint public decimals = 18;
410 
411   bool public tradingStarted = false;
412   /**
413    * @dev modifier that throws if trading has not started yet
414    */
415   modifier hasStartedTrading() {
416     require(tradingStarted);
417     _;
418   }
419  
420 
421   /**
422    * @dev Allows the owner to enable the trading. This can not be undone
423    */
424   function startTrading() onlyOwner {
425     tradingStarted = true;
426   }
427 
428   /**
429    * @dev Allows anyone to transfer the PAY tokens once trading has started
430    * @param _to the recipient address of the tokens. 
431    * @param _value number of tokens to be transfered. 
432    */
433   function transfer(address _to, uint _value) hasStartedTrading {
434     super.transfer(_to, _value);
435   }
436 
437    /**
438    * @dev Allows anyone to transfer the CBC tokens once trading has started
439    * @param _from address The address which you want to send tokens from
440    * @param _to address The address which you want to transfer to
441    * @param _value uint the amout of tokens to be transfered
442    */
443   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
444     super.transferFrom(_from, _to, _value);
445   }
446 
447 }
448 
449 /**
450  * @title MainSale
451  * @dev The main CBC token sale contract
452  * 
453  * ABI
454  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
455  */
456 contract MainSale is Ownable, Authorizable {
457   using SafeMath for uint;
458   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
459   event AuthorizedCreate(address recipient, uint pay_amount);
460   event AuthorizedBurn(address receiver, uint value);
461   event AuthorizedStartTrading();
462   event MainSaleClosed();
463   CBCToken public token = new CBCToken();
464 
465   address public multisigVault;
466 
467   uint hardcap = 100000000000000 ether;
468   ExchangeRate public exchangeRate;
469 
470   uint public altDeposits = 0;
471   uint public start = 1525996800;
472 
473   /**
474    * @dev modifier to allow token creation only when the sale IS ON
475    */
476   modifier saleIsOn() {
477     require(now > start && now < start + 28 days);
478     _;
479   }
480 
481   /**
482    * @dev modifier to allow token creation only when the hardcap has not been reached
483    */
484   modifier isUnderHardCap() {
485     require(multisigVault.balance + altDeposits <= hardcap);
486     _;
487   }
488 
489   /**
490    * @dev Allows anyone to create tokens by depositing ether.
491    * @param recipient the recipient to receive tokens. 
492    */
493   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
494     uint rate = exchangeRate.getRate("ETH");
495     uint tokens = rate.mul(msg.value).div(1 ether);
496     token.mint(recipient, tokens);
497     require(multisigVault.send(msg.value));
498     TokenSold(recipient, msg.value, tokens, rate);
499   }
500 
501   /**
502    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
503    * @param totalAltDeposits total amount ETH equivalent
504    */
505   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
506     altDeposits = totalAltDeposits;
507   }
508 
509   /**
510    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
511    * @param recipient the recipient to receive tokens.
512    * @param tokens number of tokens to be created. 
513    */
514   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
515     token.mint(recipient, tokens);
516     AuthorizedCreate(recipient, tokens);
517   }
518   
519   function authorizedStartTrading() public onlyAuthorized {
520     token.startTrading();
521     AuthorizedStartTrading();
522   }
523   
524   /**
525    * @dev Allows authorized acces to burn tokens.
526    * @param receiver the receiver to receive tokens.
527    * @param value number of tokens to be created. 
528    */
529   function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
530     token.burn(receiver, value);
531     AuthorizedBurn(receiver, value);
532   }
533 
534   /**
535    * @dev Allows the owner to set the hardcap.
536    * @param _hardcap the new hardcap
537    */
538   function setHardCap(uint _hardcap) public onlyOwner {
539     hardcap = _hardcap;
540   }
541 
542   /**
543    * @dev Allows the owner to set the starting time.
544    * @param _start the new _start
545    */
546   function setStart(uint _start) public onlyOwner {
547     start = _start;
548   }
549 
550   /**
551    * @dev Allows the owner to set the multisig contract.
552    * @param _multisigVault the multisig contract address
553    */
554   function setMultisigVault(address _multisigVault) public onlyOwner {
555     if (_multisigVault != address(0)) {
556       multisigVault = _multisigVault;
557     }
558   }
559 
560   /**
561    * @dev Allows the owner to set the exchangerate contract.
562    * @param _exchangeRate the exchangerate address
563    */
564   function setExchangeRate(address _exchangeRate) public onlyOwner {
565     exchangeRate = ExchangeRate(_exchangeRate);
566   }
567 
568   /**
569    * @dev Allows the owner to finish the minting. This will create the 
570    * restricted tokens and then close the minting.
571    * Then the ownership of the PAY token contract is transfered 
572    * to this owner.
573    */
574   function finishMinting() public onlyOwner {
575     uint issuedTokenSupply = token.totalSupply();
576     uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
577     token.mint(multisigVault, restrictedTokens);
578     token.finishMinting();
579     token.transferOwnership(owner);
580     MainSaleClosed();
581   }
582 
583   /**
584    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
585    * @param _token the contract address of the ERC20 contract
586    */
587   function retrieveTokens(address _token) public onlyOwner {
588     ERC20 token = ERC20(_token);
589     token.transfer(multisigVault, token.balanceOf(this));
590   }
591   
592   /**
593    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
594    * msg.sender.
595    */
596   function() external payable {
597     createTokens(msg.sender);
598   }
599 
600 }