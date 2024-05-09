1 pragma solidity ^0.4.11;
2 
3 //
4 // SafeMath
5 //
6 // Ownable
7 // Destructible
8 // Pausable
9 //
10 // ERC20Basic
11 // ERC20 : ERC20Basic
12 // BasicToken : ERC20Basic
13 // StandardToken : ERC20, BasicToken
14 // MintableToken : StandardToken, Ownable
15 // PausableToken : StandardToken, Pausable
16 //
17 // CAToken : MintableToken, PausableToken
18 //
19 // Crowdsale
20 // PausableCrowdsale
21 // BonusCrowdsale
22 // TokensCappedCrowdsale
23 // FinalizableCrowdsale
24 //
25 // CATCrowdsale
26 //
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address newOwner) onlyOwner public {
93     require(newOwner != address(0));
94     OwnershipTransferred(owner, newOwner);
95     owner = newOwner;
96   }
97 
98 }
99 
100 /**
101  * @title Destructible
102  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
103  */
104 contract Destructible is Ownable {
105 
106   function Destructible() public payable { }
107 
108   /**
109    * @dev Transfers the current balance to the owner and terminates the contract.
110    */
111   function destroy() onlyOwner public {
112     selfdestruct(owner);
113   }
114 
115   function destroyAndSend(address _recipient) onlyOwner public {
116     selfdestruct(_recipient);
117   }
118 }
119 
120 /**
121  * @title Pausable
122  * @dev Base contract which allows children to implement an emergency stop mechanism.
123  */
124 contract Pausable is Ownable {
125   event Pause();
126   event Unpause();
127 
128   bool public paused = false;
129 
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is not paused.
133    */
134   modifier whenNotPaused() {
135     require(!paused);
136     _;
137   }
138 
139   /**
140    * @dev Modifier to make a function callable only when the contract is paused.
141    */
142   modifier whenPaused() {
143     require(paused);
144     _;
145   }
146 
147   /**
148    * @dev called by the owner to pause, triggers stopped state
149    */
150   function pause() onlyOwner whenNotPaused public {
151     paused = true;
152     Pause();
153   }
154 
155   /**
156    * @dev called by the owner to unpause, returns to normal state
157    */
158   function unpause() onlyOwner whenPaused public {
159     paused = false;
160     Unpause();
161   }
162 }
163 
164 /**
165  * @title ERC20Basic
166  * @dev Simpler version of ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/179
168  */
169 contract ERC20Basic {
170   uint256 public totalSupply;
171   function balanceOf(address who) public constant returns (uint256);
172   function transfer(address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender) public constant returns (uint256);
182   function transferFrom(address from, address to, uint256 value) public returns (bool);
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   /**
197   * @dev transfer token for a specified address
198   * @param _to The address to transfer to.
199   * @param _value The amount to be transferred.
200   */
201   function transfer(address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203 
204     // SafeMath.sub will throw if there is not enough balance.
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     Transfer(msg.sender, _to, _value);
208     return true;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) public constant returns (uint256 balance) {
217     return balances[_owner];
218   }
219 
220 }
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242 
243     uint256 _allowance = allowed[_from][msg.sender];
244 
245     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
246     // require (_value <= _allowance);
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = _allowance.sub(_value);
251     Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    *
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value) public returns (bool) {
266     allowed[msg.sender][_spender] = _value;
267     Approval(msg.sender, _spender, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * approve should be called when allowed[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    */
287   function increaseApproval (address _spender, uint _addedValue) public
288     returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public
295     returns (bool success) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
334     totalSupply = totalSupply.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     Mint(_to, _amount);
337     Transfer(0x0, _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner public returns (bool) {
346     mintingFinished = true;
347     MintFinished();
348     return true;
349   }
350 }
351 
352 /**
353  * @title Pausable token
354  *
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 
358 contract PausableToken is StandardToken, Pausable {
359 
360   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
361     return super.transfer(_to, _value);
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transferFrom(_from, _to, _value);
366   }
367 
368   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
369     return super.approve(_spender, _value);
370   }
371 
372   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
373     return super.increaseApproval(_spender, _addedValue);
374   }
375 
376   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
377     return super.decreaseApproval(_spender, _subtractedValue);
378   }
379 }
380 
381 /**
382 * @dev Pre main Bitcalve CAT token ERC20 contract
383 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
384 */
385 contract CAToken is MintableToken, PausableToken {
386     
387     // Metadata
388     string public constant symbol = "CAT";
389     string public constant name = "BitClave - Consumer Activity Token";
390     uint8 public constant decimals = 18;
391     string public constant version = "2.0";
392 
393     /**
394     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
395     */
396     function finishMinting() onlyOwner canMint public returns(bool) {
397         return super.finishMinting();
398     }
399 
400 }
401 
402 /**
403 * @dev Main Bitcalve PreCAT token ERC20 contract
404 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
405 */
406 contract PreCAToken is CAToken, Destructible {
407 
408     // Metadata
409     string public constant symbol = "CAT";
410     string public constant name = "BitClave - Consumer Activity Token";
411     uint8 public constant decimals = 18;
412     string public constant version = "1.1";
413 
414     // Overrided destructor
415     function destroy() public onlyOwner {
416         require(mintingFinished);
417         super.destroy();
418     }
419 
420     // Overrided destructor companion
421     function destroyAndSend(address _recipient) public onlyOwner {
422         require(mintingFinished);
423         super.destroyAndSend(_recipient);
424     }
425 
426 }