1 pragma solidity ^0.4.24;
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
12     /**
13      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14      * account.
15      */
16     function Ownable() public {
17         owner = msg.sender;
18     }
19 
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require (msg.sender == owner);
26         _;
27     }
28 
29 
30     /**
31      * @dev Allows the current owner to transfer control of the contract to a newOwner.
32      * @param newOwner The address to transfer ownership to.
33      */
34     function transferOwnership(address newOwner) onlyOwner {
35         require(newOwner != address(0));
36         owner = newOwner;
37     }
38 }
39 
40 
41 
42 /**
43  * @title Authorizable
44  * @dev Allows to authorize access to certain function calls
45  *
46  * ABI
47  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
48  */
49 contract Authorizable {
50 
51     address[] authorizers;
52     mapping(address => uint) authorizerIndex;
53 
54     /**
55      * @dev Throws if called by any account tat is not authorized.
56      */
57     modifier onlyAuthorized {
58         require(isAuthorized(msg.sender));
59         _;
60     }
61 
62     /**
63      * @dev Contructor that authorizes the msg.sender.
64      */
65     function Authorizable() public {
66         authorizers.length = 2;
67         authorizers[1] = msg.sender;
68         authorizerIndex[msg.sender] = 1;
69     }
70 
71     /**
72      * @dev Function to get a specific authorizer
73      * @param authorizerIndex index of the authorizer to be retrieved.
74      * @return The address of the authorizer.
75      */
76     function getAuthorizer(uint authorizerIndex) external constant returns(address) {
77         return address(authorizers[authorizerIndex + 1]);
78     }
79 
80     /**
81      * @dev Function to check if an address is authorized
82      * @param _addr the address to check if it is authorized.
83      * @return boolean flag if address is authorized.
84      */
85     function isAuthorized(address _addr) public constant returns(bool) {
86         return authorizerIndex[_addr] > 0;
87     }
88 
89     /**
90      * @dev Function to add a new authorizer
91      * @param _addr the address to add as a new authorizer.
92      */
93     function addAuthorized(address _addr) external onlyAuthorized {
94         authorizerIndex[_addr] = authorizers.length;
95         authorizers.length++;
96         authorizers[authorizers.length - 1] = _addr;
97     }
98 
99 }
100 
101 /**
102  * @title ExchangeRate
103  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
104  *
105  * ABI
106  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
107  */
108 contract ExchangeRate is Ownable {
109 
110     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
111 
112     mapping(bytes32 => uint) public rates;
113 
114     /**
115      * @dev Allows the current owner to update a single rate.
116      * @param _symbol The symbol to be updated.
117      * @param _rate the rate for the symbol.
118      */
119     function updateRate(string _symbol, uint _rate) public onlyOwner {
120         rates[keccak256(_symbol)] = _rate;
121         RateUpdated(now, keccak256(_symbol), _rate);
122     }
123 
124     /**
125      * @dev Allows the current owner to update multiple rates.
126      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
127      */
128     function updateRates(uint[] data) public onlyOwner {
129         require (data.length % 2 <= 0);
130         uint i = 0;
131         while (i < data.length / 2) {
132             bytes32 symbol = bytes32(data[i * 2]);
133             uint rate = data[i * 2 + 1];
134             rates[symbol] = rate;
135             RateUpdated(now, symbol, rate);
136             i++;
137         }
138     }
139 
140     /**
141      * @dev Allows the anyone to read the current rate.
142      * @param _symbol the symbol to be retrieved.
143      */
144     function getRate(string _symbol) public constant returns(uint) {
145         return rates[keccak256(_symbol)];
146     }
147 
148 }
149 
150 /**
151  * Math operations with safety checks
152  */
153 library SafeMath {
154     function mul(uint a, uint b) internal returns (uint) {
155         uint c = a * b;
156         assert(a == 0 || c / a == b);
157         return c;
158     }
159 
160     function div(uint a, uint b) internal returns (uint) {
161         // assert(b > 0); // Solidity automatically throws when dividing by 0
162         uint c = a / b;
163         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
164         return c;
165     }
166 
167     function sub(uint a, uint b) internal returns (uint) {
168         assert(b <= a);
169         return a - b;
170     }
171 
172     function add(uint a, uint b) internal returns (uint) {
173         uint c = a + b;
174         assert(c >= a);
175         return c;
176     }
177 
178     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
179         return a >= b ? a : b;
180     }
181 
182     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
183         return a < b ? a : b;
184     }
185 
186     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
187         return a >= b ? a : b;
188     }
189 
190     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
191         return a < b ? a : b;
192     }
193 
194     function assert(bool assertion) internal {
195         require(assertion);
196     }
197 }
198 
199 
200 /**
201  * @title ERC20Basic
202  * @dev Simpler version of ERC20 interface
203  * @dev see https://github.com/ethereum/EIPs/issues/20
204  */
205 contract ERC20Basic {
206     uint public totalSupply;
207     function balanceOf(address who) public constant returns (uint);
208     function transfer(address to, uint value) public;
209     event Transfer(address indexed from, address indexed to, uint value);
210 }
211 
212 
213 
214 
215 /**
216  * @title ERC20 interface
217  * @dev see https://github.com/ethereum/EIPs/issues/20
218  */
219 contract ERC20 is ERC20Basic {
220     function allowance(address owner, address spender) constant returns (uint);
221     function transferFrom(address from, address to, uint value);
222     function approve(address spender, uint value);
223     event Approval(address indexed owner, address indexed spender, uint value);
224 }
225 
226 
227 
228 
229 /**
230  * @title Basic token
231  * @dev Basic version of StandardToken, with no allowances.
232  */
233 contract BasicToken is ERC20Basic {
234     using SafeMath for uint;
235 
236     mapping(address => uint) balances;
237 
238     /**
239      * @dev Fix for the ERC20 short address attack.
240      */
241     modifier onlyPayloadSize(uint size) {
242         require (size + 4 <= msg.data.length);
243         _;
244     }
245 
246     /**
247     * @dev transfer token for a specified address
248     * @param _to The address to transfer to.
249     * @param _value The amount to be transferred.
250     */
251     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
252         balances[msg.sender] = balances[msg.sender].sub(_value);
253         balances[_to] = balances[_to].add(_value);
254         Transfer(msg.sender, _to, _value);
255     }
256 
257     /**
258     * @dev Gets the balance of the specified address.
259     * @param _owner The address to query the the balance of.
260     * @return An uint representing the amount owned by the passed address.
261     */
262     function balanceOf(address _owner) constant returns (uint balance) {
263         return balances[_owner];
264     }
265 
266 }
267 
268 
269 
270 
271 /**
272  * @title Standard ERC20 token
273  *
274  * @dev Implemantation of the basic standart token.
275  * @dev https://github.com/ethereum/EIPs/issues/20
276  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
277  */
278 contract StandardToken is BasicToken, ERC20 {
279 
280     mapping (address => mapping (address => uint)) allowed;
281 
282 
283     /**
284      * @dev Transfer tokens from one address to another
285      * @param _from address The address which you want to send tokens from
286      * @param _to address The address which you want to transfer to
287      * @param _value uint the amout of tokens to be transfered
288      */
289     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
290         var _allowance = allowed[_from][msg.sender];
291 
292         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
293         // if (_value > _allowance) throw;
294 
295         balances[_to] = balances[_to].add(_value);
296         balances[_from] = balances[_from].sub(_value);
297         allowed[_from][msg.sender] = _allowance.sub(_value);
298         Transfer(_from, _to, _value);
299     }
300 
301     /**
302      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
303      * @param _spender The address which will spend the funds.
304      * @param _value The amount of tokens to be spent.
305      */
306     function approve(address _spender, uint _value) {
307 
308         // To change the approve amount you first have to reduce the addresses`
309         //  allowance to zero by calling `approve(_spender, 0)` if it is not
310         //  already 0 to mitigate the race condition described here:
311         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
313 
314         allowed[msg.sender][_spender] = _value;
315         Approval(msg.sender, _spender, _value);
316     }
317 
318     /**
319      * @dev Function to check the amount of tokens than an owner allowed to a spender.
320      * @param _owner address The address which owns the funds.
321      * @param _spender address The address which will spend the funds.
322      * @return A uint specifing the amount of tokens still avaible for the spender.
323      */
324     function allowance(address _owner, address _spender) constant returns (uint remaining) {
325         return allowed[_owner][_spender];
326     }
327 
328 }
329 
330 
331 /**
332  * @title Mintable token
333  * @dev Simple ERC20 Token example, with mintable token creation
334  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
335  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
336  */
337 
338 contract MintableToken is StandardToken, Ownable {
339     event Mint(address indexed to, uint value);
340     event MintFinished();
341     event Burn(address indexed burner, uint256 value);
342 
343     bool public mintingFinished = false;
344     uint public totalSupply = 0;
345 
346 
347     modifier canMint() {
348         require(!mintingFinished);
349         _;
350     }
351 
352     /**
353      * @dev Function to mint tokens
354      * @param _to The address that will recieve the minted tokens.
355      * @param _amount The amount of tokens to mint.
356      * @return A boolean that indicates if the operation was successful.
357      */
358     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
359         totalSupply = totalSupply.add(_amount);
360         balances[_to] = balances[_to].add(_amount);
361         Mint(_to, _amount);
362         return true;
363     }
364 
365     /**
366      * @dev Function to stop minting new tokens.
367      * @return True if the operation was successful.
368      */
369     function finishMinting() onlyOwner returns (bool) {
370         mintingFinished = true;
371         MintFinished();
372         return true;
373     }
374 
375 
376     /**
377      * @dev Burns a specific amount of tokens.
378      * @param _value The amount of token to be burned.
379      */
380     function burn(address _who, uint256 _value) onlyOwner public {
381         _burn(_who, _value);
382     }
383 
384     function _burn(address _who, uint256 _value) internal {
385         require(_value <= balances[_who]);
386         // no need to require value <= totalSupply, since that would imply the
387         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
388 
389         balances[_who] = balances[_who].sub(_value);
390         totalSupply = totalSupply.sub(_value);
391         Burn(_who, _value);
392         Transfer(_who, address(0), _value);
393     }
394 }
395 
396 
397 /**
398  * @title CBCToken
399  * @dev The main CBC token contract
400  *
401  * ABI
402  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
403  */
404 contract CBCToken is MintableToken {
405 
406     string public name = "Crypto Boss Coin";
407     string public symbol = "CBC";
408     uint public decimals = 18;
409 
410     bool public tradingStarted = false;
411     /**
412      * @dev modifier that throws if trading has not started yet
413      */
414     modifier hasStartedTrading() {
415         require(tradingStarted);
416         _;
417     }
418 
419 
420     /**
421      * @dev Allows the owner to enable the trading. This can not be undone
422      */
423     function startTrading() onlyOwner {
424         tradingStarted = true;
425     }
426 
427     /**
428      * @dev Allows anyone to transfer the PAY tokens once trading has started
429      * @param _to the recipient address of the tokens.
430      * @param _value number of tokens to be transfered.
431      */
432     function transfer(address _to, uint _value) hasStartedTrading {
433         super.transfer(_to, _value);
434     }
435 
436     /**
437     * @dev Allows anyone to transfer the CBC tokens once trading has started
438     * @param _from address The address which you want to send tokens from
439     * @param _to address The address which you want to transfer to
440     * @param _value uint the amout of tokens to be transfered
441     */
442     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
443         super.transferFrom(_from, _to, _value);
444     }
445 
446 }
447 
448 /**
449  * @title MainSale
450  * @dev The main CBC token sale contract
451  *
452  * ABI
453  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposit","outputs":[],"payable":false,"type":"function"},{"constant":!1,"inputs":[{"name":"victim","type":"address"},{"name":"amount","type":"uint256"}],"name":"burnTokens","outputs":[],"payable":!1,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardCap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
454  */
455 contract MainSale is Ownable, Authorizable {
456     using SafeMath for uint;
457     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
458     event AuthorizedCreate(address recipient, uint pay_amount);
459     event AuthorizedBurn(address receiver, uint value);
460     event AuthorizedStartTrading();
461     event MainSaleClosed();
462     CBCToken public token = new CBCToken();
463 
464     address public multisigVault;
465 
466     uint hardcap = 100000000000000 ether;
467     ExchangeRate public exchangeRate;
468 
469     uint public altDeposits = 0;
470     uint public start = 1525996800;
471 
472     /**
473      * @dev modifier to allow token creation only when the sale IS ON
474      */
475     modifier saleIsOn() {
476         require(now > start && now < start + 28 days);
477         _;
478     }
479 
480     /**
481      * @dev modifier to allow token creation only when the hardcap has not been reached
482      */
483     modifier isUnderHardCap() {
484         require(multisigVault.balance + altDeposits <= hardcap);
485         _;
486     }
487 
488     /**
489      * @dev Allows anyone to create tokens by depositing ether.
490      * @param recipient the recipient to receive tokens.
491      */
492     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
493         uint rate = exchangeRate.getRate("ETH");
494         uint tokens = rate.mul(msg.value).div(1 ether);
495         token.mint(recipient, tokens);
496         require(multisigVault.send(msg.value));
497         TokenSold(recipient, msg.value, tokens, rate);
498     }
499 
500     /**
501      * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
502      * @param totalAltDeposits total amount ETH equivalent
503      */
504     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
505         altDeposits = totalAltDeposits;
506     }
507 
508     /**
509      * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
510      * @param recipient the recipient to receive tokens.
511      * @param tokens number of tokens to be created.
512      */
513     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
514         token.mint(recipient, tokens);
515         AuthorizedCreate(recipient, tokens);
516     }
517 
518     function authorizedStartTrading() public onlyAuthorized {
519         token.startTrading();
520         AuthorizedStartTrading();
521     }
522 
523     /**
524      * @dev Allows authorized acces to burn tokens.
525      * @param receiver the receiver to receive tokens.
526      * @param value number of tokens to be created.
527      */
528     function authorizedBurnTokens(address receiver, uint value) public onlyAuthorized {
529         token.burn(receiver, value);
530         AuthorizedBurn(receiver, value);
531     }
532 
533     /**
534      * @dev Allows the owner to set the hardcap.
535      * @param _hardcap the new hardcap
536      */
537     function setHardCap(uint _hardcap) public onlyOwner {
538         hardcap = _hardcap;
539     }
540 
541     /**
542      * @dev Allows the owner to set the starting time.
543      * @param _start the new _start
544      */
545     function setStart(uint _start) public onlyOwner {
546         start = _start;
547     }
548 
549     /**
550      * @dev Allows the owner to set the multisig contract.
551      * @param _multisigVault the multisig contract address
552      */
553     function setMultisigVault(address _multisigVault) public onlyOwner {
554         if (_multisigVault != address(0)) {
555             multisigVault = _multisigVault;
556         }
557     }
558 
559     /**
560      * @dev Allows the owner to set the exchangerate contract.
561      * @param _exchangeRate the exchangerate address
562      */
563     function setExchangeRate(address _exchangeRate) public onlyOwner {
564         exchangeRate = ExchangeRate(_exchangeRate);
565     }
566 
567     /**
568      * @dev Allows the owner to finish the minting. This will create the
569      * restricted tokens and then close the minting.
570      * Then the ownership of the PAY token contract is transfered
571      * to this owner.
572      */
573     function finishMinting() public onlyOwner {
574         uint issuedTokenSupply = token.totalSupply();
575         uint restrictedTokens = issuedTokenSupply.mul(49).div(51);
576         token.mint(multisigVault, restrictedTokens);
577         token.finishMinting();
578         token.transferOwnership(owner);
579         MainSaleClosed();
580     }
581 
582     /**
583      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
584      * @param _token the contract address of the ERC20 contract
585      */
586     function retrieveTokens(address _token) public onlyOwner {
587         ERC20 token = ERC20(_token);
588         token.transfer(multisigVault, token.balanceOf(this));
589     }
590 
591     /**
592      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
593      * msg.sender.
594      */
595     function() external payable {
596         createTokens(msg.sender);
597     }
598 
599 }
600 
601 /**
602 * It is insurance smart-contract for the SmartContractBank.
603 * You can buy insurance for 0.1 ETH and if you do not take 100% profit when balance of
604 * the SmartContractBank will be lesser then 0.01 you can receive part of insurance fund depend on your not received money.
605 *
606 * To buy insurance:
607 * Send to the contract address 0.01 ETH, and you will be accounted to.
608 *
609 * To receive insurance payout:
610 * Send to the contract address 0 ETH, and you will receive part of insurance depend on your not received money.
611 * If you already received 100% from your deposit, you will take error.
612 */
613 contract InsuranceFund {
614     using SafeMath for uint256;
615 
616     /**
617     * @dev Structure for evaluating payout
618     * @param deposit Duplicated from SmartContractBank deposit
619     * @param withdrawals Duplicated from SmartContractBank withdrawals
620     * @param insured Flag for available payout
621     */
622     struct Investor {
623         uint256 deposit;
624         uint256 withdrawals;
625         bool insured;
626     }
627     mapping (address => Investor) public investors;
628     uint public countOfInvestors;
629 
630     bool public startOfPayments = false;
631     uint256 public totalSupply;
632 
633     uint256 public totalNotReceived;
634     address public SCBAddress;
635 
636     SmartContractBank SCBContract;
637 
638     event Paid(address investor, uint256 amount, uint256  notRecieve, uint256  partOfNotReceived);
639     event SetInfo(address investor, uint256  notRecieve, uint256 deposit, uint256 withdrawals);
640 
641     /**
642     * @dev  Modifier for access from the SmartContractBank
643     */
644     modifier onlySCB() {
645         require(msg.sender == SCBAddress, "access denied");
646         _;
647     }
648 
649     /**
650     * @dev  Setter the SmartContractBank address. Address can be set only once.
651     * @param _SCBAddress Address of the SmartContractBank
652     */
653     function setSCBAddress(address _SCBAddress) public {
654         require(SCBAddress == address(0x0));
655         SCBAddress = _SCBAddress;
656         SCBContract = SmartContractBank(SCBAddress);
657     }
658 
659     /**
660     * @dev  Private setter info about investor. Can be call if payouts not started.
661     * Needing for evaluating not received total amount without loops.
662     * @param _address Investor's address
663     * @param _address Investor's deposit
664     * @param _address Investor's withdrawals
665     */
666     function privateSetInfo(address _address, uint256 deposit, uint256 withdrawals) private{
667         if (!startOfPayments) {
668             Investor storage investor = investors[_address];
669 
670             if (investor.deposit != deposit){
671                 totalNotReceived = totalNotReceived.add(deposit.sub(investor.deposit));
672                 investor.deposit = deposit;
673             }
674 
675             if (investor.withdrawals != withdrawals){
676                 uint256 different;
677                 if (deposit <= withdrawals){
678                     different = deposit.sub(withdrawals);
679                     if (totalNotReceived >= different)
680                         totalNotReceived = totalNotReceived.sub(different);
681                     else
682                         totalNotReceived = 0;
683                 } else {
684                     different = withdrawals.sub(investor.withdrawals);
685                     if (totalNotReceived >= different)
686                         totalNotReceived = totalNotReceived.sub(different);
687                     else
688                         totalNotReceived = 0;
689                 }
690                 investor.withdrawals = withdrawals;
691             }
692 
693             emit SetInfo(_address, totalNotReceived, investor.deposit, investor.withdrawals);
694         }
695     }
696 
697     /**
698     * @dev  Setter info about investor from the SmartContractBank.
699     * @param _address Investor's address
700     * @param _address Investor's deposit
701     * @param _address Investor's withdrawals
702     */
703     function setInfo(address _address, uint256 deposit, uint256 withdrawals) public onlySCB {
704         privateSetInfo(_address, deposit, withdrawals);
705     }
706 
707     /**
708     * @dev  Delete insured from the SmartContractBank.
709     * @param _address Investor's address
710     */
711     function deleteInsured(address _address) public onlySCB {
712         Investor storage investor = investors[_address];
713         investor.deposit = 0;
714         investor.withdrawals = 0;
715         investor.insured = false;
716         countOfInvestors--;
717     }
718 
719     /**
720     * @dev  Function for starting payouts and stopping receive funds.
721     */
722     function beginOfPayments() public {
723         require(address(SCBAddress).balance < 0.1 ether && !startOfPayments);
724         startOfPayments = true;
725         totalSupply = address(this).balance;
726     }
727 
728     /**
729     * @dev  Payable function for receive funds, buying insurance and receive insurance payouts .
730     */
731     function () external payable {
732         Investor storage investor = investors[msg.sender];
733         if (msg.value > 0 ether){
734             require(!startOfPayments);
735             if (msg.sender != SCBAddress && msg.value >= 0.1 ether) {
736                 uint256 deposit;
737                 uint256 withdrawals;
738                 (deposit, withdrawals, investor.insured) = SCBContract.setInsured(msg.sender);
739                 countOfInvestors++;
740                 privateSetInfo(msg.sender, deposit, withdrawals);
741             }
742         } else if (msg.value == 0){
743             uint256 notReceived = investor.deposit.sub(investor.withdrawals);
744             uint256 partOfNotReceived = notReceived.mul(100).div(totalNotReceived);
745             uint256 payAmount = totalSupply.div(100).mul(partOfNotReceived);
746             require(startOfPayments && investor.insured && notReceived > 0);
747             investor.insured = false;
748             msg.sender.transfer(payAmount);
749             emit Paid(msg.sender, payAmount, notReceived, partOfNotReceived);
750         }
751     }
752 }
753 
754 /**
755 * It is "Smart Contract Bank" smart-contract.
756 * - You can take profit 4% per day.
757 * - You can buy insurance and receive part of insurance fund when balance will be lesser then 0.01 ETH.
758 * - You can increase your percent on 0.5% if you have 10 CBC Token (0x790bFaCaE71576107C068f494c8A6302aea640cb ico.cryptoboss.me)
759 *    1. To buy CBC Tokens send 0.01 ETH on Sale Token Address 0x369fc7de8aee87a167244eb10b87eb3005780872
760 *    2. To increase your profit percent if you already have tokens, you should send to SmartContractBank address 0.0001 ETH
761 * - If your percent balance will be beyond of 200% you will able to take your profit only once time.
762 * HODL your profit and take more then 200% percents.
763 * - If balance of contract will be lesser then 0.1 ETH every user able stop contract and start insurance payments.
764 *
765 * - Percent of profit depends on balance of contract. Percent chart below:
766 * - If balance < 100 ETH - 4% per day
767 * - If balance >= 100 ETH and < 600 - 2% per day
768 * - If balance >= 600 ETH and < 1000 - 1% per day
769 * - If balance >= 1000 ETH and < 3000 - 0.9% per day
770 * - If balance >= 3000 ETH and < 5000 - 0.8% per day
771 * - If balance >= 5000  - 0.7% per day
772 * - If balance of contract will be beyond threshold, your payout will be reevaluate depends on currently balance of contract
773 * -
774 * - You can calm your profit every 5 minutes
775 *
776 * To invest:
777 * - Send minimum 0.01 ETH to contract address
778 *
779 * To calm profit:
780 * - Send 0 ETH to contract address
781 */
782 contract SmartContractBank {
783     using SafeMath for uint256;
784     struct Investor {
785         uint256 deposit;
786         uint256 paymentTime;
787         uint256 withdrawals;
788         bool increasedPercent;
789         bool insured;
790     }
791     uint public countOfInvestors;
792     mapping (address => Investor) public investors;
793 
794     uint256 public minimum = 0.01 ether;
795     uint step = 5 minutes;
796     uint ownerPercent = 4;
797     uint promotionPercent = 8;
798     uint insurancePercent = 2;
799     bool public closed = false;
800     
801     address public ownerAddressOne = 0xaB5007407d8A686B9198079816ebBaaa2912ecC1;
802     address public ownerAddressTwo = 0x4A5b00cDDAeE928B8De7a7939545f372d6727C06;
803     address public promotionAddress = 0x3878E2231f7CA61c0c1D0Aa3e6962d7D23Df1B3b;
804     address public insuranceFundAddress;
805     address CBCTokenAddress = 0x790bFaCaE71576107C068f494c8A6302aea640cb;
806     address MainSaleAddress = 0x369fc7de8aee87a167244eb10b87eb3005780872;
807 
808     InsuranceFund IFContract;
809 
810     event Invest(address investor, uint256 amount);
811     event Withdraw(address investor, uint256 amount);
812     event UserDelete(address investor);
813 
814     /**
815     * @dev Modifier for access from the InsuranceFund
816     */
817     modifier onlyIF() {
818         require(insuranceFundAddress == msg.sender, "access denied");
819         _;
820     }
821 
822     /**
823     * @dev  Setter the InsuranceFund address. Address can be set only once.
824     * @param _insuranceFundAddress Address of the InsuranceFund
825     */
826     function setInsuranceFundAddress(address _insuranceFundAddress) public{
827         require(insuranceFundAddress == address(0x0));
828         insuranceFundAddress = _insuranceFundAddress;
829         IFContract = InsuranceFund(insuranceFundAddress);
830     }
831 
832     /**
833     * @dev  Set insured from the InsuranceFund.
834     * @param _address Investor's address
835     * @return Object of investor's information
836     */
837     function setInsured(address _address) public onlyIF returns(uint256, uint256, bool){
838         Investor storage investor = investors[_address];
839         investor.insured = true;
840         return (investor.deposit, investor.withdrawals, investor.insured);
841     }
842 
843     /**
844     * @dev  Function for close entrance.
845     */
846     function closeEntrance() public {
847         require(address(this).balance < 0.1 ether && !closed);
848         closed = true;
849     }
850 
851     /**
852     * @dev Get percent depends on balance of contract
853     * @return Percent
854     */
855     function getPhasePercent() view public returns (uint){
856         Investor storage investor = investors[msg.sender];
857         uint contractBalance = address(this).balance;
858         uint percent;
859         if (contractBalance < 100 ether) {
860             percent = 40;
861         }
862         if (contractBalance >= 100 ether && contractBalance < 600 ether) {
863             percent = 20;
864         }
865         if (contractBalance >= 600 ether && contractBalance < 1000 ether) {
866             percent = 10;
867         }
868         if (contractBalance >= 1000 ether && contractBalance < 3000 ether) {
869             percent = 9;
870         }
871         if (contractBalance >= 3000 ether && contractBalance < 5000 ether) {
872             percent = 8;
873         }
874         if (contractBalance >= 5000 ether) {
875             percent = 7;
876         }
877 
878         if (investor.increasedPercent){
879             percent = percent.add(5);
880         }
881 
882         return percent;
883     }
884 
885     /**
886     * @dev Allocation budgets
887     */
888     function allocation() private{
889         ownerAddressOne.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
890         ownerAddressTwo.transfer(msg.value.mul(ownerPercent.div(2)).div(100));
891         promotionAddress.transfer(msg.value.mul(promotionPercent).div(100));
892         insuranceFundAddress.transfer(msg.value.mul(insurancePercent).div(100));
893     }
894 
895     /**
896     * @dev Evaluate current balance
897     * @param _address Address of investor
898     * @return Payout amount
899     */
900     function getUserBalance(address _address) view public returns (uint256) {
901         Investor storage investor = investors[_address];
902         uint percent = getPhasePercent();
903         uint256 differentTime = now.sub(investor.paymentTime).div(step);
904         uint256 differentPercent = investor.deposit.mul(percent).div(1000);
905         uint256 payout = differentPercent.mul(differentTime).div(288);
906 
907         return payout;
908     }
909 
910     /**
911     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received x2
912     */
913     function withdraw() private {
914         Investor storage investor = investors[msg.sender];
915         uint256 balance = getUserBalance(msg.sender);
916         if (investor.deposit > 0 && address(this).balance > balance && balance > 0) {
917             uint256 tempWithdrawals = investor.withdrawals;
918 
919             investor.withdrawals = investor.withdrawals.add(balance);
920             investor.paymentTime = now;
921 
922             if (investor.withdrawals >= investor.deposit.mul(2)){
923                 investor.deposit = 0;
924                 investor.paymentTime = 0;
925                 investor.withdrawals = 0;
926                 investor.increasedPercent = false;
927                 investor.insured = false;
928                 countOfInvestors--;
929                 if (investor.insured)
930                     IFContract.deleteInsured(msg.sender);
931                 emit UserDelete(msg.sender);
932             } else {
933                 if (investor.insured && tempWithdrawals < investor.deposit){
934                     IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
935                 }
936             }
937             msg.sender.transfer(balance);
938             emit Withdraw(msg.sender, balance);
939         }
940 
941     }
942 
943     /**
944     * @dev Increase percent with CBC Token
945     */
946     function increasePercent() private {
947         CBCToken CBCTokenContract = CBCToken(CBCTokenAddress);
948         MainSale MainSaleContract = MainSale(MainSaleAddress);
949         Investor storage investor = investors[msg.sender];
950         if (CBCTokenContract.balanceOf(msg.sender) >= 10){
951             MainSaleContract.authorizedBurnTokens(msg.sender, 10);
952             investor.increasedPercent = true;
953         }
954     }
955 
956     /**
957     * @dev  Payable function for
958     * - receive funds (send minimum 0.01 ETH),
959     * - increase percent and receive profit (send 0.0001 ETH if you already have CBC Tokens on your address).
960     * - calm your profit (send 0 ETH)
961     */
962     function () external payable {
963         require(!closed);
964         Investor storage investor = investors[msg.sender];
965         if (msg.value > 0){
966             require(msg.value >= minimum);
967 
968             withdraw();
969 
970             if (investor.deposit == 0){
971                 countOfInvestors++;
972             }
973 
974             investor.deposit = investor.deposit.add(msg.value);
975             investor.paymentTime = now;
976 
977             if (investor.insured){
978                 IFContract.setInfo(msg.sender, investor.deposit, investor.withdrawals);
979             }
980             allocation();
981             emit Invest(msg.sender, msg.value);
982         } if (msg.value == 0.0001 ether) {
983             increasePercent();
984         } else {
985             withdraw();
986         }
987     }
988 }