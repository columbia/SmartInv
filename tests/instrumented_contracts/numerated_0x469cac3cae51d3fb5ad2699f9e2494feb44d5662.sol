1 pragma solidity ^0.4.13;
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
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     require(newOwner != address(0));
36     owner = newOwner;
37   }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) constant returns (uint256);
79   function transfer(address to, uint256 value) returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) returns (bool);
91   function approve(address spender, uint256 value) returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 /**
97  * @title Basic token
98  * @dev Basic version of StandardToken, with no allowances.
99  */
100 contract BasicToken is ERC20Basic {
101   using SafeMath for uint256;
102 
103   mapping(address => uint256) balances;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) returns (bool) {
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) constant returns (uint256 balance) {
123     return balances[_owner];
124   }
125 }
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amout of tokens to be transfered
145    */
146   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
147     var _allowance = allowed[_from][msg.sender];
148 
149     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
150     // require (_value <= _allowance);
151 
152     balances[_to] = balances[_to].add(_value);
153     balances[_from] = balances[_from].sub(_value);
154     allowed[_from][msg.sender] = _allowance.sub(_value);
155     Transfer(_from, _to, _value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) returns (bool) {
165 
166     // To change the approve amount you first have to reduce the addresses`
167     //  allowance to zero by calling `approve(_spender, 0)` if it is not
168     //  already 0 to mitigate the race condition described here:
169     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
171 
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifing the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
184     return allowed[_owner][_spender];
185   }
186 }
187 
188 
189 /**
190  * @title Mintable token
191  * @dev Simple ERC20 Token example, with mintable token creation
192  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
193  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
194  */
195 
196 contract MintableToken is StandardToken, Ownable {
197   event Mint(address indexed to, uint256 amount);
198   event MintFinished();
199 
200   bool public mintingFinished = false;
201 
202 
203   modifier canMint() {
204     require(!mintingFinished);
205     _;
206   }
207 
208   /**
209    * @dev Function to mint tokens
210    * @param _to The address that will recieve the minted tokens.
211    * @param _amount The amount of tokens to mint.
212    * @return A boolean that indicates if the operation was successful.
213    */
214   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
215     totalSupply = totalSupply.add(_amount);
216     balances[_to] = balances[_to].add(_amount);
217     Mint(_to, _amount);
218     return true;
219   }
220 
221   /**
222    * @dev Function to stop minting new tokens.
223    * @return True if the operation was successful.
224    */
225   function finishMinting() onlyOwner returns (bool) {
226     mintingFinished = true;
227     MintFinished();
228     return true;
229   }
230 }
231 
232 contract DisbursableToken is MintableToken {
233   using SafeMath for uint256;
234 
235   struct Account {
236     uint claimedPoints;
237     uint allowedPoints;
238     uint lastPointsPerToken;
239   }
240 
241   event Disburse(address _source, uint _amount);
242   event ClaimDisbursement(address _account, uint _amount);
243   // The disbursement multiplier exists to correct rounding errors
244   // One disbursed wei = 1e18 disbursement points
245   uint pointMultiplier = 1e18;
246   uint totalPointsPerToken;
247   uint unclaimedDisbursement;
248   uint totalDisbursement;
249 
250   mapping(address => Account) accounts;
251 
252   /**
253    * @dev Function to send eth to owners of this token.
254    */
255   function disburse() public payable {
256     totalPointsPerToken = totalPointsPerToken.add(msg.value.mul(pointMultiplier).div(totalSupply));
257     unclaimedDisbursement = unclaimedDisbursement.add(msg.value);
258     totalDisbursement = totalDisbursement.add(msg.value);
259     Disburse(msg.sender, msg.value);
260   }
261 
262   /**
263    * @dev Function to update the claimable disbursements whenever tokens change hands
264    * @param _account address The address whose claimable disbursements should be updated
265    * @return A uint256 specifing the amount of wei still available for the owner.
266    */
267   function updatePoints(address _account) internal {
268     uint newPointsPerToken = totalPointsPerToken.sub(accounts[_account].lastPointsPerToken);
269     accounts[_account].allowedPoints = accounts[_account].allowedPoints.add(balances[_account].mul(newPointsPerToken));
270     accounts[_account].lastPointsPerToken = totalPointsPerToken;
271   }
272 
273   /**
274    * @dev Function to check the amount of wei that a token owner can claim.
275    * @param _owner address The address which owns the funds.
276    * @return A uint256 specifing the amount of wei still available for the owner.
277    */
278   function claimable(address _owner) constant returns (uint256 remaining) {
279     updatePoints(_owner);
280     return accounts[_owner].allowedPoints.sub(accounts[_owner].claimedPoints).div(pointMultiplier);
281   }
282 
283   /**
284    * @dev Function to claim the wei that a token owner is entitled to
285    * @param _amount uint256 How much of the wei the user will take
286    */
287   function claim(uint _amount) public {
288     require(_amount > 0);
289     updatePoints(msg.sender);
290     uint claimingPoints = _amount.mul(pointMultiplier);
291     require(accounts[msg.sender].claimedPoints.add(claimingPoints) <= accounts[msg.sender].allowedPoints);
292     accounts[msg.sender].claimedPoints = accounts[msg.sender].claimedPoints.add(claimingPoints);
293     ClaimDisbursement(msg.sender, _amount);
294     require(msg.sender.send(_amount));
295   }
296 
297   /**
298    * @dev Function to mint tokens. We need to modify this to update points.
299    * @param _to The address that will recieve the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
304     updatePoints(_to);
305     super.mint(_to, _amount);
306   }
307 
308   function transfer(address _to, uint _value) returns(bool) {
309     updatePoints(msg.sender);
310     updatePoints(_to);
311     super.transfer(_to, _value);
312   }
313 
314   /**
315    * @dev Transfer tokens from one address to another while ensuring that claims remain where they are
316    * @param _from address The address which you want to send tokens from
317    * @param _to address The address which you want to transfer to
318    * @param _value uint256 the amout of tokens to be transfered
319    */
320   function transferFrom(address _from, address _to, uint _value) returns(bool) {
321     updatePoints(_from);
322     updatePoints(_to);
323     super.transferFrom(_from, _to, _value);
324   }
325 }
326 
327 
328 /**
329  * @title Hero token
330  * @dev This is the token being sold
331  *
332  * ABI
333  * [{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"startTrading","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint256"}],"name":"claim","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"claimable","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"tradingStarted","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"balance","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"disburse","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_source","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"Disburse","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_account","type":"address"},{"indexed":false,"name":"_amount","type":"uint256"}],"name":"ClaimDisbursement","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}]
334  */
335 
336 contract HeroToken is DisbursableToken {
337   string public name = "Hero Token";
338   string public symbol = "HERO";
339   uint public decimals = 18;
340 
341   bool public tradingStarted = false;
342   /**
343    * @dev modifier that throws if trading has not started yet
344    */
345   modifier hasStartedTrading() {
346     require(tradingStarted);
347     _;
348   }
349 
350   /**
351    * @dev Allows the owner to enable the trading. This can not be undone
352    */
353   function startTrading() onlyOwner {
354     tradingStarted = true;
355   }
356 
357   /**
358    * @dev Allows anyone to transfer the DEVE tokens once trading has started
359    * @param _to the recipient address of the tokens.
360    * @param _value number of tokens to be transfered.
361    */
362   function transfer(address _to, uint _value) hasStartedTrading returns(bool) {
363     super.transfer(_to, _value);
364   }
365 
366    /**
367    * @dev Allows anyone to transfer the DEVE tokens once trading has started
368    * @param _from address The address which you want to send tokens from
369    * @param _to address The address which you want to transfer to
370    * @param _value uint the amout of tokens to be transfered
371    */
372   function transferFrom(address _from, address _to, uint _value) hasStartedTrading returns(bool) {
373     super.transferFrom(_from, _to, _value);
374   }
375 
376   function() external payable {
377     disburse();
378   }
379 }
380 
381 /**
382  * @title MainSale
383  * @dev The main HERO token sale contract
384  *
385  * ABI
386  * [{"constant":false,"inputs":[{"name":"_multisigVault","type":"address"}],"name":"setMultisigVault","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"saleOngoing","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"exchangeRate","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"base","type":"uint256"}],"name":"bonusTokens","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"altDeposits","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"},{"name":"tokens","type":"uint256"}],"name":"authorizedCreateTokens","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_saleOngoing","type":"bool"}],"name":"setSaleOngoing","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"totalAltDeposits","type":"uint256"}],"name":"setAltDeposits","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"}],"name":"retrieveTokens","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"hardcap","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"recipient","type":"address"}],"name":"createTokens","outputs":[],"payable":true,"type":"function"},{"constant":true,"inputs":[],"name":"multisigVault","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"uint256"}],"name":"setExchangeRate","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_hardcap","type":"uint256"}],"name":"setHardcap","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"}],"name":"setStart","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"token","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"payable":true,"type":"fallback"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"ether_amount","type":"uint256"},{"indexed":false,"name":"token_amount","type":"uint256"},{"indexed":false,"name":"exchangerate","type":"uint256"}],"name":"TokenSold","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"recipient","type":"address"},{"indexed":false,"name":"token_amount","type":"uint256"}],"name":"AuthorizedCreate","type":"event"},{"anonymous":false,"inputs":[],"name":"MainSaleClosed","type":"event"}]
387  */
388 contract MainSale is Ownable {
389   using SafeMath for uint;
390   event TokenSold(address recipient, uint ether_amount, uint token_amount, uint exchangerate);
391   event AuthorizedCreate(address recipient, uint token_amount);
392   event MainSaleClosed();
393 
394   HeroToken public token = new HeroToken();
395 
396   address public multisigVault;
397 
398   uint public hardcap = 250000 ether;
399   uint public exchangeRate = 200;
400 
401   uint public altDeposits = 0;
402   uint public start = 1609372800; //new Date("December 31, 2020 00:00:00").getTime() / 1000
403   bool public saleOngoing = true;
404 
405   /**
406    * @dev modifier to allow token creation only when the sale IS ON
407    */
408   modifier isSaleOn() {
409     require(start < now && saleOngoing && !token.mintingFinished());
410     _;
411   }
412 
413   /**
414    * @dev modifier to allow token creation only when the hardcap has not been reached
415    */
416   modifier isUnderHardcap() {
417     require(multisigVault.balance + altDeposits <= hardcap);
418     _;
419   }
420 
421   /*
422    * @dev Allows anyone to create tokens by depositing ether.
423    * @param recipient the recipient to receive tokens.
424    */
425   function createTokens(address recipient) public isUnderHardcap isSaleOn payable {
426     uint base = exchangeRate.mul(msg.value).mul(10**token.decimals()).div(1 ether);
427     uint bonus = bonusTokens(base);
428     uint tokens = base.add(bonus);
429     token.mint(recipient, tokens);
430     require(multisigVault.send(msg.value));
431     TokenSold(recipient, msg.value, tokens, exchangeRate);
432   }
433 
434   /**
435    * @dev Computes the number of bonus tokens awarded based on the current time.
436    * @param base the original number of tokens made without counting the bonus
437    */
438   function bonusTokens(uint base) constant returns(uint) {
439     uint bonus = 0;
440     if (now <= start + 3 hours) {
441       bonus = base.mul(3).div(10);
442     } else if (now <= start + 24 hours) {
443       bonus = base.mul(2).div(10);
444     } else if (now <= start + 3 days) {
445       bonus = base.div(10);
446     } else if (now <= start + 7 days) {
447       bonus = base.div(20);
448     } else if (now <= start + 14 days) {
449       bonus = base.div(40);
450     }
451     return bonus;
452   }
453 
454   /**
455    * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
456    * @param recipient the recipient to receive tokens.
457    * @param tokens number of tokens to be created.
458    */
459   function authorizedCreateTokens(address recipient, uint tokens) public onlyOwner {
460     token.mint(recipient, tokens);
461     AuthorizedCreate(recipient, tokens);
462   }
463 
464   /**
465    * @dev Allows the owner to set the starting time.
466    * @param _start the new _start
467    */
468   function setStart(uint _start) public onlyOwner {
469     start = _start;
470   }
471 
472   /**
473    * @dev Allows the owner to set the hardcap.
474    * @param _hardcap the new hardcap
475    */
476   function setHardcap(uint _hardcap) public onlyOwner {
477     hardcap = _hardcap;
478   }
479 
480   /**
481    * @dev Allows to set the toal alt deposit measured in ETH to make sure the hardcap includes other deposits
482    * @param totalAltDeposits total amount ETH equivalent
483    */
484   function setAltDeposits(uint totalAltDeposits) public onlyOwner {
485     altDeposits = totalAltDeposits;
486   }
487 
488   /**
489    * @dev Allows the owner to set the multisig contract.
490    * @param _multisigVault the multisig contract address
491    */
492   function setMultisigVault(address _multisigVault) public onlyOwner {
493     if (_multisigVault != address(0)) {
494       multisigVault = _multisigVault;
495     }
496   }
497 
498   /**
499    * @dev Allows the owner to set the exchange rate
500    * @param _exchangeRate the exchangerate address
501    */
502   function setExchangeRate(uint _exchangeRate) public onlyOwner {
503     exchangeRate = _exchangeRate;
504   }
505 
506   /**
507    * @dev Allows the owner to stop the sale
508    * @param _saleOngoing whether the sale is ongoing or not
509    */
510   function setSaleOngoing(bool _saleOngoing) public onlyOwner {
511     saleOngoing = _saleOngoing;
512   }
513 
514   /**
515    * @dev Allows the owner to finish the minting.
516    * The ownership of the token contract is transfered
517    * to this owner.
518    */
519   function finishMinting() public onlyOwner {
520     token.finishMinting();
521     token.transferOwnership(owner);
522     MainSaleClosed();
523   }
524 
525   /**
526    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
527    * @param _token the contract address of the ERC20 contract
528    */
529   function retrieveTokens(address _token) public onlyOwner {
530     ERC20 foreignToken = ERC20(_token);
531     foreignToken.transfer(multisigVault, foreignToken.balanceOf(this));
532   }
533 
534   /**
535    * @dev Fallback function which receives ether and created the appropriate number of tokens for the
536    * msg.sender.
537    */
538   function() external payable {
539     createTokens(msg.sender);
540   }
541 }