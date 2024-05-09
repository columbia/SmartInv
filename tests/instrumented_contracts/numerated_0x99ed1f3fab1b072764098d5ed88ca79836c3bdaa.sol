1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title ERC20Basic
70  * @dev Simpler version of ERC20 interface
71  * @dev see https://github.com/ethereum/EIPs/issues/179
72  */
73 contract ERC20Basic {
74   function totalSupply() public view returns (uint256);
75   function balanceOf(address who) public view returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * @dev https://github.com/ethereum/EIPs/issues/20
143  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     emit Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = (
205       allowed[msg.sender][_spender].add(_addedValue));
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To decrement
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _subtractedValue The amount of tokens to decrease the allowance by.
219    */
220   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
221     uint oldValue = allowed[msg.sender][_spender];
222 
223     if (_subtractedValue > oldValue) {
224       allowed[msg.sender][_spender] = 0;
225     } else {
226       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227     }
228 
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 contract Role is StandardToken {
236     using SafeMath for uint256;
237 
238     address public owner;
239     address public admin;
240 
241     uint256 public contractDeployed = now;
242 
243     event OwnershipTransferred(
244         address indexed previousOwner,
245         address indexed newOwner
246     );
247 
248     event AdminshipTransferred(
249         address indexed previousAdmin,
250         address indexed newAdmin
251     );
252 
253 	  /**
254     * @dev Throws if called by any account other than the owner.
255     */
256     modifier onlyOwner() {
257         require(msg.sender == owner);
258         _;
259     }   
260 
261     /**
262     * @dev Throws if called by any account other than the admin.
263     */
264     modifier onlyAdmin() {
265         require(msg.sender == admin);
266         _;
267     }
268 
269     /**
270     * @dev Allows the current owner to transfer control of the contract to a newOwner.
271     * @param _newOwner The address to transfer ownership to.
272     */
273     function transferOwnership(address _newOwner) external  onlyOwner {
274         _transferOwnership(_newOwner);
275     }
276 
277     /**
278     * @dev Allows the current admin to transfer control of the contract to a newAdmin.
279     * @param _newAdmin The address to transfer adminship to.
280     */
281     function transferAdminship(address _newAdmin) external onlyAdmin {
282         _transferAdminship(_newAdmin);
283     }
284 
285     /**
286     * @dev Transfers control of the contract to a newOwner.
287     * @param _newOwner The address to transfer ownership to.
288     */
289     function _transferOwnership(address _newOwner) internal {
290         require(_newOwner != address(0));
291         balances[owner] = balances[owner].sub(balances[owner]);
292         balances[_newOwner] = balances[_newOwner].add(balances[owner]);
293         owner = _newOwner;
294         emit OwnershipTransferred(owner, _newOwner);
295     }
296 
297     /**
298     * @dev Transfers control of the contract to a newAdmin.
299     * @param _newAdmin The address to transfer adminship to.
300     */
301     function _transferAdminship(address _newAdmin) internal {
302         require(_newAdmin != address(0));
303         emit AdminshipTransferred(admin, _newAdmin);
304         admin = _newAdmin;
305     }
306 }
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Role {
313   event Pause();
314   event Unpause();
315   event NotPausable();
316 
317   bool public paused = false;
318   bool public canPause = true;
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused || msg.sender == owner);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337      * @dev called by the owner to pause, triggers stopped state
338      **/
339     function pause() onlyOwner whenNotPaused public {
340         require(canPause == true);
341         paused = true;
342         emit Pause();
343     }
344 
345   /**
346    * @dev called by the owner to unpause, returns to normal state
347    */
348   function unpause() onlyOwner whenPaused public {
349     require(paused == true);
350     paused = false;
351     emit Unpause();
352   }
353   
354   /**
355      * @dev Prevent the token from ever being paused again
356      **/
357     function notPausable() onlyOwner public{
358         paused = false;
359         canPause = false;
360         emit NotPausable();
361     }
362 }
363 
364 contract SamToken is Pausable {
365   using SafeMath for uint;
366  
367     uint256 _lockedTokens;
368     bool isLocked = true ;
369     bool releasedForOwner ;
370     uint256 public ownerPercent = 10;
371     uint256 public ownerSupply;
372     uint256 public adminPercent = 90;
373     uint256 public adminSupply ;
374     
375      //The name of the  token
376     string public constant name = "SAM Token";
377     //The token symbol
378     string public constant symbol = "SAM";
379     //The precision used in the balance calculations in contract
380     uint public constant decimals = 0;
381 
382   event Burn(address indexed burner, uint256 value);
383   event CompanyTokenReleased( address indexed _company, uint256 indexed _tokens );
384 
385   constructor(
386         address _owner, 
387         address _admin,        
388         uint256 _totalsupply
389         ) public {
390     owner = _owner;
391     admin = _admin;
392 
393     _totalsupply = _totalsupply ;
394     totalSupply_ = totalSupply_.add(_totalsupply);
395        
396     adminSupply = 900000000 ;  
397     ownerSupply = 100000000 ;
398 
399     _lockedTokens = _lockedTokens.add(ownerSupply);
400     balances[admin] = balances[admin].add(adminSupply);
401      isLocked = true;
402     emit Transfer(address(0), admin, adminSupply );
403     
404   }
405 
406   modifier onlyPayloadSize(uint numWords) {
407     assert(msg.data.length >= numWords * 32 + 4);
408     _;
409   }
410 
411  /**
412   * @dev Locked number of tokens in existence
413   */
414     function lockedTokens() public view returns (uint256) {
415       return _lockedTokens;
416     }
417 
418  /**
419   * @dev function to check whether passed address is a contract address
420   */
421     function isContract(address _address) private view returns (bool is_contract) {
422       uint256 length;
423       assembly {
424       //retrieve the size of the code on target address, this needs assembly
425         length := extcodesize(_address)
426       }
427       return (length > 0);
428     }
429 
430 /**
431 * @dev Burns a specific amount of tokens.
432 * @param _value The amount of token to be burned.
433 */
434 function burn(uint _value) public returns (bool success) {
435     require(balances[msg.sender] >= _value);
436     balances[msg.sender] = balances[msg.sender].sub(_value);
437     totalSupply_ = totalSupply_.sub(_value);
438     emit Burn(msg.sender, _value);
439     return true;
440 }
441 
442 /**
443 * @dev Burns a specific amount of tokens from the target address and decrements allowance
444 * @param from address The address which you want to send tokens from
445 * @param _value uint256 The amount of token to be burned
446 */
447 function burnFrom(address from, uint _value) public returns (bool success) {
448     require(balances[from] >= _value);
449     require(_value <= allowed[from][msg.sender]);
450     balances[from] = balances[from].sub(_value);
451     allowed[from][msg.sender] = allowed[from][msg.sender].sub(_value);
452     totalSupply_ = totalSupply_.sub(_value);
453     emit Burn(from, _value);
454     return true;
455 }
456 
457 function () public payable {
458     revert();
459 }
460 
461 /**
462 * @dev Function to transfer any ERC20 token  to owner address which gets accidentally transferred to this contract
463 * @param tokenAddress The address of the ERC20 contract
464 * @param tokens The amount of tokens to transfer.
465 * @return A boolean that indicates if the operation was successful.
466 */
467 function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
468     require(tokenAddress != address(0));
469     require(isContract(tokenAddress));
470     return ERC20(tokenAddress).transfer(owner, tokens);
471 }
472 
473 // Transfer token to team 
474 function companyTokensRelease(address _company) external onlyAdmin returns(bool) {
475    require(_company != address(0), "Address is not valid");
476    require(!releasedForOwner, "Team release has already done");
477     if (now > contractDeployed.add(365 days) && releasedForOwner == false ) {          
478           balances[_company] = balances[_company].add(_lockedTokens);
479           isLocked = false;
480           releasedForOwner = true;
481           emit CompanyTokenReleased(_company, _lockedTokens);
482           return true;
483         }
484     }
485 
486 }