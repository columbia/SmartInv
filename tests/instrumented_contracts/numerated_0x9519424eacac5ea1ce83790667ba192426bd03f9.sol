1 pragma solidity ^0.4.15;
2 
3 /***********************JUST THE TIP (TOKEN)*************************
4 
5                           `.`.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,
6                           ``.``.:;;;;;JUST;;;;;;;;;;;;;;;;;;;;;;
7                           ````..``.:;;;;;;;;THE;;;;;;;;;;;;;;;;;
8       `                  ````````````..`.,:;;;;;;TIP;;;;;;;;;;:
9    `.```                 `````````````````.`.,:;;;;;;;;;;;;;;:
10    .````..               ``````````````````````     ```;;``
11       .                 ``` ###'```` #.`````````
12       ``                ```# ` # ``+@`@'```````..
13        .               ```@````',`@ ```# ````````
14          .             ````````@ ,+``` #````````..
15           .`         `.``````````` ``` @```````````````..
16              `.......  ``````````````````````````.         .`
17                        ``````            ````````.`         .`
18                        ``````            ````````.`          .`
19                        ```````          `````````.`            .
20                         ````````       `````````..              .
21                         
22 **************The token that still *technically* counts*************/
23 
24 /**
25  * @title Ownable
26  * @dev The Ownable contract has an owner address, and provides basic authorization control
27  * functions, this simplifies the implementation of "user permissions".
28  */
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     require(newOwner != address(0));
57     owner = newOwner;
58   }
59 
60 }
61 
62 /**
63  * @title SafeMath
64  * @dev Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a * b;
69     assert(a == 0 || c / a == b);
70     return c;
71   }
72 
73   function div(uint256 a, uint256 b) internal constant returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return c;
78   }
79 
80   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
81     assert(b <= a);
82     return a - b;
83   }
84 
85   function add(uint256 a, uint256 b) internal constant returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   uint256 public totalSupply;
99   function balanceOf(address who) constant returns (uint256);
100   function transfer(address to, uint256 value) returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant returns (uint256);
110   function transferFrom(address from, address to, uint256 value) returns (bool);
111   function approve(address spender, uint256 value) returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) returns (bool) {
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) constant returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
166     var _allowance = allowed[_from][msg.sender];
167 
168     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
169     // require (_value <= _allowance);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = _allowance.sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) returns (bool) {
184 
185     // To change the approve amount you first have to reduce the addresses`
186     //  allowance to zero by calling `approve(_spender, 0)` if it is not
187     //  already 0 to mitigate the race condition described here:
188     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
190 
191     allowed[msg.sender][_spender] = _value;
192     Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
203     return allowed[_owner][_spender];
204   }
205 
206     /*
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    */
212   function increaseApproval (address _spender, uint _addedValue)
213     returns (bool success) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   function decreaseApproval (address _spender, uint _subtractedValue)
220     returns (bool success) {
221     uint oldValue = allowed[msg.sender][_spender];
222     if (_subtractedValue > oldValue) {
223       allowed[msg.sender][_spender] = 0;
224     } else {
225       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
226     }
227     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 }
232 
233 /**
234  * @title Mintable token
235  * @dev Simple ERC20 Token example, with mintable token creation
236  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
237  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
238  */
239 
240 contract MintableToken is StandardToken, Ownable {
241   event Mint(address indexed to, uint256 amount);
242   event MintFinished();
243 
244   bool public mintingFinished = false;
245 
246 
247   modifier canMint() {
248     require(!mintingFinished);
249     _;
250   }
251 
252   /**
253    * @dev Function to mint tokens
254    * @param _to The address that will receive the minted tokens.
255    * @param _amount The amount of tokens to mint.
256    * @return A boolean that indicates if the operation was successful.
257    */
258   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
259     totalSupply = totalSupply.add(_amount);
260     balances[_to] = balances[_to].add(_amount);
261     Mint(_to, _amount);
262     Transfer(0x0, _to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 /**
278  * @title Crowdsale
279  * @dev Crowdsale is a base contract for managing a token crowdsale.
280  * Crowdsales have a start and end timestamps, where investors can make
281  * token purchases and the crowdsale will assign them tokens based
282  * on a token per ETH rate. Funds collected are forwarded to a wallet
283  * as they arrive.
284  */
285 contract Crowdsale {
286   using SafeMath for uint256;
287 
288   // The token being sold
289   MintableToken public token;
290 
291   // start and end timestamps where investments are allowed (both inclusive)
292   uint256 public startTime;
293   uint256 public endTime;
294 
295   // address where funds are collected
296   address public wallet;
297 
298   // how many token units a buyer gets per wei
299   uint256 public rate;
300 
301   // amount of raised money in wei
302   uint256 public weiRaised;
303 
304   /**
305    * event for token purchase logging
306    * @param purchaser who paid for the tokens
307    * @param beneficiary who got the tokens
308    * @param value weis paid for purchase
309    * @param amount amount of tokens purchased
310    */
311   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
312 
313 
314   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
315     require(_startTime >= now);
316     require(_endTime >= _startTime);
317     require(_rate > 0);
318     require(_wallet != 0x0);
319 
320     token = createTokenContract();
321     startTime = _startTime;
322     endTime = _endTime;
323     rate = _rate;
324     wallet = _wallet;
325   }
326 
327   // creates the token to be sold.
328   // override this method to have crowdsale of a specific mintable token.
329   function createTokenContract() internal returns (MintableToken) {
330     return new MintableToken();
331   }
332 
333 
334   // fallback function can be used to buy tokens
335   function () payable {
336     buyTokens(msg.sender);
337   }
338 
339   // low level token purchase function
340   function buyTokens(address beneficiary) payable {
341     require(beneficiary != 0x0);
342     require(validPurchase());
343 
344     uint256 weiAmount = msg.value;
345 
346     // calculate token amount to be created
347     uint256 tokens = weiAmount.mul(rate);
348 
349     // update state
350     weiRaised = weiRaised.add(weiAmount);
351 
352     token.mint(beneficiary, tokens);
353     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
354 
355     forwardFunds();
356   }
357 
358   // send ether to the fund collection wallet
359   // override to create custom fund forwarding mechanisms
360   function forwardFunds() internal {
361     wallet.transfer(msg.value);
362   }
363 
364   // @return true if the transaction can buy tokens
365   function validPurchase() internal constant returns (bool) {
366     bool withinPeriod = now >= startTime && now <= endTime;
367     bool nonZeroPurchase = msg.value != 0;
368     return withinPeriod && nonZeroPurchase;
369   }
370 
371   // @return true if crowdsale event has ended
372   function hasEnded() public constant returns (bool) {
373     return now > endTime;
374   }
375 }
376 
377 contract JustTheTipToken is MintableToken{
378   string public constant name = "Just The Tip";
379   string public constant symbol = "TIP";
380   uint8 public constant decimals = 18;
381 }
382 
383 contract JustTheTipCrowdsale is Crowdsale {
384 
385   function JustTheTipCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)  Crowdsale(_startTime, _endTime, _rate, _wallet) {
386   }
387 
388   function createTokenContract() internal returns (MintableToken) {
389     return new JustTheTipToken();
390   }
391 }