1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 
34 /**
35  * @title ERC20Basic
36  * @dev Simpler version of ERC20 interface
37  * @dev see https://github.com/ethereum/EIPs/issues/179
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) constant returns (uint256);
42   function transfer(address to, uint256 value) returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 /**
48  * @title Basic token
49  * @dev Basic version of StandardToken, with no allowances. 
50  */
51 contract BasicToken is ERC20Basic {
52   using SafeMath for uint256;
53 
54   mapping(address => uint256) balances;
55 
56   /**
57   * @dev transfer token for a specified address
58   * @param _to The address to transfer to.
59   * @param _value The amount to be transferred.
60   */
61   function transfer(address _to, uint256 _value) returns (bool) {
62     balances[msg.sender] = balances[msg.sender].sub(_value);
63     balances[_to] = balances[_to].add(_value);
64     Transfer(msg.sender, _to, _value);
65     return true;
66   }
67 
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of. 
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint256);
85   function transferFrom(address from, address to, uint256 value) returns (bool);
86   function approve(address spender, uint256 value) returns (bool);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * @dev https://github.com/ethereum/EIPs/issues/20
95  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amout of tokens to be transfered
106    */
107   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108     var _allowance = allowed[_from][msg.sender];
109 
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112 
113     balances[_to] = balances[_to].add(_value);
114     balances[_from] = balances[_from].sub(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) returns (bool) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifing the amount of tokens still avaible for the spender.
143    */
144   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156   address public owner;
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) onlyOwner {
179     if (newOwner != address(0)) {
180       owner = newOwner;
181     }
182   }
183 
184 }
185 
186 /**
187  * @title Pausable
188  * @dev Base contract which allows children to implement an emergency stop mechanism.
189  */
190 contract Pausable is Ownable {
191   event Pause();
192   event Unpause();
193 
194   bool public paused = false;
195 
196   /**
197    * @dev modifier to allow actions only when the contract IS paused
198    */
199   modifier whenNotPaused() {
200     require(!paused);
201     _;
202   }
203 
204   /**
205    * @dev modifier to allow actions only when the contract IS NOT paused
206    */
207   modifier whenPaused {
208     require(paused);
209     _;
210   }
211 
212   /**
213    * @dev called by the owner to pause, triggers stopped state
214    */
215   function pause() onlyOwner whenNotPaused returns (bool) {
216     paused = true;
217     Pause();
218     return true;
219   }
220 
221   /**
222    * @dev called by the owner to unpause, returns to normal state
223    */
224   function unpause() onlyOwner whenPaused returns (bool) {
225     paused = false;
226     Unpause();
227     return true;
228   }
229 }
230 
231 /**
232  * @title Mintable token
233  * @dev Simple ERC20 Token example, with mintable token creation
234  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
235  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
236  */
237 
238 contract MintableToken is StandardToken, Ownable {
239   event Mint(address indexed to, uint256 amount);
240   event MintFinished();
241 
242   bool public mintingFinished = false;
243 
244   modifier canMint() {
245     require(!mintingFinished);
246     _;
247   }
248 
249   /**
250    * @dev Function to mint tokens
251    * @param _to The address that will recieve the minted tokens.
252    * @param _amount The amount of tokens to mint.
253    * @return A boolean that indicates if the operation was successful.
254    */
255   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
256     totalSupply = totalSupply.add(_amount);
257     balances[_to] = balances[_to].add(_amount);
258     Mint(_to, _amount);
259     Transfer(this, _to, _amount); // so it shows in etherscan
260     return true;
261   }
262 
263   /**
264    * @dev Function to stop minting new tokens.
265    * @return True if the operation was successful.
266    */
267   function finishMinting() onlyOwner returns (bool) {
268     mintingFinished = true;
269     MintFinished();
270     return true;
271   }
272 }
273 
274 /** 
275  * @title TokenDestructible:
276  * @author Remco Bloemen <remco@2π.com>
277  * @dev Base contract that can be destroyed by owner. All funds in contract including
278  * listed tokens will be sent to the owner.
279  */
280 contract TokenDestructible is Ownable {
281 
282   function TokenDestructible() payable { } 
283 
284   /** 
285    * @notice Terminate contract and refund to owner
286    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
287    refund.
288    * @notice The called token contracts could try to re-enter this contract. Only
289    supply token contracts you trust.
290    */
291   function destroy(address[] tokens) onlyOwner {
292 
293     // Transfer tokens to owner
294     for (uint256 i = 0; i < tokens.length; i++) {
295       ERC20Basic token = ERC20Basic(tokens[i]);
296       uint256 balance = token.balanceOf(this);
297       token.transfer(owner, balance);
298     }
299 
300     // Transfer Eth to owner and terminate contract
301     selfdestruct(owner);
302   }
303 }
304 
305 /**
306  * @title JesusCoin token
307  * @dev Simple ERC20 Token example, with mintable token creation
308  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
309  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
310  */
311 
312 contract JesusCoin is StandardToken, Ownable, TokenDestructible {
313 
314   string public name = "Jesus Coin";
315   uint8 public decimals = 18;
316   string public symbol = "JC";
317   string public version = "0.1";
318 
319   event Mint(address indexed to, uint256 amount);
320   event MintFinished();
321 
322   bool public mintingFinished = false;
323 
324   modifier canMint() {
325     require(!mintingFinished);
326     _;
327   }
328 
329   /**
330    * @dev Function to mint tokens
331    * @param _to The address that will recieve the minted tokens.
332    * @param _amount The amount of tokens to mint.
333    * @return A boolean that indicates if the operation was successful.
334    */
335   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
336     totalSupply = totalSupply.add(_amount);
337     balances[_to] = balances[_to].add(_amount);
338     Mint(_to, _amount);
339     return true;
340   }
341 
342   /**
343    * @dev Function to stop minting new tokens.
344    * @return True if the operation was successful.
345    */
346   function finishMinting() onlyOwner returns (bool) {
347     mintingFinished = true;
348     MintFinished();
349     return true;
350   }
351 }
352 
353 
354 /**
355  * @title Crowdsale 
356  * @dev Crowdsale is a base contract for managing a token crowdsale.
357  * Crowdsales have a start and end block, where investors can make
358  * token purchases and the crowdsale will assign them tokens based
359  * on a token per ETH rate. Funds collected are forwarded to a wallet 
360  * as they arrive.
361  */
362 contract JesusCrowdsale is Ownable, Pausable, TokenDestructible {
363   using SafeMath for uint256;
364 
365   // The token being sold
366   JesusCoin public token;
367 
368   // start and end dates where investments are allowed (both inclusive)
369   uint256 constant public START = 1507755600; // +new Date(2017, 9, 12) / 1000
370   uint256 constant public END = 1513029600; // +new Date(2017, 11, 12) / 1000
371 
372   // address where funds are collected
373   address public wallet = 0x61cc738Aef5D67ec7954B03871BA13dDe5B87DE8;
374   address public bountyWallet = 0x03D299B68f8a0e47edd0609FB2B77FC0F2e4fa9e;
375 
376   // amount of raised money in wei
377   uint256 public weiRaised;
378 
379   // has bounty been distributed?
380   bool public bountyDistributed;
381 
382   /**
383    * event for token purchase logging
384    * @param purchaser who paid for the tokens
385    * @param beneficiary who got the tokens
386    * @param value weis paid for purchase
387    * @param amount amount of tokens purchased
388    */ 
389   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
390   event BountyDistributed(address indexed bountyAddress, uint256 amount);
391 
392   function JesusCrowdsale() payable {
393     token = new JesusCoin();
394   }
395 
396   // function to get the price of the token
397   // returns how many token units a buyer gets per wei, needs to be divided by 10
398   function getRate() constant returns (uint8) {
399     if      (now < START)            return 166; // presale, 40% bonus
400     else if (now <= START +  6 days) return 162; // day 1 to 6, 35% bonus
401     else if (now <= START + 13 days) return 156; // day 7 to 13, 30% bonus
402     else if (now <= START + 20 days) return 150; // day 14 to 20, 25% bonus
403     else if (now <= START + 27 days) return 144; // day 21 to 27, 20% bonus
404     else if (now <= START + 34 days) return 138; // day 28 to 34, 15% bonus
405     else if (now <= START + 41 days) return 132; // day 35 to 41, 10% bonus
406     else if (now <= START + 48 days) return 126; // day 42 to 48, 5% bonus
407     return 120; // no bonus
408   }
409 
410   // fallback function can be used to buy tokens
411   function () payable {
412     buyTokens(msg.sender);
413   }
414 
415   // low level token purchase function
416   function buyTokens(address beneficiary) whenNotPaused() payable {
417     require(beneficiary != 0x0);
418     require(msg.value != 0);
419     require(now <= END);
420 
421     uint256 weiAmount = msg.value;
422 
423     // calculate token amount to be minted
424     uint256 tokens = weiAmount.mul(getRate()).div(10);
425     
426     // update state
427     weiRaised = weiRaised.add(weiAmount);
428 
429     token.mint(beneficiary, tokens);
430 
431     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
432 
433     wallet.transfer(msg.value);
434   }
435 
436   function distributeBounty() onlyOwner {
437     require(!bountyDistributed);
438     require(now >= END);
439 
440     bountyDistributed = true;
441 
442     // calculate token amount to be minted for bounty
443     uint256 amount = weiRaised.mul(2).div(100); // 2% of all tokens
444 
445     token.mint(bountyWallet, amount);
446     BountyDistributed(bountyWallet, amount);
447   }
448   
449   /**
450    * @dev Function to stop minting new tokens.
451    * @return True if the operation was successful.
452    */
453   function finishMinting() onlyOwner returns (bool) {
454     require(bountyDistributed);
455     require(now >= END);
456 
457     return token.finishMinting();
458   }
459 
460 }