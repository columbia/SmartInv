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
136   //18*10**7*10**17 Crowdsale
137   uint256 totalSupply_=18*10**7*10**18;
138 
139 
140   
141  // uint256 crowdsaleDist_;
142 
143   uint256 mintNums_;
144 
145   uint256 transferOpenTimes=1534003200;
146   uint256 transferCloseTimes=7845350400;
147 
148 
149   /**
150   * @dev total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156 
157 
158    function totalMintNums() public view returns (uint256) {
159         return mintNums_;
160    }
161 
162 
163 //   function totalCrowdSale() public view returns (uint256) {
164 //         return crowdsaleDist_;
165 //   }
166 
167 //   function addCrowdSale(uint256 _value) public {
168 
169 //       crowdsaleDist_ =  crowdsaleDist_.add(_value);
170 
171 //   }
172 
173 
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) public returns (bool) {
181 
182     if((now>=transferOpenTimes)&&(now<=transferCloseTimes))
183     {
184       return false;
185     }else
186     {
187     require(_to != address(0));
188     address addr = msg.sender;
189     require(addr!= address(0));
190     //require(_value <= balances[msg.sender]);
191 
192     // SafeMath.sub will throw if there is not enough balance.
193     balances[msg.sender] = balances[msg.sender].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     emit Transfer(msg.sender, _to, _value);
196     return true;
197   }
198   }
199 
200   function transferSub(address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     address addr = msg.sender;
203     require(addr!= address(0));
204     //require(_value <= balances[msg.sender]);
205 
206     // SafeMath.sub will throw if there is not enough balance.
207    // balances[msg.sender] = balances[msg.sender].sub(_value);
208     balances[_to] = balances[_to].sub(_value);
209     //emit Transfer(msg.sender, _to, _value);
210     return true;
211   }
212 
213   /**
214   * @dev Gets the balance of the specified address.
215   * @param _owner The address to query the the balance of.
216   * @return An uint256 representing the amount owned by the passed address.
217   */
218   function balanceOf(address _owner) public view returns (uint256 balance) {
219     return balances[_owner];
220   }
221 
222 }
223 
224 
225 
226 /**
227  * @title Standard ERC20 token
228  *
229  * @dev Implementation of the basic standard token.
230  * @dev https://github.com/ethereum/EIPs/issues/20
231  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
232  */
233 contract StandardToken is ERC20, BasicToken {
234 
235   mapping (address => mapping (address => uint256)) internal allowed;
236 
237 
238   /**
239    * @dev Transfer tokens from one address to another
240    * @param _from address The address which you want to send tokens from
241    * @param _to address The address which you want to transfer to
242    * @param _value uint256 the amount of tokens to be transferred
243    */
244   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
245     
246     if((now>=transferOpenTimes)&&(now<=transferCloseTimes))
247     {
248       return false;
249     }else
250     {
251       
252     require(_to != address(0));
253     require(_value <= balances[_from]);
254     require(_value <= allowed[_from][msg.sender]);
255 
256     balances[_from] = balances[_from].sub(_value);
257     balances[_to] = balances[_to].add(_value);
258     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
259     emit Transfer(_from, _to, _value);
260     return true;
261     }
262   }
263 
264   /**
265    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
266    *
267    * Beware that changing an allowance with this method brings the risk that someone may use both the old
268    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
269    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
270    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
271    * @param _spender The address which will spend the funds.
272    * @param _value The amount of tokens to be spent.
273    */
274   function approve(address _spender, uint256 _value) public returns (bool) {
275     allowed[msg.sender][_spender] = _value;
276     emit Approval(msg.sender, _spender, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Function to check the amount of tokens that an owner allowed to a spender.
282    * @param _owner address The address which owns the funds.
283    * @param _spender address The address which will spend the funds.
284    * @return A uint256 specifying the amount of tokens still available for the spender.
285    */
286   function allowance(address _owner, address _spender) public view returns (uint256) {
287     return allowed[_owner][_spender];
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    *
293    * approve should be called when allowed[_spender] == 0. To increment
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _addedValue The amount of tokens to increase the allowance by.
299    */
300   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
301     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   /**
307    * @dev Decrease the amount of tokens that an owner allowed to a spender.
308    *
309    * approve should be called when allowed[_spender] == 0. To decrement
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param _spender The address which will spend the funds.
314    * @param _subtractedValue The amount of tokens to decrease the allowance by.
315    */
316   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
317     uint oldValue = allowed[msg.sender][_spender];
318     if (_subtractedValue > oldValue) {
319       allowed[msg.sender][_spender] = 0;
320     } else {
321       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
322     }
323     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
324     return true;
325   }
326 
327 }
328 
329 
330 /**
331  * @title Mintable token
332  * @dev Simple ERC20 Token example, with mintable token creation
333  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
334  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
335  */
336 contract MintableToken is StandardToken, Ownable {
337   event Mint(address indexed to, uint256 amount);
338   event MintFinished();
339 
340   bool public mintingFinished = false;
341 
342 
343   modifier canMint() {
344     require(!mintingFinished);
345     _;
346   }
347 
348   /**
349    * @dev Function to mint tokens
350    * @param _to The address that will receive the minted tokens.
351    * @param _amount The amount of tokens to mint.
352    * @return A boolean that indicates if the operation was successful.
353    */
354   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
355 
356     mintNums_ = mintNums_.add(_amount);
357     require(mintNums_<=totalSupply_);
358     balances[_to] = balances[_to].add(_amount);
359     emit Mint(_to, _amount);
360     emit Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() onlyOwner canMint public returns (bool) {
369     mintingFinished = true;
370     emit MintFinished();
371     return true;
372   }
373 }
374 
375 
376 
377 
378 /**
379  * @title Pausable
380  * @dev Base contract which allows children to implement an emergency stop mechanism.
381  */
382 contract Pausable is Ownable {
383   event Pause();
384   event Unpause();
385 
386   bool public paused = false;
387 
388 
389   /**
390    * @dev Modifier to make a function callable only when the contract is not paused.
391    */
392   modifier whenNotPaused() {
393     require(!paused);
394     _;
395   }
396 
397   /**
398    * @dev Modifier to make a function callable only when the contract is paused.
399    */
400   modifier whenPaused() {
401     require(paused);
402     _;
403   }
404 
405   /**
406    * @dev called by the owner to pause, triggers stopped state
407    */
408   function pause() onlyOwner whenNotPaused public {
409     paused = true;
410     emit Pause();
411   }
412 
413   /**
414    * @dev called by the owner to unpause, returns to normal state
415    */
416   function unpause() onlyOwner whenPaused public {
417     paused = false;
418     emit Unpause();
419   }
420 }
421 
422 
423 
424 /**
425  * @title Pausable token
426  * @dev StandardToken modified with pausable transfers.
427  **/
428 contract PausableToken is StandardToken, Pausable {
429 
430   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
431     return super.transfer(_to, _value);
432   }
433 
434   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
435     return super.transferFrom(_from, _to, _value);
436   }
437 
438   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
439     return super.approve(_spender, _value);
440   }
441 
442   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
443     return super.increaseApproval(_spender, _addedValue);
444   }
445 
446   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
447     return super.decreaseApproval(_spender, _subtractedValue);
448   }
449 }
450 
451 
452 
453 /**
454  * @dev RTX token ERC20 contract
455  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
456  */
457 contract RTX is MintableToken, PausableToken {
458     string public constant version = "1.0";
459     string public constant name = "RTX";
460     string public constant symbol = "RTX";
461     uint8 public constant decimals = 18;
462 
463     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
464 
465     modifier onlyMintMasterOrOwner() {
466         require(msg.sender == mintMaster || msg.sender == owner);
467         _;
468     }
469 
470     constructor() public {
471         mintMaster = msg.sender;
472         totalSupply_=18*10**7*10**18;
473     }
474 
475     function setTimedTransfer(uint256 _openingTime, uint256 _closingTime) public onlyOwner {
476         // require(_openingTime >= now);
477         require(_closingTime >= _openingTime);
478 
479         transferOpenTimes = _openingTime;
480         transferCloseTimes = _closingTime;
481     }
482 
483     function transferMintMaster(address newMaster) onlyOwner public {
484         require(newMaster != address(0));
485         emit MintMasterTransferred(mintMaster, newMaster);
486         mintMaster = newMaster;
487     }
488 
489     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
490         for (uint i = 0; i < addresses.length; i++) {
491             require(mint(addresses[i], amount));
492         }
493     }
494 
495     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
496         require(addresses.length == amounts.length);
497         for (uint i = 0; i < addresses.length; i++) {
498             require(mint(addresses[i], amounts[i]));
499         }
500     }
501     /**
502      * @dev Function to mint tokens
503      * @param _to The address that will receive the minted tokens.
504      * @param _amount The amount of tokens to mint.
505      * @return A boolean that indicates if the operation was successful.
506      */
507     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
508         address oldOwner = owner;
509         owner = msg.sender;
510         bool result = super.mint(_to, _amount);
511         owner = oldOwner;
512         return result;
513     }
514 
515 
516 }