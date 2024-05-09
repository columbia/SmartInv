1 pragma solidity ^0.4.13;
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
26     require(msg.sender == owner);
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
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) constant returns (uint256);
92   function transferFrom(address from, address to, uint256 value) returns (bool);
93   function approve(address spender, uint256 value) returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) returns (bool) {
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) constant returns (uint256 balance) {
125     return balances[_owner];
126   }
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amout of tokens to be transfered
146    */
147   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
148     var _allowance = allowed[_from][msg.sender];
149 
150     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
151     // require (_value <= _allowance);
152 
153     balances[_to] = balances[_to].add(_value);
154     balances[_from] = balances[_from].sub(_value);
155     allowed[_from][msg.sender] = _allowance.sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) returns (bool) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifing the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
185     return allowed[_owner][_spender];
186   }
187 }
188 
189 
190 /**
191  * @title Mintable token
192  * @dev Simple ERC20 Token example, with mintable token creation
193  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
194  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
195  */
196 
197 contract MintableToken is StandardToken, Ownable {
198   event Mint(address indexed to, uint256 amount);
199   event MintFinished();
200 
201   bool public mintingFinished = false;
202 
203 
204   modifier canMint() {
205     require(!mintingFinished);
206     _;
207   }
208 
209   /**
210    * @dev Function to mint tokens
211    * @param _to The address that will recieve the minted tokens.
212    * @param _amount The amount of tokens to mint.
213    * @return A boolean that indicates if the operation was successful.
214    */
215   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
216     totalSupply = totalSupply.add(_amount);
217     balances[_to] = balances[_to].add(_amount);
218     Mint(_to, _amount);
219     return true;
220   }
221 
222   /**
223    * @dev Function to stop minting new tokens.
224    * @return True if the operation was successful.
225    */
226   function finishMinting() onlyOwner returns (bool) {
227     mintingFinished = true;
228     MintFinished();
229     return true;
230   }
231 }
232 
233 
234 contract DisbursableToken is MintableToken {
235   using SafeMath for uint256;
236 
237   struct Account {
238     uint claimedPoints;
239     uint allowedPoints;
240     uint lastPointsPerToken;
241   }
242 
243   event Disburse(address _source, uint _amount);
244   event ClaimDisbursement(address _account, uint _amount);
245   // The disbursement multiplier exists to correct rounding errors
246   // One disbursed wei = 1e18 disbursement points
247   uint pointMultiplier = 1e18;
248   uint totalPointsPerToken;
249   uint unclaimedDisbursement;
250   uint totalDisbursement;
251 
252   mapping(address => Account) accounts;
253 
254   /**
255    * @dev Function to send eth to owners of this token.
256    */
257   function disburse() public payable {
258     totalPointsPerToken = totalPointsPerToken.add(msg.value.mul(pointMultiplier).div(totalSupply));
259     unclaimedDisbursement = unclaimedDisbursement.add(msg.value);
260     totalDisbursement = totalDisbursement.add(msg.value);
261     Disburse(msg.sender, msg.value);
262   }
263 
264   /**
265    * @dev Function to update the claimable disbursements whenever tokens change hands
266    * @param _account address The address whose claimable disbursements should be updated
267    * @return A uint256 specifing the amount of wei still available for the owner.
268    */
269   function updatePoints(address _account) internal {
270     uint newPointsPerToken = totalPointsPerToken.sub(accounts[_account].lastPointsPerToken);
271     accounts[_account].allowedPoints = accounts[_account].allowedPoints.add(balances[_account].mul(newPointsPerToken));
272     accounts[_account].lastPointsPerToken = totalPointsPerToken;
273   }
274 
275   /**
276    * @dev Function to check the amount of wei that a token owner can claim.
277    * @param _owner address The address which owns the funds.
278    * @return A uint256 specifing the amount of wei still available for the owner.
279    */
280   function claimable(address _owner) constant returns (uint256 remaining) {
281     updatePoints(_owner);
282     return accounts[_owner].allowedPoints.sub(accounts[_owner].claimedPoints).div(pointMultiplier);
283   }
284 
285   /**
286    * @dev Function to claim the wei that a token owner is entitled to
287    * @param _amount uint256 How much of the wei the user will take
288    */
289   function claim(uint _amount) public {
290     require(_amount > 0);
291     updatePoints(msg.sender);
292     uint claimingPoints = _amount.mul(pointMultiplier);
293     require(accounts[msg.sender].claimedPoints.add(claimingPoints) <= accounts[msg.sender].allowedPoints);
294     accounts[msg.sender].claimedPoints = accounts[msg.sender].claimedPoints.add(claimingPoints);
295     ClaimDisbursement(msg.sender, _amount);
296     require(msg.sender.send(_amount));
297   }
298 
299   /**
300    * @dev Function to mint tokens. We need to modify this to update points.
301    * @param _to The address that will recieve the minted tokens.
302    * @param _amount The amount of tokens to mint.
303    * @return A boolean that indicates if the operation was successful.
304    */
305   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
306     updatePoints(_to);
307     super.mint(_to, _amount);
308   }
309 
310   function transfer(address _to, uint _value) returns(bool) {
311     updatePoints(msg.sender);
312     updatePoints(_to);
313     super.transfer(_to, _value);
314   }
315 
316   /**
317    * @dev Transfer tokens from one address to another while ensuring that claims remain where they are
318    * @param _from address The address which you want to send tokens from
319    * @param _to address The address which you want to transfer to
320    * @param _value uint256 the amout of tokens to be transfered
321    */
322   function transferFrom(address _from, address _to, uint _value) returns(bool) {
323     updatePoints(_from);
324     updatePoints(_to);
325     super.transferFrom(_from, _to, _value);
326   }
327 }
328 
329 
330 /**
331  * @title Hero token
332  * @dev This is the token being sold
333  *
334  * ABI
335  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint256"}],"name":"claim","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"claimable","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"disburse","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_source","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Disburse","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_account","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"ClaimDisbursement","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
336  */
337 
338 contract HeroToken is DisbursableToken {
339   string public name = "Hero Token";
340   string public symbol = "HERO";
341   uint public decimals = 18;
342 
343   bool public tradingStarted = false;
344   /**
345    * @dev modifier that throws if trading has not started yet
346    */
347   modifier hasStartedTrading() {
348     require(tradingStarted);
349     _;
350   }
351 
352   /**
353    * @dev Allows the owner to enable the trading. This can not be undone
354    */
355   function startTrading() onlyOwner {
356     tradingStarted = true;
357   }
358 
359   /**
360    * @dev Allows anyone to transfer the DEVE tokens once trading has started
361    * @param _to the recipient address of the tokens.
362    * @param _value number of tokens to be transfered.
363    */
364   function transfer(address _to, uint _value) hasStartedTrading returns(bool) {
365     super.transfer(_to, _value);
366   }
367 
368    /**
369    * @dev Allows anyone to transfer the DEVE tokens once trading has started
370    * @param _from address The address which you want to send tokens from
371    * @param _to address The address which you want to transfer to
372    * @param _value uint the amout of tokens to be transfered
373    */
374   function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns(bool) {
375     super.transferFrom(_from, _to, _value);
376   }
377 
378   function() external payable {
379     disburse();
380   }
381 }
382 
383 /**
384  * @title MainSale
385  * @dev The main HERO token sale contract
386  *
387  * ABI
388  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_minimum","type":"uint256"}],"name":"setMinimum","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"saleOngoing","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"base","type":"uint256"}],"name":"bonusTokens","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"minimum","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_saleOngoing","type":"bool"}],"name":"setSaleOngoing","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposits","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"hardcap","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"uint256"}],"name":"setExchangeRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardcap","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"token_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"token_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
389  */
390 contract MainSale is Ownable {
391   using SafeMath for uint;
392   event TokenSold(address recipient, uint ether_amount, uint token_amount, uint exchangerate);
393   event AuthorizedCreate(address recipient, uint token_amount);
394   event MainSaleClosed();
395 
396   HeroToken public token = new HeroToken();
397 
398   address public multisigVault = 0x877f1DAa6e6E9dc2764611D48c56172CE3547656;
399 
400   uint public hardcap = 250000 ether;
401   uint public exchangeRate = 200;
402   uint public minimum = 10 ether;
403 
404   uint public altDeposits = 0;
405   uint public start = 1504266900; //new Date("September 1, 2017 19:55:00 GMT+8").getTime() / 1000
406   bool public saleOngoing = true;
407 
408   /**
409    * @dev modifier to allow token creation only when the sale IS ON
410    */
411   modifier isSaleOn() {
412     require(start < now && saleOngoing && !token.mintingFinished());
413     _;
414   }
415 
416   /**
417    * @dev modifier to prevent buying tokens below the minimum required
418    */
419   modifier isOverMinimum() {
420     require(msg.value >= minimum);
421     _;
422   }
423 
424   /**
425    * @dev modifier to allow token creation only when the hardcap has not been reached
426    */
427   modifier isUnderHardcap() {
428     require(multisigVault.balance + altDeposits <= hardcap);
429     _;
430   }
431 
432   /*
433    * @dev Allows anyone to create tokens by depositing ether.
434    * @param recipient the recipient to receive tokens.
435    */
436   function createTokens(address recipient) public isOverMinimum isUnderHardcap isSaleOn payable {
437     uint base = exchangeRate.mul(msg.value).mul(10**token.decimals()).div(1 ether);
438     uint bonus = bonusTokens(base);
439     uint tokens = base.add(bonus);
440     token.mint(recipient, tokens);
441     require(multisigVault.send(msg.value));
442     TokenSold(recipient, msg.value, tokens, exchangeRate);
443   }
444 
445   /**
446    * @dev Computes the number of bonus tokens awarded based on the current time.
447    * @param base the original number of tokens made without counting the bonus
448    */
449   function bonusTokens(uint base) constant returns(uint) {
450     uint bonus = 0;
451     if (now <= start + 3 hours) {
452       bonus = base.mul(3).div(10);
453     } else if (now <= start + 24 hours) {
454       bonus = base.mul(2).div(10);
455     } else if (now <= start + 3 days) {
456       bonus = base.div(10);
457     } else if (now <= start + 7 days) {
458       bonus = base.div(20);
459     } else if (now <= start + 14 days) {
460       bonus = base.div(40);
461     }
462     return bonus;
463   }
464 
465   /**
466    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
467    * @param recipient the recipient to receive tokens.
468    * @param tokens number of tokens to be created.
469    */
470   function authorizedCreateTokens(address recipient, uint tokens) public onlyOwner {
471     token.mint(recipient, tokens);
472     AuthorizedCreate(recipient, tokens);
473   }
474 
475   /**
476    * @dev Allows the owner to set the starting time.
477    * @param _start the new _start
478    */
479   function setStart(uint _start) public onlyOwner {
480     start = _start;
481   }
482 
483   /**
484    * @dev Allows the owner to set the minimum purchase.
485    * @param _minimum the new _minimum
486    */
487   function setMinimum(uint _minimum) public onlyOwner {
488     minimum = _minimum;
489   }
490 
491   /**
492    * @dev Allows the owner to set the hardcap.
493    * @param _hardcap the new hardcap
494    */
495   function setHardcap(uint _hardcap) public onlyOwner {
496     hardcap = _hardcap;
497   }
498 
499   /**
500    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
501    * @param totalAltDeposits total amount ETH equivalent
502    */
503   function setAltDeposits(uint totalAltDeposits) public onlyOwner {
504     altDeposits = totalAltDeposits;
505   }
506 
507   /**
508    * @dev Allows the owner to set the multisig contract.
509    * @param _multisigVault the multisig contract address
510    */
511   function setMultisigVault(address _multisigVault) public onlyOwner {
512     if (_multisigVault != address(0)) {
513       multisigVault = _multisigVault;
514     }
515   }
516 
517   /**
518    * @dev Allows the owner to set the exchange rate
519    * @param _exchangeRate the exchangerate address
520    */
521   function setExchangeRate(uint _exchangeRate) public onlyOwner {
522     exchangeRate = _exchangeRate;
523   }
524 
525   /**
526    * @dev Allows the owner to stop the sale
527    * @param _saleOngoing whether the sale is ongoing or not
528    */
529   function setSaleOngoing(bool _saleOngoing) public onlyOwner {
530     saleOngoing = _saleOngoing;
531   }
532 
533   /**
534    * @dev Allows the owner to finish the minting.
535    * The ownership of the token contract is transfered
536    * to this owner.
537    */
538   function finishMinting() public onlyOwner {
539     token.finishMinting();
540     token.transferOwnership(owner);
541     MainSaleClosed();
542   }
543 
544   /**
545    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
546    * @param _token the contract address of the ERC20 contract
547    */
548   function retrieveTokens(address _token) public onlyOwner {
549     ERC20 foreignToken = ERC20(_token);
550     foreignToken.transfer(multisigVault, foreignToken.balanceOf(this));
551   }
552 
553   /**
554    * @dev Fallback function which receives ether and created the appropriate number of tokens for the
555    * msg.sender.
556    */
557   function() external payable {
558     createTokens(msg.sender);
559   }
560 }