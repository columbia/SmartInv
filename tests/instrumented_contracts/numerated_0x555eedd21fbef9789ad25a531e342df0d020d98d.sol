1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     function Ownable() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         if (msg.sender != owner) {
26             revert();
27         }
28         _;
29     }
30 
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         if (newOwner != address(0)) {
38             owner = newOwner;
39         }
40     }
41 
42 }
43 
44 /**
45  * @title Authorizable
46  * @dev Allows to authorize access to certain function calls
47  *
48  * ABI
49  * [{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"authorizers","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]
50  */
51 contract Authorizable {
52 
53     address[] public authorizers;
54     mapping(address => uint) authorizerIndex;
55 
56     /**
57      * @dev Throws if called by any account tat is not authorized.
58      */
59     modifier onlyAuthorized {
60         require(isAuthorized(msg.sender));
61         _;
62     }
63 
64     /**
65      * @dev Contructor that authorizes the msg.sender.
66      */
67     function Authorizable() public {
68         authorizers.length = 2;
69         authorizers[1] = msg.sender;
70         authorizerIndex[msg.sender] = 1;
71     }
72 
73     /**
74      * @dev Function to check if an address is authorized
75      * @param _addr the address to check if it is authorized.
76      * @return boolean flag if address is authorized.
77      */
78     function isAuthorized(address _addr) public view returns(bool) {
79         return authorizerIndex[_addr] > 0;
80     }
81 
82     /**
83      * @dev Function to add a new authorizer
84      * @param _addr the address to add as a new authorizer.
85      */
86     function addAuthorized(address _addr) external onlyAuthorized {
87         authorizerIndex[_addr] = authorizers.length;
88         authorizers.length++;
89         authorizers[authorizers.length - 1] = _addr;
90     }
91 }
92 
93 /**
94  * @title Investors
95  * @dev Allows to get investors
96  *
97  * ABI
98  * [{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"authorizers","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"investors","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_inv","type":"address"}],"name":"addInvestor","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]
99  */
100 contract Investors is Authorizable {
101 
102     address[] public investors;
103     mapping(address => uint) investorIndex;
104 
105     /**
106      * @dev Contructor that authorizes the msg.sender.
107      */
108     function Investors() public {
109         investors.length = 2;
110         investors[1] = msg.sender;
111         investorIndex[msg.sender] = 1;
112     }
113 
114     /**
115      * @dev Function to add a new investor
116      * @param _inv the address to add as a new investor.
117      */
118     function addInvestor(address _inv) public {
119         if (investorIndex[_inv] <= 0) {
120             investorIndex[_inv] = investors.length;
121             investors.length++;
122             investors[investors.length - 1] = _inv;
123         }
124 
125     }
126 }
127 
128 /**
129  * @title ExchangeRate
130  * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
131  *
132  * ABI
133  * [{"constant":false,"inputs":[{"name":"_symbol","type":"string"},{"name":"_rate","type":"uint256"}],"name":"updateRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"data","type":"uint256[]"}],"name":"updateRates","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_symbol","type":"string"}],"name":"getRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"bytes32"}],"name":"rates","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"timestamp","type":"uint256"},{"indexed":false,"name":"symbol","type":"bytes32"},{"indexed":false,"name":"rate","type":"uint256"}],"name":"RateUpdated","type":"event"}]
134  */
135 contract ExchangeRate is Ownable {
136 
137     event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
138 
139     mapping(bytes32 => uint) public rates;
140 
141     /**
142      * @dev Allows the current owner to update a single rate.
143      * @param _symbol The symbol to be updated.
144      * @param _rate the rate for the symbol.
145      */
146     function updateRate(string _symbol, uint _rate) public onlyOwner {
147         rates[keccak256(_symbol)] = _rate;
148         RateUpdated(now, keccak256(_symbol), _rate);
149     }
150 
151     /**
152      * @dev Allows the current owner to update multiple rates.
153      * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
154      */
155     function updateRates(uint[] data) public onlyOwner {
156         if (data.length % 2 > 0)
157         revert();
158         uint i = 0;
159         while (i < data.length / 2) {
160             bytes32 symbol = bytes32(data[i * 2]);
161             uint rate = data[i * 2 + 1];
162             rates[symbol] = rate;
163             RateUpdated(now, symbol, rate);
164             i++;
165         }
166     }
167 
168     /**
169      * @dev Allows the anyone to read the current rate.
170      * @param _symbol the symbol to be retrieved.
171      */
172     function getRate(string _symbol) public view returns(uint) {
173         return rates[keccak256(_symbol)];
174     }
175 }
176 
177 /**
178  * Math operations with safety checks
179  */
180 library SafeMath {
181     function mul(uint a, uint b) internal returns (uint) {
182         uint c = a * b;
183         assert(a == 0 || c / a == b);
184         return c;
185     }
186 
187     function div(uint a, uint b) internal returns (uint) {
188         // assert(b > 0); // Solidity automatically throws when dividing by 0
189         uint c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191         return c;
192     }
193 
194     function sub(uint a, uint b) internal returns (uint) {
195         assert(b <= a);
196         return a - b;
197     }
198 
199     function add(uint a, uint b) internal returns (uint) {
200         uint c = a + b;
201         assert(c >= a);
202         return c;
203     }
204 
205     function max64(uint64 a, uint64 b) internal view returns (uint64) {
206         return a >= b ? a : b;
207     }
208 
209     function min64(uint64 a, uint64 b) internal view returns (uint64) {
210         return a < b ? a : b;
211     }
212 
213     function max256(uint256 a, uint256 b) internal view returns (uint256) {
214         return a >= b ? a : b;
215     }
216 
217     function min256(uint256 a, uint256 b) internal view returns (uint256) {
218         return a < b ? a : b;
219     }
220 }
221 
222 /**
223  * @title ERC20Basic
224  * @dev Simpler version of ERC20 interface
225  * @dev see https://github.com/ethereum/EIPs/issues/20
226  */
227 contract ERC20Basic {
228     uint public totalSupply;
229     function balanceOf(address who) public view returns (uint);
230     function transfer(address to, uint value) public;
231     event Transfer(address indexed from, address indexed to, uint value);
232 }
233 
234 
235 
236 
237 /**
238  * @title ERC20 interface
239  * @dev see https://github.com/ethereum/EIPs/issues/20
240  */
241 contract ERC20 is ERC20Basic {
242     function allowance(address owner, address spender) public view returns (uint);
243     function transferFrom(address from, address to, uint value) public;
244     function approve(address spender, uint value)  public;
245     event Approval(address indexed owner, address indexed spender, uint value);
246 }
247 
248 /**
249  * @title Basic token
250  * @dev Basic version of StandardToken, with no allowances.
251  */
252 contract BasicToken is ERC20Basic {
253     using SafeMath for uint;
254 
255     mapping(address => uint) balances;
256 
257     /**
258      * @dev Fix for the ERC20 short address attack.
259      */
260     modifier onlyPayloadSize(uint size) {
261         if(msg.data.length < size + 4) {
262             revert();
263         }
264         _;
265     }
266 
267     /**
268     * @dev transfer token for a specified address
269     * @param _to The address to transfer to.
270     * @param _value The amount to be transferred.
271     */
272     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
273         balances[msg.sender] = balances[msg.sender].sub(_value);
274         balances[_to] = balances[_to].add(_value);
275         Transfer(msg.sender, _to, _value);
276     }
277 
278     /**
279     * @dev Gets the balance of the specified address.
280     * @param _owner The address to query the the balance of.
281     * @return An uint representing the amount owned by the passed address.
282     */
283     function balanceOf(address _owner) view returns (uint balance) {
284         return balances[_owner];
285     }
286 
287 }
288 
289 /**
290  * @title Standard ERC20 token
291  *
292  * @dev Implemantation of the basic standart token.
293  * @dev https://github.com/ethereum/EIPs/issues/20
294  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
295  */
296 contract StandardToken is BasicToken, ERC20 {
297 
298     mapping (address => mapping (address => uint)) allowed;
299 
300 
301     /**
302      * @dev Transfer tokens from one address to another
303      * @param _from address The address which you want to send tokens from
304      * @param _to address The address which you want to transfer to
305      * @param _value uint the amout of tokens to be transfered
306      */
307     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
308         var _allowance = allowed[_from][msg.sender];
309 
310         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
311         // if (_value > _allowance) throw;
312 
313         balances[_to] = balances[_to].add(_value);
314         balances[_from] = balances[_from].sub(_value);
315         allowed[_from][msg.sender] = _allowance.sub(_value);
316         Transfer(_from, _to, _value);
317     }
318 
319     /**
320      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
321      * @param _spender The address which will spend the funds.
322      * @param _value The amount of tokens to be spent.
323      */
324     function approve(address _spender, uint _value) {
325 
326         // To change the approve amount you first have to reduce the addresses`
327         //  allowance to zero by calling `approve(_spender, 0)` if it is not
328         //  already 0 to mitigate the race condition described here:
329         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();
331 
332         allowed[msg.sender][_spender] = _value;
333         Approval(msg.sender, _spender, _value);
334     }
335 
336     /**
337      * @dev Function to check the amount of tokens than an owner allowed to a spender.
338      * @param _owner address The address which owns the funds.
339      * @param _spender address The address which will spend the funds.
340      * @return A uint specifing the amount of tokens still avaible for the spender.
341      */
342     function allowance(address _owner, address _spender) view returns (uint remaining) {
343         return allowed[_owner][_spender];
344     }
345 
346 }
347 
348 /**
349  * @title Mintable token
350  * @dev Simple ERC20 Token example, with mintable token creation
351  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
352  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
353  */
354 
355 contract MintableToken is StandardToken, Ownable {
356     event Mint(address indexed to, uint value);
357     event MintFinished();
358     event MintRestarted();
359 
360     bool public mintingFinished = false;
361     uint public totalSupply = 0;
362 
363 
364     modifier canMint() {
365         if(mintingFinished) revert();
366         _;
367     }
368 
369     /**
370      * @dev Function to mint tokens
371      * @param _to The address that will recieve the minted tokens.
372      * @param _amount The amount of tokens to mint.
373      * @return A boolean that indicates if the operation was successful.
374      */
375     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
376         totalSupply = totalSupply.add(_amount);
377         balances[_to] = balances[_to].add(_amount);
378         Mint(_to, _amount);
379         return true;
380     }
381 
382     /**
383      * @dev Function to stop minting new tokens.
384      * @return True if the operation was successful.
385      */
386     function finishMinting() onlyOwner returns (bool) {
387         mintingFinished = true;
388         MintFinished();
389         return true;
390     }
391 
392     /**
393      * @dev Function to restart minting new tokens.
394      * @return True if the operation was successful.
395      */
396     function restartMinting() onlyOwner returns (bool) {
397         mintingFinished = false;
398         MintRestarted();
399         return true;
400     }
401 }
402 
403 
404 /**
405  * @title InvestyToken
406  * @dev The main PAY token contract
407  *
408  * ABI
409  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"restartMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[],"name":"MintRestarted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
410  */
411 contract InvestyToken is MintableToken {
412 
413     string public name = "Investy Coin";
414     string public symbol = "IVC66";
415     uint public decimals = 18;
416 
417     bool public tradingStarted = false;
418 
419     /**
420      * @dev modifier that throws if trading has not started yet
421      */
422     modifier hasStartedTrading() {
423         require(tradingStarted);
424         _;
425     }
426 
427     /**
428      * @dev Allows the owner to enable the trading. This can not be undone
429      */
430     function startTrading() onlyOwner {
431         tradingStarted = true;
432     }
433 
434     /**
435      * @dev Allows anyone to transfer the PAY tokens once trading has started
436      * @param _to the recipient address of the tokens.
437      * @param _value number of tokens to be transfered.
438      */
439     function transfer(address _to, uint _value) hasStartedTrading {
440         super.transfer(_to, _value);
441     }
442 
443     /**
444     * @dev Allows anyone to transfer the PAY tokens once trading has started
445     * @param _from address The address which you want to send tokens from
446     * @param _to address The address which you want to transfer to
447     * @param _value uint the amout of tokens to be transfered
448     */
449     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
450         super.transferFrom(_from, _to, _value);
451     }
452 
453 }
454 
455 /**
456  * @title MainSale
457  * @dev The main PAY token sale contract
458  *
459  * ABI
460  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"investors","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"presaleActive","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"transferToken","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"finishPresale","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"address"}],"name":"setExchangeRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"investorIndex","type":"uint256"}],"name":"getInvestor","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"restartPresale","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_inv","type":"address"}],"name":"addInvestor","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"pay_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"pay_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"PresaleFinished","type":"event"},{"anonymous":false,"inputs":[],"name":"PresaleReStarted","type":"event"}]
461  */
462 contract InvestyPresale is Ownable, Authorizable, Investors {
463     using SafeMath for uint;
464     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
465     event AuthorizedCreate(address recipient, uint pay_amount);
466     event PresaleFinished();
467     event PresaleReStarted();
468 
469     InvestyToken public token = new InvestyToken();
470 
471     address public multisigVault;
472     uint constant MILLI_USD_TO_IVC_RATE = 34;//presale fixed IVC coin cost
473 
474     ExchangeRate public exchangeRate;
475 
476     bool public presaleActive = true;
477     modifier isPresaleActive() {
478         if(!presaleActive) revert();
479         _;
480     }
481 
482     /**
483      * constructor
484      */
485     function InvestyPresale() {
486     }
487 
488     /**
489      * @dev Function to stop minting new tokens.
490      * @return True if the operation was successful.
491      */
492     function finishPresale() public onlyOwner returns (bool) {
493         presaleActive = false;
494         PresaleFinished();
495         return true;
496     }
497 
498     /**
499      * @dev Function to stop minting new tokens.
500      * @return True if the operation was successful.
501      */
502     function restartPresale() public onlyOwner returns (bool) {
503         presaleActive = true;
504         PresaleReStarted();
505         return true;
506     }
507 
508     /**
509      * @dev Allows anyone to create tokens by depositing ether.
510      * @param recipient the recipient to receive tokens.
511      */
512     function createTokens(address recipient) public isPresaleActive payable {
513         var einsteinToUsdRate = exchangeRate.getRate("EinsteinToUSD");
514         uint ivc = (einsteinToUsdRate.mul(msg.value).div(MILLI_USD_TO_IVC_RATE));// 18 signs after comma
515         token.mint(recipient, ivc);
516         addInvestor(recipient);
517         require(multisigVault.send(msg.value));
518         TokenSold(recipient, msg.value, ivc, einsteinToUsdRate / 1000);
519     }
520 
521     /**
522    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
523    * @param recipient the recipient to receive tokens.
524    * @param tokens number of tokens to be created.
525    */
526     function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
527         token.mint(recipient, tokens);
528         addInvestor(recipient);
529         AuthorizedCreate(recipient, tokens);
530     }
531 
532     /**
533    * @dev Allows the owner to set the exchangerate contract.
534    * @param _exchangeRate the exchangerate address
535    */
536     function setExchangeRate(address _exchangeRate) public onlyOwner {
537         exchangeRate = ExchangeRate(_exchangeRate);
538     }
539 
540     /**
541    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
542    * @param _token the contract address of the ERC20 contract
543    */
544     function retrieveTokens(address _token) public onlyOwner {
545         ERC20 outerToken = ERC20(_token);
546         token.transfer(multisigVault, outerToken.balanceOf(this));
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
560      * @dev Ownership of the PAY token contract is transfered to this owner.
561      */
562     function transferToken() public onlyOwner {
563         token.transferOwnership(owner);
564     }
565 
566     /**
567      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
568      * msg.sender.
569      */
570     function() external payable {
571         createTokens(msg.sender);
572     }
573 }