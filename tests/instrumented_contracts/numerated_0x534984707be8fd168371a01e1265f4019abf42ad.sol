1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65 
66   address public owner;
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   function Ownable() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) onlyOwner public {
89     require(newOwner != address(0));
90     owner = newOwner;
91   }
92 
93 }
94 /**
95  * @title Basic token
96  * @dev Basic version of StandardToken, with no allowances.
97  */
98 contract BasicToken is ERC20Basic, Ownable {
99 
100   using SafeMath for uint256;
101   mapping(address => uint256) balances;
102   // 1 denied / 0 allow
103   mapping(address => uint8) permissionsList;
104 
105   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
106     permissionsList[_address] = _sign;
107   }
108   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
109     return permissionsList[_address];
110   }
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(permissionsList[msg.sender] == 0);
118     require(_to != address(0));
119     require(_value <= balances[msg.sender]);
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public constant returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) allowed;
147 
148   /**
149    * @dev Transfer tokens from one address to another
150    * @param _from address The address which you want to send tokens from
151    * @param _to address The address which you want to transfer to
152    * @param _value uint256 the amount of tokens to be transferred
153    */
154   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155     require(permissionsList[_from] == 0);
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173 
174     // To change the approve amount you first have to reduce the addresses`
175     //  allowance to zero by calling `approve(_spender, 0)` if it is not
176     //  already 0 to mitigate the race condition described here:
177     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
179 
180     allowed[msg.sender][_spender] = _value;
181     emit Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifing the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
192     return allowed[_owner][_spender];
193   }
194 
195 }
196 
197 
198 /**
199  * @title Mintable token
200  * @dev Simple ERC20 Token example, with mintable token creation
201  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
202  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
203  */
204 contract MintableToken is StandardToken {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207 
208   bool public mintingFinished = false;
209 
210 
211   modifier canMint() {
212     require(!mintingFinished);
213     _;
214   }
215 
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
223     totalSupply = totalSupply.add(_amount);
224     balances[_to] = balances[_to].add(_amount);
225     emit Mint(_to, _amount);
226     emit Transfer(address(0), _to, _amount);
227     return true;
228   }
229 
230   /**
231    * @dev Function to stop minting new tokens.
232    * @return True if the operation was successful.
233    */
234   function finishMinting() onlyOwner canMint public returns (bool) {
235     mintingFinished = true;
236     MintFinished();
237     return true;
238   }
239 }
240 
241 contract BurnableByOwner is BasicToken {
242 
243   event Burn(address indexed burner, uint256 value);
244   function burn(address _address, uint256 _value) public onlyOwner{
245     require(_value <= balances[_address]);
246     // no need to require value <= totalSupply, since that would imply the
247     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
248 
249     address burner = _address;
250     balances[burner] = balances[burner].sub(_value);
251     totalSupply = totalSupply.sub(_value);
252     emit Burn(burner, _value);
253     emit Transfer(burner, address(0), _value);
254   }
255 }
256 
257 contract Wolf is Ownable, MintableToken, BurnableByOwner {
258   using SafeMath for uint256;
259   string public constant name = "Wolf";
260   string public constant symbol = "Wolf";
261   uint32 public constant decimals = 18;
262 
263   address public addressTeam;
264   address public addressCashwolf;
265   address public addressFutureInvest;
266   address public addressBounty;
267 
268 
269   uint public summTeam = 15000000000 * 1 ether;
270   uint public summCashwolf = 10000000000 * 1 ether;
271   uint public summFutureInvest = 10000000000 * 1 ether;
272   uint public summBounty = 1000000000 * 1 ether;
273 
274 
275   function Wolf() public {
276 	addressTeam = 0xb5AB520F01DeE8a42A2bfaEa8075398414774778;
277 	addressCashwolf = 0x3366e9946DD375d1966c8E09f889Bc18C5E1579A;
278 	addressFutureInvest = 0x7134121392eE0b6DC9382BBd8E392B4054CdCcEf;
279   addressBounty = 0x902A95ad8a292f5e355fCb8EcB761175D30b6fC6;
280 
281     //Founders and supporters initial Allocations
282     balances[addressTeam] = balances[addressTeam].add(summTeam);
283     balances[addressCashwolf] = balances[addressCashwolf].add(summCashwolf);
284 	  balances[addressFutureInvest] = balances[addressFutureInvest].add(summFutureInvest);
285     balances[addressBounty] = balances[addressBounty].add(summBounty);
286 
287     totalSupply = summTeam.add(summCashwolf).add(summFutureInvest).add(summBounty);
288   }
289   function getTotalSupply() public constant returns(uint256){
290       return totalSupply;
291   }
292 }
293 
294 
295 /**
296  * @title Crowdsale
297  * @dev Crowdsale is a base contract for managing a token crowdsale.
298  * Crowdsales have a start and end timestamps, where Contributors can make
299  * token Contributions and the crowdsale will assign them tokens based
300  * on a token per ETH rate. Funds collected are forwarded to a wallet
301  * as they arrive. The contract requires a MintableToken that will be
302  * minted as contributions arrive, note that the crowdsale contract
303  * must be owner of the token in order to be able to mint it.
304  */
305 contract Crowdsale is Ownable {
306   using SafeMath for uint256;
307   // soft cap
308   uint256 public softcap;
309   //A balance that does not include the amount of unconfirmed addresses.
310   //The balance which, if a soft cap is reached, can be transferred to the owner's wallet.
311   uint256 public activeBalance;
312   // balances for softcap
313   mapping(address => uint) public balancesSoftCap;
314   struct BuyInfo {
315     uint summEth;
316     uint summToken;
317     uint dateEndRefund;
318   }
319   mapping(address => mapping(uint => BuyInfo)) public payments;
320   mapping(address => uint) public paymentCounter;
321   // The token being offered
322   Wolf public token;
323   // start and end timestamps where investments are allowed (both inclusive)
324   // start
325   uint256 public startICO;
326   // end
327   uint256 public endICO;
328   uint256 public period;
329   uint256 public endICO14;
330   // token distribution
331   uint256 public hardCap;
332   uint256 public totalICO;
333   // how many token units a Contributor gets per wei
334   uint256 public rate;
335   // address where funds are collected
336   address public wallet;
337   // minimum/maximum quantity values
338   uint256 public minNumbPerSubscr;
339   uint256 public maxNumbPerSubscr;
340 
341 /**
342 * event for token Procurement logging
343 * @param contributor who Pledged for the tokens
344 * @param beneficiary who got the tokens
345 * @param value weis Contributed for Procurement
346 * @param amount amount of tokens Procured
347 */
348   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
349   function Crowdsale() public {
350     token = createTokenContract();
351     // soft cap
352     softcap = 5000 * 1 ether;
353     // minimum quantity values
354     minNumbPerSubscr = 10000000000000000; //0.01 eth
355     maxNumbPerSubscr = 300 * 1 ether;
356     // start and end timestamps where investments are allowed
357     // start
358     startICO = 1523455200;// 04/11/2018 @ 02:00pm (UTC)
359     period = 60;
360     // end
361     endICO = startICO + period * 1 days;
362     endICO14 = endICO + 14 * 1 days;
363     // restrictions on amounts during the crowdfunding event stages
364     hardCap = 65000000000 * 1 ether;
365     // rate;
366     rate = 500000;
367     // address where funds are collected
368     wallet = 0x7472106A07EbAB5a202e195c0dC22776778b44E6;
369   }
370 
371   function setStartICO(uint _startICO) public onlyOwner{
372     startICO = _startICO;
373     endICO = startICO + period * 1 days;
374     endICO14 = endICO + 14 * 1 days;
375   }
376 
377   function setPeriod(uint _period) public onlyOwner{
378     period = _period;
379     endICO = startICO + period * 1 days;
380     endICO14 = endICO + 14 * 1 days;
381   }
382 
383   function setRate(uint _rate) public  onlyOwner{
384     rate = _rate;
385   }
386 
387   function createTokenContract() internal returns (Wolf) {
388     return new Wolf();
389   }
390 
391   // fallback function can be used to Procure tokens
392   function () external payable {
393     procureTokens(msg.sender);
394   }
395 
396   // low level token Pledge function
397   function procureTokens(address beneficiary) public payable {
398     uint256 tokens;
399     uint256 weiAmount = msg.value;
400     uint256 backAmount;
401 
402     require(beneficiary != address(0));
403     //minimum/maximum amount in ETH
404     require(weiAmount >= minNumbPerSubscr && weiAmount <= maxNumbPerSubscr);
405     if (now >= startICO && now <= endICO && totalICO < hardCap){
406       tokens = weiAmount.mul(rate);
407       if (hardCap.sub(totalICO) < tokens){
408         tokens = hardCap.sub(totalICO);
409         weiAmount = tokens.div(rate);
410         backAmount = msg.value.sub(weiAmount);
411       }
412       totalICO = totalICO.add(tokens);
413     }
414     require(tokens > 0);
415     token.mint(beneficiary, tokens);
416     balancesSoftCap[beneficiary] = balancesSoftCap[beneficiary].add(weiAmount);
417     uint256 dateEndRefund = now + 14 * 1 days;
418     paymentCounter[beneficiary] = paymentCounter[beneficiary] + 1;
419     payments[beneficiary][paymentCounter[beneficiary]] = BuyInfo(weiAmount, tokens, dateEndRefund);
420     token.SetPermissionsList(beneficiary, 1);
421     if (backAmount > 0){
422       msg.sender.transfer(backAmount);
423     }
424     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
425   }
426 
427   function SetPermissionsList(address _address, uint8 _sign) public onlyOwner{
428       uint8 sign;
429       sign = token.GetPermissionsList(_address);
430       token.SetPermissionsList(_address, _sign);
431       if (_sign == 0){
432           if (sign != _sign){
433             activeBalance =  activeBalance.add(balancesSoftCap[_address]);
434           }
435 
436       }
437       if (_sign == 1){
438           if (sign != _sign){
439             activeBalance =  activeBalance.sub(balancesSoftCap[_address]);
440           }
441       }
442   }
443   function GetPermissionsList(address _address) public constant onlyOwner returns(uint8){
444     return token.GetPermissionsList(_address);
445   }
446   function refund() public{
447     require(activeBalance < softcap && now > endICO);
448     require(balancesSoftCap[msg.sender] > 0);
449     uint value = balancesSoftCap[msg.sender];
450     balancesSoftCap[msg.sender] = 0;
451     msg.sender.transfer(value);
452   }
453 
454   function refundUnconfirmed() public{
455     require(now > endICO);
456     require(balancesSoftCap[msg.sender] > 0);
457     require(token.GetPermissionsList(msg.sender) == 1);
458     uint value = balancesSoftCap[msg.sender];
459     balancesSoftCap[msg.sender] = 0;
460     msg.sender.transfer(value);
461     token.burn(msg.sender, token.balanceOf(msg.sender));
462     totalICO = totalICO.sub(token.balanceOf(msg.sender));
463   }
464 
465   function revoke(uint _id) public{
466     uint8 sign;
467     require(now <= payments[msg.sender][_id].dateEndRefund);
468     require(balancesSoftCap[msg.sender] > 0);
469     require(payments[msg.sender][_id].summEth > 0);
470     require(payments[msg.sender][_id].summToken > 0);
471     uint value = payments[msg.sender][_id].summEth;
472     uint valueToken = payments[msg.sender][_id].summToken;
473     balancesSoftCap[msg.sender] = balancesSoftCap[msg.sender].sub(value);
474     sign = token.GetPermissionsList(msg.sender);
475     if (sign == 0){
476       activeBalance =  activeBalance.sub(value);
477     }
478     payments[msg.sender][_id].summEth = 0;
479     payments[msg.sender][_id].summToken = 0;
480     msg.sender.transfer(value);
481     token.burn(msg.sender, valueToken);
482     totalICO = totalICO.sub(valueToken);
483   }
484 
485   function transferToMultisig() public onlyOwner {
486     require(activeBalance >= softcap && now > endICO14);
487       wallet.transfer(activeBalance);
488       activeBalance = 0;
489   }
490 }