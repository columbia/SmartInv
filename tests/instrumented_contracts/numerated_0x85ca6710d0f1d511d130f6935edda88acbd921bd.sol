1 pragma solidity 0.4.24;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6 
7     /// @dev Multiply two numbers, throw on overflow.
8     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         if (a == 0) {
10             return 0;
11         }
12         c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /// @dev Substract two numbers, throw on overflow (i.e. if subtrahend is greater than minuend).
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     /// @dev Add two numbers, throw on overflow.
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 /// @title Ownable
32 /// @dev Provide a modifier that permits only a single user to call the function
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /// @dev Set the original `owner` of the contract to the sender account.
39     constructor() public {
40         owner = msg.sender;
41     }
42 
43     /// @dev Require that the modified function is only called by `owner`
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     /// @dev Allow `owner` to transfer control of the contract to `newOwner`.
50     /// @param newOwner The address to transfer ownership to.
51     function transferOwnership(address newOwner) public onlyOwner {
52         require(newOwner != address(0));
53         emit OwnershipTransferred(owner, newOwner);
54         owner = newOwner;
55     }
56 
57 }
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 /**
91  * @title Contracts that should not own Ether
92  * @author Remco Bloemen <remco@2π.com>
93  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
94  * in the contract, it will allow the owner to reclaim this ether.
95  * @notice Ether can still be sent to this contract by:
96  * calling functions labeled `payable`
97  * `selfdestruct(contract_address)`
98  * mining directly to the contract address
99  */
100 contract HasNoEther is Ownable {
101 
102     /**
103     * @dev Constructor that rejects incoming Ether
104     * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
105     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
106     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
107     * we could use assembly to access msg.value.
108     */
109     constructor() public payable {
110         require(msg.value == 0);
111     }
112 
113     /**
114     * @dev Disallows direct send by settings a default function without the `payable` flag.
115     */
116     function() external {}
117 
118     /**
119     * @dev Transfer all Ether held by the contract to the owner.
120     */
121     function reclaimEther() external onlyOwner {
122         owner.transfer(address(this).balance);
123     }
124 }
125 
126 /**
127  * @title SafeERC20
128  * @dev Wrappers around ERC20 operations that throw on failure.
129  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
130  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
131  */
132 library SafeERC20 {
133   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
134     require(token.transfer(to, value));
135   }
136 
137   function safeTransferFrom(
138     ERC20 token,
139     address from,
140     address to,
141     uint256 value
142   )
143     internal
144   {
145     require(token.transferFrom(from, to, value));
146   }
147 
148   function safeApprove(ERC20 token, address spender, uint256 value) internal {
149     require(token.approve(spender, value));
150   }
151 }
152 
153 /**
154  * @title Contracts that should be able to recover tokens
155  * @author SylTi
156  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
157  * This will prevent any accidental loss of tokens.
158  */
159 contract CanReclaimToken is Ownable {
160   using SafeERC20 for ERC20Basic;
161 
162   /**
163    * @dev Reclaim all ERC20Basic compatible tokens
164    * @param token ERC20Basic The address of the token contract
165    */
166   function reclaimToken(ERC20Basic token) external onlyOwner {
167     uint256 balance = token.balanceOf(this);
168     token.safeTransfer(owner, balance);
169   }
170 
171 }
172 
173 /**
174  * @title Contracts that should not own Tokens
175  * @author Remco Bloemen <remco@2π.com>
176  * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.
177  * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the
178  * owner to reclaim the tokens.
179  */
180 contract HasNoTokens is CanReclaimToken {
181 
182  /**
183   * @dev Reject all ERC223 compatible tokens
184   * @param from_ address The address that is transferring the tokens
185   * @param value_ uint256 the amount of the specified token
186   * @param data_ Bytes The data passed from the caller.
187   */
188   function tokenFallback(address from_, uint256 value_, bytes data_) external {
189     from_;
190     value_;
191     data_;
192     revert();
193   }
194 
195 }
196 
197 /**
198  * @title Contracts that should not own Contracts
199  * @author Remco Bloemen <remco@2π.com>
200  * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner
201  * of this contract to reclaim ownership of the contracts.
202  */
203 contract HasNoContracts is Ownable {
204 
205     /**
206     * @dev Reclaim ownership of Ownable contracts
207     * @param contractAddr The address of the Ownable to be reclaimed.
208     */
209     function reclaimContract(address contractAddr) external onlyOwner {
210         Ownable contractInst = Ownable(contractAddr);
211         contractInst.transferOwnership(owner);
212     }
213 }
214 
215 /**
216  * @title Base contract for contracts that should not own things.
217  * @author Remco Bloemen <remco@2π.com>
218  * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or
219  * Owned contracts. See respective base contracts for details.
220  */
221 contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {
222 }
223 
224 /**
225  * @title Basic token
226  * @dev Basic version of StandardToken, with no allowances.
227  */
228 contract BasicToken is ERC20Basic {
229   using SafeMath for uint256;
230 
231   mapping(address => uint256) balances;
232 
233   uint256 totalSupply_;
234 
235   /**
236   * @dev total number of tokens in existence
237   */
238   function totalSupply() public view returns (uint256) {
239     return totalSupply_;
240   }
241 
242   /**
243   * @dev transfer token for a specified address
244   * @param _to The address to transfer to.
245   * @param _value The amount to be transferred.
246   */
247   function transfer(address _to, uint256 _value) public returns (bool) {
248     require(_to != address(0));
249     require(_value <= balances[msg.sender]);
250 
251     balances[msg.sender] = balances[msg.sender].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     emit Transfer(msg.sender, _to, _value);
254     return true;
255   }
256 
257   /**
258   * @dev Gets the balance of the specified address.
259   * @param _owner The address to query the the balance of.
260   * @return An uint256 representing the amount owned by the passed address.
261   */
262   function balanceOf(address _owner) public view returns (uint256) {
263     return balances[_owner];
264   }
265 
266 }
267 
268 /**
269  * @title Standard ERC20 token
270  *
271  * @dev Implementation of the basic standard token.
272  * @dev https://github.com/ethereum/EIPs/issues/20
273  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
274  */
275 contract StandardToken is ERC20, BasicToken {
276 
277   mapping (address => mapping (address => uint256)) internal allowed;
278 
279 
280   /**
281    * @dev Transfer tokens from one address to another
282    * @param _from address The address which you want to send tokens from
283    * @param _to address The address which you want to transfer to
284    * @param _value uint256 the amount of tokens to be transferred
285    */
286   function transferFrom(
287     address _from,
288     address _to,
289     uint256 _value
290   )
291     public
292     returns (bool)
293   {
294     require(_to != address(0));
295     require(_value <= balances[_from]);
296     require(_value <= allowed[_from][msg.sender]);
297 
298     balances[_from] = balances[_from].sub(_value);
299     balances[_to] = balances[_to].add(_value);
300     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
301     emit Transfer(_from, _to, _value);
302     return true;
303   }
304 
305   /**
306    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
307    *
308    * Beware that changing an allowance with this method brings the risk that someone may use both the old
309    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
310    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
311    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312    * @param _spender The address which will spend the funds.
313    * @param _value The amount of tokens to be spent.
314    */
315   function approve(address _spender, uint256 _value) public returns (bool) {
316     allowed[msg.sender][_spender] = _value;
317     emit Approval(msg.sender, _spender, _value);
318     return true;
319   }
320 
321   /**
322    * @dev Function to check the amount of tokens that an owner allowed to a spender.
323    * @param _owner address The address which owns the funds.
324    * @param _spender address The address which will spend the funds.
325    * @return A uint256 specifying the amount of tokens still available for the spender.
326    */
327   function allowance(
328     address _owner,
329     address _spender
330    )
331     public
332     view
333     returns (uint256)
334   {
335     return allowed[_owner][_spender];
336   }
337 
338   /**
339    * @dev Increase the amount of tokens that an owner allowed to a spender.
340    *
341    * approve should be called when allowed[_spender] == 0. To increment
342    * allowed value is better to use this function to avoid 2 calls (and wait until
343    * the first transaction is mined)
344    * From MonolithDAO Token.sol
345    * @param _spender The address which will spend the funds.
346    * @param _addedValue The amount of tokens to increase the allowance by.
347    */
348   function increaseApproval(
349     address _spender,
350     uint _addedValue
351   )
352     public
353     returns (bool)
354   {
355     allowed[msg.sender][_spender] = (
356       allowed[msg.sender][_spender].add(_addedValue));
357     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
358     return true;
359   }
360 
361   /**
362    * @dev Decrease the amount of tokens that an owner allowed to a spender.
363    *
364    * approve should be called when allowed[_spender] == 0. To decrement
365    * allowed value is better to use this function to avoid 2 calls (and wait until
366    * the first transaction is mined)
367    * From MonolithDAO Token.sol
368    * @param _spender The address which will spend the funds.
369    * @param _subtractedValue The amount of tokens to decrease the allowance by.
370    */
371   function decreaseApproval(
372     address _spender,
373     uint _subtractedValue
374   )
375     public
376     returns (bool)
377   {
378     uint oldValue = allowed[msg.sender][_spender];
379     if (_subtractedValue > oldValue) {
380       allowed[msg.sender][_spender] = 0;
381     } else {
382       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
383     }
384     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
385     return true;
386   }
387 
388 }
389 
390 /// @title Lockable token with exceptions
391 /// @dev StandardToken modified with pausable transfers.
392 contract LockableToken is Ownable, StandardToken {
393 
394     /// Flag for locking normal trading
395     bool public locked = true;
396 
397     /// Addresses exempted from token trade lock
398     mapping(address => bool) public lockExceptions;
399 
400     constructor() public {
401         // It should always be possible to call reclaimToken
402         lockExceptions[this] = true;
403     }
404 
405     /// @notice Admin function to lock trading
406     function lock() public onlyOwner {
407         locked = true;
408     }
409 
410     /// @notice Admin function to unlock trading
411     function unlock() public onlyOwner {
412         locked = false;
413     }
414 
415     /// @notice Set whether `sender` may trade when token is locked
416     /// @param sender The address to change the lock exception for
417     /// @param _canTrade Whether `sender` may trade
418     function setTradeException(address sender, bool _canTrade) public onlyOwner {
419         lockExceptions[sender] = _canTrade;
420     }
421 
422     /// @notice Check if the token is currently tradable for `sender`
423     /// @param sender The address attempting to make a transfer
424     /// @return True if `sender` is allowed to make transfers, false otherwise
425     function canTrade(address sender) public view returns(bool) {
426         return !locked || lockExceptions[sender];
427     }
428 
429     /// @dev Modifier to make a function callable only when the contract is not paused.
430     modifier whenNotLocked() {
431         require(canTrade(msg.sender));
432         _;
433     }
434 
435     function transfer(address _to, uint256 _value)
436                 public whenNotLocked returns (bool) {
437 
438         return super.transfer(_to, _value);
439     }
440 
441     function transferFrom(address _from, address _to, uint256 _value)
442                 public whenNotLocked returns (bool) {
443 
444         return super.transferFrom(_from, _to, _value);
445     }
446 
447     function approve(address _spender, uint256 _value)
448                 public whenNotLocked returns (bool) {
449 
450         return super.approve(_spender, _value);
451     }
452 
453     function increaseApproval(address _spender, uint _addedValue)
454                 public whenNotLocked returns (bool success) {
455 
456         return super.increaseApproval(_spender, _addedValue);
457     }
458 
459     function decreaseApproval(address _spender, uint _subtractedValue)
460                 public whenNotLocked returns (bool success) {
461                         
462         return super.decreaseApproval(_spender, _subtractedValue);
463     }
464 }
465 
466 /// @title Pledgecamp Token (PLG)
467 /// @author Sam Pullman
468 /// @notice ERC20 compatible token for the Pledgecamp platform
469 contract PLGToken is Ownable, NoOwner, LockableToken {
470     using SafeMath for uint256;
471     
472     /// @notice Emitted when tokens are burned
473     /// @param burner Account that burned its tokens
474     /// @param value Number of tokens burned
475     event Burn(address indexed burner, uint256 value);
476 
477     string public name = "PLGToken";
478     string public symbol = "PLG";
479     uint8 public decimals = 18;
480 
481     /// Flag for only allowing a single token initialization
482     bool public initialized = false;
483 
484     /// @notice Set initial PLG allocations, which can only happen once
485     /// @param addresses Addresses of beneficiaries
486     /// @param allocations Amounts to allocate each beneficiary
487     function initialize(address[] addresses, uint256[] allocations) public onlyOwner {
488         require(!initialized);
489         require(addresses.length == allocations.length);
490         initialized = true;
491 
492         for(uint i = 0; i<allocations.length; i += 1) {
493             require(addresses[i] != address(0));
494             require(allocations[i] > 0);
495             balances[addresses[i]] = allocations[i];
496             totalSupply_ = totalSupply_.add(allocations[i]);
497         }
498     }
499 
500     /// @dev Burns a specific amount of tokens owned by the sender
501     /// @param value The number of tokens to be burned
502     function burn(uint256 value) public {
503         require(value <= balances[msg.sender]);
504 
505         balances[msg.sender] = balances[msg.sender].sub(value);
506         totalSupply_ = totalSupply_.sub(value);
507         emit Burn(msg.sender, value);
508         emit Transfer(msg.sender, address(0), value);
509     }
510 
511 }