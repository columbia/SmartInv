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
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     emit Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     uint256 _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     emit Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     emit Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() public {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner public {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 contract MintableToken is StandardToken, Ownable {
195   event Mint(address indexed to, uint256 amount);
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206   /**
207    * @dev Function to mint tokens
208    * @param _to The address that will receive the minted tokens.
209    * @param _amount The amount of tokens to mint.
210    * @return A boolean that indicates if the operation was successful.
211    */
212   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
213     totalSupply = totalSupply.add(_amount);
214     balances[_to] = balances[_to].add(_amount);
215     emit Mint(_to, _amount);
216     emit Transfer(address(0), _to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner canMint public returns (bool) {
225     mintingFinished = true;
226     emit MintFinished();
227     return true;
228   }
229 }
230 
231 contract BurnableByOwner is BasicToken, Ownable {
232 
233   event Burn(address indexed burner, uint256 value);
234   function burn(address _address, uint256 _value) public onlyOwner{
235     require(_value <= balances[_address]);
236     // no need to require value <= totalSupply, since that would imply the
237     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
238 
239     address burner = _address;
240     balances[burner] = balances[burner].sub(_value);
241     totalSupply = totalSupply.sub(_value);
242     emit Burn(burner, _value);
243     emit Transfer(burner, address(0), _value);
244   }
245 }
246 
247 contract Wolf is Ownable, MintableToken, BurnableByOwner {
248   using SafeMath for uint256;    
249   string public constant name = "Wolf";
250   string public constant symbol = "Wolf";
251   uint32 public constant decimals = 18;
252 
253   address public addressTeam;
254   address public addressCashwolf;
255   address public addressFutureInvest;
256 
257 
258   uint public summTeam = 15000000000 * 1 ether;
259   uint public summCashwolf = 10000000000 * 1 ether;
260   uint public summFutureInvest = 10000000000 * 1 ether;
261 
262 
263   function Wolf() public {
264 	addressTeam = 0xb5AB520F01DeE8a42A2bfaEa8075398414774778;
265 	addressCashwolf = 0x3366e9946DD375d1966c8E09f889Bc18C5E1579A;
266 	addressFutureInvest = 0x7134121392eE0b6DC9382BBd8E392B4054CdCcEf;
267 	
268 
269     //Founders and supporters initial Allocations
270     balances[addressTeam] = balances[addressTeam].add(summTeam);
271     balances[addressCashwolf] = balances[addressCashwolf].add(summCashwolf);
272 	balances[addressFutureInvest] = balances[addressFutureInvest].add(summFutureInvest);
273 
274     totalSupply = summTeam.add(summCashwolf).add(summFutureInvest);
275   }
276   function getTotalSupply() public constant returns(uint256){
277       return totalSupply;
278   }
279 }
280 
281 
282 
283 /**
284  * @title Crowdsale
285  * @dev Crowdsale is a base contract for managing a token crowdsale.
286  * Crowdsales have a start and end timestamps, where Contributors can make
287  * token Contributions and the crowdsale will assign them tokens based
288  * on a token per ETH rate. Funds collected are forwarded to a wallet
289  * as they arrive. The contract requires a MintableToken that will be
290  * minted as contributions arrive, note that the crowdsale contract
291  * must be owner of the token in order to be able to mint it.
292  */
293 contract Crowdsale is Ownable {
294   using SafeMath for uint256;
295   // soft cap
296   uint256 public softcap;
297   // balances for softcap
298   mapping(address => uint) public balancesSoftCap;
299   struct BuyInfo {
300     uint summEth;
301     uint summToken;
302     uint dateEndRefund;
303   }
304   mapping(address => mapping(uint => BuyInfo)) public payments;
305   mapping(address => uint) public paymentCounter;
306   // The token being offered
307   Wolf public token;
308   // start and end timestamps where investments are allowed (both inclusive)
309   // start
310   uint256 public startICO;
311   // end
312   uint256 public endICO;
313   uint256 public period;
314   uint256 public endICO14; 
315   // token distribution
316   uint256 public hardCap;
317   uint256 public totalICO;
318   // how many token units a Contributor gets per wei
319   uint256 public rate;   
320   // address where funds are collected
321   address public wallet;
322   // minimum/maximum quantity values
323   uint256 public minNumbPerSubscr; 
324   uint256 public maxNumbPerSubscr; 
325 
326 /**
327 * event for token Procurement logging
328 * @param contributor who Pledged for the tokens
329 * @param beneficiary who got the tokens
330 * @param value weis Contributed for Procurement
331 * @param amount amount of tokens Procured
332 */
333   event TokenProcurement(address indexed contributor, address indexed beneficiary, uint256 value, uint256 amount);
334   function Crowdsale() public {
335     token = createTokenContract();
336     // soft cap
337     softcap = 100 * 1 ether;   
338     // minimum quantity values
339     minNumbPerSubscr = 10000000000000000; //0.01 eth
340     maxNumbPerSubscr = 100 * 1 ether;
341     // start and end timestamps where investments are allowed
342     // start
343     startICO = 1521878400;// 03/24/2018 @ 8:00am (UTC)
344     period = 30;
345     // end
346     endICO = startICO + period * 1 days;
347     endICO14 = endICO + 14 * 1 days;
348     // restrictions on amounts during the crowdfunding event stages
349     hardCap = 65000000000 * 1 ether;
350     // rate;
351     rate = 1000000;
352     // address where funds are collected
353     wallet = 0x7472106A07EbAB5a202e195c0dC22776778b44E6;
354   }
355 
356   function setStartICO(uint _startICO) public onlyOwner{
357     startICO = _startICO;
358     endICO = startICO + period * 1 days;
359     endICO14 = endICO + 14 * 1 days;    
360   }
361 
362   function setPeriod(uint _period) public onlyOwner{
363     period = _period;
364     endICO = startICO + period * 1 days;
365     endICO14 = endICO + 14 * 1 days;    
366   }
367   
368   function setRate(uint _rate) public  onlyOwner{
369     rate = _rate;
370   }
371   
372   function createTokenContract() internal returns (Wolf) {
373     return new Wolf();
374   }
375 
376   // fallback function can be used to Procure tokens
377   function () external payable {
378     procureTokens(msg.sender);
379   }
380 
381   // low level token Pledge function
382   function procureTokens(address beneficiary) public payable {
383     uint256 tokens;
384     uint256 weiAmount = msg.value;
385     uint256 backAmount;
386     require(beneficiary != address(0));
387     //minimum/maximum amount in ETH
388     require(weiAmount >= minNumbPerSubscr && weiAmount <= maxNumbPerSubscr);
389     if (now >= startICO && now <= endICO && totalICO < hardCap){
390       tokens = weiAmount.mul(rate);
391       if (hardCap.sub(totalICO) < tokens){
392         tokens = hardCap.sub(totalICO); 
393         weiAmount = tokens.div(rate);
394         backAmount = msg.value.sub(weiAmount);
395       }
396       totalICO = totalICO.add(tokens);
397     }
398 
399     require(tokens > 0);
400     token.mint(beneficiary, tokens);
401     balancesSoftCap[beneficiary] = balancesSoftCap[beneficiary].add(weiAmount);
402 
403     uint256 dateEndRefund = now + 14 * 1 days;
404     paymentCounter[beneficiary] = paymentCounter[beneficiary] + 1;
405     payments[beneficiary][paymentCounter[beneficiary]] = BuyInfo(weiAmount, tokens, dateEndRefund); 
406     
407     if (backAmount > 0){
408       msg.sender.transfer(backAmount);  
409     }
410     emit TokenProcurement(msg.sender, beneficiary, weiAmount, tokens);
411   }
412 
413  
414   function refund() public{
415     require(address(this).balance < softcap && now > endICO);
416     require(balancesSoftCap[msg.sender] > 0);
417     uint value = balancesSoftCap[msg.sender];
418     balancesSoftCap[msg.sender] = 0;
419     msg.sender.transfer(value);
420   }
421   
422   function revoke(uint _id) public{
423     require(now <= payments[msg.sender][_id].dateEndRefund);
424     require(payments[msg.sender][_id].summEth > 0);
425     require(payments[msg.sender][_id].summToken > 0);
426     uint value = payments[msg.sender][_id].summEth;
427     uint valueToken = payments[msg.sender][_id].summToken;
428     balancesSoftCap[msg.sender] = balancesSoftCap[msg.sender].sub(value);
429     payments[msg.sender][_id].summEth = 0;
430     payments[msg.sender][_id].summToken = 0;
431     msg.sender.transfer(value);
432     token.burn(msg.sender, valueToken);
433    }  
434   
435   function transferToMultisig() public onlyOwner {
436     require(address(this).balance >= softcap && now > endICO14);  
437       wallet.transfer(address(this).balance);
438   }  
439 }