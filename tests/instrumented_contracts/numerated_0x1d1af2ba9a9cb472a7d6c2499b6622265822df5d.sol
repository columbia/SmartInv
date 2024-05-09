1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 // File: zeppelin-solidity/contracts/math/SafeMath.sol
90 
91 /**
92  * @title SafeMath
93  * @dev Math operations with safety checks that throw on error
94  */
95 library SafeMath {
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   /**
120   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
138 
139 /**
140  * @title ERC20Basic
141  * @dev Simpler version of ERC20 interface
142  * @dev see https://github.com/ethereum/EIPs/issues/179
143  */
144 contract ERC20Basic {
145   function totalSupply() public view returns (uint256);
146   function balanceOf(address who) public view returns (uint256);
147   function transfer(address to, uint256 value) public returns (bool);
148   event Transfer(address indexed from, address indexed to, uint256 value);
149 }
150 
151 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
152 
153 /**
154  * @title ERC20 interface
155  * @dev see https://github.com/ethereum/EIPs/issues/20
156  */
157 contract ERC20 is ERC20Basic {
158   function allowance(address owner, address spender) public view returns (uint256);
159   function transferFrom(address from, address to, uint256 value) public returns (bool);
160   function approve(address spender, uint256 value) public returns (bool);
161   event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint256;
172 
173   mapping(address => uint256) balances;
174 
175   uint256 totalSupply_;
176 
177   /**
178   * @dev total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191     require(_value <= balances[msg.sender]);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
212 
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * @dev https://github.com/ethereum/EIPs/issues/20
218  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
219  */
220 contract StandardToken is ERC20, BasicToken {
221 
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value <= allowed[_from][msg.sender]);
235 
236     balances[_from] = balances[_from].sub(_value);
237     balances[_to] = balances[_to].add(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239     Transfer(_from, _to, _value);
240     return true;
241   }
242 
243   /**
244    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
245    *
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param _spender The address which will spend the funds.
251    * @param _value The amount of tokens to be spent.
252    */
253   function approve(address _spender, uint256 _value) public returns (bool) {
254     allowed[msg.sender][_spender] = _value;
255     Approval(msg.sender, _spender, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Function to check the amount of tokens that an owner allowed to a spender.
261    * @param _owner address The address which owns the funds.
262    * @param _spender address The address which will spend the funds.
263    * @return A uint256 specifying the amount of tokens still available for the spender.
264    */
265   function allowance(address _owner, address _spender) public view returns (uint256) {
266     return allowed[_owner][_spender];
267   }
268 
269   /**
270    * @dev Increase the amount of tokens that an owner allowed to a spender.
271    *
272    * approve should be called when allowed[_spender] == 0. To increment
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param _spender The address which will spend the funds.
277    * @param _addedValue The amount of tokens to increase the allowance by.
278    */
279   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    *
288    * approve should be called when allowed[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param _spender The address which will spend the funds.
293    * @param _subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 // File: contracts/BsktToken.sol
309 
310 library AddressArrayUtils {
311 
312     /// @return Returns index and ok of the first occurrence starting from index 0
313     function index(address[] addresses, address a) internal pure returns (uint, bool) {
314         for (uint i = 0; i < addresses.length; i++) {
315             if (addresses[i] == a) {
316                 return (i, true);
317             }
318         }
319         return (0, false);
320     }
321 
322 }
323 
324 
325 /// @title A decentralized Bskt-like ERC20 which gives the owner a claim to the
326 /// underlying assets
327 /// @notice Bskt Tokens are transferable, and can be created and redeemed by
328 /// anyone. To create, a user must approve the contract to move the underlying
329 /// tokens, then call `create()`.
330 /// @author Daniel Que and Quan Pham
331 contract BsktToken is StandardToken, Pausable {
332     using SafeMath for uint256;
333     using AddressArrayUtils for address[];
334 
335     string public name;
336     string public symbol;
337     uint8 constant public decimals = 18;
338     struct TokenInfo {
339         address addr;
340         uint256 quantity;
341     }
342     uint256 private creationUnit_;
343     TokenInfo[] public tokens;
344 
345     event Mint(address indexed to, uint256 amount);
346     event Burn(address indexed from, uint256 amount);
347 
348     /// @notice Requires value to be divisible by creationUnit
349     /// @param value Number to be checked
350     modifier requireMultiple(uint256 value) {
351         require((value % creationUnit_) == 0);
352         _;
353     }
354 
355     /// @notice Requires value to be non-zero
356     /// @param value Number to be checked
357     modifier requireNonZero(uint256 value) {
358         require(value > 0);
359         _;
360     }
361 
362     /// @notice Initializes contract with a list of ERC20 token addresses and
363     /// corresponding minimum number of units required for a creation unit
364     /// @param addresses Addresses of the underlying ERC20 token contracts
365     /// @param quantities Number of token base units required per creation unit
366     /// @param _creationUnit Number of base units per creation unit
367     function BsktToken(
368         address[] addresses,
369         uint256[] quantities,
370         uint256 _creationUnit,
371         string _name,
372         string _symbol
373     ) public {
374         require(0 < addresses.length && addresses.length < 256);
375         require(addresses.length == quantities.length);
376         require(_creationUnit >= 1);
377 
378         for (uint256 i = 0; i < addresses.length; i++) {
379             tokens.push(TokenInfo({
380                 addr: addresses[i],
381                 quantity: quantities[i]
382             }));
383         }
384 
385         creationUnit_ = _creationUnit;
386         name = _name;
387         symbol = _symbol;
388     }
389 
390     /// @notice Returns the creationUnit
391     /// @dev Creation quantity concept is similar but not identical to the one
392     /// described by EIP777
393     /// @return creationUnit_ Creation quantity of the Bskt token
394     function creationUnit() external view returns(uint256) {
395         return creationUnit_;
396     }
397 
398     /// @notice Creates Bskt tokens in exchange for underlying tokens. Before
399     /// calling, underlying tokens must be approved to be moved by the Bskt Token
400     /// contract. The number of approved tokens required depends on
401     /// baseUnits.
402     /// @dev If any underlying tokens' `transferFrom` fails (eg. the token is
403     /// frozen), create will no longer work. At this point a token upgrade will
404     /// be necessary.
405     /// @param baseUnits Number of base units to create. Must be a multiple of
406     /// creationUnit.
407     function create(uint256 baseUnits)
408         external
409         whenNotPaused()
410         requireNonZero(baseUnits)
411         requireMultiple(baseUnits)
412     {
413         // Check overflow
414         require((totalSupply_ + baseUnits) > totalSupply_);
415 
416         for (uint256 i = 0; i < tokens.length; i++) {
417             TokenInfo memory token = tokens[i];
418             ERC20 erc20 = ERC20(token.addr);
419             uint256 amount = baseUnits.div(creationUnit_).mul(token.quantity);
420             require(erc20.transferFrom(msg.sender, address(this), amount));
421         }
422 
423         mint(msg.sender, baseUnits);
424     }
425 
426     /// @notice Redeems Bskt Token in return for underlying tokens
427     /// @param baseUnits Number of base units to redeem. Must be a multiple of
428     /// creationUnit.
429     /// @param tokensToSkip Underlying token addresses to skip redemption for.
430     /// Intended to be used to skip frozen or broken tokens which would prevent
431     /// all underlying tokens from being withdrawn due to a revert. Skipped
432     /// tokens will be left in the Bskt Token contract and will be unclaimable.
433     function redeem(uint256 baseUnits, address[] tokensToSkip)
434         external
435         requireNonZero(baseUnits)
436         requireMultiple(baseUnits)
437     {
438         require(baseUnits <= totalSupply_);
439         require(baseUnits <= balances[msg.sender]);
440         require(tokensToSkip.length <= tokens.length);
441         // Total supply check not required since a user would have to have balance greater than the total supply
442 
443         // Burn before to prevent re-entrancy
444         burn(msg.sender, baseUnits);
445 
446         for (uint256 i = 0; i < tokens.length; i++) {
447             TokenInfo memory token = tokens[i];
448             ERC20 erc20 = ERC20(token.addr);
449             uint256 index;
450             bool ok;
451             (index, ok) = tokensToSkip.index(token.addr);
452             if (ok) {
453                 continue;
454             }
455             uint256 amount = baseUnits.div(creationUnit_).mul(token.quantity);
456             require(erc20.transfer(msg.sender, amount));
457         }
458     }
459 
460     /// @return addresses Underlying token addresses
461     function tokenAddresses() external view returns (address[]){
462         address[] memory addresses = new address[](tokens.length);
463         for (uint256 i = 0; i < tokens.length; i++) {
464             addresses[i] = tokens[i].addr;
465         }
466         return addresses;
467     }
468 
469     /// @return quantities Number of token base units required per creation unit
470     function tokenQuantities() external view returns (uint256[]){
471         uint256[] memory quantities = new uint256[](tokens.length);
472         for (uint256 i = 0; i < tokens.length; i++) {
473             quantities[i] = tokens[i].quantity;
474         }
475         return quantities;
476     }
477 
478     // @dev Mints new Bskt tokens
479     // @param to
480     // @param amount
481     // @return ok
482     function mint(address to, uint256 amount) internal returns (bool) {
483         totalSupply_ = totalSupply_.add(amount);
484         balances[to] = balances[to].add(amount);
485         Mint(to, amount);
486         Transfer(address(0), to, amount);
487         return true;
488     }
489 
490     // @dev Burns Bskt tokens
491     // @param from
492     // @param amount
493     // @return ok
494     function burn(address from, uint256 amount) internal returns (bool) {
495         totalSupply_ = totalSupply_.sub(amount);
496         balances[from] = balances[from].sub(amount);
497         Burn(from, amount);
498         Transfer(from, address(0), amount);
499         return true;
500     }
501 
502     // @notice Look up token info
503     // @param token Token address to look up
504     // @return (quantity, ok) Units of underlying token, and whether the
505     // operation was successful
506     function getQuantities(address token) internal view returns (uint256, bool) {
507         for (uint256 i = 0; i < tokens.length; i++) {
508             if (tokens[i].addr == token) {
509                 return (tokens[i].quantity, true);
510             }
511         }
512         return (0, false);
513     }
514 
515     /// @notice Owner: Withdraw excess funds which don't belong to Bskt Token
516     /// holders
517     /// @param token ERC20 token address to withdraw
518     function withdrawExcessToken(address token)
519         external
520         onlyOwner
521     {
522         ERC20 erc20 = ERC20(token);
523         uint256 withdrawAmount;
524         uint256 amountOwned = erc20.balanceOf(address(this));
525         uint256 quantity;
526         bool ok;
527         (quantity, ok) = getQuantities(token);
528         if (ok) {
529             withdrawAmount = amountOwned.sub(totalSupply_.div(creationUnit_).mul(quantity));
530         } else {
531             withdrawAmount = amountOwned;
532         }
533         require(erc20.transfer(owner, withdrawAmount));
534     }
535 
536     /// @notice Owner: Withdraw Ether
537     function withdrawEther()
538         external
539         onlyOwner
540     {
541         owner.transfer(this.balance);
542     }
543 
544     /// @notice Fallback function
545     function() external payable {
546     }
547 
548 }