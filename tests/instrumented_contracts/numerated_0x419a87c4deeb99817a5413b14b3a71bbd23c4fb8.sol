1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11   /** 
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner. 
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to. 
30    */
31   function transferOwnership(address newOwner) onlyOwner public {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 
40 /**
41  * @title Authorizable
42  * @dev Allows to authorize access to certain function calls
43  * 
44  * ABI
45  * [{"constant": true,"inputs": [{"name": "authorizerIndex","type": "uint256"}],"name": "getAuthorizer","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_addr","type": "address"}],"name": "addAuthorized","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_addr","type": "address"}],"name": "isAuthorized","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"inputs": [],"payable": false,"stateMutability": "nonpayable","type": "constructor"}]
46  */
47 contract Authorizable {
48 
49   address[] authorizers;
50   mapping(address => uint) authorizerIndex;
51 
52   /**
53    * @dev Throws if called by any account tat is not authorized. 
54    */
55   modifier onlyAuthorized {
56     require(isAuthorized(msg.sender));
57     _;
58   }
59 
60   /**
61    * @dev Contructor that authorizes the msg.sender. 
62    */
63   function Authorizable() {
64     authorizers.length = 2;
65     authorizers[1] = msg.sender;
66     authorizerIndex[msg.sender] = 1;
67   }
68 
69   /**
70    * @dev Function to get a specific authorizer
71    * @param authorizerIndex index of the authorizer to be retrieved.
72    * @return The address of the authorizer.
73    */
74   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
75     return address(authorizers[authorizerIndex + 1]);
76   }
77 
78   /**
79    * @dev Function to check if an address is authorized
80    * @param _addr the address to check if it is authorized.
81    * @return boolean flag if address is authorized.
82    */
83   function isAuthorized(address _addr) constant returns(bool) {
84     return authorizerIndex[_addr] > 0;
85   }
86 
87   /**
88    * @dev Function to add a new authorizer
89    * @param _addr the address to add as a new authorizer.
90    */
91   function addAuthorized(address _addr) external onlyAuthorized {
92     authorizerIndex[_addr] = authorizers.length;
93     authorizers.length++;
94     authorizers[authorizers.length - 1] = _addr;
95   }
96 
97 }
98 
99 
100 /**
101  * Math operations with safety checks
102  */
103 library SafeMath {
104   function mul(uint a, uint b) internal returns (uint) {
105     uint c = a * b;
106     assert(a == 0 || c / a == b);
107     return c;
108   }
109 
110   function div(uint a, uint b) internal returns (uint) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   function sub(uint a, uint b) internal returns (uint) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   function add(uint a, uint b) internal returns (uint) {
123     uint c = a + b;
124     assert(c >= a);
125     return c;
126   }
127 
128   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
129     return a >= b ? a : b;
130   }
131 
132   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
133     return a < b ? a : b;
134   }
135 
136   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
137     return a >= b ? a : b;
138   }
139 
140   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
141     return a < b ? a : b;
142   }
143 
144 }
145 
146 
147 /**
148  * @title ExchangeRate
149  * @dev Allows updating and retrieveing of Conversion Rates for ABLE tokens
150  *
151  * ABI
152  * [{"constant": false,"inputs": [{"name": "_symbol","type": "string"},{"name": "_rate","type": "uint256"}],"name": "updateRate","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "data","type": "uint256[]"}],"name": "updateRates","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_symbol","type": "string"}],"name": "getRate","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "","type": "bytes32"}],"name": "rates","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": false,"name": "timestamp","type": "uint256"},{"indexed": false,"name": "symbol","type": "bytes32"},{"indexed": false,"name": "rate","type": "uint256"}],"name": "RateUpdated","type": "event"}]
153  */
154 contract ExchangeRate is Ownable {
155 
156   event RateUpdated(uint timestamp, bytes32 symbol, uint rate);
157 
158   mapping(bytes32 => uint) public rates;
159 
160   /**
161    * @dev Allows the current owner to update a single rate.
162    * @param _symbol The symbol to be updated. 
163    * @param _rate the rate for the symbol. 
164    */
165   function updateRate(string _symbol, uint _rate) public onlyOwner {
166     rates[sha3(_symbol)] = _rate;
167     RateUpdated(now, sha3(_symbol), _rate);
168   }
169 
170   /**
171    * @dev Allows the current owner to update multiple rates.
172    * @param data an array that alternates sha3 hashes of the symbol and the corresponding rate . 
173    */
174   function updateRates(uint[] data) public onlyOwner {
175     require(data.length % 2 == 0);
176     uint i = 0;
177     while (i < data.length / 2) {
178       bytes32 symbol = bytes32(data[i * 2]);
179       uint rate = data[i * 2 + 1];
180       rates[symbol] = rate;
181       RateUpdated(now, symbol, rate);
182       i++;
183     }
184   }
185 
186   /**
187    * @dev Allows the anyone to read the current rate.
188    * @param _symbol the symbol to be retrieved. 
189    */
190   function getRate(string _symbol) public constant returns(uint) {
191     return rates[sha3(_symbol)];
192   }
193 
194 }
195 
196 
197 /**
198  * @title HardCap
199  * @dev Allows updating and retrieveing of Conversion HardCap for ABLE tokens
200  *
201  * ABI
202  * [{"constant": true,"inputs": [{"name": "_symbol","type": "string"}],"name": "getCap","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_symbol","type": "string"},{"name": "_cap","type": "uint256"}],"name": "updateCap","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "data","type": "uint256[]"}],"name": "updateCaps","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "getHardCap","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "","type": "bytes32"}],"name": "caps","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": false,"name": "timestamp","type": "uint256"},{"indexed": false,"name": "symbol","type": "bytes32"},{"indexed": false,"name": "rate","type": "uint256"}],"name": "CapUpdated","type": "event"}]
203  */
204 contract HardCap is Ownable {
205   using SafeMath for uint;
206   event CapUpdated(uint timestamp, bytes32 symbol, uint rate);
207   
208   mapping(bytes32 => uint) public caps;
209   uint hardcap = 0;
210 
211   /**
212    * @dev Allows the current owner to update a single cap.
213    * @param _symbol The symbol to be updated. 
214    * @param _cap the cap for the symbol. 
215    */
216   function updateCap(string _symbol, uint _cap) public onlyOwner {
217     caps[sha3(_symbol)] = _cap;
218     hardcap = hardcap.add(_cap) ;
219     CapUpdated(now, sha3(_symbol), _cap);
220   }
221 
222   /**
223    * @dev Allows the current owner to update multiple caps.
224    * @param data an array that alternates sha3 hashes of the symbol and the corresponding cap . 
225    */
226   function updateCaps(uint[] data) public onlyOwner {
227     require(data.length % 2 == 0);
228     uint i = 0;
229     while (i < data.length / 2) {
230       bytes32 symbol = bytes32(data[i * 2]);
231       uint cap = data[i * 2 + 1];
232       caps[symbol] = cap;
233       hardcap = hardcap.add(cap);
234       CapUpdated(now, symbol, cap);
235       i++;
236     }
237   }
238 
239   /**
240    * @dev Allows the anyone to read the current cap.
241    * @param _symbol the symbol to be retrieved. 
242    */
243   function getCap(string _symbol) public constant returns(uint) {
244     return caps[sha3(_symbol)];
245   }
246   
247   /**
248    * @dev Allows the anyone to read the current hardcap.
249    */
250   function getHardCap() public constant returns(uint) {
251     return hardcap;
252   }
253 
254 }
255 
256 
257 /**
258  * @title ERC20Basic
259  * @dev Simpler version of ERC20 interface
260  * @dev see https://github.com/ethereum/EIPs/issues/20
261  */
262 contract ERC20Basic {
263   uint public totalSupply;
264   function balanceOf(address who) constant returns (uint);
265   function transfer(address to, uint value);
266   event Transfer(address indexed from, address indexed to, uint value);
267 }
268 
269 
270 /**
271  * @title ERC20 interface
272  * @dev see https://github.com/ethereum/EIPs/issues/20
273  */
274 contract ERC20 is ERC20Basic {
275   function allowance(address owner, address spender) constant returns (uint);
276   function transferFrom(address from, address to, uint value);
277   function approve(address spender, uint value);
278   event Approval(address indexed owner, address indexed spender, uint value);
279 }
280 
281 
282 /**
283  * @title Basic token
284  * @dev Basic version of StandardToken, with no allowances. 
285  */
286 contract BasicToken is ERC20Basic {
287   using SafeMath for uint;
288 
289   mapping(address => uint) balances;
290 
291   /**
292    * @dev Fix for the ERC20 short address attack.
293    */
294   modifier onlyPayloadSize(uint size) {
295      require(msg.data.length >= size + 4);
296      _;
297   }
298 
299   /**
300   * @dev transfer token for a specified address
301   * @param _to The address to transfer to.
302   * @param _value The amount to be transferred.
303   */
304   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
305     balances[msg.sender] = balances[msg.sender].sub(_value);
306     balances[_to] = balances[_to].add(_value);
307     Transfer(msg.sender, _to, _value);
308   }
309 
310   /**
311   * @dev Gets the balance of the specified address.
312   * @param _owner The address to query the the balance of. 
313   * @return An uint representing the amount owned by the passed address.
314   */
315   function balanceOf(address _owner) constant returns (uint balance) {
316     return balances[_owner];
317   }
318 
319 }
320 
321 
322 /**
323  * @title Standard ERC20 token
324  *
325  * @dev Implemantation of the basic standart token.
326  * @dev https://github.com/ethereum/EIPs/issues/20
327  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
328  */
329 contract StandardToken is BasicToken, ERC20 {
330 
331   mapping (address => mapping (address => uint)) allowed;
332 
333 
334   /**
335    * @dev Transfer tokens from one address to another
336    * @param _from address The address which you want to send tokens from
337    * @param _to address The address which you want to transfer to
338    * @param _value uint the amout of tokens to be transfered
339    */
340   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
341     var _allowance = allowed[_from][msg.sender];
342 
343     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
344     // if (_value > _allowance) throw;
345 
346     balances[_to] = balances[_to].add(_value);
347     balances[_from] = balances[_from].sub(_value);
348     allowed[_from][msg.sender] = _allowance.sub(_value);
349     Transfer(_from, _to, _value);
350   }
351 
352   /**
353    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
354    * @param _spender The address which will spend the funds.
355    * @param _value The amount of tokens to be spent.
356    */
357   function approve(address _spender, uint _value) {
358 
359     //  To change the approve amount you first have to reduce the addresses`
360     //  allowance to zero by calling `approve(_spender, 0)` if it is not
361     //  already 0 to mitigate the race condition described here:
362     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363     require(_value == 0);
364     require(allowed[msg.sender][_spender] == 0);
365 
366     allowed[msg.sender][_spender] = _value;
367     Approval(msg.sender, _spender, _value);
368   }
369 
370   /**
371    * @dev Function to check the amount of tokens than an owner allowed to a spender.
372    * @param _owner address The address which owns the funds.
373    * @param _spender address The address which will spend the funds.
374    * @return A uint specifing the amount of tokens still avaible for the spender.
375    */
376   function allowance(address _owner, address _spender) constant returns (uint remaining) {
377     return allowed[_owner][_spender];
378   }
379 
380 }
381 
382 
383 /**
384  * @title Mintable token
385  * @dev Simple ERC20 Token example, with mintable token creation
386  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
387  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
388  */
389 
390 contract MintableToken is StandardToken, Ownable {
391   event Mint(address indexed to, uint value);
392   event MintFinished();
393 
394   bool public mintingFinished = false;
395   uint public totalSupply = 0;
396 
397 
398   modifier canMint() {
399     require(!mintingFinished);
400     _;
401   }
402 
403   /**
404    * @dev Function to mint tokens
405    * @param _to The address that will recieve the minted tokens.
406    * @param _amount The amount of tokens to mint.
407    * @return A boolean that indicates if the operation was successful.
408    */
409   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
410     totalSupply = totalSupply.add(_amount);
411     balances[_to] = balances[_to].add(_amount);
412     Mint(_to, _amount);
413     return true;
414   }
415 
416   /**
417    * @dev Function to stop minting new tokens.
418    * @return True if the operation was successful.
419    */
420   function finishMinting() onlyOwner returns (bool) {
421     mintingFinished = true;
422     MintFinished();
423     return true;
424   }
425 
426 }
427 
428 
429 /**
430  * @title AbleTokoen
431  * @dev The main ABLE token contract
432  * 
433  * ABI 
434  * [{"constant": true,"inputs": [],"name": "mintingFinished","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "name","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_spender","type": "address"},{"name": "_value","type": "uint256"}],"name": "approve","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "totalSupply","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_from","type": "address"},{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transferFrom","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "startTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "decimals","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_amount","type": "uint256"}],"name": "mint","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "tradingStarted","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"}],"name": "balanceOf","outputs": [{"name": "balance","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [],"name": "stopTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "finishMinting","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "symbol","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_to","type": "address"},{"name": "_value","type": "uint256"}],"name": "transfer","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_owner","type": "address"},{"name": "_spender","type": "address"}],"name": "allowance","outputs": [{"name": "remaining","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"anonymous": false,"inputs": [{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Mint","type": "event"},{"anonymous": false,"inputs": [],"name": "MintFinished","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "owner","type": "address"},{"indexed": true,"name": "spender","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Approval","type": "event"},{"anonymous": false,"inputs": [{"indexed": true,"name": "from","type": "address"},{"indexed": true,"name": "to","type": "address"},{"indexed": false,"name": "value","type": "uint256"}],"name": "Transfer","type": "event"}]
435  */
436 contract AbleToken is MintableToken {
437 
438   string public name = "ABLE Token";
439   string public symbol = "ABLE";
440   uint public decimals = 18;
441 
442   bool public tradingStarted = false;
443 
444   /**
445    * @dev modifier that throws if trading has not started yet
446    */
447   modifier hasStartedTrading() {
448     require(tradingStarted);
449     _;
450   }
451 
452   /**
453    * @dev Allows the owner to enable the trading.
454    */
455   function startTrading() onlyOwner {
456     tradingStarted = true;
457   }
458   
459   /**
460    * @dev Allows the owner to disable the trading.
461    */
462   function stopTrading() onlyOwner {
463     tradingStarted = false;
464   }
465 
466   /**
467    * @dev Allows anyone to transfer the ABLE tokens once trading has started
468    * @param _to the recipient address of the tokens. 
469    * @param _value number of tokens to be transfered. 
470    */
471   function transfer(address _to, uint _value) hasStartedTrading {
472     super.transfer(_to, _value);
473   }
474 
475    /**
476    * @dev Allows anyone to transfer the ABLE tokens once trading has started
477    * @param _from address The address which you want to send tokens from
478    * @param _to address The address which you want to transfer to
479    * @param _value uint the amout of tokens to be transfered
480    */
481   function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
482     super.transferFrom(_from, _to, _value);
483   }
484 
485 }
486 
487 
488 /**
489  * @title MainSale
490  * @dev The main ABLE token sale contract
491  * 
492  * ABI
493  * [{"constant": false,"inputs": [{"name": "_multisigVault","type": "address"}],"name": "setMultisigVault","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "startTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "authorizerIndex","type": "uint256"}],"name": "getAuthorizer","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "exchangeRate","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "altDeposits","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_salePeriod","type": "string"}],"name": "setSalePeriod","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "recipient","type": "address"},{"name": "tokens","type": "uint256"}],"name": "authorizedCreateTokens","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "ethDeposits","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [],"name": "stopTrading","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [],"name": "finishMinting","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "owner","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_exchangeRate","type": "address"}],"name": "setExchangeRate","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "salePeriod","outputs": [{"name": "","type": "string"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_token","type": "address"}],"name": "retrieveTokens","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "totalAltDeposits","type": "uint256"}],"name": "setAltDeposit","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "start","outputs": [{"name": "","type": "uint256"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "recipient","type": "address"}],"name": "createTokens","outputs": [],"payable": true,"stateMutability": "payable","type": "function"},{"constant": false,"inputs": [{"name": "_addr","type": "address"}],"name": "addAuthorized","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "multisigVault","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "newOwner","type": "address"}],"name": "transferOwnership","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": false,"inputs": [{"name": "_start","type": "uint256"}],"name": "setStart","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [],"name": "hardCap","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": true,"inputs": [],"name": "token","outputs": [{"name": "","type": "address"}],"payable": false,"stateMutability": "view","type": "function"},{"constant": false,"inputs": [{"name": "_hardCap","type": "address"}],"name": "setHardCap","outputs": [],"payable": false,"stateMutability": "nonpayable","type": "function"},{"constant": true,"inputs": [{"name": "_addr","type": "address"}],"name": "isAuthorized","outputs": [{"name": "","type": "bool"}],"payable": false,"stateMutability": "view","type": "function"},{"payable": true,"stateMutability": "payable","type": "fallback"},{"anonymous": false,"inputs": [{"indexed": false,"name": "recipient","type": "address"},{"indexed": false,"name": "ether_amount","type": "uint256"},{"indexed": false,"name": "pay_amount","type": "uint256"},{"indexed": false,"name": "exchangerate","type": "uint256"}],"name": "TokenSold","type": "event"},{"anonymous": false,"inputs": [{"indexed": false,"name": "recipient","type": "address"},{"indexed": false,"name": "pay_amount","type": "uint256"}],"name": "AuthorizedCreate","type": "event"},{"anonymous": false,"inputs": [{"indexed": false,"name": "hardcap","type": "uint256[]"}],"name": "hardcapChanged","type": "event"},{"anonymous": false,"inputs": [{"indexed": false,"name": "salePeriod","type": "uint256"}],"name": "salePreiodChanged","type": "event"},{"anonymous": false,"inputs": [],"name": "MainSaleClosed","type": "event"}]
494  */
495 contract MainSale is Ownable, Authorizable {
496   using SafeMath for uint;
497   event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
498   event AuthorizedCreate(address recipient, uint pay_amount);
499   event hardcapChanged(uint[] hardcap);
500   event salePreiodChanged(uint salePeriod);
501   event MainSaleClosed();
502 
503   AbleToken public token = new AbleToken();
504 
505   address public multisigVault;
506   
507   ExchangeRate public exchangeRate;
508   HardCap public hardCap;
509   string public salePeriod = "";
510   uint public ethDeposits = 0;
511   uint public altDeposits = 0;
512   uint public start = 1519614000; // Mon, 26 Feb 2018 12:00:00 GMT+09:00
513 
514   /**
515    * @dev modifier to allow token creation only when the sale IS ON
516    */
517   modifier saleIsOn() {
518     require(now > start && now < start + 30 days);
519     _;
520   }
521 
522   /**
523    * @dev modifier to allow token creation only when the hardcap has not been reached
524    */
525   modifier isUnderHardCap() {
526     require(ethDeposits + altDeposits <= hardCap.getCap(salePeriod));
527     _;
528   }
529 
530   /**
531    * @dev Allows anyone to create tokens by depositing ether.
532    * @param recipient the recipient to receive tokens. 
533    */
534   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
535     uint rate;
536     rate = exchangeRate.getRate(salePeriod);
537     uint tokens = rate.mul(msg.value);
538     ethDeposits = ethDeposits.add(msg.value);
539     token.mint(recipient, tokens);
540     require(multisigVault.send(msg.value));
541     TokenSold(recipient, msg.value, tokens, rate);
542   }
543 
544 
545   /**
546    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
547    * @param totalAltDeposits total amount ETH equivalent
548    */
549   function setAltDeposit(uint totalAltDeposits) public onlyOwner {
550     altDeposits = totalAltDeposits;
551   }
552 
553   /**
554    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
555    * @param recipient the recipient to receive tokens.
556    * @param tokens the number of tokens to be created. 
557    */
558   function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
559     token.mint(recipient, tokens);
560     AuthorizedCreate(recipient, tokens);
561   }
562 
563 
564   /**
565    * @dev Allows the owner to set the starting time.
566    * @param _start the new _start
567    */
568   function setStart(uint _start) public onlyOwner {
569     start = _start;
570   }
571 
572   /**
573    * @dev Allows the owner to set the multisig contract.
574    * @param _multisigVault the multisig contract address
575    */
576   function setMultisigVault(address _multisigVault) public onlyOwner {
577     if (_multisigVault != address(0)) {
578       multisigVault = _multisigVault;
579     }
580   }
581 
582   /**
583    * @dev Allows the owner to set the exchangerate contract.
584    * @param _exchangeRate the exchangerate address
585    */
586   function setExchangeRate(address _exchangeRate) public onlyOwner {
587     exchangeRate = ExchangeRate(_exchangeRate);
588   }
589   
590   /**
591    * @dev Allows the owner to set the hardcap contract.
592    * @param _hardCap the hardcap address
593    */
594   function setHardCap(address _hardCap) public onlyOwner {
595     hardCap = HardCap(_hardCap);
596   }
597   
598   /**
599    * @dev Allows the owner to set the saleperiod.
600    * @param _salePeriod the saleperiod
601    */
602   function setSalePeriod(string _salePeriod) public onlyOwner {
603     salePeriod = _salePeriod;
604     ethDeposits = 0;
605   }
606 
607   /**
608    * @dev Allows the owner to finish the minting. This will create the 
609    * restricted tokens and then close the minting.
610    * Then the ownership of the ABLE token contract is transfered 
611    * to this owner.
612    */
613   function finishMinting() public onlyOwner {
614     token.finishMinting();
615     token.transferOwnership(owner);
616     MainSaleClosed();
617   }
618   
619   /**
620    * @dev Allows the owner to start the trading ABLE tokens. 
621    */
622   function startTrading() public onlyOwner {
623     token.startTrading();
624   }
625   
626   /**
627    * @dev Allows the owner to stop the trading ABLE tokens. 
628    */
629   function stopTrading() public onlyOwner {
630     token.stopTrading();
631   }
632 
633   /**
634    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
635    * @param _token the contract address of the ERC20 contract
636    */
637   function retrieveTokens(address _token) public onlyOwner {
638     ERC20 token = ERC20(_token);
639     token.transfer(multisigVault, token.balanceOf(this));
640   }
641 
642   /**
643    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
644    * msg.sender.
645    */
646   function() external payable {
647     createTokens(msg.sender);
648   }
649 
650 }