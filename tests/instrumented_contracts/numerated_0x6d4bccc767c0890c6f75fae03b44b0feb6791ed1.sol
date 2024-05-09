1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two number
25 [2] only remix transactions, script
26 
27 Search transactions
28 
29 Listen on networks, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   function totalSupply() public view returns (uint256);
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint256;
78 
79   mapping(address => uint256) balances;
80 
81   uint256 totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint256) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint256 _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     // SafeMath.sub will throw if there is not enough balance.
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public view returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
131 
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  * @dev https://github.com/ethereum/EIPs/issues/20
137  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
138  */
139 contract StandardToken is ERC20, BasicToken {
140 
141   mapping (address => mapping (address => uint256)) internal allowed;
142 
143 
144   /**
145    * @dev Transfer tokens from one address to another
146    * @param _from address The address which you want to send tokens from
147    * @param _to address The address which you want to transfer to
148    * @param _value uint256 the amount of tokens to be transferred
149    */
150   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(address _owner, address _spender) public view returns (uint256) {
185     return allowed[_owner][_spender];
186   }
187 
188   /**
189    * @dev Increase the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To increment
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _addedValue The amount of tokens to increase the allowance by.
197    */
198   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
199     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204   /**
205    * @dev Decrease the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To decrement
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _subtractedValue The amount of tokens to decrease the allowance by.
213    */
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     uint oldValue = allowed[msg.sender][_spender];
216     if (_subtractedValue > oldValue) {
217       allowed[msg.sender][_spender] = 0;
218     } else {
219       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
220     }
221     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225 }
226 
227 // File: contracts/DisableSelfTransfer.sol
228 
229 contract DisableSelfTransfer is StandardToken {
230     
231   function transfer(address _to, uint256 _value) public returns (bool) {
232     require(_to != address(this));
233     return super.transfer(_to, _value);
234   }
235 
236   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237     require(_to != address(this));
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241 }
242 
243 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
244 
245 /**
246  * @title Ownable
247  * @dev The Ownable contract has an owner address, and provides basic authorization control
248  * functions, this simplifies the implementation of "user permissions".
249  */
250 contract Ownable {
251   address public owner;
252 
253 
254   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256 
257   /**
258    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
259    * account.
260    */
261   function Ownable() public {
262     owner = msg.sender;
263   }
264 
265   /**
266    * @dev Throws if called by any account other than the owner.
267    */
268   modifier onlyOwner() {
269     require(msg.sender == owner);
270     _;
271   }
272 
273   /**
274    * @dev Allows the current owner to transfer control of the contract to a newOwner.
275    * @param newOwner The address to transfer ownership to.
276    */
277   function transferOwnership(address newOwner) public onlyOwner {
278     require(newOwner != address(0));
279     OwnershipTransferred(owner, newOwner);
280     owner = newOwner;
281   }
282 
283 }
284 
285 // File: contracts/OwnerContract.sol
286 
287 contract OwnerContract is Ownable {
288   mapping (address => bool) internal contracts;
289 
290   // New modifier to be used in place of OWNER ONLY activity
291   // Eventually this will be owned by a controller contract and not a private wallet
292   modifier justOwner() {
293     require(msg.sender == owner);
294     _;
295   }
296   
297   // Allow contracts to have ownership without taking full custody of the token
298   modifier onlyOwner() {
299     if (msg.sender == address(0) || (msg.sender != owner && !contracts[msg.sender])) {
300       revert(); // error for uncontrolled request
301     }
302     _;
303   }
304 
305   // Stops owner from gaining access to all functionality
306   modifier onlyContract() {
307     require(msg.sender != address(0));
308     require(contracts[msg.sender]); 
309     _;
310   }
311 
312   // new owner only activity. 
313   function removeController(address controllerToRemove) public justOwner {
314     require(contracts[controllerToRemove]);
315     contracts[controllerToRemove] = false;
316   }
317   // new owner only activity.
318   function addController(address newController) public justOwner {
319     contracts[newController] = true;
320   }
321 
322   // Check an address to see if it is a controller
323   function isController(address _address) public view returns(bool) {
324     return contracts[_address];
325   }
326 
327 }
328 
329 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
330 
331 /**
332  * @title Burnable Token
333  * @dev Token that can be irreversibly burned (destroyed).
334  */
335 contract BurnableToken is BasicToken {
336 
337   event Burn(address indexed burner, uint256 value);
338 
339   /**
340    * @dev Burns a specific amount of tokens.
341    * @param _value The amount of token to be burned.
342    */
343   function burn(uint256 _value) public {
344     require(_value <= balances[msg.sender]);
345     // no need to require value <= totalSupply, since that would imply the
346     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
347 
348     address burner = msg.sender;
349     balances[burner] = balances[burner].sub(_value);
350     totalSupply_ = totalSupply_.sub(_value);
351     Burn(burner, _value);
352     Transfer(burner, address(0), _value);
353   }
354 }
355 
356 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
357 
358 /**
359  * @title Mintable token
360  * @dev Simple ERC20 Token example, with mintable token creation
361  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
362  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
363  */
364 contract MintableToken is StandardToken, Ownable {
365   event Mint(address indexed to, uint256 amount);
366   event MintFinished();
367 
368   bool public mintingFinished = false;
369 
370 
371   modifier canMint() {
372     require(!mintingFinished);
373     _;
374   }
375 
376   /**
377    * @dev Function to mint tokens
378    * @param _to The address that will receive the minted tokens.
379    * @param _amount The amount of tokens to mint.
380    * @return A boolean that indicates if the operation was successful.
381    */
382   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
383     totalSupply_ = totalSupply_.add(_amount);
384     balances[_to] = balances[_to].add(_amount);
385     Mint(_to, _amount);
386     Transfer(address(0), _to, _amount);
387     return true;
388   }
389 
390   /**
391    * @dev Function to stop minting new tokens.
392    * @return True if the operation was successful.
393    */
394   function finishMinting() onlyOwner canMint public returns (bool) {
395     mintingFinished = true;
396     MintFinished();
397     return true;
398   }
399 }
400 
401 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
402 
403 /**
404  * @title Capped token
405  * @dev Mintable token with a token cap.
406  */
407 contract CappedToken is MintableToken {
408 
409   uint256 public cap;
410 
411   function CappedToken(uint256 _cap) public {
412     require(_cap > 0);
413     cap = _cap;
414   }
415 
416   /**
417    * @dev Function to mint tokens
418    * @param _to The address that will receive the minted tokens.
419    * @param _amount The amount of tokens to mint.
420    * @return A boolean that indicates if the operation was successful.
421    */
422   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
423     require(totalSupply_.add(_amount) <= cap);
424 
425     return super.mint(_to, _amount);
426   }
427 
428 }
429 
430 // File: contracts/AhmadToken.sol
431 
432 contract ahmadToken is CappedToken, BurnableToken, OwnerContract, DisableSelfTransfer {
433     string public name = "ahmad Token";
434     string public symbol = "AHT";
435     uint8 public decimals = 18;
436 
437 
438     function ahmadToken(uint256 _cap) public CappedToken(_cap) {
439         
440     }
441     
442     function changeCap(uint256 newCap) public onlyOwner {
443         cap = newCap;
444     }
445 }