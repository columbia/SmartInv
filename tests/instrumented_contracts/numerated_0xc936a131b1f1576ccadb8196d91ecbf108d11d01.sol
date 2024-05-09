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
79 
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) constant returns (uint256);
87   function transferFrom(address from, address to, uint256 value) returns (bool);
88   function approve(address spender, uint256 value) returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  * @dev https://github.com/ethereum/EIPs/issues/20
99  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  */
101 contract StandardToken is ERC20, BasicToken {
102 
103   mapping (address => mapping (address => uint256)) allowed;
104 
105 
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amout of tokens to be transfered
111    */
112   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
113     var _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_to] = balances[_to].add(_value);
119     balances[_from] = balances[_from].sub(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    * @param _spender The address which will spend the funds.
128    * @param _value The amount of tokens to be spent.
129    */
130   function approve(address _spender, uint256 _value) returns (bool) {
131 
132     // To change the approve amount you first have to reduce the addresses`
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134     //  already 0 to mitigate the race condition described here:
135     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
137 
138     allowed[msg.sender][_spender] = _value;
139     Approval(msg.sender, _spender, _value);
140     return true;
141   }
142 
143   /**
144    * @dev Function to check the amount of tokens that an owner allowed to a spender.
145    * @param _owner address The address which owns the funds.
146    * @param _spender address The address which will spend the funds.
147    * @return A uint256 specifing the amount of tokens still avaible for the spender.
148    */
149   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
150     return allowed[_owner][_spender];
151   }
152 
153 }
154 
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner {
188     if (newOwner != address(0)) {
189       owner = newOwner;
190     }
191   }
192 
193 }
194 
195 /**
196  * @title Pausable
197  * @dev Base contract which allows children to implement an emergency stop mechanism.
198  */
199 contract Pausable is Ownable {
200   event Pause();
201   event Unpause();
202 
203   bool public paused = false;
204 
205 
206   /**
207    * @dev modifier to allow actions only when the contract IS paused
208    */
209   modifier whenNotPaused() {
210     require(!paused);
211     _;
212   }
213 
214   /**
215    * @dev modifier to allow actions only when the contract IS NOT paused
216    */
217   modifier whenPaused {
218     require(paused);
219     _;
220   }
221 
222   /**
223    * @dev called by the owner to pause, triggers stopped state
224    */
225   function pause() onlyOwner whenNotPaused returns (bool) {
226     paused = true;
227     Pause();
228     return true;
229   }
230 
231   /**
232    * @dev called by the owner to unpause, returns to normal state
233    */
234   function unpause() onlyOwner whenPaused returns (bool) {
235     paused = false;
236     Unpause();
237     return true;
238   }
239 }
240 
241 
242 /**
243  * @title Mintable token
244  * @dev Simple ERC20 Token example, with mintable token creation
245  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
246  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
247  */
248 
249 contract MintableToken is StandardToken, Ownable {
250   event Mint(address indexed to, uint256 amount);
251   event MintFinished();
252 
253   bool public mintingFinished = false;
254 
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   /**
262    * @dev Function to mint tokens
263    * @param _to The address that will recieve the minted tokens.
264    * @param _amount The amount of tokens to mint.
265    * @return A boolean that indicates if the operation was successful.
266    */
267   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
268     totalSupply = totalSupply.add(_amount);
269     balances[_to] = balances[_to].add(_amount);
270     Mint(_to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 /**
286  * @title EmpireToken token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 
292 contract EmpireToken is StandardToken, Ownable {
293 
294   string public name = 'Empire Token';
295   uint8 public decimals = 18;
296   string public symbol = 'EMP';
297   string public version = '0.1';
298 
299   event Mint(address indexed to, uint256 amount);
300   event MintFinished();
301 
302   bool public mintingFinished = false;
303 
304 
305   modifier canMint() {
306     require(!mintingFinished);
307     _;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will recieve the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
317     totalSupply = totalSupply.add(_amount);
318     balances[_to] = balances[_to].add(_amount);
319     Mint(_to, _amount);
320     return true;
321   }
322 
323   /**
324    * @dev Function to stop minting new tokens.
325    * @return True if the operation was successful.
326    */
327   function finishMinting() onlyOwner returns (bool) {
328     mintingFinished = true;
329     MintFinished();
330     return true;
331   }
332 }
333 
334 
335 /**
336  * @title Crowdsale 
337  * @dev Crowdsale is a base contract for managing a token crowdsale.
338  * Crowdsales have a start and end block, where investors can make
339  * token purchases and the crowdsale will assign them tokens based
340  * on a token per ETH rate. Funds collected are forwarded to a wallet 
341  * as they arrive.
342  */
343 contract EmpireCrowdsale is Ownable, Pausable {
344   using SafeMath for uint256;
345 
346   // The token being sold
347   EmpireToken public token;
348 
349   // start and end dates where investments are allowed (both inclusive)
350   uint256 public start;
351   uint256 public end;
352 
353   // address where funds are collected
354   address public wallet;
355 
356   // amount of raised money in wei
357   uint256 public weiRaised;
358 
359   // amount of ether as presale and soft cap
360   uint256 public presaleCap;
361   uint256 public softCap;
362   uint256 public gracePeriodCap;
363     
364   uint256 public gracePeriodStart;
365 
366 
367 
368   /**
369    * event for token purchase logging
370    * @param purchaser who paid for the tokens
371    * @param beneficiary who got the tokens
372    * @param value weis paid for purchase
373    * @param amount amount of tokens purchased
374    */ 
375   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
376 
377   function EmpireCrowdsale(uint256 _start, uint256 _end, address _wallet, uint256 _presaleCap, uint256 _softCap, uint256 _graceCap) payable {
378     require(_start >= now);
379     require(_end >= _start);
380     require(_wallet != 0x0);
381     require(_presaleCap > 0);
382     require(_softCap > 0);
383     require(_graceCap > 0);
384 
385     start = _start;
386     end = _end;
387     wallet = _wallet;
388     token = new EmpireToken();
389     presaleCap = _presaleCap;   // in Ether
390     softCap = _softCap;         // in Ether
391     gracePeriodCap = _graceCap; // in Ether
392   }
393 
394   // function to get the price of the token
395   // returns how many token units a buyer gets per wei
396   function getRate() constant returns (uint) {
397     bool duringPresale = (now < start) && (weiRaised < presaleCap * 1 ether);
398     bool gracePeriodSet = gracePeriodStart != 0;
399     bool duringGracePeriod = gracePeriodSet && now <= gracePeriodStart + 24 hours;
400     uint rate = 1000;
401     
402     if (duringPresale) rate = 1300;               // presale, 30% bonus
403     else if (now <= start +  3 days) rate = 1250; // day 1 to 3, 25% bonus
404     else if (now <= start + 10 days) rate = 1150; // day 4 to 10, 15% bonus
405     else if (now <= start + 20 days) rate = 1050; // day 11 to 20, 5% bonus
406     
407     if (duringGracePeriod) return rate.sub(rate.div(10)); // 10% penalization
408     
409     return rate;
410   }
411 
412   // fallback function can be used to buy tokens
413   function () payable {
414     buyTokens(msg.sender);
415   }
416 
417   // low level token purchase function
418   function buyTokens(address beneficiary) whenNotPaused() payable {
419     require(beneficiary != 0x0);
420     require(msg.value != 0);
421     require(now <= end);
422 
423     // check if soft cap was reached, and for redefinition
424     if ((weiRaised >= softCap * 1 ether) && gracePeriodStart == 0) 
425       gracePeriodStart = block.timestamp;
426 
427     uint256 weiAmount = msg.value;
428 
429     // calculate token amount to be created
430     uint256 tokens = weiAmount.mul(getRate());
431     
432     // update state
433     weiRaised = weiRaised.add(weiAmount);
434 
435     token.mint(beneficiary, tokens);
436     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
437 
438     forwardFunds();
439   }
440 
441   // send ether to the fund collection wallet
442   // override to create custom fund forwarding mechanisms
443   function forwardFunds() internal {
444     wallet.transfer(msg.value);
445   }
446   
447   /**
448    * @dev Function to stop minting new tokens.
449    * @return True if the operation was successful.
450    */
451   function finishMinting() onlyOwner returns (bool) {
452     return token.finishMinting();
453   }
454 
455 
456 }