1 pragma solidity ^0.4.16;
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
27       revert();
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
81 /*
82   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
83     return address(authorizers[authorizerIndex + 1]);
84   }
85 */
86   /**
87    * @dev Function to check if an address is authorized
88    * @param _addr the address to check if it is authorized.
89    * @return boolean flag if address is authorized.
90    */
91   function isAuthorized(address _addr) constant returns(bool) {
92     return authorizerIndex[_addr] > 0;
93   }
94 
95   /**
96    * @dev Function to add a new authorizer
97    * @param _addr the address to add as a new authorizer.
98    */
99   function addAuthorized(address _addr) external onlyAuthorized {
100     authorizerIndex[_addr] = authorizers.length;
101     authorizers.length++;
102     authorizers[authorizers.length - 1] = _addr;
103   }
104 
105 }
106 
107 /**
108  * @title ExchangeRate
109  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
110  *
111  * ABI
112  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
113  */
114 contract ExchangeRate is Ownable {
115 
116   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
117 
118   mapping(bytes32 => uint) public rates;
119 
120   /**
121    * @dev Allows the current owner to update a single rate.
122    * @param _symbol The symbol to be updated. 
123    * @param _rate the rate for the symbol. 
124    */
125   function updateRate(string _symbol, uint _rate) public onlyOwner {
126     rates[sha3(_symbol)] = _rate;
127     RateUpdated(now, sha3(_symbol), _rate);
128   }
129 
130   /**
131    * @dev Allows the current owner to update multiple rates.
132    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
133    */
134   function updateRates(uint[] data) public onlyOwner {
135     if (data.length % 2 > 0)
136       revert();
137     uint i = 0;
138     while (i < data.length / 2) {
139       bytes32 symbol = bytes32(data[i * 2]);
140       uint rate = data[i * 2 + 1];
141       rates[symbol] = rate;
142       RateUpdated(now, symbol, rate);
143       i++;
144     }
145   }
146 
147   /**
148    * @dev Allows the anyone to read the current rate.
149    * @param _symbol the symbol to be retrieved. 
150    */
151   function getRate(string _symbol) public constant returns(uint) {
152     return rates[sha3(_symbol)];
153   }
154 
155 }
156 
157 /**
158  * Math operations with safety checks
159  */
160 library SafeMath {
161   function mul(uint a, uint b) internal returns (uint) {
162     uint c = a * b;
163     assert(a == 0 || c / a == b);
164     return c;
165   }
166 
167   function div(uint a, uint b) internal returns (uint) {
168     // assert(b > 0); // Solidity automatically revert()s when dividing by 0
169     uint c = a / b;
170     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171     return c;
172   }
173 
174   function sub(uint a, uint b) internal returns (uint) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   function add(uint a, uint b) internal returns (uint) {
180     uint c = a + b;
181     assert(c >= a);
182     return c;
183   }
184 
185   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
186     return a >= b ? a : b;
187   }
188 
189   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
190     return a < b ? a : b;
191   }
192 
193   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
194     return a >= b ? a : b;
195   }
196 
197   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
198     return a < b ? a : b;
199   }
200 
201 /* function assert(bool assertion) internal { */
202     /*   if (!assertion) { */
203     /*     throw; */
204     /*   } */
205     /* }      // assert no longer needed once solidity is on 0.4.10 */
206 }
207 
208 
209 /**
210  * @title ERC20Basic
211  * @dev Simpler version of ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 contract ERC20Basic {
215   uint public totalSupply;
216   function balanceOf(address who) constant returns (uint);
217   function transfer(address to, uint value);
218   event Transfer(address indexed from, address indexed to, uint value);
219 }
220 
221 
222 
223 
224 /**
225  * @title ERC20 interface
226  * @dev see https://github.com/ethereum/EIPs/issues/20
227  */
228 contract ERC20 is ERC20Basic {
229   function allowance(address owner, address spender) constant returns (uint);
230   function transferFrom(address from, address to, uint value);
231   function approve(address spender, uint value);
232   event Approval(address indexed owner, address indexed spender, uint value);
233 }
234 
235 
236 
237 
238 /**
239  * @title Basic token
240  * @dev Basic version of StandardToken, with no allowances. 
241  */
242 contract BasicToken is ERC20Basic {
243   using SafeMath for uint;
244 
245   mapping(address => uint) balances;
246 
247   /**
248    * @dev Fix for the ERC20 short address attack.
249    */
250   modifier onlyPayloadSize(uint size) {
251      if(msg.data.length < size + 4) {
252        revert();
253      }
254      _;
255   }
256 
257   /**
258   * @dev transfer token for a specified address
259   * @param _to The address to transfer to.
260   * @param _value The amount to be transferred.
261   */
262   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
263     balances[msg.sender] = balances[msg.sender].sub(_value);
264     balances[_to] = balances[_to].add(_value);
265     Transfer(msg.sender, _to, _value);
266   }
267 
268   /**
269   * @dev Gets the balance of the specified address.
270   * @param _owner The address to query the the balance of. 
271   * @return An uint representing the amount owned by the passed address.
272   */
273   function balanceOf(address _owner) constant returns (uint balance) {
274     return balances[_owner];
275   }
276 
277 }
278 
279 
280 
281 
282 /**
283  * @title Standard ERC20 token
284  *
285  * @dev Implemantation of the basic standart token.
286  * @dev https://github.com/ethereum/EIPs/issues/20
287  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
288  */
289 contract StandardToken is BasicToken, ERC20 {
290 
291   mapping (address => mapping (address => uint)) allowed;
292 
293 
294   /**
295    * @dev Transfer tokens from one address to another
296    * @param _from address The address which you want to send tokens from
297    * @param _to address The address which you want to transfer to
298    * @param _value uint the amout of tokens to be transfered
299    */
300   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
301     var _allowance = allowed[_from][msg.sender];
302 
303     // Check is not needed because sub(_allowance, _value) will already revert() if this condition is not met
304     // if (_value > _allowance) revert();
305 
306     balances[_to] = balances[_to].add(_value);
307     balances[_from] = balances[_from].sub(_value);
308     allowed[_from][msg.sender] = _allowance.sub(_value);
309     Transfer(_from, _to, _value);
310   }
311 
312   /**
313    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
314    * @param _spender The address which will spend the funds.
315    * @param _value The amount of tokens to be spent.
316    */
317   function approve(address _spender, uint _value) {
318 
319     // To change the approve amount you first have to reduce the addresses`
320     //  allowance to zero by calling `approve(_spender, 0)` if it is not
321     //  already 0 to mitigate the race condition described here:
322     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
323     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
324 
325     allowed[msg.sender][_spender] = _value;
326     Approval(msg.sender, _spender, _value);
327   }
328 
329   /**
330    * @dev Function to check the amount of tokens than an owner allowed to a spender.
331    * @param _owner address The address which owns the funds.
332    * @param _spender address The address which will spend the funds.
333    * @return A uint specifing the amount of tokens still avaible for the spender.
334    */
335   function allowance(address _owner, address _spender) constant returns (uint remaining) {
336     return allowed[_owner][_spender];
337   }
338 
339 }
340 
341 
342 
343 
344 
345 
346 /**
347  * @title Mintable token
348  * @dev Simple ERC20 Token example, with mintable token creation
349  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
350  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
351  */
352 
353 contract MintableToken is StandardToken, Ownable {
354   event Mint(address indexed to, uint value);
355   event MintFinished();
356 
357   bool public mintingFinished = false;
358   uint public totalSupply = 0;
359 
360 
361   modifier canMint() {
362     if(mintingFinished) revert();
363     _;
364   }
365 
366   /**
367    * @dev Function to mint tokens
368    * @param _to The address that will recieve the minted tokens.
369    * @param _amount The amount of tokens to mint.
370    * @return A boolean that indicates if the operation was successful.
371    */
372   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
373     totalSupply = totalSupply.add(_amount);
374     balances[_to] = balances[_to].add(_amount);
375     Mint(_to, _amount);
376     return true;
377   }
378 
379   /**
380    * @dev Function to stop minting new tokens.
381    * @return True if the operation was successful.
382    */
383   function finishMinting() onlyOwner returns (bool) {
384     mintingFinished = true;
385     MintFinished();
386     return true;
387   }
388 }
389 
390 
391 /**
392  * @title PayToken
393  * @dev The main PAY token contract
394  * 
395  * ABI 
396  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
397  */
398 contract JobcoinToken is MintableToken {
399 
400   string public name = "Jobcoin Token";
401   string public symbol = "JCT";
402   uint public decimals = 18;
403 
404   bool public tradingStarted = false;
405 
406   /**
407    * @dev modifier that revert()s if trading has not started yet
408    */
409   modifier hasStartedTrading() {
410     require(tradingStarted);
411     _;
412   }
413 
414   /**
415    * @dev Allows the owner to enable the trading. This can not be undone
416    */
417   function startTrading() onlyOwner {
418     tradingStarted = true;
419   }
420 
421   /**
422    * @dev Allows anyone to transfer the PAY tokens once trading has started
423    * @param _to the recipient address of the tokens. 
424    * @param _value number of tokens to be transfered. 
425    */
426   function transfer(address _to, uint _value) hasStartedTrading {
427     super.transfer(_to, _value);
428   }
429 
430    /**
431    * @dev Allows anyone to transfer the PAY tokens once trading has started
432    * @param _from address The address which you want to send tokens from
433    * @param _to address The address which you want to transfer to
434    * @param _value uint the amout of tokens to be transfered
435    */
436   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
437     super.transferFrom(_from, _to, _value);
438   }
439 
440 }
441 
442 
443 /**
444  * @title MainSale
445  * @dev The main PAY token sale contract
446  * 
447  * ABI
448  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
449  */
450 contract MainSale is Ownable, Authorizable {
451   using SafeMath for uint;
452   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
453   event AuthorizedCreate(address recipient, uint pay_amount);
454   event MainSaleClosed();
455 
456   JobcoinToken public token = new JobcoinToken();
457 
458   address public multisigVault;
459 
460   uint hardcap = 200000 ether;
461   ExchangeRate public exchangeRate;
462 
463   uint public altDeposits = 0;
464   uint public start = 1498302000; //new Date("Jun 24 2017 11:00:00 GMT").getTime() / 1000
465 
466   /**
467    * @dev modifier to allow token creation only when the sale IS ON
468    */
469   modifier saleIsOn() {
470     require(now > start && now < start + 28 days);
471     _;
472   }
473 
474   /**
475    * @dev modifier to allow token creation only when the hardcap has not been reached
476    */
477   modifier isUnderHardCap() {
478     require(multisigVault.balance + altDeposits <= hardcap);
479     _;
480   }
481 
482   /**
483    * @dev Allows anyone to create tokens by depositing ether.
484    * @param recipient the recipient to receive tokens. 
485    */
486   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
487     uint rate = exchangeRate.getRate("ETH");
488     uint tokens = rate.mul(msg.value).div(1 ether);
489     token.mint(recipient, tokens);
490     require(multisigVault.send(msg.value));
491     TokenSold(recipient, msg.value, tokens, rate);
492   }
493 
494 
495   /**
496    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
497    * @param totalAltDeposits total amount ETH equivalent
498    */
499   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
500     altDeposits = totalAltDeposits;
501   }
502 
503   /**
504    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
505    * @param recipient the recipient to receive tokens.
506    * @param tokens number of tokens to be created. 
507    */
508   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
509     token.mint(recipient, tokens);
510     AuthorizedCreate(recipient, tokens);
511   }
512 
513   /**
514    * @dev Allows the owner to set the hardcap.
515    * @param _hardcap the new hardcap
516    */
517   function setHardCap(uint _hardcap) public onlyOwner {
518     hardcap = _hardcap;
519   }
520 
521   /**
522    * @dev Allows the owner to set the starting time.
523    * @param _start the new _start
524    */
525   function setStart(uint _start) public onlyOwner {
526     start = _start;
527   }
528 
529   /**
530    * @dev Allows the owner to set the multisig contract.
531    * @param _multisigVault the multisig contract address
532    */
533   function setMultisigVault(address _multisigVault) public onlyOwner {
534     if (_multisigVault != address(0)) {
535       multisigVault = _multisigVault;
536     }
537   }
538 
539   /**
540    * @dev Allows the owner to set the exchangerate contract.
541    * @param _exchangeRate the exchangerate address
542    */
543   function setExchangeRate(address _exchangeRate) public onlyOwner {
544     exchangeRate = ExchangeRate(_exchangeRate);
545   }
546 
547   /**
548    * @dev Allows the owner to finish the minting. This will create the 
549    * restricted tokens and then close the minting.
550    * Then the ownership of the PAY token contract is transfered 
551    * to this owner.
552    */
553   function finishMinting() public onlyOwner {
554     uint issuedTokenSupply = token.totalSupply();
555     uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
556     token.mint(multisigVault, restrictedTokens);
557     token.finishMinting();
558     token.transferOwnership(owner);
559     MainSaleClosed();
560   }
561 
562   /**
563    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
564    * @param _token the contract address of the ERC20 contract
565    */
566 /*
567   function retrieveTokens(address _token) public onlyOwner {
568     ERC20 token = ERC20(_token);
569     token.transfer(multisigVault, token.balanceOf(this));
570   }
571 */
572 
573   /**
574    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
575    * msg.sender.
576    */
577   function() external payable {
578     createTokens(msg.sender);
579   }
580 
581 }