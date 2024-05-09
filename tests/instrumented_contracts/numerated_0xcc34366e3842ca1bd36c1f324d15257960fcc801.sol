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
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     owner = newOwner;
38   }
39 
40 }
41 
42 /**
43  * @title Authorizable
44  * @dev Allows to authorize access to certain function calls
45  */
46 contract Authorizable is Ownable {
47 
48   address[] authorizers;
49   mapping(address => uint) authorizerIndex;
50 
51   /**
52    * @dev Throws if called by any account tat is not authorized.
53    */
54   modifier onlyAuthorized {
55     require(isAuthorized(msg.sender));
56     _;
57   }
58 
59   /**
60    * @dev Contructor that authorizes the msg.sender.
61    */
62   function Authorizable() public {
63     authorizers.length = 2;
64     authorizers[1] = msg.sender;
65     authorizerIndex[msg.sender] = 1;
66   }
67 
68   /**
69    * @dev Function to get a specific authorizer
70    * @param _authorizerIndex index of the authorizer to be retrieved.
71    * @return The address of the authorizer.
72    */
73   function getAuthorizer(uint _authorizerIndex) external constant returns(address) {
74     return address(authorizers[_authorizerIndex + 1]);
75   }
76 
77   /**
78    * @dev Function to check if an address is authorized
79    * @param _addr the address to check if it is authorized.
80    * @return boolean flag if address is authorized.
81    */
82   function isAuthorized(address _addr) public constant returns(bool) {
83     return authorizerIndex[_addr] > 0;
84   }
85 
86   /**
87    * @dev Function to add a new authorizer
88    * @param _addr the address to add as a new authorizer.
89    */
90   function addAuthorized(address _addr) external onlyOwner {
91     authorizerIndex[_addr] = authorizers.length;
92     authorizers.length++;
93     authorizers[authorizers.length - 1] = _addr;
94   }
95 
96 }
97 
98 /**
99  * @title ExchangeRate
100  * @dev Allows updating and retrieveing of Conversion Rates for BON tokens
101  *
102  * ABI
103  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"view"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
104  */
105 contract ExchangeRate is Ownable, Authorizable {
106 
107   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
108 
109   mapping(bytes32 => uint) public rates;
110 
111   /**
112    * @dev Allows the current owner to update a single rate.
113    * @param _symbol The symbol to be updated.
114    * @param _rate the rate for the symbol.
115    */
116   function updateRate(string _symbol, uint _rate) public onlyAuthorized {
117     rates[keccak256(_symbol)] = _rate;
118     RateUpdated(now, keccak256(_symbol), _rate);
119   }
120 
121   /**
122    * @dev Allows the current owner to update multiple rates.
123    * Rate name should be hashed by keccak256: https://emn178.github.io/online-tools/keccak_256.html
124    * [
125    *   "0x9696f33f18e6c2c578fe917dd3f5e1613cc0add242942840b709f9ec392cfc46",1234567,
126    *   "0x8f6c75b19293b5703037f47598d72a91641249e6ecec91fa499fb6d66a92e867",54321
127    * ]
128    * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
129    */
130   function updateRates(uint[] data) public onlyAuthorized {
131     require(data.length % 2 == 0);
132     uint i = 0;
133     while (i < data.length / 2) {
134       bytes32 symbol = bytes32(data[i * 2]);
135       uint rate = data[i * 2 + 1];
136       rates[symbol] = rate;
137       RateUpdated(now, symbol, rate);
138       i++;
139     }
140   }
141 
142   /**
143    * @dev Allows the anyone to read the current rate.
144    * @param _symbol the symbol to be retrieved.
145    */
146   function getRate(string _symbol) public constant returns(uint) {
147     return rates[keccak256(_symbol)];
148   }
149 
150 }
151 
152 /**
153  * Math operations with safety checks
154  */
155 library SafeMath {
156   function mul(uint a, uint b) internal returns (uint) {
157     uint c = a * b;
158     assert(a == 0 || c / a == b);
159     return c;
160   }
161 
162   function div(uint a, uint b) internal returns (uint) {
163     // assert(b > 0); // Solidity automatically throws when dividing by 0
164     uint c = a / b;
165     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166     return c;
167   }
168 
169   function sub(uint a, uint b) internal returns (uint) {
170     assert(b <= a);
171     return a - b;
172   }
173 
174   function add(uint a, uint b) internal returns (uint) {
175     uint c = a + b;
176     assert(c >= a);
177     return c;
178   }
179 
180   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
181     return a >= b ? a : b;
182   }
183 
184   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
185     return a < b ? a : b;
186   }
187 
188   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
189     return a >= b ? a : b;
190   }
191 
192   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
193     return a < b ? a : b;
194   }
195 }
196 
197 /**
198  * @title ERC20Basic
199  * @dev Simpler version of ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 contract ERC20Basic {
203   uint public totalSupply;
204   function balanceOf(address who) public constant returns (uint);
205   function transfer(address to, uint value) public;
206   event Transfer(address indexed from, address indexed to, uint value);
207 }
208 
209 /**
210  * @title ERC20 interface
211  * @dev see https://github.com/ethereum/EIPs/issues/20
212  */
213 contract ERC20 is ERC20Basic {
214   function allowance(address owner, address spender) public constant returns (uint);
215   function transferFrom(address from, address to, uint value) public;
216   function approve(address spender, uint value) public;
217   event Approval(address indexed owner, address indexed spender, uint value);
218 }
219 
220 /**
221  * @title Basic token
222  * @dev Basic version of StandardToken, with no allowances.
223  */
224 contract BasicToken is ERC20Basic {
225   using SafeMath for uint;
226 
227   mapping(address => uint) balances;
228 
229   /**
230    * @dev Fix for the ERC20 short address attack.
231    */
232   modifier onlyPayloadSize(uint size) {
233     require(msg.data.length >= size + 4);
234     _;
235   }
236 
237   /**
238   * @dev transfer token for a specified address
239   * @param _to The address to transfer to.
240   * @param _value The amount to be transferred.
241   */
242   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
243     balances[msg.sender] = balances[msg.sender].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     Transfer(msg.sender, _to, _value);
246   }
247 
248   /**
249   * @dev Gets the balance of the specified address.
250   * @param _owner The address to query the the balance of.
251   * @return An uint representing the amount owned by the passed address.
252   */
253   function balanceOf(address _owner) public constant returns (uint balance) {
254     return balances[_owner];
255   }
256 
257 }
258 
259 /**
260  * @title Standard ERC20 token
261  * @dev Implemantation of the basic standart token.
262  */
263 contract StandardToken is BasicToken, ERC20 {
264 
265   mapping (address => mapping (address => uint)) allowed;
266 
267 
268   /**
269    * @dev Transfer tokens from one address to another
270    * @param _from address The address which you want to send tokens from
271    * @param _to address The address which you want to transfer to
272    * @param _value uint the amout of tokens to be transfered
273    */
274   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
275     var _allowance = allowed[_from][msg.sender];
276 
277     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
278     // if (_value > _allowance) throw;
279 
280     balances[_to] = balances[_to].add(_value);
281     balances[_from] = balances[_from].sub(_value);
282     allowed[_from][msg.sender] = _allowance.sub(_value);
283     Transfer(_from, _to, _value);
284   }
285 
286   /**
287    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
288    * @param _spender The address which will spend the funds.
289    * @param _value The amount of tokens to be spent.
290    */
291   function approve(address _spender, uint _value) public {
292 
293     // To change the approve amount you first have to reduce the addresses`
294     //  allowance to zero by calling `approve(_spender, 0)` if it is not
295     //  already 0 to mitigate the race condition described here:
296     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
298 
299     allowed[msg.sender][_spender] = _value;
300     Approval(msg.sender, _spender, _value);
301   }
302 
303   /**
304    * @dev Function to check the amount of tokens than an owner allowed to a spender.
305    * @param _owner address The address which owns the funds.
306    * @param _spender address The address which will spend the funds.
307    * @return A uint specifing the amount of tokens still avaible for the spender.
308    */
309   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
310     return allowed[_owner][_spender];
311   }
312 
313 }
314 
315 /**
316  * @title Mintable token
317  */
318 contract MintableToken is StandardToken, Ownable {
319   event Mint(address indexed to, uint value);
320   event MintFinished();
321 
322   bool public mintingFinished = false;
323   uint public totalSupply = 0;
324 
325 
326   modifier canMint() {
327     require(!mintingFinished);
328     _;
329   }
330 
331   /**
332    * @dev Function to mint tokens
333    * @param _to The address that will recieve the minted tokens.
334    * @param _amount The amount of tokens to mint.
335    * @return A boolean that indicates if the operation was successful.
336    */
337   function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
338     totalSupply = totalSupply.add(_amount);
339     balances[_to] = balances[_to].add(_amount);
340     Mint(_to, _amount);
341     return true;
342   }
343 
344   /**
345    * @dev Function to stop minting new tokens.
346    * @return True if the operation was successful.
347    */
348   function finishMinting() public onlyOwner returns (bool) {
349     mintingFinished = true;
350     MintFinished();
351     return true;
352   }
353 }
354 
355 
356 /**
357  * @title MyToken
358  * @dev The main BON token contract
359  *
360  * ABI
361  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[{"name":"_authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"view"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
362  */
363 contract MyToken is MintableToken, Authorizable {
364 
365   string public name = "Bonpay Token";
366   string public symbol = "BON";
367   uint public decimals = 18;
368 
369   bool public tradingStarted = false;
370 
371   /**
372    * @dev modifier that throws if trading has not started yet
373    */
374   modifier hasStartedTrading() {
375     require(tradingStarted);
376     _;
377   }
378 
379   function mint(address _to, uint _amount) public onlyAuthorized canMint returns (bool) {
380     totalSupply = totalSupply.add(_amount);
381     balances[_to] = balances[_to].add(_amount);
382     Mint(_to, _amount);
383     return true;
384   }
385 
386   /**
387    * @dev Function to stop minting new tokens.
388    * @return True if the operation was successful.
389    */
390   function finishMinting() public onlyAuthorized returns (bool) {
391     mintingFinished = true;
392     MintFinished();
393     return true;
394   }
395 
396   /**
397    * @dev Allows the owner to enable the trading. This can not be undone
398    */
399   function startTrading() public onlyOwner {
400     tradingStarted = true;
401   }
402 
403   /**
404    * @dev Allows anyone to transfer the BON tokens once trading has started
405    * @param _to the recipient address of the tokens.
406    * @param _value number of tokens to be transfered.
407    */
408   function transfer(address _to, uint _value) public hasStartedTrading {
409     super.transfer(_to, _value);
410   }
411 
412   /**
413   * @dev Allows anyone to transfer the BON tokens once trading has started
414   * @param _from address The address which you want to send tokens from
415   * @param _to address The address which you want to transfer to
416   * @param _value uint the amout of tokens to be transfered
417   */
418   function transferFrom(address _from, address _to, uint _value) public hasStartedTrading {
419     super.transferFrom(_from, _to, _value);
420   }
421 
422 }
423 
424 /**
425  * @title MainSale
426  * @dev The main BON token sale contract
427  *
428  * ABI
429  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[{"name":"_authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function","stateMutability":"payable"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function","stateMutability":"nonpayable"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function","stateMutability":"view"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function","stateMutability":"view"},{"inputs":[{"name":"_token","type":"address"},{"name":"_exchangeRate","type":"address"},{"name":"_multisigVault","type":"address"},{"name":"_start","type":"uint256"}],"payable":false,"type":"constructor","stateMutability":"nonpayable"},{"payable":true,"type":"fallback","stateMutability":"payable"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
430  */
431 contract MainSale is Ownable, Authorizable {
432   using SafeMath for uint;
433   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
434   event AuthorizedCreate(address recipient, uint pay_amount);
435   event MainSaleClosed();
436 
437   MyToken public token;
438 
439   address public multisigVault;
440 
441   uint hardcap = 200000 ether;
442   ExchangeRate public exchangeRate;
443 
444   uint public altDeposits = 0;
445   uint public start = 0;
446 
447   /**
448    * @dev modifier to allow token creation only when the sale IS ON
449    */
450   modifier saleIsOn() {
451     require(now > start && now < start + 28 days);
452     _;
453   }
454 
455   /**
456    * @dev modifier to allow token creation only when the hardcap has not been reached
457    */
458   modifier isUnderHardCap() {
459     require(multisigVault.balance + altDeposits <= hardcap);
460     _;
461   }
462 
463   function MainSale(address _token, address _exchangeRate, address _multisigVault, uint _start) public onlyOwner {
464     token = MyToken(_token);
465     setExchangeRate(_exchangeRate);
466     setMultisigVault(_multisigVault);
467     setStart(_start);
468   }
469 
470   /**
471    * @dev Allows anyone to create tokens by depositing ether.
472    * @param recipient the recipient to receive tokens.
473    */
474   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
475     uint rate = exchangeRate.getRate("ETH");
476     uint tokens = rate.mul(msg.value).div(1 ether);
477     token.mint(recipient, tokens);
478     require(multisigVault.send(msg.value));
479     TokenSold(recipient, msg.value, tokens, rate);
480   }
481 
482 
483   /**
484    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
485    * @param totalAltDeposits total amount ETH equivalent
486    */
487   function setAltDeposit(uint totalAltDeposits) public onlyAuthorized {
488     altDeposits = totalAltDeposits;
489   }
490 
491   /**
492    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
493    * @param recipient the recipient to receive tokens.
494    * @param tokens number of tokens to be created.
495    */
496   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
497     token.mint(recipient, tokens);
498     AuthorizedCreate(recipient, tokens);
499   }
500 
501   /**
502    * @dev Allows the owner to set the hardcap.
503    * @param _hardcap the new hardcap
504    */
505   function setHardCap(uint _hardcap) public onlyOwner {
506     hardcap = _hardcap;
507   }
508 
509   /**
510    * @dev Allows the owner to set the starting time.
511    * @param _start the new _start
512    */
513   function setStart(uint _start) public onlyOwner {
514     start = _start;
515   }
516 
517   /**
518    * @dev Allows the owner to set the multisig contract.
519    * @param _multisigVault the multisig contract address
520    */
521   function setMultisigVault(address _multisigVault) public onlyOwner {
522     if (_multisigVault != address(0)) {
523       multisigVault = _multisigVault;
524     }
525   }
526 
527   /**
528    * @dev Allows the owner to set the exchangerate contract.
529    * @param _exchangeRate the exchangerate address
530    */
531   function setExchangeRate(address _exchangeRate) public onlyOwner {
532     exchangeRate = ExchangeRate(_exchangeRate);
533   }
534 
535   /**
536    * @dev Allows the owner to finish the minting. This will create the
537    * restricted tokens and then close the minting.
538    * to this owner.
539    */
540   function finishMinting() public onlyOwner {
541     uint issuedTokenSupply = token.totalSupply();
542     uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
543     token.mint(multisigVault, restrictedTokens);
544     token.finishMinting();
545     MainSaleClosed();
546   }
547 
548   /**
549    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
550    * @param _token the contract address of the ERC20 contract
551    */
552   function retrieveTokens(address _token) public onlyAuthorized {
553     ERC20 othertoken = ERC20(_token);
554     othertoken.transfer(multisigVault, othertoken.balanceOf(this));
555   }
556 
557   /**
558    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
559    * msg.sender.
560    */
561   function() external payable {
562     createTokens(msg.sender);
563   }
564 
565 }