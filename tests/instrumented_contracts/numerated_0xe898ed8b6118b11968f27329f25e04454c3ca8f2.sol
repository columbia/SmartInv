1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83   modifier onlyPayloadSize(uint256 numwords) {
84     assert(msg.data.length >= numwords * 32 + 4);
85     _;
86   }
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * @dev https://github.com/ethereum/EIPs/issues/20
126  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
127  */
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 
177   /**
178    * @dev Increase the amount of tokens that an owner allowed to a spender.
179    *
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    * @param _spender The address which will spend the funds.
185    * @param _addedValue The amount of tokens to increase the allowance by.
186    */
187   function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   /**
194    * @dev Decrease the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To decrement
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _subtractedValue The amount of tokens to decrease the allowance by.
202    */
203   function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
204     uint oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue > oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipRenounced(address indexed previousOwner);
226   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227 
228 
229   /**
230    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
231    * account.
232    */
233   function Ownable() public {
234     owner = msg.sender;
235   }
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245   /**
246    * @dev Allows the current owner to transfer control of the contract to a newOwner.
247    * @param newOwner The address to transfer ownership to.
248    */
249   function transferOwnership(address newOwner) public onlyOwner {
250     require(newOwner != address(0));
251     OwnershipTransferred(owner, newOwner);
252     owner = newOwner;
253   }
254 
255   /**
256    * @dev Allows the current owner to relinquish control of the contract.
257    */
258   function renounceOwnership() public onlyOwner {
259     OwnershipRenounced(owner);
260     owner = address(0);
261   }
262 }
263 
264 /**
265  * @title Pausable
266  * @dev Base contract which allows children to implement an emergency stop mechanism.
267  */
268 contract Pausable is Ownable {
269   event Pause();
270   event Unpause();
271 
272   bool public paused = false;
273 
274 
275   /**
276    * @dev Modifier to make a function callable only when the contract is not paused.
277    */
278   modifier whenNotPaused() {
279     require(!paused);
280     _;
281   }
282 
283   /**
284    * @dev Modifier to make a function callable only when the contract is paused.
285    */
286   modifier whenPaused() {
287     require(paused);
288     _;
289   }
290 
291   /**
292    * @dev called by the owner to pause, triggers stopped state
293    */
294   function pause() onlyOwner whenNotPaused public {
295     paused = true;
296     Pause();
297   }
298 
299   /**
300    * @dev called by the owner to unpause, returns to normal state
301    */
302   function unpause() onlyOwner whenPaused public {
303     paused = false;
304     Unpause();
305   }
306 }
307 
308 /**
309  * @title Pausable token
310  * @dev StandardToken modified with pausable transfers.
311  **/
312 contract PausableToken is StandardToken, Pausable {
313 
314   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transferFrom(_from, _to, _value);
320   }
321 
322   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
323     return super.approve(_spender, _value);
324   }
325 
326   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseApproval(_spender, _subtractedValue);
332   }
333 }
334 
335 /**
336  * @title Mintable token
337  * @dev Simple ERC20 Token example, with mintable token creation
338  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
339  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
340  */
341 contract MintableToken is PausableToken {
342   event Mint(address indexed to, uint256 amount);
343   event MintFinished();
344 
345   bool public mintingFinished = false;
346 
347 
348   modifier canMint() {
349     require(!mintingFinished);
350     _;
351   }
352 
353   /**
354    * @dev Function to mint tokens
355    * @param _to The address that will receive the minted tokens.
356    * @param _amount The amount of tokens to mint.
357    * @return A boolean that indicates if the operation was successful.
358    */
359   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
360     totalSupply_ = totalSupply_.add(_amount);
361     balances[_to] = balances[_to].add(_amount);
362     Mint(_to, _amount);
363     Transfer(address(0), _to, _amount);
364     return true;
365   }
366 
367   /**
368    * @dev Function to stop minting new tokens.
369    * @return True if the operation was successful.
370    */
371   function finishMinting() onlyOwner canMint public returns (bool) {
372     mintingFinished = true;
373     MintFinished();
374     return true;
375   }
376 }
377 /**
378  * @title Burnable Token
379  * @dev Token that can be irreversibly burned (destroyed).
380  */
381 contract BurnableToken is MintableToken {
382 
383   event Burn(address indexed burner, uint256 value);
384 
385   /**
386    * @dev Burns a specific amount of tokens.
387    * @param _value The amount of token to be burned.
388    */
389   function burn(uint256 _value) public {
390     _burn(msg.sender, _value);
391   }
392 
393   function _burn(address _who, uint256 _value) internal {
394     require(_value <= balances[_who]);
395     // no need to require value <= totalSupply, since that would imply the
396     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
397 
398     balances[_who] = balances[_who].sub(_value);
399     totalSupply_ = totalSupply_.sub(_value);
400     Burn(_who, _value);
401     Transfer(_who, address(0), _value);
402   }
403 }
404 
405 /**
406  * @title Standard Burnable Token
407  * @dev Adds burnFrom method to ERC20 implementations
408  */
409 contract StandardBurnableToken is BurnableToken {
410 
411   /**
412    * @dev Burns a specific amount of tokens from the target address and decrements allowance
413    * @param _from address The address which you want to send tokens from
414    * @param _value uint256 The amount of token to be burned
415    */
416   function burnFrom(address _from, uint256 _value) public {
417     require(_value <= allowed[_from][msg.sender]);
418     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
419     // this function needs to emit an event with the updated approval.
420     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
421     _burn(_from, _value);
422   }
423 }
424 
425 contract ZNAQ is StandardBurnableToken {
426 
427   string public constant name = "ZNAQ";
428   string public constant symbol = "ZNAQ";
429   uint8 public constant decimals = 18;
430   address public wallet = 0xE3bf6F453e85B57cdDfF2030BAcf119841d132D5;
431 
432   function changeWallet(address _newWallet) public onlyOwner {
433     require(_newWallet != address(0));
434     wallet = _newWallet;
435   }
436 
437   function sendEth() public onlyOwner {
438     wallet.transfer(address(this).balance);
439   }
440 
441   function () payable public {}
442 }