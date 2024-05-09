1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/ReentrancyGuard.sol
4 
5 /**
6  * @title Helps contracts guard agains reentrancy attacks.
7  * @author Remco Bloemen <remco@2π.com>
8  * @notice If you mark a function `nonReentrant`, you should also
9  * mark it `external`.
10  */
11 contract ReentrancyGuard {
12 
13   /**
14    * @dev We use a single lock for the whole contract.
15    */
16   bool private reentrancy_lock = false;
17 
18   /**
19    * @dev Prevents a contract from calling itself, directly or indirectly.
20    * @notice If you mark a function `nonReentrant`, you should also
21    * mark it `external`. Calling one nonReentrant function from
22    * another is not supported. Instead, you can implement a
23    * `private` function doing the actual work, and a `external`
24    * wrapper marked as `nonReentrant`.
25    */
26   modifier nonReentrant() {
27     require(!reentrancy_lock);
28     reentrancy_lock = true;
29     _;
30     reentrancy_lock = false;
31   }
32 
33 }
34 
35 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     emit OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
78 
79 /**
80  * @title Pausable
81  * @dev Base contract which allows children to implement an emergency stop mechanism.
82  */
83 contract Pausable is Ownable {
84   event Pause();
85   event Unpause();
86 
87   bool public paused = false;
88 
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is not paused.
92    */
93   modifier whenNotPaused() {
94     require(!paused);
95     _;
96   }
97 
98   /**
99    * @dev Modifier to make a function callable only when the contract is paused.
100    */
101   modifier whenPaused() {
102     require(paused);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to pause, triggers stopped state
108    */
109   function pause() onlyOwner whenNotPaused public {
110     paused = true;
111     emit Pause();
112   }
113 
114   /**
115    * @dev called by the owner to unpause, returns to normal state
116    */
117   function unpause() onlyOwner whenPaused public {
118     paused = false;
119     emit Unpause();
120   }
121 }
122 
123 // File: zeppelin-solidity/contracts/math/SafeMath.sol
124 
125 /**
126  * @title SafeMath
127  * @dev Math operations with safety checks that throw on error
128  */
129 library SafeMath {
130 
131   /**
132   * @dev Multiplies two numbers, throws on overflow.
133   */
134   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135     if (a == 0) {
136       return 0;
137     }
138     uint256 c = a * b;
139     assert(c / a == b);
140     return c;
141   }
142 
143   /**
144   * @dev Integer division of two numbers, truncating the quotient.
145   */
146   function div(uint256 a, uint256 b) internal pure returns (uint256) {
147     // assert(b > 0); // Solidity automatically throws when dividing by 0
148     // uint256 c = a / b;
149     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
150     return a / b;
151   }
152 
153   /**
154   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
155   */
156   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157     assert(b <= a);
158     return a - b;
159   }
160 
161   /**
162   * @dev Adds two numbers, throws on overflow.
163   */
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     assert(c >= a);
167     return c;
168   }
169 }
170 
171 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
172 
173 /**
174  * @title ERC20Basic
175  * @dev Simpler version of ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/179
177  */
178 contract ERC20Basic {
179   function totalSupply() public view returns (uint256);
180   function balanceOf(address who) public view returns (uint256);
181   function transfer(address to, uint256 value) public returns (bool);
182   event Transfer(address indexed from, address indexed to, uint256 value);
183 }
184 
185 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 is ERC20Basic {
192   function allowance(address owner, address spender) public view returns (uint256);
193   function transferFrom(address from, address to, uint256 value) public returns (bool);
194   function approve(address spender, uint256 value) public returns (bool);
195   event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
199 
200 contract DetailedERC20 is ERC20 {
201   string public name;
202   string public symbol;
203   uint8 public decimals;
204 
205   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
206     name = _name;
207     symbol = _symbol;
208     decimals = _decimals;
209   }
210 }
211 
212 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
213 
214 /**
215  * @title Basic token
216  * @dev Basic version of StandardToken, with no allowances.
217  */
218 contract BasicToken is ERC20Basic {
219   using SafeMath for uint256;
220 
221   mapping(address => uint256) balances;
222 
223   uint256 totalSupply_;
224 
225   /**
226   * @dev total number of tokens in existence
227   */
228   function totalSupply() public view returns (uint256) {
229     return totalSupply_;
230   }
231 
232   /**
233   * @dev transfer token for a specified address
234   * @param _to The address to transfer to.
235   * @param _value The amount to be transferred.
236   */
237   function transfer(address _to, uint256 _value) public returns (bool) {
238     require(_to != address(0));
239     require(_value <= balances[msg.sender]);
240 
241     balances[msg.sender] = balances[msg.sender].sub(_value);
242     balances[_to] = balances[_to].add(_value);
243     emit Transfer(msg.sender, _to, _value);
244     return true;
245   }
246 
247   /**
248   * @dev Gets the balance of the specified address.
249   * @param _owner The address to query the the balance of.
250   * @return An uint256 representing the amount owned by the passed address.
251   */
252   function balanceOf(address _owner) public view returns (uint256 balance) {
253     return balances[_owner];
254   }
255 
256 }
257 
258 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
259 
260 /**
261  * @title Standard ERC20 token
262  *
263  * @dev Implementation of the basic standard token.
264  * @dev https://github.com/ethereum/EIPs/issues/20
265  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
266  */
267 contract StandardToken is ERC20, BasicToken {
268 
269   mapping (address => mapping (address => uint256)) internal allowed;
270 
271 
272   /**
273    * @dev Transfer tokens from one address to another
274    * @param _from address The address which you want to send tokens from
275    * @param _to address The address which you want to transfer to
276    * @param _value uint256 the amount of tokens to be transferred
277    */
278   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
279     require(_to != address(0));
280     require(_value <= balances[_from]);
281     require(_value <= allowed[_from][msg.sender]);
282 
283     balances[_from] = balances[_from].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     emit Transfer(_from, _to, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
292    *
293    * Beware that changing an allowance with this method brings the risk that someone may use both the old
294    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
295    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
296    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297    * @param _spender The address which will spend the funds.
298    * @param _value The amount of tokens to be spent.
299    */
300   function approve(address _spender, uint256 _value) public returns (bool) {
301     allowed[msg.sender][_spender] = _value;
302     emit Approval(msg.sender, _spender, _value);
303     return true;
304   }
305 
306   /**
307    * @dev Function to check the amount of tokens that an owner allowed to a spender.
308    * @param _owner address The address which owns the funds.
309    * @param _spender address The address which will spend the funds.
310    * @return A uint256 specifying the amount of tokens still available for the spender.
311    */
312   function allowance(address _owner, address _spender) public view returns (uint256) {
313     return allowed[_owner][_spender];
314   }
315 
316   /**
317    * @dev Increase the amount of tokens that an owner allowed to a spender.
318    *
319    * approve should be called when allowed[_spender] == 0. To increment
320    * allowed value is better to use this function to avoid 2 calls (and wait until
321    * the first transaction is mined)
322    * From MonolithDAO Token.sol
323    * @param _spender The address which will spend the funds.
324    * @param _addedValue The amount of tokens to increase the allowance by.
325    */
326   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
327     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
328     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
329     return true;
330   }
331 
332   /**
333    * @dev Decrease the amount of tokens that an owner allowed to a spender.
334    *
335    * approve should be called when allowed[_spender] == 0. To decrement
336    * allowed value is better to use this function to avoid 2 calls (and wait until
337    * the first transaction is mined)
338    * From MonolithDAO Token.sol
339    * @param _spender The address which will spend the funds.
340    * @param _subtractedValue The amount of tokens to decrease the allowance by.
341    */
342   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
343     uint oldValue = allowed[msg.sender][_spender];
344     if (_subtractedValue > oldValue) {
345       allowed[msg.sender][_spender] = 0;
346     } else {
347       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
348     }
349     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
350     return true;
351   }
352 
353 }
354 
355 // File: contracts/BsktToken.sol
356 
357 library AddressArrayUtils {
358 
359     /// @return Returns index and ok for the first occurrence starting from
360     /// index 0
361     function index(address[] addresses, address a)
362         internal pure returns (uint, bool)
363     {
364         for (uint i = 0; i < addresses.length; i++) {
365             if (addresses[i] == a) {
366                 return (i, true);
367             }
368         }
369         return (0, false);
370     }
371 
372 }
373 
374 
375 /// @title BsktToken
376 /// @notice Bskt tokens are transferable, and can be created and redeemed by
377 /// anyone. To create, a user must approve the contract to move the underlying
378 /// tokens, then call `create`.
379 /// @author CryptoFin
380 contract BsktToken is StandardToken, DetailedERC20, Pausable, ReentrancyGuard {
381     using SafeMath for uint256;
382     using AddressArrayUtils for address[];
383 
384     struct TokenInfo {
385         address addr;
386         uint256 quantity;
387     }
388     uint256 public creationUnit;
389     TokenInfo[] public tokens;
390 
391     event Create(address indexed creator, uint256 amount);
392     event Redeem(address indexed redeemer, uint256 amount, address[] skippedTokens);
393 
394     /// @notice Requires value to be divisible by creationUnit
395     /// @param value Number to be checked
396     modifier requireMultiple(uint256 value) {
397         require((value % creationUnit) == 0);
398         _;
399     }
400 
401     /// @notice Requires value to be non-zero
402     /// @param value Number to be checked
403     modifier requireNonZero(uint256 value) {
404         require(value > 0);
405         _;
406     }
407 
408     /// @notice Initializes contract with a list of ERC20 token addresses and
409     /// corresponding minimum number of units required for a creation unit
410     /// @param addresses Addresses of the underlying ERC20 token contracts
411     /// @param quantities Number of token base units required per creation unit
412     /// @param _creationUnit Number of base units per creation unit
413     function BsktToken(
414         address[] addresses,
415         uint256[] quantities,
416         uint256 _creationUnit,
417         string _name,
418         string _symbol
419     ) DetailedERC20(_name, _symbol, 18) public {
420         require(addresses.length > 0);
421         require(addresses.length == quantities.length);
422         require(_creationUnit >= 1);
423 
424         for (uint256 i = 0; i < addresses.length; i++) {
425             tokens.push(TokenInfo({
426                 addr: addresses[i],
427                 quantity: quantities[i]
428             }));
429         }
430 
431         creationUnit = _creationUnit;
432         name = _name;
433         symbol = _symbol;
434     }
435 
436     /// @notice Creates Bskt tokens in exchange for underlying tokens. Before
437     /// calling, underlying tokens must be approved to be moved by the Bskt
438     /// contract. The number of approved tokens required depends on baseUnits.
439     /// @dev If any underlying tokens' `transferFrom` fails (eg. the token is
440     /// frozen), create will no longer work. At this point a token upgrade will
441     /// be necessary.
442     /// @param baseUnits Number of base units to create. Must be a multiple of
443     /// creationUnit.
444     function create(uint256 baseUnits)
445         external
446         whenNotPaused()
447         requireNonZero(baseUnits)
448         requireMultiple(baseUnits)
449     {
450         // Check overflow
451         require((totalSupply_ + baseUnits) > totalSupply_);
452 
453         for (uint256 i = 0; i < tokens.length; i++) {
454             TokenInfo memory token = tokens[i];
455             ERC20 erc20 = ERC20(token.addr);
456             uint256 amount = baseUnits.div(creationUnit).mul(token.quantity);
457             require(erc20.transferFrom(msg.sender, address(this), amount));
458         }
459 
460         mint(msg.sender, baseUnits);
461         emit Create(msg.sender, baseUnits);
462     }
463 
464     /// @notice Redeems Bskt tokens in exchange for underlying tokens
465     /// @param baseUnits Number of base units to redeem. Must be a multiple of
466     /// creationUnit.
467     /// @param tokensToSkip Underlying token addresses to skip redemption for.
468     /// Intended to be used to skip frozen or broken tokens which would prevent
469     /// all underlying tokens from being withdrawn due to a revert. Skipped
470     /// tokens are left in the Bskt contract and are unclaimable.
471     function redeem(uint256 baseUnits, address[] tokensToSkip)
472         external
473         requireNonZero(baseUnits)
474         requireMultiple(baseUnits)
475     {
476         require(baseUnits <= totalSupply_);
477         require(baseUnits <= balances[msg.sender]);
478         require(tokensToSkip.length <= tokens.length);
479         // Total supply check not required since a user would have to have
480         // balance greater than the total supply
481 
482         // Burn before to prevent re-entrancy
483         burn(msg.sender, baseUnits);
484 
485         for (uint256 i = 0; i < tokens.length; i++) {
486             TokenInfo memory token = tokens[i];
487             ERC20 erc20 = ERC20(token.addr);
488             uint256 index;
489             bool ok;
490             (index, ok) = tokensToSkip.index(token.addr);
491             if (ok) {
492                 continue;
493             }
494             uint256 amount = baseUnits.div(creationUnit).mul(token.quantity);
495             require(erc20.transfer(msg.sender, amount));
496         }
497         emit Redeem(msg.sender, baseUnits, tokensToSkip);
498     }
499 
500     /// @return addresses Underlying token addresses
501     function tokenAddresses() external view returns (address[]){
502         address[] memory addresses = new address[](tokens.length);
503         for (uint256 i = 0; i < tokens.length; i++) {
504             addresses[i] = tokens[i].addr;
505         }
506         return addresses;
507     }
508 
509     /// @return quantities Number of token base units required per creation unit
510     function tokenQuantities() external view returns (uint256[]){
511         uint256[] memory quantities = new uint256[](tokens.length);
512         for (uint256 i = 0; i < tokens.length; i++) {
513             quantities[i] = tokens[i].quantity;
514         }
515         return quantities;
516     }
517 
518     // @dev Mints new Bskt tokens
519     // @param to Address to mint to
520     // @param amount Amount to mint
521     // @return ok Whether the operation was successful
522     function mint(address to, uint256 amount) internal returns (bool) {
523         totalSupply_ = totalSupply_.add(amount);
524         balances[to] = balances[to].add(amount);
525         emit Transfer(address(0), to, amount);
526         return true;
527     }
528 
529     // @dev Burns Bskt tokens
530     // @param from Address to burn from
531     // @param amount Amount to burn
532     // @return ok Whether the operation was successful
533     function burn(address from, uint256 amount) internal returns (bool) {
534         totalSupply_ = totalSupply_.sub(amount);
535         balances[from] = balances[from].sub(amount);
536         emit Transfer(from, address(0), amount);
537         return true;
538     }
539 
540     // @notice Look up token quantity and whether token exists
541     // @param token Token address to look up
542     // @return (quantity, ok) Units of underlying token, and whether the
543     // token was found
544     function getQuantity(address token) internal view returns (uint256, bool) {
545         for (uint256 i = 0; i < tokens.length; i++) {
546             if (tokens[i].addr == token) {
547                 return (tokens[i].quantity, true);
548             }
549         }
550         return (0, false);
551     }
552 
553     /// @notice Owner: Withdraw excess funds which don't belong to Bskt token
554     /// holders
555     /// @param token ERC20 token address to withdraw
556     function withdrawExcessToken(address token)
557         external
558         onlyOwner
559         nonReentrant
560     {
561         ERC20 erc20 = ERC20(token);
562         uint256 withdrawAmount;
563         uint256 amountOwned = erc20.balanceOf(address(this));
564         uint256 quantity;
565         bool ok;
566         (quantity, ok) = getQuantity(token);
567         if (ok) {
568             withdrawAmount = amountOwned.sub(
569                 totalSupply_.div(creationUnit).mul(quantity)
570             );
571         } else {
572             withdrawAmount = amountOwned;
573         }
574         require(erc20.transfer(owner, withdrawAmount));
575     }
576 
577     /// @dev Prevent Bskt tokens from being sent to the Bskt contract
578     /// @param _to The address to transfer tokens to
579     /// @param _value the amount of tokens to be transferred
580     function transfer(address _to, uint256 _value) public returns (bool) {
581         require(_to != address(this));
582         return super.transfer(_to, _value);
583     }
584 
585     /// @dev Prevent Bskt tokens from being sent to the Bskt contract
586     /// @param _from The address to transfer tokens from
587     /// @param _to The address to transfer to
588     /// @param _value The amount of tokens to be transferred
589     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
590         require(_to != address(this));
591         return super.transferFrom(_from, _to, _value);
592     }
593 
594 }