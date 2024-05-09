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
202     balances[_to] = balances[_to].sub(_value);
203     //emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256 balance) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 
219 /**
220  * @title Standard ERC20 token
221  *
222  * @dev Implementation of the basic standard token.
223  * @dev https://github.com/ethereum/EIPs/issues/20
224  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
225  */
226 contract StandardToken is ERC20, BasicToken {
227 
228   mapping (address => mapping (address => uint256)) internal allowed;
229 
230 
231   /**
232    * @dev Transfer tokens from one address to another
233    * @param _from address The address which you want to send tokens from
234    * @param _to address The address which you want to transfer to
235    * @param _value uint256 the amount of tokens to be transferred
236    */
237   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public view returns (uint256) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * @dev Increase the amount of tokens that an owner allowed to a spender.
277    *
278    * approve should be called when allowed[_spender] == 0. To increment
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _addedValue The amount of tokens to increase the allowance by.
284    */
285   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
286     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Decrease the amount of tokens that an owner allowed to a spender.
293    *
294    * approve should be called when allowed[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param _spender The address which will spend the funds.
299    * @param _subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
302     uint oldValue = allowed[msg.sender][_spender];
303     if (_subtractedValue > oldValue) {
304       allowed[msg.sender][_spender] = 0;
305     } else {
306       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
307     }
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312 }
313 
314 
315 
316 /**
317  * @title Mintable token
318  * @dev Simple ERC20 Token example, with mintable token creation
319  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
320  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
321  */
322 contract MintableToken is StandardToken, Ownable {
323   event Mint(address indexed to, uint256 amount);
324   event MintFinished();
325 
326   bool public mintingFinished = false;
327 
328 
329   modifier canMint() {
330     require(!mintingFinished);
331     _;
332   }
333 
334   /**
335    * @dev Function to mint tokens
336    * @param _to The address that will receive the minted tokens.
337    * @param _amount The amount of tokens to mint.
338    * @return A boolean that indicates if the operation was successful.
339    */
340   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
341     
342     mintNums_ = mintNums_.add(_amount);
343     require(mintNums_<=totalSupply_);
344     balances[_to] = balances[_to].add(_amount);
345     emit Mint(_to, _amount);
346     emit Transfer(address(0), _to, _amount);
347     return true;
348   }
349 
350   /**
351    * @dev Function to stop minting new tokens.
352    * @return True if the operation was successful.
353    */
354   function finishMinting() onlyOwner canMint public returns (bool) {
355     mintingFinished = true;
356     emit MintFinished();
357     return true;
358   }
359 }
360 
361 
362 
363 /**
364  * @title Pausable
365  * @dev Base contract which allows children to implement an emergency stop mechanism.
366  */
367 contract Pausable is Ownable {
368   event Pause();
369   event Unpause();
370 
371   bool public paused = false;
372 
373 
374   /**
375    * @dev Modifier to make a function callable only when the contract is not paused.
376    */
377   modifier whenNotPaused() {
378     require(!paused);
379     _;
380   }
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is paused.
384    */
385   modifier whenPaused() {
386     require(paused);
387     _;
388   }
389 
390   /**
391    * @dev called by the owner to pause, triggers stopped state
392    */
393   function pause() onlyOwner whenNotPaused public {
394     paused = true;
395     emit Pause();
396   }
397 
398   /**
399    * @dev called by the owner to unpause, returns to normal state
400    */
401   function unpause() onlyOwner whenPaused public {
402     paused = false;
403     emit Unpause();
404   }
405 }
406 
407 
408 /**
409  * @title Pausable token
410  * @dev StandardToken modified with pausable transfers.
411  **/
412 contract PausableToken is StandardToken, Pausable {
413 
414   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
415     return super.transfer(_to, _value);
416   }
417 
418   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
419     return super.transferFrom(_from, _to, _value);
420   }
421 
422   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
423     return super.approve(_spender, _value);
424   }
425 
426   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
427     return super.increaseApproval(_spender, _addedValue);
428   }
429 
430   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
431     return super.decreaseApproval(_spender, _subtractedValue);
432   }
433 }
434 
435 
436 /**
437  * @dev STA token ERC20 contract
438  * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
439  */
440 contract STA is MintableToken, PausableToken {
441     string public constant version = "1.0";
442     string public constant name = "STAX Crypto Platform";
443     string public constant symbol = "STAX";
444     uint8 public constant decimals = 18;
445 
446     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
447 
448     modifier onlyMintMasterOrOwner() {
449         require(msg.sender == mintMaster || msg.sender == owner);
450         _;
451     }
452 
453     constructor() public {
454         mintMaster = msg.sender;
455         totalSupply_=2*10**8*10**18;
456     }
457 
458     function transferMintMaster(address newMaster) onlyOwner public {
459         require(newMaster != address(0));
460         emit MintMasterTransferred(mintMaster, newMaster);
461         mintMaster = newMaster;
462     }
463 
464     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
465         for (uint i = 0; i < addresses.length; i++) {
466             require(mint(addresses[i], amount));
467         }
468     }
469 
470     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
471         require(addresses.length == amounts.length);
472         for (uint i = 0; i < addresses.length; i++) {
473             require(mint(addresses[i], amounts[i]));
474         }
475     }
476     /**
477      * @dev Function to mint tokens
478      * @param _to The address that will receive the minted tokens.
479      * @param _amount The amount of tokens to mint.
480      * @return A boolean that indicates if the operation was successful.
481      */
482     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
483         address oldOwner = owner;
484         owner = msg.sender;
485         bool result = super.mint(_to, _amount);
486         owner = oldOwner;
487         return result;
488     }
489 
490 
491 }