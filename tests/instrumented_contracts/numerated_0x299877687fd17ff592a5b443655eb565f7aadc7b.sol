1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to. 
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title Authorizable
48  * @dev Allows to authorize access to certain function calls
49  * 
50  * ABI
51  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
52  */
53 contract Authorizable {
54 
55   address[] authorizers;
56   mapping(address => uint) authorizerIndex;
57 
58   /**
59    * @dev Throws if called by any account that is not authorized. 
60    */
61   modifier onlyAuthorized {
62     require(isAuthorized(msg.sender));
63     _;
64   }
65 
66   /**
67    * @dev Contructor that authorizes the msg.sender. 
68    */
69   function Authorizable() {
70     authorizers.length = 2;
71     authorizers[1] = msg.sender;
72     authorizerIndex[msg.sender] = 1;
73   }
74 
75   /**
76    * @dev Function to get a specific authorizer
77    * @param authorizerIndex index of the authorizer to be retrieved.
78    * @return The address of the authorizer.
79    */
80   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
81     return address(authorizers[authorizerIndex + 1]);
82   }
83 
84   /**
85    * @dev Function to check if an address is authorized
86    * @param _addr the address to check if it is authorized.
87    * @return boolean flag if address is authorized.
88    */
89   function isAuthorized(address _addr) constant returns(bool) {
90     return authorizerIndex[_addr] > 0;
91   }
92 
93   /**
94    * @dev Function to add a new authorizer
95    * @param _addr the address to add as a new authorizer.
96    */
97   function addAuthorized(address _addr) external onlyAuthorized {
98     authorizerIndex[_addr] = authorizers.length;
99     authorizers.length++;
100     authorizers[authorizers.length - 1] = _addr;
101   }
102 
103 }
104 
105 /**
106  * @title ExchangeRate
107  * @dev Allows updating and retrieveing of Conversion Rates for OMT tokens
108  *
109  * ABI
110  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
111  */
112 contract ExchangeRate is Ownable {
113 
114   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
115 
116   mapping(bytes32 => uint) public rates;
117 
118   /**
119    * @dev Allows the current owner to update a single rate.
120    * @param _symbol The symbol to be updated. 
121    * @param _rate the rate for the symbol. 
122    */
123   function updateRate(string _symbol, uint _rate) public onlyOwner {
124     rates[sha3(_symbol)] = _rate;
125     RateUpdated(now, sha3(_symbol), _rate);
126   }
127 
128   /**
129    * @dev Allows the current owner to update multiple rates.
130    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
131    */
132   function updateRates(uint[] data) public onlyOwner {
133     if (data.length % 2 > 0)
134       throw;
135     uint i = 0;
136     while (i < data.length / 2) {
137       bytes32 symbol = bytes32(data[i * 2]);
138       uint rate = data[i * 2 + 1];
139       rates[symbol] = rate;
140       RateUpdated(now, symbol, rate);
141       i++;
142     }
143   }
144 
145   /**
146    * @dev Allows the anyone to read the current rate.
147    * @param _symbol the symbol to be retrieved. 
148    */
149   function getRate(string _symbol) public constant returns(uint) {
150     return rates[sha3(_symbol)];
151   }
152 
153 }
154 
155 /**
156  * Math operations with safety checks
157  */
158 library SafeMath {
159   function mul(uint a, uint b) internal returns (uint) {
160     uint c = a * b;
161     assert(a == 0 || c / a == b);
162     return c;
163   }
164 
165   function div(uint a, uint b) internal returns (uint) {
166     // assert(b > 0); // Solidity automatically throws when dividing by 0
167     uint c = a / b;
168     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169     return c;
170   }
171 
172   function sub(uint a, uint b) internal returns (uint) {
173     assert(b <= a);
174     return a - b;
175   }
176 
177   function add(uint a, uint b) internal returns (uint) {
178     uint c = a + b;
179     assert(c >= a);
180     return c;
181   }
182 
183   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
184     return a >= b ? a : b;
185   }
186 
187   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
188     return a < b ? a : b;
189   }
190 
191   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
192     return a >= b ? a : b;
193   }
194 
195   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
196     return a < b ? a : b;
197   }
198 
199   function assert(bool assertion) internal {
200     if (!assertion) {
201       throw;
202     }
203   }
204 }
205 
206 
207 /**
208  * @title ERC20Basic
209  * @dev Simpler version of ERC20 interface
210  * @dev see https://github.com/ethereum/EIPs/issues/20
211  */
212 contract ERC20Basic {
213   uint public totalSupply;
214   function balanceOf(address who) constant returns (uint);
215   function transfer(address to, uint value);
216   event Transfer(address indexed from, address indexed to, uint value);
217 }
218 
219 
220 
221 
222 /**
223  * @title ERC20 interface
224  * @dev see https://github.com/ethereum/EIPs/issues/20
225  */
226 contract ERC20 is ERC20Basic {
227   function allowance(address owner, address spender) constant returns (uint);
228   function transferFrom(address from, address to, uint value);
229   function approve(address spender, uint value);
230   event Approval(address indexed owner, address indexed spender, uint value);
231 }
232 
233 
234 
235 
236 /**
237  * @title Basic token
238  * @dev Basic version of StandardToken, with no allowances. 
239  */
240 contract BasicToken is ERC20Basic {
241   using SafeMath for uint;
242 
243   mapping(address => uint) balances;
244 
245   /**
246    * @dev Fix for the ERC20 short address attack.
247    */
248   modifier onlyPayloadSize(uint size) {
249      if(msg.data.length < size + 4) {
250        throw;
251      }
252      _;
253   }
254 
255   /**
256   * @dev transfer token for a specified address
257   * @param _to The address to transfer to.
258   * @param _value The amount to be transferred.
259   */
260   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
261     balances[msg.sender] = balances[msg.sender].sub(_value);
262     balances[_to] = balances[_to].add(_value);
263     Transfer(msg.sender, _to, _value);
264   }
265 
266   /**
267   * @dev Gets the balance of the specified address.
268   * @param _owner The address to query the the balance of. 
269   * @return An uint representing the amount owned by the passed address.
270   */
271   function balanceOf(address _owner) constant returns (uint balance) {
272     return balances[_owner];
273   }
274 
275 }
276 
277 
278 
279 
280 /**
281  * @title Standard ERC20 token
282  *
283  * @dev Implemantation of the basic standart token.
284  * @dev https://github.com/ethereum/EIPs/issues/20
285  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
286  */
287 contract StandardToken is BasicToken, ERC20 {
288 
289   mapping (address => mapping (address => uint)) allowed;
290 
291 
292   /**
293    * @dev Transfer tokens from one address to another
294    * @param _from address The address which you want to send tokens from
295    * @param _to address The address which you want to transfer to
296    * @param _value uint the amout of tokens to be transfered
297    */
298   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
299     var _allowance = allowed[_from][msg.sender];
300 
301     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
302     // if (_value > _allowance) throw;
303 
304     balances[_to] = balances[_to].add(_value);
305     balances[_from] = balances[_from].sub(_value);
306     allowed[_from][msg.sender] = _allowance.sub(_value);
307     Transfer(_from, _to, _value);
308   }
309 
310   /**
311    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
312    * @param _spender The address which will spend the funds.
313    * @param _value The amount of tokens to be spent.
314    */
315   function approve(address _spender, uint _value) {
316 
317     // To change the approve amount you first have to reduce the addresses`
318     //  allowance to zero by calling `approve(_spender, 0)` if it is not
319     //  already 0 to mitigate the race condition described here:
320     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
321     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
322 
323     allowed[msg.sender][_spender] = _value;
324     Approval(msg.sender, _spender, _value);
325   }
326 
327   /**
328    * @dev Function to check the amount of tokens than an owner allowed to a spender.
329    * @param _owner address The address which owns the funds.
330    * @param _spender address The address which will spend the funds.
331    * @return A uint specifing the amount of tokens still avaible for the spender.
332    */
333   function allowance(address _owner, address _spender) constant returns (uint remaining) {
334     return allowed[_owner][_spender];
335   }
336 
337 }
338 
339 
340 
341 
342 
343 
344 /**
345  * @title Mintable token
346  * @dev Simple ERC20 Token example, with mintable token creation
347  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
348  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
349  */
350 
351 contract MintableToken is StandardToken, Ownable {
352   event Mint(address indexed to, uint value);
353   event MintFinished();
354 
355   bool public mintingFinished = false;
356   uint public totalSupply = 0;
357 
358 
359   modifier canMint() {
360     if(mintingFinished) throw;
361     _;
362   }
363 
364   /**
365    * @dev Function to mint tokens
366    * @param _to The address that will recieve the minted tokens.
367    * @param _amount The amount of tokens to mint.
368    * @return A boolean that indicates if the operation was successful.
369    */
370   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
371     totalSupply = totalSupply.add(_amount);
372     balances[_to] = balances[_to].add(_amount);
373     Mint(_to, _amount);
374     return true;
375   }
376 
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() onlyOwner returns (bool) {
382     mintingFinished = true;
383     MintFinished();
384     return true;
385   }
386 }
387 
388 
389 /**
390  * @title OMToken
391  * @dev The main OMT token contract
392  * 
393  * ABI 
394  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
395  */
396 contract OMToken is MintableToken {
397 
398   string public name = "OMToken";
399   string public symbol = "OMT";
400   uint public decimals = 18;
401 
402   bool public tradingStarted = false;
403 
404   /**
405    * @dev modifier that throws if trading has not started yet
406    */
407   modifier hasStartedTrading() {
408     require(tradingStarted);
409     _;
410   }
411 
412   /**
413    * @dev Allows the owner to enable the trading. This can not be undone
414    */
415   function startTrading() onlyOwner {
416     tradingStarted = true;
417   }
418 
419   /**
420    * @dev Allows anyone to transfer the OMT tokens once trading has started
421    * @param _to the recipient address of the tokens. 
422    * @param _value number of tokens to be transfered. 
423    */
424   function transfer(address _to, uint _value) hasStartedTrading {
425     super.transfer(_to, _value);
426   }
427 
428    /**
429    * @dev Allows anyone to transfer the OMT tokens once trading has started
430    * @param _from address The address which you want to send tokens from
431    * @param _to address The address which you want to transfer to
432    * @param _value uint the amout of tokens to be transfered
433    */
434   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
435     super.transferFrom(_from, _to, _value);
436   }
437 }
438 
439 /**
440  * @title MainSale
441  * @dev The main OMToken sale contract
442  * 
443  * ABI
444  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
445  */
446 contract MainSale is Ownable, Authorizable {
447   using SafeMath for uint;
448   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
449   event AuthorizedCreate(address recipient, uint pay_amount);
450   event MainSaleClosed();
451 
452   OMToken public token = new OMToken();
453 
454   address public multisigVault;
455 
456   uint hardcap = 40000 ether;
457   ExchangeRate public exchangeRate;
458 
459   uint public altDeposits = 0;
460   uint public start = 1518598800; //new Date("Feb 14 2018 09:00:00 GMT").getTime() / 1000
461 
462   /**
463    * @dev modifier to allow token creation only when the sale IS ON
464    */
465   modifier saleIsOn() {
466     require(now > start && now < start + 365 days);
467     _;
468   }
469 
470   /**
471    * @dev modifier to allow token creation only when the hardcap has not been reached
472    */
473   modifier isUnderHardCap() {
474     require(multisigVault.balance + altDeposits <= hardcap);
475     _;
476   }
477 
478   /**
479    * @dev Allows anyone to create tokens by depositing ether.
480    * @param recipient the recipient to receive tokens. 
481    */
482   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
483     uint rate = exchangeRate.getRate("ETH");
484     uint tokens = rate.mul(msg.value).div(1 ether);
485     token.mint(recipient, tokens);
486     require(multisigVault.send(msg.value));
487     TokenSold(recipient, msg.value, tokens, rate);
488   }
489   
490   /**
491    * @dev Allows to set the total alt deposit measured in ETH to make sure the hardcap includes other deposits
492    * @param totalAltDeposits total amount ETH equivalent
493    */
494   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
495     altDeposits = totalAltDeposits;
496   }
497 
498   /**
499    * @dev Allows authorized access to create tokens. This is used for Bitcoin and ERC20 deposits
500    * @param recipient the recipient to receive tokens.
501    * @param tokens number of tokens to be created. 
502    */
503   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
504     token.mint(recipient, tokens);
505     AuthorizedCreate(recipient, tokens);
506   }
507 
508   /**
509    * @dev Allows the owner to set the hardcap.
510    * @param _hardcap the new hardcap
511    */
512   function setHardCap(uint _hardcap) public onlyOwner {
513     hardcap = _hardcap;
514   }
515 
516   /**
517    * @dev Allows the owner to set the starting time.
518    * @param _start the new _start
519    */
520   function setStart(uint _start) public onlyOwner {
521     start = _start;
522   }
523 
524   /**
525    * @dev Allows the owner to set the multisig contract.
526    * @param _multisigVault the multisig contract address
527    */
528   function setMultisigVault(address _multisigVault) public onlyOwner {
529     if (_multisigVault != address(0)) {
530       multisigVault = _multisigVault;
531     }
532   }
533 
534   /**
535    * @dev Allows the owner to set the exchangerate contract.
536    * @param _exchangeRate the exchangerate address
537    */
538   function setExchangeRate(address _exchangeRate) public onlyOwner {
539     exchangeRate = ExchangeRate(_exchangeRate);
540   }
541 
542   /**
543    * @dev Allows the owner to finish the minting. This will create the 
544    * restricted tokens and then close the minting.
545    * Then the ownership of the OMT token contract is transfered 
546    * to this owner.
547    */
548   function finishMinting() public onlyOwner {
549     uint issuedTokenSupply = token.totalSupply();
550     uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
551     token.mint(multisigVault, restrictedTokens);
552     token.finishMinting();
553     token.transferOwnership(owner);
554     MainSaleClosed();
555   }
556 
557   /**
558    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
559    * @param _token the contract address of the ERC20 contract
560    */
561   function retrieveTokens(address _token) public onlyOwner {
562     ERC20 token = ERC20(_token);
563     token.transfer(multisigVault, token.balanceOf(this));
564   }
565 
566   /**
567    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
568    * msg.sender.
569    */
570   function() external payable {
571     createTokens(msg.sender);
572   }
573 
574 }