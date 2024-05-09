1 //File: node_modules/zeppelin-solidity/contracts/token/ERC20Basic.sol
2 pragma solidity ^0.4.18;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 //File: node_modules/zeppelin-solidity/contracts/math/SafeMath.sol
18 pragma solidity ^0.4.18;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 //File: node_modules/zeppelin-solidity/contracts/token/BasicToken.sol
55 pragma solidity ^0.4.18;
56 
57 
58 
59 
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 //File: node_modules/zeppelin-solidity/contracts/token/ERC20.sol
99 pragma solidity ^0.4.18;
100 
101 
102 
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 //File: node_modules/zeppelin-solidity/contracts/token/StandardToken.sol
117 pragma solidity ^0.4.18;
118 
119 
120 
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[_from]);
145     require(_value <= allowed[_from][msg.sender]);
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156    *
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param _spender The address which will spend the funds.
162    * @param _value The amount of tokens to be spent.
163    */
164   function approve(address _spender, uint256 _value) public returns (bool) {
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * @dev Increase the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To increment
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _addedValue The amount of tokens to increase the allowance by.
189    */
190   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196   /**
197    * @dev Decrease the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To decrement
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _subtractedValue The amount of tokens to decrease the allowance by.
205    */
206   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
207     uint oldValue = allowed[msg.sender][_spender];
208     if (_subtractedValue > oldValue) {
209       allowed[msg.sender][_spender] = 0;
210     } else {
211       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212     }
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214     return true;
215   }
216 
217 }
218 
219 //File: node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol
220 pragma solidity ^0.4.18;
221 
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243 
244   /**
245    * @dev Throws if called by any account other than the owner.
246    */
247   modifier onlyOwner() {
248     require(msg.sender == owner);
249     _;
250   }
251 
252 
253   /**
254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
255    * @param newOwner The address to transfer ownership to.
256    */
257   function transferOwnership(address newOwner) public onlyOwner {
258     require(newOwner != address(0));
259     OwnershipTransferred(owner, newOwner);
260     owner = newOwner;
261   }
262 
263 }
264 
265 //File: node_modules/zeppelin-solidity/contracts/token/MintableToken.sol
266 pragma solidity ^0.4.18;
267 
268 
269 
270 
271 
272 
273 
274 /**
275  * @title Mintable token
276  * @dev Simple ERC20 Token example, with mintable token creation
277  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
278  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
279  */
280 
281 contract MintableToken is StandardToken, Ownable {
282   event Mint(address indexed to, uint256 amount);
283   event MintFinished();
284 
285   bool public mintingFinished = false;
286 
287 
288   modifier canMint() {
289     require(!mintingFinished);
290     _;
291   }
292 
293   /**
294    * @dev Function to mint tokens
295    * @param _to The address that will receive the minted tokens.
296    * @param _amount The amount of tokens to mint.
297    * @return A boolean that indicates if the operation was successful.
298    */
299   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
300     totalSupply = totalSupply.add(_amount);
301     balances[_to] = balances[_to].add(_amount);
302     Mint(_to, _amount);
303     Transfer(address(0), _to, _amount);
304     return true;
305   }
306 
307   /**
308    * @dev Function to stop minting new tokens.
309    * @return True if the operation was successful.
310    */
311   function finishMinting() onlyOwner canMint public returns (bool) {
312     mintingFinished = true;
313     MintFinished();
314     return true;
315   }
316 }
317 
318 //File: node_modules/zeppelin-solidity/contracts/lifecycle/Pausable.sol
319 pragma solidity ^0.4.18;
320 
321 
322 
323 
324 
325 /**
326  * @title Pausable
327  * @dev Base contract which allows children to implement an emergency stop mechanism.
328  */
329 contract Pausable is Ownable {
330   event Pause();
331   event Unpause();
332 
333   bool public paused = false;
334 
335 
336   /**
337    * @dev Modifier to make a function callable only when the contract is not paused.
338    */
339   modifier whenNotPaused() {
340     require(!paused);
341     _;
342   }
343 
344   /**
345    * @dev Modifier to make a function callable only when the contract is paused.
346    */
347   modifier whenPaused() {
348     require(paused);
349     _;
350   }
351 
352   /**
353    * @dev called by the owner to pause, triggers stopped state
354    */
355   function pause() onlyOwner whenNotPaused public {
356     paused = true;
357     Pause();
358   }
359 
360   /**
361    * @dev called by the owner to unpause, returns to normal state
362    */
363   function unpause() onlyOwner whenPaused public {
364     paused = false;
365     Unpause();
366   }
367 }
368 
369 //File: node_modules/zeppelin-solidity/contracts/token/PausableToken.sol
370 pragma solidity ^0.4.18;
371 
372 
373 
374 
375 /**
376  * @title Pausable token
377  *
378  * @dev StandardToken modified with pausable transfers.
379  **/
380 
381 contract PausableToken is StandardToken, Pausable {
382 
383   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
384     return super.transfer(_to, _value);
385   }
386 
387   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
388     return super.transferFrom(_from, _to, _value);
389   }
390 
391   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
392     return super.approve(_spender, _value);
393   }
394 
395   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
396     return super.increaseApproval(_spender, _addedValue);
397   }
398 
399   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
400     return super.decreaseApproval(_spender, _subtractedValue);
401   }
402 }
403 
404 //File: src/contracts/ico/MtnToken.sol
405 /**
406  * @title MTN token
407  *
408  * @version 1.0
409  * @author Validity Labs AG <info@validitylabs.org>
410  */
411 pragma solidity ^0.4.18;
412 
413 
414 
415 
416 contract MtnToken is MintableToken, PausableToken {
417     string public constant name = "MedToken";
418     string public constant symbol = "MTN";
419     uint8 public constant decimals = 18;
420 
421     /**
422      * @dev Constructor of MtnToken that instantiates a new Mintable Pauseable Token
423      */
424     function MtnToken() public {
425         // token should not be transferrable until after all tokens have been issued
426         paused = true;
427     }
428 }