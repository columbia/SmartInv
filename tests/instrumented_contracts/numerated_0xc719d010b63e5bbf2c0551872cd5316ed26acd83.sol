1 pragma solidity 0.4.24;
2 
3 // File: contracts/tokensale/DipTgeInterface.sol
4 
5 contract DipTgeInterface {
6     function tokenIsLocked(address _contributor) public constant returns (bool);
7 }
8 
9 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 // File: zeppelin-solidity/contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal constant returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal constant returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   uint256 public totalSupply;
94   function balanceOf(address who) public constant returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 // File: zeppelin-solidity/contracts/token/BasicToken.sol
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public constant returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public constant returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 // File: zeppelin-solidity/contracts/token/StandardToken.sol
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171 
172     uint256 _allowance = allowed[_from][msg.sender];
173 
174     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175     // require (_value <= _allowance);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = _allowance.sub(_value);
180     Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    */
216   function increaseApproval (address _spender, uint _addedValue)
217     returns (bool success) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   function decreaseApproval (address _spender, uint _subtractedValue)
224     returns (bool success) {
225     uint oldValue = allowed[msg.sender][_spender];
226     if (_subtractedValue > oldValue) {
227       allowed[msg.sender][_spender] = 0;
228     } else {
229       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230     }
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235 }
236 
237 // File: zeppelin-solidity/contracts/token/MintableToken.sol
238 
239 /**
240  * @title Mintable token
241  * @dev Simple ERC20 Token example, with mintable token creation
242  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
243  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
244  */
245 
246 contract MintableToken is StandardToken, Ownable {
247   event Mint(address indexed to, uint256 amount);
248   event MintFinished();
249 
250   bool public mintingFinished = false;
251 
252 
253   modifier canMint() {
254     require(!mintingFinished);
255     _;
256   }
257 
258   /**
259    * @dev Function to mint tokens
260    * @param _to The address that will receive the minted tokens.
261    * @param _amount The amount of tokens to mint.
262    * @return A boolean that indicates if the operation was successful.
263    */
264   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     Mint(_to, _amount);
268     Transfer(0x0, _to, _amount);
269     return true;
270   }
271 
272   /**
273    * @dev Function to stop minting new tokens.
274    * @return True if the operation was successful.
275    */
276   function finishMinting() onlyOwner public returns (bool) {
277     mintingFinished = true;
278     MintFinished();
279     return true;
280   }
281 }
282 
283 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
284 
285 /**
286  * @title Pausable
287  * @dev Base contract which allows children to implement an emergency stop mechanism.
288  */
289 contract Pausable is Ownable {
290   event Pause();
291   event Unpause();
292 
293   bool public paused = false;
294 
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is not paused.
298    */
299   modifier whenNotPaused() {
300     require(!paused);
301     _;
302   }
303 
304   /**
305    * @dev Modifier to make a function callable only when the contract is paused.
306    */
307   modifier whenPaused() {
308     require(paused);
309     _;
310   }
311 
312   /**
313    * @dev called by the owner to pause, triggers stopped state
314    */
315   function pause() onlyOwner whenNotPaused public {
316     paused = true;
317     Pause();
318   }
319 
320   /**
321    * @dev called by the owner to unpause, returns to normal state
322    */
323   function unpause() onlyOwner whenPaused public {
324     paused = false;
325     Unpause();
326   }
327 }
328 
329 // File: zeppelin-solidity/contracts/token/PausableToken.sol
330 
331 /**
332  * @title Pausable token
333  *
334  * @dev StandardToken modified with pausable transfers.
335  **/
336 
337 contract PausableToken is StandardToken, Pausable {
338 
339   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transfer(_to, _value);
341   }
342 
343   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
344     return super.transferFrom(_from, _to, _value);
345   }
346 
347   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
348     return super.approve(_spender, _value);
349   }
350 
351   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
352     return super.increaseApproval(_spender, _addedValue);
353   }
354 
355   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
356     return super.decreaseApproval(_spender, _subtractedValue);
357   }
358 }
359 
360 // File: contracts/token/DipToken.sol
361 
362 /**
363  * @title DIP Token
364  * @dev The Decentralized Insurance Platform Token.
365  * @author Christoph Mussenbrock
366  * @copyright 2017 Etherisc GmbH
367  */
368 
369 pragma solidity 0.4.24;
370 
371 
372 
373 
374 
375 contract DipToken is PausableToken, MintableToken {
376 
377   string public constant name = "Decentralized Insurance Protocol";
378   string public constant symbol = "DIP";
379   uint256 public constant decimals = 18;
380   uint256 public constant MAXIMUM_SUPPLY = 10**9 * 10**18; // 1 Billion 1'000'000'000
381 
382   DipTgeInterface public DipTokensale;
383 
384   constructor() public {
385     DipTokensale = DipTgeInterface(owner);
386   }
387 
388   modifier shouldNotBeLockedIn(address _contributor) {
389     // after LockIntTime2, we don't need to check anymore, and
390     // the DipTokensale contract is no longer required.
391     require(DipTokensale.tokenIsLocked(_contributor) == false);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will recieve the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(address _to, uint256 _amount) public returns (bool) {
402     if (totalSupply.add(_amount) > MAXIMUM_SUPPLY) {
403       return false;
404     }
405 
406     return super.mint(_to, _amount);
407   }
408 
409   /**
410    * Owner can transfer back tokens which have been sent to this contract by mistake.
411    * @param  _token address of token contract of the respective tokens
412    * @param  _to where to send the tokens
413    */
414   function salvageTokens(ERC20Basic _token, address _to) onlyOwner public {
415     _token.transfer(_to, _token.balanceOf(this));
416   }
417 
418   function transferFrom(address _from, address _to, uint256 _value) shouldNotBeLockedIn(_from) public returns (bool) {
419       return super.transferFrom(_from, _to, _value);
420   }
421 
422   function transfer(address to, uint256 value) shouldNotBeLockedIn(msg.sender) public returns (bool) {
423       return super.transfer(to, value);
424   }
425 }