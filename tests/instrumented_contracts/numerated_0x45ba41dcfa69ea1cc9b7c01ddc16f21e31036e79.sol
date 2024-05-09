1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC223ReceivingContract.sol
4 
5 /**
6  * @title Contract that will work with ERC223 tokens.
7 **/
8  
9 contract ERC223ReceivingContract { 
10 
11   /**
12     * @dev Standard ERC223 function that will handle incoming token transfers.
13     *
14     * @param _from  Token sender address.
15     * @param _value Amount of tokens.
16     * @param _data  Transaction metadata.
17   */
18   function tokenFallback(address _from, uint _value, bytes _data);
19 
20 }
21 
22 // File: zeppelin-solidity/contracts/math/SafeMath.sol
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30     if (a == 0) {
31       return 0;
32     }
33     uint256 c = a * b;
34     assert(c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 // File: zeppelin-solidity/contracts/token/BasicToken.sol
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
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 // File: contracts/ERC223.sol
110 
111 contract ERC223 is BasicToken {
112 
113   function transfer(address _to, uint _value, bytes _data) public returns (bool) {
114     super.transfer(_to, _value);
115 
116     // Standard function transfer similar to ERC20 transfer with no _data .
117     // Added due to backwards compatibility reasons .
118     uint codeLength;
119 
120     assembly {
121       // Retrieve the size of the code on target address, this needs assembly .
122       codeLength := extcodesize(_to)
123     }
124     if (codeLength > 0) {
125       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
126       receiver.tokenFallback(msg.sender, _value, _data);
127     }
128     Transfer(msg.sender, _to, _value, _data);
129   }
130 
131   function transfer(address _to, uint _value) public returns (bool) {
132     super.transfer(_to, _value);
133 
134     // Standard function transfer similar to ERC20 transfer with no _data .
135     // Added due to backwards compatibility reasons .
136     uint codeLength;
137     bytes memory empty;
138 
139     assembly {
140       // Retrieve the size of the code on target address, this needs assembly .
141       codeLength := extcodesize(_to)
142     }
143     if (codeLength > 0) {
144       ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
145       receiver.tokenFallback(msg.sender, _value, empty);
146     }
147     Transfer(msg.sender, _to, _value, empty);
148   }
149 
150   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
151 }
152 
153 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
154 
155 /**
156  * @title Ownable
157  * @dev The Ownable contract has an owner address, and provides basic authorization control
158  * functions, this simplifies the implementation of "user permissions".
159  */
160 contract Ownable {
161   address public owner;
162 
163 
164   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166 
167   /**
168    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
169    * account.
170    */
171   function Ownable() public {
172     owner = msg.sender;
173   }
174 
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address newOwner) public onlyOwner {
190     require(newOwner != address(0));
191     OwnershipTransferred(owner, newOwner);
192     owner = newOwner;
193   }
194 
195 }
196 
197 // File: zeppelin-solidity/contracts/token/ERC20.sol
198 
199 /**
200  * @title ERC20 interface
201  * @dev see https://github.com/ethereum/EIPs/issues/20
202  */
203 contract ERC20 is ERC20Basic {
204   function allowance(address owner, address spender) public view returns (uint256);
205   function transferFrom(address from, address to, uint256 value) public returns (bool);
206   function approve(address spender, uint256 value) public returns (bool);
207   event Approval(address indexed owner, address indexed spender, uint256 value);
208 }
209 
210 // File: zeppelin-solidity/contracts/token/StandardToken.sol
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * @dev https://github.com/ethereum/EIPs/issues/20
217  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[_from]);
233     require(_value <= allowed[_from][msg.sender]);
234 
235     balances[_from] = balances[_from].sub(_value);
236     balances[_to] = balances[_to].add(_value);
237     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
238     Transfer(_from, _to, _value);
239     return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    *
245    * Beware that changing an allowance with this method brings the risk that someone may use both the old
246    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
247    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
248    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249    * @param _spender The address which will spend the funds.
250    * @param _value The amount of tokens to be spent.
251    */
252   function approve(address _spender, uint256 _value) public returns (bool) {
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifying the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) public view returns (uint256) {
265     return allowed[_owner][_spender];
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    *
271    * approve should be called when allowed[_spender] == 0. To increment
272    * allowed value is better to use this function to avoid 2 calls (and wait until
273    * the first transaction is mined)
274    * From MonolithDAO Token.sol
275    * @param _spender The address which will spend the funds.
276    * @param _addedValue The amount of tokens to increase the allowance by.
277    */
278   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
279     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
280     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
281     return true;
282   }
283 
284   /**
285    * @dev Decrease the amount of tokens that an owner allowed to a spender.
286    *
287    * approve should be called when allowed[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param _spender The address which will spend the funds.
292    * @param _subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 // File: zeppelin-solidity/contracts/token/MintableToken.sol
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 
316 contract MintableToken is StandardToken, Ownable {
317   event Mint(address indexed to, uint256 amount);
318   event MintFinished();
319 
320   bool public mintingFinished = false;
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
337     Transfer(address(0), _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner canMint public returns (bool) {
346     mintingFinished = true;
347     MintFinished();
348     return true;
349   }
350 }
351 
352 // File: zeppelin-solidity/contracts/token/CappedToken.sol
353 
354 /**
355  * @title Capped token
356  * @dev Mintable token with a token cap.
357  */
358 
359 contract CappedToken is MintableToken {
360 
361   uint256 public cap;
362 
363   function CappedToken(uint256 _cap) public {
364     require(_cap > 0);
365     cap = _cap;
366   }
367 
368   /**
369    * @dev Function to mint tokens
370    * @param _to The address that will receive the minted tokens.
371    * @param _amount The amount of tokens to mint.
372    * @return A boolean that indicates if the operation was successful.
373    */
374   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
375     require(totalSupply.add(_amount) <= cap);
376 
377     return super.mint(_to, _amount);
378   }
379 
380 }
381 
382 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
383 
384 /**
385  * @title Pausable
386  * @dev Base contract which allows children to implement an emergency stop mechanism.
387  */
388 contract Pausable is Ownable {
389   event Pause();
390   event Unpause();
391 
392   bool public paused = false;
393 
394 
395   /**
396    * @dev Modifier to make a function callable only when the contract is not paused.
397    */
398   modifier whenNotPaused() {
399     require(!paused);
400     _;
401   }
402 
403   /**
404    * @dev Modifier to make a function callable only when the contract is paused.
405    */
406   modifier whenPaused() {
407     require(paused);
408     _;
409   }
410 
411   /**
412    * @dev called by the owner to pause, triggers stopped state
413    */
414   function pause() onlyOwner whenNotPaused public {
415     paused = true;
416     Pause();
417   }
418 
419   /**
420    * @dev called by the owner to unpause, returns to normal state
421    */
422   function unpause() onlyOwner whenPaused public {
423     paused = false;
424     Unpause();
425   }
426 }
427 
428 // File: zeppelin-solidity/contracts/token/PausableToken.sol
429 
430 /**
431  * @title Pausable token
432  *
433  * @dev StandardToken modified with pausable transfers.
434  **/
435 
436 contract PausableToken is StandardToken, Pausable {
437 
438   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
439     return super.transfer(_to, _value);
440   }
441 
442   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
443     return super.transferFrom(_from, _to, _value);
444   }
445 
446   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
447     return super.approve(_spender, _value);
448   }
449 
450   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
451     return super.increaseApproval(_spender, _addedValue);
452   }
453 
454   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
455     return super.decreaseApproval(_spender, _subtractedValue);
456   }
457 }
458 
459 // File: contracts/YoloToken.sol
460 
461 /** @title YoloToken - Token for the UltraYOLO lottery protocol
462   * @author UltraYOLO
463 
464   The totalSupply for YOLO token will be 4 Billion
465 **/
466 
467 contract YoloToken is CappedToken, PausableToken, ERC223 {
468 
469   string public constant name     = "Yolo";
470   string public constant symbol   = "YOLO";
471   uint   public constant decimals = 18;
472 
473   function YoloToken(uint256 _totalSupply) CappedToken(_totalSupply) {
474     paused = true;
475   }
476 
477 }