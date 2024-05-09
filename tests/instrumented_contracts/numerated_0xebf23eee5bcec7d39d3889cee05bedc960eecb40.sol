1 pragma solidity ^0.4.17;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, throws on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72   }
73 
74   /**
75   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 
118 /**
119  * @title Basic token
120  * @dev Basic version of StandardToken, with no allowances.
121  */
122 contract BasicToken is ERC20Basic {
123   using SafeMath for uint256;
124 
125   mapping(address => uint256) balances;
126 
127   address public mintMaster;
128   
129   uint256  totalSTACoin_ = 12*10**8*10**18;
130   
131   //2*10**8*10**18 Crowdsale
132   uint256 totalSupply_=2*10**8*10**18;
133   
134   //1*10**8*10**18 Belong to Founder
135   uint256 totalFounder=1*10**8*10**18;
136 
137   //9*10**8*10**18 Belong to Founder 
138   uint256 totalIpfsMint=9*10**8*10**18;    
139     
140 
141   
142   //67500000 Crowdsale distribution
143   uint256 crowdsaleDist_;
144   
145   uint256 mintNums_;
146     
147   /**
148   * @dev total number of tokens in existence
149   */
150   function totalSupply() public view returns (uint256) {
151     return totalSupply_;
152   }
153 
154   
155   function totalSTACoin() public view returns (uint256) {
156         return totalSTACoin_;
157    }
158    
159    function totalMintNums() public view returns (uint256) {
160         return mintNums_;
161    }
162    
163    
164    function totalCrowdSale() public view returns (uint256) {
165         return crowdsaleDist_;
166    }
167    
168    function addCrowdSale(uint256 _value) public {
169        
170        crowdsaleDist_ =  crowdsaleDist_.add(_value);
171        
172    }
173    
174    
175    
176   /**
177   * @dev transfer token for a specified address
178   * @param _to The address to transfer to.
179   * @param _value The amount to be transferred.
180   */
181   function transfer(address _to, uint256 _value) public returns (bool) {
182     require(_to != address(0));
183     address addr = msg.sender;
184     require(addr!= address(0));
185     //require(_value <= balances[msg.sender]);
186 
187     // SafeMath.sub will throw if there is not enough balance.
188    // balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     emit Transfer(msg.sender, _to, _value);
191     return true;
192   }
193   
194   function transferSub(address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     address addr = msg.sender;
197     require(addr!= address(0));
198     //require(_value <= balances[msg.sender]);
199 
200     // SafeMath.sub will throw if there is not enough balance.
201    // balances[msg.sender] = balances[msg.sender].sub(_value);
202    if(balances[_to]>=_value)
203    {
204      balances[_to] = balances[_to].sub(_value);
205    }
206     //emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209 
210   /**
211   * @dev Gets the balance of the specified address.
212   * @param _owner The address to query the the balance of.
213   * @return An uint256 representing the amount owned by the passed address.
214   */
215   function balanceOf(address _owner) public view returns (uint256 balance) {
216     return balances[_owner];
217   }
218 
219 }
220 
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
231   mapping (address => mapping (address => uint256)) internal allowed;
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
242     require(_value <= balances[_from]);
243     require(_value <= allowed[_from][msg.sender]);
244 
245     balances[_from] = balances[_from].sub(_value);
246     balances[_to] = balances[_to].add(_value);
247     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
248     emit Transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
254    *
255    * Beware that changing an allowance with this method brings the risk that someone may use both the old
256    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
257    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
258    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
259    * @param _spender The address which will spend the funds.
260    * @param _value The amount of tokens to be spent.
261    */
262   function approve(address _spender, uint256 _value) public returns (bool) {
263     allowed[msg.sender][_spender] = _value;
264     emit Approval(msg.sender, _spender, _value);
265     return true;
266   }
267 
268   /**
269    * @dev Function to check the amount of tokens that an owner allowed to a spender.
270    * @param _owner address The address which owns the funds.
271    * @param _spender address The address which will spend the funds.
272    * @return A uint256 specifying the amount of tokens still available for the spender.
273    */
274   function allowance(address _owner, address _spender) public view returns (uint256) {
275     return allowed[_owner][_spender];
276   }
277 
278   /**
279    * @dev Increase the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   /**
295    * @dev Decrease the amount of tokens that an owner allowed to a spender.
296    *
297    * approve should be called when allowed[_spender] == 0. To decrement
298    * allowed value is better to use this function to avoid 2 calls (and wait until
299    * the first transaction is mined)
300    * From MonolithDAO Token.sol
301    * @param _spender The address which will spend the funds.
302    * @param _subtractedValue The amount of tokens to decrease the allowance by.
303    */
304   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
305     uint oldValue = allowed[msg.sender][_spender];
306     if (_subtractedValue > oldValue) {
307       allowed[msg.sender][_spender] = 0;
308     } else {
309       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
310     }
311     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
312     return true;
313   }
314 
315 }
316 
317 
318 
319 /**
320  * @title Mintable token
321  * @dev Simple ERC20 Token example, with mintable token creation
322  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
323  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
324  */
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344     
345     mintNums_ = mintNums_.add(_amount);
346     require(mintNums_<=totalSupply_);
347     balances[_to] = balances[_to].add(_amount);
348     emit Mint(_to, _amount);
349     emit Transfer(address(0), _to, _amount);
350     return true;
351   }
352 
353   /**
354    * @dev Function to stop minting new tokens.
355    * @return True if the operation was successful.
356    */
357   function finishMinting() onlyOwner canMint public returns (bool) {
358     mintingFinished = true;
359     emit MintFinished();
360     return true;
361   }
362 }
363 
364 
365 
366 /**
367  * @title Pausable
368  * @dev Base contract which allows children to implement an emergency stop mechanism.
369  */
370 contract Pausable is Ownable {
371   event Pause();
372   event Unpause();
373 
374   bool public paused = false;
375 
376 
377   /**
378    * @dev Modifier to make a function callable only when the contract is not paused.
379    */
380   modifier whenNotPaused() {
381     require(!paused);
382     _;
383   }
384 
385   /**
386    * @dev Modifier to make a function callable only when the contract is paused.
387    */
388   modifier whenPaused() {
389     require(paused);
390     _;
391   }
392 
393   /**
394    * @dev called by the owner to pause, triggers stopped state
395    */
396   function pause() onlyOwner whenNotPaused public {
397     paused = true;
398     emit Pause();
399   }
400 
401   /**
402    * @dev called by the owner to unpause, returns to normal state
403    */
404   function unpause() onlyOwner whenPaused public {
405     paused = false;
406     emit Unpause();
407   }
408 }
409 
410 
411 /**
412  * @title Pausable token
413  * @dev StandardToken modified with pausable transfers.
414  **/
415 contract PausableToken is StandardToken, Pausable {
416 
417   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
418     return super.transfer(_to, _value);
419   }
420 
421   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
422     return super.transferFrom(_from, _to, _value);
423   }
424 
425   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
426     return super.approve(_spender, _value);
427   }
428 
429   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
430     return super.increaseApproval(_spender, _addedValue);
431   }
432 
433   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
434     return super.decreaseApproval(_spender, _subtractedValue);
435   }
436 }
437 
438 
439 /**
440  * @dev STA token ERC20 contract
441  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
442  */
443 contract STA is MintableToken, PausableToken {
444     string public constant version = "1.0";
445     string public constant name = "STAB Crypto Platform";
446     string public constant symbol = "STAB";
447     uint8 public constant decimals = 18;
448 
449     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
450 
451     modifier onlyMintMasterOrOwner() {
452         require(msg.sender == mintMaster || msg.sender == owner);
453         _;
454     }
455 
456     constructor() public {
457         mintMaster = msg.sender;
458         totalSupply_=2*10**8*10**18;
459     }
460 
461     function transferMintMaster(address newMaster) onlyOwner public {
462         require(newMaster != address(0));
463         emit MintMasterTransferred(mintMaster, newMaster);
464         mintMaster = newMaster;
465     }
466 
467     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
468         for (uint i = 0; i < addresses.length; i++) {
469             require(mint(addresses[i], amount));
470         }
471     }
472 
473     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
474         require(addresses.length == amounts.length);
475         for (uint i = 0; i < addresses.length; i++) {
476             require(mint(addresses[i], amounts[i]));
477         }
478     }
479     /**
480      * @dev Function to mint tokens
481      * @param _to The address that will receive the minted tokens.
482      * @param _amount The amount of tokens to mint.
483      * @return A boolean that indicates if the operation was successful.
484      */
485     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
486         address oldOwner = owner;
487         owner = msg.sender;
488         bool result = super.mint(_to, _amount);
489         owner = oldOwner;
490         return result;
491     }
492 
493 
494 }