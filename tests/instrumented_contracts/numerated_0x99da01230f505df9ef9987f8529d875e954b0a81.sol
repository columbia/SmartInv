1 pragma solidity ^0.4.16;
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
259     return true;
260   }
261 
262   /**
263    * @dev Function to stop minting new tokens.
264    * @return True if the operation was successful.
265    */
266   function finishMinting() onlyOwner returns (bool) {
267     mintingFinished = true;
268     MintFinished();
269     return true;
270   }
271 }
272 
273 /** 
274  * @title TokenDestructible:
275  * @author Remco Bloemen <remco@2π.com>
276  * @dev Base contract that can be destroyed by owner. All funds in contract including
277  * listed tokens will be sent to the owner.
278  */
279 contract TokenDestructible is Ownable {
280 
281   function TokenDestructible() payable { } 
282 
283   /** 
284    * @notice Terminate contract and refund to owner
285    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
286    refund.
287    * @notice The called token contracts could try to re-enter this contract. Only
288    supply token contracts you trust.
289    */
290   function destroy(address[] tokens) onlyOwner {
291 
292     // Transfer tokens to owner
293     for (uint256 i = 0; i < tokens.length; i++) {
294       ERC20Basic token = ERC20Basic(tokens[i]);
295       uint256 balance = token.balanceOf(this);
296       token.transfer(owner, balance);
297     }
298 
299     // Transfer Eth to owner and terminate contract
300     selfdestruct(owner);
301   }
302 }
303 
304 /**
305  * @title JesusCoin token
306  * @dev Simple ERC20 Token example, with mintable token creation
307  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
308  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
309  */
310  
311 contract JesusCoin is StandardToken, Ownable, TokenDestructible {
312 
313   string public name = "Jesus Coin";
314   uint8 public decimals = 18;
315   string public symbol = "JC";
316   string public version = "0.2";
317 
318   event Mint(address indexed to, uint256 amount);
319   event MintFinished();
320 
321   bool public mintingFinished = false;
322 
323   modifier canMint() {
324     require(!mintingFinished);
325     _;
326   }
327 
328   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
329     totalSupply = totalSupply.add(_amount);
330     balances[_to] = balances[_to].add(_amount);
331     Mint(_to, _amount);
332     Transfer(0x0, _to, _amount);
333     return true;
334   }
335 
336   function finishMinting() onlyOwner returns (bool) {
337     mintingFinished = true;
338     MintFinished();
339     return true;
340   }
341 }
342 
343 
344 /**
345  * @title Crowdsale 
346  * @dev Crowdsale is a base contract for managing a token crowdsale.
347  * Crowdsales have a start and end block, where investors can make
348  * token purchases and the crowdsale will assign them tokens based
349  * on a token per ETH rate. Funds collected are forwarded to a wallet 
350  * as they arrive.
351  */
352 contract JesusCrowdsale is Ownable, Pausable, TokenDestructible {
353   using SafeMath for uint256;
354 
355   JesusCoin public token;
356 
357   uint256 constant public START = 1507755600; // +new Date(2017, 9, 12) / 1000
358   uint256 constant public END = 1513029600; // +new Date(2017, 11, 12) / 1000
359 
360   address public wallet = 0x61cc738Aef5D67ec7954B03871BA13dDe5B87DE8;
361   address public bountyWallet = 0x03D299B68f8a0e47edd0609FB2B77FC0F2e4fa9e;
362 
363   uint256 public weiRaised;
364 
365   bool public bountyDistributed;
366 
367   function JesusCrowdsale() payable {
368     token = new JesusCoin();
369   }
370 
371   // function to get the price of the token
372   // returns how many token units a buyer gets per wei, needs to be divided by 10
373   function getRate() constant returns (uint8) {
374     if      (block.timestamp < START)            return 166; // presale, 40% bonus
375     else if (block.timestamp <= START +  6 days) return 162; // day 1 to 6, 35% bonus
376     else if (block.timestamp <= START + 13 days) return 156; // day 7 to 13, 30% bonus
377     else if (block.timestamp <= START + 20 days) return 150; // day 14 to 20, 25% bonus
378     else if (block.timestamp <= START + 27 days) return 144; // day 21 to 27, 20% bonus
379     else if (block.timestamp <= START + 34 days) return 138; // day 28 to 34, 15% bonus
380     else if (block.timestamp <= START + 41 days) return 132; // day 35 to 41, 10% bonus
381     else if (block.timestamp <= START + 48 days) return 126; // day 42 to 48, 5% bonus
382     return 120; // no bonus
383   }
384 
385   // fallback function can be used to buy tokens
386   function () payable {
387     buyTokens(msg.sender);
388   }
389 
390   function buyTokens(address beneficiary) whenNotPaused() payable {
391     require(beneficiary != 0x0);
392     require(msg.value != 0);
393     require(block.timestamp <= END);
394 
395     uint256 weiAmount = msg.value;
396     weiRaised = weiRaised.add(weiAmount);
397 
398     uint256 tokens = weiAmount.mul(getRate()).div(10);
399     token.mint(beneficiary, tokens);
400 
401     wallet.transfer(msg.value);
402   }
403 
404   function distributeBounty() onlyOwner {
405     require(!bountyDistributed);
406     require(block.timestamp >= END);
407 
408     // calculate token amount to be minted for bounty
409     uint256 amount = weiRaised.div(100).mul(2); // 2% of all tokens
410     token.mint(bountyWallet, amount);
411     
412     bountyDistributed = true;
413   }
414   
415   /**
416    * @dev Function to stop minting new tokens.
417    * @return True if the operation was successful.
418    */
419   function finishMinting() onlyOwner returns (bool) {
420     require(bountyDistributed);
421     require(block.timestamp >= END);
422 
423     return token.finishMinting();
424   }
425 
426 }