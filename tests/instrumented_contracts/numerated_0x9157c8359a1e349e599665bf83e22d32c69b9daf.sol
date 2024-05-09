1 pragma solidity 0.4.24;
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
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/ownership/HasNoEther.sol
65 
66 /**
67  * @title Contracts that should not own Ether
68  * @author Remco Bloemen <remco@2π.com>
69  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
70  * in the contract, it will allow the owner to reclaim this ether.
71  * @notice Ether can still be sent to this contract by:
72  * calling functions labeled `payable`
73  * `selfdestruct(contract_address)`
74  * mining directly to the contract address
75  */
76 contract HasNoEther is Ownable {
77 
78   /**
79   * @dev Constructor that rejects incoming Ether
80   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
81   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
82   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
83   * we could use assembly to access msg.value.
84   */
85   constructor() public payable {
86     require(msg.value == 0);
87   }
88 
89   /**
90    * @dev Disallows direct send by settings a default function without the `payable` flag.
91    */
92   function() external {
93   }
94 
95   /**
96    * @dev Transfer all Ether held by the contract to the owner.
97    */
98   function reclaimEther() external onlyOwner {
99     owner.transfer(address(this).balance);
100   }
101 }
102 
103 // File: zeppelin-solidity/contracts/ownership/Claimable.sol
104 
105 /**
106  * @title Claimable
107  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
108  * This allows the new owner to accept the transfer.
109  */
110 contract Claimable is Ownable {
111   address public pendingOwner;
112 
113   /**
114    * @dev Modifier throws if called by any account other than the pendingOwner.
115    */
116   modifier onlyPendingOwner() {
117     require(msg.sender == pendingOwner);
118     _;
119   }
120 
121   /**
122    * @dev Allows the current owner to set the pendingOwner address.
123    * @param newOwner The address to transfer ownership to.
124    */
125   function transferOwnership(address newOwner) onlyOwner public {
126     pendingOwner = newOwner;
127   }
128 
129   /**
130    * @dev Allows the pendingOwner address to finalize the transfer.
131    */
132   function claimOwnership() onlyPendingOwner public {
133     emit OwnershipTransferred(owner, pendingOwner);
134     owner = pendingOwner;
135     pendingOwner = address(0);
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
153 // File: zeppelin-solidity/contracts/math/SafeMath.sol
154 
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that throw on error
158  */
159 library SafeMath {
160 
161   /**
162   * @dev Multiplies two numbers, throws on overflow.
163   */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
166     // benefit is lost if 'b' is also tested.
167     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
168     if (a == 0) {
169       return 0;
170     }
171 
172     c = a * b;
173     assert(c / a == b);
174     return c;
175   }
176 
177   /**
178   * @dev Integer division of two numbers, truncating the quotient.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     // uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return a / b;
185   }
186 
187   /**
188   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     assert(b <= a);
192     return a - b;
193   }
194 
195   /**
196   * @dev Adds two numbers, throws on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
199     c = a + b;
200     assert(c >= a);
201     return c;
202   }
203 }
204 
205 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
206 
207 /**
208  * @title Basic token
209  * @dev Basic version of StandardToken, with no allowances.
210  */
211 contract BasicToken is ERC20Basic {
212   using SafeMath for uint256;
213 
214   mapping(address => uint256) balances;
215 
216   uint256 totalSupply_;
217 
218   /**
219   * @dev total number of tokens in existence
220   */
221   function totalSupply() public view returns (uint256) {
222     return totalSupply_;
223   }
224 
225   /**
226   * @dev transfer token for a specified address
227   * @param _to The address to transfer to.
228   * @param _value The amount to be transferred.
229   */
230   function transfer(address _to, uint256 _value) public returns (bool) {
231     require(_to != address(0));
232     require(_value <= balances[msg.sender]);
233 
234     balances[msg.sender] = balances[msg.sender].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     emit Transfer(msg.sender, _to, _value);
237     return true;
238   }
239 
240   /**
241   * @dev Gets the balance of the specified address.
242   * @param _owner The address to query the the balance of.
243   * @return An uint256 representing the amount owned by the passed address.
244   */
245   function balanceOf(address _owner) public view returns (uint256) {
246     return balances[_owner];
247   }
248 
249 }
250 
251 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
252 
253 /**
254  * @title ERC20 interface
255  * @dev see https://github.com/ethereum/EIPs/issues/20
256  */
257 contract ERC20 is ERC20Basic {
258   function allowance(address owner, address spender)
259     public view returns (uint256);
260 
261   function transferFrom(address from, address to, uint256 value)
262     public returns (bool);
263 
264   function approve(address spender, uint256 value) public returns (bool);
265   event Approval(
266     address indexed owner,
267     address indexed spender,
268     uint256 value
269   );
270 }
271 
272 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
273 
274 /**
275  * @title Standard ERC20 token
276  *
277  * @dev Implementation of the basic standard token.
278  * @dev https://github.com/ethereum/EIPs/issues/20
279  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
280  */
281 contract StandardToken is ERC20, BasicToken {
282 
283   mapping (address => mapping (address => uint256)) internal allowed;
284 
285 
286   /**
287    * @dev Transfer tokens from one address to another
288    * @param _from address The address which you want to send tokens from
289    * @param _to address The address which you want to transfer to
290    * @param _value uint256 the amount of tokens to be transferred
291    */
292   function transferFrom(
293     address _from,
294     address _to,
295     uint256 _value
296   )
297     public
298     returns (bool)
299   {
300     require(_to != address(0));
301     require(_value <= balances[_from]);
302     require(_value <= allowed[_from][msg.sender]);
303 
304     balances[_from] = balances[_from].sub(_value);
305     balances[_to] = balances[_to].add(_value);
306     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
307     emit Transfer(_from, _to, _value);
308     return true;
309   }
310 
311   /**
312    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
313    *
314    * Beware that changing an allowance with this method brings the risk that someone may use both the old
315    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
316    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
317    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
318    * @param _spender The address which will spend the funds.
319    * @param _value The amount of tokens to be spent.
320    */
321   function approve(address _spender, uint256 _value) public returns (bool) {
322     allowed[msg.sender][_spender] = _value;
323     emit Approval(msg.sender, _spender, _value);
324     return true;
325   }
326 
327   /**
328    * @dev Function to check the amount of tokens that an owner allowed to a spender.
329    * @param _owner address The address which owns the funds.
330    * @param _spender address The address which will spend the funds.
331    * @return A uint256 specifying the amount of tokens still available for the spender.
332    */
333   function allowance(
334     address _owner,
335     address _spender
336    )
337     public
338     view
339     returns (uint256)
340   {
341     return allowed[_owner][_spender];
342   }
343 
344   /**
345    * @dev Increase the amount of tokens that an owner allowed to a spender.
346    *
347    * approve should be called when allowed[_spender] == 0. To increment
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param _spender The address which will spend the funds.
352    * @param _addedValue The amount of tokens to increase the allowance by.
353    */
354   function increaseApproval(
355     address _spender,
356     uint _addedValue
357   )
358     public
359     returns (bool)
360   {
361     allowed[msg.sender][_spender] = (
362       allowed[msg.sender][_spender].add(_addedValue));
363     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
364     return true;
365   }
366 
367   /**
368    * @dev Decrease the amount of tokens that an owner allowed to a spender.
369    *
370    * approve should be called when allowed[_spender] == 0. To decrement
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _subtractedValue The amount of tokens to decrease the allowance by.
376    */
377   function decreaseApproval(
378     address _spender,
379     uint _subtractedValue
380   )
381     public
382     returns (bool)
383   {
384     uint oldValue = allowed[msg.sender][_spender];
385     if (_subtractedValue > oldValue) {
386       allowed[msg.sender][_spender] = 0;
387     } else {
388       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
389     }
390     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
391     return true;
392   }
393 
394 }
395 
396 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
397 
398 /**
399  * @title Mintable token
400  * @dev Simple ERC20 Token example, with mintable token creation
401  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
402  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
403  */
404 contract MintableToken is StandardToken, Ownable {
405   event Mint(address indexed to, uint256 amount);
406   event MintFinished();
407 
408   bool public mintingFinished = false;
409 
410 
411   modifier canMint() {
412     require(!mintingFinished);
413     _;
414   }
415 
416   modifier hasMintPermission() {
417     require(msg.sender == owner);
418     _;
419   }
420 
421   /**
422    * @dev Function to mint tokens
423    * @param _to The address that will receive the minted tokens.
424    * @param _amount The amount of tokens to mint.
425    * @return A boolean that indicates if the operation was successful.
426    */
427   function mint(
428     address _to,
429     uint256 _amount
430   )
431     hasMintPermission
432     canMint
433     public
434     returns (bool)
435   {
436     totalSupply_ = totalSupply_.add(_amount);
437     balances[_to] = balances[_to].add(_amount);
438     emit Mint(_to, _amount);
439     emit Transfer(address(0), _to, _amount);
440     return true;
441   }
442 
443   /**
444    * @dev Function to stop minting new tokens.
445    * @return True if the operation was successful.
446    */
447   function finishMinting() onlyOwner canMint public returns (bool) {
448     mintingFinished = true;
449     emit MintFinished();
450     return true;
451   }
452 }
453 
454 // File: contracts/CotiDime.sol
455 
456 /// @title COTI-DIME token for COTI-ZERO platform
457 contract CotiDime is HasNoEther, Claimable, MintableToken {
458     string public constant name = "COTI-DIME";
459     string public constant symbol = "CPS";
460     uint8 public constant decimals = 18;
461 
462     // This modifier will be used to disable ERC20 transfer functionalities during the minting process.
463     modifier isTransferable() {
464         require(mintingFinished, "Minting hasn't finished yet");
465         _;
466     }
467 
468     /// @dev Transfer token for a specified address
469     /// @param _to address The address to transfer to.
470     /// @param _value uint256 The amount to be transferred.
471     /// @return Calling super.transfer and returns true if successful.
472     function transfer(address _to, uint256 _value) public isTransferable returns (bool) {
473         return super.transfer(_to, _value);
474     }
475 
476     /// @dev Transfer tokens from one address to another.
477     /// @param _from address The address which you want to send tokens from.
478     /// @param _to address The address which you want to transfer to.
479     /// @param _value uint256 The amount of tokens to be transferred.
480     /// @return Calling super.transferFrom and returns true if successful.
481     function transferFrom(address _from, address _to, uint256 _value) public isTransferable returns (bool) {
482         return super.transferFrom(_from, _to, _value);
483     }
484 }