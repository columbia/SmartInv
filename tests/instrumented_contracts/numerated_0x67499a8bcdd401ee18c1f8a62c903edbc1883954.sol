1 pragma solidity ^0.4.11;
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
17   function Ownable() {
18     owner = msg.sender;
19   }
20  
21  
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       return;
28     }
29     _;
30   }
31  
32  
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to. 
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42  
43 }
44  
45  
46  
47 /**
48  * @title Authorizable
49  * @dev Allows to authorize access to certain function calls
50  * 
51  * ABI
52  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
53  */
54 contract Authorizable {
55  
56   address[] authorizers;
57   mapping(address => uint) authorizerIndex;
58  
59   /**
60    * @dev Throws if called by any account tat is not authorized. 
61    */
62   modifier onlyAuthorized {
63     require(isAuthorized(msg.sender));
64     _;
65   }
66  
67   /**
68    * @dev Contructor that authorizes the msg.sender. 
69    */
70   function Authorizable() {
71     authorizers.length = 2;
72     authorizers[1] = msg.sender;
73     authorizerIndex[msg.sender] = 1;
74   }
75  
76   /**
77    * @dev Function to get a specific authorizer
78    * @param authorizerIndex index of the authorizer to be retrieved.
79    * @return The address of the authorizer.
80    */
81   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
82     return address(authorizers[authorizerIndex + 1]);
83   }
84  
85   /**
86    * @dev Function to check if an address is authorized
87    * @param _addr the address to check if it is authorized.
88    * @return boolean flag if address is authorized.
89    */
90   function isAuthorized(address _addr) constant returns(bool) {
91     return authorizerIndex[_addr] > 0;
92   }
93  
94   /**
95    * @dev Function to add a new authorizer
96    * @param _addr the address to add as a new authorizer.
97    */
98   function addAuthorized(address _addr) external onlyAuthorized {
99     authorizerIndex[_addr] = authorizers.length;
100     authorizers.length++;
101     authorizers[authorizers.length - 1] = _addr;
102   }
103  
104 }
105  
106 /**
107  * @title ExchangeRate
108  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
109  *
110  * ABI
111  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
112  */
113 contract ExchangeRate is Ownable {
114  
115   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
116  
117   mapping(bytes32 => uint) public rates;
118  
119   /**
120    * @dev Allows the current owner to update a single rate.
121    * @param _symbol The symbol to be updated. 
122    * @param _rate the rate for the symbol. 
123    */
124   function updateRate(string _symbol, uint _rate) public onlyOwner {
125     rates[sha3(_symbol)] = _rate;
126     RateUpdated(now, sha3(_symbol), _rate);
127   }
128  
129   /**
130    * @dev Allows the current owner to update multiple rates.
131    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
132    */
133   function updateRates(uint[] data) public onlyOwner {
134     if (data.length % 2 > 0)
135       return;
136     uint i = 0;
137     while (i < data.length / 2) {
138       bytes32 symbol = bytes32(data[i * 2]);
139       uint rate = data[i * 2 + 1];
140       rates[symbol] = rate;
141       RateUpdated(now, symbol, rate);
142       i++;
143     }
144   }
145  
146   /**
147    * @dev Allows the anyone to read the current rate.
148    * @param _symbol the symbol to be retrieved. 
149    */
150   function getRate(string _symbol) public constant returns(uint) {
151     return rates[sha3(_symbol)];
152   }
153  
154 }
155  
156 /**
157  * Math operations with safety checks
158  */
159 library SafeMath {
160   function mul(uint a, uint b) internal returns (uint) {
161     uint c = a * b;
162     assert(a == 0 || c / a == b);
163     return c;
164   }
165  
166   function div(uint a, uint b) internal returns (uint) {
167     // assert(b > 0); // Solidity automatically throws when dividing by 0
168     uint c = a / b;
169     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170     return c;
171   }
172  
173   function sub(uint a, uint b) internal returns (uint) {
174     assert(b <= a);
175     return a - b;
176   }
177  
178   function add(uint a, uint b) internal returns (uint) {
179     uint c = a + b;
180     assert(c >= a);
181     return c;
182   }
183  
184   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
185     return a >= b ? a : b;
186   }
187  
188   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
189     return a < b ? a : b;
190   }
191  
192   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
193     return a >= b ? a : b;
194   }
195  
196   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
197     return a < b ? a : b;
198   }
199  
200   function assert(bool assertion) internal {
201     if (!assertion) {
202       return;
203     }
204   }
205 }
206  
207  
208 /**
209  * @title ERC20Basic
210  * @dev Simpler version of ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 contract ERC20Basic {
214   uint public totalSupply;
215   function balanceOf(address who) constant returns (uint);
216   function transfer(address to, uint value);
217   event Transfer(address indexed from, address indexed to, uint value);
218 }
219  
220  
221  
222  
223 /**
224  * @title ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20 is ERC20Basic {
228   function allowance(address owner, address spender) constant returns (uint);
229   function transferFrom(address from, address to, uint value);
230   function approve(address spender, uint value);
231   event Approval(address indexed owner, address indexed spender, uint value);
232 }
233  
234  
235  
236  
237 /**
238  * @title Basic token
239  * @dev Basic version of StandardToken, with no allowances. 
240  */
241 contract BasicToken is ERC20Basic {
242   using SafeMath for uint;
243  
244   mapping(address => uint) balances;
245  
246   /**
247    * @dev Fix for the ERC20 short address attack.
248    */
249   modifier onlyPayloadSize(uint size) {
250      if(msg.data.length < size + 4) {
251        return;
252      }
253      _;
254   }
255  
256   /**
257   * @dev transfer token for a specified address
258   * @param _to The address to transfer to.
259   * @param _value The amount to be transferred.
260   */
261   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
262     balances[msg.sender] = balances[msg.sender].sub(_value);
263     balances[_to] = balances[_to].add(_value);
264     Transfer(msg.sender, _to, _value);
265   }
266  
267   /**
268   * @dev Gets the balance of the specified address.
269   * @param _owner The address to query the the balance of. 
270   * @return An uint representing the amount owned by the passed address.
271   */
272   function balanceOf(address _owner) constant returns (uint balance) {
273     return balances[_owner];
274   }
275  
276 }
277  
278  
279  
280  
281 /**
282  * @title Standard ERC20 token
283  *
284  * @dev Implemantation of the basic standart token.
285  * @dev https://github.com/ethereum/EIPs/issues/20
286  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
287  */
288 contract StandardToken is BasicToken, ERC20 {
289  
290   mapping (address => mapping (address => uint)) allowed;
291  
292  
293   /**
294    * @dev Transfer tokens from one address to another
295    * @param _from address The address which you want to send tokens from
296    * @param _to address The address which you want to transfer to
297    * @param _value uint the amout of tokens to be transfered
298    */
299   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
300     var _allowance = allowed[_from][msg.sender];
301  
302     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
303     // if (_value > _allowance) throw;
304  
305     balances[_to] = balances[_to].add(_value);
306     balances[_from] = balances[_from].sub(_value);
307     allowed[_from][msg.sender] = _allowance.sub(_value);
308     Transfer(_from, _to, _value);
309   }
310  
311   /**
312    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
313    * @param _spender The address which will spend the funds.
314    * @param _value The amount of tokens to be spent.
315    */
316   function approve(address _spender, uint _value) {
317  
318     // To change the approve amount you first have to reduce the addresses`
319     //  allowance to zero by calling `approve(_spender, 0)` if it is not
320     //  already 0 to mitigate the race condition described here:
321     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) return;
323  
324     allowed[msg.sender][_spender] = _value;
325     Approval(msg.sender, _spender, _value);
326   }
327  
328   /**
329    * @dev Function to check the amount of tokens than an owner allowed to a spender.
330    * @param _owner address The address which owns the funds.
331    * @param _spender address The address which will spend the funds.
332    * @return A uint specifing the amount of tokens still avaible for the spender.
333    */
334   function allowance(address _owner, address _spender) constant returns (uint remaining) {
335     return allowed[_owner][_spender];
336   }
337  
338 }
339  
340  
341  
342  
343  
344  
345 /**
346  * @title Mintable token
347  * @dev Simple ERC20 Token example, with mintable token creation
348  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
349  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
350  */
351  
352 contract MintableToken is StandardToken, Ownable {
353   event Mint(address indexed to, uint value);
354   event MintFinished();
355  
356   bool public mintingFinished = false;
357   uint public totalSupply = 0;
358  
359  
360   modifier canMint() {
361     if(mintingFinished) return;
362     _;
363   }
364  
365   /**
366    * @dev Function to mint tokens
367    * @param _to The address that will recieve the minted tokens.
368    * @param _amount The amount of tokens to mint.
369    * @return A boolean that indicates if the operation was successful.
370    */
371   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
372     totalSupply = totalSupply.add(_amount);
373     balances[_to] = balances[_to].add(_amount);
374     Mint(_to, _amount);
375     return true;
376   }
377  
378   /**
379    * @dev Function to stop minting new tokens.
380    * @return True if the operation was successful.
381    */
382   function finishMinting() onlyOwner returns (bool) {
383     mintingFinished = true;
384     MintFinished();
385     return true;
386   }
387 }
388  
389  
390 /**
391  * @title PayToken
392  * @dev The main PAY token contract
393  * 
394  * ABI 
395  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
396  */
397 contract FoxToken is MintableToken {
398  
399   string public name = "Fox Token";
400   string public symbol = "FOX";
401   uint public decimals = 18;
402  
403   bool public tradingStarted = false;
404  
405   /**
406    * @dev modifier that throws if trading has not started yet
407    */
408   modifier hasStartedTrading() {
409     require(tradingStarted);
410     _;
411   }
412  
413   /**
414    * @dev Allows the owner to enable the trading. This can not be undone
415    */
416   function startTrading() onlyOwner {
417     tradingStarted = true;
418   }
419  
420   /**
421    * @dev Allows anyone to transfer the PAY tokens once trading has started
422    * @param _to the recipient address of the tokens. 
423    * @param _value number of tokens to be transfered. 
424    */
425   function transfer(address _to, uint _value) hasStartedTrading {
426     super.transfer(_to, _value);
427   }
428  
429    /**
430    * @dev Allows anyone to transfer the PAY tokens once trading has started
431    * @param _from address The address which you want to send tokens from
432    * @param _to address The address which you want to transfer to
433    * @param _value uint the amout of tokens to be transfered
434    */
435   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
436     super.transferFrom(_from, _to, _value);
437   }
438  
439 }
440  
441  
442 /**
443  * @title MainSale
444  * @dev The main PAY token sale contract
445  * 
446  * ABI
447  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
448  */
449 contract MainSale is Ownable, Authorizable {
450   using SafeMath for uint;
451   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
452   event AuthorizedCreate(address recipient, uint pay_amount);
453   event MainSaleClosed();
454  
455   FoxToken public token = new FoxToken();
456  
457   address public multisigVault;
458  
459   uint hardcap = 2000 ether;
460   ExchangeRate public exchangeRate;
461  
462   uint public altDeposits = 0;
463   uint public start = 1502022597; //new Date("Jun 24 2017 11:00:00 GMT").getTime() / 1000
464  
465   /**
466    * @dev modifier to allow token creation only when the sale IS ON
467    */
468   modifier saleIsOn() {
469     require(now > start && now < start + 60 days);
470     _;
471   }
472  
473   /**
474    * @dev modifier to allow token creation only when the hardcap has not been reached
475    */
476   modifier isUnderHardCap() {
477     require(multisigVault.balance + altDeposits <= hardcap);
478     _;
479   }
480  
481   /**
482    * @dev Allows anyone to create tokens by depositing ether.
483    * @param recipient the recipient to receive tokens. 
484    */
485   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
486     uint rate = exchangeRate.getRate("ETH");
487     uint tokens = rate.mul(msg.value).div(1 ether);
488     token.mint(recipient, tokens);
489     require(multisigVault.send(msg.value));
490     TokenSold(recipient, msg.value, tokens, rate);
491   }
492  
493  
494   /**
495    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
496    * @param totalAltDeposits total amount ETH equivalent
497    */
498   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
499     altDeposits = totalAltDeposits;
500   }
501  
502   /**
503    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
504    * @param recipient the recipient to receive tokens.
505    * @param tokens number of tokens to be created. 
506    */
507   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
508     token.mint(recipient, tokens);
509     AuthorizedCreate(recipient, tokens);
510   }
511  
512   /**
513    * @dev Allows the owner to set the hardcap.
514    * @param _hardcap the new hardcap
515    */
516   function setHardCap(uint _hardcap) public onlyOwner {
517     hardcap = _hardcap;
518   }
519  
520   /**
521    * @dev Allows the owner to set the starting time.
522    * @param _start the new _start
523    */
524   function setStart(uint _start) public onlyOwner {
525     start = _start;
526   }
527  
528   /**
529    * @dev Allows the owner to set the multisig contract.
530    * @param _multisigVault the multisig contract address
531    */
532   function setMultisigVault(address _multisigVault) public onlyOwner {
533     if (_multisigVault != address(0)) {
534       multisigVault = _multisigVault;
535     }
536   }
537  
538   /**
539    * @dev Allows the owner to set the exchangerate contract.
540    * @param _exchangeRate the exchangerate address
541    */
542   function setExchangeRate(address _exchangeRate) public onlyOwner {
543     exchangeRate = ExchangeRate(_exchangeRate);
544   }
545  
546   /**
547    * @dev Allows the owner to finish the minting. This will create the 
548    * restricted tokens and then close the minting.
549    * Then the ownership of the PAY token contract is transfered 
550    * to this owner.
551    */
552   function finishMinting() public onlyOwner {
553     uint issuedTokenSupply = token.totalSupply();
554     uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
555     token.mint(multisigVault, restrictedTokens);
556     token.finishMinting();
557     token.transferOwnership(owner);
558     MainSaleClosed();
559   }
560  
561   /**
562    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
563    * @param _token the contract address of the ERC20 contract
564    */
565   function retrieveTokens(address _token) public onlyOwner {
566     ERC20 token = ERC20(_token);
567     token.transfer(multisigVault, token.balanceOf(this));
568   }
569  
570   /**
571    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
572    * msg.sender.
573    */
574   function() external payable {
575     createTokens(msg.sender);
576   }
577  
578 }