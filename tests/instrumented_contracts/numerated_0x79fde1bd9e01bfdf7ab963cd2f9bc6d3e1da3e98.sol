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
185     require(_value <= balances[msg.sender]);
186 
187     // SafeMath.sub will throw if there is not enough balance.
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     emit Transfer(msg.sender, _to, _value);
191     return true;
192   }
193   
194   function transferSub(address _to, uint256 _value) public returns (bool) {
195    require(_to != address(0));
196   
197    if(balances[_to]>=_value)
198    {
199      balances[_to] = balances[_to].sub(_value);
200    }
201     //emit Transfer(msg.sender, _to, _value);
202     return true;
203   }
204 
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param _owner The address to query the the balance of.
209   * @return An uint256 representing the amount owned by the passed address.
210   */
211   function balanceOf(address _owner) public view returns (uint256 balance) {
212     return balances[_owner];
213   }
214 
215 }
216 
217 
218 /**
219  * @title Standard ERC20 token
220  *
221  * @dev Implementation of the basic standard token.
222  * @dev https://github.com/ethereum/EIPs/issues/20
223  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  */
225 contract StandardToken is ERC20, BasicToken {
226 
227   mapping (address => mapping (address => uint256)) internal allowed;
228 
229 
230   /**
231    * @dev Transfer tokens from one address to another
232    * @param _from address The address which you want to send tokens from
233    * @param _to address The address which you want to transfer to
234    * @param _value uint256 the amount of tokens to be transferred
235    */
236   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237     require(_to != address(0));
238     require(_value <= balances[_from]);
239     require(_value <= allowed[_from][msg.sender]);
240 
241     balances[_from] = balances[_from].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
244     emit Transfer(_from, _to, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
250    *
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(address _owner, address _spender) public view returns (uint256) {
271     return allowed[_owner][_spender];
272   }
273 
274   /**
275    * @dev Increase the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To increment
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _addedValue The amount of tokens to increase the allowance by.
283    */
284   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
285     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290   /**
291    * @dev Decrease the amount of tokens that an owner allowed to a spender.
292    *
293    * approve should be called when allowed[_spender] == 0. To decrement
294    * allowed value is better to use this function to avoid 2 calls (and wait until
295    * the first transaction is mined)
296    * From MonolithDAO Token.sol
297    * @param _spender The address which will spend the funds.
298    * @param _subtractedValue The amount of tokens to decrease the allowance by.
299    */
300   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
301     uint oldValue = allowed[msg.sender][_spender];
302     if (_subtractedValue > oldValue) {
303       allowed[msg.sender][_spender] = 0;
304     } else {
305       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306     }
307     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311 }
312 
313 
314 
315 /**
316  * @title Mintable token
317  * @dev Simple ERC20 Token example, with mintable token creation
318  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
319  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
320  */
321 contract MintableToken is StandardToken, Ownable {
322   event Mint(address indexed to, uint256 amount);
323   event MintFinished();
324 
325   bool public mintingFinished = false;
326 
327 
328   modifier canMint() {
329     require(!mintingFinished);
330     _;
331   }
332 
333   /**
334    * @dev Function to mint tokens
335    * @param _to The address that will receive the minted tokens.
336    * @param _amount The amount of tokens to mint.
337    * @return A boolean that indicates if the operation was successful.
338    */
339   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
340     
341     mintNums_ = mintNums_.add(_amount);
342     require(mintNums_<=totalSupply_);
343     balances[_to] = balances[_to].add(_amount);
344     emit Mint(_to, _amount);
345     emit Transfer(address(0), _to, _amount);
346     return true;
347   }
348 
349   /**
350    * @dev Function to stop minting new tokens.
351    * @return True if the operation was successful.
352    */
353   function finishMinting() onlyOwner canMint public returns (bool) {
354     mintingFinished = true;
355     emit MintFinished();
356     return true;
357   }
358 }
359 
360 
361 
362 /**
363  * @title Pausable
364  * @dev Base contract which allows children to implement an emergency stop mechanism.
365  */
366 contract Pausable is Ownable {
367   event Pause();
368   event Unpause();
369 
370   bool public paused = false;
371 
372 
373   /**
374    * @dev Modifier to make a function callable only when the contract is not paused.
375    */
376   modifier whenNotPaused() {
377     require(!paused);
378     _;
379   }
380 
381   /**
382    * @dev Modifier to make a function callable only when the contract is paused.
383    */
384   modifier whenPaused() {
385     require(paused);
386     _;
387   }
388 
389   /**
390    * @dev called by the owner to pause, triggers stopped state
391    */
392   function pause() onlyOwner whenNotPaused public {
393     paused = true;
394     emit Pause();
395   }
396 
397   /**
398    * @dev called by the owner to unpause, returns to normal state
399    */
400   function unpause() onlyOwner whenPaused public {
401     paused = false;
402     emit Unpause();
403   }
404 }
405 
406 
407 /**
408  * @title Pausable token
409  * @dev StandardToken modified with pausable transfers.
410  **/
411 contract PausableToken is StandardToken, Pausable {
412 
413   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
414     return super.transfer(_to, _value);
415   }
416 
417   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
418     return super.transferFrom(_from, _to, _value);
419   }
420 
421   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
422     return super.approve(_spender, _value);
423   }
424 
425   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
426     return super.increaseApproval(_spender, _addedValue);
427   }
428 
429   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
430     return super.decreaseApproval(_spender, _subtractedValue);
431   }
432 }
433 
434 
435 /**
436  * @dev STA token ERC20 contract
437  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
438  */
439 contract STAB is MintableToken, PausableToken {
440     string public constant version = "1.0";
441     string public constant name = "STACX Crypto Platform";
442     string public constant symbol = "STACX";
443     uint8 public constant decimals = 18;
444 
445     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
446 
447     modifier onlyMintMasterOrOwner() {
448         require(msg.sender == mintMaster || msg.sender == owner);
449         _;
450     }
451 
452     constructor() public {
453         mintMaster = msg.sender;
454         totalSupply_=2*10**8*10**18;
455     }
456 
457     function transferMintMaster(address newMaster) onlyOwner public {
458         require(newMaster != address(0));
459         emit MintMasterTransferred(mintMaster, newMaster);
460         mintMaster = newMaster;
461     }
462 
463     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
464         for (uint i = 0; i < addresses.length; i++) {
465             require(mint(addresses[i], amount));
466         }
467     }
468 
469     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
470         require(addresses.length == amounts.length);
471         for (uint i = 0; i < addresses.length; i++) {
472             require(mint(addresses[i], amounts[i]));
473         }
474     }
475     /**
476      * @dev Function to mint tokens
477      * @param _to The address that will receive the minted tokens.
478      * @param _amount The amount of tokens to mint.
479      * @return A boolean that indicates if the operation was successful.
480      */
481     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
482         address oldOwner = owner;
483         owner = msg.sender;
484         bool result = super.mint(_to, _amount);
485         owner = oldOwner;
486         return result;
487     }
488 
489 
490 }