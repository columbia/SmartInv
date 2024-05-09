1 pragma solidity ^0.4.20;
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
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title Destructible
45  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
46  */
47 contract Destructible is Ownable {
48 
49   function Destructible() public payable { }
50 
51   /**
52    * @dev Transfers the current balance to the owner and terminates the contract.
53    */
54   function destroy() onlyOwner public {
55     selfdestruct(owner);
56   }
57 
58   function destroyAndSend(address _recipient) onlyOwner public {
59     selfdestruct(_recipient);
60   }
61 }
62 
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68 
69   /**
70   * @dev Multiplies two numbers, throws on overflow.
71   */
72   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73     if (a == 0) {
74       return 0;
75     }
76     uint256 c = a * b;
77     assert(c / a == b);
78     return c;
79   }
80 
81   /**
82   * @dev Integer division of two numbers, truncating the quotient.
83   */
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   /**
92   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
93   */
94   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   /**
100   * @dev Adds two numbers, throws on overflow.
101   */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     assert(c >= a);
105     return c;
106   }
107 }
108 
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   function totalSupply() public view returns (uint256);
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Basic token
135  * @dev Basic version of StandardToken, with no allowances.
136  */
137 contract BasicToken is ERC20Basic {
138   using SafeMath for uint256;
139 
140   mapping(address => uint256) balances;
141 
142   uint256 totalSupply_;
143 
144   /**
145   * @dev total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return totalSupply_;
149   }
150 
151   /**
152   * @dev transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[msg.sender]);
159 
160     // SafeMath.sub will throw if there is not enough balance.
161     balances[msg.sender] = balances[msg.sender].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   /**
168   * @dev Gets the balance of the specified address.
169   * @param _owner The address to query the the balance of.
170   * @return An uint256 representing the amount owned by the passed address.
171   */
172   function balanceOf(address _owner) public view returns (uint256 balance) {
173     return balances[_owner];
174   }
175 
176 }
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) public view returns (uint256) {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   /**
292    * @dev Function to mint tokens
293    * @param _to The address that will receive the minted tokens.
294    * @param _amount The amount of tokens to mint.
295    * @return A boolean that indicates if the operation was successful.
296    */
297   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
298     totalSupply_ = totalSupply_.add(_amount);
299     balances[_to] = balances[_to].add(_amount);
300     Mint(_to, _amount);
301     Transfer(address(0), _to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyOwner canMint public returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 
317 /**
318  * @title Pausable
319  * @dev Base contract which allows children to implement an emergency stop mechanism.
320  */
321 contract Pausable is Ownable {
322   event Pause();
323   event Unpause();
324 
325   bool public paused = false;
326 
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is not paused.
330    */
331   modifier whenNotPaused() {
332     require(!paused);
333     _;
334   }
335 
336   /**
337    * @dev Modifier to make a function callable only when the contract is paused.
338    */
339   modifier whenPaused() {
340     require(paused);
341     _;
342   }
343 
344   /**
345    * @dev called by the owner to pause, triggers stopped state
346    */
347   function pause() onlyOwner whenNotPaused public {
348     paused = true;
349     Pause();
350   }
351 
352   /**
353    * @dev called by the owner to unpause, returns to normal state
354    */
355   function unpause() onlyOwner whenPaused public {
356     paused = false;
357     Unpause();
358   }
359 }
360 
361 
362 /**
363  * @title Burnable Token
364  * @dev Token that can be irreversibly burned (destroyed).
365  */
366 contract BurnableToken is BasicToken {
367 
368   event Burn(address indexed burner, uint256 value);
369 
370   /**
371    * @dev Burns a specific amount of tokens.
372    * @param _value The amount of token to be burned.
373    */
374   function burn(uint256 _value) public {
375     require(_value <= balances[msg.sender]);
376     // no need to require value <= totalSupply, since that would imply the
377     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
378 
379     address burner = msg.sender;
380     balances[burner] = balances[burner].sub(_value);
381     totalSupply_ = totalSupply_.sub(_value);
382     Burn(burner, _value);
383   }
384 }
385 
386 
387 /**
388  * @title Pausable token
389  *
390  * @dev StandardToken modified with pausable transfers.
391  **/
392 
393 contract PausableToken is StandardToken, Pausable {
394 
395   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
396     return super.transfer(_to, _value);
397   }
398 
399   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
400     return super.transferFrom(_from, _to, _value);
401   }
402 
403   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
404     return super.approve(_spender, _value);
405   }
406 
407   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
408     return super.increaseApproval(_spender, _addedValue);
409   }
410 
411   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
412     return super.decreaseApproval(_spender, _subtractedValue);
413   }
414 }
415 
416 /**
417  * Token Definition 
418  **/
419 contract MomentumToken is MintableToken,BurnableToken,PausableToken,Destructible {
420   string public name = "Momentum";
421   string public symbol = "MMTM";
422   uint256 public decimals = 18;
423   
424    
425     //override
426     function burn(uint256 _value) onlyOwner public {
427         super.burn(_value);
428     }
429     
430   
431 }