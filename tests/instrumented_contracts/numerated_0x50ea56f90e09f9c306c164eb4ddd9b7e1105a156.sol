1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
21   function Ownable() public {
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
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/math/SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     if (a == 0) {
104       return 0;
105     }
106     uint256 c = a * b;
107     assert(c / a == b);
108     return c;
109   }
110 
111   /**
112   * @dev Integer division of two numbers, truncating the quotient.
113   */
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint256 c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   /**
122   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123   */
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   /**
130   * @dev Adds two numbers, throws on overflow.
131   */
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
140 
141 /**
142  * @title ERC20Basic
143  * @dev Simpler version of ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/179
145  */
146 contract ERC20Basic {
147   function totalSupply() public view returns (uint256);
148   function balanceOf(address who) public view returns (uint256);
149   function transfer(address to, uint256 value) public returns (bool);
150   event Transfer(address indexed from, address indexed to, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   uint256 totalSupply_;
178 
179   /**
180   * @dev total number of tokens in existence
181   */
182   function totalSupply() public view returns (uint256) {
183     return totalSupply_;
184   }
185 
186   /**
187   * @dev transfer token for a specified address
188   * @param _to The address to transfer to.
189   * @param _value The amount to be transferred.
190   */
191   function transfer(address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[msg.sender]);
194 
195     // SafeMath.sub will throw if there is not enough balance.
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     Transfer(msg.sender, _to, _value);
199     return true;
200   }
201 
202   /**
203   * @dev Gets the balance of the specified address.
204   * @param _owner The address to query the the balance of.
205   * @return An uint256 representing the amount owned by the passed address.
206   */
207   function balanceOf(address _owner) public view returns (uint256 balance) {
208     return balances[_owner];
209   }
210 
211 }
212 
213 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 // File: contracts/BasketToken.sol
311 
312 library AddressArrayUtils {
313 
314     /// @return Returns index and ok of the first occurrence starting from index 0
315     function index(address[] addresses, address a) internal pure returns (uint, bool) {
316         for (uint i = 0; i < addresses.length; i++) {
317             if (addresses[i] == a) {
318                 return (i, true);
319             }
320         }
321         return (0, false);
322     }
323 
324 }
325 
326 
327 /// @title A decentralized Basket-like ERC20 which gives the owner a claim to the
328 /// underlying assets
329 /// @notice Basket Tokens are transferable, and can be created and redeemed by
330 /// anyone. To create, a user must approve the contract to move the underlying
331 /// tokens, then call `create()`.
332 /// @author Daniel Que and Quan Pham
333 contract BasketToken is StandardToken, Pausable {
334     using SafeMath for uint256;
335     using AddressArrayUtils for address[];
336 
337     string constant public name = "ERC20 TWENTY";
338     string constant public symbol = "ETW";
339     uint8 constant public decimals = 18;
340     struct TokenInfo {
341         address addr;
342         uint256 tokenUnits;
343     }
344     uint256 private creationQuantity_;
345     TokenInfo[] public tokens;
346 
347     event Mint(address indexed to, uint256 amount);
348     event Burn(address indexed from, uint256 amount);
349 
350     /// @notice Requires value to be divisible by creationQuantity
351     /// @param value Number to be checked
352     modifier requireMultiple(uint256 value) {
353         require((value % creationQuantity_) == 0);
354         _;
355     }
356 
357     /// @notice Requires value to be non-zero
358     /// @param value Number to be checked
359     modifier requireNonZero(uint256 value) {
360         require(value > 0);
361         _;
362     }
363 
364     /// @notice Initializes contract with a list of ERC20 token addresses and
365     /// corresponding minimum number of units required for a creation unit
366     /// @param addresses Addresses of the underlying ERC20 token contracts
367     /// @param tokenUnits Number of token base units required per creation unit
368     /// @param _creationQuantity Number of base units per creation unit
369     function BasketToken(
370         address[] addresses,
371         uint256[] tokenUnits,
372         uint256 _creationQuantity
373     ) public {
374         require(0 < addresses.length && addresses.length < 256);
375         require(addresses.length == tokenUnits.length);
376         require(_creationQuantity >= 1);
377 
378         creationQuantity_ = _creationQuantity;
379 
380         for (uint8 i = 0; i < addresses.length; i++) { // Using uint8 because we expect maximum of 256 underlying tokens
381             tokens.push(TokenInfo({
382                 addr: addresses[i],
383                 tokenUnits: tokenUnits[i]
384             }));
385         }
386     }
387 
388     /// @notice Returns the creationQuantity
389     /// @dev Creation quantity concept is similar but not identical to the one
390     /// described by EIP777
391     /// @return creationQuantity_ Creation quantity of the Basket token
392     function creationQuantity() external view returns(uint256) {
393         return creationQuantity_;
394     }
395 
396     /// @notice Creates Basket tokens in exchange for underlying tokens. Before
397     /// calling, underlying tokens must be approved to be moved by the Basket Token
398     /// contract. The number of approved tokens required depends on
399     /// baseUnits.
400     /// @dev If any underlying tokens' `transferFrom` fails (eg. the token is
401     /// frozen), create will no longer work. At this point a token upgrade will
402     /// be necessary.
403     /// @param baseUnits Number of base units to create. Must be a multiple of
404     /// creationQuantity.
405     function create(uint256 baseUnits)
406         external
407         whenNotPaused()
408         requireNonZero(baseUnits)
409         requireMultiple(baseUnits)
410     {
411         // Check overflow
412         require((totalSupply_ + baseUnits) > totalSupply_);
413 
414         for (uint8 i = 0; i < tokens.length; i++) {
415             TokenInfo memory tokenInfo = tokens[i];
416             ERC20 erc20 = ERC20(tokenInfo.addr);
417             uint256 amount = baseUnits.div(creationQuantity_).mul(tokenInfo.tokenUnits);
418             require(erc20.transferFrom(msg.sender, address(this), amount));
419         }
420 
421         mint(msg.sender, baseUnits);
422     }
423 
424     /// @notice Redeems Basket Token in return for underlying tokens
425     /// @param baseUnits Number of base units to redeem. Must be a multiple of
426     /// creationQuantity.
427     /// @param tokensToSkip Underlying token addresses to skip redemption for.
428     /// Intended to be used to skip frozen or broken tokens which would prevent
429     /// all underlying tokens from being withdrawn due to a revert. Skipped
430     /// tokens will be left in the Basket Token contract and will be unclaimable.
431     function redeem(uint256 baseUnits, address[] tokensToSkip)
432         external
433         whenNotPaused()
434         requireNonZero(baseUnits)
435         requireMultiple(baseUnits)
436     {
437         require((totalSupply_ >= baseUnits));
438         require((balances[msg.sender] >= baseUnits));
439         require(tokensToSkip.length <= tokens.length);
440 
441         // Burn before to prevent re-entrancy
442         burn(msg.sender, baseUnits);
443 
444         for (uint8 i = 0; i < tokens.length; i++) {
445             TokenInfo memory tokenInfo = tokens[i];
446             ERC20 erc20 = ERC20(tokenInfo.addr);
447             uint256 index;
448             bool ok;
449             (index, ok) = tokensToSkip.index(tokenInfo.addr);
450             if (ok) {
451                 continue;
452             }
453             uint256 amount = baseUnits.div(creationQuantity_).mul(tokenInfo.tokenUnits);
454             require(erc20.transfer(msg.sender, amount));
455         }
456     }
457 
458     /// @return tokenAddresses Underlying token addresses
459     function tokenAddresses() external view returns (address[]){
460         address[] memory tokenAddresses = new address[](tokens.length);
461         for (uint8 i = 0; i < tokens.length; i++) {
462             tokenAddresses[i] = tokens[i].addr;
463         }
464         return tokenAddresses;
465     }
466 
467     /// @return tokenUnits Number of token base units required per creation unit
468     function tokenUnits() external view returns (uint256[]){
469         uint256[] memory tokenUnits = new uint256[](tokens.length);
470         for (uint8 i = 0; i < tokens.length; i++) {
471             tokenUnits[i] = tokens[i].tokenUnits;
472         }
473         return tokenUnits;
474     }
475 
476     // @dev Mints new Basket tokens
477     // @param to
478     // @param amount
479     // @return ok
480     function mint(address to, uint256 amount) internal returns (bool) {
481         totalSupply_ = totalSupply_.add(amount);
482         balances[to] = balances[to].add(amount);
483         Mint(to, amount);
484         Transfer(address(0), to, amount);
485         return true;
486     }
487 
488     // @dev Burns Basket tokens
489     // @param from
490     // @param amount
491     // @return ok
492     function burn(address from, uint256 amount) internal returns (bool) {
493         totalSupply_ = totalSupply_.sub(amount);
494         balances[from] = balances[from].sub(amount);
495         Burn(from, amount);
496         Transfer(from, address(0), amount);
497         return true;
498     }
499 
500     // @notice Look up token info
501     // @param token Token address to look up
502     // @return (tokenUnits, ok) Units of underlying token, and whether the
503     // operation was successful
504     function getTokenUnits(address token) internal view returns (uint256, bool) {
505         for (uint8 i = 0; i < tokens.length; i++) {
506             if (tokens[i].addr == token) {
507                 return (tokens[i].tokenUnits, true);
508             }
509         }
510         return (0, false);
511     }
512 
513     /// @notice Owner: Withdraw excess funds which don't belong to Basket Token
514     /// holders
515     /// @param token ERC20 token address to withdraw
516     function withdrawExcessToken(address token)
517         external
518         onlyOwner
519     {
520         ERC20 erc20 = ERC20(token);
521         uint256 withdrawAmount;
522         uint256 amountOwned = erc20.balanceOf(address(this));
523         uint256 tokenUnits;
524         bool ok;
525         (tokenUnits, ok) = getTokenUnits(token);
526         if (ok) {
527             withdrawAmount = amountOwned.sub(totalSupply_.div(creationQuantity_).mul(tokenUnits));
528         } else {
529             withdrawAmount = amountOwned;
530         }
531         require(erc20.transfer(owner, withdrawAmount));
532     }
533 
534     /// @notice Owner: Withdraw Ether
535     function withdrawEther()
536         external
537         onlyOwner
538     {
539         owner.transfer(this.balance);
540     }
541 
542     /// @notice Fallback function
543     function() external payable {
544     }
545 
546 }