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
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/DisableSelfTransfer.sol
223 
224 contract DisableSelfTransfer is StandardToken {
225     
226   function transfer(address _to, uint256 _value) public returns (bool) {
227     require(_to != address(this));
228     return super.transfer(_to, _value);
229   }
230 
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(this));
233     return super.transferFrom(_from, _to, _value);
234   }
235 
236 }
237 
238 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
239 
240 /**
241  * @title Ownable
242  * @dev The Ownable contract has an owner address, and provides basic authorization control
243  * functions, this simplifies the implementation of "user permissions".
244  */
245 contract Ownable {
246   address public owner;
247 
248 
249   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251 
252   /**
253    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
254    * account.
255    */
256   function Ownable() public {
257     owner = msg.sender;
258   }
259 
260   /**
261    * @dev Throws if called by any account other than the owner.
262    */
263   modifier onlyOwner() {
264     require(msg.sender == owner);
265     _;
266   }
267 
268   /**
269    * @dev Allows the current owner to transfer control of the contract to a newOwner.
270    * @param newOwner The address to transfer ownership to.
271    */
272   function transferOwnership(address newOwner) public onlyOwner {
273     require(newOwner != address(0));
274     OwnershipTransferred(owner, newOwner);
275     owner = newOwner;
276   }
277 
278 }
279 
280 // File: contracts/OwnerContract.sol
281 
282 contract OwnerContract is Ownable {
283   mapping (address => bool) internal contracts;
284 
285   // New modifier to be used in place of OWNER ONLY activity
286   // Eventually this will be owned by a controller contract and not a private wallet
287   modifier justOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291   
292   // Allow contracts to have ownership without taking full custody of the token
293   modifier onlyOwner() {
294     if (msg.sender == address(0) || (msg.sender != owner && !contracts[msg.sender])) {
295       revert(); // error for uncontrolled request
296     }
297     _;
298   }
299 
300   // Stops owner from gaining access to all functionality
301   modifier onlyContract() {
302     require(msg.sender != address(0));
303     require(contracts[msg.sender]); 
304     _;
305   }
306 
307   // new owner only activity. 
308   function removeController(address controllerToRemove) public justOwner {
309     require(contracts[controllerToRemove]);
310     contracts[controllerToRemove] = false;
311   }
312   // new owner only activity.
313   function addController(address newController) public justOwner {
314     contracts[newController] = true;
315   }
316 
317   // Check an address to see if it is a controller
318   function isController(address _address) public view returns(bool) {
319     return contracts[_address];
320   }
321 
322 }
323 
324 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
325 
326 /**
327  * @title Burnable Token
328  * @dev Token that can be irreversibly burned (destroyed).
329  */
330 contract BurnableToken is BasicToken {
331 
332   event Burn(address indexed burner, uint256 value);
333 
334   /**
335    * @dev Burns a specific amount of tokens.
336    * @param _value The amount of token to be burned.
337    */
338   function burn(uint256 _value) public {
339     require(_value <= balances[msg.sender]);
340     // no need to require value <= totalSupply, since that would imply the
341     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
342 
343     address burner = msg.sender;
344     balances[burner] = balances[burner].sub(_value);
345     totalSupply_ = totalSupply_.sub(_value);
346     Burn(burner, _value);
347     Transfer(burner, address(0), _value);
348   }
349 }
350 
351 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
352 
353 /**
354  * @title Mintable token
355  * @dev Simple ERC20 Token example, with mintable token creation
356  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
357  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
358  */
359 contract MintableToken is StandardToken, Ownable {
360   event Mint(address indexed to, uint256 amount);
361   event MintFinished();
362 
363   bool public mintingFinished = false;
364 
365 
366   modifier canMint() {
367     require(!mintingFinished);
368     _;
369   }
370 
371   /**
372    * @dev Function to mint tokens
373    * @param _to The address that will receive the minted tokens.
374    * @param _amount The amount of tokens to mint.
375    * @return A boolean that indicates if the operation was successful.
376    */
377   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
378     totalSupply_ = totalSupply_.add(_amount);
379     balances[_to] = balances[_to].add(_amount);
380     Mint(_to, _amount);
381     Transfer(address(0), _to, _amount);
382     return true;
383   }
384 
385   /**
386    * @dev Function to stop minting new tokens.
387    * @return True if the operation was successful.
388    */
389   function finishMinting() onlyOwner canMint public returns (bool) {
390     mintingFinished = true;
391     MintFinished();
392     return true;
393   }
394 }
395 
396 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
397 
398 /**
399  * @title Capped token
400  * @dev Mintable token with a token cap.
401  */
402 contract CappedToken is MintableToken {
403 
404   uint256 public cap;
405 
406   function CappedToken(uint256 _cap) public {
407     require(_cap > 0);
408     cap = _cap;
409   }
410 
411   /**
412    * @dev Function to mint tokens
413    * @param _to The address that will receive the minted tokens.
414    * @param _amount The amount of tokens to mint.
415    * @return A boolean that indicates if the operation was successful.
416    */
417   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
418     require(totalSupply_.add(_amount) <= cap);
419 
420     return super.mint(_to, _amount);
421   }
422 
423 }
424 
425 // File: contracts/TurkeyBurgerToken.sol
426 
427 contract TurkeyBurgerToken is CappedToken, BurnableToken, OwnerContract, DisableSelfTransfer {
428     string public name = "TurkeyBurger Token";
429     string public symbol = "TBT";
430     uint8 public decimals = 18;
431 
432 
433     function TurkeyBurgerToken(uint256 _cap) public CappedToken(_cap) {
434         
435     }
436     
437     function changeCap(uint256 newCap) public onlyOwner {
438         cap = newCap;
439     }
440 }