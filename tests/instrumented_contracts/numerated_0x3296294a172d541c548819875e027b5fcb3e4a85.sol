1 pragma solidity ^0.4.11;
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
17     function Ownable() {
18         owner = msg.sender;
19     }
20 
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) onlyOwner {
36         if (newOwner != address(0)) {
37             owner = newOwner;
38         }
39     }
40 
41 }
42 
43 
44 
45 /**
46  * @title Authorizable
47  * @dev Allows to authorize access to certain function calls
48  *
49  * ABI
50  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
51  */
52 contract Authorizable {
53 
54     address[] authorizers;
55     mapping(address => uint) authorizerIndex;
56 
57     /**
58      * @dev Throws if called by any account tat is not authorized.
59      */
60     modifier onlyAuthorized {
61         require(isAuthorized(msg.sender));
62         _;
63     }
64 
65     /**
66      * @dev Contructor that authorizes the msg.sender.
67      */
68     function Authorizable() {
69         authorizers.length = 2;
70         authorizers[1] = msg.sender;
71         authorizerIndex[msg.sender] = 1;
72     }
73 
74     /**
75      * @dev Function to get a specific authorizer
76      * @param authorizerIndex index of the authorizer to be retrieved.
77      * @return The address of the authorizer.
78      */
79     function getAuthorizer(uint authorizerIndex) external constant returns(address) {
80         return address(authorizers[authorizerIndex + 1]);
81     }
82 
83     /**
84      * @dev Function to check if an address is authorized
85      * @param _addr the address to check if it is authorized.
86      * @return boolean flag if address is authorized.
87      */
88     function isAuthorized(address _addr) constant returns(bool) {
89         return authorizerIndex[_addr] > 0;
90     }
91 
92     /**
93      * @dev Function to add a new authorizer
94      * @param _addr the address to add as a new authorizer.
95      */
96     function addAuthorized(address _addr) external onlyAuthorized {
97         authorizerIndex[_addr] = authorizers.length;
98         authorizers.length++;
99         authorizers[authorizers.length - 1] = _addr;
100     }
101 
102 }
103 
104 /**
105  * Math operations with safety checks
106  */
107 library SafeMath {
108     function mul(uint a, uint b) internal returns (uint) {
109         uint c = a * b;
110         assert(a == 0 || c / a == b);
111         return c;
112     }
113 
114     function div(uint a, uint b) internal returns (uint) {
115         // assert(b > 0); // Solidity automatically throws when dividing by 0
116         uint c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118         return c;
119     }
120 
121     function sub(uint a, uint b) internal returns (uint) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     function add(uint a, uint b) internal returns (uint) {
127         uint c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 
132     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
133         return a >= b ? a : b;
134     }
135 
136     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
137         return a < b ? a : b;
138     }
139 
140     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
141         return a >= b ? a : b;
142     }
143 
144     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
145         return a < b ? a : b;
146     }
147 
148     function assert(bool assertion) internal {
149         require(assertion);
150     }
151 }
152 
153 
154 /**
155  * @title ERC20Basic
156  * @dev Simpler version of ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20Basic {
160     uint public totalSupply;
161     function balanceOf(address who) constant returns (uint);
162     function transfer(address to, uint value);
163     event Transfer(address indexed from, address indexed to, uint value);
164 }
165 
166 
167 
168 
169 /**
170  * @title ERC20 interface
171  * @dev see https://github.com/ethereum/EIPs/issues/20
172  */
173 contract ERC20 is ERC20Basic {
174     function allowance(address owner, address spender) constant returns (uint);
175     function transferFrom(address from, address to, uint value);
176     function approve(address spender, uint value);
177     event Approval(address indexed owner, address indexed spender, uint value);
178 }
179 
180 
181 
182 
183 /**
184  * @title Basic token
185  * @dev Basic version of StandardToken, with no allowances.
186  */
187 contract BasicToken is ERC20Basic {
188     using SafeMath for uint;
189 
190     mapping(address => uint) balances;
191 
192     /**
193      * @dev Fix for the ERC20 short address attack.
194      */
195     modifier onlyPayloadSize(uint size) {
196         require(msg.data.length >= size + 4);
197         _;
198     }
199 
200     /**
201     * @dev transfer token for a specified address
202     * @param _to The address to transfer to.
203     * @param _value The amount to be transferred.
204     */
205     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208         Transfer(msg.sender, _to, _value);
209     }
210 
211     /**
212     * @dev Gets the balance of the specified address.
213     * @param _owner The address to query the the balance of.
214     * @return An uint representing the amount owned by the passed address.
215     */
216     function balanceOf(address _owner) constant returns (uint balance) {
217         return balances[_owner];
218     }
219 
220 }
221 
222 
223 
224 
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implemantation of the basic standart token.
229  * @dev https://github.com/ethereum/EIPs/issues/20
230  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  */
232 contract StandardToken is BasicToken, ERC20 {
233 
234     mapping (address => mapping (address => uint)) allowed;
235 
236 
237     /**
238      * @dev Transfer tokens from one address to another
239      * @param _from address The address which you want to send tokens from
240      * @param _to address The address which you want to transfer to
241      * @param _value uint the amout of tokens to be transfered
242      */
243     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
244         var _allowance = allowed[_from][msg.sender];
245 
246         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
247         // if (_value > _allowance) throw;
248 
249         balances[_to] = balances[_to].add(_value);
250         balances[_from] = balances[_from].sub(_value);
251         allowed[_from][msg.sender] = _allowance.sub(_value);
252         Transfer(_from, _to, _value);
253     }
254 
255     /**
256      * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
257      * @param _spender The address which will spend the funds.
258      * @param _value The amount of tokens to be spent.
259      */
260     function approve(address _spender, uint _value) {
261 
262         // To change the approve amount you first have to reduce the addresses`
263         //  allowance to zero by calling `approve(_spender, 0)` if it is not
264         //  already 0 to mitigate the race condition described here:
265         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266         require( ! ((_value != 0) && (allowed[msg.sender][_spender] != 0)) );
267 
268         allowed[msg.sender][_spender] = _value;
269         Approval(msg.sender, _spender, _value);
270     }
271 
272     /**
273      * @dev Function to check the amount of tokens than an owner allowed to a spender.
274      * @param _owner address The address which owns the funds.
275      * @param _spender address The address which will spend the funds.
276      * @return A uint specifing the amount of tokens still avaible for the spender.
277      */
278     function allowance(address _owner, address _spender) constant returns (uint remaining) {
279         return allowed[_owner][_spender];
280     }
281 
282 }
283 
284 
285 
286 
287 
288 
289 /**
290  * @title Mintable token
291  * @dev Simple ERC20 Token example, with mintable token creation
292  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
293  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
294  */
295 
296 contract MintableToken is StandardToken, Ownable {
297     event Mint(address indexed to, uint value);
298     event MintFinished();
299 
300     bool public mintingFinished = false;
301     uint public totalSupply = 0;
302 
303 
304     modifier canMint() {
305         require(! mintingFinished);
306         _;
307     }
308 
309     /**
310      * @dev Function to mint tokens
311      * @param _to The address that will recieve the minted tokens.
312      * @param _amount The amount of tokens to mint.
313      * @return A boolean that indicates if the operation was successful.
314      */
315     function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
316         totalSupply = totalSupply.add(_amount);
317         balances[_to] = balances[_to].add(_amount);
318         Mint(_to, _amount);
319         return true;
320     }
321 
322     /**
323      * @dev Function to stop minting new tokens.
324      * @return True if the operation was successful.
325      */
326     function finishMinting() onlyOwner returns (bool) {
327         mintingFinished = true;
328         MintFinished();
329         return true;
330     }
331 }
332 
333 
334 
335 
336 
337 
338 /**
339  * @title TopChainToken
340  * @dev The main TPC token contract
341  *
342  * ABI
343  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
344  */
345 contract TopCoin is MintableToken {
346 
347     string public name = "TopCoin";
348     string public symbol = "TPC";
349     uint public decimals = 6;
350 
351     bool public tradingStarted = false;
352 
353     /**
354      * @dev modifier that throws if trading has not started yet
355      */
356     modifier hasStartedTrading() {
357         require(tradingStarted);
358         _;
359     }
360 
361     /**
362      * @dev Allows the owner to enable the trading. This can not be undone
363      */
364     function startTrading() onlyOwner {
365         tradingStarted = true;
366     }
367 
368     /**
369      * @dev Allows anyone to transfer the PAY tokens once trading has started
370      * @param _to the recipient address of the tokens.
371      * @param _value number of tokens to be transfered.
372      */
373     function transfer(address _to, uint _value) hasStartedTrading {
374         super.transfer(_to, _value);
375     }
376 
377     /**
378     * @dev Allows anyone to transfer the PAY tokens once trading has started
379     * @param _from address The address which you want to send tokens from
380     * @param _to address The address which you want to transfer to
381     * @param _value uint the amout of tokens to be transfered
382     */
383     function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
384         super.transferFrom(_from, _to, _value);
385     }
386 
387 }
388 
389 
390 /**
391  * @title TopCoinDistribution
392  * @dev The main TPC token sale contract
393  *
394  * ABI
395  */
396 contract TopCoinDistribution is Ownable, Authorizable {
397     using SafeMath for uint;
398     event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
399     event AuthorizedCreate(address recipient, uint pay_amount);
400     event TopCoinSaleClosed();
401 
402     TopCoin public token = new TopCoin();
403 
404     address public multisigVault;
405 
406     uint public hardcap = 87500 ether;
407 
408     uint public rate = 3600*(10 ** 6); //1 ether : 3600 tpc
409 
410     uint totalToken = 2100000000 * (10 ** 6); //tpc
411 
412     uint public authorizeMintToken = 210000000 * (10 ** 6); //tpc
413 
414     uint public altDeposits = 0; //ether
415 
416     uint public start = 1504008000; //new Date("Aug 29 2017 20:00:00 GMT+8").getTime() / 1000;
417 
418     address partenersAddress = 0x6F3c01E350509b98665bCcF7c7D88C120C1762ef; //totalToken * 20%
419     address operationAddress = 0xb5B802F753bEe90C969aD27a94Da5C179Eaa3334; //totalToken * 20%
420     address technicalAddress = 0x62C1eC256B7bb10AA53FD4208454E1BFD533b7f0; //totalToken * 30%
421 
422     /**
423      * @dev modifier to allow token creation only when the sale IS ON
424      */
425     modifier saleIsOn() {
426         require(now > start && now < start + 28 days);
427         _;
428     }
429 
430     /**
431      * @dev modifier to allow token creation only when the hardcap has not been reached
432      */
433     modifier isUnderHardCap() {
434         require(multisigVault.balance + msg.value + altDeposits <= hardcap);
435         _;
436     }
437 
438     function isContract(address _addr) constant internal returns(bool) {
439         uint size;
440         if (_addr == 0) return false;
441         assembly {
442         size := extcodesize(_addr)
443         }
444         return size > 0;
445     }
446 
447     /**
448      * @dev Allows anyone to create tokens by depositing ether.
449      * @param recipient the recipient to receive tokens.
450      */
451     function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
452         require(!isContract(recipient));
453         uint tokens = rate.mul(msg.value).div(1 ether);
454         token.mint(recipient, tokens);
455         require(multisigVault.send(msg.value));
456         TokenSold(recipient, msg.value, tokens, rate);
457     }
458 
459     /**
460      * @dev Allows to set the authorize mint token
461      * @param _authorizeMintToken total amount ETH equivalent
462      */
463     function setAuthorizeMintToken(uint _authorizeMintToken) public onlyOwner {
464         authorizeMintToken = _authorizeMintToken;
465     }
466 
467     /**
468      * @dev Allows to set the total alt deposit measured in ETH to make sure the hardcap includes other deposits
469      * @param totalAltDeposits total amount ETH equivalent
470      */
471     function setAltDeposit(uint totalAltDeposits) public onlyOwner {
472         altDeposits = totalAltDeposits;
473     }
474 
475     /**
476      * @dev set eth : tpc rate
477      * @param _rate eth:tpc rate
478      */
479     function setRate(uint _rate) public onlyOwner {
480         rate = _rate;
481     }
482 
483 
484     /**
485      * @dev Allows authorized access to create tokens. This is used for Bitcoin and ERC20 deposits
486      * @param recipient the recipient to receive tokens.
487      * @param _tokens number of tokens to be created.
488      */
489     function authorizedCreateTokens(address recipient, uint _tokens) public onlyAuthorized {
490         uint tokens = _tokens * (10 ** 6);
491         uint totalSupply = token.totalSupply();
492         require(totalSupply + tokens <= authorizeMintToken);
493         token.mint(recipient, tokens);
494         AuthorizedCreate(recipient, tokens);
495     }
496 
497     /**
498      * @dev Allows the owner to set the hardcap.
499      * @param _hardcap the new hardcap
500      */
501     function setHardCap(uint _hardcap) public onlyOwner {
502         hardcap = _hardcap;
503     }
504 
505     /**
506      * @dev Allows the owner to set the starting time.
507      * @param _start the new _start
508      */
509     function setStart(uint _start) public onlyOwner {
510         start = _start;
511     }
512 
513     /**
514      * @dev Allows the owner to set the multisig contract.
515      * @param _multisigVault the multisig contract address
516      */
517     function setMultisigVault(address _multisigVault) public onlyOwner {
518         if (_multisigVault != address(0)) {
519             multisigVault = _multisigVault;
520         }
521     }
522 
523     /**
524      * @dev Allows the owner to finish the minting. This will create the
525      * restricted tokens and then close the minting.
526      * Then the ownership of the YES token contract is transfered
527      * to this owner.
528      */
529     function finishMinting() public onlyOwner {
530         uint issuedTokenSupply = token.totalSupply();
531         uint partenersTokens = totalToken.mul(20).div(100);
532         uint technicalTokens = totalToken.mul(30).div(100);
533         uint operationTokens = totalToken.mul(20).div(100);
534 
535         token.mint(partenersAddress, partenersTokens);
536         token.mint(technicalAddress, technicalTokens);
537         token.mint(operationAddress, operationTokens);
538 
539         uint restrictedTokens = totalToken.sub(issuedTokenSupply).sub(partenersTokens).sub(technicalTokens).sub(operationTokens);
540         token.mint(multisigVault, restrictedTokens);
541         token.finishMinting();
542         token.transferOwnership(owner);
543         TopCoinSaleClosed();
544     }
545 
546     /**
547      * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
548      * @param _token the contract address of the ERC20 contract
549      */
550     function retrieveTokens(address _token) public onlyOwner {
551         ERC20 token = ERC20(_token);
552         token.transfer(multisigVault, token.balanceOf(this));
553     }
554 
555     /**
556      * @dev Fallback function which receives ether and created the appropriate number of tokens for the
557      * msg.sender.
558      */
559     function() external payable {
560         createTokens(msg.sender);
561     }
562 
563 }