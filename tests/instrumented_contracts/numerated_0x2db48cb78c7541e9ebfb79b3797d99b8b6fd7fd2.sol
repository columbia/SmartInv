1 pragma solidity ^0.4.17;
2 
3 
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
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
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
51 
52 
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 
95 
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  */
102 contract ERC20Basic {
103   function totalSupply() public view returns (uint256);
104   function balanceOf(address who) public view returns (uint256);
105   function transfer(address to, uint256 value) public returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 
110 /**
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   address public mintMaster;
133 
134 
135 
136   //totalSupply
137   uint256 totalSupply_=2*10**8*10**18;
138 
139   uint256 mintNums_;
140 
141   uint256 transferOpenTimes=1527782400;
142   uint256 transferCloseTimes=1530374400;
143 
144 
145   /**
146   * @dev total number of tokens in existence
147   */
148   function totalSupply() public view returns (uint256) {
149     return totalSupply_;
150   }
151 
152 
153 
154    function totalMintNums() public view returns (uint256) {
155         return mintNums_;
156    }
157 
158 
159    function getTransferTime() public view returns (uint256,uint256) {
160 
161      return (transferOpenTimes, transferCloseTimes);
162   }
163 
164   /**
165   * @dev transfer token for a specified address
166   * @param _to The address to transfer to.
167   * @param _value The amount to be transferred.
168   */
169   function transfer(address _to, uint256 _value) public returns (bool) {
170 
171     if((now>=transferOpenTimes)&&(now<=transferCloseTimes))
172     {
173       return false;
174     }else
175     {
176       require(_to != address(0));
177       address addr = msg.sender;
178       require(addr!= address(0));
179       require(_value <= balances[msg.sender]);
180 
181       // SafeMath.sub will throw if there is not enough balance.
182       balances[msg.sender] = balances[msg.sender].sub(_value);
183       balances[_to] = balances[_to].add(_value);
184       emit Transfer(msg.sender, _to, _value);
185       return true;
186    }
187   }
188 
189 
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param _owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address _owner) public view returns (uint256 balance) {
197     return balances[_owner];
198   }
199 
200 }
201 
202 
203 
204 /**
205  * @title Standard ERC20 token
206  *
207  * @dev Implementation of the basic standard token.
208  * @dev https://github.com/ethereum/EIPs/issues/20
209  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
210  */
211 contract StandardToken is ERC20, BasicToken {
212 
213   mapping (address => mapping (address => uint256)) internal allowed;
214 
215 
216   /**
217    * @dev Transfer tokens from one address to another
218    * @param _from address The address which you want to send tokens from
219    * @param _to address The address which you want to transfer to
220    * @param _value uint256 the amount of tokens to be transferred
221    */
222   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
223 
224     if((now>=transferOpenTimes)&&(now<=transferCloseTimes))
225     {
226       return false;
227     }else
228     {
229 
230      require(_to != address(0));
231      require(_value <= balances[_from]);
232      require(_value <= allowed[_from][msg.sender]);
233 
234      balances[_from] = balances[_from].sub(_value);
235      balances[_to] = balances[_to].add(_value);
236      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237      emit Transfer(_from, _to, _value);
238      return true;
239     }
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
254     emit Approval(msg.sender, _spender, _value);
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
280     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 contract MintableToken is StandardToken, Ownable {
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   bool public mintingFinished = false;
319 
320 
321   modifier canMint() {
322     require(!mintingFinished);
323     _;
324   }
325 
326   /**
327    * @dev Function to mint tokens
328    * @param _to The address that will receive the minted tokens.
329    * @param _amount The amount of tokens to mint.
330    * @return A boolean that indicates if the operation was successful.
331    */
332   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
333 
334     uint256 vtemp = mintNums_.add(_amount);
335     require(vtemp<=totalSupply_);
336     mintNums_ = vtemp;
337     balances[_to] = balances[_to].add(_amount);
338     emit Mint(_to, _amount);
339     emit Transfer(address(0), _to, _amount);
340     return true;
341   }
342 
343   /**
344    * @dev Function to stop minting new tokens.
345    * @return True if the operation was successful.
346    */
347   function finishMinting() onlyOwner canMint public returns (bool) {
348     mintingFinished = true;
349     emit MintFinished();
350     return true;
351   }
352 }
353 
354 
355 
356 
357 /**
358  * @title Pausable
359  * @dev Base contract which allows children to implement an emergency stop mechanism.
360  */
361 contract Pausable is Ownable {
362   event Pause();
363   event Unpause();
364 
365   bool public paused = false;
366 
367 
368   /**
369    * @dev Modifier to make a function callable only when the contract is not paused.
370    */
371   modifier whenNotPaused() {
372     require(!paused);
373     _;
374   }
375 
376   /**
377    * @dev Modifier to make a function callable only when the contract is paused.
378    */
379   modifier whenPaused() {
380     require(paused);
381     _;
382   }
383 
384   /**
385    * @dev called by the owner to pause, triggers stopped state
386    */
387   function pause() onlyOwner whenNotPaused public {
388     paused = true;
389     emit Pause();
390   }
391 
392   /**
393    * @dev called by the owner to unpause, returns to normal state
394    */
395   function unpause() onlyOwner whenPaused public {
396     paused = false;
397     emit Unpause();
398   }
399 }
400 
401 
402 
403 /**
404  * @title Pausable token
405  * @dev StandardToken modified with pausable transfers.
406  **/
407 contract PausableToken is StandardToken, Pausable {
408 
409   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
410     return super.transfer(_to, _value);
411   }
412 
413   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
414     return super.transferFrom(_from, _to, _value);
415   }
416 
417   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
418     return super.approve(_spender, _value);
419   }
420 
421   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
422     return super.increaseApproval(_spender, _addedValue);
423   }
424 
425   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
426     return super.decreaseApproval(_spender, _subtractedValue);
427   }
428 }
429 
430 
431 
432 /**
433  * @dev OREX token ERC20 contract
434  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
435  */
436 contract OREX is MintableToken, PausableToken {
437     string public constant version = "1.0";
438     string public constant name = "OREX";
439     string public constant symbol = "OREX";
440     uint8 public constant decimals = 18;
441 
442     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
443 
444     modifier onlyMintMasterOrOwner() {
445         require(msg.sender == mintMaster || msg.sender == owner);
446         _;
447     }
448 
449     constructor() public {
450         mintMaster = msg.sender;
451         totalSupply_=2*10**8*10**18;
452     }
453 
454     function setTimedTransfer(uint256 _openingTime, uint256 _closingTime) public onlyOwner {
455         // require(_openingTime >= now);
456         require(_closingTime >= _openingTime);
457 
458         transferOpenTimes = _openingTime;
459         transferCloseTimes = _closingTime;
460     }
461 
462     function transferMintMaster(address newMaster) onlyOwner public {
463         require(newMaster != address(0));
464         emit MintMasterTransferred(mintMaster, newMaster);
465         mintMaster = newMaster;
466     }
467 
468     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
469         for (uint i = 0; i < addresses.length; i++) {
470             require(mint(addresses[i], amount));
471         }
472     }
473 
474     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
475         require(addresses.length == amounts.length);
476         for (uint i = 0; i < addresses.length; i++) {
477             require(mint(addresses[i], amounts[i]));
478         }
479     }
480     /**
481      * @dev Function to mint tokens
482      * @param _to The address that will receive the minted tokens.
483      * @param _amount The amount of tokens to mint.
484      * @return A boolean that indicates if the operation was successful.
485      */
486     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
487         address oldOwner = owner;
488         owner = msg.sender;
489         bool result = super.mint(_to, _amount);
490         owner = oldOwner;
491         return result;
492     }
493 
494 
495 }