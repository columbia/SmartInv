1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title SafeERC20
55  * @dev Wrappers around ERC20 operations that throw on failure.
56  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
57  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
58  */
59 library SafeERC20 {
60   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
61     require(token.transfer(to, value));
62   }
63 
64   function safeTransferFrom(
65     ERC20 token,
66     address from,
67     address to,
68     uint256 value
69   )
70     internal
71   {
72     require(token.transferFrom(from, to, value));
73   }
74 
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     require(token.approve(spender, value));
77   }
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * See https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87   function totalSupply() public view returns (uint256);
88   function balanceOf(address who) public view returns (uint256);
89   function transfer(address to, uint256 value) public returns (bool);
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender)
99     public view returns (uint256);
100 
101   function transferFrom(address from, address to, uint256 value)
102     public returns (bool);
103 
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(
106     address indexed owner,
107     address indexed spender,
108     uint256 value
109   );
110 }
111 
112 /**
113  * @title Basic token
114  * @dev Basic version of StandardToken, with no allowances.
115  */
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[msg.sender]);
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * https://github.com/ethereum/EIPs/issues/20
161  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Function to check the amount of tokens that an owner allowed to a spender.
210    * @param _owner address The address which owns the funds.
211    * @param _spender address The address which will spend the funds.
212    * @return A uint256 specifying the amount of tokens still available for the spender.
213    */
214   function allowance(
215     address _owner,
216     address _spender
217    )
218     public
219     view
220     returns (uint256)
221   {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint256 _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint256 _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint256 oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273 }
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281   address public owner;
282 
283 
284   event OwnershipRenounced(address indexed previousOwner);
285   event OwnershipTransferred(
286     address indexed previousOwner,
287     address indexed newOwner
288   );
289 
290 
291   /**
292    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
293    * account.
294    */
295   constructor() public {
296     owner = msg.sender;
297   }
298 
299   /**
300    * @dev Throws if called by any account other than the owner.
301    */
302   modifier onlyOwner() {
303     require(msg.sender == owner);
304     _;
305   }
306 
307   /**
308    * @dev Allows the current owner to relinquish control of the contract.
309    * @notice Renouncing to ownership will leave the contract without an owner.
310    * It will not be possible to call the functions with the `onlyOwner`
311    * modifier anymore.
312    */
313   function renounceOwnership() public onlyOwner {
314     emit OwnershipRenounced(owner);
315     owner = address(0);
316   }
317 
318   /**
319    * @dev Allows the current owner to transfer control of the contract to a newOwner.
320    * @param _newOwner The address to transfer ownership to.
321    */
322   function transferOwnership(address _newOwner) public onlyOwner {
323     _transferOwnership(_newOwner);
324   }
325 
326   /**
327    * @dev Transfers control of the contract to a newOwner.
328    * @param _newOwner The address to transfer ownership to.
329    */
330   function _transferOwnership(address _newOwner) internal {
331     require(_newOwner != address(0));
332     emit OwnershipTransferred(owner, _newOwner);
333     owner = _newOwner;
334   }
335 }
336 
337 /**
338  * @title Mintable token
339  * @dev Simple ERC20 Token example, with mintable token creation
340  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
341  */
342 contract MintableToken is StandardToken, Ownable {
343   event Mint(address indexed to, uint256 amount);
344   event MintFinished();
345 
346   bool public mintingFinished = false;
347 
348 
349   modifier canMint() {
350     require(!mintingFinished);
351     _;
352   }
353 
354   modifier hasMintPermission() {
355     require(msg.sender == owner);
356     _;
357   }
358 
359   /**
360    * @dev Function to mint tokens
361    * @param _to The address that will receive the minted tokens.
362    * @param _amount The amount of tokens to mint.
363    * @return A boolean that indicates if the operation was successful.
364    */
365   function mint(
366     address _to,
367     uint256 _amount
368   )
369     hasMintPermission
370     canMint
371     public
372     returns (bool)
373   {
374     totalSupply_ = totalSupply_.add(_amount);
375     balances[_to] = balances[_to].add(_amount);
376     emit Mint(_to, _amount);
377     emit Transfer(address(0), _to, _amount);
378     return true;
379   }
380 
381   /**
382    * @dev Function to stop minting new tokens.
383    * @return True if the operation was successful.
384    */
385   function finishMinting() onlyOwner canMint public returns (bool) {
386     mintingFinished = true;
387     emit MintFinished();
388     return true;
389   }
390 }
391 
392 /**
393  * @title Burnable Token
394  * @dev Token that can be irreversibly burned (destroyed).
395  */
396 contract BurnableToken is BasicToken {
397 
398   event Burn(address indexed burner, uint256 value);
399 
400   /**
401    * @dev Burns a specific amount of tokens.
402    * @param _value The amount of token to be burned.
403    */
404   function burn(uint256 _value) public {
405     _burn(msg.sender, _value);
406   }
407 
408   function _burn(address _who, uint256 _value) internal {
409     require(_value <= balances[_who]);
410     // no need to require value <= totalSupply, since that would imply the
411     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
412 
413     balances[_who] = balances[_who].sub(_value);
414     totalSupply_ = totalSupply_.sub(_value);
415     emit Burn(_who, _value);
416     emit Transfer(_who, address(0), _value);
417   }
418 }
419 
420 /**
421  * @title Claimable
422  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
423  * This allows the new owner to accept the transfer.
424  */
425 contract Claimable is Ownable {
426   address public pendingOwner;
427 
428   /**
429    * @dev Modifier throws if called by any account other than the pendingOwner.
430    */
431   modifier onlyPendingOwner() {
432     require(msg.sender == pendingOwner);
433     _;
434   }
435 
436   /**
437    * @dev Allows the current owner to set the pendingOwner address.
438    * @param newOwner The address to transfer ownership to.
439    */
440   function transferOwnership(address newOwner) onlyOwner public {
441     pendingOwner = newOwner;
442   }
443 
444   /**
445    * @dev Allows the pendingOwner address to finalize the transfer.
446    */
447   function claimOwnership() onlyPendingOwner public {
448     emit OwnershipTransferred(owner, pendingOwner);
449     owner = pendingOwner;
450     pendingOwner = address(0);
451   }
452 }
453 
454 /**
455  * @title Contracts that should be able to recover tokens
456  * @author SylTi
457  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
458  * This will prevent any accidental loss of tokens.
459  */
460 contract CanReclaimToken is Ownable {
461   using SafeERC20 for ERC20Basic;
462 
463   /**
464    * @dev Reclaim all ERC20Basic compatible tokens
465    * @param token ERC20Basic The address of the token contract
466    */
467   function reclaimToken(ERC20Basic token) external onlyOwner {
468     uint256 balance = token.balanceOf(this);
469     token.safeTransfer(owner, balance);
470   }
471 
472 }
473 
474 contract ConferenceCoinToken is MintableToken, BurnableToken, Claimable, CanReclaimToken {
475   string public name = "ConferenceCoin";
476   string public symbol = "CC";
477   uint public decimals = 18;
478 }